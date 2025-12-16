Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CAA2D97B8;
	Tue, 16 Dec 2025 11:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885012; cv=none; b=sPKUhTV6aUdrh9ji0qdVvUpTHEdUbQaVY1ZSw0iBqHvgoJrfqOVe4u6YoyiaFwiEWrWV89esCRB0ikSuKm3q8EncFeRf5ofdhTtzlIl+a8BlU4OeoyDROphabs/ue7Mt/fB8e1U6y51kcBb2/1pvxgDosmF19575QDplnIK2Nrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885012; c=relaxed/simple;
	bh=pRWS7fICdDMeu6uJbdGDTP9OhGoWkEeXoFsTqaQeGEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpxBr9NLcjccQrJt9zbCg0FhGstQGnr4NM3v8YRQjv3bahQwmQNAoeJE8eibycka4aJt0XO0REmmXETGW0zsSJUFk3xgoycUC4YBsafQx0AoCvukLsJoeSW3X9JMNKKM4dOn1eMK32LaYe0TcqFh7NubCAMLcpzeGFer5QjdMlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJK3JZ2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJK3JZ2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E407C4CEF1;
	Tue, 16 Dec 2025 11:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885011;
	bh=pRWS7fICdDMeu6uJbdGDTP9OhGoWkEeXoFsTqaQeGEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJK3JZ2lZ40Vm3rbEs0wiVGRyNEcU4sbePeNOPDKbCnGCBGceK6ETFymnIAZ2UOk6
	 QSP9XTvuTHbj9/LVckYrKJFh9flUEFSlFAdHb9gOzSwpD0bXN/E3UqWWERykcga/95
	 Fy7flnk6rOql90wxVzSqMKn1rYBEf4+H8/oQUsbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 012/507] accel/ivpu: Rework bind/unbind of imported buffers
Date: Tue, 16 Dec 2025 12:07:33 +0100
Message-ID: <20251216111345.979530522@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

[ Upstream commit e0c0891cd63bf8338c25c423e28a5a93aed3d74c ]

Ensure that imported buffers are properly mapped and unmapped in
the same way as regular buffers to properly handle buffers during
device's bind and unbind operations to prevent resource leaks and
inconsistent buffer states.

Imported buffers are now dma_mapped before submission and
dma_unmapped in ivpu_bo_unbind(), guaranteeing they are unmapped
when the device is unbound.

Add also imported buffers to vdev->bo_list for consistent unmapping
on device unbind. The bo->ctx_id is set in open() so imported
buffers have a valid context ID.

Debug logs have been updated to match the new code structure.
The function ivpu_bo_pin() has been renamed to ivpu_bo_bind()
to better reflect its purpose, and unbind tests have been refactored
for improved coverage and clarity.

Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://lore.kernel.org/r/20250925145059.1446243-1-maciej.falkowski@linux.intel.com
Stable-dep-of: 8b694b405a84 ("accel/ivpu: Fix page fault in ivpu_bo_unbind_all_bos_from_context()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_gem.c | 90 ++++++++++++++++++++++-------------
 drivers/accel/ivpu/ivpu_gem.h |  2 +-
 drivers/accel/ivpu/ivpu_job.c |  2 +-
 3 files changed, 60 insertions(+), 34 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_gem.c b/drivers/accel/ivpu/ivpu_gem.c
index 59cfcf3eaded9..dc6d0d15cda9c 100644
--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -27,8 +27,8 @@ static const struct drm_gem_object_funcs ivpu_gem_funcs;
 static inline void ivpu_dbg_bo(struct ivpu_device *vdev, struct ivpu_bo *bo, const char *action)
 {
 	ivpu_dbg(vdev, BO,
-		 "%6s: bo %8p vpu_addr %9llx size %8zu ctx %d has_pages %d dma_mapped %d mmu_mapped %d wc %d imported %d\n",
-		 action, bo, bo->vpu_addr, ivpu_bo_size(bo), bo->ctx_id,
+		 "%6s: bo %8p size %9zu ctx %d vpu_addr %9llx pages %d sgt %d mmu_mapped %d wc %d imported %d\n",
+		 action, bo, ivpu_bo_size(bo), bo->ctx_id, bo->vpu_addr,
 		 (bool)bo->base.pages, (bool)bo->base.sgt, bo->mmu_mapped, bo->base.map_wc,
 		 (bool)drm_gem_is_imported(&bo->base.base));
 }
@@ -43,22 +43,46 @@ static inline void ivpu_bo_unlock(struct ivpu_bo *bo)
 	dma_resv_unlock(bo->base.base.resv);
 }
 
+static struct sg_table *ivpu_bo_map_attachment(struct ivpu_device *vdev, struct ivpu_bo *bo)
+{
+	struct sg_table *sgt = bo->base.sgt;
+
+	drm_WARN_ON(&vdev->drm, !bo->base.base.import_attach);
+
+	ivpu_bo_lock(bo);
+
+	if (!sgt) {
+		sgt = dma_buf_map_attachment(bo->base.base.import_attach, DMA_BIDIRECTIONAL);
+		if (IS_ERR(sgt))
+			ivpu_err(vdev, "Failed to map BO in IOMMU: %ld\n", PTR_ERR(sgt));
+		else
+			bo->base.sgt = sgt;
+	}
+
+	ivpu_bo_unlock(bo);
+
+	return sgt;
+}
+
 /*
- * ivpu_bo_pin() - pin the backing physical pages and map them to VPU.
+ * ivpu_bo_bind() - pin the backing physical pages and map them to VPU.
  *
  * This function pins physical memory pages, then maps the physical pages
  * to IOMMU address space and finally updates the VPU MMU page tables
  * to allow the VPU to translate VPU address to IOMMU address.
  */
-int __must_check ivpu_bo_pin(struct ivpu_bo *bo)
+int __must_check ivpu_bo_bind(struct ivpu_bo *bo)
 {
 	struct ivpu_device *vdev = ivpu_bo_to_vdev(bo);
 	struct sg_table *sgt;
 	int ret = 0;
 
-	ivpu_dbg_bo(vdev, bo, "pin");
+	ivpu_dbg_bo(vdev, bo, "bind");
 
-	sgt = drm_gem_shmem_get_pages_sgt(&bo->base);
+	if (bo->base.base.import_attach)
+		sgt = ivpu_bo_map_attachment(vdev, bo);
+	else
+		sgt = drm_gem_shmem_get_pages_sgt(&bo->base);
 	if (IS_ERR(sgt)) {
 		ret = PTR_ERR(sgt);
 		ivpu_err(vdev, "Failed to map BO in IOMMU: %d\n", ret);
@@ -99,7 +123,9 @@ ivpu_bo_alloc_vpu_addr(struct ivpu_bo *bo, struct ivpu_mmu_context *ctx,
 	ret = ivpu_mmu_context_insert_node(ctx, range, ivpu_bo_size(bo), &bo->mm_node);
 	if (!ret) {
 		bo->ctx = ctx;
+		bo->ctx_id = ctx->id;
 		bo->vpu_addr = bo->mm_node.start;
+		ivpu_dbg_bo(vdev, bo, "vaddr");
 	} else {
 		ivpu_err(vdev, "Failed to add BO to context %u: %d\n", ctx->id, ret);
 	}
@@ -115,7 +141,7 @@ static void ivpu_bo_unbind_locked(struct ivpu_bo *bo)
 {
 	struct ivpu_device *vdev = ivpu_bo_to_vdev(bo);
 
-	lockdep_assert(dma_resv_held(bo->base.base.resv) || !kref_read(&bo->base.base.refcount));
+	dma_resv_assert_held(bo->base.base.resv);
 
 	if (bo->mmu_mapped) {
 		drm_WARN_ON(&vdev->drm, !bo->ctx);
@@ -134,9 +160,14 @@ static void ivpu_bo_unbind_locked(struct ivpu_bo *bo)
 		return;
 
 	if (bo->base.sgt) {
-		dma_unmap_sgtable(vdev->drm.dev, bo->base.sgt, DMA_BIDIRECTIONAL, 0);
-		sg_free_table(bo->base.sgt);
-		kfree(bo->base.sgt);
+		if (bo->base.base.import_attach) {
+			dma_buf_unmap_attachment(bo->base.base.import_attach,
+						 bo->base.sgt, DMA_BIDIRECTIONAL);
+		} else {
+			dma_unmap_sgtable(vdev->drm.dev, bo->base.sgt, DMA_BIDIRECTIONAL, 0);
+			sg_free_table(bo->base.sgt);
+			kfree(bo->base.sgt);
+		}
 		bo->base.sgt = NULL;
 	}
 }
@@ -162,6 +193,7 @@ void ivpu_bo_unbind_all_bos_from_context(struct ivpu_device *vdev, struct ivpu_m
 
 struct drm_gem_object *ivpu_gem_create_object(struct drm_device *dev, size_t size)
 {
+	struct ivpu_device *vdev = to_ivpu_device(dev);
 	struct ivpu_bo *bo;
 
 	if (size == 0 || !PAGE_ALIGNED(size))
@@ -176,6 +208,11 @@ struct drm_gem_object *ivpu_gem_create_object(struct drm_device *dev, size_t siz
 
 	INIT_LIST_HEAD(&bo->bo_list_node);
 
+	mutex_lock(&vdev->bo_list_lock);
+	list_add_tail(&bo->bo_list_node, &vdev->bo_list);
+	mutex_unlock(&vdev->bo_list_lock);
+
+	ivpu_dbg(vdev, BO, " alloc: bo %8p size %9zu\n", bo, size);
 	return &bo->base.base;
 }
 
@@ -184,7 +221,6 @@ struct drm_gem_object *ivpu_gem_prime_import(struct drm_device *dev,
 {
 	struct device *attach_dev = dev->dev;
 	struct dma_buf_attachment *attach;
-	struct sg_table *sgt;
 	struct drm_gem_object *obj;
 	int ret;
 
@@ -194,16 +230,10 @@ struct drm_gem_object *ivpu_gem_prime_import(struct drm_device *dev,
 
 	get_dma_buf(dma_buf);
 
-	sgt = dma_buf_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
-	if (IS_ERR(sgt)) {
-		ret = PTR_ERR(sgt);
-		goto fail_detach;
-	}
-
-	obj = drm_gem_shmem_prime_import_sg_table(dev, attach, sgt);
+	obj = drm_gem_shmem_prime_import_sg_table(dev, attach, NULL);
 	if (IS_ERR(obj)) {
 		ret = PTR_ERR(obj);
-		goto fail_unmap;
+		goto fail_detach;
 	}
 
 	obj->import_attach = attach;
@@ -211,8 +241,6 @@ struct drm_gem_object *ivpu_gem_prime_import(struct drm_device *dev,
 
 	return obj;
 
-fail_unmap:
-	dma_buf_unmap_attachment_unlocked(attach, sgt, DMA_BIDIRECTIONAL);
 fail_detach:
 	dma_buf_detach(dma_buf, attach);
 	dma_buf_put(dma_buf);
@@ -220,7 +248,7 @@ struct drm_gem_object *ivpu_gem_prime_import(struct drm_device *dev,
 	return ERR_PTR(ret);
 }
 
-static struct ivpu_bo *ivpu_bo_alloc(struct ivpu_device *vdev, u64 size, u32 flags, u32 ctx_id)
+static struct ivpu_bo *ivpu_bo_alloc(struct ivpu_device *vdev, u64 size, u32 flags)
 {
 	struct drm_gem_shmem_object *shmem;
 	struct ivpu_bo *bo;
@@ -238,16 +266,9 @@ static struct ivpu_bo *ivpu_bo_alloc(struct ivpu_device *vdev, u64 size, u32 fla
 		return ERR_CAST(shmem);
 
 	bo = to_ivpu_bo(&shmem->base);
-	bo->ctx_id = ctx_id;
 	bo->base.map_wc = flags & DRM_IVPU_BO_WC;
 	bo->flags = flags;
 
-	mutex_lock(&vdev->bo_list_lock);
-	list_add_tail(&bo->bo_list_node, &vdev->bo_list);
-	mutex_unlock(&vdev->bo_list_lock);
-
-	ivpu_dbg_bo(vdev, bo, "alloc");
-
 	return bo;
 }
 
@@ -281,6 +302,8 @@ static void ivpu_gem_bo_free(struct drm_gem_object *obj)
 
 	ivpu_dbg_bo(vdev, bo, "free");
 
+	drm_WARN_ON(&vdev->drm, list_empty(&bo->bo_list_node));
+
 	mutex_lock(&vdev->bo_list_lock);
 	list_del(&bo->bo_list_node);
 	mutex_unlock(&vdev->bo_list_lock);
@@ -290,7 +313,10 @@ static void ivpu_gem_bo_free(struct drm_gem_object *obj)
 	drm_WARN_ON(&vdev->drm, ivpu_bo_size(bo) == 0);
 	drm_WARN_ON(&vdev->drm, bo->base.vaddr);
 
+	ivpu_bo_lock(bo);
 	ivpu_bo_unbind_locked(bo);
+	ivpu_bo_unlock(bo);
+
 	drm_WARN_ON(&vdev->drm, bo->mmu_mapped);
 	drm_WARN_ON(&vdev->drm, bo->ctx);
 
@@ -326,7 +352,7 @@ int ivpu_bo_create_ioctl(struct drm_device *dev, void *data, struct drm_file *fi
 	if (size == 0)
 		return -EINVAL;
 
-	bo = ivpu_bo_alloc(vdev, size, args->flags, file_priv->ctx.id);
+	bo = ivpu_bo_alloc(vdev, size, args->flags);
 	if (IS_ERR(bo)) {
 		ivpu_err(vdev, "Failed to allocate BO: %pe (ctx %u size %llu flags 0x%x)",
 			 bo, file_priv->ctx.id, args->size, args->flags);
@@ -360,7 +386,7 @@ ivpu_bo_create(struct ivpu_device *vdev, struct ivpu_mmu_context *ctx,
 	drm_WARN_ON(&vdev->drm, !PAGE_ALIGNED(range->end));
 	drm_WARN_ON(&vdev->drm, !PAGE_ALIGNED(size));
 
-	bo = ivpu_bo_alloc(vdev, size, flags, IVPU_GLOBAL_CONTEXT_MMU_SSID);
+	bo = ivpu_bo_alloc(vdev, size, flags);
 	if (IS_ERR(bo)) {
 		ivpu_err(vdev, "Failed to allocate BO: %pe (vpu_addr 0x%llx size %llu flags 0x%x)",
 			 bo, range->start, size, flags);
@@ -371,7 +397,7 @@ ivpu_bo_create(struct ivpu_device *vdev, struct ivpu_mmu_context *ctx,
 	if (ret)
 		goto err_put;
 
-	ret = ivpu_bo_pin(bo);
+	ret = ivpu_bo_bind(bo);
 	if (ret)
 		goto err_put;
 
diff --git a/drivers/accel/ivpu/ivpu_gem.h b/drivers/accel/ivpu/ivpu_gem.h
index aa8ff14f7aae1..ade0d127453ff 100644
--- a/drivers/accel/ivpu/ivpu_gem.h
+++ b/drivers/accel/ivpu/ivpu_gem.h
@@ -24,7 +24,7 @@ struct ivpu_bo {
 	bool mmu_mapped;
 };
 
-int ivpu_bo_pin(struct ivpu_bo *bo);
+int ivpu_bo_bind(struct ivpu_bo *bo);
 void ivpu_bo_unbind_all_bos_from_context(struct ivpu_device *vdev, struct ivpu_mmu_context *ctx);
 
 struct drm_gem_object *ivpu_gem_create_object(struct drm_device *dev, size_t size);
diff --git a/drivers/accel/ivpu/ivpu_job.c b/drivers/accel/ivpu/ivpu_job.c
index dbefa43c74e28..1e4caf5726474 100644
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -732,7 +732,7 @@ ivpu_job_prepare_bos_for_submit(struct drm_file *file, struct ivpu_job *job, u32
 
 		job->bos[i] = to_ivpu_bo(obj);
 
-		ret = ivpu_bo_pin(job->bos[i]);
+		ret = ivpu_bo_bind(job->bos[i]);
 		if (ret)
 			return ret;
 	}
-- 
2.51.0



