Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0693A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nymY8wgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE878C433C7;
	Wed, 15 Nov 2023 19:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077845;
	bh=sQW0qYt17Nd0xykMT+7IvV34pJV4zYDGtkBQglWx8do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nymY8wgINdGd3LgilLUEuWpjMowFjy8JE/uGaALQ4tO4YoB6/OVliEIX2Me+eGYVO
	 Wbh8EkWEVWwZWLsLSfyALCbzVjERHYImQKOsw4NHU96bNZUPBDncOMM+9TQv6/QaK1
	 3Ju2V/RBrdExB7xt8NC3rr0mEryThMJlIdl9D5AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 556/603] octeontx2-pf: Free pending and dropped SQEs
Date: Wed, 15 Nov 2023 14:18:21 -0500
Message-ID: <20231115191650.154770864@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 3423ca23e08bf285a324237abe88e7e7d9becfe6 ]

On interface down, the pending SQEs in the NIX get dropped
or drained out during SMQ flush. But skb's pointed by these
SQEs never get free or updated to the stack as respective CQE
never get added.
This patch fixes the issue by freeing all valid skb's in SQ SG list.

Fixes: b1bc8457e9d0 ("octeontx2-pf: Cleanup all receive buffers in SG descriptor")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/nic/otx2_common.c       | 15 +++----
 .../marvell/octeontx2/nic/otx2_common.h       |  1 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  1 +
 .../marvell/octeontx2/nic/otx2_txrx.c         | 42 +++++++++++++++++++
 4 files changed, 49 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 818ce76185b2f..629cf1659e5f9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -818,7 +818,6 @@ void otx2_sqb_flush(struct otx2_nic *pfvf)
 	int qidx, sqe_tail, sqe_head;
 	struct otx2_snd_queue *sq;
 	u64 incr, *ptr, val;
-	int timeout = 1000;
 
 	ptr = (u64 *)otx2_get_regaddr(pfvf, NIX_LF_SQ_OP_STATUS);
 	for (qidx = 0; qidx < otx2_get_total_tx_queues(pfvf); qidx++) {
@@ -827,15 +826,11 @@ void otx2_sqb_flush(struct otx2_nic *pfvf)
 			continue;
 
 		incr = (u64)qidx << 32;
-		while (timeout) {
-			val = otx2_atomic64_add(incr, ptr);
-			sqe_head = (val >> 20) & 0x3F;
-			sqe_tail = (val >> 28) & 0x3F;
-			if (sqe_head == sqe_tail)
-				break;
-			usleep_range(1, 3);
-			timeout--;
-		}
+		val = otx2_atomic64_add(incr, ptr);
+		sqe_head = (val >> 20) & 0x3F;
+		sqe_tail = (val >> 28) & 0x3F;
+		if (sqe_head != sqe_tail)
+			usleep_range(50, 60);
 	}
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index c04a8ee53a82f..e7c69b57147e0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -977,6 +977,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl, int prio, bool pfc_en);
 int otx2_txsch_alloc(struct otx2_nic *pfvf);
 void otx2_txschq_stop(struct otx2_nic *pfvf);
 void otx2_txschq_free_one(struct otx2_nic *pfvf, u16 lvl, u16 schq);
+void otx2_free_pending_sqe(struct otx2_nic *pfvf);
 void otx2_sqb_flush(struct otx2_nic *pfvf);
 int otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 		    dma_addr_t *dma);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 125fe231702a4..91b99fd703616 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1601,6 +1601,7 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 		else
 			otx2_cleanup_tx_cqes(pf, cq);
 	}
+	otx2_free_pending_sqe(pf);
 
 	otx2_free_sq_res(pf);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 53b2a4ef52985..6ee15f3c25ede 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -1247,9 +1247,11 @@ void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq, int q
 
 void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 {
+	int tx_pkts = 0, tx_bytes = 0;
 	struct sk_buff *skb = NULL;
 	struct otx2_snd_queue *sq;
 	struct nix_cqe_tx_s *cqe;
+	struct netdev_queue *txq;
 	int processed_cqe = 0;
 	struct sg_list *sg;
 	int qidx;
@@ -1270,12 +1272,20 @@ void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 		sg = &sq->sg[cqe->comp.sqe_id];
 		skb = (struct sk_buff *)sg->skb;
 		if (skb) {
+			tx_bytes += skb->len;
+			tx_pkts++;
 			otx2_dma_unmap_skb_frags(pfvf, sg);
 			dev_kfree_skb_any(skb);
 			sg->skb = (u64)NULL;
 		}
 	}
 
+	if (likely(tx_pkts)) {
+		if (qidx >= pfvf->hw.tx_queues)
+			qidx -= pfvf->hw.xdp_queues;
+		txq = netdev_get_tx_queue(pfvf->netdev, qidx);
+		netdev_tx_completed_queue(txq, tx_pkts, tx_bytes);
+	}
 	/* Free CQEs to HW */
 	otx2_write64(pfvf, NIX_LF_CQ_OP_DOOR,
 		     ((u64)cq->cq_idx << 32) | processed_cqe);
@@ -1302,6 +1312,38 @@ int otx2_rxtx_enable(struct otx2_nic *pfvf, bool enable)
 	return err;
 }
 
+void otx2_free_pending_sqe(struct otx2_nic *pfvf)
+{
+	int tx_pkts = 0, tx_bytes = 0;
+	struct sk_buff *skb = NULL;
+	struct otx2_snd_queue *sq;
+	struct netdev_queue *txq;
+	struct sg_list *sg;
+	int sq_idx, sqe;
+
+	for (sq_idx = 0; sq_idx < pfvf->hw.tx_queues; sq_idx++) {
+		sq = &pfvf->qset.sq[sq_idx];
+		for (sqe = 0; sqe < sq->sqe_cnt; sqe++) {
+			sg = &sq->sg[sqe];
+			skb = (struct sk_buff *)sg->skb;
+			if (skb) {
+				tx_bytes += skb->len;
+				tx_pkts++;
+				otx2_dma_unmap_skb_frags(pfvf, sg);
+				dev_kfree_skb_any(skb);
+				sg->skb = (u64)NULL;
+			}
+		}
+
+		if (!tx_pkts)
+			continue;
+		txq = netdev_get_tx_queue(pfvf->netdev, sq_idx);
+		netdev_tx_completed_queue(txq, tx_pkts, tx_bytes);
+		tx_pkts = 0;
+		tx_bytes = 0;
+	}
+}
+
 static void otx2_xdp_sqe_add_sg(struct otx2_snd_queue *sq, u64 dma_addr,
 				int len, int *offset)
 {
-- 
2.42.0



