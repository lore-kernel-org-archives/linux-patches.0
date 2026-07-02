Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285D4414DDD;
	Thu,  2 Jul 2026 16:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009681; cv=none; b=crVOu0IBVy2AEFEm0BRqC6e31ohJIqzL4Erk6xR5KAuNrBnv1x4PK6jHSfZQNMynyKuxt4+5Cd+lpR1YBP8FKZsJTfhrLdkw1RtKE4tXGRvjStHnzvG0tUHu7rvo34BJEdiorEIlJu7m2uy2K9qTwuJz4qmpbV43McBwhWbcdIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009681; c=relaxed/simple;
	bh=+LcDJZ9oZdoluPlj7SWAkbgL0+fjed1SZcAq0X6BJFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lfms8fYS1phfvI80AdFlc9IoBOfEb/+ocJhHJQSPOMaPAG0MvZ3jNJ7gIxQky/K6tN/w++O85wRrwaaCL+HFebAlfOlmuvJyXNwlR0X5byga5ZHiLt0anETi8tV5nBNprs85P6QHW4TUz0kfEkyYBU5x9bUhc6k0Z69fvDsb+Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foRKDmqV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foRKDmqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743DC1F000E9;
	Thu,  2 Jul 2026 16:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009678;
	bh=DTISAGXlRRfjYQDh1hlQweEEFZAa4aLKPp5Cwlou8Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=foRKDmqVbuCUiE/uLBdPCpa2cjAOY9/r+onpi+0STokX1aZWYSSVLlr9eOvkUU96H
	 ZUm7tvmmb7zD17it4va1+QoNaTdOQ4xXfc7XSzhIkLPZBtJ0ASbMLNTAUzQoYqFBUp
	 hHGjBcvoNyEfgMNCMPj0FEJqOgmJAvcrEzFSMuWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 08/95] drm/v3d: Store the active job inside the queues state
Date: Thu,  2 Jul 2026 18:19:11 +0200
Message-ID: <20260702155109.385288151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 0d3768826d38c0ac740f8b45cd13346630535f2b ]

Instead of storing the queue's active job in four different variables,
store the active job inside the queue's state. This way, it's possible
to access all active jobs using an index based in `enum v3d_queue`.

Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Link: https://lore.kernel.org/r/20250826-v3d-queue-lock-v3-2-979efc43e490@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Stable-dep-of: 7f93fad5ea0a ("drm/v3d: Skip CSD when it has zeroed workgroups")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_drv.h   |  8 +++-----
 drivers/gpu/drm/v3d/v3d_gem.c   |  5 +++--
 drivers/gpu/drm/v3d/v3d_irq.c   | 24 ++++++++++++++----------
 drivers/gpu/drm/v3d/v3d_sched.c | 26 ++++++++++++++++++--------
 4 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
index 0d551b1d9b05d4..14002d2b4add36 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -35,6 +35,9 @@ struct v3d_queue_state {
 
 	u64 fence_context;
 	u64 emit_seqno;
+
+	/* Currently active job for this queue */
+	struct v3d_job *active_job;
 };
 
 /* Performance monitor object. The perform lifetime is controlled by userspace
@@ -119,11 +122,6 @@ struct v3d_dev {
 
 	struct work_struct overflow_mem_work;
 
-	struct v3d_bin_job *bin_job;
-	struct v3d_render_job *render_job;
-	struct v3d_tfu_job *tfu_job;
-	struct v3d_csd_job *csd_job;
-
 	struct v3d_queue_state queue[V3D_MAX_QUEUES];
 
 	/* Spinlock used to synchronize the overflow memory
diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
index ecd03ad9699a08..3911550f72c22f 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -950,14 +950,15 @@ void
 v3d_gem_destroy(struct drm_device *dev)
 {
 	struct v3d_dev *v3d = to_v3d_dev(dev);
+	enum v3d_queue q;
 
 	v3d_sched_fini(v3d);
 
 	/* Waiting for jobs to finish would need to be done before
 	 * unregistering V3D.
 	 */
-	WARN_ON(v3d->bin_job);
-	WARN_ON(v3d->render_job);
+	for (q = 0; q < V3D_MAX_QUEUES; q++)
+		WARN_ON(v3d->queue[q].active_job);
 
 	drm_mm_takedown(&v3d->mm);
 
diff --git a/drivers/gpu/drm/v3d/v3d_irq.c b/drivers/gpu/drm/v3d/v3d_irq.c
index 9aba78e6d7a5a6..3d5505159ff5e8 100644
--- a/drivers/gpu/drm/v3d/v3d_irq.c
+++ b/drivers/gpu/drm/v3d/v3d_irq.c
@@ -40,6 +40,8 @@ v3d_overflow_mem_work(struct work_struct *work)
 		container_of(work, struct v3d_dev, overflow_mem_work);
 	struct drm_device *dev = &v3d->drm;
 	struct v3d_bo *bo = v3d_bo_create(dev, NULL /* XXX: GMP */, 256 * 1024);
+	struct v3d_queue_state *queue = &v3d->queue[V3D_BIN];
+	struct v3d_bin_job *bin_job;
 	struct drm_gem_object *obj;
 	unsigned long irqflags;
 
@@ -59,13 +61,15 @@ v3d_overflow_mem_work(struct work_struct *work)
 	 * some binner pool anyway.
 	 */
 	spin_lock_irqsave(&v3d->job_lock, irqflags);
-	if (!v3d->bin_job) {
+	bin_job = (struct v3d_bin_job *)queue->active_job;
+
+	if (!bin_job) {
 		spin_unlock_irqrestore(&v3d->job_lock, irqflags);
 		goto out;
 	}
 
 	drm_gem_object_get(obj);
-	list_add_tail(&bo->unref_head, &v3d->bin_job->render->unref_list);
+	list_add_tail(&bo->unref_head, &bin_job->render->unref_list);
 	spin_unlock_irqrestore(&v3d->job_lock, irqflags);
 
 	V3D_CORE_WRITE(0, V3D_PTB_BPOA, bo->node.start << PAGE_SHIFT);
@@ -99,11 +103,11 @@ v3d_irq(int irq, void *arg)
 
 	if (intsts & V3D_INT_FLDONE) {
 		struct v3d_fence *fence =
-			to_v3d_fence(v3d->bin_job->base.irq_fence);
+			to_v3d_fence(v3d->queue[V3D_BIN].active_job->irq_fence);
 
 		trace_v3d_bcl_irq(&v3d->drm, fence->seqno);
 
-		v3d->bin_job = NULL;
+		v3d->queue[V3D_BIN].active_job = NULL;
 		dma_fence_signal(&fence->base);
 
 		status = IRQ_HANDLED;
@@ -111,11 +115,11 @@ v3d_irq(int irq, void *arg)
 
 	if (intsts & V3D_INT_FRDONE) {
 		struct v3d_fence *fence =
-			to_v3d_fence(v3d->render_job->base.irq_fence);
+			to_v3d_fence(v3d->queue[V3D_RENDER].active_job->irq_fence);
 
 		trace_v3d_rcl_irq(&v3d->drm, fence->seqno);
 
-		v3d->render_job = NULL;
+		v3d->queue[V3D_RENDER].active_job = NULL;
 		dma_fence_signal(&fence->base);
 
 		status = IRQ_HANDLED;
@@ -123,11 +127,11 @@ v3d_irq(int irq, void *arg)
 
 	if (intsts & V3D_INT_CSDDONE) {
 		struct v3d_fence *fence =
-			to_v3d_fence(v3d->csd_job->base.irq_fence);
+			to_v3d_fence(v3d->queue[V3D_CSD].active_job->irq_fence);
 
 		trace_v3d_csd_irq(&v3d->drm, fence->seqno);
 
-		v3d->csd_job = NULL;
+		v3d->queue[V3D_CSD].active_job = NULL;
 		dma_fence_signal(&fence->base);
 
 		status = IRQ_HANDLED;
@@ -162,11 +166,11 @@ v3d_hub_irq(int irq, void *arg)
 
 	if (intsts & V3D_HUB_INT_TFUC) {
 		struct v3d_fence *fence =
-			to_v3d_fence(v3d->tfu_job->base.irq_fence);
+			to_v3d_fence(v3d->queue[V3D_TFU].active_job->irq_fence);
 
 		trace_v3d_tfu_irq(&v3d->drm, fence->seqno);
 
-		v3d->tfu_job = NULL;
+		v3d->queue[V3D_TFU].active_job = NULL;
 		dma_fence_signal(&fence->base);
 
 		status = IRQ_HANDLED;
diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index c357229256b73a..db98855741ee85 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -103,14 +103,18 @@ static struct dma_fence *v3d_bin_job_run(struct drm_sched_job *sched_job)
 	struct dma_fence *fence;
 	unsigned long irqflags;
 
-	if (unlikely(job->base.base.s_fence->finished.error))
+	if (unlikely(job->base.base.s_fence->finished.error)) {
+		spin_lock_irqsave(&v3d->job_lock, irqflags);
+		v3d->queue[V3D_BIN].active_job = NULL;
+		spin_unlock_irqrestore(&v3d->job_lock, irqflags);
 		return NULL;
+	}
 
 	/* Lock required around bin_job update vs
 	 * v3d_overflow_mem_work().
 	 */
 	spin_lock_irqsave(&v3d->job_lock, irqflags);
-	v3d->bin_job = job;
+	v3d->queue[V3D_BIN].active_job = &job->base;
 	/* Clear out the overflow allocation, so we don't
 	 * reuse the overflow attached to a previous job.
 	 */
@@ -157,10 +161,12 @@ static struct dma_fence *v3d_render_job_run(struct drm_sched_job *sched_job)
 	struct drm_device *dev = &v3d->drm;
 	struct dma_fence *fence;
 
-	if (unlikely(job->base.base.s_fence->finished.error))
+	if (unlikely(job->base.base.s_fence->finished.error)) {
+		v3d->queue[V3D_RENDER].active_job = NULL;
 		return NULL;
+	}
 
-	v3d->render_job = job;
+	v3d->queue[V3D_RENDER].active_job = &job->base;
 
 	/* Can we avoid this flush?  We need to be careful of
 	 * scheduling, though -- imagine job0 rendering to texture and
@@ -202,10 +208,12 @@ v3d_tfu_job_run(struct drm_sched_job *sched_job)
 	struct drm_device *dev = &v3d->drm;
 	struct dma_fence *fence;
 
-	if (unlikely(job->base.base.s_fence->finished.error))
+	if (unlikely(job->base.base.s_fence->finished.error)) {
+		v3d->queue[V3D_TFU].active_job = NULL;
 		return NULL;
+	}
 
-	v3d->tfu_job = job;
+	v3d->queue[V3D_TFU].active_job = &job->base;
 
 	fence = v3d_fence_create(v3d, V3D_TFU);
 	if (IS_ERR(fence))
@@ -244,10 +252,12 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 	struct dma_fence *fence;
 	int i;
 
-	if (unlikely(job->base.base.s_fence->finished.error))
+	if (unlikely(job->base.base.s_fence->finished.error)) {
+		v3d->queue[V3D_CSD].active_job = NULL;
 		return NULL;
+	}
 
-	v3d->csd_job = job;
+	v3d->queue[V3D_CSD].active_job = &job->base;
 
 	v3d_invalidate_caches(v3d);
 
-- 
2.53.0



