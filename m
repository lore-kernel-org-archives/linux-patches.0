Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0626F254844;
	Mon, 23 Jun 2025 13:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684917; cv=none; b=OJV8WL5cmiW5221USXtwOvimcXRb2+4+JM4K8hrRVuwhZLey4RuzsiQSmuR5v++JS4Lg+5Yebqft62P/nVh+azYdouHxypPTzZMZdB8lXNLHVCDwlhjNzpS1BSj6YHhv1Lq0cbHy/YiCKZubfjejXhqhqabxPo0YVE8wT4Je81g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684917; c=relaxed/simple;
	bh=XZcfl35K7Qt5gwX9t8iRJ4x82FS+xN0NVc3K7sw46vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cShgwWT0yZf+baK8neRFQkJF5HMSwkEd/rjSi4bxorbPeWbw1B50m5K8TE7KlC+/DRNNYjCp4Y1hP0o2eAq911XX9HfcolIdgLmnDDJZTZpiRNRw8hYoexTbvW1ULut4mzuyLeFQshx46oV6UX5nrQlsKMOti56Caq7y8q8P1jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpPAMCGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpPAMCGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C916C4CEEA;
	Mon, 23 Jun 2025 13:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684916;
	bh=XZcfl35K7Qt5gwX9t8iRJ4x82FS+xN0NVc3K7sw46vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpPAMCGSf6yPmNQxYYacOtVtziqNN8VFn3QjJ/zIXcVJUEeGPfjGRLPPRGbuRKECA
	 sCH+HQAb+AbUqTmSCYF3C91Yygr299+B5WK4FDabLCuc8T9sWZ5E2AoS+FUEOFGE80
	 AlJg7HUy14c+XxJwWAup0+Jw3X+lrxQgW6q0HHTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.15 190/592] accel/ivpu: Improve buffer object logging
Date: Mon, 23 Jun 2025 15:02:28 +0200
Message-ID: <20250623130704.803095236@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit a01e93ee44f7ed76f872d0ede82f8d31bf0a048a upstream.

- Fix missing alloc log when drm_gem_handle_create() fails in
  drm_vma_node_allow() and open callback is not called
- Add ivpu_bo->ctx_id that enables to log the actual context
  id instead of using 0 as default
- Add couple WARNs and errors so we can catch more memory
  corruption issues

Fixes: 37dee2a2f433 ("accel/ivpu: Improve buffer object debug logs")
Cc: stable@vger.kernel.org # v6.8+
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://lore.kernel.org/r/20250506091303.262034-1-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_gem.c |   25 +++++++++++++++++--------
 drivers/accel/ivpu/ivpu_gem.h |    1 +
 2 files changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -28,7 +28,7 @@ static inline void ivpu_dbg_bo(struct iv
 {
 	ivpu_dbg(vdev, BO,
 		 "%6s: bo %8p vpu_addr %9llx size %8zu ctx %d has_pages %d dma_mapped %d mmu_mapped %d wc %d imported %d\n",
-		 action, bo, bo->vpu_addr, ivpu_bo_size(bo), bo->ctx ? bo->ctx->id : 0,
+		 action, bo, bo->vpu_addr, ivpu_bo_size(bo), bo->ctx_id,
 		 (bool)bo->base.pages, (bool)bo->base.sgt, bo->mmu_mapped, bo->base.map_wc,
 		 (bool)bo->base.base.import_attach);
 }
@@ -94,8 +94,6 @@ ivpu_bo_alloc_vpu_addr(struct ivpu_bo *b
 		ivpu_err(vdev, "Failed to add BO to context %u: %d\n", ctx->id, ret);
 	}
 
-	ivpu_dbg_bo(vdev, bo, "alloc");
-
 	mutex_unlock(&bo->lock);
 
 	drm_dev_exit(idx);
@@ -215,7 +213,7 @@ fail_detach:
 	return ERR_PTR(ret);
 }
 
-static struct ivpu_bo *ivpu_bo_alloc(struct ivpu_device *vdev, u64 size, u32 flags)
+static struct ivpu_bo *ivpu_bo_alloc(struct ivpu_device *vdev, u64 size, u32 flags, u32 ctx_id)
 {
 	struct drm_gem_shmem_object *shmem;
 	struct ivpu_bo *bo;
@@ -233,6 +231,7 @@ static struct ivpu_bo *ivpu_bo_alloc(str
 		return ERR_CAST(shmem);
 
 	bo = to_ivpu_bo(&shmem->base);
+	bo->ctx_id = ctx_id;
 	bo->base.map_wc = flags & DRM_IVPU_BO_WC;
 	bo->flags = flags;
 
@@ -240,6 +239,8 @@ static struct ivpu_bo *ivpu_bo_alloc(str
 	list_add_tail(&bo->bo_list_node, &vdev->bo_list);
 	mutex_unlock(&vdev->bo_list_lock);
 
+	ivpu_dbg_bo(vdev, bo, "alloc");
+
 	return bo;
 }
 
@@ -278,8 +279,13 @@ static void ivpu_gem_bo_free(struct drm_
 	mutex_unlock(&vdev->bo_list_lock);
 
 	drm_WARN_ON(&vdev->drm, !dma_resv_test_signaled(obj->resv, DMA_RESV_USAGE_READ));
+	drm_WARN_ON(&vdev->drm, ivpu_bo_size(bo) == 0);
+	drm_WARN_ON(&vdev->drm, bo->base.vaddr);
 
 	ivpu_bo_unbind_locked(bo);
+	drm_WARN_ON(&vdev->drm, bo->mmu_mapped);
+	drm_WARN_ON(&vdev->drm, bo->ctx);
+
 	mutex_destroy(&bo->lock);
 
 	drm_WARN_ON(obj->dev, bo->base.pages_use_count > 1);
@@ -314,7 +320,7 @@ int ivpu_bo_create_ioctl(struct drm_devi
 	if (size == 0)
 		return -EINVAL;
 
-	bo = ivpu_bo_alloc(vdev, size, args->flags);
+	bo = ivpu_bo_alloc(vdev, size, args->flags, file_priv->ctx.id);
 	if (IS_ERR(bo)) {
 		ivpu_err(vdev, "Failed to allocate BO: %pe (ctx %u size %llu flags 0x%x)",
 			 bo, file_priv->ctx.id, args->size, args->flags);
@@ -322,7 +328,10 @@ int ivpu_bo_create_ioctl(struct drm_devi
 	}
 
 	ret = drm_gem_handle_create(file, &bo->base.base, &args->handle);
-	if (!ret)
+	if (ret)
+		ivpu_err(vdev, "Failed to create handle for BO: %pe (ctx %u size %llu flags 0x%x)",
+			 bo, file_priv->ctx.id, args->size, args->flags);
+	else
 		args->vpu_addr = bo->vpu_addr;
 
 	drm_gem_object_put(&bo->base.base);
@@ -345,7 +354,7 @@ ivpu_bo_create(struct ivpu_device *vdev,
 	drm_WARN_ON(&vdev->drm, !PAGE_ALIGNED(range->end));
 	drm_WARN_ON(&vdev->drm, !PAGE_ALIGNED(size));
 
-	bo = ivpu_bo_alloc(vdev, size, flags);
+	bo = ivpu_bo_alloc(vdev, size, flags, IVPU_GLOBAL_CONTEXT_MMU_SSID);
 	if (IS_ERR(bo)) {
 		ivpu_err(vdev, "Failed to allocate BO: %pe (vpu_addr 0x%llx size %llu flags 0x%x)",
 			 bo, range->start, size, flags);
@@ -452,7 +461,7 @@ static void ivpu_bo_print_info(struct iv
 	mutex_lock(&bo->lock);
 
 	drm_printf(p, "%-9p %-3u 0x%-12llx %-10lu 0x%-8x %-4u",
-		   bo, bo->ctx ? bo->ctx->id : 0, bo->vpu_addr, bo->base.base.size,
+		   bo, bo->ctx_id, bo->vpu_addr, bo->base.base.size,
 		   bo->flags, kref_read(&bo->base.base.refcount));
 
 	if (bo->base.pages)
--- a/drivers/accel/ivpu/ivpu_gem.h
+++ b/drivers/accel/ivpu/ivpu_gem.h
@@ -21,6 +21,7 @@ struct ivpu_bo {
 	u64 vpu_addr;
 	u32 flags;
 	u32 job_status; /* Valid only for command buffer */
+	u32 ctx_id;
 	bool mmu_mapped;
 };
 


