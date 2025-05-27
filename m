Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A64185E7F;
	Tue, 27 May 2025 17:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366543; cv=none; b=KxwtLc8FIgA/YbVc3IO9u8mRQ81pIbq8PxqG3QYT5e0pfx79oQ5WImxBSMb9Se4toqOL2GqDl7+2y4HL4bWFOJscpYEW/aO/1zTeCwTZ/SCzOVTljoYW3nnK/jtpQpyql75WXXWhMKenbW851StLYbtBrzGkvMx1uxnU7ZNDT2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366543; c=relaxed/simple;
	bh=0dAUnVDLQDUXagnFhIly/XaWJNq84wC8+IfTCEctx5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kDeBPg5d15c3FGI2LJeYurpn8KQ0Tco21GyyRBHQqVL1S7bXrmMyt8+eM381oyBJILHaxKgmO6Y5eT2RbxqWHUBc+0elbZrMJLEV6dU0+Y5zXJmI36qvKVYGAbLbNqsu5SYUlvq9XjqGKXhc8R59DH4gqwsLizK4UeESy0nnEqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGXfTA+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGXfTA+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B4AC4CEE9;
	Tue, 27 May 2025 17:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366543;
	bh=0dAUnVDLQDUXagnFhIly/XaWJNq84wC8+IfTCEctx5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGXfTA+gdkIUkorz0Xwo4CkXkMoXqTJzFIv5G45ZwjJ/9sAvMfVLfr/DGFCK+BeTE
	 csVYmc38aLkJmW0dpwepfCe4HS+dZr+KSv/OTnMwGI58rS+X+F+zCfbZ0rjek0OZvY
	 nZ05FYUNMj0jrC+1uHE5L2vT5e8c0xbt3QqeDkY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 102/783] drm/amdgpu: use GFP_NOWAIT for memory allocations
Date: Tue, 27 May 2025 18:18:19 +0200
Message-ID: <20250527162517.297243864@linuxfoundation.org>
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

[ Upstream commit 16590745b571c07869ef8958e0bbe44ab6f08d1f ]

In the critical submission path memory allocations can't wait for
reclaim since that can potentially wait for submissions to finish.

Finally clean that up and mark most memory allocations in the critical
path with GFP_NOWAIT. The only exception left is the dma_fence_array()
used when no VMID is available, but that will be cleaned up later on.

Signed-off-by: Christian König <christian.koenig@amd.com>
Acked-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  8 ++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c         | 18 +++++++++++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c        | 11 +++++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c        |  4 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c       | 11 ++++++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.h       |  3 ++-
 6 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 1e998f972c308..70224b9f54f2f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -499,7 +499,7 @@ static int vm_update_pds(struct amdgpu_vm *vm, struct amdgpu_sync *sync)
 	if (ret)
 		return ret;
 
-	return amdgpu_sync_fence(sync, vm->last_update);
+	return amdgpu_sync_fence(sync, vm->last_update, GFP_KERNEL);
 }
 
 static uint64_t get_pte_flags(struct amdgpu_device *adev, struct kgd_mem *mem)
@@ -1263,7 +1263,7 @@ static int unmap_bo_from_gpuvm(struct kgd_mem *mem,
 
 	(void)amdgpu_vm_clear_freed(adev, vm, &bo_va->last_pt_update);
 
-	(void)amdgpu_sync_fence(sync, bo_va->last_pt_update);
+	(void)amdgpu_sync_fence(sync, bo_va->last_pt_update, GFP_KERNEL);
 
 	return 0;
 }
@@ -1287,7 +1287,7 @@ static int update_gpuvm_pte(struct kgd_mem *mem,
 		return ret;
 	}
 
-	return amdgpu_sync_fence(sync, bo_va->last_pt_update);
+	return amdgpu_sync_fence(sync, bo_va->last_pt_update, GFP_KERNEL);
 }
 
 static int map_bo_to_gpuvm(struct kgd_mem *mem,
@@ -2969,7 +2969,7 @@ int amdgpu_amdkfd_gpuvm_restore_process_bos(void *info, struct dma_fence __rcu *
 		}
 		dma_resv_for_each_fence(&cursor, bo->tbo.base.resv,
 					DMA_RESV_USAGE_KERNEL, fence) {
-			ret = amdgpu_sync_fence(&sync_obj, fence);
+			ret = amdgpu_sync_fence(&sync_obj, fence, GFP_KERNEL);
 			if (ret) {
 				pr_debug("Memory eviction: Sync BO fence failed. Try again\n");
 				goto validate_map_fail;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 5cc5f59e30184..4a5b406601fa2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -428,7 +428,7 @@ static int amdgpu_cs_p2_dependencies(struct amdgpu_cs_parser *p,
 			dma_fence_put(old);
 		}
 
-		r = amdgpu_sync_fence(&p->sync, fence);
+		r = amdgpu_sync_fence(&p->sync, fence, GFP_KERNEL);
 		dma_fence_put(fence);
 		if (r)
 			return r;
@@ -450,7 +450,7 @@ static int amdgpu_syncobj_lookup_and_add(struct amdgpu_cs_parser *p,
 		return r;
 	}
 
-	r = amdgpu_sync_fence(&p->sync, fence);
+	r = amdgpu_sync_fence(&p->sync, fence, GFP_KERNEL);
 	dma_fence_put(fence);
 	return r;
 }
@@ -1124,7 +1124,8 @@ static int amdgpu_cs_vm_handling(struct amdgpu_cs_parser *p)
 	if (r)
 		return r;
 
-	r = amdgpu_sync_fence(&p->sync, fpriv->prt_va->last_pt_update);
+	r = amdgpu_sync_fence(&p->sync, fpriv->prt_va->last_pt_update,
+			      GFP_KERNEL);
 	if (r)
 		return r;
 
@@ -1135,7 +1136,8 @@ static int amdgpu_cs_vm_handling(struct amdgpu_cs_parser *p)
 		if (r)
 			return r;
 
-		r = amdgpu_sync_fence(&p->sync, bo_va->last_pt_update);
+		r = amdgpu_sync_fence(&p->sync, bo_va->last_pt_update,
+				      GFP_KERNEL);
 		if (r)
 			return r;
 	}
@@ -1154,7 +1156,8 @@ static int amdgpu_cs_vm_handling(struct amdgpu_cs_parser *p)
 		if (r)
 			return r;
 
-		r = amdgpu_sync_fence(&p->sync, bo_va->last_pt_update);
+		r = amdgpu_sync_fence(&p->sync, bo_va->last_pt_update,
+				      GFP_KERNEL);
 		if (r)
 			return r;
 	}
@@ -1167,7 +1170,7 @@ static int amdgpu_cs_vm_handling(struct amdgpu_cs_parser *p)
 	if (r)
 		return r;
 
-	r = amdgpu_sync_fence(&p->sync, vm->last_update);
+	r = amdgpu_sync_fence(&p->sync, vm->last_update, GFP_KERNEL);
 	if (r)
 		return r;
 
@@ -1248,7 +1251,8 @@ static int amdgpu_cs_sync_rings(struct amdgpu_cs_parser *p)
 			continue;
 		}
 
-		r = amdgpu_sync_fence(&p->gang_leader->explicit_sync, fence);
+		r = amdgpu_sync_fence(&p->gang_leader->explicit_sync, fence,
+				      GFP_KERNEL);
 		dma_fence_put(fence);
 		if (r)
 			return r;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
index 9008b7388e897..92ab821afc06a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
@@ -209,7 +209,7 @@ static int amdgpu_vmid_grab_idle(struct amdgpu_ring *ring,
 		return 0;
 	}
 
-	fences = kmalloc_array(id_mgr->num_ids, sizeof(void *), GFP_KERNEL);
+	fences = kmalloc_array(id_mgr->num_ids, sizeof(void *), GFP_NOWAIT);
 	if (!fences)
 		return -ENOMEM;
 
@@ -313,7 +313,8 @@ static int amdgpu_vmid_grab_reserved(struct amdgpu_vm *vm,
 	/* Good we can use this VMID. Remember this submission as
 	* user of the VMID.
 	*/
-	r = amdgpu_sync_fence(&(*id)->active, &job->base.s_fence->finished);
+	r = amdgpu_sync_fence(&(*id)->active, &job->base.s_fence->finished,
+			      GFP_NOWAIT);
 	if (r)
 		return r;
 
@@ -372,7 +373,8 @@ static int amdgpu_vmid_grab_used(struct amdgpu_vm *vm,
 		 * user of the VMID.
 		 */
 		r = amdgpu_sync_fence(&(*id)->active,
-				      &job->base.s_fence->finished);
+				      &job->base.s_fence->finished,
+				      GFP_NOWAIT);
 		if (r)
 			return r;
 
@@ -424,7 +426,8 @@ int amdgpu_vmid_grab(struct amdgpu_vm *vm, struct amdgpu_ring *ring,
 
 			/* Remember this submission as user of the VMID */
 			r = amdgpu_sync_fence(&id->active,
-					      &job->base.s_fence->finished);
+					      &job->base.s_fence->finished,
+					      GFP_NOWAIT);
 			if (r)
 				goto error;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
index 6fa20980a0b15..e4251d0691c9c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -1335,14 +1335,14 @@ int amdgpu_mes_ctx_map_meta_data(struct amdgpu_device *adev,
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
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
index d75715b3f1870..34fc742fda91d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
@@ -152,7 +152,8 @@ static bool amdgpu_sync_add_later(struct amdgpu_sync *sync, struct dma_fence *f)
  *
  * Add the fence to the sync object.
  */
-int amdgpu_sync_fence(struct amdgpu_sync *sync, struct dma_fence *f)
+int amdgpu_sync_fence(struct amdgpu_sync *sync, struct dma_fence *f,
+		      gfp_t flags)
 {
 	struct amdgpu_sync_entry *e;
 
@@ -162,7 +163,7 @@ int amdgpu_sync_fence(struct amdgpu_sync *sync, struct dma_fence *f)
 	if (amdgpu_sync_add_later(sync, f))
 		return 0;
 
-	e = kmem_cache_alloc(amdgpu_sync_slab, GFP_KERNEL);
+	e = kmem_cache_alloc(amdgpu_sync_slab, flags);
 	if (!e)
 		return -ENOMEM;
 
@@ -249,7 +250,7 @@ int amdgpu_sync_resv(struct amdgpu_device *adev, struct amdgpu_sync *sync,
 			struct dma_fence *tmp = dma_fence_chain_contained(f);
 
 			if (amdgpu_sync_test_fence(adev, mode, owner, tmp)) {
-				r = amdgpu_sync_fence(sync, f);
+				r = amdgpu_sync_fence(sync, f, GFP_KERNEL);
 				dma_fence_put(f);
 				if (r)
 					return r;
@@ -281,7 +282,7 @@ int amdgpu_sync_kfd(struct amdgpu_sync *sync, struct dma_resv *resv)
 		if (fence_owner != AMDGPU_FENCE_OWNER_KFD)
 			continue;
 
-		r = amdgpu_sync_fence(sync, f);
+		r = amdgpu_sync_fence(sync, f, GFP_KERNEL);
 		if (r)
 			break;
 	}
@@ -388,7 +389,7 @@ int amdgpu_sync_clone(struct amdgpu_sync *source, struct amdgpu_sync *clone)
 	hash_for_each_safe(source->fences, i, tmp, e, node) {
 		f = e->fence;
 		if (!dma_fence_is_signaled(f)) {
-			r = amdgpu_sync_fence(clone, f);
+			r = amdgpu_sync_fence(clone, f, GFP_KERNEL);
 			if (r)
 				return r;
 		} else {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.h
index a91a8eaf808b1..51eb4382c91eb 100644
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
-- 
2.39.5



