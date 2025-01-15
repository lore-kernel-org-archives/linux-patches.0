Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6F3248BA6;
	Wed, 15 Jan 2025 10:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938027; cv=none; b=lQIT9rO9UkLsMHjW0ivrzg2pMyIDsN+7fkz3S7dInSC4FSka/sfuNdj9dZH+NsRtOQBrjeNb+4ll28MHPkZl4/5/77S7BxRhmkYGpLDAfuSl2+nB3znYlpFJ9RASTzSGYwsJ9tlbdjqACx/+AC3FEId8voYlICeQy4i/NOs08L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938027; c=relaxed/simple;
	bh=sDjluqYMFiIoPQ1+lg1trNWshZH7vl+8VlsD6xyAebc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIdGQzIxH94O2UJ66zDGuCYHaChTepolvB4UNLDWDFU9vQHAAPeMOGT0i6VnNRRHLA60JumpkVDvrhSLKGOAomZeYxalX7NN/tydTHTVK1Ojq4RIUO2TTk39MKDF1eyW4B9mxZaHrmHWaQdVy11IQtQsgTOc+wDAurbnlqld5Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJHVMla9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJHVMla9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A175AC4CEDF;
	Wed, 15 Jan 2025 10:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938027;
	bh=sDjluqYMFiIoPQ1+lg1trNWshZH7vl+8VlsD6xyAebc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJHVMla9bpUId37dQpWsI8KJUw3eGI4txS9P/tSwGihONkME5xDhM8o5e5atuZBSO
	 6+4tFaH4YeAI7DQkzZjXRArmEdCrujuBJqU14GfHOG4/rnh00lYLrwlM4f8EFYXmFa
	 SQbyGQ/FdsH4XmJqo2W9g9OIxkvvNT136S6uZTq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongguang Gao <hongguang.gao@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/189] bnxt_en: Fix DIM shutdown
Date: Wed, 15 Jan 2025 11:35:28 +0100
Message-ID: <20250115103607.640760086@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 40452969a50652e3cbf89dac83d54eebf2206d27 ]

DIM work will call the firmware to adjust the coalescing parameters on
the RX rings.  We should cancel DIM work before we call the firmware
to free the RX rings.  Otherwise, FW will reject the call from DIM
work if the RX ring has been freed.  This will generate an error
message like this:

bnxt_en 0000:21:00.1 ens2f1np1: hwrm req_type 0x53 seq id 0x6fca error 0x2

and cause unnecessary concern for the user.  It is also possible to
modify the coalescing parameters of the wrong ring if the ring has
been re-allocated.

To prevent this, cancel DIM work right before freeing the RX rings.
We also have to add a check in NAPI poll to not schedule DIM if the
RX rings are shutting down.  Check that the VNIC is active before we
schedule DIM.  The VNIC is always disabled before we free the RX rings.

Fixes: 0bc0b97fca73 ("bnxt_en: cleanup DIM work on device shutdown")
Reviewed-by: Hongguang Gao <hongguang.gao@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250104043849.3482067-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 38 ++++++++++++++++++++---
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index dafc5a4039cd..c255445e97f3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2826,6 +2826,13 @@ static int bnxt_hwrm_handler(struct bnxt *bp, struct tx_cmp *txcmp)
 	return 0;
 }
 
+static bool bnxt_vnic_is_active(struct bnxt *bp)
+{
+	struct bnxt_vnic_info *vnic = &bp->vnic_info[0];
+
+	return vnic->fw_vnic_id != INVALID_HW_RING_ID && vnic->mru > 0;
+}
+
 static irqreturn_t bnxt_msix(int irq, void *dev_instance)
 {
 	struct bnxt_napi *bnapi = dev_instance;
@@ -3093,7 +3100,7 @@ static int bnxt_poll(struct napi_struct *napi, int budget)
 			break;
 		}
 	}
-	if (bp->flags & BNXT_FLAG_DIM) {
+	if ((bp->flags & BNXT_FLAG_DIM) && bnxt_vnic_is_active(bp)) {
 		struct dim_sample dim_sample = {};
 
 		dim_update_sample(cpr->event_ctr,
@@ -3224,7 +3231,7 @@ static int bnxt_poll_p5(struct napi_struct *napi, int budget)
 poll_done:
 	cpr_rx = &cpr->cp_ring_arr[0];
 	if (cpr_rx->cp_ring_type == BNXT_NQ_HDL_TYPE_RX &&
-	    (bp->flags & BNXT_FLAG_DIM)) {
+	    (bp->flags & BNXT_FLAG_DIM) && bnxt_vnic_is_active(bp)) {
 		struct dim_sample dim_sample = {};
 
 		dim_update_sample(cpr->event_ctr,
@@ -7116,6 +7123,26 @@ static int bnxt_hwrm_ring_alloc(struct bnxt *bp)
 	return rc;
 }
 
+static void bnxt_cancel_dim(struct bnxt *bp)
+{
+	int i;
+
+	/* DIM work is initialized in bnxt_enable_napi().  Proceed only
+	 * if NAPI is enabled.
+	 */
+	if (!bp->bnapi || test_bit(BNXT_STATE_NAPI_DISABLED, &bp->state))
+		return;
+
+	/* Make sure NAPI sees that the VNIC is disabled */
+	synchronize_net();
+	for (i = 0; i < bp->rx_nr_rings; i++) {
+		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
+		struct bnxt_napi *bnapi = rxr->bnapi;
+
+		cancel_work_sync(&bnapi->cp_ring.dim.work);
+	}
+}
+
 static int hwrm_ring_free_send_msg(struct bnxt *bp,
 				   struct bnxt_ring_struct *ring,
 				   u32 ring_type, int cmpl_ring_id)
@@ -7216,6 +7243,7 @@ static void bnxt_hwrm_ring_free(struct bnxt *bp, bool close_path)
 		}
 	}
 
+	bnxt_cancel_dim(bp);
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		bnxt_hwrm_rx_ring_free(bp, &bp->rx_ring[i], close_path);
 		bnxt_hwrm_rx_agg_ring_free(bp, &bp->rx_ring[i], close_path);
@@ -11012,8 +11040,6 @@ static void bnxt_disable_napi(struct bnxt *bp)
 		if (bnapi->in_reset)
 			cpr->sw_stats->rx.rx_resets++;
 		napi_disable(&bnapi->napi);
-		if (bnapi->rx_ring)
-			cancel_work_sync(&cpr->dim.work);
 	}
 }
 
@@ -15269,8 +15295,10 @@ static int bnxt_queue_stop(struct net_device *dev, void *qmem, int idx)
 		bnxt_hwrm_vnic_update(bp, vnic,
 				      VNIC_UPDATE_REQ_ENABLES_MRU_VALID);
 	}
-
+	/* Make sure NAPI sees that the VNIC is disabled */
+	synchronize_net();
 	rxr = &bp->rx_ring[idx];
+	cancel_work_sync(&rxr->bnapi->cp_ring.dim.work);
 	bnxt_hwrm_rx_ring_free(bp, rxr, false);
 	bnxt_hwrm_rx_agg_ring_free(bp, rxr, false);
 	rxr->rx_next_cons = 0;
-- 
2.39.5



