Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF0B14389E;
	Tue, 23 Apr 2024 21:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908654; cv=none; b=LhZObEUeao8OVppHkMvzEnUBvDwD5pvz0/yhwOMDLSXIQoic2bj3Ir3OgcKk5pl7/h6+UpujlXXSeFAU7hoAfuqi1CjNwTwizT9hvovaxq1Ul4koi+Z7/wy4kUQSbIN/i6UMY+OHvK3s5HzsXfXrF02ZA9pTmiIC9L8Dz5Oxy3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908654; c=relaxed/simple;
	bh=8stEjvJy9UbW5dUwtBTKWWN5BT6CsvGwDI+W2uvfE/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQ5JUG9LVkPzc2vMUcvW4GbQjx2FJCdcFx7KmOI+4+vF9pDwa4fxvM67qJioFIjhFI1XXZF9l8IRcXjEg0TQWTF+77d4k/NAiStu9ZysyOI5Fyc/wT/hUEAZ7Kf+11MZmPt4H1wozPRzy8q98c3ri+MEpqiIY1npCBvHiEZxAlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIZtjfwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIZtjfwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAEAC116B1;
	Tue, 23 Apr 2024 21:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908654;
	bh=8stEjvJy9UbW5dUwtBTKWWN5BT6CsvGwDI+W2uvfE/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIZtjfwdAyeoPi/mOX/U4FBxGSDPYev85uJb/rJu4NnOSJMG4fUkSzqNgMWQxqBet
	 T3nOmgY5IL2m6VLg0sdP0h+i7ty3x7hwzDtkX27xYZZMUCCqF4ahVPpbq33BqpmhV1
	 JTTC23w15g+G2xklKipfzZN2Imm/jPOl/LuTmRQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Martin Krastev <martin.krastev@broadcom.com>
Subject: [PATCH 6.6 144/158] drm/vmwgfx: Fix prime import/export
Date: Tue, 23 Apr 2024 14:39:41 -0700
Message-ID: <20240423213900.362449350@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit b32233accefff1338806f064fb9b62cf5bc0609f upstream.

vmwgfx never supported prime import of external buffers. Furthermore the
driver exposes two different objects to userspace: vmw_surface's and
gem buffers but prime import/export only worked with vmw_surfaces.

Because gem buffers are used through the dumb_buffer interface this meant
that the driver created buffers couldn't have been prime exported or
imported.

Fix prime import/export. Makes IGT's kms_prime pass.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Fixes: 8afa13a0583f ("drm/vmwgfx: Implement DRIVER_GEM")
Cc: <stable@vger.kernel.org> # v6.6+
Reviewed-by: Martin Krastev <martin.krastev@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240412025511.78553-4-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_blit.c       |   35 +++++++++++++++++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c         |    7 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.h         |    2 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c        |    1 
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h        |    3 +
 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c        |   32 +++++++++++++++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_prime.c      |   15 ++++++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c |   44 +++++++++++++++++++----------
 8 files changed, 117 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_blit.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_blit.c
@@ -456,8 +456,10 @@ int vmw_bo_cpu_blit(struct ttm_buffer_ob
 		.no_wait_gpu = false
 	};
 	u32 j, initial_line = dst_offset / dst_stride;
-	struct vmw_bo_blit_line_data d;
+	struct vmw_bo_blit_line_data d = {0};
 	int ret = 0;
+	struct page **dst_pages = NULL;
+	struct page **src_pages = NULL;
 
 	/* Buffer objects need to be either pinned or reserved: */
 	if (!(dst->pin_count))
@@ -477,12 +479,35 @@ int vmw_bo_cpu_blit(struct ttm_buffer_ob
 			return ret;
 	}
 
+	if (!src->ttm->pages && src->ttm->sg) {
+		src_pages = kvmalloc_array(src->ttm->num_pages,
+					   sizeof(struct page *), GFP_KERNEL);
+		if (!src_pages)
+			return -ENOMEM;
+		ret = drm_prime_sg_to_page_array(src->ttm->sg, src_pages,
+						 src->ttm->num_pages);
+		if (ret)
+			goto out;
+	}
+	if (!dst->ttm->pages && dst->ttm->sg) {
+		dst_pages = kvmalloc_array(dst->ttm->num_pages,
+					   sizeof(struct page *), GFP_KERNEL);
+		if (!dst_pages) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = drm_prime_sg_to_page_array(dst->ttm->sg, dst_pages,
+						 dst->ttm->num_pages);
+		if (ret)
+			goto out;
+	}
+
 	d.mapped_dst = 0;
 	d.mapped_src = 0;
 	d.dst_addr = NULL;
 	d.src_addr = NULL;
-	d.dst_pages = dst->ttm->pages;
-	d.src_pages = src->ttm->pages;
+	d.dst_pages = dst->ttm->pages ? dst->ttm->pages : dst_pages;
+	d.src_pages = src->ttm->pages ? src->ttm->pages : src_pages;
 	d.dst_num_pages = PFN_UP(dst->resource->size);
 	d.src_num_pages = PFN_UP(src->resource->size);
 	d.dst_prot = ttm_io_prot(dst, dst->resource, PAGE_KERNEL);
@@ -504,6 +529,10 @@ out:
 		kunmap_atomic(d.src_addr);
 	if (d.dst_addr)
 		kunmap_atomic(d.dst_addr);
+	if (src_pages)
+		kvfree(src_pages);
+	if (dst_pages)
+		kvfree(dst_pages);
 
 	return ret;
 }
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -377,7 +377,8 @@ static int vmw_bo_init(struct vmw_privat
 {
 	struct ttm_operation_ctx ctx = {
 		.interruptible = params->bo_type != ttm_bo_type_kernel,
-		.no_wait_gpu = false
+		.no_wait_gpu = false,
+		.resv = params->resv,
 	};
 	struct ttm_device *bdev = &dev_priv->bdev;
 	struct drm_device *vdev = &dev_priv->drm;
@@ -394,8 +395,8 @@ static int vmw_bo_init(struct vmw_privat
 
 	vmw_bo_placement_set(vmw_bo, params->domain, params->busy_domain);
 	ret = ttm_bo_init_reserved(bdev, &vmw_bo->tbo, params->bo_type,
-				   &vmw_bo->placement, 0, &ctx, NULL,
-				   NULL, destroy);
+				   &vmw_bo->placement, 0, &ctx,
+				   params->sg, params->resv, destroy);
 	if (unlikely(ret))
 		return ret;
 
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
@@ -55,6 +55,8 @@ struct vmw_bo_params {
 	enum ttm_bo_type bo_type;
 	size_t size;
 	bool pin;
+	struct dma_resv *resv;
+	struct sg_table *sg;
 };
 
 /**
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -1628,6 +1628,7 @@ static const struct drm_driver driver =
 
 	.prime_fd_to_handle = vmw_prime_fd_to_handle,
 	.prime_handle_to_fd = vmw_prime_handle_to_fd,
+	.gem_prime_import_sg_table = vmw_prime_import_sg_table,
 
 	.fops = &vmwgfx_driver_fops,
 	.name = VMWGFX_DRIVER_NAME,
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -1131,6 +1131,9 @@ extern int vmw_prime_handle_to_fd(struct
 				  struct drm_file *file_priv,
 				  uint32_t handle, uint32_t flags,
 				  int *prime_fd);
+struct drm_gem_object *vmw_prime_import_sg_table(struct drm_device *dev,
+						 struct dma_buf_attachment *attach,
+						 struct sg_table *table);
 
 /*
  * MemoryOBject management -  vmwgfx_mob.c
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
@@ -149,6 +149,38 @@ out_no_bo:
 	return ret;
 }
 
+struct drm_gem_object *vmw_prime_import_sg_table(struct drm_device *dev,
+						 struct dma_buf_attachment *attach,
+						 struct sg_table *table)
+{
+	int ret;
+	struct vmw_private *dev_priv = vmw_priv(dev);
+	struct drm_gem_object *gem = NULL;
+	struct vmw_bo *vbo;
+	struct vmw_bo_params params = {
+		.domain = (dev_priv->has_mob) ? VMW_BO_DOMAIN_SYS : VMW_BO_DOMAIN_VRAM,
+		.busy_domain = VMW_BO_DOMAIN_SYS,
+		.bo_type = ttm_bo_type_sg,
+		.size = attach->dmabuf->size,
+		.pin = false,
+		.resv = attach->dmabuf->resv,
+		.sg = table,
+
+	};
+
+	dma_resv_lock(params.resv, NULL);
+
+	ret = vmw_bo_create(dev_priv, &params, &vbo);
+	if (ret != 0)
+		goto out_no_bo;
+
+	vbo->tbo.base.funcs = &vmw_gem_object_funcs;
+
+	gem = &vbo->tbo.base;
+out_no_bo:
+	dma_resv_unlock(params.resv);
+	return gem;
+}
 
 int vmw_gem_object_create_ioctl(struct drm_device *dev, void *data,
 				struct drm_file *filp)
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
@@ -75,8 +75,12 @@ int vmw_prime_fd_to_handle(struct drm_de
 			   int fd, u32 *handle)
 {
 	struct ttm_object_file *tfile = vmw_fpriv(file_priv)->tfile;
+	int ret = ttm_prime_fd_to_handle(tfile, fd, handle);
 
-	return ttm_prime_fd_to_handle(tfile, fd, handle);
+	if (ret)
+		ret = drm_gem_prime_fd_to_handle(dev, file_priv, fd, handle);
+
+	return ret;
 }
 
 int vmw_prime_handle_to_fd(struct drm_device *dev,
@@ -85,5 +89,12 @@ int vmw_prime_handle_to_fd(struct drm_de
 			   int *prime_fd)
 {
 	struct ttm_object_file *tfile = vmw_fpriv(file_priv)->tfile;
-	return ttm_prime_handle_to_fd(tfile, handle, flags, prime_fd);
+	int ret;
+
+	if (handle > VMWGFX_NUM_MOB)
+		ret = ttm_prime_handle_to_fd(tfile, handle, flags, prime_fd);
+	else
+		ret = drm_gem_prime_handle_to_fd(dev, file_priv, handle, flags, prime_fd);
+
+	return ret;
 }
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
@@ -220,13 +220,18 @@ static int vmw_ttm_map_dma(struct vmw_tt
 	switch (dev_priv->map_mode) {
 	case vmw_dma_map_bind:
 	case vmw_dma_map_populate:
-		vsgt->sgt = &vmw_tt->sgt;
-		ret = sg_alloc_table_from_pages_segment(
-			&vmw_tt->sgt, vsgt->pages, vsgt->num_pages, 0,
-			(unsigned long)vsgt->num_pages << PAGE_SHIFT,
-			dma_get_max_seg_size(dev_priv->drm.dev), GFP_KERNEL);
-		if (ret)
-			goto out_sg_alloc_fail;
+		if (vmw_tt->dma_ttm.page_flags  & TTM_TT_FLAG_EXTERNAL) {
+			vsgt->sgt = vmw_tt->dma_ttm.sg;
+		} else {
+			vsgt->sgt = &vmw_tt->sgt;
+			ret = sg_alloc_table_from_pages_segment(&vmw_tt->sgt,
+				vsgt->pages, vsgt->num_pages, 0,
+				(unsigned long)vsgt->num_pages << PAGE_SHIFT,
+				dma_get_max_seg_size(dev_priv->drm.dev),
+				GFP_KERNEL);
+			if (ret)
+				goto out_sg_alloc_fail;
+		}
 
 		ret = vmw_ttm_map_for_dma(vmw_tt);
 		if (unlikely(ret != 0))
@@ -241,8 +246,9 @@ static int vmw_ttm_map_dma(struct vmw_tt
 	return 0;
 
 out_map_fail:
-	sg_free_table(vmw_tt->vsgt.sgt);
-	vmw_tt->vsgt.sgt = NULL;
+	drm_warn(&dev_priv->drm, "VSG table map failed!");
+	sg_free_table(vsgt->sgt);
+	vsgt->sgt = NULL;
 out_sg_alloc_fail:
 	return ret;
 }
@@ -388,15 +394,17 @@ static void vmw_ttm_destroy(struct ttm_d
 static int vmw_ttm_populate(struct ttm_device *bdev,
 			    struct ttm_tt *ttm, struct ttm_operation_ctx *ctx)
 {
-	int ret;
+	bool external = (ttm->page_flags & TTM_TT_FLAG_EXTERNAL) != 0;
 
-	/* TODO: maybe completely drop this ? */
 	if (ttm_tt_is_populated(ttm))
 		return 0;
 
-	ret = ttm_pool_alloc(&bdev->pool, ttm, ctx);
+	if (external && ttm->sg)
+		return  drm_prime_sg_to_dma_addr_array(ttm->sg,
+						       ttm->dma_address,
+						       ttm->num_pages);
 
-	return ret;
+	return ttm_pool_alloc(&bdev->pool, ttm, ctx);
 }
 
 static void vmw_ttm_unpopulate(struct ttm_device *bdev,
@@ -404,6 +412,10 @@ static void vmw_ttm_unpopulate(struct tt
 {
 	struct vmw_ttm_tt *vmw_tt = container_of(ttm, struct vmw_ttm_tt,
 						 dma_ttm);
+	bool external = (ttm->page_flags & TTM_TT_FLAG_EXTERNAL) != 0;
+
+	if (external)
+		return;
 
 	vmw_ttm_unbind(bdev, ttm);
 
@@ -422,6 +434,7 @@ static struct ttm_tt *vmw_ttm_tt_create(
 {
 	struct vmw_ttm_tt *vmw_be;
 	int ret;
+	bool external = bo->type == ttm_bo_type_sg;
 
 	vmw_be = kzalloc(sizeof(*vmw_be), GFP_KERNEL);
 	if (!vmw_be)
@@ -430,7 +443,10 @@ static struct ttm_tt *vmw_ttm_tt_create(
 	vmw_be->dev_priv = vmw_priv_from_ttm(bo->bdev);
 	vmw_be->mob = NULL;
 
-	if (vmw_be->dev_priv->map_mode == vmw_dma_alloc_coherent)
+	if (external)
+		page_flags |= TTM_TT_FLAG_EXTERNAL | TTM_TT_FLAG_EXTERNAL_MAPPABLE;
+
+	if (vmw_be->dev_priv->map_mode == vmw_dma_alloc_coherent || external)
 		ret = ttm_sg_tt_init(&vmw_be->dma_ttm, bo, page_flags,
 				     ttm_cached);
 	else


