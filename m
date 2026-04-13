Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61947225A38;
	Mon, 13 Apr 2026 16:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097837; cv=none; b=iRLxeHB+3pDLiiTfveyOJuGR1T0p0sEsFfkmsYmkyus1Qn/uZUGG7wxqJrZIFsCj/ud+A9PC4Y4F7jAVLFpSlaUAKXslFzxpp5POL/+lEFJ1nVkYwWvpbK07Og3jS0/8LnW4SsZ27Od93ILv1dCia4/o0JEAQp3If250TC1hMig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097837; c=relaxed/simple;
	bh=pzdGXXbJPp5/UHYeU6gopXz0GAKfe/TCR8zox8O8khU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzbraGOiIqKV2/BJerJM7vdlUxAB7H9QOvQpV5Mmzth6//aZwVaQQpJvPP/HD67SzCOLcxBsBPIFIcmHR1vmv7V0T2IBHrrkKW8hrk655Z+o81PuNOGp+aHphmXeqIIAiEz45XSz/iQ7afI/kQtnmlQmQpd/72/sMMl9VZa77+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCzckTGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCzckTGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5F8C2BCAF;
	Mon, 13 Apr 2026 16:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097837;
	bh=pzdGXXbJPp5/UHYeU6gopXz0GAKfe/TCR8zox8O8khU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCzckTGPFoi1KJN4LkjzsXF24cLYFlWdtV8rd+iCadBSWBWXGjgMmdhNKh7cf9S26
	 DzfOS2acwgNJbJDtKonxtQhSzdTzwvj+/CMDKipzp3OG6pqkPNfpdf4katsVyP6IWa
	 V+Kvl2LrVhGjGeb0Wh4gVMSJPhnjzmrUZkvACfNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dexuan Cui <decui@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/570] net: mana: Improve the HWC error handling
Date: Mon, 13 Apr 2026 17:56:35 +0200
Message-ID: <20260413155840.371679769@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 62ea8b77ed3b7086561765df0226ebc7bb442020 ]

Currently when the HWC creation fails, the error handling is flawed,
e.g. if mana_hwc_create_channel() -> mana_hwc_establish_channel() fails,
the resources acquired in mana_hwc_init_queues() is not released.

Enhance mana_hwc_destroy_channel() to do the proper cleanup work and
call it accordingly.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: fa103fc8f569 ("net: mana: fix use-after-free in mana_hwc_destroy_channel() by reordering teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   |  4 --
 .../net/ethernet/microsoft/mana/hw_channel.c  | 71 ++++++++-----------
 2 files changed, 31 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 7864611f55a77..f3e90313a4487 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1336,8 +1336,6 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 clean_up_gdma:
 	mana_hwc_destroy_channel(gc);
-	vfree(gc->cq_table);
-	gc->cq_table = NULL;
 remove_irq:
 	mana_gd_remove_irqs(pdev);
 unmap_bar:
@@ -1360,8 +1358,6 @@ static void mana_gd_remove(struct pci_dev *pdev)
 	mana_remove(&gc->mana);
 
 	mana_hwc_destroy_channel(gc);
-	vfree(gc->cq_table);
-	gc->cq_table = NULL;
 
 	mana_gd_remove_irqs(pdev);
 
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 508f83c29f325..8b027bf6ede90 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -315,9 +315,6 @@ static void mana_hwc_comp_event(void *ctx, struct gdma_queue *q_self)
 
 static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
 {
-	if (!hwc_cq)
-		return;
-
 	kfree(hwc_cq->comp_buf);
 
 	if (hwc_cq->gdma_cq)
@@ -452,9 +449,6 @@ static void mana_hwc_dealloc_dma_buf(struct hw_channel_context *hwc,
 static void mana_hwc_destroy_wq(struct hw_channel_context *hwc,
 				struct hwc_wq *hwc_wq)
 {
-	if (!hwc_wq)
-		return;
-
 	mana_hwc_dealloc_dma_buf(hwc, hwc_wq->msg_buf);
 
 	if (hwc_wq->gdma_wq)
@@ -627,6 +621,7 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
 	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
 
+	/* Both were set in mana_hwc_init_event_handler(). */
 	if (WARN_ON(cq->id >= gc->max_num_cqs))
 		return -EPROTO;
 
@@ -642,9 +637,6 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 				u32 max_req_msg_size, u32 max_resp_msg_size)
 {
-	struct hwc_wq *hwc_rxq = NULL;
-	struct hwc_wq *hwc_txq = NULL;
-	struct hwc_cq *hwc_cq = NULL;
 	int err;
 
 	err = mana_hwc_init_inflight_msg(hwc, q_depth);
@@ -657,44 +649,32 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 	err = mana_hwc_create_cq(hwc, q_depth * 2,
 				 mana_hwc_init_event_handler, hwc,
 				 mana_hwc_rx_event_handler, hwc,
-				 mana_hwc_tx_event_handler, hwc, &hwc_cq);
+				 mana_hwc_tx_event_handler, hwc, &hwc->cq);
 	if (err) {
 		dev_err(hwc->dev, "Failed to create HWC CQ: %d\n", err);
 		goto out;
 	}
-	hwc->cq = hwc_cq;
 
 	err = mana_hwc_create_wq(hwc, GDMA_RQ, q_depth, max_req_msg_size,
-				 hwc_cq, &hwc_rxq);
+				 hwc->cq, &hwc->rxq);
 	if (err) {
 		dev_err(hwc->dev, "Failed to create HWC RQ: %d\n", err);
 		goto out;
 	}
-	hwc->rxq = hwc_rxq;
 
 	err = mana_hwc_create_wq(hwc, GDMA_SQ, q_depth, max_resp_msg_size,
-				 hwc_cq, &hwc_txq);
+				 hwc->cq, &hwc->txq);
 	if (err) {
 		dev_err(hwc->dev, "Failed to create HWC SQ: %d\n", err);
 		goto out;
 	}
-	hwc->txq = hwc_txq;
 
 	hwc->num_inflight_msg = q_depth;
 	hwc->max_req_msg_size = max_req_msg_size;
 
 	return 0;
 out:
-	if (hwc_txq)
-		mana_hwc_destroy_wq(hwc, hwc_txq);
-
-	if (hwc_rxq)
-		mana_hwc_destroy_wq(hwc, hwc_rxq);
-
-	if (hwc_cq)
-		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc_cq);
-
-	mana_gd_free_res_map(&hwc->inflight_msg_res);
+	/* mana_hwc_create_channel() will do the cleanup.*/
 	return err;
 }
 
@@ -722,6 +702,9 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 	gd->pdid = INVALID_PDID;
 	gd->doorbell = INVALID_DOORBELL;
 
+	/* mana_hwc_init_queues() only creates the required data structures,
+	 * and doesn't touch the HWC device.
+	 */
 	err = mana_hwc_init_queues(hwc, HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
 				   HW_CHANNEL_MAX_REQUEST_SIZE,
 				   HW_CHANNEL_MAX_RESPONSE_SIZE);
@@ -747,42 +730,50 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 
 	return 0;
 out:
-	kfree(hwc);
+	mana_hwc_destroy_channel(gc);
 	return err;
 }
 
 void mana_hwc_destroy_channel(struct gdma_context *gc)
 {
 	struct hw_channel_context *hwc = gc->hwc.driver_data;
-	struct hwc_caller_ctx *ctx;
 
-	mana_smc_teardown_hwc(&gc->shm_channel, false);
+	if (!hwc)
+		return;
+
+	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
+	 * non-zero, the HWC worked and we should tear down the HWC here.
+	 */
+	if (gc->max_num_cqs > 0) {
+		mana_smc_teardown_hwc(&gc->shm_channel, false);
+		gc->max_num_cqs = 0;
+	}
 
-	ctx = hwc->caller_ctx;
-	kfree(ctx);
+	kfree(hwc->caller_ctx);
 	hwc->caller_ctx = NULL;
 
-	mana_hwc_destroy_wq(hwc, hwc->txq);
-	hwc->txq = NULL;
+	if (hwc->txq)
+		mana_hwc_destroy_wq(hwc, hwc->txq);
 
-	mana_hwc_destroy_wq(hwc, hwc->rxq);
-	hwc->rxq = NULL;
+	if (hwc->rxq)
+		mana_hwc_destroy_wq(hwc, hwc->rxq);
 
-	mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
-	hwc->cq = NULL;
+	if (hwc->cq)
+		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
 
 	mana_gd_free_res_map(&hwc->inflight_msg_res);
 
 	hwc->num_inflight_msg = 0;
 
-	if (hwc->gdma_dev->pdid != INVALID_PDID) {
-		hwc->gdma_dev->doorbell = INVALID_DOORBELL;
-		hwc->gdma_dev->pdid = INVALID_PDID;
-	}
+	hwc->gdma_dev->doorbell = INVALID_DOORBELL;
+	hwc->gdma_dev->pdid = INVALID_PDID;
 
 	kfree(hwc);
 	gc->hwc.driver_data = NULL;
 	gc->hwc.gdma_context = NULL;
+
+	vfree(gc->cq_table);
+	gc->cq_table = NULL;
 }
 
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
-- 
2.51.0



