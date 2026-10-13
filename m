Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B6B4F799A;
	Tue, 13 Oct 2026 12:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895029; cv=none; b=THaaDAQjiZlP9JA/NCJGcH2UaEPiXasb7wZytbFMEerZWfALaKGZC3h78bgoSjOyBUZsTnbrGX+VPy5JFzJSWawtVZT1B9SWADPm8E0WHFb6rFL9O0Rw2VeGXVLKRC75azmHgvrj0iy/WzfbTzQbHh7meLfc49BwenMeCiofAro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895029; c=relaxed/simple;
	bh=QiXepk9QWS0wWfteEpcUj8Zs6bR57iD2eBCj+NMmKRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TeysObtYc3h4memP7qo/Kgs0drS/zTvU0sZhKhG2UJCc3Ze9POi3/SdWzGHmMkkcRaoV755Fd3W3jO7YXkXzCstUUJ4MwUNCVLh01FNLVs5TdZq36baqz+BPmjrhTpAtdw3eNXYU7wOLRFPSb4A8DATqw/VIyduNM+uH7NUObUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLFFWqrQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLFFWqrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6971F00893;
	Tue, 13 Oct 2026 12:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895028;
	bh=al+mdvEJ/pst6o4x3H4cYfbxdDtBRrm+qbvEqZ4XlCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLFFWqrQzxs4utvYFksbLKeyjYRIzGslDUZMqPDk7kjots3MJp2ZToXgxfGq0Mhfi
	 VSn5kfjLpsjA+8AJQQ4ASgbQAuncaSZkYU5fr/9lwkOFH54HNtacFnZVQ1R/rJMAJg
	 kbSPU09Tog6mIw9reHIAkCIqbYx5qmojzSShaopw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandeep Haemoon <sandeeph@loljews.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/497] net: ethernet: mtk_eth_soc: allocate dummy netdev sooner
Date: Tue, 13 Oct 2026 13:34:20 +0200
Message-ID: <20261013112910.099041263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Sandeep Haemoon <sandeeph@loljews.com>

[ Upstream commit 6f0c2c4f5e7143eba75153ecc8af3a03f7b6a98b ]

The RX rings and the shared NAPI are carried by an internal "dummy" netdev
(eth->dummy_dev). mtk_probe() creates that dummy device, and adds the
shared tx/rx NAPI to it, only after the MAC netdevs have been registered.
That order has been there since the MT7623 support was added and leaves a
window in which the netdevs are visible to the network core before the
shared NAPI and the dummy device exist.

If anything brings the first netdev up during that window (e.g. netifd
opening the WAN link the instant the interface is registered), the
first-open path runs without them. On NETSYS v2 and later SoCs
mtk_rx_alloc() -> __xdp_rxq_info_reg() then dereferences eth->dummy_dev ==
NULL:

  WARNING: CPU: ... Missing net_device from driver

in net/core/xdp.c and mtk_open() fails with -ENODEV. On NETSYS v1 SoCs
(MT7621/MT7622/MT7623/MT7629) there is no page pool, so the same open
instead calls napi_enable() on a napi_struct that netif_napi_add() has not
initialised yet and dereferences a NULL napi->dev.

Allocate the dummy netdev and add the shared tx/rx NAPI to it before the
register_netdev() loop. Both the dummy-allocation failure and a
register_netdev() failure now unwind through mtk_unreg_dev(), which
unregisters the net_device notifiers and the netdevs registered so far,
stopping a concurrently-opened netdev (ndo_stop) and its NAPI before the
dummy carrier is freed.

A netdev that opened during the window can also have queued the
frame-engine reset worker (via the tx watchdog or phylink), so the probe
error path now cancels eth->pending_work before freeing the shared state,
as mtk_cleanup() already does on remove.

Fixes: 656e705243fd ("net-next: mediatek: add support for MT7623 ethernet")
Signed-off-by: Sandeep Haemoon <sandeeph@loljews.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/patch-e52c13380b0768fec63af04c80e4b487@loljews.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 38 ++++++++++++++-------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 4c9ebbb1b4f18..489c909e7327f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -5125,6 +5125,22 @@ static int mtk_probe(struct platform_device *pdev)
 		}
 	}
 
+	/* we run 2 devices on the same DMA ring so we need a dummy device
+	 * for NAPI to work. Allocate it before registering the netdevs so a
+	 * concurrent ndo_open (e.g. netifd bringing the first netdev up the
+	 * instant it is registered) never observes eth->dummy_dev == NULL in
+	 * mtk_dma_init() -> mtk_rx_alloc() -> __xdp_rxq_info_reg() (net/core/xdp.c
+	 * "Missing net_device from driver") and fails the first open.
+	 */
+	eth->dummy_dev = alloc_netdev_dummy(0);
+	if (!eth->dummy_dev) {
+		err = -ENOMEM;
+		dev_err(eth->dev, "failed to allocated dummy device\n");
+		goto err_unreg_netdev;
+	}
+	netif_napi_add(eth->dummy_dev, &eth->tx_napi, mtk_napi_tx);
+	netif_napi_add(eth->dummy_dev, &eth->rx_napi, mtk_napi_rx);
+
 	for (i = 0; i < MTK_MAX_DEVS; i++) {
 		if (!eth->netdev[i])
 			continue;
@@ -5139,18 +5155,6 @@ static int mtk_probe(struct platform_device *pdev)
 				   eth->netdev[i]->base_addr, eth->irq[MTK_FE_IRQ_SHARED]);
 	}
 
-	/* we run 2 devices on the same DMA ring so we need a dummy device
-	 * for NAPI to work
-	 */
-	eth->dummy_dev = alloc_netdev_dummy(0);
-	if (!eth->dummy_dev) {
-		err = -ENOMEM;
-		dev_err(eth->dev, "failed to allocated dummy device\n");
-		goto err_unreg_netdev;
-	}
-	netif_napi_add(eth->dummy_dev, &eth->tx_napi, mtk_napi_tx);
-	netif_napi_add(eth->dummy_dev, &eth->rx_napi, mtk_napi_rx);
-
 	platform_set_drvdata(pdev, eth);
 	schedule_delayed_work(&eth->reset.monitor_work,
 			      MTK_DMA_MONITOR_TIMEOUT);
@@ -5160,6 +5164,16 @@ static int mtk_probe(struct platform_device *pdev)
 err_unreg_netdev:
 	mtk_unreg_dev(eth);
 err_deinit_ppe:
+	/* A netdev opened while probe was still registering can have queued
+	 * the frame-engine reset worker, which takes rtnl and drives the
+	 * hardware; cancel it before anything below is torn down.
+	 */
+	cancel_work_sync(&eth->pending_work);
+	if (eth->dummy_dev) {
+		netif_napi_del(&eth->tx_napi);
+		netif_napi_del(&eth->rx_napi);
+		free_netdev(eth->dummy_dev);
+	}
 	mtk_ppe_deinit(eth);
 	mtk_mdio_cleanup(eth);
 err_free_dev:
-- 
2.53.0



