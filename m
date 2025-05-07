Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ADB29A0;
	Wed,  7 May 2025 19:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644562; cv=none; b=WUwmfv/aj/eexd0JGI4sSOT+JA9t9AqmS729iO80ImjesboWjcVwhopQP7TQ5XZKOJOysKVjzfC95VBse5J9kMD+6i5zLOoANMtdLOv/5hYbdwVQ7lo5kLCHfzI+rHHRR8B1aSE1lH3VBL7OVzxADL/2XuA9D0RaP4XV4gF8rlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644562; c=relaxed/simple;
	bh=ni0+uLCBN4rHDbPG/YHi61ehwfgmviaglKzsaG3ka3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ansy8vBBX2hpPYnjeydlBOBPXTTnnpoxuVTt34JnjktaD3AIiuIu+M8FiaZjymQW/x45AJMzU0HLRB0hWV5A7I51NlFrCzep4ZdiB6kyiPgAwl4rYnmmVyaXFu3zjWQbt80wl7+OJbeARcGRACf06voJpt1mJtrr3ZvdK7EMtns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKmv63lX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKmv63lX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4BCC4CEE2;
	Wed,  7 May 2025 19:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644562;
	bh=ni0+uLCBN4rHDbPG/YHi61ehwfgmviaglKzsaG3ka3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKmv63lXguZvh00jcpUfVkzPuw4PJOCD1sWNf8MUE5WxTYvIwBUj3Oeg5slJF9kyM
	 yxSM5CBPbyrJh/iut6jX0N1feiH4XB8e5tiVRZSb5ULvx4NPG9T6FFRVE3keZWwHwl
	 h5wF/yumBb5mPL5EdWBOSpsGlt7VhJFypwIePYY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Vadim Fedorenko <vadfed@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/164] bnxt_en: improve TX timestamping FIFO configuration
Date: Wed,  7 May 2025 20:39:28 +0200
Message-ID: <20250507183824.323841038@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Vadim Fedorenko <vadfed@meta.com>

[ Upstream commit 8f7ae5a85137b913cb97e2d24409d36548d0bab1 ]

Reconfiguration of netdev may trigger close/open procedure which can
break FIFO status by adjusting the amount of empty slots for TX
timestamps. But it is not really needed because timestamps for the
packets sent over the wire still can be retrieved. On the other side,
during netdev close procedure any skbs waiting for TX timestamps can be
leaked because there is no cleaning procedure called. Free skbs waiting
for TX timestamps when closing netdev.

Fixes: 8aa2a79e9b95 ("bnxt_en: Increase the max total outstanding PTP TX packets to 4")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
Link: https://patch.msgid.link/20250424125547.460632-1-vadfed@meta.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  5 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 29 ++++++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  1 +
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 016dcfec8d496..874a15f33bc5b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3320,6 +3320,9 @@ static void bnxt_free_tx_skbs(struct bnxt *bp)
 		}
 		netdev_tx_reset_queue(netdev_get_tx_queue(bp->dev, i));
 	}
+
+	if (bp->ptp_cfg && !(bp->fw_cap & BNXT_FW_CAP_TX_TS_CMP))
+		bnxt_ptp_free_txts_skbs(bp->ptp_cfg);
 }
 
 static void bnxt_free_one_rx_ring(struct bnxt *bp, struct bnxt_rx_ring_info *rxr)
@@ -12249,8 +12252,6 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	/* VF-reps may need to be re-opened after the PF is re-opened */
 	if (BNXT_PF(bp))
 		bnxt_vf_reps_open(bp);
-	if (bp->ptp_cfg && !(bp->fw_cap & BNXT_FW_CAP_TX_TS_CMP))
-		WRITE_ONCE(bp->ptp_cfg->tx_avail, BNXT_MAX_TX_TS);
 	bnxt_ptp_init_rtc(bp, true);
 	bnxt_ptp_cfg_tstamp_filters(bp);
 	if (BNXT_SUPPORTS_MULTI_RSS_CTX(bp))
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 781225d3ba8ff..650034a4bb46d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -777,6 +777,27 @@ static long bnxt_ptp_ts_aux_work(struct ptp_clock_info *ptp_info)
 	return HZ;
 }
 
+void bnxt_ptp_free_txts_skbs(struct bnxt_ptp_cfg *ptp)
+{
+	struct bnxt_ptp_tx_req *txts_req;
+	u16 cons = ptp->txts_cons;
+
+	/* make sure ptp aux worker finished with
+	 * possible BNXT_STATE_OPEN set
+	 */
+	ptp_cancel_worker_sync(ptp->ptp_clock);
+
+	ptp->tx_avail = BNXT_MAX_TX_TS;
+	while (cons != ptp->txts_prod) {
+		txts_req = &ptp->txts_req[cons];
+		if (!IS_ERR_OR_NULL(txts_req->tx_skb))
+			dev_kfree_skb_any(txts_req->tx_skb);
+		cons = NEXT_TXTS(cons);
+	}
+	ptp->txts_cons = cons;
+	ptp_schedule_worker(ptp->ptp_clock, 0);
+}
+
 int bnxt_ptp_get_txts_prod(struct bnxt_ptp_cfg *ptp, u16 *prod)
 {
 	spin_lock_bh(&ptp->ptp_tx_lock);
@@ -1095,7 +1116,6 @@ int bnxt_ptp_init(struct bnxt *bp)
 void bnxt_ptp_clear(struct bnxt *bp)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
-	int i;
 
 	if (!ptp)
 		return;
@@ -1107,12 +1127,5 @@ void bnxt_ptp_clear(struct bnxt *bp)
 	kfree(ptp->ptp_info.pin_config);
 	ptp->ptp_info.pin_config = NULL;
 
-	for (i = 0; i < BNXT_MAX_TX_TS; i++) {
-		if (ptp->txts_req[i].tx_skb) {
-			dev_kfree_skb_any(ptp->txts_req[i].tx_skb);
-			ptp->txts_req[i].tx_skb = NULL;
-		}
-	}
-
 	bnxt_unmap_ptp_regs(bp);
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 61e89bb2d2690..999b497990bce 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -174,6 +174,7 @@ int bnxt_ptp_cfg_tstamp_filters(struct bnxt *bp);
 void bnxt_ptp_reapply_pps(struct bnxt *bp);
 int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
 int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
+void bnxt_ptp_free_txts_skbs(struct bnxt_ptp_cfg *ptp);
 int bnxt_ptp_get_txts_prod(struct bnxt_ptp_cfg *ptp, u16 *prod);
 void bnxt_get_tx_ts_p5(struct bnxt *bp, struct sk_buff *skb, u16 prod);
 int bnxt_get_rx_ts_p5(struct bnxt *bp, u64 *ts, u32 pkt_ts);
-- 
2.39.5



