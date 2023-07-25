Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FC414263
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12663C433C8;
	Tue, 25 Jul 2023 10:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282429;
	bh=xbH6wIwOZG5M2DaP0ZJgalD+ZaD9fshGC5PX0Sdww5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8P2CAarzySyG7mUKvOY0Uw1gFdYIpe3igeA+4EdAFcZHTJi6hdyYIQ6p1p6Kkv79
	 01wVIbVThJ9oZS1PECYMKv2+ErqLXQdXjWaJn2TjUYFwNSlWbH/QS2NS6O/eEnM0sd
	 Ew0XklxTJWBCUT99ZScnzmG1ryFZHjPnAZx9uwjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Simon Horman <simon.horman@corigine.com>,
	Gabriel Somlo <gsomlo@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 125/227] net: ethernet: litex: add support for 64 bit stats
Date: Tue, 25 Jul 2023 12:44:52 +0200
Message-ID: <20230725104519.984933604@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 18da174d865a87d47d2f33f5b0a322efcf067728 ]

Implement 64 bit per cpu stats to fix the overflow of netdev->stats
on 32 bit platforms. To simplify the code, we use net core
pcpu_sw_netstats infrastructure. One small drawback is some memory
overhead because litex uses just one queue, but we allocate the
counters per cpu.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Gabriel Somlo <gsomlo@gmail.com>
Link: https://lore.kernel.org/r/20230614162035.300-1-jszhang@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/litex/litex_liteeth.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/litex/litex_liteeth.c b/drivers/net/ethernet/litex/litex_liteeth.c
index 35f24e0f09349..ffa96059079c6 100644
--- a/drivers/net/ethernet/litex/litex_liteeth.c
+++ b/drivers/net/ethernet/litex/litex_liteeth.c
@@ -78,8 +78,7 @@ static int liteeth_rx(struct net_device *netdev)
 	memcpy_fromio(data, priv->rx_base + rx_slot * priv->slot_size, len);
 	skb->protocol = eth_type_trans(skb, netdev);
 
-	netdev->stats.rx_packets++;
-	netdev->stats.rx_bytes += len;
+	dev_sw_netstats_rx_add(netdev, len);
 
 	return netif_rx(skb);
 
@@ -185,8 +184,7 @@ static netdev_tx_t liteeth_start_xmit(struct sk_buff *skb,
 	litex_write16(priv->base + LITEETH_READER_LENGTH, skb->len);
 	litex_write8(priv->base + LITEETH_READER_START, 1);
 
-	netdev->stats.tx_bytes += skb->len;
-	netdev->stats.tx_packets++;
+	dev_sw_netstats_tx_add(netdev, 1, skb->len);
 
 	priv->tx_slot = (priv->tx_slot + 1) % priv->num_tx_slots;
 	dev_kfree_skb_any(skb);
@@ -194,9 +192,17 @@ static netdev_tx_t liteeth_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static void
+liteeth_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
+{
+	netdev_stats_to_stats64(stats, &netdev->stats);
+	dev_fetch_sw_netstats(stats, netdev->tstats);
+}
+
 static const struct net_device_ops liteeth_netdev_ops = {
 	.ndo_open		= liteeth_open,
 	.ndo_stop		= liteeth_stop,
+	.ndo_get_stats64	= liteeth_get_stats64,
 	.ndo_start_xmit         = liteeth_start_xmit,
 };
 
@@ -242,6 +248,11 @@ static int liteeth_probe(struct platform_device *pdev)
 	priv->netdev = netdev;
 	priv->dev = &pdev->dev;
 
+	netdev->tstats = devm_netdev_alloc_pcpu_stats(&pdev->dev,
+						      struct pcpu_sw_netstats);
+	if (!netdev->tstats)
+		return -ENOMEM;
+
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return irq;
-- 
2.39.2



