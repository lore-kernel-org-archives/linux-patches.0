Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CE0374195;
	Fri,  7 Aug 2026 15:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115782; cv=none; b=qoonKuzlE0lucI9jYUEaAPz6NW3C6QYCxnefAfFPKsFjfcGnQLMDU0N36vL5zFPHcsf2F5yLRO2SRmpcQu9K7bzwYebeh/Cg9zPZdZIlnarb1FxZoyvF4xHmZrA4Yxwqqin34dhD9wiVN7k/JIVrPLcG1VFAnOIPr3B8d3kN4Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115782; c=relaxed/simple;
	bh=xXSn48xfq9V4BM00gVyrMbZGaxzLx5py7hVHearu+oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0ZFAMEdtyMX3zhc+56ZrwK6nHP83gxKuN/krZ/wWPtlJNXvLG5RCT2Ar1R6ow7rRZ8Px60eDirW+WH8ETp+Ly953r8yfqjcv8UwgIHZej8o4+iN7Ez0If8xO/xWXZYX0qU3TjWGblcUUaTEUMNtu7ybfIEd7WAVIde6PRdD01I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hLuhlfRE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hLuhlfRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBAD1F000E9;
	Fri,  7 Aug 2026 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115781;
	bh=sags9Zzp3z7yLXGnQAB2ek2WjfOMOI/MtDxPpENKwAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLuhlfRE3D7j/mYHq+SNN6NusUn/lmFYvq1xXkx2uJ4PNehJ2XQW/blBaHE/OsC/D
	 7HAdR00JU2GuGsSUVwLg+8xL2Aj4miq2osUATN4nHyHKVTikEzd4OEijW+y1qjuLjs
	 TSED4Z/3IZII2f/bgoXqTsYoHST8hTxWk36aqDUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 388/396] drm/xe: Use SVM range helpers in PT layer
Date: Fri,  7 Aug 2026 16:39:08 +0200
Message-ID: <20260807143432.645764992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 9ea9b45701ab50049a722450abc28346d1121e6e ]

We have helpers SVM range start, end, and size. Use them in the PT
layer rather than directly looking at the struct.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://lore.kernel.org/r/20251022230122.922382-1-matthew.brost@intel.com
Stable-dep-of: 6384271ac1ac ("drm/xe/pt: Reset current_op in xe_pt_update_ops_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_pt.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -715,7 +715,7 @@ xe_pt_stage_bind(struct xe_tile *tile, s
 		.vm = vm,
 		.tile = tile,
 		.curs = &curs,
-		.va_curs_start = range ? range->base.itree.start :
+		.va_curs_start = range ? xe_svm_range_start(range) :
 			xe_vma_start(vma),
 		.vma = vma,
 		.wupd.entries = entries,
@@ -734,7 +734,7 @@ xe_pt_stage_bind(struct xe_tile *tile, s
 		}
 		if (xe_svm_range_has_dma_mapping(range)) {
 			xe_res_first_dma(range->base.pages.dma_addr, 0,
-					 range->base.itree.last + 1 - range->base.itree.start,
+					 xe_svm_range_size(range),
 					 &curs);
 			xe_svm_range_debug(range, "BIND PREPARE - MIXED");
 		} else {
@@ -778,8 +778,8 @@ xe_pt_stage_bind(struct xe_tile *tile, s
 
 walk_pt:
 	ret = xe_pt_walk_range(&pt->base, pt->level,
-			       range ? range->base.itree.start : xe_vma_start(vma),
-			       range ? range->base.itree.last + 1 : xe_vma_end(vma),
+			       range ? xe_svm_range_start(range) : xe_vma_start(vma),
+			       range ? xe_svm_range_end(range) : xe_vma_end(vma),
 			       &xe_walk.base);
 
 	*num_entries = xe_walk.wupd.num_used_entries;
@@ -983,8 +983,8 @@ bool xe_pt_zap_ptes_range(struct xe_tile
 	if (!(pt_mask & BIT(tile->id)))
 		return false;
 
-	(void)xe_pt_walk_shared(&pt->base, pt->level, range->base.itree.start,
-				range->base.itree.last + 1, &xe_walk.base);
+	(void)xe_pt_walk_shared(&pt->base, pt->level, xe_svm_range_start(range),
+				xe_svm_range_end(range), &xe_walk.base);
 
 	return xe_walk.needs_invalidate;
 }
@@ -1711,8 +1711,8 @@ static unsigned int xe_pt_stage_unbind(s
 				       struct xe_svm_range *range,
 				       struct xe_vm_pgtable_update *entries)
 {
-	u64 start = range ? range->base.itree.start : xe_vma_start(vma);
-	u64 end = range ? range->base.itree.last + 1 : xe_vma_end(vma);
+	u64 start = range ? xe_svm_range_start(range) : xe_vma_start(vma);
+	u64 end = range ? xe_svm_range_end(range) : xe_vma_end(vma);
 	struct xe_pt_stage_unbind_walk xe_walk = {
 		.base = {
 			.ops = &xe_pt_stage_unbind_ops,
@@ -1922,7 +1922,7 @@ static int bind_range_prepare(struct xe_
 
 	vm_dbg(&xe_vma_vm(vma)->xe->drm,
 	       "Preparing bind, with range [%lx...%lx)\n",
-	       range->base.itree.start, range->base.itree.last);
+	       xe_svm_range_start(range), xe_svm_range_end(range) - 1);
 
 	pt_op->vma = NULL;
 	pt_op->bind = true;
@@ -1937,8 +1937,8 @@ static int bind_range_prepare(struct xe_
 					pt_op->num_entries, true);
 
 		xe_pt_update_ops_rfence_interval(pt_update_ops,
-						 range->base.itree.start,
-						 range->base.itree.last + 1);
+						 xe_svm_range_start(range),
+						 xe_svm_range_end(range));
 		++pt_update_ops->current_op;
 		pt_update_ops->needs_svm_lock = true;
 
@@ -2033,7 +2033,7 @@ static int unbind_range_prepare(struct x
 
 	vm_dbg(&vm->xe->drm,
 	       "Preparing unbind, with range [%lx...%lx)\n",
-	       range->base.itree.start, range->base.itree.last);
+	       xe_svm_range_start(range), xe_svm_range_end(range) - 1);
 
 	pt_op->vma = XE_INVALID_VMA;
 	pt_op->bind = false;
@@ -2044,8 +2044,8 @@ static int unbind_range_prepare(struct x
 
 	xe_vm_dbg_print_entries(tile_to_xe(tile), pt_op->entries,
 				pt_op->num_entries, false);
-	xe_pt_update_ops_rfence_interval(pt_update_ops, range->base.itree.start,
-					 range->base.itree.last + 1);
+	xe_pt_update_ops_rfence_interval(pt_update_ops, xe_svm_range_start(range),
+					 xe_svm_range_end(range));
 	++pt_update_ops->current_op;
 	pt_update_ops->needs_svm_lock = true;
 	pt_update_ops->needs_invalidation |= xe_vm_has_scratch(vm) ||


