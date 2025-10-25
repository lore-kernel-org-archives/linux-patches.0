Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27646302CB8;
	Sat, 25 Oct 2025 16:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409484; cv=none; b=s7VG2H0aI1b5mVoPONWjyj/XKPn+7HpJlIIL1c0L9XI6X3lR1BgqfV6h+3VoU/+pdbsAhchiFyaUsptnlzgvUURsVRbMFKFXFFSx53Bdha9mN0BZ23fscgc8KQmNxRVlRvQQJRiSAwNZULFUXLymcAByipne9XBKiDIP/f/vtS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409484; c=relaxed/simple;
	bh=DvjHgIqTUYUSmQLZ6UrLNKfbIO2pBoyCIPtCmAEGx/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WMb2BtWML2t+kD6ySLhkVkVtCwsDciAiTvERoy1uBAw/snxKlR9ZFGcXv2B4Mg5cmXwrApW8XAgswGZ6MgFcHEYFdad2PjhfrX6toxT7NpazSX/ohlc/SV1BY7E0Zb7pglFbaPvJmKXwzbO2EFXSC22tWpX0Q7gWbejjsyVAb4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzWMdEpJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzWMdEpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CDBC4CEFF;
	Sat, 25 Oct 2025 16:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409484;
	bh=DvjHgIqTUYUSmQLZ6UrLNKfbIO2pBoyCIPtCmAEGx/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzWMdEpJm+ZTkBKfHjwOx+e/Z6y0fe58PSXhCzLeg9WZDiIDdsjY2QYdic/fJwvpO
	 vUhw5/7s+37ascTeC+upCdqEXE4ND1QTOljdc7q0la0jeCn2e7txqYrjhgVAMM4L7S
	 2UpCN3igKxf/iHRIx5SoC0o0acq+Cadc84i05nT0ryaCn1OaXDmvzPsW6bjEiruNxn
	 1K4J8eYFjl6XmIbFNBY18in5ReYC3Sydl9g7LO2cg0Kbc29d2eF63Z6IZHRzeVlCvS
	 FzCa03BedyocbUBU0qdTaSRiQpX5KHVSnxdEtJRmJz6+EMwzL2Ln08sNnythyNTTIs
	 UeVwZaNw1M1qw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Auld <matthew.auld@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/xe: rework PDE PAT index selection
Date: Sat, 25 Oct 2025 11:59:35 -0400
Message-ID: <20251025160905.3857885-344-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 17593a69b75f098280ad88b625f2d8c5bfe4c6a1 ]

For non-leaf paging structures we end up selecting a random index
between [0, 3], depending on the first user if the page-table is shared,
since non-leaf structures only have two bits in the HW for encoding the
PAT index, and here we are just passing along the full user provided
index, which can be an index as large as ~31 on xe2+. The user provided
index is meant for the leaf node, which maps the actual BO pages where
we have more PAT bits, and not the non-leaf nodes which are only mapping
other paging structures, and so only needs a minimal PAT index range.
Also the chosen index might need to consider how the driver mapped the
paging structures on the host side, like wc vs wb, which is separate
from the user provided index.

With that move the PDE PAT index selection under driver control. For now
just use a coherent index on platforms with page-tables that are cached
on host side, and incoherent otherwise. Using a coherent index could
potentially be expensive, and would be overkill if we know the page-table
is always uncached on host side.

v2 (Stuart):
  - Add some documentation and split into separate helper.

BSpec: 59510
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Stuart Summers <stuart.summers@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://lore.kernel.org/r/20250808103455.462424-2-matthew.auld@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Non-leaf page-table entries (PDE/PDPE) have only two PAT bits in HW,
    but the driver was passing the full user-provided PAT index (which
    can be up to ~31 on xe2+). This meant the effective index was just
    the low 2 bits and could vary “randomly” depending on the first VMA
    that created a shared page-table level. That is a
    correctness/coherency bug for non-leaf page-table levels that only
    point to paging structures and must reflect how those paging
    structures are mapped on the host.
  - Commit moves PDE PAT index selection under driver control and ties
    it to the page-table BO’s actual host-side caching/coherency rather
    than the user PAT for leaf mappings.

- Evidence in current code
  - PDE encoding currently uses the caller’s `pat_index`:
    - `drivers/gpu/drm/xe/xe_vm.c:1550` (`xelp_pde_encode_bo(...,
      pat_index)`) sets only PAT0/PAT1 via `pde_encode_pat_index()`
      despite callers passing broader user PATs (including bit4 on
      xe2+).
    - PDE is fed the user’s PAT in multiple places:
      - `drivers/gpu/drm/xe/xe_pt.c:619` (stage-bind:
        `pde_encode_bo(xe_child->bo, 0, pat_index)`)
      - `drivers/gpu/drm/xe/xe_migrate.c:212, 303, 314` (migration
        identity and pagetable setup paths)
      - `drivers/gpu/drm/xe/xe_pt.c:71-73` (scratch PT path)
      - `drivers/gpu/drm/xe/xe_vm.c:2088-2091` (PDP descriptor)
  - PAT encoding functions show the mismatch explicitly:
    - `drivers/gpu/drm/xe/xe_vm.c:1499-1510` encodes only two bits for
      PDE/PDPE in `pde_encode_pat_index()`, while leaf PTE path
      (`pte_encode_pat_index()`, `drivers/gpu/drm/xe/xe_vm.c:1512-1536`)
      supports more bits (incl. `PAT4` on xe2+), reinforcing that the
      user PAT applies to leaf entries, not PDEs.

- What the patch changes
  - Drops `pat_index` from the PDE encoder vfunc
    (`drivers/gpu/drm/xe/xe_pt_types.h:48-50`).
  - Adds a new helper to choose a PDE PAT index based on the BO’s
    placement and host-side caching (WB for cached system-memory page
    tables; NONE if VRAM or WC/uncached) and asserts it fits the 2-bit
    range.
  - Updates all PDE call sites to the new signature (e.g.,
    `drivers/gpu/drm/xe/xe_pt.c:619`, `drivers/gpu/drm/xe/xe_migrate.c`
    call sites, `drivers/gpu/drm/xe/xe_vm.c:2088-2091`).
  - Leaf PTE encoding remains unchanged and continues to honor the user-
    provided PAT index (`drivers/gpu/drm/xe/xe_pt.c:544-555`,
    `drivers/gpu/drm/xe/xe_vm.c:1562-1585`).

- Why the new policy is correct and safe
  - Non-leaf entries only point to other page tables, so they need a
    small, fixed PAT selection tied to how those page tables are
    accessed by host/GPU, not the VMA’s user PAT intended for leaf
    pages. The new helper encodes this explicitly.
  - The chosen indices are guaranteed to fit the 2-bit encoding:
    platform PAT tables assign WB/NONE indices in the [0..3] range
    across platforms (see `drivers/gpu/drm/xe/xe_pat.c:392-396` for xe2,
    `drivers/gpu/drm/xe/xe_pat.c:401-403` for MTL,
    `drivers/gpu/drm/xe/xe_pat.c:427-429` for DG2/XeLP).
  - The policy aligns with how the driver sets page-table BO caching:
    - For iGPU/Xe_LPG+ page tables use CPU:WC (`ttm_write_combined`)
      (`drivers/gpu/drm/xe/xe_bo.c:472-496` when
      `XE_BO_FLAG_PAGETABLE`), which the new code maps to an incoherent
      PDE PAT (NONE).
    - For DGFX system memory page tables, CPU caching is WB
      (`ttm_cached`), and the new code uses a coherent PDE PAT (WB).
  - The change is localized to the XE driver, does not alter ABI or
    user-visible uAPI, and keeps leaf PTE behavior intact.

- Stable backport criteria
  - Fixes a real and subtle bug that can lead to non-deterministic PDE
    PAT selection and potential coherency/performance issues in shared
    page-table levels.
  - Small, self-contained change within `drivers/gpu/drm/xe`, with
    mechanical signature updates and a new helper.
  - No architectural changes; no cross-subsystem effects.
  - Leaf-page behavior remains unchanged; regression risk is low.

- Potential side effects and risk
  - PDE PAT is no longer implicitly influenced by the first VMA’s user
    PAT, removing non-determinism. Any workload that accidentally relied
    on that non-determinism gains correctness, not a regression.
  - The assert that the chosen PAT index ≤ 3 is valid given current PAT
    table assignments and acts as a safeguard.

Conclusion: This is a targeted correctness fix to avoid misusing the
user PAT in non-leaf entries and to align PDE PAT with the page-table
BO’s coherency model. It is small, contained, and low risk. It should be
backported.

 drivers/gpu/drm/xe/xe_migrate.c  | 10 ++++------
 drivers/gpu/drm/xe/xe_pt.c       |  4 ++--
 drivers/gpu/drm/xe/xe_pt_types.h |  3 +--
 drivers/gpu/drm/xe/xe_vm.c       | 34 +++++++++++++++++++++++++++-----
 4 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index 13e287e037096..9b1e3dce1aea3 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -163,8 +163,7 @@ static void xe_migrate_program_identity(struct xe_device *xe, struct xe_vm *vm,
 	for (pos = dpa_base; pos < vram_limit;
 	     pos += SZ_1G, ofs += 8) {
 		if (pos + SZ_1G >= vram_limit) {
-			entry = vm->pt_ops->pde_encode_bo(bo, pt_2m_ofs,
-							  pat_index);
+			entry = vm->pt_ops->pde_encode_bo(bo, pt_2m_ofs);
 			xe_map_wr(xe, &bo->vmap, ofs, u64, entry);
 
 			flags = vm->pt_ops->pte_encode_addr(xe, 0,
@@ -218,7 +217,7 @@ static int xe_migrate_prepare_vm(struct xe_tile *tile, struct xe_migrate *m,
 
 	/* PT30 & PT31 reserved for 2M identity map */
 	pt29_ofs = xe_bo_size(bo) - 3 * XE_PAGE_SIZE;
-	entry = vm->pt_ops->pde_encode_bo(bo, pt29_ofs, pat_index);
+	entry = vm->pt_ops->pde_encode_bo(bo, pt29_ofs);
 	xe_pt_write(xe, &vm->pt_root[id]->bo->vmap, 0, entry);
 
 	map_ofs = (num_entries - num_setup) * XE_PAGE_SIZE;
@@ -286,15 +285,14 @@ static int xe_migrate_prepare_vm(struct xe_tile *tile, struct xe_migrate *m,
 			flags = XE_PDE_64K;
 
 		entry = vm->pt_ops->pde_encode_bo(bo, map_ofs + (u64)(level - 1) *
-						  XE_PAGE_SIZE, pat_index);
+						  XE_PAGE_SIZE);
 		xe_map_wr(xe, &bo->vmap, map_ofs + XE_PAGE_SIZE * level, u64,
 			  entry | flags);
 	}
 
 	/* Write PDE's that point to our BO. */
 	for (i = 0; i < map_ofs / PAGE_SIZE; i++) {
-		entry = vm->pt_ops->pde_encode_bo(bo, (u64)i * XE_PAGE_SIZE,
-						  pat_index);
+		entry = vm->pt_ops->pde_encode_bo(bo, (u64)i * XE_PAGE_SIZE);
 
 		xe_map_wr(xe, &bo->vmap, map_ofs + XE_PAGE_SIZE +
 			  (i + 1) * 8, u64, entry);
diff --git a/drivers/gpu/drm/xe/xe_pt.c b/drivers/gpu/drm/xe/xe_pt.c
index c8e63bd23300e..eb9774a8f683c 100644
--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -69,7 +69,7 @@ static u64 __xe_pt_empty_pte(struct xe_tile *tile, struct xe_vm *vm,
 
 	if (level > MAX_HUGEPTE_LEVEL)
 		return vm->pt_ops->pde_encode_bo(vm->scratch_pt[id][level - 1]->bo,
-						 0, pat_index);
+						 0);
 
 	return vm->pt_ops->pte_encode_addr(xe, 0, pat_index, level, IS_DGFX(xe), 0) |
 		XE_PTE_NULL;
@@ -616,7 +616,7 @@ xe_pt_stage_bind_entry(struct xe_ptw *parent, pgoff_t offset,
 			xe_child->is_compact = true;
 		}
 
-		pte = vm->pt_ops->pde_encode_bo(xe_child->bo, 0, pat_index) | flags;
+		pte = vm->pt_ops->pde_encode_bo(xe_child->bo, 0) | flags;
 		ret = xe_pt_insert_entry(xe_walk, xe_parent, offset, xe_child,
 					 pte);
 	}
diff --git a/drivers/gpu/drm/xe/xe_pt_types.h b/drivers/gpu/drm/xe/xe_pt_types.h
index 69eab6f37cfe6..17cdd7c7e9f5e 100644
--- a/drivers/gpu/drm/xe/xe_pt_types.h
+++ b/drivers/gpu/drm/xe/xe_pt_types.h
@@ -45,8 +45,7 @@ struct xe_pt_ops {
 	u64 (*pte_encode_addr)(struct xe_device *xe, u64 addr,
 			       u16 pat_index,
 			       u32 pt_level, bool devmem, u64 flags);
-	u64 (*pde_encode_bo)(struct xe_bo *bo, u64 bo_offset,
-			     u16 pat_index);
+	u64 (*pde_encode_bo)(struct xe_bo *bo, u64 bo_offset);
 };
 
 struct xe_pt_entry {
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index bf44cd5bf49c0..30c32717a980e 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1547,14 +1547,39 @@ static u64 pte_encode_ps(u32 pt_level)
 	return 0;
 }
 
-static u64 xelp_pde_encode_bo(struct xe_bo *bo, u64 bo_offset,
-			      const u16 pat_index)
+static u16 pde_pat_index(struct xe_bo *bo)
+{
+	struct xe_device *xe = xe_bo_device(bo);
+	u16 pat_index;
+
+	/*
+	 * We only have two bits to encode the PAT index in non-leaf nodes, but
+	 * these only point to other paging structures so we only need a minimal
+	 * selection of options. The user PAT index is only for encoding leaf
+	 * nodes, where we have use of more bits to do the encoding. The
+	 * non-leaf nodes are instead under driver control so the chosen index
+	 * here should be distict from the user PAT index. Also the
+	 * corresponding coherency of the PAT index should be tied to the
+	 * allocation type of the page table (or at least we should pick
+	 * something which is always safe).
+	 */
+	if (!xe_bo_is_vram(bo) && bo->ttm.ttm->caching == ttm_cached)
+		pat_index = xe->pat.idx[XE_CACHE_WB];
+	else
+		pat_index = xe->pat.idx[XE_CACHE_NONE];
+
+	xe_assert(xe, pat_index <= 3);
+
+	return pat_index;
+}
+
+static u64 xelp_pde_encode_bo(struct xe_bo *bo, u64 bo_offset)
 {
 	u64 pde;
 
 	pde = xe_bo_addr(bo, bo_offset, XE_PAGE_SIZE);
 	pde |= XE_PAGE_PRESENT | XE_PAGE_RW;
-	pde |= pde_encode_pat_index(pat_index);
+	pde |= pde_encode_pat_index(pde_pat_index(bo));
 
 	return pde;
 }
@@ -2085,8 +2110,7 @@ struct xe_vm *xe_vm_lookup(struct xe_file *xef, u32 id)
 
 u64 xe_vm_pdp4_descriptor(struct xe_vm *vm, struct xe_tile *tile)
 {
-	return vm->pt_ops->pde_encode_bo(vm->pt_root[tile->id]->bo, 0,
-					 tile_to_xe(tile)->pat.idx[XE_CACHE_WB]);
+	return vm->pt_ops->pde_encode_bo(vm->pt_root[tile->id]->bo, 0);
 }
 
 static struct xe_exec_queue *
-- 
2.51.0

