Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80D03546C8;
	Wed, 20 May 2026 17:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299234; cv=none; b=qybxXZn8876+gHsOnRwxzcKY2dglUM1w9+V8RdBytRdu1QDKpDL5Ce8UoCAWpeGanywSboylfALXUqVksbLM3yNnRrSRkxVEUm0aKWiGHaLLvVpdWyhuaW5yMSiQaOHyZMZwc8CENpB33rfP2JqoeCcU8XDChaOVwZQhwDbUdp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299234; c=relaxed/simple;
	bh=bgmt3VsW8ojpOPlrI28ZWcH7oRIpFi1wRtDHZBwGE40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moo94mOqiSfdQDMaxws+HKqRrr/RUtF19/a8/dY7UwtguARDqNI1mLFqClQpEsxiECfKldebNd/ah82Ox70FS/0XRxotWmJ5L4+KRGw05pJGWMkAEyAyUIvZU3aYzIaNMwRFiGFIU1FOISEmGzmQwlCeONwq/c5uMPZWUqhuwSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VeOX+88G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VeOX+88G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506E91F000E9;
	Wed, 20 May 2026 17:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299232;
	bh=rIDHduNoMQ9FxZycHhw6K8rQr1hnFcj493/rDYufk7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VeOX+88GmUq2NXPQ0q0DhpuBWb+KouSrmOfw9bh+jPTW+8RPxIdYaqC7PLImz8Rpk
	 0Z5wYH0fFxKn5vzIX9DTXypFqRJHTbE2Z6tUOu7y2zZuocHzCtXS3gXeok9yWy3N/B
	 th057dzVKWOOdGPlcoMAPJbvq/m7pGscsTCX8Ssg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Eric Dumazet <edumazet@google.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 706/957] net: mana: Handle SKB if TX SGEs exceed hardware limit
Date: Wed, 20 May 2026 18:19:49 +0200
Message-ID: <20260520162149.851326079@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya@linux.microsoft.com>

[ Upstream commit 934fa943b53795339486cc0026b3ab7ad39dc600 ]

The MANA hardware supports a maximum of 30 scatter-gather entries (SGEs)
per TX WQE. Exceeding this limit can cause TX failures.
Add ndo_features_check() callback to validate SKB layout before
transmission. For GSO SKBs that would exceed the hardware SGE limit, clear
NETIF_F_GSO_MASK to enforce software segmentation in the stack.
Add a fallback in mana_start_xmit() to linearize non-GSO SKBs that still
exceed the SGE limit.

Also, Add ethtool counter for SKBs linearized

Co-developed-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Signed-off-by: Aditya Garg <gargaditya@linux.microsoft.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://patch.msgid.link/1763464269-10431-2-git-send-email-gargaditya@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 65267c9c4f28 ("net: mana: Fix EQ leak in mana_remove on NULL port")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 40 ++++++++++++++++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    |  2 +
 include/net/mana/gdma.h                       |  8 +++-
 include/net/mana/mana.h                       |  1 +
 4 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 02090edbd103f..b9cab61d0afe2 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -11,6 +11,7 @@
 #include <linux/mm.h>
 #include <linux/pci.h>
 #include <linux/export.h>
+#include <linux/skbuff.h>
 
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
@@ -329,6 +330,21 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	cq = &apc->tx_qp[txq_idx].tx_cq;
 	tx_stats = &txq->stats;
 
+	BUILD_BUG_ON(MAX_TX_WQE_SGL_ENTRIES != MANA_MAX_TX_WQE_SGL_ENTRIES);
+	if (MAX_SKB_FRAGS + 2 > MAX_TX_WQE_SGL_ENTRIES &&
+	    skb_shinfo(skb)->nr_frags + 2 > MAX_TX_WQE_SGL_ENTRIES) {
+		/* GSO skb with Hardware SGE limit exceeded is not expected here
+		 * as they are handled in mana_features_check() callback
+		 */
+		if (skb_linearize(skb)) {
+			netdev_warn_once(ndev, "Failed to linearize skb with nr_frags=%d and is_gso=%d\n",
+					 skb_shinfo(skb)->nr_frags,
+					 skb_is_gso(skb));
+			goto tx_drop_count;
+		}
+		apc->eth_stats.tx_linear_pkt_cnt++;
+	}
+
 	pkg.tx_oob.s_oob.vcq_num = cq->gdma_id;
 	pkg.tx_oob.s_oob.vsq_frame = txq->vsq_frame;
 
@@ -442,8 +458,6 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		}
 	}
 
-	WARN_ON_ONCE(pkg.wqe_req.num_sge > MAX_TX_WQE_SGL_ENTRIES);
-
 	if (pkg.wqe_req.num_sge <= ARRAY_SIZE(pkg.sgl_array)) {
 		pkg.wqe_req.sgl = pkg.sgl_array;
 	} else {
@@ -518,6 +532,25 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	return NETDEV_TX_OK;
 }
 
+#if (MAX_SKB_FRAGS + 2 > MANA_MAX_TX_WQE_SGL_ENTRIES)
+static netdev_features_t mana_features_check(struct sk_buff *skb,
+					     struct net_device *ndev,
+					     netdev_features_t features)
+{
+	if (skb_shinfo(skb)->nr_frags + 2 > MAX_TX_WQE_SGL_ENTRIES) {
+		/* Exceeds HW SGE limit.
+		 * GSO case:
+		 *   Disable GSO so the stack will software-segment the skb
+		 *   into smaller skbs that fit the SGE budget.
+		 * Non-GSO case:
+		 *   The xmit path will attempt skb_linearize() as a fallback.
+		 */
+		features &= ~NETIF_F_GSO_MASK;
+	}
+	return features;
+}
+#endif
+
 static void mana_get_stats64(struct net_device *ndev,
 			     struct rtnl_link_stats64 *st)
 {
@@ -890,6 +923,9 @@ static const struct net_device_ops mana_devops = {
 	.ndo_open		= mana_open,
 	.ndo_stop		= mana_close,
 	.ndo_select_queue	= mana_select_queue,
+#if (MAX_SKB_FRAGS + 2 > MANA_MAX_TX_WQE_SGL_ENTRIES)
+	.ndo_features_check	= mana_features_check,
+#endif
 	.ndo_start_xmit		= mana_start_xmit,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_get_stats64	= mana_get_stats64,
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 99e8112086833..0e2f4343ac67f 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -18,6 +18,8 @@ static const struct mana_stats_desc mana_eth_stats[] = {
 	{"tx_cq_err", offsetof(struct mana_ethtool_stats, tx_cqe_err)},
 	{"tx_cqe_unknown_type", offsetof(struct mana_ethtool_stats,
 					tx_cqe_unknown_type)},
+	{"tx_linear_pkt_cnt", offsetof(struct mana_ethtool_stats,
+				       tx_linear_pkt_cnt)},
 	{"rx_coalesced_err", offsetof(struct mana_ethtool_stats,
 					rx_coalesced_err)},
 	{"rx_cqe_unknown_type", offsetof(struct mana_ethtool_stats,
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 2e4f2f3175e55..a4cf307859f85 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -486,6 +486,8 @@ struct gdma_wqe {
 #define INLINE_OOB_SMALL_SIZE 8
 #define INLINE_OOB_LARGE_SIZE 24
 
+#define MANA_MAX_TX_WQE_SGL_ENTRIES 30
+
 #define MAX_TX_WQE_SIZE 512
 #define MAX_RX_WQE_SIZE 256
 
@@ -592,6 +594,9 @@ enum {
 #define GDMA_DRV_CAP_FLAG_1_HANDLE_RECONFIG_EQE BIT(17)
 #define GDMA_DRV_CAP_FLAG_1_HW_VPORT_LINK_AWARE BIT(6)
 
+/* Driver supports linearizing the skb when num_sge exceeds hardware limit */
+#define GDMA_DRV_CAP_FLAG_1_SKB_LINEARIZE BIT(20)
+
 /* Driver can send HWC periodically to query stats */
 #define GDMA_DRV_CAP_FLAG_1_PERIODIC_STATS_QUERY BIT(21)
 
@@ -605,7 +610,8 @@ enum {
 	 GDMA_DRV_CAP_FLAG_1_SELF_RESET_ON_EQE | \
 	 GDMA_DRV_CAP_FLAG_1_HANDLE_RECONFIG_EQE | \
 	 GDMA_DRV_CAP_FLAG_1_HW_VPORT_LINK_AWARE | \
-	 GDMA_DRV_CAP_FLAG_1_PERIODIC_STATS_QUERY)
+	 GDMA_DRV_CAP_FLAG_1_PERIODIC_STATS_QUERY | \
+	 GDMA_DRV_CAP_FLAG_1_SKB_LINEARIZE)
 
 #define GDMA_DRV_CAP_FLAGS2 0
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 7e946239effa9..9fadff78568ea 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -377,6 +377,7 @@ struct mana_ethtool_stats {
 	u64 wake_queue;
 	u64 tx_cqe_err;
 	u64 tx_cqe_unknown_type;
+	u64 tx_linear_pkt_cnt;
 	u64 rx_coalesced_err;
 	u64 rx_cqe_unknown_type;
 };
-- 
2.53.0



