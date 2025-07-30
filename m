Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E8C1ACEDE;
	Wed, 30 Jul 2025 09:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869277; cv=none; b=WK/6dHfOT8thqHEkyp20xMFFgfbVyoA/MeLfStB0RfgtzKGbP99fPQ0UpzLPwGsZfdUSFCcDxDepbt9og/Gf+lpKBr/FiVxf0MBEvKvSm7G7/GhTNlTxM/AVFXp2ms1f885ahIM5Vvho8/twipIoN3ViGY1CHuHIHaZuvKzLk1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869277; c=relaxed/simple;
	bh=BaC7ZfGk9MixhIN/LkvTnCK7biw52wdERWKrKNxlXb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5d2M83zMPyXikFxK0f5qkQjGRzlig6kTF2/OZJiOk7Mot3lHe8J4WSHbuE4XT5iXdGndLQWbceb1OHzDZHPidxYdQRigLO0DrdhS0C7/eBnBnbYIP7+LClt+5nYijS6N0KvCT3lMMHA4X2D3HRHgkK5zu8UIKHk8qHjTksNBkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SP+nf2Wf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SP+nf2Wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D645CC4CEF5;
	Wed, 30 Jul 2025 09:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869276;
	bh=BaC7ZfGk9MixhIN/LkvTnCK7biw52wdERWKrKNxlXb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SP+nf2WfU7jgyB/Y2dqkMD5fes5TqjM9T3D81VGiCIKiflJKD2UoW+dTVF+pwDk6d
	 wYq+CfqIiwSM7Wjca0IBXFa74D1ujN1mDjTGIZs5m01sLNLMwgOkyE2vXrQ6R5KFHV
	 oKukYgZyLWoBhfdQnSlJKqUNS+ZxSTwRtxRPjj2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 81/92] drm/xe: Make WA BB part of LRC BO
Date: Wed, 30 Jul 2025 11:36:29 +0200
Message-ID: <20250730093233.885890312@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

commit afcad92411772a1f361339f22c49f855c6cc7d0f upstream.

No idea why, but without this GuC context switches randomly fail when
running IGTs in a loop. Need to follow up why this fixes the
aforementioned issue but can live with a stable driver for now.

Fixes: 617d824c5323 ("drm/xe: Add WA BB to capture active context utilization")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Tested-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://lore.kernel.org/r/20250612031925.4009701-1-matthew.brost@intel.com
(cherry picked from commit 3a1edef8f4b58b0ba826bc68bf4bce4bdf59ecf3)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
[ adapted xe_bo_create_pin_map() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_lrc.c       |   37 +++++++++++++++++++------------------
 drivers/gpu/drm/xe/xe_lrc_types.h |    3 ---
 2 files changed, 19 insertions(+), 21 deletions(-)

--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -39,6 +39,7 @@
 #define LRC_ENGINE_INSTANCE			GENMASK_ULL(53, 48)
 
 #define LRC_INDIRECT_RING_STATE_SIZE		SZ_4K
+#define LRC_WA_BB_SIZE				SZ_4K
 
 static struct xe_device *
 lrc_to_xe(struct xe_lrc *lrc)
@@ -910,7 +911,11 @@ static void xe_lrc_finish(struct xe_lrc
 	xe_bo_unpin(lrc->bo);
 	xe_bo_unlock(lrc->bo);
 	xe_bo_put(lrc->bo);
-	xe_bo_unpin_map_no_vm(lrc->bb_per_ctx_bo);
+}
+
+static size_t wa_bb_offset(struct xe_lrc *lrc)
+{
+	return lrc->bo->size - LRC_WA_BB_SIZE;
 }
 
 /*
@@ -943,15 +948,16 @@ static void xe_lrc_finish(struct xe_lrc
 #define CONTEXT_ACTIVE 1ULL
 static int xe_lrc_setup_utilization(struct xe_lrc *lrc)
 {
+	const size_t max_size = LRC_WA_BB_SIZE;
 	u32 *cmd, *buf = NULL;
 
-	if (lrc->bb_per_ctx_bo->vmap.is_iomem) {
-		buf = kmalloc(lrc->bb_per_ctx_bo->size, GFP_KERNEL);
+	if (lrc->bo->vmap.is_iomem) {
+		buf = kmalloc(max_size, GFP_KERNEL);
 		if (!buf)
 			return -ENOMEM;
 		cmd = buf;
 	} else {
-		cmd = lrc->bb_per_ctx_bo->vmap.vaddr;
+		cmd = lrc->bo->vmap.vaddr + wa_bb_offset(lrc);
 	}
 
 	*cmd++ = MI_STORE_REGISTER_MEM | MI_SRM_USE_GGTT | MI_SRM_ADD_CS_OFFSET;
@@ -974,13 +980,14 @@ static int xe_lrc_setup_utilization(stru
 	*cmd++ = MI_BATCH_BUFFER_END;
 
 	if (buf) {
-		xe_map_memcpy_to(gt_to_xe(lrc->gt), &lrc->bb_per_ctx_bo->vmap, 0,
-				 buf, (cmd - buf) * sizeof(*cmd));
+		xe_map_memcpy_to(gt_to_xe(lrc->gt), &lrc->bo->vmap,
+				 wa_bb_offset(lrc), buf,
+				 (cmd - buf) * sizeof(*cmd));
 		kfree(buf);
 	}
 
-	xe_lrc_write_ctx_reg(lrc, CTX_BB_PER_CTX_PTR,
-			     xe_bo_ggtt_addr(lrc->bb_per_ctx_bo) | 1);
+	xe_lrc_write_ctx_reg(lrc, CTX_BB_PER_CTX_PTR, xe_bo_ggtt_addr(lrc->bo) +
+			     wa_bb_offset(lrc) + 1);
 
 	return 0;
 }
@@ -1016,20 +1023,13 @@ static int xe_lrc_init(struct xe_lrc *lr
 	 * FIXME: Perma-pinning LRC as we don't yet support moving GGTT address
 	 * via VM bind calls.
 	 */
-	lrc->bo = xe_bo_create_pin_map(xe, tile, vm, lrc_size,
+	lrc->bo = xe_bo_create_pin_map(xe, tile, vm,
+				       lrc_size + LRC_WA_BB_SIZE,
 				       ttm_bo_type_kernel,
 				       bo_flags);
 	if (IS_ERR(lrc->bo))
 		return PTR_ERR(lrc->bo);
 
-	lrc->bb_per_ctx_bo = xe_bo_create_pin_map(xe, tile, NULL, SZ_4K,
-						  ttm_bo_type_kernel,
-						  bo_flags);
-	if (IS_ERR(lrc->bb_per_ctx_bo)) {
-		err = PTR_ERR(lrc->bb_per_ctx_bo);
-		goto err_lrc_finish;
-	}
-
 	lrc->size = lrc_size;
 	lrc->ring.size = ring_size;
 	lrc->ring.tail = 0;
@@ -1819,7 +1819,8 @@ struct xe_lrc_snapshot *xe_lrc_snapshot_
 	snapshot->seqno = xe_lrc_seqno(lrc);
 	snapshot->lrc_bo = xe_bo_get(lrc->bo);
 	snapshot->lrc_offset = xe_lrc_pphwsp_offset(lrc);
-	snapshot->lrc_size = lrc->bo->size - snapshot->lrc_offset;
+	snapshot->lrc_size = lrc->bo->size - snapshot->lrc_offset -
+		LRC_WA_BB_SIZE;
 	snapshot->lrc_snapshot = NULL;
 	snapshot->ctx_timestamp = lower_32_bits(xe_lrc_ctx_timestamp(lrc));
 	snapshot->ctx_job_timestamp = xe_lrc_ctx_job_timestamp(lrc);
--- a/drivers/gpu/drm/xe/xe_lrc_types.h
+++ b/drivers/gpu/drm/xe/xe_lrc_types.h
@@ -53,9 +53,6 @@ struct xe_lrc {
 
 	/** @ctx_timestamp: readout value of CTX_TIMESTAMP on last update */
 	u64 ctx_timestamp;
-
-	/** @bb_per_ctx_bo: buffer object for per context batch wa buffer */
-	struct xe_bo *bb_per_ctx_bo;
 };
 
 struct xe_lrc_snapshot;


