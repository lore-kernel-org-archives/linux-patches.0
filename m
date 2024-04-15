Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F44B36AE0;
	Mon, 15 Apr 2024 14:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191658; cv=none; b=C1sXF9n+vvKBQ/v0ucKbv3vM1TtPzZZ071frvtcmga7mnO/NR8zL34j3YGc5wmARrw3AVommhNojknBKhlQV1FDCM65QG/ouZ7roIz/WeC/7Fz34PIRp0j+Quk0TkkVmvk82v5SWfWHZX2H0tQ2+ArHlYHVLjk5IdUgX6SUvfVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191658; c=relaxed/simple;
	bh=LH5+YijjafGfJpQ6TfMZuPe7hxzKl/B9pMq4TNwrRi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxiZehRdi2zTlbiv+CokGXlTElGpKS7pMqRES/xbP1pbLNpzYvEBPnqTbphl1Zo26/sPii1T63i4xGIuZYJghQycx3MHRe55CLKDCEO744/WnJEWoltrIUP4vh+sX+pPHfFpwM+UoiFxwAzdmclBB0oFboQ8TZoLo+WxyneL7YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRxTGMYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRxTGMYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A24C113CC;
	Mon, 15 Apr 2024 14:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191658;
	bh=LH5+YijjafGfJpQ6TfMZuPe7hxzKl/B9pMq4TNwrRi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRxTGMYK5xfz+vKB6LERR/Qv54aXA8CXzuDw482nLa/ayLczSf+uMElpAFJTX3lp5
	 M8STHEE1zP2prgbpZmCRaT7kEda/h5eizeb6DSU5rh2LnHQUL7MlAPr15RGXP0op6O
	 LIPFNiiRpbPmXw488X0QgFW5SKQRMrTprLAmrVRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/122] net: ks8851: Inline ks8851_rx_skb()
Date: Mon, 15 Apr 2024 16:20:06 +0200
Message-ID: <20240415141954.600079228@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit f96f700449b6d190e06272f1cf732ae8e45b73df ]

Both ks8851_rx_skb_par() and ks8851_rx_skb_spi() call netif_rx(skb),
inline the netif_rx(skb) call directly into ks8851_common.c and drop
the .rx_skb callback and ks8851_rx_skb() wrapper. This removes one
indirect call from the driver, no functional change otherwise.

Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20240405203204.82062-1-marex@denx.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: be0384bf599c ("net: ks8851: Handle softirqs at the end of IRQ thread to fix hang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851.h        |  3 ---
 drivers/net/ethernet/micrel/ks8851_common.c | 12 +-----------
 drivers/net/ethernet/micrel/ks8851_par.c    | 11 -----------
 drivers/net/ethernet/micrel/ks8851_spi.c    | 11 -----------
 4 files changed, 1 insertion(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.h b/drivers/net/ethernet/micrel/ks8851.h
index e5ec0a363aff8..31f75b4a67fd7 100644
--- a/drivers/net/ethernet/micrel/ks8851.h
+++ b/drivers/net/ethernet/micrel/ks8851.h
@@ -368,7 +368,6 @@ union ks8851_tx_hdr {
  * @rdfifo: FIFO read callback
  * @wrfifo: FIFO write callback
  * @start_xmit: start_xmit() implementation callback
- * @rx_skb: rx_skb() implementation callback
  * @flush_tx_work: flush_tx_work() implementation callback
  *
  * The @statelock is used to protect information in the structure which may
@@ -423,8 +422,6 @@ struct ks8851_net {
 					  struct sk_buff *txp, bool irq);
 	netdev_tx_t		(*start_xmit)(struct sk_buff *skb,
 					      struct net_device *dev);
-	void			(*rx_skb)(struct ks8851_net *ks,
-					  struct sk_buff *skb);
 	void			(*flush_tx_work)(struct ks8851_net *ks);
 };
 
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 0bf13b38b8f5b..896d43bb8883d 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -231,16 +231,6 @@ static void ks8851_dbg_dumpkkt(struct ks8851_net *ks, u8 *rxpkt)
 		   rxpkt[12], rxpkt[13], rxpkt[14], rxpkt[15]);
 }
 
-/**
- * ks8851_rx_skb - receive skbuff
- * @ks: The device state.
- * @skb: The skbuff
- */
-static void ks8851_rx_skb(struct ks8851_net *ks, struct sk_buff *skb)
-{
-	ks->rx_skb(ks, skb);
-}
-
 /**
  * ks8851_rx_pkts - receive packets from the host
  * @ks: The device information.
@@ -309,7 +299,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 					ks8851_dbg_dumpkkt(ks, rxpkt);
 
 				skb->protocol = eth_type_trans(skb, ks->netdev);
-				ks8851_rx_skb(ks, skb);
+				netif_rx(skb);
 
 				ks->netdev->stats.rx_packets++;
 				ks->netdev->stats.rx_bytes += rxlen;
diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
index 7f49042484bdc..96fb0ffcedb90 100644
--- a/drivers/net/ethernet/micrel/ks8851_par.c
+++ b/drivers/net/ethernet/micrel/ks8851_par.c
@@ -210,16 +210,6 @@ static void ks8851_wrfifo_par(struct ks8851_net *ks, struct sk_buff *txp,
 	iowrite16_rep(ksp->hw_addr, txp->data, len / 2);
 }
 
-/**
- * ks8851_rx_skb_par - receive skbuff
- * @ks: The device state.
- * @skb: The skbuff
- */
-static void ks8851_rx_skb_par(struct ks8851_net *ks, struct sk_buff *skb)
-{
-	netif_rx(skb);
-}
-
 static unsigned int ks8851_rdreg16_par_txqcr(struct ks8851_net *ks)
 {
 	return ks8851_rdreg16_par(ks, KS_TXQCR);
@@ -298,7 +288,6 @@ static int ks8851_probe_par(struct platform_device *pdev)
 	ks->rdfifo = ks8851_rdfifo_par;
 	ks->wrfifo = ks8851_wrfifo_par;
 	ks->start_xmit = ks8851_start_xmit_par;
-	ks->rx_skb = ks8851_rx_skb_par;
 
 #define STD_IRQ (IRQ_LCI |	/* Link Change */	\
 		 IRQ_RXI |	/* RX done */		\
diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
index 88e26c120b483..4dcbff789b19d 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -298,16 +298,6 @@ static unsigned int calc_txlen(unsigned int len)
 	return ALIGN(len + 4, 4);
 }
 
-/**
- * ks8851_rx_skb_spi - receive skbuff
- * @ks: The device state
- * @skb: The skbuff
- */
-static void ks8851_rx_skb_spi(struct ks8851_net *ks, struct sk_buff *skb)
-{
-	netif_rx(skb);
-}
-
 /**
  * ks8851_tx_work - process tx packet(s)
  * @work: The work strucutre what was scheduled.
@@ -435,7 +425,6 @@ static int ks8851_probe_spi(struct spi_device *spi)
 	ks->rdfifo = ks8851_rdfifo_spi;
 	ks->wrfifo = ks8851_wrfifo_spi;
 	ks->start_xmit = ks8851_start_xmit_spi;
-	ks->rx_skb = ks8851_rx_skb_spi;
 	ks->flush_tx_work = ks8851_flush_tx_work_spi;
 
 #define STD_IRQ (IRQ_LCI |	/* Link Change */	\
-- 
2.43.0



