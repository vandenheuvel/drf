# sf1 dataset

# repro
set.seed(1)

# libs
require(drf)

# param
USE.RES <- TRUE

# source
source("./helpers.R")

# load the data
d <- loadMTRdata(path = "../../data/mtr-datasets/downloaded_data/", dataset.name = "sf1")

if (USE.RES) {
  res <- ResRF(X = d$X, Y = d$Y)
  Y <- res$residuals
} else {
  Y <- d$Y
}

# hyper-param selection 
res_hyper_param <- hyperParamSelection(Y=Y, X.knn = d$X.knn, X.gauss = d$X.gauss, k = 2)

# best parameters
selected.k <- c(5, 10, 20, sqrt(nrow(d$X.knn)), nrow(d$X.knn))[which.min(lapply(res_hyper_param$knn, function(res) mean(res)))]
selected.sigma <- c(0.1, 0.5, 1, 2, 10)[which.min(lapply(res_hyper_param$gauss, function(res) mean(res)))]

# run pinball analysis (l)
res_pinball <- runRandomPinballAnalysis(param.knn = selected.k, param.gauss = selected.sigma, k = 2, alpha_seq = 0.9,
                                        X=d$X, Y=Y, X.knn = d$X.knn, X.gauss = d$X.gauss, 
                                        num_features = 10, nb_random_directions = 100)

# save results 
save(d, res_pinball, selected.k, selected.sigma, file = "../../data/mtr-datasets/computed
     _data/sf1.Rdata")
