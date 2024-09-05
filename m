Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64CB155730;
	Thu,  5 Sep 2024 09:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529778; cv=none; b=VSsJXKHAKwhj2QL6dd4kgFnPls5Z9aGwLrENg98vZMe7V6T4Me4PghaCRCtdeSsrLuv189SqDnlMh2eDnI34DqlWPET+QB+vxJW2ijBaXYXPM8zju9QH6PsBmxAnckIU9h6Lk33Lc4s9EdzkcItE+LES9bBUleKAoj6H4rVs/rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529778; c=relaxed/simple;
	bh=isdoswAxJsfOl8qhLIFMYbvp1qNOHtIF8tcVobkmlMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwGbr+Dwum8ZGovd5ASLTUju6oqC5ERrWidlo34M3zihsNcYwup9qH/uHJxAY8OQX4bKnVmBBl4YpxHtQjNDhgAdJYnAMYHYexw/szwMLF2XFIFFEewHPCx3nOoaf6UgnuYvTOTEMWiO7EUcszkoCtl5Qy0zkojpaZrlylrjoP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLMwFHGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLMwFHGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4588C4CEC3;
	Thu,  5 Sep 2024 09:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529778;
	bh=isdoswAxJsfOl8qhLIFMYbvp1qNOHtIF8tcVobkmlMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLMwFHGeUpg2DYne6osR49QNDFZqytal9gOmcAc/RnTIzybYuOxgXgs2us9vY6nnT
	 evtMJz1ypqo7kORQE1Gv2ipBj+eom72f/jg4MBk45qSRy3vWZgWe8q83Lu2o5stCkZ
	 0Ek1Chv/rXmmlRUcvd1GGXvr4LioDCmV1g081tzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Fei Yang <fei.yang@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 140/184] drm/xe: Dont overmap identity VRAM mapping
Date: Thu,  5 Sep 2024 11:40:53 +0200
Message-ID: <20240905093737.683122762@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 6d3581edffea0b3a64b0d3094d3f09222e0024f7 ]

Overmapping the identity VRAM mapping is triggering hardware bugs on
certain platforms. Use 2M pages for the last unaligned (to 1G) VRAM
chunk.

v2:
 - Always use 2M pages for last chunk (Fei Yang)
 - break loop when 2M pages are used
 - Add assert for usable_size being 2M aligned
v3:
 - Fix checkpatch

Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Fei Yang <fei.yang@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240603181824.1927675-1-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_migrate.c | 55 +++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index 198f5c2189cb..208649436fdb 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -69,7 +69,7 @@ struct xe_migrate {
 
 #define MAX_PREEMPTDISABLE_TRANSFER SZ_8M /* Around 1ms. */
 #define MAX_CCS_LIMITED_TRANSFER SZ_4M /* XE_PAGE_SIZE * (FIELD_MAX(XE2_CCS_SIZE_MASK) + 1) */
-#define NUM_KERNEL_PDE 17
+#define NUM_KERNEL_PDE 15
 #define NUM_PT_SLOTS 32
 #define LEVEL0_PAGE_TABLE_ENCODE_SIZE SZ_2M
 #define MAX_NUM_PTE 512
@@ -137,10 +137,11 @@ static int xe_migrate_prepare_vm(struct xe_tile *tile, struct xe_migrate *m,
 	struct xe_device *xe = tile_to_xe(tile);
 	u16 pat_index = xe->pat.idx[XE_CACHE_WB];
 	u8 id = tile->id;
-	u32 num_entries = NUM_PT_SLOTS, num_level = vm->pt_root[id]->level;
+	u32 num_entries = NUM_PT_SLOTS, num_level = vm->pt_root[id]->level,
+	    num_setup = num_level + 1;
 	u32 map_ofs, level, i;
 	struct xe_bo *bo, *batch = tile->mem.kernel_bb_pool->bo;
-	u64 entry;
+	u64 entry, pt30_ofs;
 
 	/* Can't bump NUM_PT_SLOTS too high */
 	BUILD_BUG_ON(NUM_PT_SLOTS > SZ_2M/XE_PAGE_SIZE);
@@ -160,10 +161,12 @@ static int xe_migrate_prepare_vm(struct xe_tile *tile, struct xe_migrate *m,
 	if (IS_ERR(bo))
 		return PTR_ERR(bo);
 
-	entry = vm->pt_ops->pde_encode_bo(bo, bo->size - XE_PAGE_SIZE, pat_index);
+	/* PT31 reserved for 2M identity map */
+	pt30_ofs = bo->size - 2 * XE_PAGE_SIZE;
+	entry = vm->pt_ops->pde_encode_bo(bo, pt30_ofs, pat_index);
 	xe_pt_write(xe, &vm->pt_root[id]->bo->vmap, 0, entry);
 
-	map_ofs = (num_entries - num_level) * XE_PAGE_SIZE;
+	map_ofs = (num_entries - num_setup) * XE_PAGE_SIZE;
 
 	/* Map the entire BO in our level 0 pt */
 	for (i = 0, level = 0; i < num_entries; level++) {
@@ -234,7 +237,7 @@ static int xe_migrate_prepare_vm(struct xe_tile *tile, struct xe_migrate *m,
 	}
 
 	/* Write PDE's that point to our BO. */
-	for (i = 0; i < num_entries - num_level; i++) {
+	for (i = 0; i < map_ofs / PAGE_SIZE; i++) {
 		entry = vm->pt_ops->pde_encode_bo(bo, (u64)i * XE_PAGE_SIZE,
 						  pat_index);
 
@@ -252,28 +255,54 @@ static int xe_migrate_prepare_vm(struct xe_tile *tile, struct xe_migrate *m,
 	/* Identity map the entire vram at 256GiB offset */
 	if (IS_DGFX(xe)) {
 		u64 pos, ofs, flags;
+		/* XXX: Unclear if this should be usable_size? */
+		u64 vram_limit =  xe->mem.vram.actual_physical_size +
+			xe->mem.vram.dpa_base;
 
 		level = 2;
 		ofs = map_ofs + XE_PAGE_SIZE * level + 256 * 8;
 		flags = vm->pt_ops->pte_encode_addr(xe, 0, pat_index, level,
 						    true, 0);
 
+		xe_assert(xe, IS_ALIGNED(xe->mem.vram.usable_size, SZ_2M));
+
 		/*
-		 * Use 1GB pages, it shouldn't matter the physical amount of
-		 * vram is less, when we don't access it.
+		 * Use 1GB pages when possible, last chunk always use 2M
+		 * pages as mixing reserved memory (stolen, WOCPM) with a single
+		 * mapping is not allowed on certain platforms.
 		 */
-		for (pos = xe->mem.vram.dpa_base;
-		     pos < xe->mem.vram.actual_physical_size + xe->mem.vram.dpa_base;
-		     pos += SZ_1G, ofs += 8)
+		for (pos = xe->mem.vram.dpa_base; pos < vram_limit;
+		     pos += SZ_1G, ofs += 8) {
+			if (pos + SZ_1G >= vram_limit) {
+				u64 pt31_ofs = bo->size - XE_PAGE_SIZE;
+
+				entry = vm->pt_ops->pde_encode_bo(bo, pt31_ofs,
+								  pat_index);
+				xe_map_wr(xe, &bo->vmap, ofs, u64, entry);
+
+				flags = vm->pt_ops->pte_encode_addr(xe, 0,
+								    pat_index,
+								    level - 1,
+								    true, 0);
+
+				for (ofs = pt31_ofs; pos < vram_limit;
+				     pos += SZ_2M, ofs += 8)
+					xe_map_wr(xe, &bo->vmap, ofs, u64, pos | flags);
+				break;	/* Ensure pos == vram_limit assert correct */
+			}
+
 			xe_map_wr(xe, &bo->vmap, ofs, u64, pos | flags);
+		}
+
+		xe_assert(xe, pos == vram_limit);
 	}
 
 	/*
 	 * Example layout created above, with root level = 3:
 	 * [PT0...PT7]: kernel PT's for copy/clear; 64 or 4KiB PTE's
 	 * [PT8]: Kernel PT for VM_BIND, 4 KiB PTE's
-	 * [PT9...PT28]: Userspace PT's for VM_BIND, 4 KiB PTE's
-	 * [PT29 = PDE 0] [PT30 = PDE 1] [PT31 = PDE 2]
+	 * [PT9...PT27]: Userspace PT's for VM_BIND, 4 KiB PTE's
+	 * [PT28 = PDE 0] [PT29 = PDE 1] [PT30 = PDE 2] [PT31 = 2M vram identity map]
 	 *
 	 * This makes the lowest part of the VM point to the pagetables.
 	 * Hence the lowest 2M in the vm should point to itself, with a few writes
-- 
2.43.0



