Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BA01F959
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C53BC433C8;
	Tue,  1 Aug 2023 09:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882530;
	bh=68PcJ7ZoclRljHIeHJUXCiJ23NX4zi2Ose7r/qtxYSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pk2rN5TdOKggV6czhjC+3q0xTg92+6wtv6kIktP4Qg4FtJ/8nR2SG/TN3OKjoign/
	 aKrq6uGpFIyP9PJ4l+HdFZfcjnIZiGw16pyJl+Xo9ZKzdBQs5a+di4XfWcc4LMso5F
	 aOUCY/a9xg3SkJd9hNgEE6i500QhQPWzn6juQaDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/228] drm/msm: Switch idr_lock to spinlock
Date: Tue,  1 Aug 2023 11:19:56 +0200
Message-ID: <20230801091927.833625330@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit e4f020c6a05db73eac49b7c3b3650251be374200 ]

Needed to idr_preload() which returns with preemption disabled.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/527846/
Link: https://lore.kernel.org/r/20230320144356.803762-11-robdclark@gmail.com
Stable-dep-of: 1b5d0ddcb34a ("drm/msm: Disallow submit with fence id 0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c         |  6 ++----
 drivers/gpu/drm/msm/msm_gem_submit.c  | 10 +++++-----
 drivers/gpu/drm/msm/msm_gpu.h         |  2 +-
 drivers/gpu/drm/msm/msm_submitqueue.c |  2 +-
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index ac3d1d492a48c..f982a827be7ca 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -932,13 +932,11 @@ static int wait_fence(struct msm_gpu_submitqueue *queue, uint32_t fence_id,
 	 * retired, so if the fence is not found it means there is nothing
 	 * to wait for
 	 */
-	ret = mutex_lock_interruptible(&queue->idr_lock);
-	if (ret)
-		return ret;
+	spin_lock(&queue->idr_lock);
 	fence = idr_find(&queue->fence_idr, fence_id);
 	if (fence)
 		fence = dma_fence_get_rcu(fence);
-	mutex_unlock(&queue->idr_lock);
+	spin_unlock(&queue->idr_lock);
 
 	if (!fence)
 		return 0;
diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index d6162561141c5..5668860f01827 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -72,9 +72,9 @@ void __msm_gem_submit_destroy(struct kref *kref)
 	unsigned i;
 
 	if (submit->fence_id) {
-		mutex_lock(&submit->queue->idr_lock);
+		spin_lock(&submit->queue->idr_lock);
 		idr_remove(&submit->queue->fence_idr, submit->fence_id);
-		mutex_unlock(&submit->queue->idr_lock);
+		spin_unlock(&submit->queue->idr_lock);
 	}
 
 	dma_fence_put(submit->user_fence);
@@ -866,7 +866,7 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 
 	submit->nr_cmds = i;
 
-	mutex_lock(&queue->idr_lock);
+	spin_lock(&queue->idr_lock);
 
 	/*
 	 * If using userspace provided seqno fence, validate that the id
@@ -876,7 +876,7 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 	 */
 	if ((args->flags & MSM_SUBMIT_FENCE_SN_IN) &&
 			idr_find(&queue->fence_idr, args->fence)) {
-		mutex_unlock(&queue->idr_lock);
+		spin_unlock(&queue->idr_lock);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -910,7 +910,7 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 						    INT_MAX, GFP_KERNEL);
 	}
 
-	mutex_unlock(&queue->idr_lock);
+	spin_unlock(&queue->idr_lock);
 
 	if (submit->fence_id < 0) {
 		ret = submit->fence_id;
diff --git a/drivers/gpu/drm/msm/msm_gpu.h b/drivers/gpu/drm/msm/msm_gpu.h
index 732295e256834..b39cd332751dc 100644
--- a/drivers/gpu/drm/msm/msm_gpu.h
+++ b/drivers/gpu/drm/msm/msm_gpu.h
@@ -500,7 +500,7 @@ struct msm_gpu_submitqueue {
 	struct msm_file_private *ctx;
 	struct list_head node;
 	struct idr fence_idr;
-	struct mutex idr_lock;
+	struct spinlock idr_lock;
 	struct mutex lock;
 	struct kref ref;
 	struct drm_sched_entity *entity;
diff --git a/drivers/gpu/drm/msm/msm_submitqueue.c b/drivers/gpu/drm/msm/msm_submitqueue.c
index c6929e205b511..0e803125a325a 100644
--- a/drivers/gpu/drm/msm/msm_submitqueue.c
+++ b/drivers/gpu/drm/msm/msm_submitqueue.c
@@ -200,7 +200,7 @@ int msm_submitqueue_create(struct drm_device *drm, struct msm_file_private *ctx,
 		*id = queue->id;
 
 	idr_init(&queue->fence_idr);
-	mutex_init(&queue->idr_lock);
+	spin_lock_init(&queue->idr_lock);
 	mutex_init(&queue->lock);
 
 	list_add_tail(&queue->node, &ctx->submitqueues);
-- 
2.40.1



