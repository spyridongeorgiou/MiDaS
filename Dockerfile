# enables cuda support in docker
#FROM nvidia/cuda:10.2-cudnn7-runtime-ubuntu18.04
FROM nvidia/cuda:12.0.1-cudnn8-runtime-ubuntu18.04
# install python 3.6, pip and requirements for opencv-python 
# (see https://github.com/NVIDIA/nvidia-docker/issues/864)
RUN apt-get update && apt-get -y install \
    python3 \
    python3-pip \
    libsm6 \
    libxext6 \
    libxrender-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# install python dependencies
RUN pip3 install --upgrade pip
RUN pip3 install torch~=1.8 torchvision opencv-python-headless~=3.4 timm
RUN pip3 install imutils
#RUN pip3 install opencv-python

# copy inference code
WORKDIR /opt/MiDaS
COPY ./midas ./midas
COPY ./*.py ./
COPY ./weights ./weights
  
# download model weights so the docker image can be used offline
#RUN cd weights && {curl -OL https://github.com/isl-org/MiDaS/releases/download/v3/dpt_hybrid_384.pt; cd -; }
RUN cd weights && {curl -OL https://github.com/isl-org/MiDaS/releases/download/v3/dpt_beit_large_512.pt; cd -; }
#RUN python3 run.py --model_type dpt_hybrid; exit 0
#RUN python3 run.py --model_type dpt_beit_large_512; exit 0
RUN apt-get update && apt-get -y install \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    v4l-utils \
    && rm -rf /var/lib/apt/lists/*
#RUN ls /dev/video*
# entrypoint (dont forget to mount input and output directories)
#CMD python3 run.py --model_type dpt_hybrid
#CMD python3 run.py --model_type dpt_beit_large_512 --side
#CMD ["python3", "run.py", "--model_type", "dpt_beit_large_512"]
