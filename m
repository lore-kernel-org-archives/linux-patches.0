Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49AF522F0A;
	Wed, 30 Sep 2026 17:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790382; cv=none; b=uKA5B0xTkkHnbQ0ZBVHYTJrg7RNb4H5fCF5Rk1xMB35X3GdS/qBx2VFY0U3NIuOffEICOWFGDl3S+UxntcMrWaNIK++MUgRfNY+4UtiDwGBp5CT/hGz1pKyjoHKuoRayx9TcLfwZrnobGMWIpf8gsHEGlQMJzdSUrYQnQfsSHs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790382; c=relaxed/simple;
	bh=/2uoRmqaF3DAnaFbIwmuUmfvJ0h/Zq7iuz7we88eTQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g7rgR50/xd//kY5UWcD5c7H6rU0yLO18FKKshNo2ykb1wJRo/1ooy/uLmqotEyZKZP8xjYctuer3afTdeUGb+HflpDGmOgP/0JW8CN8IQ4idV3BF2JodBb825mJVsHLleTvXR/kL6d0X9qqmJ11TcTz7ZxlpBwCwwFfMuElQDkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOvJi2iR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOvJi2iR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B07B1F00898;
	Wed, 30 Sep 2026 17:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790380;
	bh=1+wFhfXBiPbPdGo1SU2M9yjF/ay6TUT2ix4eLWnOUH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QOvJi2iR3fwvmU98ESGymnq1A34XbauhKXnpb/iz66gQEV16Jj9LzPEG8i/2WodPX
	 8/2u013mCmOUwiL+FGEga6iO8v/IQb7XrTJ+3Rp+h077UZtzcvXPUJ2OB2MpgNuC7c
	 HBB+YuS1b21jrUfnfl0LO08MS9KRNCIvB7f09UdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 809/877] drm/amdgpu: use GFP_NOWAIT for memory allocations
Date: Wed, 30 Sep 2026 17:28:40 +0200
Message-ID: <20260930152432.176188147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 16590745b571c07869ef8958e0bbe44ab6f08d1f ]

In the critical submission path memory allocations can't wait for
reclaim since that can potentially wait for submissions to finish.

Finally clean that up and mark most memory allocations in the critical
path with GFP_NOWAIT. The only exception left is the dma_fence_array()
used when no VMID is available, but that will be cleaned up later on.

Signed-off-by: Christian König <christian.koenig@amd.com>
Acked-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 5155002b03b2 ("drm/amdgpu: fix rmmio iounmap skipped on device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    8 ++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c           |   18 +++++++++++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c          |   11 +++++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c          |    4 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c         |   11 ++++++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.h         |    3 ++-
 6 files changed, 32 insertions(+), 23 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -491,7 +491,7 @@ static int vm_update_pds(struct amdgpu_v
 	if (ret)
 		return ret;
 
-	return amdgpu_sync_fence(sync, vm->last_update);
+	return amdgpu_sync_fence(sync, vm->last_update, GFP_KERNEL);
 }
 
 static uint64_t get_pte_flags(struct amdgpu_device *adev, struct kgd_mem *mem)
@@ -1255,7 +1255,7 @@ static int unmap_bo_from_gpuvm(struct kg
 
 	(void)amdgpu_vm_clear_freed(adev, vm, &bo_va->last_pt_update);
 
-	(void)amdgpu_sync_fence(sync, bo_va->last_pt_update);
+	(void)amdgpu_sync_fence(sync, bo_va->last_pt_update, GFP_KERNEL);
 
 	return 0;
 }
@@ -1279,7 +1279,7 @@ static int update_gpuvm_pte(struct kgd_m
 		return ret;
 	}
 
-	return amdgpu_sync_fence(sync, bo_va->last_pt_update);
+	return amdgpu_sync_fence(sync, bo_va->last_pt_update, GFP_KERNEL);
 }
 
 static int map_bo_to_gpuvm(struct kgd_mem *mem,
@@ -2971,7 +2971,7 @@ int amdgpu_amdkfd_gpuvm_restore_process_
 		}
 		dma_resv_for_each_fence(&cursor, bo->tbo.base.resv,
 					DMA_RESV_USAGE_KERNEL, fence) {
-			ret = amdgpu_sync_fence(&sync_obj, fence);
+			ret = amdgpu_sync_fence(&sync_obj, fence, GFP_KERNEL);
 			if (ret) {
 				pr_debug("Memory eviction: Sync BO fence failed. Try again\n");
 				goto validate_map_fail;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -462,7 +462,7 @@ static int amdgpu_cs_p2_dependencies(str
 			dma_fence_put(old);
 		}
 
-		r = amdgpu_sync_fence(&p->sync, fence);
+		r = amdgpu_sync_fence(&p->sync, fence, GFP_KERNEL);
 		dma_fence_put(fence);
 		if (r)
 			return r;
@@ -484,7 +484,7 @@ static int amdgpu_syncobj_lookup_and_add
 		return r;
 	}
 
-	r = amdgpu_sync_fence(&p->sync, fence);
+	r = amdgpu_sync_fence(&p->sync, fence, GFP_KERNEL);
 	dma_fence_put(fence);
 	return r;
 }
@@ -1157,7 +1157,8 @@ static int amdgpu_cs_vm_handling(struct
 	if (r)
 		return r;
 
-	r = amdgpu_sync_fence(&p->sync, fpriv->prt_va->last_pt_update);
+	r = amdgpu_sync_fence(&p->sync, fpriv->prt_va->last_pt_update,
+			      GFP_KERNEL);
 	if (r)
 		return r;
 
@@ -1168,7 +1169,8 @@ static int amdgpu_cs_vm_handling(struct
 		if (r)
 			return r;
 
-		r = amdgpu_sync_fence(&p->sync, bo_va->last_pt_update);
+		r = amdgpu_sync_fence(&p->sync, bo_va->last_pt_update,
+				      GFP_KERNEL);
 		if (r)
 			return r;
 	}
@@ -1187,7 +1189,8 @@ static int amdgpu_cs_vm_handling(struct
 		if (r)
 			return r;
 
-		r = amdgpu_sync_fence(&p->sync, bo_va->last_pt_update);
+		r = amdgpu_sync_fence(&p->sync, bo_va->last_pt_update,
+				      GFP_KERNEL);
 		if (r)
 			return r;
 	}
@@ -1200,7 +1203,7 @@ static int amdgpu_cs_vm_handling(struct
 	if (r)
 		return r;
 
-	r = amdgpu_sync_fence(&p->sync, vm->last_update);
+	r = amdgpu_sync_fence(&p->sync, vm->last_update, GFP_KERNEL);
 	if (r)
 		return r;
 
@@ -1267,7 +1270,8 @@ static int amdgpu_cs_sync_rings(struct a
 			continue;
 		}
 
-		r = amdgpu_sync_fence(&p->gang_leader->explicit_sync, fence);
+		r = amdgpu_sync_fence(&p->gang_leader->explicit_sync, fence,
+				      GFP_KERNEL);
 		dma_fence_put(fence);
 		if (r)
 			return r;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
@@ -220,7 +220,7 @@ static int amdgpu_vmid_grab_idle(struct
 		return 0;
 	}
 
-	fences = kmalloc_array(id_mgr->num_ids, sizeof(void *), GFP_KERNEL);
+	fences = kmalloc_array(id_mgr->num_ids, sizeof(void *), GFP_NOWAIT);
 	if (!fences)
 		return -ENOMEM;
 
@@ -337,7 +337,8 @@ static int amdgpu_vmid_grab_reserved(str
 	/* Good we can use this VMID. Remember this submission as
 	* user of the VMID.
 	*/
-	r = amdgpu_sync_fence(&(*id)->active, &job->base.s_fence->finished);
+	r = amdgpu_sync_fence(&(*id)->active, &job->base.s_fence->finished,
+			      GFP_NOWAIT);
 	if (r)
 		return r;
 
@@ -398,7 +399,8 @@ static int amdgpu_vmid_grab_used(struct
 		 * user of the VMID.
 		 */
 		r = amdgpu_sync_fence(&(*id)->active,
-				      &job->base.s_fence->finished);
+				      &job->base.s_fence->finished,
+				      GFP_NOWAIT);
 		if (r)
 			return r;
 
@@ -450,7 +452,8 @@ int amdgpu_vmid_grab(struct amdgpu_vm *v
 
 			/* Remember this submission as user of the VMID */
 			r = amdgpu_sync_fence(&id->active,
-					      &job->base.s_fence->finished);
+					      &job->base.s_fence->finished,
+					      GFP_NOWAIT);
 			if (r)
 				goto error;
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -1354,14 +1354,14 @@ int amdgpu_mes_ctx_map_meta_data(struct
 		DRM_ERROR("failed to do vm_bo_update on meta data\n");
 		goto error_del_bo_va;
 	}
-	amdgpu_sync_fence(&sync, bo_va->last_pt_update);
+	amdgpu_sync_fence(&sync, bo_va->last_pt_update, GFP_KERNEL);
 
 	r = amdgpu_vm_update_pdes(adev, vm, false);
 	if (r) {
 		DRM_ERROR("failed to update pdes on meta data\n");
 		goto error_del_bo_va;
 	}
-	amdgpu_sync_fence(&sync, vm->last_update);
+	amdgpu_sync_fence(&sync, vm->last_update, GFP_KERNEL);
 
 	amdgpu_sync_wait(&sync, false);
 	drm_exec_fini(&exec);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
@@ -152,7 +152,8 @@ static bool amdgpu_sync_add_later(struct
  *
  * Add the fence to the sync object.
  */
-int amdgpu_sync_fence(struct amdgpu_sync *sync, struct dma_fence *f)
+int amdgpu_sync_fence(struct amdgpu_sync *sync, struct dma_fence *f,
+		      gfp_t flags)
 {
 	struct amdgpu_sync_entry *e;
 
@@ -162,7 +163,7 @@ int amdgpu_sync_fence(struct amdgpu_sync
 	if (amdgpu_sync_add_later(sync, f))
 		return 0;
 
-	e = kmem_cache_alloc(amdgpu_sync_slab, GFP_KERNEL);
+	e = kmem_cache_alloc(amdgpu_sync_slab, flags);
 	if (!e)
 		return -ENOMEM;
 
@@ -249,7 +250,7 @@ int amdgpu_sync_resv(struct amdgpu_devic
 			struct dma_fence *tmp = dma_fence_chain_contained(f);
 
 			if (amdgpu_sync_test_fence(adev, mode, owner, tmp)) {
-				r = amdgpu_sync_fence(sync, f);
+				r = amdgpu_sync_fence(sync, f, GFP_KERNEL);
 				dma_fence_put(f);
 				if (r)
 					return r;
@@ -281,7 +282,7 @@ int amdgpu_sync_kfd(struct amdgpu_sync *
 		if (fence_owner != AMDGPU_FENCE_OWNER_KFD)
 			continue;
 
-		r = amdgpu_sync_fence(sync, f);
+		r = amdgpu_sync_fence(sync, f, GFP_KERNEL);
 		if (r)
 			break;
 	}
@@ -388,7 +389,7 @@ int amdgpu_sync_clone(struct amdgpu_sync
 	hash_for_each_safe(source->fences, i, tmp, e, node) {
 		f = e->fence;
 		if (!dma_fence_is_signaled(f)) {
-			r = amdgpu_sync_fence(clone, f);
+			r = amdgpu_sync_fence(clone, f, GFP_KERNEL);
 			if (r)
 				return r;
 		} else {
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.h
@@ -47,7 +47,8 @@ struct amdgpu_sync {
 };
 
 void amdgpu_sync_create(struct amdgpu_sync *sync);
-int amdgpu_sync_fence(struct amdgpu_sync *sync, struct dma_fence *f);
+int amdgpu_sync_fence(struct amdgpu_sync *sync, struct dma_fence *f,
+		      gfp_t flags);
 int amdgpu_sync_resv(struct amdgpu_device *adev, struct amdgpu_sync *sync,
 		     struct dma_resv *resv, enum amdgpu_sync_mode mode,
 		     void *owner);


