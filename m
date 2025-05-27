Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A4E185E7F;
	Tue, 27 May 2025 17:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366540; cv=none; b=aTcbPrCME07/HNAwcKBhnH6Zj9mvDkOpMXfqrrddhN51RpYgjuI2dhlaN2tTxj4eCBqR1OItfQ8J1Y8PRWaRTmVfvgy2c1ExmUCx/ijpuoxQAroIoT3F0v72RBIocv8TAG6RRq/tDGICp85WBrTwd+mKrZHQvjnVacEyFLqhvTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366540; c=relaxed/simple;
	bh=2CfYq+rY94Xwc1DyKRTtQidV5Uo773feZ8sIrtlIR8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pitPEpGs22rZ2nvyD6dSszFz6emY33ybRQZ/MooB0dSsIHTMDl9twRM+3C5bPkOy2YFaADdkiXzw4I8kNcO/lIdoMoNAU5qcHMbzrm+TZZ2e0UyjkKqBtO/nqi62xFuuVzPaidEaG7v3NG0JcfA/nZPegtYm2dsvKu6rEk4a4yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kafh3KTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kafh3KTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24616C4CEE9;
	Tue, 27 May 2025 17:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366540;
	bh=2CfYq+rY94Xwc1DyKRTtQidV5Uo773feZ8sIrtlIR8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kafh3KTEZlZMOwShX2MFgpBafdddlemI9LxqZhN8s1Bc1Ovw2UhrY3vXIWHdhYVSE
	 H071/GHVCPWvTYAK0EM/dS2sWU5oC2FGXVb5ea10LIDrg+84+HA8hwPcgcs+Rxfbwx
	 qy+NKGqyWaKkuQDcRCrusfQnaiWvgGDzFguPMUSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 101/783] drm/amdgpu: rework how isolation is enforced v2
Date: Tue, 27 May 2025 18:18:18 +0200
Message-ID: <20250527162517.255801839@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit bd22e44ad415ac22e3a4f9a983d2a085f6cb4427 ]

Limiting the number of available VMIDs to enforce isolation causes some
issues with gang submit and applying certain HW workarounds which
require multiple VMIDs to work correctly.

So instead start to track all submissions to the relevant engines in a
per partition data structure and use the dma_fences of the submissions
to enforce isolation similar to what a VMID limit does.

v2: use ~0l for jobs without isolation to distinct it from kernel
    submissions which uses NULL for the owner. Add some warning when we
    are OOM.

Signed-off-by: Christian König <christian.koenig@amd.com>
Acked-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        | 13 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 98 +++++++++++++++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c    | 43 ++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c    | 16 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c   | 19 +++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.h   |  1 +
 6 files changed, 155 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 416d2611fbf1c..90f688b3d9d36 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1187,9 +1187,15 @@ struct amdgpu_device {
 	bool                            debug_enable_ras_aca;
 	bool                            debug_exp_resets;
 
-	bool				enforce_isolation[MAX_XCP];
-	/* Added this mutex for cleaner shader isolation between GFX and compute processes */
+	/* Protection for the following isolation structure */
 	struct mutex                    enforce_isolation_mutex;
+	bool				enforce_isolation[MAX_XCP];
+	struct amdgpu_isolation {
+		void			*owner;
+		struct dma_fence	*spearhead;
+		struct amdgpu_sync	active;
+		struct amdgpu_sync	prev;
+	} isolation[MAX_XCP];
 
 	struct amdgpu_init_level *init_lvl;
 };
@@ -1470,6 +1476,9 @@ void amdgpu_device_pcie_port_wreg(struct amdgpu_device *adev,
 struct dma_fence *amdgpu_device_get_gang(struct amdgpu_device *adev);
 struct dma_fence *amdgpu_device_switch_gang(struct amdgpu_device *adev,
 					    struct dma_fence *gang);
+struct dma_fence *amdgpu_device_enforce_isolation(struct amdgpu_device *adev,
+						  struct amdgpu_ring *ring,
+						  struct amdgpu_job *job);
 bool amdgpu_device_has_display_hardware(struct amdgpu_device *adev);
 ssize_t amdgpu_get_soft_full_reset_mask(struct amdgpu_ring *ring);
 ssize_t amdgpu_show_reset_mask(char *buf, uint32_t supported_reset);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 34f0451b274c8..726c4854e6296 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4232,6 +4232,11 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	mutex_init(&adev->gfx.reset_sem_mutex);
 	/* Initialize the mutex for cleaner shader isolation between GFX and compute processes */
 	mutex_init(&adev->enforce_isolation_mutex);
+	for (i = 0; i < MAX_XCP; ++i) {
+		adev->isolation[i].spearhead = dma_fence_get_stub();
+		amdgpu_sync_create(&adev->isolation[i].active);
+		amdgpu_sync_create(&adev->isolation[i].prev);
+	}
 	mutex_init(&adev->gfx.kfd_sch_mutex);
 
 	amdgpu_device_init_apu_flags(adev);
@@ -4731,7 +4736,7 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 
 void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 {
-	int idx;
+	int i, idx;
 	bool px;
 
 	amdgpu_device_ip_fini(adev);
@@ -4739,6 +4744,11 @@ void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 	amdgpu_ucode_release(&adev->firmware.gpu_info_fw);
 	adev->accel_working = false;
 	dma_fence_put(rcu_dereference_protected(adev->gang_submit, true));
+	for (i = 0; i < MAX_XCP; ++i) {
+		dma_fence_put(adev->isolation[i].spearhead);
+		amdgpu_sync_free(&adev->isolation[i].active);
+		amdgpu_sync_free(&adev->isolation[i].prev);
+	}
 
 	amdgpu_reset_fini(adev);
 
@@ -6860,6 +6870,92 @@ struct dma_fence *amdgpu_device_switch_gang(struct amdgpu_device *adev,
 	return NULL;
 }
 
+/**
+ * amdgpu_device_enforce_isolation - enforce HW isolation
+ * @adev: the amdgpu device pointer
+ * @ring: the HW ring the job is supposed to run on
+ * @job: the job which is about to be pushed to the HW ring
+ *
+ * Makes sure that only one client at a time can use the GFX block.
+ * Returns: The dependency to wait on before the job can be pushed to the HW.
+ * The function is called multiple times until NULL is returned.
+ */
+struct dma_fence *amdgpu_device_enforce_isolation(struct amdgpu_device *adev,
+						  struct amdgpu_ring *ring,
+						  struct amdgpu_job *job)
+{
+	struct amdgpu_isolation *isolation = &adev->isolation[ring->xcp_id];
+	struct drm_sched_fence *f = job->base.s_fence;
+	struct dma_fence *dep;
+	void *owner;
+	int r;
+
+	/*
+	 * For now enforce isolation only for the GFX block since we only need
+	 * the cleaner shader on those rings.
+	 */
+	if (ring->funcs->type != AMDGPU_RING_TYPE_GFX &&
+	    ring->funcs->type != AMDGPU_RING_TYPE_COMPUTE)
+		return NULL;
+
+	/*
+	 * All submissions where enforce isolation is false are handled as if
+	 * they come from a single client. Use ~0l as the owner to distinct it
+	 * from kernel submissions where the owner is NULL.
+	 */
+	owner = job->enforce_isolation ? f->owner : (void *)~0l;
+
+	mutex_lock(&adev->enforce_isolation_mutex);
+
+	/*
+	 * The "spearhead" submission is the first one which changes the
+	 * ownership to its client. We always need to wait for it to be
+	 * pushed to the HW before proceeding with anything.
+	 */
+	if (&f->scheduled != isolation->spearhead &&
+	    !dma_fence_is_signaled(isolation->spearhead)) {
+		dep = isolation->spearhead;
+		goto out_grab_ref;
+	}
+
+	if (isolation->owner != owner) {
+
+		/*
+		 * Wait for any gang to be assembled before switching to a
+		 * different owner or otherwise we could deadlock the
+		 * submissions.
+		 */
+		if (!job->gang_submit) {
+			dep = amdgpu_device_get_gang(adev);
+			if (!dma_fence_is_signaled(dep))
+				goto out_return_dep;
+			dma_fence_put(dep);
+		}
+
+		dma_fence_put(isolation->spearhead);
+		isolation->spearhead = dma_fence_get(&f->scheduled);
+		amdgpu_sync_move(&isolation->active, &isolation->prev);
+		isolation->owner = owner;
+	}
+
+	/*
+	 * Specifying the ring here helps to pipeline submissions even when
+	 * isolation is enabled. If that is not desired for testing NULL can be
+	 * used instead of the ring to enforce a CPU round trip while switching
+	 * between clients.
+	 */
+	dep = amdgpu_sync_peek_fence(&isolation->prev, ring);
+	r = amdgpu_sync_fence(&isolation->active, &f->finished, GFP_NOWAIT);
+	if (r)
+		DRM_WARN("OOM tracking isolation\n");
+
+out_grab_ref:
+	dma_fence_get(dep);
+out_return_dep:
+	mutex_unlock(&adev->enforce_isolation_mutex);
+	return dep;
+}
+
 bool amdgpu_device_has_display_hardware(struct amdgpu_device *adev)
 {
 	switch (adev->asic_type) {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
index 8e712a11aba5d..9008b7388e897 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
@@ -287,40 +287,27 @@ static int amdgpu_vmid_grab_reserved(struct amdgpu_vm *vm,
 	    (*id)->flushed_updates < updates ||
 	    !(*id)->last_flush ||
 	    ((*id)->last_flush->context != fence_context &&
-	     !dma_fence_is_signaled((*id)->last_flush))) {
+	     !dma_fence_is_signaled((*id)->last_flush)))
+		needs_flush = true;
+
+	if ((*id)->owner != vm->immediate.fence_context ||
+	    (!adev->vm_manager.concurrent_flush && needs_flush)) {
 		struct dma_fence *tmp;
 
-		/* Wait for the gang to be assembled before using a
-		 * reserved VMID or otherwise the gang could deadlock.
+		/* Don't use per engine and per process VMID at the
+		 * same time
 		 */
-		tmp = amdgpu_device_get_gang(adev);
-		if (!dma_fence_is_signaled(tmp) && tmp != job->gang_submit) {
+		if (adev->vm_manager.concurrent_flush)
+			ring = NULL;
+
+		/* to prevent one context starved by another context */
+		(*id)->pd_gpu_addr = 0;
+		tmp = amdgpu_sync_peek_fence(&(*id)->active, ring);
+		if (tmp) {
 			*id = NULL;
-			*fence = tmp;
+			*fence = dma_fence_get(tmp);
 			return 0;
 		}
-		dma_fence_put(tmp);
-
-		/* Make sure the id is owned by the gang before proceeding */
-		if (!job->gang_submit ||
-		    (*id)->owner != vm->immediate.fence_context) {
-
-			/* Don't use per engine and per process VMID at the
-			 * same time
-			 */
-			if (adev->vm_manager.concurrent_flush)
-				ring = NULL;
-
-			/* to prevent one context starved by another context */
-			(*id)->pd_gpu_addr = 0;
-			tmp = amdgpu_sync_peek_fence(&(*id)->active, ring);
-			if (tmp) {
-				*id = NULL;
-				*fence = dma_fence_get(tmp);
-				return 0;
-			}
-		}
-		needs_flush = true;
 	}
 
 	/* Good we can use this VMID. Remember this submission as
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index 100f044759435..685c61a05af85 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -342,17 +342,24 @@ amdgpu_job_prepare_job(struct drm_sched_job *sched_job,
 {
 	struct amdgpu_ring *ring = to_amdgpu_ring(s_entity->rq->sched);
 	struct amdgpu_job *job = to_amdgpu_job(sched_job);
-	struct dma_fence *fence = NULL;
+	struct dma_fence *fence;
 	int r;
 
 	r = drm_sched_entity_error(s_entity);
 	if (r)
 		goto error;
 
-	if (job->gang_submit)
+	if (job->gang_submit) {
 		fence = amdgpu_device_switch_gang(ring->adev, job->gang_submit);
+		if (fence)
+			return fence;
+	}
+
+	fence = amdgpu_device_enforce_isolation(ring->adev, ring, job);
+	if (fence)
+		return fence;
 
-	if (!fence && job->vm && !job->vmid) {
+	if (job->vm && !job->vmid) {
 		r = amdgpu_vmid_grab(job->vm, ring, job, &fence);
 		if (r) {
 			dev_err(ring->adev->dev, "Error getting VM ID (%d)\n", r);
@@ -365,9 +372,10 @@ amdgpu_job_prepare_job(struct drm_sched_job *sched_job,
 		 */
 		if (!fence)
 			job->vm = NULL;
+		return fence;
 	}
 
-	return fence;
+	return NULL;
 
 error:
 	dma_fence_set_error(&job->base.s_fence->finished, r);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
index c586ab4c911bf..d75715b3f1870 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
@@ -399,6 +399,25 @@ int amdgpu_sync_clone(struct amdgpu_sync *source, struct amdgpu_sync *clone)
 	return 0;
 }
 
+/**
+ * amdgpu_sync_move - move all fences from src to dst
+ *
+ * @src: source of the fences, empty after function
+ * @dst: destination for the fences
+ *
+ * Moves all fences from source to destination. All fences in destination are
+ * freed and source is empty after the function call.
+ */
+void amdgpu_sync_move(struct amdgpu_sync *src, struct amdgpu_sync *dst)
+{
+	unsigned int i;
+
+	amdgpu_sync_free(dst);
+
+	for (i = 0; i < HASH_SIZE(src->fences); ++i)
+		hlist_move_list(&src->fences[i], &dst->fences[i]);
+}
+
 /**
  * amdgpu_sync_push_to_job - push fences into job
  * @sync: sync object to get the fences from
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.h
index e3272dce798d7..a91a8eaf808b1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.h
@@ -56,6 +56,7 @@ struct dma_fence *amdgpu_sync_peek_fence(struct amdgpu_sync *sync,
 				     struct amdgpu_ring *ring);
 struct dma_fence *amdgpu_sync_get_fence(struct amdgpu_sync *sync);
 int amdgpu_sync_clone(struct amdgpu_sync *source, struct amdgpu_sync *clone);
+void amdgpu_sync_move(struct amdgpu_sync *src, struct amdgpu_sync *dst);
 int amdgpu_sync_push_to_job(struct amdgpu_sync *sync, struct amdgpu_job *job);
 int amdgpu_sync_wait(struct amdgpu_sync *sync, bool intr);
 void amdgpu_sync_free(struct amdgpu_sync *sync);
-- 
2.39.5



