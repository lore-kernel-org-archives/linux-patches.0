Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7C8303A0D;
	Sat, 17 Oct 2026 16:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256382; cv=none; b=W94gMI10NSiyQTmXW1ZuQdBbnyr7iM8QDES+q10fC3vnz5sqX7S53eAbdgaHEHWHuaEg77FZg/KusLpRUrShQJGsB9s+YttgKBNOqAMykSOpES3MtQH+VOahURRHDE8QeFDbsraIgNqUdWGnGMq4YcIETN27RbIS1yOgWjhzn/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256382; c=relaxed/simple;
	bh=BD2CV8CLgMeLYn2Uc1Xx/fKMOcrlHCk5SmGGRDPCRO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFhF/RfcB6T5hjelbU65bP9+gQLavbrVius0ufUql/nS9h7apbpKRdd38EsWLnnYGPKGuM7zs4nBuxMaCtnrs68Jq6N4FNxIZIsvQkDUWt+LHgCKEm5N1IXofPzkLSvVuCUdQy2sr68gz0Y25jZhe+gMgAIY1u92+JerPe51myU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3nMq9Xu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3nMq9Xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5361F000C4;
	Sat, 17 Oct 2026 16:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256380;
	bh=vIif2KaS+8JwKzi+OhEgi0RINKDsBr73Oo15LZN8mos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3nMq9Xu70T3zp57LyGBQLmPFlw9rA5tkOceb+Uub8CWNafXaNUJ7K4QvW/wwhjZr
	 Urc2/ER7Br47LDtl5rnafeJRAkcHtBS2E33p8Bl7d+EZuRMcGWPMirrliUXVC6osDk
	 91Py+jiNwxt6tksfHgVnulhBbJ2VKUFUPW+90hhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandeep Haemoon <sandeeph@loljews.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0218/1674] net: ethernet: mtk_eth_soc: allocate dummy netdev sooner
Date: Sat, 17 Oct 2026 17:41:30 +0200
Message-ID: <20261017160436.743771581@linuxfoundation.org>
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
index 261bc1a1b55a3..9827e914df1df 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -5031,6 +5031,22 @@ static int mtk_probe(struct platform_device *pdev)
 			goto err_deinit_ppe;
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
@@ -5045,18 +5061,6 @@ static int mtk_probe(struct platform_device *pdev)
 				   eth->netdev[i]->base_addr, eth->irq[0]);
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
@@ -5066,6 +5070,16 @@ static int mtk_probe(struct platform_device *pdev)
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



