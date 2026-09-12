Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49DE2F617C;
	Sat, 12 Sep 2026 11:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214359; cv=none; b=MgD/1VYxMbrUlk6n+w+vFDeXYeyQ6BefEUIDsgtYZXEMNjRkDCRJ6J5A9XwVuGNItFHQhSR0CUKH1pdLA1zVDYnh2JuCjqdq3LPRqfnuS4e5dvfSLU8f0B44GZPeL3crADm1yY9WU2ta67X3SuQF+GQ4LQx1plLKh4W8HMw7ftk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214359; c=relaxed/simple;
	bh=HiFwnlNzOt1RgrTZV4Ptzsoeh+N59HWvzS5MT2Z6zCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BDvOxaDHgpaOJdsw9paDNs2MRvvRZb24M11HNsDWbM9gE5zEt5CF3/l8+iS47TsUk+hlq+JOI8o3B8+43N7iIT4O+G2ZBru9iX8Fs6s0Z/p96selTs6nFZYpsNJU9Sv7+3/HDV9Wa6UrS1+c0aLzzwN2mieCoQ6lMyECV8V4yLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbyQ7LZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbyQ7LZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2641F000FF;
	Sat, 12 Sep 2026 11:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214357;
	bh=wMn5HeXn6O9yhRW9CscL/445NlH8vY1YMvcTvWka8aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FbyQ7LZci8G1FGc8UXq8EK7G24Iq5+xmPgjptjaQd24Xfbn9tGed8gSAQg0rdgoe6
	 ZPHB62fkkKFI10tcHA8ZBRYIm2nMucTplLzXyow5C9nyJdFXZFzeYuaqJ51vWbvhIG
	 S3HKo+J9UefG7SI+UovyIzO/qRtL3OJsnukLomKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0310/1376] drm/v3d: Replace a global spinlock with a per-queue spinlock
Date: Sat, 12 Sep 2026 08:45:36 +0200
Message-ID: <20260912065614.459092847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit e9d8e027483267a9505f5b6b7f0476b5299743af ]

Each V3D queue works independently and all the dependencies between the
jobs are handled through the DRM scheduler. Therefore, there is no need
to use one single lock for all queues. Using it, creates unnecessary
contention between different queues that can operate independently.

Replace the global spinlock with per-queue locks to improve parallelism
and reduce contention between different V3D queues (BIN, RENDER, TFU,
CSD). This allows independent queues to operate concurrently while
maintaining proper synchronization within each queue.

Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Link: https://lore.kernel.org/r/20250826-v3d-queue-lock-v3-3-979efc43e490@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Stable-dep-of: 25a166990751 ("drm/v3d: Clear queue->active_job when v3d_fence_create() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_drv.h   |  8 ++------
 drivers/gpu/drm/v3d/v3d_fence.c | 11 ++++++-----
 drivers/gpu/drm/v3d/v3d_gem.c   |  3 ++-
 drivers/gpu/drm/v3d/v3d_irq.c   |  6 +++---
 drivers/gpu/drm/v3d/v3d_sched.c | 13 +++++++------
 5 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
index b6e11968fba47..a15a17a4dbc6e 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -62,6 +62,7 @@ struct v3d_queue_state {
 
 	/* Currently active job for this queue */
 	struct v3d_job *active_job;
+	spinlock_t queue_lock;
 };
 
 /* Performance monitor object. The perform lifetime is controlled by userspace
@@ -154,11 +155,6 @@ struct v3d_dev {
 
 	struct v3d_queue_state queue[V3D_MAX_QUEUES];
 
-	/* Spinlock used to synchronize the overflow memory
-	 * management against bin job submission.
-	 */
-	spinlock_t job_lock;
-
 	/* Used to track the active perfmon if any. */
 	struct v3d_perfmon *active_perfmon;
 
@@ -532,7 +528,7 @@ void v3d_get_stats(const struct v3d_stats *stats, u64 timestamp,
 
 /* v3d_fence.c */
 extern const struct dma_fence_ops v3d_fence_ops;
-struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_queue queue);
+struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_queue q);
 
 /* v3d_gem.c */
 int v3d_gem_init(struct drm_device *dev);
diff --git a/drivers/gpu/drm/v3d/v3d_fence.c b/drivers/gpu/drm/v3d/v3d_fence.c
index 89840ed212c06..8f8471adae34a 100644
--- a/drivers/gpu/drm/v3d/v3d_fence.c
+++ b/drivers/gpu/drm/v3d/v3d_fence.c
@@ -3,8 +3,9 @@
 
 #include "v3d_drv.h"
 
-struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_queue queue)
+struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_queue q)
 {
+	struct v3d_queue_state *queue = &v3d->queue[q];
 	struct v3d_fence *fence;
 
 	fence = kzalloc(sizeof(*fence), GFP_KERNEL);
@@ -12,10 +13,10 @@ struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_queue queue)
 		return ERR_PTR(-ENOMEM);
 
 	fence->dev = &v3d->drm;
-	fence->queue = queue;
-	fence->seqno = ++v3d->queue[queue].emit_seqno;
-	dma_fence_init(&fence->base, &v3d_fence_ops, &v3d->job_lock,
-		       v3d->queue[queue].fence_context, fence->seqno);
+	fence->queue = q;
+	fence->seqno = ++queue->emit_seqno;
+	dma_fence_init(&fence->base, &v3d_fence_ops, &queue->queue_lock,
+		       queue->fence_context, fence->seqno);
 
 	return &fence->base;
 }
diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
index cf3b93101429c..175304977daf3 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -254,10 +254,11 @@ v3d_gem_init(struct drm_device *dev)
 		queue->fence_context = dma_fence_context_alloc(1);
 		memset(&queue->stats, 0, sizeof(queue->stats));
 		seqcount_init(&queue->stats.lock);
+
+		spin_lock_init(&queue->queue_lock);
 	}
 
 	spin_lock_init(&v3d->mm_lock);
-	spin_lock_init(&v3d->job_lock);
 	ret = drmm_mutex_init(dev, &v3d->bo_lock);
 	if (ret)
 		return ret;
diff --git a/drivers/gpu/drm/v3d/v3d_irq.c b/drivers/gpu/drm/v3d/v3d_irq.c
index 2464ea4d935d0..6831eeccac37c 100644
--- a/drivers/gpu/drm/v3d/v3d_irq.c
+++ b/drivers/gpu/drm/v3d/v3d_irq.c
@@ -62,17 +62,17 @@ v3d_overflow_mem_work(struct work_struct *work)
 	 * bin job got scheduled, that's fine.  We'll just give them
 	 * some binner pool anyway.
 	 */
-	spin_lock_irqsave(&v3d->job_lock, irqflags);
+	spin_lock_irqsave(&queue->queue_lock, irqflags);
 	bin_job = (struct v3d_bin_job *)queue->active_job;
 
 	if (!bin_job) {
-		spin_unlock_irqrestore(&v3d->job_lock, irqflags);
+		spin_unlock_irqrestore(&queue->queue_lock, irqflags);
 		goto out;
 	}
 
 	drm_gem_object_get(obj);
 	list_add_tail(&bo->unref_head, &bin_job->render->unref_list);
-	spin_unlock_irqrestore(&v3d->job_lock, irqflags);
+	spin_unlock_irqrestore(&queue->queue_lock, irqflags);
 
 	v3d_mmu_flush_all(v3d);
 
diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index f2bac920af899..c20e69a2a3dbf 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -204,27 +204,28 @@ static struct dma_fence *v3d_bin_job_run(struct drm_sched_job *sched_job)
 {
 	struct v3d_bin_job *job = to_bin_job(sched_job);
 	struct v3d_dev *v3d = job->base.v3d;
+	struct v3d_queue_state *queue = &v3d->queue[V3D_BIN];
 	struct drm_device *dev = &v3d->drm;
 	struct dma_fence *fence;
 	unsigned long irqflags;
 
 	if (unlikely(job->base.base.s_fence->finished.error)) {
-		spin_lock_irqsave(&v3d->job_lock, irqflags);
-		v3d->queue[V3D_BIN].active_job = NULL;
-		spin_unlock_irqrestore(&v3d->job_lock, irqflags);
+		spin_lock_irqsave(&queue->queue_lock, irqflags);
+		queue->active_job = NULL;
+		spin_unlock_irqrestore(&queue->queue_lock, irqflags);
 		return NULL;
 	}
 
 	/* Lock required around bin_job update vs
 	 * v3d_overflow_mem_work().
 	 */
-	spin_lock_irqsave(&v3d->job_lock, irqflags);
-	v3d->queue[V3D_BIN].active_job = &job->base;
+	spin_lock_irqsave(&queue->queue_lock, irqflags);
+	queue->active_job = &job->base;
 	/* Clear out the overflow allocation, so we don't
 	 * reuse the overflow attached to a previous job.
 	 */
 	V3D_CORE_WRITE(0, V3D_PTB_BPOS, 0);
-	spin_unlock_irqrestore(&v3d->job_lock, irqflags);
+	spin_unlock_irqrestore(&queue->queue_lock, irqflags);
 
 	v3d_invalidate_caches(v3d);
 
-- 
2.53.0



