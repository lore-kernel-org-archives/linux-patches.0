Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EF82750ED;
	Thu, 15 Jan 2026 17:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497123; cv=none; b=Do41rTvQ9e3wquHRBxwYV0+25fBw22tL7+XJgDtyZaQGoyITxwjeMXd1WzvJRKd9wQkOq5yifkfpVkTuPwDoBKQkpSYABPTMcK9L0lKsVbKe4QXw6kH+oirgr+K5sue6oGCo1J5oJNdZFlO4uyuFbIzX078HyX/yKs6JmP97tDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497123; c=relaxed/simple;
	bh=LTKLrVVksuK1EnPCmja/+M9eDomokpR00MvnpAOGXV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=em0pnJrlMaDFT8UjbB6z0/eSr5tC2n0CLp7auiJDMc3NAvZacvCKo+7flKOXjPTJtGklz9xMmqcHIW4tUbAG83jr/iHKI6s61thdSJsH7EO3fwvEwiBPiJmluoym9AaUQatO7DIhPKtqTzGD5SYCXPtwOlzD1sBHrm56rw5K5zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDPxJwx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDPxJwx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCE3C19422;
	Thu, 15 Jan 2026 17:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497123;
	bh=LTKLrVVksuK1EnPCmja/+M9eDomokpR00MvnpAOGXV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDPxJwx0gOhdaK/AU61sbAjQ+UayQ4SArRIF9Db8azAHInK4T7U4j9+ps68IkD7Qz
	 HJnu8W1A10yk9OChbn6SXm0bjcXO2HwfERtHMJbCriPqP6B/6E2YlO5NX/u9xloVdJ
	 pHinpeqNDaDapd4Lbr1RhVeuszUyJVrOlgbkCdhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 44/72] eth: bnxt: move and rename reset helpers
Date: Thu, 15 Jan 2026 17:48:54 +0100
Message-ID: <20260115164145.092456455@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit fea2993aecd74d5d11ede1ebbd60e478ebfed996 ]

Move the reset helpers, subsequent patches will need some
of them on the Tx path.

While at it rename bnxt_sched_reset(), on more recent chips
it schedules a queue reset, instead of a fuller reset.

Link: https://lore.kernel.org/r/20230720010440.1967136-2-kuba@kernel.org
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ffeafa65b2b2 ("bnxt_en: Fix potential data corruption with HW GRO/LRO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 72 +++++++++++------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6b1245a3ab4b1..2540402030bf1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -293,6 +293,38 @@ static void bnxt_db_cq(struct bnxt *bp, struct bnxt_db_info *db, u32 idx)
 		BNXT_DB_CQ(db, idx);
 }
 
+static void bnxt_queue_fw_reset_work(struct bnxt *bp, unsigned long delay)
+{
+	if (!(test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)))
+		return;
+
+	if (BNXT_PF(bp))
+		queue_delayed_work(bnxt_pf_wq, &bp->fw_reset_task, delay);
+	else
+		schedule_delayed_work(&bp->fw_reset_task, delay);
+}
+
+static void bnxt_queue_sp_work(struct bnxt *bp)
+{
+	if (BNXT_PF(bp))
+		queue_work(bnxt_pf_wq, &bp->sp_task);
+	else
+		schedule_work(&bp->sp_task);
+}
+
+static void bnxt_sched_reset_rxr(struct bnxt *bp, struct bnxt_rx_ring_info *rxr)
+{
+	if (!rxr->bnapi->in_reset) {
+		rxr->bnapi->in_reset = true;
+		if (bp->flags & BNXT_FLAG_CHIP_P5)
+			set_bit(BNXT_RESET_TASK_SP_EVENT, &bp->sp_event);
+		else
+			set_bit(BNXT_RST_RING_SP_EVENT, &bp->sp_event);
+		bnxt_queue_sp_work(bp);
+	}
+	rxr->rx_next_cons = 0xffff;
+}
+
 const u16 bnxt_lhint_arr[] = {
 	TX_BD_FLAGS_LHINT_512_AND_SMALLER,
 	TX_BD_FLAGS_LHINT_512_TO_1023,
@@ -1269,38 +1301,6 @@ static int bnxt_discard_rx(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	return 0;
 }
 
-static void bnxt_queue_fw_reset_work(struct bnxt *bp, unsigned long delay)
-{
-	if (!(test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)))
-		return;
-
-	if (BNXT_PF(bp))
-		queue_delayed_work(bnxt_pf_wq, &bp->fw_reset_task, delay);
-	else
-		schedule_delayed_work(&bp->fw_reset_task, delay);
-}
-
-static void bnxt_queue_sp_work(struct bnxt *bp)
-{
-	if (BNXT_PF(bp))
-		queue_work(bnxt_pf_wq, &bp->sp_task);
-	else
-		schedule_work(&bp->sp_task);
-}
-
-static void bnxt_sched_reset(struct bnxt *bp, struct bnxt_rx_ring_info *rxr)
-{
-	if (!rxr->bnapi->in_reset) {
-		rxr->bnapi->in_reset = true;
-		if (bp->flags & BNXT_FLAG_CHIP_P5)
-			set_bit(BNXT_RESET_TASK_SP_EVENT, &bp->sp_event);
-		else
-			set_bit(BNXT_RST_RING_SP_EVENT, &bp->sp_event);
-		bnxt_queue_sp_work(bp);
-	}
-	rxr->rx_next_cons = 0xffff;
-}
-
 static u16 bnxt_alloc_agg_idx(struct bnxt_rx_ring_info *rxr, u16 agg_id)
 {
 	struct bnxt_tpa_idx_map *map = rxr->rx_tpa_idx_map;
@@ -1355,7 +1355,7 @@ static void bnxt_tpa_start(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 		netdev_warn(bp->dev, "TPA cons %x, expected cons %x, error code %x\n",
 			    cons, rxr->rx_next_cons,
 			    TPA_START_ERROR_CODE(tpa_start1));
-		bnxt_sched_reset(bp, rxr);
+		bnxt_sched_reset_rxr(bp, rxr);
 		return;
 	}
 	/* Store cfa_code in tpa_info to use in tpa_end
@@ -1895,7 +1895,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		if (rxr->rx_next_cons != 0xffff)
 			netdev_warn(bp->dev, "RX cons %x != expected cons %x\n",
 				    cons, rxr->rx_next_cons);
-		bnxt_sched_reset(bp, rxr);
+		bnxt_sched_reset_rxr(bp, rxr);
 		if (rc1)
 			return rc1;
 		goto next_rx_no_prod_no_len;
@@ -1933,7 +1933,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 			    !(bp->fw_cap & BNXT_FW_CAP_RING_MONITOR)) {
 				netdev_warn_once(bp->dev, "RX buffer error %x\n",
 						 rx_err);
-				bnxt_sched_reset(bp, rxr);
+				bnxt_sched_reset_rxr(bp, rxr);
 			}
 		}
 		goto next_rx_no_len;
@@ -2371,7 +2371,7 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			goto async_event_process_exit;
 		}
 		rxr = bp->bnapi[grp_idx]->rx_ring;
-		bnxt_sched_reset(bp, rxr);
+		bnxt_sched_reset_rxr(bp, rxr);
 		goto async_event_process_exit;
 	}
 	case ASYNC_EVENT_CMPL_EVENT_ID_ECHO_REQUEST: {
-- 
2.51.0



