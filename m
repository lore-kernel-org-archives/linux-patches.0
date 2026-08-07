Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5186331200;
	Fri,  7 Aug 2026 14:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114605; cv=none; b=go8X83J46hzTNC7igDn8JZ3G7b7Z50SwaWwQCvJgN7lZUby/NgFe3yrDRe3mUjxQCYtTnsTeAVHRaVGEzeUSlZ8ux09+u7oYxKSxpFHET1/ZwUdJNiyrfglSrZhU2ViUnQ13LdZgqQy7oexwD1fSq865P5UFTrIugmDEO2qFI5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114605; c=relaxed/simple;
	bh=FBFfdg1wM/87JkVagGnp/qYZ00IAh8DkzFjZ6xfjSuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WQQ0tguhxqIk5un33e7A126N2yfrQczD07XHAx6E7Ceqg2l2e7nVztrUqekqclw5oSCVevgZGw+sW1WaMZtGvwjmNMeChhUgS8s21W98aMKpmKI/VbaGGACPiawO/++FA17vA25RzgRkmrVOOvAN6tKuhmbPo35fzhTXD3a7DE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0JFGxXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0JFGxXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83ADA1F00A3A;
	Fri,  7 Aug 2026 14:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114599;
	bh=9grP+0tUYTb8N5dGEDO/TufrwLkmPbYT8882vkCbwJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0JFGxXyIHX33XwZFJl64iW9Z9925NUsJUUlGWVGvKAKmxGS30XwT0QdKsieu8ejg
	 cSOqBcEbvQt/SD1dyJlgICKfL/Ono+bzctRY4gZWu8qMXiQwxuSKP3YuXBP4qigtQL
	 YGmuGO6fOZCcVyXjRmiGCF6IKTFH+1C7KHFqAy3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Hellstrom <thomas.hellstrom@linux.intel.com>,
	Christian Konig <christian.koenig@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 321/337] drm/xe: Hold a dma-buf reference for imported BOs
Date: Fri,  7 Aug 2026 16:38:44 +0200
Message-ID: <20260807143425.492590903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Nitin Gote <nitin.r.gote@intel.com>

[ Upstream commit 62775525a27c3b0d56382e08ba81ee2d322058b6 ]

An imported dma-buf BO is created as a ttm_bo_type_sg BO whose
reservation object is the exporter's dma_buf->resv. The importer,
however, only takes a dma-buf reference after a successful
dma_buf_dynamic_attach(). Until then nothing keeps the exporter alive,
so if the exporter is freed while the BO still references its resv, a
later access to that resv is a use-after-free:

  Oops: general protection fault, probably for non-canonical address
        0x6b6b6b6b6b6b6b9c
  Workqueue: ttm ttm_bo_delayed_delete [ttm]
  RIP: 0010:mutex_can_spin_on_owner+0x3f/0xc0

This can be reached on two paths:

 - dma_buf_dynamic_attach() fails, or
 - ttm_bo_init_reserved() fails during BO creation.

In both cases the BO already has bo->base.resv pointing at the exporter
resv, and sg BOs are always torn down via ttm_bo_delayed_delete(), which
locks bo->base.resv asynchronously - potentially after the exporter has
been freed.

Take the dma-buf reference in xe_bo_init_locked(), before
ttm_bo_init_reserved(), so it also covers a creation failure there, and
release it in xe_ttm_bo_destroy(). The reference is held for the whole
BO lifetime, keeping the shared resv alive on every path.

v2:
  - Reworked the fix to avoid creating the imported sg BO before
    dma_buf_dynamic_attach() succeeds.
  - Attach with importer_priv == NULL and make invalidate_mappings ignore
    incomplete imports.

v3:
  - Dropped the xe-side reordering approach since importer_priv must be
    valid when dma_buf_dynamic_attach() publishes the attachment.
  - Per Christian's suggestion on the v1 thread, keyed the check on
    import_attach rather than removing the sg guard entirely.
  - Fixes both xe and amdgpu in a single TTM patch.

v4:
  - Moved import_attach check to after dma_resv_copy_fences() so fences
    are copied before returning for successful imports (Thomas).
  - Removed exporter-alive claim from commit message (Thomas).

v5:
  - Add drm/xe patch to keep imported sg BOs off the LRU before attach
    succeeds; the TTM fix alone is not sufficient for xe if the BO is
    already LRU-visible. (Thomas)
    v4 patch:
    https://patchwork.freedesktop.org/patch/736663/?series=169129&rev=2
  - Patch 1 (drm/ttm) carries Christian's Reviewed-by from v4.

v6:
  - Reworked the fix based on Thomas' suggestion. Instead of the TTM resv
    individualization (v1-v5) plus the xe off-LRU/placement handling (v5),
    just hold a dma-buf reference for the imported BO lifetime so the
    shared resv can never be freed while the BO still references it.
    Single xe patch, no TTM change. (Thomas)
  - Take the reference in xe_bo_init_locked() before ttm_bo_init_reserved()
    so a TTM creation failure is covered too (Thomas).
  - Dropped the v5 series (drm/ttm + drm/xe off-LRU); the off-LRU approach
    also regressed in CI BAT via ttm_bo_pipeline_gutting() creating a ghost
    BO that outlived the exporter.
    Link to v5: https://patchwork.freedesktop.org/series/169984/

v7:
  - Move changelog above --- so it stays in the commit message.
  - Reorder changelog entries oldest-to-newest. (Thomas)

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/8023
Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org
Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
Cc: Christian Konig <christian.koenig@amd.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Suggested-by: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
Assisted-by: GitHub_Copilot:claude-sonnet-4.6
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20260710191027.260160-2-nitin.r.gote@intel.com
(cherry picked from commit 3516f3fae6be35642f8f06f8a218da6425c0306a)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.c       |   17 +++++++++++++++--
 drivers/gpu/drm/xe/xe_bo.h       |    2 +-
 drivers/gpu/drm/xe/xe_bo_types.h |    2 ++
 drivers/gpu/drm/xe/xe_dma_buf.c  |    2 +-
 4 files changed, 19 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1131,6 +1131,8 @@ static void xe_ttm_bo_destroy(struct ttm
 
 	if (bo->ttm.base.import_attach)
 		drm_prime_gem_destroy(&bo->ttm.base, NULL);
+	if (bo->dma_buf)
+		dma_buf_put(bo->dma_buf);
 	drm_gem_object_release(&bo->ttm.base);
 
 	xe_assert(xe, list_empty(&ttm_bo->base.gpuva.list));
@@ -1292,7 +1294,7 @@ struct xe_bo *xe_bo_init_locked(struct x
 				struct xe_tile *tile, struct dma_resv *resv,
 				struct ttm_lru_bulk_move *bulk, size_t size,
 				u16 cpu_caching, enum ttm_bo_type type,
-				u32 flags)
+				u32 flags, struct dma_buf *dma_buf)
 {
 	struct ttm_operation_ctx ctx = {
 		.interruptible = true,
@@ -1377,6 +1379,17 @@ struct xe_bo *xe_bo_init_locked(struct x
 	placement = (type == ttm_bo_type_sg ||
 		     bo->flags & XE_BO_FLAG_DEFER_BACKING) ? &sys_placement :
 		&bo->placement;
+
+	/*
+	 * For imported BOs, keep the exporter dma-buf alive for the BO
+	 * lifetime. Taken before ttm_bo_init_reserved() to also cover a
+	 * creation failure there. Released in xe_ttm_bo_destroy().
+	 */
+	if (dma_buf) {
+		get_dma_buf(dma_buf);
+		bo->dma_buf = dma_buf;
+	}
+
 	err = ttm_bo_init_reserved(&xe->ttm, &bo->ttm, type,
 				   placement, alignment,
 				   &ctx, NULL, resv, xe_ttm_bo_destroy);
@@ -1491,7 +1504,7 @@ __xe_bo_create_locked(struct xe_device *
 			       vm && !xe_vm_in_fault_mode(vm) &&
 			       flags & XE_BO_FLAG_USER ?
 			       &vm->lru_bulk_move : NULL, size,
-			       cpu_caching, type, flags);
+			       cpu_caching, type, flags, NULL);
 	if (IS_ERR(bo))
 		return bo;
 
--- a/drivers/gpu/drm/xe/xe_bo.h
+++ b/drivers/gpu/drm/xe/xe_bo.h
@@ -84,7 +84,7 @@ struct xe_bo *xe_bo_init_locked(struct x
 				struct xe_tile *tile, struct dma_resv *resv,
 				struct ttm_lru_bulk_move *bulk, size_t size,
 				u16 cpu_caching, enum ttm_bo_type type,
-				u32 flags);
+				u32 flags, struct dma_buf *dma_buf);
 struct xe_bo *
 xe_bo_create_locked_range(struct xe_device *xe,
 			  struct xe_tile *tile, struct xe_vm *vm,
--- a/drivers/gpu/drm/xe/xe_bo_types.h
+++ b/drivers/gpu/drm/xe/xe_bo_types.h
@@ -30,6 +30,8 @@ struct xe_bo {
 	struct ttm_buffer_object ttm;
 	/** @size: Size of this buffer object */
 	size_t size;
+	/** @dma_buf: Imported dma-buf ref to keep its resv alive. */
+	struct dma_buf *dma_buf;
 	/** @flags: flags for this buffer object */
 	u32 flags;
 	/** @vm: VM this BO is attached to, for extobj this will be NULL */
--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -214,7 +214,7 @@ xe_dma_buf_init_obj(struct drm_device *d
 	dma_resv_lock(resv, NULL);
 	bo = xe_bo_init_locked(xe, storage, NULL, resv, NULL, dma_buf->size,
 			       0, /* Will require 1way or 2way for vm_bind */
-			       ttm_bo_type_sg, XE_BO_FLAG_SYSTEM);
+			       ttm_bo_type_sg, XE_BO_FLAG_SYSTEM, dma_buf);
 	if (IS_ERR(bo)) {
 		ret = PTR_ERR(bo);
 		goto error;


