Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414EF47F761;
	Thu, 20 Aug 2026 16:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244381; cv=none; b=lTxhOloOVUtbYnICW7XEf90AE8rdKmtYW23KeENKiI6/NXnR4xYQb3GkwMyKlGCqVdXb7Yv0h7wRzRCtfubRocm68AFd7t1MYtZwy7RHb4Go6J8xtEa4gRVGwahs5/GkROenpOKLvBL5MndQLB+8Y/o+NfgCqA2luRHgxmMLna0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244381; c=relaxed/simple;
	bh=gqr/SPa6ziE+HhvtGmiiGM6y5Hq0sFJEfCp7NMOMbQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PzAUe2sp5lz2hXEx0NTj28UGaO39dY7COzND1MMFeH02qR8nhPAXo/SXLxmp+frcVMrO8SwBNOUGyOEGWk5EHKynyg7ihMwWZ46rHD2YrW53pdC8Zx54rL5E+HCDQ15CDjtVhJ7m1YwjbmWnIiY2sBWKJHQq9tSTeo8a8pv/qVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfNYCOyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfNYCOyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937E01F000E9;
	Thu, 20 Aug 2026 16:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244380;
	bh=1TBQMJb/rqcgeKX/IHycYbf1lc67rInDe+Yk94cMV8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vfNYCOylzlsWqucDHxcvXABQNX+Yl0tu65/k/FjSJBOqlKLroQO4VSoz+fJh5zKJy
	 mtHgNeAbAi9h0D8zG77PzSLHtSGmSo5DtYzK4UsmI44oy30oqEEYOwit/SuY0Kd2tD
	 v/0Dd9+J1qVlf9ImdC2jQprANyWtA/LhdY3cmKLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/235] dma-buf/drivers: make reserving a shared slot mandatory v4
Date: Thu, 20 Aug 2026 16:56:26 +0200
Message-ID: <20260820145220.994042087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit c8d4c18bfbc4ab467188dbe45cc8155759f49d9e ]

Audit all the users of dma_resv_add_excl_fence() and make sure they
reserve a shared slot also when only trying to add an exclusive fence.

This is the next step towards handling the exclusive fence like a
shared one.

v2: fix missed case in amdgpu
v3: and two more radeon, rename function
v4: add one more case to TTM, fix i915 after rebase

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220406075132.3263-2-christian.koenig@amd.com
Stable-dep-of: a48bbcc7ac73 ("drm/virtio: use uninterruptible resv lock for plane updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-resv.c                       |    8 ++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    4 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c           |    2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c     |    2 +-
 drivers/gpu/drm/i915/i915_vma.c                  |    2 +-
 drivers/gpu/drm/lima/lima_gem.c                  |    2 +-
 drivers/gpu/drm/msm/msm_gem_submit.c             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c          |    2 +-
 drivers/gpu/drm/qxl/qxl_release.c                |    2 +-
 drivers/gpu/drm/radeon/radeon_vm.c               |    2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                     |    4 ++--
 drivers/gpu/drm/ttm/ttm_execbuf_util.c           |    4 ++--
 drivers/gpu/drm/vc4/vc4_gem.c                    |    2 +-
 drivers/gpu/drm/vgem/vgem_fence.c                |    2 +-
 include/linux/dma-resv.h                         |    2 +-
 15 files changed, 21 insertions(+), 21 deletions(-)

--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -173,7 +173,7 @@ void dma_resv_fini(struct dma_resv *obj)
 EXPORT_SYMBOL(dma_resv_fini);
 
 /**
- * dma_resv_reserve_shared - Reserve space to add shared fences to
+ * dma_resv_reserve_fences - Reserve space to add shared fences to
  * a dma_resv.
  * @obj: reservation object
  * @num_fences: number of fences we want to add
@@ -184,7 +184,7 @@ EXPORT_SYMBOL(dma_resv_fini);
  * RETURNS
  * Zero for success, or -errno
  */
-int dma_resv_reserve_shared(struct dma_resv *obj, unsigned int num_fences)
+int dma_resv_reserve_fences(struct dma_resv *obj, unsigned int num_fences)
 {
 	struct dma_resv_list *old, *new;
 	unsigned int i, j, k, max;
@@ -250,7 +250,7 @@ int dma_resv_reserve_shared(struct dma_r
 
 	return 0;
 }
-EXPORT_SYMBOL(dma_resv_reserve_shared);
+EXPORT_SYMBOL(dma_resv_reserve_fences);
 
 /**
  * dma_resv_add_shared_fence - Add a fence to a shared slot
@@ -258,7 +258,7 @@ EXPORT_SYMBOL(dma_resv_reserve_shared);
  * @fence: the shared fence to add
  *
  * Add a fence to a shared slot, obj->lock must be held, and
- * dma_resv_reserve_shared() has been called.
+ * dma_resv_reserve_fences() has been called.
  */
 void dma_resv_add_shared_fence(struct dma_resv *obj, struct dma_fence *fence)
 {
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -950,7 +950,7 @@ static int init_kfd_vm(struct amdgpu_vm
 				  AMDGPU_FENCE_OWNER_KFD, false);
 	if (ret)
 		goto wait_pd_fail;
-	ret = dma_resv_reserve_shared(vm->root.base.bo->tbo.base.resv, 1);
+	ret = dma_resv_reserve_fences(vm->root.base.bo->tbo.base.resv, 1);
 	if (ret)
 		goto reserve_shared_fail;
 	amdgpu_bo_fence(vm->root.base.bo,
@@ -2205,7 +2205,7 @@ int amdgpu_amdkfd_add_gws_to_process(voi
 	 * Add process eviction fence to bo so they can
 	 * evict each other.
 	 */
-	ret = dma_resv_reserve_shared(gws_bo->tbo.base.resv, 1);
+	ret = dma_resv_reserve_fences(gws_bo->tbo.base.resv, 1);
 	if (ret)
 		goto reserve_shared_fail;
 	amdgpu_bo_fence(gws_bo, &process_info->eviction_fence->base, true);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2904,7 +2904,7 @@ int amdgpu_vm_init(struct amdgpu_device
 	if (r)
 		goto error_free_root;
 
-	r = dma_resv_reserve_shared(root->tbo.base.resv, 1);
+	r = dma_resv_reserve_fences(root->tbo.base.resv, 1);
 	if (r)
 		goto error_unreserve;
 
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
@@ -180,7 +180,7 @@ static int submit_fence_sync(struct etna
 		struct dma_resv *robj = bo->obj->base.resv;
 
 		if (!(bo->flags & ETNA_SUBMIT_BO_WRITE)) {
-			ret = dma_resv_reserve_shared(robj, 1);
+			ret = dma_resv_reserve_fences(robj, 1);
 			if (ret)
 				return ret;
 		}
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -1241,7 +1241,7 @@ int i915_vma_move_to_active(struct i915_
 		obj->write_domain = I915_GEM_DOMAIN_RENDER;
 		obj->read_domains = 0;
 	} else {
-		err = dma_resv_reserve_shared(vma->resv, 1);
+		err = dma_resv_reserve_fences(vma->resv, 1);
 		if (unlikely(err))
 			return err;
 
--- a/drivers/gpu/drm/lima/lima_gem.c
+++ b/drivers/gpu/drm/lima/lima_gem.c
@@ -263,7 +263,7 @@ static int lima_gem_sync_bo(struct lima_
 	int err = 0;
 
 	if (!write) {
-		err = dma_resv_reserve_shared(lima_bo_resv(bo), 1);
+		err = dma_resv_reserve_fences(lima_bo_resv(bo), 1);
 		if (err)
 			return err;
 	}
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -230,7 +230,7 @@ static int submit_fence_sync(struct msm_
 			 * strange place to call it.  OTOH this is a
 			 * convenient can-fail point to hook it in.
 			 */
-			ret = dma_resv_reserve_shared(msm_obj->base.resv,
+			ret = dma_resv_reserve_fences(msm_obj->base.resv,
 								1);
 			if (ret)
 				return ret;
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -349,7 +349,7 @@ nouveau_fence_sync(struct nouveau_bo *nv
 	int ret = 0, i;
 
 	if (!exclusive) {
-		ret = dma_resv_reserve_shared(resv, 1);
+		ret = dma_resv_reserve_fences(resv, 1);
 
 		if (ret)
 			return ret;
--- a/drivers/gpu/drm/qxl/qxl_release.c
+++ b/drivers/gpu/drm/qxl/qxl_release.c
@@ -239,7 +239,7 @@ static int qxl_release_validate_bo(struc
 			return ret;
 	}
 
-	ret = dma_resv_reserve_shared(bo->tbo.base.resv, 1);
+	ret = dma_resv_reserve_fences(bo->tbo.base.resv, 1);
 	if (ret)
 		return ret;
 
--- a/drivers/gpu/drm/radeon/radeon_vm.c
+++ b/drivers/gpu/drm/radeon/radeon_vm.c
@@ -831,7 +831,7 @@ static int radeon_vm_update_ptes(struct
 		int r;
 
 		radeon_sync_resv(rdev, &ib->sync, pt->tbo.base.resv, true);
-		r = dma_resv_reserve_shared(pt->tbo.base.resv, 1);
+		r = dma_resv_reserve_fences(pt->tbo.base.resv, 1);
 		if (r)
 			return r;
 
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -830,7 +830,7 @@ static int ttm_bo_add_move_fence(struct
 
 	dma_resv_add_shared_fence(bo->base.resv, fence);
 
-	ret = dma_resv_reserve_shared(bo->base.resv, 1);
+	ret = dma_resv_reserve_fences(bo->base.resv, 1);
 	if (unlikely(ret)) {
 		dma_fence_put(fence);
 		return ret;
@@ -950,7 +950,7 @@ int ttm_bo_mem_space(struct ttm_buffer_o
 	bool type_found = false;
 	int i, ret;
 
-	ret = dma_resv_reserve_shared(bo->base.resv, 1);
+	ret = dma_resv_reserve_fences(bo->base.resv, 1);
 	if (unlikely(ret))
 		return ret;
 
--- a/drivers/gpu/drm/ttm/ttm_execbuf_util.c
+++ b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
@@ -106,7 +106,7 @@ int ttm_eu_reserve_buffers(struct ww_acq
 			if (!entry->num_shared)
 				continue;
 
-			ret = dma_resv_reserve_shared(bo->base.resv,
+			ret = dma_resv_reserve_fences(bo->base.resv,
 								entry->num_shared);
 			if (!ret)
 				continue;
@@ -123,7 +123,7 @@ int ttm_eu_reserve_buffers(struct ww_acq
 		}
 
 		if (!ret && entry->num_shared)
-			ret = dma_resv_reserve_shared(bo->base.resv,
+			ret = dma_resv_reserve_fences(bo->base.resv,
 								entry->num_shared);
 
 		if (unlikely(ret != 0)) {
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -644,7 +644,7 @@ retry:
 	for (i = 0; i < exec->bo_count; i++) {
 		bo = &exec->bo[i]->base;
 
-		ret = dma_resv_reserve_shared(bo->resv, 1);
+		ret = dma_resv_reserve_fences(bo->resv, 1);
 		if (ret) {
 			vc4_unlock_bo_reservations(dev, exec, acquire_ctx);
 			return ret;
--- a/drivers/gpu/drm/vgem/vgem_fence.c
+++ b/drivers/gpu/drm/vgem/vgem_fence.c
@@ -162,7 +162,7 @@ int vgem_fence_attach_ioctl(struct drm_d
 	dma_resv_lock(resv, NULL);
 	if (arg->flags & VGEM_FENCE_WRITE)
 		dma_resv_add_excl_fence(resv, fence);
-	else if ((ret = dma_resv_reserve_shared(resv, 1)) == 0)
+	else if ((ret = dma_resv_reserve_fences(resv, 1)) == 0)
 		dma_resv_add_shared_fence(resv, fence);
 	dma_resv_unlock(resv);
 
--- a/include/linux/dma-resv.h
+++ b/include/linux/dma-resv.h
@@ -273,7 +273,7 @@ dma_resv_get_excl_rcu(struct dma_resv *o
 
 void dma_resv_init(struct dma_resv *obj);
 void dma_resv_fini(struct dma_resv *obj);
-int dma_resv_reserve_shared(struct dma_resv *obj, unsigned int num_fences);
+int dma_resv_reserve_fences(struct dma_resv *obj, unsigned int num_fences);
 void dma_resv_add_shared_fence(struct dma_resv *obj, struct dma_fence *fence);
 
 void dma_resv_add_excl_fence(struct dma_resv *obj, struct dma_fence *fence);


