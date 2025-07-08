Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8872F215F5C;
	Tue,  8 Jul 2025 16:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993010; cv=none; b=gsSyQU9wkDb+KCtWpPSrN7vXyRblnmeXrCPQJ0830FtHTNKzj0ISyMECr4JWdjX55Ba9aQ5JtrE7yrTRpEw7wyBBCBe7qpaQRi35rV7EGXGRbmPljDBUUGw7b0lqSejyeby8IABYYyaZzA55mRq+fr7n6MxW8LnxYklVUo3vDVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993010; c=relaxed/simple;
	bh=nE+W+sQbcHvDnyhCz1FcPor8FcXXAy2NbvMJVy8D5tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdUFbiLuJsrJgO+yEzJw6XeX8txFzobaqLwgCLK0K0J+3iPq/OtcPxIsMt0aw+QrsUIkdQsna35pC5hY53l65J8aF8VW2nO2O7Ze244Jq1ek/UnuxQB9b54C/iw3kxIEk02H0rVvd/bab1Q86xhwEwSuMacvLNfZUyJ5u5PDgAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fwiu/rHT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fwiu/rHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35CEC4CEED;
	Tue,  8 Jul 2025 16:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993010;
	bh=nE+W+sQbcHvDnyhCz1FcPor8FcXXAy2NbvMJVy8D5tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fwiu/rHTBKN1/L35SF6JEB+dtsK4Wi2ZGOcfMBrK9GcNiV4vWyDWsmtzlsX7LKOUk
	 OAzk9KZhPFG0EhgqoHpAoiD2g9iaeq05vPL5652vfY79ghPHJzahyGsLyqjOr0D+jT
	 I/l4WmBR+KbewFidMKxTYbTYWDrKCUGZit/WBMi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/232] drm/xe: Allow bo mapping on multiple ggtts
Date: Tue,  8 Jul 2025 18:22:32 +0200
Message-ID: <20250708162245.519669883@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>

[ Upstream commit 5a3b0df25d6a78098d548213384665eeead608c9 ]

Make bo->ggtt an array to support bo mapping on multiple ggtts.
Add XE_BO_FLAG_GGTTx flags to map the bo on ggtt of tile 'x'.

Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241120000222.204095-2-John.C.Harrison@Intel.com
Stable-dep-of: f16873f42a06 ("drm/xe: move DPT l2 flush to a more sensible place")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_fb_pin.c | 12 ++++---
 drivers/gpu/drm/xe/xe_bo.c             | 49 ++++++++++++++++++--------
 drivers/gpu/drm/xe/xe_bo.h             | 32 ++++++++++++++---
 drivers/gpu/drm/xe/xe_bo_evict.c       | 14 +++++---
 drivers/gpu/drm/xe/xe_bo_types.h       |  5 +--
 drivers/gpu/drm/xe/xe_ggtt.c           | 35 +++++++++---------
 6 files changed, 101 insertions(+), 46 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/xe_fb_pin.c b/drivers/gpu/drm/xe/display/xe_fb_pin.c
index b58fc4ba2aacb..972b7db52f785 100644
--- a/drivers/gpu/drm/xe/display/xe_fb_pin.c
+++ b/drivers/gpu/drm/xe/display/xe_fb_pin.c
@@ -153,7 +153,7 @@ static int __xe_pin_fb_vma_dpt(const struct intel_framebuffer *fb,
 	}
 
 	vma->dpt = dpt;
-	vma->node = dpt->ggtt_node;
+	vma->node = dpt->ggtt_node[tile0->id];
 	return 0;
 }
 
@@ -203,8 +203,8 @@ static int __xe_pin_fb_vma_ggtt(const struct intel_framebuffer *fb,
 	if (xe_bo_is_vram(bo) && ggtt->flags & XE_GGTT_FLAGS_64K)
 		align = max_t(u32, align, SZ_64K);
 
-	if (bo->ggtt_node && view->type == I915_GTT_VIEW_NORMAL) {
-		vma->node = bo->ggtt_node;
+	if (bo->ggtt_node[ggtt->tile->id] && view->type == I915_GTT_VIEW_NORMAL) {
+		vma->node = bo->ggtt_node[ggtt->tile->id];
 	} else if (view->type == I915_GTT_VIEW_NORMAL) {
 		u32 x, size = bo->ttm.base.size;
 
@@ -333,10 +333,12 @@ static struct i915_vma *__xe_pin_fb_vma(const struct intel_framebuffer *fb,
 
 static void __xe_unpin_fb_vma(struct i915_vma *vma)
 {
+	u8 tile_id = vma->node->ggtt->tile->id;
+
 	if (vma->dpt)
 		xe_bo_unpin_map_no_vm(vma->dpt);
-	else if (!xe_ggtt_node_allocated(vma->bo->ggtt_node) ||
-		 vma->bo->ggtt_node->base.start != vma->node->base.start)
+	else if (!xe_ggtt_node_allocated(vma->bo->ggtt_node[tile_id]) ||
+		 vma->bo->ggtt_node[tile_id]->base.start != vma->node->base.start)
 		xe_ggtt_node_remove(vma->node, false);
 
 	ttm_bo_reserve(&vma->bo->ttm, false, false, NULL);
diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index c92953c08d682..5f745d9ed6cc2 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1130,6 +1130,8 @@ static void xe_ttm_bo_destroy(struct ttm_buffer_object *ttm_bo)
 {
 	struct xe_bo *bo = ttm_to_xe_bo(ttm_bo);
 	struct xe_device *xe = ttm_to_xe_device(ttm_bo->bdev);
+	struct xe_tile *tile;
+	u8 id;
 
 	if (bo->ttm.base.import_attach)
 		drm_prime_gem_destroy(&bo->ttm.base, NULL);
@@ -1137,8 +1139,9 @@ static void xe_ttm_bo_destroy(struct ttm_buffer_object *ttm_bo)
 
 	xe_assert(xe, list_empty(&ttm_bo->base.gpuva.list));
 
-	if (bo->ggtt_node && bo->ggtt_node->base.size)
-		xe_ggtt_remove_bo(bo->tile->mem.ggtt, bo);
+	for_each_tile(tile, xe, id)
+		if (bo->ggtt_node[id] && bo->ggtt_node[id]->base.size)
+			xe_ggtt_remove_bo(tile->mem.ggtt, bo);
 
 #ifdef CONFIG_PROC_FS
 	if (bo->client)
@@ -1308,6 +1311,10 @@ struct xe_bo *___xe_bo_create_locked(struct xe_device *xe, struct xe_bo *bo,
 		return ERR_PTR(-EINVAL);
 	}
 
+	/* XE_BO_FLAG_GGTTx requires XE_BO_FLAG_GGTT also be set */
+	if ((flags & XE_BO_FLAG_GGTT_ALL) && !(flags & XE_BO_FLAG_GGTT))
+		return ERR_PTR(-EINVAL);
+
 	if (flags & (XE_BO_FLAG_VRAM_MASK | XE_BO_FLAG_STOLEN) &&
 	    !(flags & XE_BO_FLAG_IGNORE_MIN_PAGE_SIZE) &&
 	    ((xe->info.vram_flags & XE_VRAM_FLAGS_NEED64K) ||
@@ -1498,19 +1505,29 @@ __xe_bo_create_locked(struct xe_device *xe,
 	bo->vm = vm;
 
 	if (bo->flags & XE_BO_FLAG_GGTT) {
-		if (!tile && flags & XE_BO_FLAG_STOLEN)
-			tile = xe_device_get_root_tile(xe);
+		struct xe_tile *t;
+		u8 id;
 
-		xe_assert(xe, tile);
+		if (!(bo->flags & XE_BO_FLAG_GGTT_ALL)) {
+			if (!tile && flags & XE_BO_FLAG_STOLEN)
+				tile = xe_device_get_root_tile(xe);
 
-		if (flags & XE_BO_FLAG_FIXED_PLACEMENT) {
-			err = xe_ggtt_insert_bo_at(tile->mem.ggtt, bo,
-						   start + bo->size, U64_MAX);
-		} else {
-			err = xe_ggtt_insert_bo(tile->mem.ggtt, bo);
+			xe_assert(xe, tile);
+		}
+
+		for_each_tile(t, xe, id) {
+			if (t != tile && !(bo->flags & XE_BO_FLAG_GGTTx(t)))
+				continue;
+
+			if (flags & XE_BO_FLAG_FIXED_PLACEMENT) {
+				err = xe_ggtt_insert_bo_at(t->mem.ggtt, bo,
+							   start + bo->size, U64_MAX);
+			} else {
+				err = xe_ggtt_insert_bo(t->mem.ggtt, bo);
+			}
+			if (err)
+				goto err_unlock_put_bo;
 		}
-		if (err)
-			goto err_unlock_put_bo;
 	}
 
 	return bo;
@@ -2372,14 +2389,18 @@ void xe_bo_put_commit(struct llist_head *deferred)
 
 void xe_bo_put(struct xe_bo *bo)
 {
+	struct xe_tile *tile;
+	u8 id;
+
 	might_sleep();
 	if (bo) {
 #ifdef CONFIG_PROC_FS
 		if (bo->client)
 			might_lock(&bo->client->bos_lock);
 #endif
-		if (bo->ggtt_node && bo->ggtt_node->ggtt)
-			might_lock(&bo->ggtt_node->ggtt->lock);
+		for_each_tile(tile, xe_bo_device(bo), id)
+			if (bo->ggtt_node[id] && bo->ggtt_node[id]->ggtt)
+				might_lock(&bo->ggtt_node[id]->ggtt->lock);
 		drm_gem_object_put(&bo->ttm.base);
 	}
 }
diff --git a/drivers/gpu/drm/xe/xe_bo.h b/drivers/gpu/drm/xe/xe_bo.h
index 704f5068d0d0a..d04159c598465 100644
--- a/drivers/gpu/drm/xe/xe_bo.h
+++ b/drivers/gpu/drm/xe/xe_bo.h
@@ -39,10 +39,22 @@
 #define XE_BO_FLAG_NEEDS_64K		BIT(15)
 #define XE_BO_FLAG_NEEDS_2M		BIT(16)
 #define XE_BO_FLAG_GGTT_INVALIDATE	BIT(17)
+#define XE_BO_FLAG_GGTT0                BIT(18)
+#define XE_BO_FLAG_GGTT1                BIT(19)
+#define XE_BO_FLAG_GGTT2                BIT(20)
+#define XE_BO_FLAG_GGTT3                BIT(21)
+#define XE_BO_FLAG_GGTT_ALL             (XE_BO_FLAG_GGTT0 | \
+					 XE_BO_FLAG_GGTT1 | \
+					 XE_BO_FLAG_GGTT2 | \
+					 XE_BO_FLAG_GGTT3)
+
 /* this one is trigger internally only */
 #define XE_BO_FLAG_INTERNAL_TEST	BIT(30)
 #define XE_BO_FLAG_INTERNAL_64K		BIT(31)
 
+#define XE_BO_FLAG_GGTTx(tile) \
+	(XE_BO_FLAG_GGTT0 << (tile)->id)
+
 #define XE_PTE_SHIFT			12
 #define XE_PAGE_SIZE			(1 << XE_PTE_SHIFT)
 #define XE_PTE_MASK			(XE_PAGE_SIZE - 1)
@@ -194,14 +206,24 @@ xe_bo_main_addr(struct xe_bo *bo, size_t page_size)
 }
 
 static inline u32
-xe_bo_ggtt_addr(struct xe_bo *bo)
+__xe_bo_ggtt_addr(struct xe_bo *bo, u8 tile_id)
 {
-	if (XE_WARN_ON(!bo->ggtt_node))
+	struct xe_ggtt_node *ggtt_node = bo->ggtt_node[tile_id];
+
+	if (XE_WARN_ON(!ggtt_node))
 		return 0;
 
-	XE_WARN_ON(bo->ggtt_node->base.size > bo->size);
-	XE_WARN_ON(bo->ggtt_node->base.start + bo->ggtt_node->base.size > (1ull << 32));
-	return bo->ggtt_node->base.start;
+	XE_WARN_ON(ggtt_node->base.size > bo->size);
+	XE_WARN_ON(ggtt_node->base.start + ggtt_node->base.size > (1ull << 32));
+	return ggtt_node->base.start;
+}
+
+static inline u32
+xe_bo_ggtt_addr(struct xe_bo *bo)
+{
+	xe_assert(xe_bo_device(bo), bo->tile);
+
+	return __xe_bo_ggtt_addr(bo, bo->tile->id);
 }
 
 int xe_bo_vmap(struct xe_bo *bo);
diff --git a/drivers/gpu/drm/xe/xe_bo_evict.c b/drivers/gpu/drm/xe/xe_bo_evict.c
index 8fb2be0610035..6a40eedd9db10 100644
--- a/drivers/gpu/drm/xe/xe_bo_evict.c
+++ b/drivers/gpu/drm/xe/xe_bo_evict.c
@@ -152,11 +152,17 @@ int xe_bo_restore_kernel(struct xe_device *xe)
 		}
 
 		if (bo->flags & XE_BO_FLAG_GGTT) {
-			struct xe_tile *tile = bo->tile;
+			struct xe_tile *tile;
+			u8 id;
 
-			mutex_lock(&tile->mem.ggtt->lock);
-			xe_ggtt_map_bo(tile->mem.ggtt, bo);
-			mutex_unlock(&tile->mem.ggtt->lock);
+			for_each_tile(tile, xe, id) {
+				if (tile != bo->tile && !(bo->flags & XE_BO_FLAG_GGTTx(tile)))
+					continue;
+
+				mutex_lock(&tile->mem.ggtt->lock);
+				xe_ggtt_map_bo(tile->mem.ggtt, bo);
+				mutex_unlock(&tile->mem.ggtt->lock);
+			}
 		}
 
 		/*
diff --git a/drivers/gpu/drm/xe/xe_bo_types.h b/drivers/gpu/drm/xe/xe_bo_types.h
index 35372c46edfa5..aa298d33c2508 100644
--- a/drivers/gpu/drm/xe/xe_bo_types.h
+++ b/drivers/gpu/drm/xe/xe_bo_types.h
@@ -13,6 +13,7 @@
 #include <drm/ttm/ttm_execbuf_util.h>
 #include <drm/ttm/ttm_placement.h>
 
+#include "xe_device_types.h"
 #include "xe_ggtt_types.h"
 
 struct xe_device;
@@ -39,8 +40,8 @@ struct xe_bo {
 	struct ttm_place placements[XE_BO_MAX_PLACEMENTS];
 	/** @placement: current placement for this BO */
 	struct ttm_placement placement;
-	/** @ggtt_node: GGTT node if this BO is mapped in the GGTT */
-	struct xe_ggtt_node *ggtt_node;
+	/** @ggtt_node: Array of GGTT nodes if this BO is mapped in the GGTTs */
+	struct xe_ggtt_node *ggtt_node[XE_MAX_TILES_PER_DEVICE];
 	/** @vmap: iosys map of this buffer */
 	struct iosys_map vmap;
 	/** @ttm_kmap: TTM bo kmap object for internal use only. Keep off. */
diff --git a/drivers/gpu/drm/xe/xe_ggtt.c b/drivers/gpu/drm/xe/xe_ggtt.c
index 9cb5760006a1c..76e1092f51d92 100644
--- a/drivers/gpu/drm/xe/xe_ggtt.c
+++ b/drivers/gpu/drm/xe/xe_ggtt.c
@@ -605,10 +605,10 @@ void xe_ggtt_map_bo(struct xe_ggtt *ggtt, struct xe_bo *bo)
 	u64 start;
 	u64 offset, pte;
 
-	if (XE_WARN_ON(!bo->ggtt_node))
+	if (XE_WARN_ON(!bo->ggtt_node[ggtt->tile->id]))
 		return;
 
-	start = bo->ggtt_node->base.start;
+	start = bo->ggtt_node[ggtt->tile->id]->base.start;
 
 	for (offset = 0; offset < bo->size; offset += XE_PAGE_SIZE) {
 		pte = ggtt->pt_ops->pte_encode_bo(bo, offset, pat_index);
@@ -619,15 +619,16 @@ void xe_ggtt_map_bo(struct xe_ggtt *ggtt, struct xe_bo *bo)
 static int __xe_ggtt_insert_bo_at(struct xe_ggtt *ggtt, struct xe_bo *bo,
 				  u64 start, u64 end)
 {
-	int err;
 	u64 alignment = bo->min_align > 0 ? bo->min_align : XE_PAGE_SIZE;
+	u8 tile_id = ggtt->tile->id;
+	int err;
 
 	if (xe_bo_is_vram(bo) && ggtt->flags & XE_GGTT_FLAGS_64K)
 		alignment = SZ_64K;
 
-	if (XE_WARN_ON(bo->ggtt_node)) {
+	if (XE_WARN_ON(bo->ggtt_node[tile_id])) {
 		/* Someone's already inserted this BO in the GGTT */
-		xe_tile_assert(ggtt->tile, bo->ggtt_node->base.size == bo->size);
+		xe_tile_assert(ggtt->tile, bo->ggtt_node[tile_id]->base.size == bo->size);
 		return 0;
 	}
 
@@ -637,19 +638,19 @@ static int __xe_ggtt_insert_bo_at(struct xe_ggtt *ggtt, struct xe_bo *bo,
 
 	xe_pm_runtime_get_noresume(tile_to_xe(ggtt->tile));
 
-	bo->ggtt_node = xe_ggtt_node_init(ggtt);
-	if (IS_ERR(bo->ggtt_node)) {
-		err = PTR_ERR(bo->ggtt_node);
-		bo->ggtt_node = NULL;
+	bo->ggtt_node[tile_id] = xe_ggtt_node_init(ggtt);
+	if (IS_ERR(bo->ggtt_node[tile_id])) {
+		err = PTR_ERR(bo->ggtt_node[tile_id]);
+		bo->ggtt_node[tile_id] = NULL;
 		goto out;
 	}
 
 	mutex_lock(&ggtt->lock);
-	err = drm_mm_insert_node_in_range(&ggtt->mm, &bo->ggtt_node->base, bo->size,
-					  alignment, 0, start, end, 0);
+	err = drm_mm_insert_node_in_range(&ggtt->mm, &bo->ggtt_node[tile_id]->base,
+					  bo->size, alignment, 0, start, end, 0);
 	if (err) {
-		xe_ggtt_node_fini(bo->ggtt_node);
-		bo->ggtt_node = NULL;
+		xe_ggtt_node_fini(bo->ggtt_node[tile_id]);
+		bo->ggtt_node[tile_id] = NULL;
 	} else {
 		xe_ggtt_map_bo(ggtt, bo);
 	}
@@ -698,13 +699,15 @@ int xe_ggtt_insert_bo(struct xe_ggtt *ggtt, struct xe_bo *bo)
  */
 void xe_ggtt_remove_bo(struct xe_ggtt *ggtt, struct xe_bo *bo)
 {
-	if (XE_WARN_ON(!bo->ggtt_node))
+	u8 tile_id = ggtt->tile->id;
+
+	if (XE_WARN_ON(!bo->ggtt_node[tile_id]))
 		return;
 
 	/* This BO is not currently in the GGTT */
-	xe_tile_assert(ggtt->tile, bo->ggtt_node->base.size == bo->size);
+	xe_tile_assert(ggtt->tile, bo->ggtt_node[tile_id]->base.size == bo->size);
 
-	xe_ggtt_node_remove(bo->ggtt_node,
+	xe_ggtt_node_remove(bo->ggtt_node[tile_id],
 			    bo->flags & XE_BO_FLAG_GGTT_INVALIDATE);
 }
 
-- 
2.39.5



