Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D4D392829;
	Sat, 17 Oct 2026 17:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257655; cv=none; b=FFGGgAO8JheAHBIcWpygPxDPnUw8YYIZ0hF3XlYL52FG74gsAcib7qQMJQ9HyNcgbzr69YFUpUU6/b7U3HOPi9BGOdEEDgYoTAv85esoTKLXbdyHlJK2InP18MEzeAMkwiTkRjvfBgqzOPSLBSqd0YGZTurPa7IVozoH/xwJ61I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257655; c=relaxed/simple;
	bh=A30fQ2ej8h71y1tuUDisMBbf4CyeBLKori+60WD70Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXfnj069BmwqpK9mrHTLdLyez6H0hq3PttBW3H5VwTKCPDoxLq0BmEhkeRtTNjHnoIOOlHuCoewC/plB0fecALfVJHMz9v8CIbbEcIpsAMQ+ajGKdVkCmkeTXD0lZ5ztgh3rZKiAEoSrPkXRmT3lxNnP3wh68Lh1gpIhsMIu+fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMmFV8nb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMmFV8nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B551F000C4;
	Sat, 17 Oct 2026 17:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257653;
	bh=F/eVBOarF8SbLF8uQo09LMH3KZHTDXs1sxz8NrAjQFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMmFV8nbk1QpG+6PdnNy+rURQ/tTa0Ic2iHxmfd3F7OhCJVCidaXVK+okVln7hGoF
	 CYAjUnqj9w0z7d5GSTYZLvOjZ6WvLbgeAgsZzaMYh6G4wHrAamEGTqYVqiyy4gHz0l
	 dDG19cteLUoZnI+DIBM2aqL3HJ9XUZ83WMf3xM/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Shailend Chand <shailend@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0629/1674] gve: Account for stopped queues when reading NIC stats
Date: Sat, 17 Oct 2026 17:48:21 +0200
Message-ID: <20261017160447.239642777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shailend Chand <shailend@google.com>

[ Upstream commit af9bcf910b1f86244f39e15e701b2dc564b469a6 ]

We now account for the fact that the NIC might send us stats for a
subset of queues. Without this change, gve_get_ethtool_stats might make
an invalid access on the priv->stats_report->stats array.

Tested-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Signed-off-by: Shailend Chand <shailend@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c | 38 ++++++++++++++++---
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index b1c4df3bab292..bc20c13ba2870 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -166,6 +166,8 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	struct stats *report_stats;
 	int *rx_qid_to_stats_idx;
 	int *tx_qid_to_stats_idx;
+	int num_stopped_rxqs = 0;
+	int num_stopped_txqs = 0;
 	struct gve_priv *priv;
 	bool skip_nic_stats;
 	unsigned int start;
@@ -182,12 +184,23 @@ gve_get_ethtool_stats(struct net_device *netdev,
 					    sizeof(int), GFP_KERNEL);
 	if (!rx_qid_to_stats_idx)
 		return;
+	for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
+		rx_qid_to_stats_idx[ring] = -1;
+		if (!priv->ntfy_blocks[gve_rx_idx_to_ntfy(priv, ring)].rx)
+			num_stopped_rxqs++;
+	}
 	tx_qid_to_stats_idx = kmalloc_array(num_tx_queues,
 					    sizeof(int), GFP_KERNEL);
 	if (!tx_qid_to_stats_idx) {
 		kfree(rx_qid_to_stats_idx);
 		return;
 	}
+	for (ring = 0; ring < num_tx_queues; ring++) {
+		tx_qid_to_stats_idx[ring] = -1;
+		if (!priv->ntfy_blocks[gve_tx_idx_to_ntfy(priv, ring)].tx)
+			num_stopped_txqs++;
+	}
+
 	for (rx_pkts = 0, rx_bytes = 0, rx_skb_alloc_fail = 0,
 	     rx_buf_alloc_fail = 0, rx_desc_err_dropped_pkt = 0,
 	     xdp_tx_errors = 0, xdp_redirect_errors = 0,
@@ -272,11 +285,16 @@ gve_get_ethtool_stats(struct net_device *netdev,
 		 */
 		rx_base_stats_idx = (stats_region_len - nic_stats_len) /
 							sizeof(struct stats);
+		/* The boundary between driver stats and NIC stats shifts if there are
+		 * stopped queues.
+		 */
+		rx_base_stats_idx += NIC_RX_STATS_REPORT_NUM * num_stopped_rxqs +
+			NIC_TX_STATS_REPORT_NUM * num_stopped_txqs;
 		max_rx_stats_idx = NIC_RX_STATS_REPORT_NUM *
-			priv->rx_cfg.num_queues +
+			(priv->rx_cfg.num_queues - num_stopped_rxqs) +
 			rx_base_stats_idx;
 		max_tx_stats_idx = NIC_TX_STATS_REPORT_NUM *
-			num_tx_queues +
+			(num_tx_queues - num_stopped_txqs) +
 			max_rx_stats_idx;
 	}
 	/* Preprocess the stats report for rx, map queue id to start index */
@@ -291,6 +309,10 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			skip_nic_stats = true;
 			break;
 		}
+		if (queue_id < 0 || queue_id >= priv->rx_cfg.num_queues) {
+			net_err_ratelimited("Invalid rxq id in NIC stats\n");
+			continue;
+		}
 		rx_qid_to_stats_idx[queue_id] = stats_idx;
 	}
 	/* walk RX rings */
@@ -327,11 +349,11 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			data[i++] = rx->rx_copybreak_pkt;
 			data[i++] = rx->rx_copied_pkt;
 			/* stats from NIC */
-			if (skip_nic_stats) {
+			stats_idx = rx_qid_to_stats_idx[ring];
+			if (skip_nic_stats || stats_idx < 0) {
 				/* skip NIC rx stats */
 				i += NIC_RX_STATS_REPORT_NUM;
 			} else {
-				stats_idx = rx_qid_to_stats_idx[ring];
 				for (j = 0; j < NIC_RX_STATS_REPORT_NUM; j++) {
 					u64 value =
 						be64_to_cpu(report_stats[stats_idx + j].value);
@@ -367,6 +389,10 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			skip_nic_stats = true;
 			break;
 		}
+		if (queue_id < 0 || queue_id >= num_tx_queues) {
+			net_err_ratelimited("Invalid txq id in NIC stats\n");
+			continue;
+		}
 		tx_qid_to_stats_idx[queue_id] = stats_idx;
 	}
 	/* walk TX rings */
@@ -400,11 +426,11 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			data[i++] = gve_tx_load_event_counter(priv, tx);
 			data[i++] = tx->dma_mapping_error;
 			/* stats from NIC */
-			if (skip_nic_stats) {
+			stats_idx = tx_qid_to_stats_idx[ring];
+			if (skip_nic_stats || stats_idx < 0) {
 				/* skip NIC tx stats */
 				i += NIC_TX_STATS_REPORT_NUM;
 			} else {
-				stats_idx = tx_qid_to_stats_idx[ring];
 				for (j = 0; j < NIC_TX_STATS_REPORT_NUM; j++) {
 					u64 value =
 						be64_to_cpu(report_stats[stats_idx + j].value);
-- 
2.53.0



