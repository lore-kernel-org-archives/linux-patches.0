Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C60A281379;
	Thu, 13 Feb 2025 14:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457296; cv=none; b=o0dh1nEua+wK+NN3pdEd8BWx06tatE4vT029+ZafbgivBTL/ns1ljHJKNB2lV340IEviWXUFebvQUiCZxiKDVgdHgnrnrWJ/x6UOscOS4/LTCo7a7Ha63C0D0SvfPCnnY071RwHsnoFpGsOQ5JYW093M0qSw4rOmWSq3Th8+8aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457296; c=relaxed/simple;
	bh=ly41VLk90zvHSTUsKm+9lou8pOp03OZwB5cQjho1KEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7937DshbQ3mH7ih7nKj7Bx9B8Vrkili3enEXeH2hKIJ1w0Ya3yYyGHLOrYY5lnE430ay803rKR47iXFQ3r29LmRzTytSNciaBbsFNfJ6zIt6jsFI++fuv/n5M3TEl4ggJl0h5j2ZF5IA6JRsDw2buvtwc3GYG0iugeQxikwL6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZVcbUZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZVcbUZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77680C4CEE9;
	Thu, 13 Feb 2025 14:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457296;
	bh=ly41VLk90zvHSTUsKm+9lou8pOp03OZwB5cQjho1KEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZVcbUZucP7YcjKXa+P9YuAFbyRaiO0CpnzvGC1wVar1MU8u+J1vYlJCd09SjOF9c
	 lCf11NB4+kxJe0NdfzeTvE6lPVjRlxEjyQN40OuW4L02omxFZ3SRIR3jr4O6xRfr6+
	 51nnK3Q71qnk1SuRtv+E53bMxSa1mao14lBzIwTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinas Rasheed <srasheed@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/422] octeon_ep_vf: update tx/rx stats locally for persistence
Date: Thu, 13 Feb 2025 15:23:41 +0100
Message-ID: <20250213142439.336907795@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Shinas Rasheed <srasheed@marvell.com>

[ Upstream commit f84039939512e6d88b0f2f353695530f123be789 ]

Update tx/rx stats locally, so that ndo_get_stats64()
can use that and not rely on per queue resources to obtain statistics.
The latter used to cause race conditions when the device stopped.

Signed-off-by: Shinas Rasheed <srasheed@marvell.com>
Link: https://patch.msgid.link/20250117094653.2588578-5-srasheed@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeon_ep_vf/octep_vf_ethtool.c   | 29 +++++++------------
 .../marvell/octeon_ep_vf/octep_vf_main.c      | 17 +++++------
 .../marvell/octeon_ep_vf/octep_vf_main.h      |  6 ++++
 .../marvell/octeon_ep_vf/octep_vf_rx.c        |  9 +++---
 .../marvell/octeon_ep_vf/octep_vf_rx.h        |  2 +-
 .../marvell/octeon_ep_vf/octep_vf_tx.c        |  7 +++--
 .../marvell/octeon_ep_vf/octep_vf_tx.h        |  2 +-
 7 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_ethtool.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_ethtool.c
index a1979b45e355c..12ddb77141cc3 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_ethtool.c
@@ -121,12 +121,9 @@ static void octep_vf_get_ethtool_stats(struct net_device *netdev,
 	iface_tx_stats = &oct->iface_tx_stats;
 	iface_rx_stats = &oct->iface_rx_stats;
 
-	for (q = 0; q < oct->num_oqs; q++) {
-		struct octep_vf_iq *iq = oct->iq[q];
-		struct octep_vf_oq *oq = oct->oq[q];
-
-		tx_busy_errors += iq->stats.tx_busy;
-		rx_alloc_errors += oq->stats.alloc_failures;
+	for (q = 0; q < OCTEP_VF_MAX_QUEUES; q++) {
+		tx_busy_errors += oct->stats_iq[q].tx_busy;
+		rx_alloc_errors += oct->stats_oq[q].alloc_failures;
 	}
 	i = 0;
 	data[i++] = rx_alloc_errors;
@@ -141,22 +138,18 @@ static void octep_vf_get_ethtool_stats(struct net_device *netdev,
 	data[i++] = iface_rx_stats->dropped_octets_fifo_full;
 
 	/* Per Tx Queue stats */
-	for (q = 0; q < oct->num_iqs; q++) {
-		struct octep_vf_iq *iq = oct->iq[q];
-
-		data[i++] = iq->stats.instr_posted;
-		data[i++] = iq->stats.instr_completed;
-		data[i++] = iq->stats.bytes_sent;
-		data[i++] = iq->stats.tx_busy;
+	for (q = 0; q < OCTEP_VF_MAX_QUEUES; q++) {
+		data[i++] = oct->stats_iq[q].instr_posted;
+		data[i++] = oct->stats_iq[q].instr_completed;
+		data[i++] = oct->stats_iq[q].bytes_sent;
+		data[i++] = oct->stats_iq[q].tx_busy;
 	}
 
 	/* Per Rx Queue stats */
 	for (q = 0; q < oct->num_oqs; q++) {
-		struct octep_vf_oq *oq = oct->oq[q];
-
-		data[i++] = oq->stats.packets;
-		data[i++] = oq->stats.bytes;
-		data[i++] = oq->stats.alloc_failures;
+		data[i++] = oct->stats_oq[q].packets;
+		data[i++] = oct->stats_oq[q].bytes;
+		data[i++] = oct->stats_oq[q].alloc_failures;
 	}
 }
 
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
index 4c699514fd57a..18c922dd5fc64 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
@@ -574,7 +574,7 @@ static int octep_vf_iq_full_check(struct octep_vf_iq *iq)
 		  * caused queues to get re-enabled after
 		  * being stopped
 		  */
-		iq->stats.restart_cnt++;
+		iq->stats->restart_cnt++;
 		fallthrough;
 	case 1: /* Queue left enabled, since IQ is not yet full*/
 		return 0;
@@ -731,7 +731,7 @@ static netdev_tx_t octep_vf_start_xmit(struct sk_buff *skb,
 	/* Flush the hw descriptors before writing to doorbell */
 	smp_wmb();
 	writel(iq->fill_cnt, iq->doorbell_reg);
-	iq->stats.instr_posted += iq->fill_cnt;
+	iq->stats->instr_posted += iq->fill_cnt;
 	iq->fill_cnt = 0;
 	return NETDEV_TX_OK;
 }
@@ -786,14 +786,11 @@ static void octep_vf_get_stats64(struct net_device *netdev,
 	tx_bytes = 0;
 	rx_packets = 0;
 	rx_bytes = 0;
-	for (q = 0; q < oct->num_oqs; q++) {
-		struct octep_vf_iq *iq = oct->iq[q];
-		struct octep_vf_oq *oq = oct->oq[q];
-
-		tx_packets += iq->stats.instr_completed;
-		tx_bytes += iq->stats.bytes_sent;
-		rx_packets += oq->stats.packets;
-		rx_bytes += oq->stats.bytes;
+	for (q = 0; q < OCTEP_VF_MAX_QUEUES; q++) {
+		tx_packets += oct->stats_iq[q].instr_completed;
+		tx_bytes += oct->stats_iq[q].bytes_sent;
+		rx_packets += oct->stats_oq[q].packets;
+		rx_bytes += oct->stats_oq[q].bytes;
 	}
 	stats->tx_packets = tx_packets;
 	stats->tx_bytes = tx_bytes;
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h
index 5769f62545cd4..1a352f41f823c 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h
@@ -246,11 +246,17 @@ struct octep_vf_device {
 	/* Pointers to Octeon Tx queues */
 	struct octep_vf_iq *iq[OCTEP_VF_MAX_IQ];
 
+	/* Per iq stats */
+	struct octep_vf_iq_stats stats_iq[OCTEP_VF_MAX_IQ];
+
 	/* Rx queues (OQ: Output Queue) */
 	u16 num_oqs;
 	/* Pointers to Octeon Rx queues */
 	struct octep_vf_oq *oq[OCTEP_VF_MAX_OQ];
 
+	/* Per oq stats */
+	struct octep_vf_oq_stats stats_oq[OCTEP_VF_MAX_OQ];
+
 	/* Hardware port number of the PCIe interface */
 	u16 pcie_port;
 
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c
index 82821bc28634b..d70c8be3cfc40 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c
@@ -87,7 +87,7 @@ static int octep_vf_oq_refill(struct octep_vf_device *oct, struct octep_vf_oq *o
 		page = dev_alloc_page();
 		if (unlikely(!page)) {
 			dev_err(oq->dev, "refill: rx buffer alloc failed\n");
-			oq->stats.alloc_failures++;
+			oq->stats->alloc_failures++;
 			break;
 		}
 
@@ -98,7 +98,7 @@ static int octep_vf_oq_refill(struct octep_vf_device *oct, struct octep_vf_oq *o
 				"OQ-%d buffer refill: DMA mapping error!\n",
 				oq->q_no);
 			put_page(page);
-			oq->stats.alloc_failures++;
+			oq->stats->alloc_failures++;
 			break;
 		}
 		oq->buff_info[refill_idx].page = page;
@@ -134,6 +134,7 @@ static int octep_vf_setup_oq(struct octep_vf_device *oct, int q_no)
 	oq->netdev = oct->netdev;
 	oq->dev = &oct->pdev->dev;
 	oq->q_no = q_no;
+	oq->stats = &oct->stats_oq[q_no];
 	oq->max_count = CFG_GET_OQ_NUM_DESC(oct->conf);
 	oq->ring_size_mask = oq->max_count - 1;
 	oq->buffer_size = CFG_GET_OQ_BUF_SIZE(oct->conf);
@@ -458,8 +459,8 @@ static int __octep_vf_oq_process_rx(struct octep_vf_device *oct,
 
 	oq->host_read_idx = read_idx;
 	oq->refill_count += desc_used;
-	oq->stats.packets += pkt;
-	oq->stats.bytes += rx_bytes;
+	oq->stats->packets += pkt;
+	oq->stats->bytes += rx_bytes;
 
 	return pkt;
 }
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.h b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.h
index fe46838b5200f..9e296b7d7e349 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.h
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.h
@@ -187,7 +187,7 @@ struct octep_vf_oq {
 	u8 __iomem *pkts_sent_reg;
 
 	/* Statistics for this OQ. */
-	struct octep_vf_oq_stats stats;
+	struct octep_vf_oq_stats *stats;
 
 	/* Packets pending to be processed */
 	u32 pkts_pending;
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_tx.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_tx.c
index 47a5c054fdb63..8180e5ce3d7ef 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_tx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_tx.c
@@ -82,9 +82,9 @@ int octep_vf_iq_process_completions(struct octep_vf_iq *iq, u16 budget)
 	}
 
 	iq->pkts_processed += compl_pkts;
-	iq->stats.instr_completed += compl_pkts;
-	iq->stats.bytes_sent += compl_bytes;
-	iq->stats.sgentry_sent += compl_sg;
+	iq->stats->instr_completed += compl_pkts;
+	iq->stats->bytes_sent += compl_bytes;
+	iq->stats->sgentry_sent += compl_sg;
 	iq->flush_index = fi;
 
 	netif_subqueue_completed_wake(iq->netdev, iq->q_no, compl_pkts,
@@ -186,6 +186,7 @@ static int octep_vf_setup_iq(struct octep_vf_device *oct, int q_no)
 	iq->netdev = oct->netdev;
 	iq->dev = &oct->pdev->dev;
 	iq->q_no = q_no;
+	iq->stats = &oct->stats_iq[q_no];
 	iq->max_count = CFG_GET_IQ_NUM_DESC(oct->conf);
 	iq->ring_size_mask = iq->max_count - 1;
 	iq->fill_threshold = CFG_GET_IQ_DB_MIN(oct->conf);
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_tx.h b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_tx.h
index f338b975103c3..1cede90e3a5fa 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_tx.h
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_tx.h
@@ -129,7 +129,7 @@ struct octep_vf_iq {
 	u16 flush_index;
 
 	/* Statistics for this input queue. */
-	struct octep_vf_iq_stats stats;
+	struct octep_vf_iq_stats *stats;
 
 	/* Pointer to the Virtual Base addr of the input ring. */
 	struct octep_vf_tx_desc_hw *desc_ring;
-- 
2.39.5



