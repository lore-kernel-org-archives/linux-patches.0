Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88691158219;
	Tue,  9 Jul 2024 11:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524064; cv=none; b=pBkkZV6eM1T8wRpSlbMIxjWVx1woZ0idbPB92e2gq4p4D2KAbA+RxbQ+cUAVHtOQ0AboyZS91y6wtKnhqyW9Hz4yV1hBDABadZI8XME9j2+xzguGPMkM2+Cx5YnltURE/X7Jos4Qcpd/qDYLnPgco5+n4qcAG5WIiIUqUN7vX6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524064; c=relaxed/simple;
	bh=ndVKQ0IC9mMDQNg1cdvMu2A0DQqSWTCF0gxFZrE1maA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lw4VlWC7ANELAvMePxiSOrnzonKkEwmNKswy9uRqY3/fEFeHCebHh6uU95oyAP4BOpvVy6r1uNgRLObdZgBEtekIlEL4QzoIgjvwBqY6UXRK246uhlWTeci7FnWXeFhJVIleRCIRxV7JZ4/sj06fUsW+Z0cZEPVa7XAdmJFFbgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8GSq9Ms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8GSq9Ms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5AEC32786;
	Tue,  9 Jul 2024 11:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524064;
	bh=ndVKQ0IC9mMDQNg1cdvMu2A0DQqSWTCF0gxFZrE1maA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8GSq9MsLeOCGDdsoLIXHwqvVOL6F2mawoJwNPqMPAHnb9e/+NPStSWiP+o6m3ZUa
	 ak+yLirU07DoXJ2MA7OAsQ/9umO7exFZhGZQaZveCjikmgRZfrBH7dZEKHBOnV300v
	 Ve5g5bzSjhzDAPMj5BG8XPWrTHTAgS+ypt8+R5Ew=
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
Subject: [PATCH 6.9 058/197] gve: Account for stopped queues when reading NIC stats
Date: Tue,  9 Jul 2024 13:08:32 +0200
Message-ID: <20240709110711.208783656@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ethernet/google/gve/gve_ethtool.c | 41 ++++++++++++++++---
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 9aebfb843d9d1..ae90c09c56a89 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -8,6 +8,7 @@
 #include "gve.h"
 #include "gve_adminq.h"
 #include "gve_dqo.h"
+#include "gve_utils.h"
 
 static void gve_get_drvinfo(struct net_device *netdev,
 			    struct ethtool_drvinfo *info)
@@ -165,6 +166,8 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	struct stats *report_stats;
 	int *rx_qid_to_stats_idx;
 	int *tx_qid_to_stats_idx;
+	int num_stopped_rxqs = 0;
+	int num_stopped_txqs = 0;
 	struct gve_priv *priv;
 	bool skip_nic_stats;
 	unsigned int start;
@@ -181,12 +184,23 @@ gve_get_ethtool_stats(struct net_device *netdev,
 					    sizeof(int), GFP_KERNEL);
 	if (!rx_qid_to_stats_idx)
 		return;
+	for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
+		rx_qid_to_stats_idx[ring] = -1;
+		if (!gve_rx_was_added_to_block(priv, ring))
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
+		if (!gve_tx_was_added_to_block(priv, ring))
+			num_stopped_txqs++;
+	}
+
 	for (rx_pkts = 0, rx_bytes = 0, rx_hsplit_pkt = 0,
 	     rx_skb_alloc_fail = 0, rx_buf_alloc_fail = 0,
 	     rx_desc_err_dropped_pkt = 0, rx_hsplit_unsplit_pkt = 0,
@@ -260,7 +274,13 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	/* For rx cross-reporting stats, start from nic rx stats in report */
 	base_stats_idx = GVE_TX_STATS_REPORT_NUM * num_tx_queues +
 		GVE_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues;
-	max_stats_idx = NIC_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues +
+	/* The boundary between driver stats and NIC stats shifts if there are
+	 * stopped queues.
+	 */
+	base_stats_idx += NIC_RX_STATS_REPORT_NUM * num_stopped_rxqs +
+		NIC_TX_STATS_REPORT_NUM * num_stopped_txqs;
+	max_stats_idx = NIC_RX_STATS_REPORT_NUM *
+		(priv->rx_cfg.num_queues - num_stopped_rxqs) +
 		base_stats_idx;
 	/* Preprocess the stats report for rx, map queue id to start index */
 	skip_nic_stats = false;
@@ -274,6 +294,10 @@ gve_get_ethtool_stats(struct net_device *netdev,
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
@@ -308,11 +332,11 @@ gve_get_ethtool_stats(struct net_device *netdev,
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
@@ -338,7 +362,8 @@ gve_get_ethtool_stats(struct net_device *netdev,
 
 	/* For tx cross-reporting stats, start from nic tx stats in report */
 	base_stats_idx = max_stats_idx;
-	max_stats_idx = NIC_TX_STATS_REPORT_NUM * num_tx_queues +
+	max_stats_idx = NIC_TX_STATS_REPORT_NUM *
+		(num_tx_queues - num_stopped_txqs) +
 		max_stats_idx;
 	/* Preprocess the stats report for tx, map queue id to start index */
 	skip_nic_stats = false;
@@ -352,6 +377,10 @@ gve_get_ethtool_stats(struct net_device *netdev,
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
@@ -383,11 +412,11 @@ gve_get_ethtool_stats(struct net_device *netdev,
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
2.43.0



