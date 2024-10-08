Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6071DF975;
	Tue,  8 Oct 2024 12:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390246; cv=none; b=fgicqCFX4uuTnIXawwWS6PiWONbXP8YAiuXINNSs8PJrFEhhfMotzriN3s8nAV1tETEep/ZNYjNjgTNO2/y1CKfiSXqgt64r/pgPZOZ41fUsKRjW/5dZVyjCGWN1ZibKciMN+1UXjCxqIs8qyOa4mMt2z2IVSGk/SfOld0xuVXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390246; c=relaxed/simple;
	bh=GTmKg6N4f6y/Yahor0ylEsPFkDGCO+gMf+pWhcCMQeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHNkgEliMicRaSiH2YmVj07Tdx8TkbewFYcNf/2ZyxrIQwxsHqpRfFiMSDwLcNNvqkcPxRiQR/Aq8zxUG2aVNYQbG5Ak1H3m0bSE9c4KT6YSmL6hfPZFtjnMDqQ6StCfWtyE+641y4oXlx70fwYGEOY81DNwpBpYBPxK1o6Jj9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9T3HQtc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9T3HQtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44455C4CECC;
	Tue,  8 Oct 2024 12:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390245;
	bh=GTmKg6N4f6y/Yahor0ylEsPFkDGCO+gMf+pWhcCMQeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9T3HQtcYkUBHGVV1zSd0BFZc5V+jXvaVmglCFORhUjrea/wkDerxZxNDJdK/mV0e
	 gVb598xV3bprSGckeRIZa/sZNQgBxROIw8QP10eUZzVIioH1wybXA0PtFn3Bw2sxP9
	 /l+kyQAnznXlGXsGkJIlSnHghF/3/11vawKpsl1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Summers <stuart.summers@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 234/482] drm/xe: Use topology to determine page fault queue size
Date: Tue,  8 Oct 2024 14:04:57 +0200
Message-ID: <20241008115657.508630583@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Stuart Summers <stuart.summers@intel.com>

[ Upstream commit 3338e4f90c143cf32f77d64f464cb7f2c2d24700 ]

Currently the page fault queue size is hard coded. However
the hardware supports faulting for each EU and each CS.
For some applications running on hardware with a large
number of EUs and CSs, this can result in an overflow of
the page fault queue.

Add a small calculation to determine the page fault queue
size based on the number of EUs and CSs in the platform as
detmined by fuses.

Signed-off-by: Stuart Summers <stuart.summers@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/24d582a3b48c97793b8b6a402f34b4b469471636.1723862633.git.stuart.summers@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_pagefault.c | 54 +++++++++++++++++++++-------
 drivers/gpu/drm/xe/xe_gt_types.h     |  9 +++--
 2 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_pagefault.c b/drivers/gpu/drm/xe/xe_gt_pagefault.c
index 67e8efcaa93f1..ee78b4e47dfcb 100644
--- a/drivers/gpu/drm/xe/xe_gt_pagefault.c
+++ b/drivers/gpu/drm/xe/xe_gt_pagefault.c
@@ -307,7 +307,7 @@ static bool get_pagefault(struct pf_queue *pf_queue, struct pagefault *pf)
 			PFD_VIRTUAL_ADDR_LO_SHIFT;
 
 		pf_queue->tail = (pf_queue->tail + PF_MSG_LEN_DW) %
-			PF_QUEUE_NUM_DW;
+			pf_queue->num_dw;
 		ret = true;
 	}
 	spin_unlock_irq(&pf_queue->lock);
@@ -319,7 +319,8 @@ static bool pf_queue_full(struct pf_queue *pf_queue)
 {
 	lockdep_assert_held(&pf_queue->lock);
 
-	return CIRC_SPACE(pf_queue->head, pf_queue->tail, PF_QUEUE_NUM_DW) <=
+	return CIRC_SPACE(pf_queue->head, pf_queue->tail,
+			  pf_queue->num_dw) <=
 		PF_MSG_LEN_DW;
 }
 
@@ -332,22 +333,23 @@ int xe_guc_pagefault_handler(struct xe_guc *guc, u32 *msg, u32 len)
 	u32 asid;
 	bool full;
 
-	/*
-	 * The below logic doesn't work unless PF_QUEUE_NUM_DW % PF_MSG_LEN_DW == 0
-	 */
-	BUILD_BUG_ON(PF_QUEUE_NUM_DW % PF_MSG_LEN_DW);
-
 	if (unlikely(len != PF_MSG_LEN_DW))
 		return -EPROTO;
 
 	asid = FIELD_GET(PFD_ASID, msg[1]);
 	pf_queue = gt->usm.pf_queue + (asid % NUM_PF_QUEUE);
 
+	/*
+	 * The below logic doesn't work unless PF_QUEUE_NUM_DW % PF_MSG_LEN_DW == 0
+	 */
+	xe_gt_assert(gt, !(pf_queue->num_dw % PF_MSG_LEN_DW));
+
 	spin_lock_irqsave(&pf_queue->lock, flags);
 	full = pf_queue_full(pf_queue);
 	if (!full) {
 		memcpy(pf_queue->data + pf_queue->head, msg, len * sizeof(u32));
-		pf_queue->head = (pf_queue->head + len) % PF_QUEUE_NUM_DW;
+		pf_queue->head = (pf_queue->head + len) %
+			pf_queue->num_dw;
 		queue_work(gt->usm.pf_wq, &pf_queue->worker);
 	} else {
 		drm_warn(&xe->drm, "PF Queue full, shouldn't be possible");
@@ -406,26 +408,54 @@ static void pagefault_fini(void *arg)
 {
 	struct xe_gt *gt = arg;
 	struct xe_device *xe = gt_to_xe(gt);
+	int i;
 
 	if (!xe->info.has_usm)
 		return;
 
 	destroy_workqueue(gt->usm.acc_wq);
 	destroy_workqueue(gt->usm.pf_wq);
+
+	for (i = 0; i < NUM_PF_QUEUE; ++i)
+		kfree(gt->usm.pf_queue[i].data);
+}
+
+static int xe_alloc_pf_queue(struct xe_gt *gt, struct pf_queue *pf_queue)
+{
+	xe_dss_mask_t all_dss;
+	int num_dss, num_eus;
+
+	bitmap_or(all_dss, gt->fuse_topo.g_dss_mask, gt->fuse_topo.c_dss_mask,
+		  XE_MAX_DSS_FUSE_BITS);
+
+	num_dss = bitmap_weight(all_dss, XE_MAX_DSS_FUSE_BITS);
+	num_eus = bitmap_weight(gt->fuse_topo.eu_mask_per_dss,
+				XE_MAX_EU_FUSE_BITS) * num_dss;
+
+	/* user can issue separate page faults per EU and per CS */
+	pf_queue->num_dw =
+		(num_eus + XE_NUM_HW_ENGINES) * PF_MSG_LEN_DW;
+
+	pf_queue->gt = gt;
+	pf_queue->data = kzalloc(pf_queue->num_dw, GFP_KERNEL);
+	spin_lock_init(&pf_queue->lock);
+	INIT_WORK(&pf_queue->worker, pf_queue_work_func);
+
+	return 0;
 }
 
 int xe_gt_pagefault_init(struct xe_gt *gt)
 {
 	struct xe_device *xe = gt_to_xe(gt);
-	int i;
+	int i, ret = 0;
 
 	if (!xe->info.has_usm)
 		return 0;
 
 	for (i = 0; i < NUM_PF_QUEUE; ++i) {
-		gt->usm.pf_queue[i].gt = gt;
-		spin_lock_init(&gt->usm.pf_queue[i].lock);
-		INIT_WORK(&gt->usm.pf_queue[i].worker, pf_queue_work_func);
+		ret = xe_alloc_pf_queue(gt, &gt->usm.pf_queue[i]);
+		if (ret)
+			return ret;
 	}
 	for (i = 0; i < NUM_ACC_QUEUE; ++i) {
 		gt->usm.acc_queue[i].gt = gt;
diff --git a/drivers/gpu/drm/xe/xe_gt_types.h b/drivers/gpu/drm/xe/xe_gt_types.h
index cfdc761ff7f46..2dbea50cd8f98 100644
--- a/drivers/gpu/drm/xe/xe_gt_types.h
+++ b/drivers/gpu/drm/xe/xe_gt_types.h
@@ -229,9 +229,14 @@ struct xe_gt {
 		struct pf_queue {
 			/** @usm.pf_queue.gt: back pointer to GT */
 			struct xe_gt *gt;
-#define PF_QUEUE_NUM_DW	128
 			/** @usm.pf_queue.data: data in the page fault queue */
-			u32 data[PF_QUEUE_NUM_DW];
+			u32 *data;
+			/**
+			 * @usm.pf_queue.num_dw: number of DWORDS in the page
+			 * fault queue. Dynamically calculated based on the number
+			 * of compute resources available.
+			 */
+			u32 num_dw;
 			/**
 			 * @usm.pf_queue.tail: tail pointer in DWs for page fault queue,
 			 * moved by worker which processes faults (consumer).
-- 
2.43.0



