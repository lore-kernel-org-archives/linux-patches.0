Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C045934F474;
	Thu, 17 Sep 2026 17:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667112; cv=none; b=mvcJHjq0YIGAd8jyLLSlX9dq72gr9ugIFQRDdNifJ/PvY3fjuZVkVfpD2CUIHoa0LreowNvCmGXru5dnXFlRzVbU/iUrWt/Gpy3mm/3ZsA9busIrKXtVNFSpQEV0E9/7bClkf3A/lMLhB++kQSu51GacQiOpNvnh07sqwBTuvuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667112; c=relaxed/simple;
	bh=SVzjLY6YyCPW5GT6oQtTptSZ6G3voodlffS47LBnW4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GJzgmguglF7JLnjfh+AwAV0gQLs7KZ9JlomR+T35JOUCi1fiSLuA1TNsvHw5bO0eUEOb78QUS991USrvdHBHgxxZAanfkoAEkzSFP6bjKvK0N5VeCfydg3Fa9ZrIHnpdnI3PtFAzBqb2+f6Q2iv0oGbfRjSTT/Tpw0qUoYJRZhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeYc9sQ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeYc9sQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1203E1F0089E;
	Thu, 17 Sep 2026 17:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667110;
	bh=Z+wir8nnnPslOl7Mq93MVZWf6oX6LgJAa/uMI71ThV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeYc9sQ6mx9qaQxJqw0qTWNnFzh1YElwGpR3nUcnW5HUBuDsguk2q2n3TJCIhlOCK
	 2MSg0UVF6fF5B1CNOcdvm+MlTqpWK++G8OC0GygMlne4tnj6NaBjdONIft3O56satW
	 mBNcUleYdT5pUdtLYj5Rh5qOOtjOStXVlMUbSq6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1185/1250] drm/amdgpu: plumb timedout fence through to force completion
Date: Thu, 17 Sep 2026 16:16:20 +0100
Message-ID: <20260917151624.403111762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit c184df870db1e328691ea0fbb7d0e59efd9d3f9f ]

When we do a full adapter reset, if we know the timedout fence
mark the fence with -ETIME rather than -ECANCELED so it
gets properly handled by userspace.

v2: rebase

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

Stable adaptation: retain the existing fence helper declarations and use
&job->hw_fence.base because this branch embeds the hardware fence in the
job. Preserve the existing job-fence clearing during full adapter reset.
Drop the VCN 4.0.3 and 5.0.1 JPEG reset call-site updates because their
helpers do not exist on this branch; no new functions are introduced.
The two-argument UVD completion call provides the context required by
6760f5cb12d2 ("drm/amdgpu: avoid force-completing uninitialized UVD rings").

Also restore the fallible amdgpu_vm_flush() interface and its caller's
ring rollback. The preceding dependency 014ab3140cf9 converted it to void,
but this stable branch still allocates a fence in amdgpu_fence_emit() and
can return -ENOMEM. That left a value-return in a void function and broke
both x86 and arm64 builds. Keep the error propagation rather than
silently continuing submission after a failed flush. The job embeds its
hardware fence here, so the caller can return after ring rollback without
an additional fence-free path.

[ sashal: Reduced backport -- upstream c184df870db1e touches 9 file(s), this
  backport carries 10. Not backported here:
  drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
  drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 6760f5cb12d2 ("drm/amdgpu: avoid force-completing uninitialized UVD rings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c  |    6 +++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c   |   26 ++++++++++++++++++++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c      |    9 +++++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h    |    3 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c    |    4 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c     |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c     |   21 +++++++++++++--------
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c      |   10 +++++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h      |    2 +-
 10 files changed, 61 insertions(+), 24 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -1960,7 +1960,7 @@ static int amdgpu_debugfs_ib_preempt(voi
 		/* swap out the old fences */
 		amdgpu_ib_preempt_fences_swap(ring, fences);
 
-		amdgpu_fence_driver_force_completion(ring);
+		amdgpu_fence_driver_force_completion(ring, NULL);
 
 		/* resubmit unfinished jobs */
 		amdgpu_ib_preempt_job_recovery(&ring->sched);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5890,6 +5890,7 @@ int amdgpu_device_pre_asic_reset(struct
 {
 	int i, r = 0;
 	struct amdgpu_job *job = NULL;
+	struct dma_fence *fence = NULL;
 	struct amdgpu_device *tmp_adev = reset_context->reset_req_dev;
 	bool need_full_reset =
 		test_bit(AMDGPU_NEED_FULL_RESET, &reset_context->flags);
@@ -5902,6 +5903,9 @@ int amdgpu_device_pre_asic_reset(struct
 
 	amdgpu_fence_driver_isr_toggle(adev, true);
 
+	if (job)
+		fence = &job->hw_fence.base;
+
 	/* block all schedulers and reset given job's ring */
 	for (i = 0; i < AMDGPU_MAX_RINGS; ++i) {
 		struct amdgpu_ring *ring = adev->rings[i];
@@ -5915,7 +5919,7 @@ int amdgpu_device_pre_asic_reset(struct
 		amdgpu_fence_driver_clear_job_fences(ring);
 
 		/* after all hw jobs are reset, hw fence is meaningless, so force_completion */
-		amdgpu_fence_driver_force_completion(ring);
+		amdgpu_fence_driver_force_completion(ring, fence);
 	}
 
 	amdgpu_fence_driver_isr_toggle(adev, false);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -582,7 +582,7 @@ void amdgpu_fence_driver_hw_fini(struct
 			r = -ENODEV;
 		/* no need to trigger GPU reset as we are unloading */
 		if (r)
-			amdgpu_fence_driver_force_completion(ring);
+			amdgpu_fence_driver_force_completion(ring, NULL);
 
 		if (!drm_dev_is_unplugged(adev_to_drm(adev)) &&
 		    ring->fence_drv.irq_src &&
@@ -727,16 +727,34 @@ void amdgpu_fence_driver_set_error(struc
  * amdgpu_fence_driver_force_completion - force signal latest fence of ring
  *
  * @ring: fence of the ring to signal
+ * @timedout_fence: fence of the timedout job
  *
  */
-void amdgpu_fence_driver_force_completion(struct amdgpu_ring *ring)
+void amdgpu_fence_driver_force_completion(struct amdgpu_ring *ring,
+					  struct dma_fence *timedout_fence)
 {
-	amdgpu_fence_driver_set_error(ring, -ECANCELED);
+	struct amdgpu_fence_driver *drv = &ring->fence_drv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&drv->lock, flags);
+	for (unsigned int i = 0; i <= drv->num_fences_mask; ++i) {
+		struct dma_fence *fence;
+
+		fence = rcu_dereference_protected(drv->fences[i],
+						  lockdep_is_held(&drv->lock));
+		if (fence && !dma_fence_is_signaled_locked(fence)) {
+			if (fence == timedout_fence)
+				dma_fence_set_error(fence, -ETIME);
+			else
+				dma_fence_set_error(fence, -ECANCELED);
+		}
+	}
+	spin_unlock_irqrestore(&drv->lock, flags);
+
 	amdgpu_fence_write(ring, ring->fence_drv.sync_seq);
 	amdgpu_fence_process(ring);
 }
 
-
 /*
  * Kernel queue reset handling
  *
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -208,8 +208,13 @@ int amdgpu_ib_schedule(struct amdgpu_rin
 		dma_fence_put(tmp);
 	}
 
-	if (job)
-		amdgpu_vm_flush(ring, job, need_pipe_sync);
+	if (job) {
+		r = amdgpu_vm_flush(ring, job, need_pipe_sync);
+		if (r) {
+			amdgpu_ring_undo(ring);
+			return r;
+		}
+	}
 
 	amdgpu_ring_ib_begin(ring);
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
@@ -154,7 +154,8 @@ extern const struct drm_sched_backend_op
 
 void amdgpu_fence_driver_clear_job_fences(struct amdgpu_ring *ring);
 void amdgpu_fence_driver_set_error(struct amdgpu_ring *ring, int error);
-void amdgpu_fence_driver_force_completion(struct amdgpu_ring *ring);
+void amdgpu_fence_driver_force_completion(struct amdgpu_ring *ring,
+					  struct dma_fence *timedout_fence);
 void amdgpu_fence_driver_guilty_force_completion(struct amdgpu_fence *af);
 void amdgpu_fence_save_wptr(struct dma_fence *fence);
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
@@ -600,10 +600,10 @@ exit:
 		 * to be submitted to the queues after the reset is complete.
 		 */
 		if (!ret) {
-			amdgpu_fence_driver_force_completion(gfx_ring);
+			amdgpu_fence_driver_force_completion(gfx_ring, NULL);
 			drm_sched_wqueue_start(&gfx_ring->sched);
 			if (adev->sdma.has_page_queue) {
-				amdgpu_fence_driver_force_completion(page_ring);
+				amdgpu_fence_driver_force_completion(page_ring, NULL);
 				drm_sched_wqueue_start(&page_ring->sched);
 			}
 		}
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -516,7 +516,7 @@ int amdgpu_uvd_resume(struct amdgpu_devi
 			}
 			memset_io(ptr, 0, size);
 			/* to restore uvd fence seq */
-			amdgpu_fence_driver_force_completion(&adev->uvd.inst[i].ring);
+			amdgpu_fence_driver_force_completion(&adev->uvd.inst[i].ring, NULL);
 		}
 	}
 	return 0;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -1480,15 +1480,16 @@ int vcn_set_powergating_state(struct amd
 
 /**
  * amdgpu_vcn_reset_engine - Reset a specific VCN engine
- * @adev: Pointer to the AMDGPU device
- * @instance_id: VCN engine instance to reset
+ * @ring: Pointer to the VCN ring
+ * @timedout_fence: fence that timed out
  *
  * Returns: 0 on success, or a negative error code on failure.
  */
-static int amdgpu_vcn_reset_engine(struct amdgpu_device *adev,
-				   uint32_t instance_id)
+static int amdgpu_vcn_reset_engine(struct amdgpu_ring *ring,
+				   struct amdgpu_fence *timedout_fence)
 {
-	struct amdgpu_vcn_inst *vinst = &adev->vcn.inst[instance_id];
+	struct amdgpu_device *adev = ring->adev;
+	struct amdgpu_vcn_inst *vinst = &adev->vcn.inst[ring->me];
 	int r, i;
 
 	mutex_lock(&vinst->engine_reset_mutex);
@@ -1512,9 +1513,13 @@ static int amdgpu_vcn_reset_engine(struc
 		if (r)
 			goto unlock;
 	}
-	amdgpu_fence_driver_force_completion(&vinst->ring_dec);
+	amdgpu_fence_driver_force_completion(&vinst->ring_dec,
+					     (&vinst->ring_dec == ring) ?
+					     &timedout_fence->base : NULL);
 	for (i = 0; i < vinst->num_enc_rings; i++)
-		amdgpu_fence_driver_force_completion(&vinst->ring_enc[i]);
+		amdgpu_fence_driver_force_completion(&vinst->ring_enc[i],
+						     (&vinst->ring_enc[i] == ring) ?
+						     &timedout_fence->base : NULL);
 
 	/* Restart the scheduler's work queue for the dec and enc rings
 	 * if they were stopped by this function. This allows new tasks
@@ -1550,7 +1555,7 @@ int amdgpu_vcn_ring_reset(struct amdgpu_
 	if (adev->vcn.inst[ring->me].using_unified_queue)
 		return -EINVAL;
 
-	return amdgpu_vcn_reset_engine(adev, ring->me);
+	return amdgpu_vcn_reset_engine(ring, timedout_fence);
 }
 
 int amdgpu_vcn_reg_dump_init(struct amdgpu_device *adev,
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -760,9 +760,12 @@ bool amdgpu_vm_need_pipeline_sync(struct
  * @need_pipe_sync: is pipe sync needed
  *
  * Emit a VM flush when it is necessary.
+ *
+ * Returns:
+ * 0 on success, errno otherwise.
  */
-void amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job,
-		     bool need_pipe_sync)
+int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job,
+		    bool need_pipe_sync)
 {
 	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_isolation *isolation =
@@ -808,7 +811,7 @@ void amdgpu_vm_flush(struct amdgpu_ring
 
 	if (!vm_flush_needed && !gds_switch_needed && !need_pipe_sync &&
 	    !cleaner_shader_needed)
-		return;
+		return 0;
 
 	amdgpu_ring_ib_begin(ring);
 
@@ -899,6 +902,7 @@ void amdgpu_vm_flush(struct amdgpu_ring
 	}
 
 	amdgpu_ring_ib_end(ring);
+	return 0;
 }
 
 /**
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
@@ -516,7 +516,7 @@ int amdgpu_vm_validate(struct amdgpu_dev
 		       struct ww_acquire_ctx *ticket,
 		       int (*callback)(void *p, struct amdgpu_bo *bo),
 		       void *param);
-void amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job, bool need_pipe_sync);
+int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job, bool need_pipe_sync);
 int amdgpu_vm_update_pdes(struct amdgpu_device *adev,
 			  struct amdgpu_vm *vm, bool immediate);
 int amdgpu_vm_clear_freed(struct amdgpu_device *adev,


