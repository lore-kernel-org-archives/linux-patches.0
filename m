Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B1543BDCB;
	Thu, 30 Jul 2026 14:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422268; cv=none; b=ZaE3yEyZJzIaIoeNthBsMTTiHXasx3gU1M7WPiJNNWUxMrpDHsiSB0i9gdV4p3cYz4FpEJTJ2EIViKlzqEptIddfCP+CzDhmIyfZloRH2a7I+MHp30YzkxNWPHLKZq8nXAs/poYyCjbfodvpLVvqb4OD+0KJMJiVY4VTIOpCsZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422268; c=relaxed/simple;
	bh=/OYKkyBcw2X5wx88RDfclt0wv0JH96bJBQpZAeFunuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCkyy4+XKU3CEQg6ycRKagP6g/WeOnAJxCAVxHNckYJNHqogzypqKGuKNh7TK0OrKGFGFtc0SBjVtnc2EG2AMApucUQf5i/KnO/tkMFZjGJ5S7aT/zC+ALUz9bjt3NTHEP9LNuw+lEmZHC7H6O8AnTb8fv7HHWeALIxNO3NvB6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWbSBdIn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWbSBdIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3691F000E9;
	Thu, 30 Jul 2026 14:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422266;
	bh=nd33VbQ0Ol2ZP9WArUANBdJWMYErJ58Jk0b7iLTtqQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWbSBdInDqCiDbCFOthZN/KnbRsxgQ3hZL9f5Xs34c9S98xPiROlUB5fgVZDiWSp7
	 2yMcyQXqp1qVEpFZccKauUuBZeWKeYf9m3FR/DaeiEaeIIFGZu+hctwN5Jbdsfk86N
	 EfJpjdOPQCpcHnVNA8FGycAn5iYLxvqzisE+Nffw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Zongyao Bai <zongyao.bai@intel.com>,
	Brian Nguyen <brian3.nguyen@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 7.1 381/744] drm/xe: Add compact-PT and addr mask handling for page reclaim
Date: Thu, 30 Jul 2026 16:10:54 +0200
Message-ID: <20260730141452.384492601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Nguyen <brian3.nguyen@intel.com>

commit 0b5ed2756d45b04669502a1f13b1657ec7664571 upstream.

Current implementation of generate_reclaim_entry() overlooks some
differences between the different page implementations: address masking
and compact 64K page handling.

Address masking of each leaf varies depending on the leaf entry size.
generate_reclaim_entry() is using XE_PTE_ADDR_MASK [51:12] for all leaf
entries. For 2MB PTEs, bit 12 (PAT) is part of the flags so the old mask
corrupts the physical address extraction.

64K pages can be represented as PS64 and a compact PT, which the latter
was not handled. Compact pages aren't walked by the unbind walker, so we
separately walk through the compact PT to ensure none of the leaf 64K
PTEs are dropped. Previously, compact PT were causing an abort since it
was considered covered and not descended into.

v2:
 - Update 64K entry/unbind walker for 64K compact PT handling. (Matthew)
 - Rework calculations of reclamation and address mask size.
 - Add new func abstracting the error handling before generating the
   reclaim entry.

v3:
 - Report finer addr granularity in abort debug print for compact.
   (Zongyao)
 - Add comments for ADDR_MASK usage. (Zongyao)
 - Drop existing phys_addr asserts, the new XE_PAGE_ADDR_MASK clears
   bits checked, so redundant asserts. (Sashiko)
 - WARN_ON to verify compact pt and edge pt won't be possible.

Fixes: b912138df299 ("drm/xe: Create page reclaim list on unbind")
Assisted-by: Sashiko-Review:gemini-3.1-pro-preview
Cc: stable@vger.kernel.org
Cc: Matthew Auld <matthew.auld@intel.com>
Suggested-by: Zongyao Bai <zongyao.bai@intel.com>
Signed-off-by: Brian Nguyen <brian3.nguyen@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Zongyao Bai <zongyao.bai@intel.com>
Link: https://patch.msgid.link/20260605224257.2194194-2-brian3.nguyen@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 669252801a4aa4098fbc5dd9dd0bd93f0625abd7)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/regs/xe_gtt_defs.h |    6 +
 drivers/gpu/drm/xe/xe_pt.c            |  133 +++++++++++++++++++---------------
 2 files changed, 83 insertions(+), 56 deletions(-)

--- a/drivers/gpu/drm/xe/regs/xe_gtt_defs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gtt_defs.h
@@ -9,7 +9,11 @@
 #define XELPG_GGTT_PTE_PAT0	BIT_ULL(52)
 #define XELPG_GGTT_PTE_PAT1	BIT_ULL(53)
 
-#define XE_PTE_ADDR_MASK	GENMASK_ULL(51, 12)
+/*
+ * Mask for PTE address bits [51:shift].
+ * shift is the lower address boundary of page.
+ */
+#define XE_PAGE_ADDR_MASK(shift)	GENMASK_ULL(51, (shift))
 #define GGTT_PTE_VFID		GENMASK_ULL(11, 2)
 
 #define GUC_GGTT_TOP		0xFEE00000
--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -1643,23 +1643,21 @@ static bool xe_pt_check_kill(u64 addr, u
 	return false;
 }
 
-/* page_size = 2^(reclamation_size + XE_PTE_SHIFT) */
-#define COMPUTE_RECLAIM_ADDRESS_MASK(page_size)				\
-({									\
-	BUILD_BUG_ON(!__builtin_constant_p(page_size));			\
-	ilog2(page_size) - XE_PTE_SHIFT;				\
-})
-
 static int generate_reclaim_entry(struct xe_tile *tile,
 				  struct xe_page_reclaim_list *prl,
 				  u64 pte, struct xe_pt *xe_child)
 {
 	struct xe_gt *gt = tile->primary_gt;
 	struct xe_guc_page_reclaim_entry *reclaim_entries = prl->entries;
-	u64 phys_addr = pte & XE_PTE_ADDR_MASK;
+	bool is_2m = xe_child->level == 1 && (pte & XE_PDE_PS_2M);
+	bool is_64k = xe_child->level == 0 && ((pte & XE_PTE_PS64) || xe_child->is_compact);
+	u32 page_shift = is_2m ? ilog2(SZ_2M) : is_64k ? ilog2(SZ_64K) : ilog2(SZ_4K);
+	/* Physical address bits start at page shift: 2M->[51:21], 64K->[51:16], 4K->[51:12] */
+	u64 phys_addr = pte & XE_PAGE_ADDR_MASK(page_shift);
+	/* Page address is relative to 4K page regardless of entry level */
 	u64 phys_page = phys_addr >> XE_PTE_SHIFT;
 	int num_entries = prl->num_entries;
-	u32 reclamation_size;
+	u32 reclamation_size = page_shift - XE_PTE_SHIFT;
 
 	xe_tile_assert(tile, xe_child->level <= MAX_HUGEPTE_LEVEL);
 	xe_tile_assert(tile, reclaim_entries);
@@ -1674,18 +1672,12 @@ static int generate_reclaim_entry(struct
 	 * Page size is computed as 2^(reclamation_size + XE_PTE_SHIFT) bytes.
 	 * Only 4K, 64K (level 0), and 2M pages are supported by hardware for page reclaim
 	 */
-	if (xe_child->level == 0 && !(pte & XE_PTE_PS64)) {
-		xe_gt_stats_incr(gt, XE_GT_STATS_ID_PRL_4K_ENTRY_COUNT, 1);
-		reclamation_size = COMPUTE_RECLAIM_ADDRESS_MASK(SZ_4K);  /* reclamation_size = 0 */
-		xe_tile_assert(tile, phys_addr % SZ_4K == 0);
-	} else if (xe_child->level == 0) {
-		xe_gt_stats_incr(gt, XE_GT_STATS_ID_PRL_64K_ENTRY_COUNT, 1);
-		reclamation_size = COMPUTE_RECLAIM_ADDRESS_MASK(SZ_64K); /* reclamation_size = 4 */
-		xe_tile_assert(tile, phys_addr % SZ_64K == 0);
-	} else if (xe_child->level == 1 && pte & XE_PDE_PS_2M) {
+	if (is_2m) {
 		xe_gt_stats_incr(gt, XE_GT_STATS_ID_PRL_2M_ENTRY_COUNT, 1);
-		reclamation_size = COMPUTE_RECLAIM_ADDRESS_MASK(SZ_2M);  /* reclamation_size = 9 */
-		xe_tile_assert(tile, phys_addr % SZ_2M == 0);
+	} else if (is_64k) {
+		xe_gt_stats_incr(gt, XE_GT_STATS_ID_PRL_64K_ENTRY_COUNT, 1);
+	} else if (xe_child->level == 0) {
+		xe_gt_stats_incr(gt, XE_GT_STATS_ID_PRL_4K_ENTRY_COUNT, 1);
 	} else {
 		xe_page_reclaim_list_abort(tile->primary_gt, prl,
 					   "unsupported PTE level=%u pte=%#llx",
@@ -1706,6 +1698,48 @@ static int generate_reclaim_entry(struct
 	return 0;
 }
 
+static int add_pte_to_prl(struct xe_tile *tile, struct xe_page_reclaim_list *prl,
+			  struct xe_pt *xe_child, u64 pte, u64 addr)
+{
+	/*
+	 * In rare scenarios, pte may not be written yet due to racy conditions.
+	 * In such cases, invalidate the PRL and fallback to full PPC invalidation.
+	 */
+	if (!pte) {
+		xe_page_reclaim_list_abort(tile->primary_gt, prl,
+					   "found zero pte at addr=%#llx", addr);
+		return -EINVAL;
+	}
+
+	/* Ensure it is a defined page */
+	xe_tile_assert(tile, xe_child->level == 0 ||
+		       (pte & (XE_PDE_PS_2M | XE_PDPE_PS_1G)));
+
+	/* Account for NULL terminated entry on end (-1) */
+	if (prl->num_entries >= XE_PAGE_RECLAIM_MAX_ENTRIES - 1) {
+		xe_page_reclaim_list_abort(tile->primary_gt, prl,
+					   "overflow while adding pte=%#llx", pte);
+		return -ENOSPC;
+	}
+
+	return generate_reclaim_entry(tile, prl, pte, xe_child);
+}
+
+static bool add_compact_pt_prl(struct xe_tile *tile, struct xe_page_reclaim_list *prl,
+			       struct xe_device *xe, struct xe_pt *compact_pt, u64 addr)
+{
+	struct iosys_map *map = &compact_pt->bo->vmap;
+
+	for (pgoff_t i = 0; i < SZ_2M / SZ_64K && xe_page_reclaim_list_valid(prl); i++) {
+		u64 pte = xe_map_rd(xe, map, i * sizeof(u64), u64);
+
+		if (add_pte_to_prl(tile, prl, compact_pt, pte, addr + i * SZ_64K))
+			break;
+	}
+
+	return xe_page_reclaim_list_valid(prl);
+}
+
 static int xe_pt_stage_unbind_entry(struct xe_ptw *parent, pgoff_t offset,
 				    unsigned int level, u64 addr, u64 next,
 				    struct xe_ptw **child,
@@ -1715,21 +1749,22 @@ static int xe_pt_stage_unbind_entry(stru
 	struct xe_pt *xe_child = container_of(*child, typeof(*xe_child), base);
 	struct xe_pt_stage_unbind_walk *xe_walk =
 		container_of(walk, typeof(*xe_walk), base);
-	struct xe_device *xe = tile_to_xe(xe_walk->tile);
+	struct xe_page_reclaim_list *prl = xe_walk->prl;
+	struct xe_tile *tile = xe_walk->tile;
+	struct xe_device *xe = tile_to_xe(tile);
 	pgoff_t first = xe_pt_offset(addr, xe_child->level, walk);
 	bool killed;
 
 	XE_WARN_ON(!*child);
 	XE_WARN_ON(!level);
 	/* Check for leaf node */
-	if (xe_walk->prl && xe_page_reclaim_list_valid(xe_walk->prl) &&
+	if (prl && xe_page_reclaim_list_valid(prl) &&
 	    xe_child->level <= MAX_HUGEPTE_LEVEL) {
 		struct iosys_map *leaf_map = &xe_child->bo->vmap;
 		pgoff_t count = xe_pt_num_entries(addr, next, xe_child->level, walk);
 
 		for (pgoff_t i = 0; i < count; i++) {
 			u64 pte;
-			int ret;
 
 			/*
 			 * If not a leaf pt, skip unless non-leaf pt is interleaved between
@@ -1739,10 +1774,23 @@ static int xe_pt_stage_unbind_entry(stru
 				u64 pt_size = 1ULL << walk->shifts[xe_child->level];
 				bool edge_pt = (i == 0 && !IS_ALIGNED(addr, pt_size)) ||
 					       (i == count - 1 && !IS_ALIGNED(next, pt_size));
-
-				if (!edge_pt) {
-					xe_page_reclaim_list_abort(xe_walk->tile->primary_gt,
-								   xe_walk->prl,
+				struct xe_pt *child_pt =
+					container_of(xe_child->base.children[first + i],
+						     struct xe_pt, base);
+
+				/* Compact PTs always fill a full 2M-aligned slot, never an edge. */
+				XE_WARN_ON(child_pt->is_compact && edge_pt);
+				if (edge_pt)
+					continue;
+
+				/* Walker never descends into compact PTs, descend now */
+				if (child_pt->is_compact) {
+					if (!add_compact_pt_prl(tile, prl, xe, child_pt,
+								addr + (u64)i * pt_size))
+						break;
+				} else {
+					xe_page_reclaim_list_abort(tile->primary_gt,
+								   prl,
 								   "PT is skipped by walk at level=%u offset=%lu",
 								   xe_child->level, first + i);
 					break;
@@ -1752,37 +1800,12 @@ static int xe_pt_stage_unbind_entry(stru
 
 			pte = xe_map_rd(xe, leaf_map, (first + i) * sizeof(u64), u64);
 
-			/*
-			 * In rare scenarios, pte may not be written yet due to racy conditions.
-			 * In such cases, invalidate the PRL and fallback to full PPC invalidation.
-			 */
-			if (!pte) {
-				xe_page_reclaim_list_abort(xe_walk->tile->primary_gt, xe_walk->prl,
-							   "found zero pte at addr=%#llx", addr);
+			if (add_pte_to_prl(tile, prl, xe_child, pte, addr))
 				break;
-			}
-
-			/* Ensure it is a defined page */
-			xe_tile_assert(xe_walk->tile, xe_child->level == 0 ||
-				       (pte & (XE_PDE_PS_2M | XE_PDPE_PS_1G)));
 
 			/* An entry should be added for 64KB but contigious 4K have XE_PTE_PS64 */
 			if (pte & XE_PTE_PS64)
 				i += 15; /* Skip other 15 consecutive 4K pages in the 64K page */
-
-			/* Account for NULL terminated entry on end (-1) */
-			if (xe_walk->prl->num_entries < XE_PAGE_RECLAIM_MAX_ENTRIES - 1) {
-				ret = generate_reclaim_entry(xe_walk->tile, xe_walk->prl,
-							     pte, xe_child);
-				if (ret)
-					break;
-			} else {
-				/* overflow, mark as invalid */
-				xe_page_reclaim_list_abort(xe_walk->tile->primary_gt, xe_walk->prl,
-							   "overflow while adding pte=%#llx",
-							   pte);
-				break;
-			}
 		}
 	}
 
@@ -1792,7 +1815,7 @@ static int xe_pt_stage_unbind_entry(stru
 	 * Verify if any PTE are potentially dropped at non-leaf levels, either from being
 	 * killed or the page walk covers the region.
 	 */
-	if (xe_walk->prl && xe_page_reclaim_list_valid(xe_walk->prl) &&
+	if (prl && xe_page_reclaim_list_valid(prl) &&
 	    xe_child->level > MAX_HUGEPTE_LEVEL && xe_child->num_live) {
 		bool covered = xe_pt_covers(addr, next, xe_child->level, &xe_walk->base);
 
@@ -1801,7 +1824,7 @@ static int xe_pt_stage_unbind_entry(stru
 		 * we need to invalidate the PRL.
 		 */
 		if (killed || covered)
-			xe_page_reclaim_list_abort(xe_walk->tile->primary_gt, xe_walk->prl,
+			xe_page_reclaim_list_abort(tile->primary_gt, prl,
 						   "kill at level=%u addr=%#llx next=%#llx num_live=%u",
 						   level, addr, next, xe_child->num_live);
 	}


