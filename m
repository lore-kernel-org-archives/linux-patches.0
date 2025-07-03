Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09562ECEBA;
	Thu,  3 Jul 2025 14:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554398; cv=none; b=FrdRnxKiTnfU5COdjRaW97vH+KShHnrHqmeNFPjNMxG2/L79VU+vuoTzHjeRRI/nJZgr34Y67Oa4aTgcfxOh2E0Czet9BmudPfXHMDB1Y2OjKxRnsA+pQJw8LLEezd+ieV5r2twV78fZsN0GlSBe9x0eq8UeqfVfYxLXfnbq7ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554398; c=relaxed/simple;
	bh=dRiFJrB9MB2ltUe3xnDqunMduS8J3Ky/vJpWd1zUs8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KJA/ZqcPqC5kE8dpyiOREFWOnfw8PJFNSaxs3BS6KfVpGxj65Ahe1GQGAcijqh7MShmpHYlaZYo3MnBfFqsSzq4A7fpb5lCOgfVACXkRKhvoEaaASAkwQlBtUZzLjm7jU08AxRO2Ycwlew740F2Jx0yltB5yprY2pYYIRQ5Jj44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o3nNRyNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o3nNRyNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E4DC4CEE3;
	Thu,  3 Jul 2025 14:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554398;
	bh=dRiFJrB9MB2ltUe3xnDqunMduS8J3Ky/vJpWd1zUs8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3nNRyNW7DYdj0PylPFiCPMvWtlDOXR2LwqUqu0OMgv5o7c/xMbPjkqMgvOuqA8wJ
	 myts4GHmEp6Vc7HjJZLfj+vlEEuRgjVGjB9nGNkVE/yHPknZ0HttZOdbTzlyt6grt8
	 GgOv43ozit6T9g5abIKYxWIzVSct81VCjzYhTCh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 175/218] drm/amdgpu: switch job hw_fence to amdgpu_fence
Date: Thu,  3 Jul 2025 16:42:03 +0200
Message-ID: <20250703144003.171279768@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alex Deucher <alexander.deucher@amd.com>

commit ebe43542702c3d15d1a1d95e8e13b1b54076f05a upstream.

Use the amdgpu fence container so we can store additional
data in the fence.  This also fixes the start_time handling
for MCBP since we were casting the fence to an amdgpu_fence
and it wasn't.

Fixes: 3f4c175d62d8 ("drm/amdgpu: MCBP based on DRM scheduler (v9)")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bf1cd14f9e2e1fdf981eed273ddd595863f5288c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    2 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c  |    2 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c   |   30 ++++++----------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c     |   12 +++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.h     |    2 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h    |   16 ++++++++++++++
 6 files changed, 32 insertions(+), 32 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -1902,7 +1902,7 @@ no_preempt:
 			continue;
 		}
 		job = to_amdgpu_job(s_job);
-		if (preempted && (&job->hw_fence) == fence)
+		if (preempted && (&job->hw_fence.base) == fence)
 			/* mark the job as preempted */
 			job->preemption_status |= AMDGPU_IB_PREEMPTED;
 	}
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5861,7 +5861,7 @@ int amdgpu_device_gpu_recover(struct amd
 	 *
 	 * job->base holds a reference to parent fence
 	 */
-	if (job && dma_fence_is_signaled(&job->hw_fence)) {
+	if (job && dma_fence_is_signaled(&job->hw_fence.base)) {
 		job_signaled = true;
 		dev_info(adev->dev, "Guilty job already signaled, skipping HW reset");
 		goto skip_hw_reset;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -41,22 +41,6 @@
 #include "amdgpu_trace.h"
 #include "amdgpu_reset.h"
 
-/*
- * Fences mark an event in the GPUs pipeline and are used
- * for GPU/CPU synchronization.  When the fence is written,
- * it is expected that all buffers associated with that fence
- * are no longer in use by the associated ring on the GPU and
- * that the relevant GPU caches have been flushed.
- */
-
-struct amdgpu_fence {
-	struct dma_fence base;
-
-	/* RB, DMA, etc. */
-	struct amdgpu_ring		*ring;
-	ktime_t				start_timestamp;
-};
-
 static struct kmem_cache *amdgpu_fence_slab;
 
 int amdgpu_fence_slab_init(void)
@@ -151,12 +135,12 @@ int amdgpu_fence_emit(struct amdgpu_ring
 		am_fence = kmem_cache_alloc(amdgpu_fence_slab, GFP_ATOMIC);
 		if (am_fence == NULL)
 			return -ENOMEM;
-		fence = &am_fence->base;
-		am_fence->ring = ring;
 	} else {
 		/* take use of job-embedded fence */
-		fence = &job->hw_fence;
+		am_fence = &job->hw_fence;
 	}
+	fence = &am_fence->base;
+	am_fence->ring = ring;
 
 	seq = ++ring->fence_drv.sync_seq;
 	if (job && job->job_run_counter) {
@@ -718,7 +702,7 @@ void amdgpu_fence_driver_clear_job_fence
 			 * it right here or we won't be able to track them in fence_drv
 			 * and they will remain unsignaled during sa_bo free.
 			 */
-			job = container_of(old, struct amdgpu_job, hw_fence);
+			job = container_of(old, struct amdgpu_job, hw_fence.base);
 			if (!job->base.s_fence && !dma_fence_is_signaled(old))
 				dma_fence_signal(old);
 			RCU_INIT_POINTER(*ptr, NULL);
@@ -780,7 +764,7 @@ static const char *amdgpu_fence_get_time
 
 static const char *amdgpu_job_fence_get_timeline_name(struct dma_fence *f)
 {
-	struct amdgpu_job *job = container_of(f, struct amdgpu_job, hw_fence);
+	struct amdgpu_job *job = container_of(f, struct amdgpu_job, hw_fence.base);
 
 	return (const char *)to_amdgpu_ring(job->base.sched)->name;
 }
@@ -810,7 +794,7 @@ static bool amdgpu_fence_enable_signalin
  */
 static bool amdgpu_job_fence_enable_signaling(struct dma_fence *f)
 {
-	struct amdgpu_job *job = container_of(f, struct amdgpu_job, hw_fence);
+	struct amdgpu_job *job = container_of(f, struct amdgpu_job, hw_fence.base);
 
 	if (!timer_pending(&to_amdgpu_ring(job->base.sched)->fence_drv.fallback_timer))
 		amdgpu_fence_schedule_fallback(to_amdgpu_ring(job->base.sched));
@@ -845,7 +829,7 @@ static void amdgpu_job_fence_free(struct
 	struct dma_fence *f = container_of(rcu, struct dma_fence, rcu);
 
 	/* free job if fence has a parent job */
-	kfree(container_of(f, struct amdgpu_job, hw_fence));
+	kfree(container_of(f, struct amdgpu_job, hw_fence.base));
 }
 
 /**
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -259,8 +259,8 @@ void amdgpu_job_free_resources(struct am
 	/* Check if any fences where initialized */
 	if (job->base.s_fence && job->base.s_fence->finished.ops)
 		f = &job->base.s_fence->finished;
-	else if (job->hw_fence.ops)
-		f = &job->hw_fence;
+	else if (job->hw_fence.base.ops)
+		f = &job->hw_fence.base;
 	else
 		f = NULL;
 
@@ -277,10 +277,10 @@ static void amdgpu_job_free_cb(struct dr
 	amdgpu_sync_free(&job->explicit_sync);
 
 	/* only put the hw fence if has embedded fence */
-	if (!job->hw_fence.ops)
+	if (!job->hw_fence.base.ops)
 		kfree(job);
 	else
-		dma_fence_put(&job->hw_fence);
+		dma_fence_put(&job->hw_fence.base);
 }
 
 void amdgpu_job_set_gang_leader(struct amdgpu_job *job,
@@ -309,10 +309,10 @@ void amdgpu_job_free(struct amdgpu_job *
 	if (job->gang_submit != &job->base.s_fence->scheduled)
 		dma_fence_put(job->gang_submit);
 
-	if (!job->hw_fence.ops)
+	if (!job->hw_fence.base.ops)
 		kfree(job);
 	else
-		dma_fence_put(&job->hw_fence);
+		dma_fence_put(&job->hw_fence.base);
 }
 
 struct dma_fence *amdgpu_job_submit(struct amdgpu_job *job)
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.h
@@ -48,7 +48,7 @@ struct amdgpu_job {
 	struct drm_sched_job    base;
 	struct amdgpu_vm	*vm;
 	struct amdgpu_sync	explicit_sync;
-	struct dma_fence	hw_fence;
+	struct amdgpu_fence	hw_fence;
 	struct dma_fence	*gang_submit;
 	uint32_t		preamble_status;
 	uint32_t                preemption_status;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
@@ -126,6 +126,22 @@ struct amdgpu_fence_driver {
 	struct dma_fence		**fences;
 };
 
+/*
+ * Fences mark an event in the GPUs pipeline and are used
+ * for GPU/CPU synchronization.  When the fence is written,
+ * it is expected that all buffers associated with that fence
+ * are no longer in use by the associated ring on the GPU and
+ * that the relevant GPU caches have been flushed.
+ */
+
+struct amdgpu_fence {
+	struct dma_fence base;
+
+	/* RB, DMA, etc. */
+	struct amdgpu_ring		*ring;
+	ktime_t				start_timestamp;
+};
+
 extern const struct drm_sched_backend_ops amdgpu_sched_ops;
 
 void amdgpu_fence_driver_clear_job_fences(struct amdgpu_ring *ring);


