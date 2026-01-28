Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291D22DEA6B;
	Wed, 28 Jan 2026 15:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615089; cv=none; b=MW0qx/8n47AE1g+yvCm/xudszZHdzJ+xGdcPc4XhzDKOl1TLXUizkXQejPoisdlKssbOIGzozP1aE6GSc7mmnQN8yKX1ATYtsmZo8birA1DNfT/lqa1agwcl8Vaqu+XUQ6eC7bntVHJe/D6l7yjUQ4KaEnHtoqJ4CuGAsAD22Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615089; c=relaxed/simple;
	bh=1y0/brp4D0Mp+zqv/J38JfzEpGmsvO3JylfdLF3KyZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVJxxInXKYoqSzi7xfIeOmuphsN9hRQ+k/4ncD1qdmpF8fyn6coE+Nfuf6pRMT7D1TeuUZnm+exA7x2i+bOCpcMsPxX6WirGsrSmRh2F//3Fg/hJzFBoyDIp/gWpjoz3zU0SHpuidr+Eu4GWsM5RFjNKQu6Q0ca9mcLp8NS0/uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Zhm2TEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Zhm2TEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2393C4CEF7;
	Wed, 28 Jan 2026 15:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615089;
	bh=1y0/brp4D0Mp+zqv/J38JfzEpGmsvO3JylfdLF3KyZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Zhm2TEtrTldt35GzQjZQ1QD8UcaPAgRVMWG0B50t4sdWs9jUqkutvKiA2JIftDSj
	 sR8ql/bqVvPe4HMcDsbm5kDTPJIhuDGWOm4lxLo7XthdmL8+zZFd04uzigkIH2ByyV
	 h21unwlEUAOsrX6m1MH3uBhzvCcMD+FypDf61Tsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/169] net: hns3: fix data race in hns3_fetch_stats
Date: Wed, 28 Jan 2026 16:22:37 +0100
Message-ID: <20260128145336.671442271@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit 748a81c8ceda1fdbdcd0af595947422e810442aa ]

In hns3_fetch_stats(), ring statistics, protected by u64_stats_sync, are
read and accumulated in ignorance of possible u64_stats_fetch_retry()
events. These statistics are already accumulated by
hns3_ring_stats_update(). Fix this by reading them into a temporary
buffer first.

Fixes: b20d7fe51e0d ("net: hns3: add some statitics info to tx process")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Link: https://patch.msgid.link/20260119160759.1455950-1-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 69 ++++++++++---------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 94432e237640d..b477bd286ed72 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2500,44 +2500,47 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 static void hns3_fetch_stats(struct rtnl_link_stats64 *stats,
 			     struct hns3_enet_ring *ring, bool is_tx)
 {
+	struct ring_stats ring_stats;
 	unsigned int start;
 
 	do {
 		start = u64_stats_fetch_begin(&ring->syncp);
-		if (is_tx) {
-			stats->tx_bytes += ring->stats.tx_bytes;
-			stats->tx_packets += ring->stats.tx_pkts;
-			stats->tx_dropped += ring->stats.sw_err_cnt;
-			stats->tx_dropped += ring->stats.tx_vlan_err;
-			stats->tx_dropped += ring->stats.tx_l4_proto_err;
-			stats->tx_dropped += ring->stats.tx_l2l3l4_err;
-			stats->tx_dropped += ring->stats.tx_tso_err;
-			stats->tx_dropped += ring->stats.over_max_recursion;
-			stats->tx_dropped += ring->stats.hw_limitation;
-			stats->tx_dropped += ring->stats.copy_bits_err;
-			stats->tx_dropped += ring->stats.skb2sgl_err;
-			stats->tx_dropped += ring->stats.map_sg_err;
-			stats->tx_errors += ring->stats.sw_err_cnt;
-			stats->tx_errors += ring->stats.tx_vlan_err;
-			stats->tx_errors += ring->stats.tx_l4_proto_err;
-			stats->tx_errors += ring->stats.tx_l2l3l4_err;
-			stats->tx_errors += ring->stats.tx_tso_err;
-			stats->tx_errors += ring->stats.over_max_recursion;
-			stats->tx_errors += ring->stats.hw_limitation;
-			stats->tx_errors += ring->stats.copy_bits_err;
-			stats->tx_errors += ring->stats.skb2sgl_err;
-			stats->tx_errors += ring->stats.map_sg_err;
-		} else {
-			stats->rx_bytes += ring->stats.rx_bytes;
-			stats->rx_packets += ring->stats.rx_pkts;
-			stats->rx_dropped += ring->stats.l2_err;
-			stats->rx_errors += ring->stats.l2_err;
-			stats->rx_errors += ring->stats.l3l4_csum_err;
-			stats->rx_crc_errors += ring->stats.l2_err;
-			stats->multicast += ring->stats.rx_multicast;
-			stats->rx_length_errors += ring->stats.err_pkt_len;
-		}
+		ring_stats = ring->stats;
 	} while (u64_stats_fetch_retry(&ring->syncp, start));
+
+	if (is_tx) {
+		stats->tx_bytes += ring_stats.tx_bytes;
+		stats->tx_packets += ring_stats.tx_pkts;
+		stats->tx_dropped += ring_stats.sw_err_cnt;
+		stats->tx_dropped += ring_stats.tx_vlan_err;
+		stats->tx_dropped += ring_stats.tx_l4_proto_err;
+		stats->tx_dropped += ring_stats.tx_l2l3l4_err;
+		stats->tx_dropped += ring_stats.tx_tso_err;
+		stats->tx_dropped += ring_stats.over_max_recursion;
+		stats->tx_dropped += ring_stats.hw_limitation;
+		stats->tx_dropped += ring_stats.copy_bits_err;
+		stats->tx_dropped += ring_stats.skb2sgl_err;
+		stats->tx_dropped += ring_stats.map_sg_err;
+		stats->tx_errors += ring_stats.sw_err_cnt;
+		stats->tx_errors += ring_stats.tx_vlan_err;
+		stats->tx_errors += ring_stats.tx_l4_proto_err;
+		stats->tx_errors += ring_stats.tx_l2l3l4_err;
+		stats->tx_errors += ring_stats.tx_tso_err;
+		stats->tx_errors += ring_stats.over_max_recursion;
+		stats->tx_errors += ring_stats.hw_limitation;
+		stats->tx_errors += ring_stats.copy_bits_err;
+		stats->tx_errors += ring_stats.skb2sgl_err;
+		stats->tx_errors += ring_stats.map_sg_err;
+	} else {
+		stats->rx_bytes += ring_stats.rx_bytes;
+		stats->rx_packets += ring_stats.rx_pkts;
+		stats->rx_dropped += ring_stats.l2_err;
+		stats->rx_errors += ring_stats.l2_err;
+		stats->rx_errors += ring_stats.l3l4_csum_err;
+		stats->rx_crc_errors += ring_stats.l2_err;
+		stats->multicast += ring_stats.rx_multicast;
+		stats->rx_length_errors += ring_stats.err_pkt_len;
+	}
 }
 
 static void hns3_nic_get_stats64(struct net_device *netdev,
-- 
2.51.0



