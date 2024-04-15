Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9527A78C8B;
	Mon, 15 Apr 2024 14:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191187; cv=none; b=XnazgaR6ZxucbBK+mk+tHU8Gs23QU0H6tH97ASzYwd7nov4hHXMer/wcJmB9g1MKcRhAwBVOb4HS0biHI7a6PPI3rUoo0+godjAFHEtVHeXphcZimUWMses/U3T7fDatuSa/UuyAIN/MyhqCegnb0LlqYxYk7gJDPVKEA9UvVZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191187; c=relaxed/simple;
	bh=/+61h7FDESaGxEznTiL5bFbdskm1tjb6Nj47x/THUHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ux1OXQO4caNZhJUymPrkaGS5RRgWJ3GNxAV9lOQFNboGclt1de7w7VvBOmg3ib9mUBH3qI2RuGdNX/Hwqdb/RnhiEw/ZMQQYth8AFQuidodErN3LuEvSZkXKsUI/Rb8v2lC8HKqU0Sklmo15mGz5yCK0igcZigehqmKsEUSb8Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPOacNgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPOacNgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBE7C2BD10;
	Mon, 15 Apr 2024 14:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191187;
	bh=/+61h7FDESaGxEznTiL5bFbdskm1tjb6Nj47x/THUHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPOacNgYm+4EIw3Bn1ND/Oo3OR1Lbc+OTzG7jj1Rg7qkfJdBeAvLOqywZPDB1kMe9
	 gEsDo2YPLh3gUTBPEcwmKYDlDCA1+JgChLOouBvjjOfgx6vt6maO1wFLSaHdUK2I6L
	 NKkaLtUZmCEf6a92uAJGzIUxelxjoetcpmX8NzbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 062/172] net: ks8851: Inline ks8851_rx_skb()
Date: Mon, 15 Apr 2024 16:19:21 +0200
Message-ID: <20240415142002.299705125@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 2a7f298542670..381b9cd285ebd 100644
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
index 54f2eac11a631..55f6f9f6d030e 100644
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



