Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EFD3A254B;
	Thu, 30 Jul 2026 14:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422070; cv=none; b=SXn3zz45NCSfeq08x7LWPh20DZOuZC+Oo7/A+cJza72qBGL/dtbybbvEFs/ZFBR+gZ3qn5eoFbXkYmpUgolEO2s5d2gly8WSa8OLuzm3wG3GCIOuTU89EzjvV1vssKXkmhxreYhGWuRjR3XTxbr7XdHHRPTKEMom1Cc7LolaYOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422070; c=relaxed/simple;
	bh=9JL+2hezkJKkOnv+/jodiuJyrQB4JqqWvOAiqfT12so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHwRCodqgNii2c+gzpiAdKRxnW7PsCiFJy4noniQ/ny0uvfp/RZuHSrx6NITgat9PaHUJ9jDnvKty6l1TmJxpmyvdBRdC6N01C1ucxkMLchEWa/ND4oXzjs1+6ap5xCXKp4iUArHKc3xlTdKU2SsFtwvVBIy61ZuNMcH5qU7ynM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwuQpY03; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwuQpY03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3547A1F000E9;
	Thu, 30 Jul 2026 14:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422068;
	bh=K5SNeG50LtrtUPfKfEtcN8Nc2pzCUA84/j/yqX7wKi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZwuQpY03a+r2tHLEeZSUUqU7dVBWggDO8IDKD8cOaxnmRUNXZCrDHpSxyNNzZvCUT
	 S/rUzK18IYuXzk8VVot+ACHBx0Sq2nh0bIDBmeLVBKXYpb+3/80F7Mn0ABrldjPVHU
	 SFGTkLKC/8jYPbsynhYGG1n3xJ4s8Knkg6KkEcLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Luis Lang <luis.la@mail.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 312/744] net: stmmac: dwmac4: mask interrupts when stopping DMA in suspend
Date: Thu, 30 Jul 2026 16:09:45 +0200
Message-ID: <20260730141450.918233960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Lang <luis.la@mail.de>

[ Upstream commit 59a57128ae5231f9aa9d544fa9d3e38986f0efaa ]

Since commit 1b9707e6f1a9 ("net: stmmac: enable RPS and RBU
interrupts"), suspending causes an interrupt storm from the RPS
interrupt.
Fix this by adding a deinit_chan() op to stmmac_dma_ops, which
masks all default dma channel interrupts. This is called from
stmmac_stop_all_dma(), so interrupts don't trigger while suspending.

Fixes: 1b9707e6f1a9 ("net: stmmac: enable RPS and RBU interrupts")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Suggested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Luis Lang <luis.la@mail.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260720111534.163416-1-luis.la@mail.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 24 +++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  4 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 ++++
 3 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 28728271fbc9ef..55c170b930106c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -106,6 +106,17 @@ static void dwmac4_dma_init_channel(struct stmmac_priv *priv,
 	       ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
 }
 
+static void dwmac4_dma_deinit_channel(struct stmmac_priv *priv,
+				      void __iomem *ioaddr, u32 chan)
+{
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+	u32 value;
+
+	value = readl(ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
+	value &= ~DMA_CHAN_INTR_DEFAULT_MASK;
+	writel(value, ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
+}
+
 static void dwmac410_dma_init_channel(struct stmmac_priv *priv,
 				      void __iomem *ioaddr,
 				      struct stmmac_dma_cfg *dma_cfg, u32 chan)
@@ -125,6 +136,17 @@ static void dwmac410_dma_init_channel(struct stmmac_priv *priv,
 	       ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
 }
 
+static void dwmac410_dma_deinit_channel(struct stmmac_priv *priv,
+					void __iomem *ioaddr, u32 chan)
+{
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+	u32 value;
+
+	value = readl(ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
+	value &= ~DMA_CHAN_INTR_DEFAULT_MASK_4_10;
+	writel(value, ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
+}
+
 static void dwmac4_dma_init(void __iomem *ioaddr,
 			    struct stmmac_dma_cfg *dma_cfg)
 {
@@ -547,6 +569,7 @@ const struct stmmac_dma_ops dwmac4_dma_ops = {
 	.reset = dwmac4_dma_reset,
 	.init = dwmac4_dma_init,
 	.init_chan = dwmac4_dma_init_channel,
+	.deinit_chan = dwmac4_dma_deinit_channel,
 	.init_rx_chan = dwmac4_dma_init_rx_chan,
 	.init_tx_chan = dwmac4_dma_init_tx_chan,
 	.axi = dwmac4_dma_axi,
@@ -576,6 +599,7 @@ const struct stmmac_dma_ops dwmac410_dma_ops = {
 	.reset = dwmac4_dma_reset,
 	.init = dwmac4_dma_init,
 	.init_chan = dwmac410_dma_init_channel,
+	.deinit_chan = dwmac410_dma_deinit_channel,
 	.init_rx_chan = dwmac4_dma_init_rx_chan,
 	.init_tx_chan = dwmac4_dma_init_tx_chan,
 	.axi = dwmac4_dma_axi,
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index e6317b94fff7d4..04dafec021b4f9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -170,6 +170,8 @@ struct stmmac_dma_ops {
 	void (*init)(void __iomem *ioaddr, struct stmmac_dma_cfg *dma_cfg);
 	void (*init_chan)(struct stmmac_priv *priv, void __iomem *ioaddr,
 			  struct stmmac_dma_cfg *dma_cfg, u32 chan);
+	void (*deinit_chan)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    u32 chan);
 	void (*init_rx_chan)(struct stmmac_priv *priv, void __iomem *ioaddr,
 			     struct stmmac_dma_cfg *dma_cfg,
 			     dma_addr_t phy, u32 chan);
@@ -235,6 +237,8 @@ struct stmmac_dma_ops {
 	stmmac_do_void_callback(__priv, dma, init, __args)
 #define stmmac_init_chan(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, init_chan, __priv, __args)
+#define stmmac_deinit_chan(__priv, __args...) \
+	stmmac_do_void_callback(__priv, dma, deinit_chan, __priv, __args)
 #define stmmac_init_rx_chan(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, init_rx_chan, __priv, __args)
 #define stmmac_init_tx_chan(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3591755ea30be5..50dfdf5bd3eb02 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2560,6 +2560,7 @@ static void stmmac_stop_all_dma(struct stmmac_priv *priv)
 {
 	u8 rx_channels_count = priv->plat->rx_queues_to_use;
 	u8 tx_channels_count = priv->plat->tx_queues_to_use;
+	u8 dma_csr_ch = max(rx_channels_count, tx_channels_count);
 	u8 chan;
 
 	for (chan = 0; chan < rx_channels_count; chan++)
@@ -2567,6 +2568,9 @@ static void stmmac_stop_all_dma(struct stmmac_priv *priv)
 
 	for (chan = 0; chan < tx_channels_count; chan++)
 		stmmac_stop_tx_dma(priv, chan);
+
+	for (chan = 0; chan < dma_csr_ch; chan++)
+		stmmac_deinit_chan(priv, priv->ioaddr, chan);
 }
 
 /**
-- 
2.53.0



