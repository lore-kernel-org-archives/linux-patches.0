Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA62930567C;
	Thu, 30 Jul 2026 15:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425251; cv=none; b=H+WidcHBKavOYdHISegbl1shLL4ajD8bU+whJFAsS8CISUkuWI6FVmw4XUqRgcTvFZ2AMMCPUw9sA3uR2hJnBcbEQPFQdCtHCF2s5/cdYPwN6hxrA2BAFu6IwIjmkXTIyWuTJNXF401sXtDL7HKy19RDHwfyIMfNT21n3qOxtC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425251; c=relaxed/simple;
	bh=UXDt8Iehw1M0dwosAO8WE/oNl7fjU56ibWcinkD4cQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcL8Zcq/4hceNXyMgfzOaPAeh/Bk5/qok1V+2rvrQQz8sW+bBD3mFJBRNmctwx3AhUYSIRGBrNtcQtzrSj2lDAeGOJgaN+rC0iu8zSc+DC9g16B+oQdmQxl3mQ4GG87PA0yu6/DiFPVqeHgi/hNjI31asfj5Kd03IXQahaEFADE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZW2YaTnx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZW2YaTnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0CE1F000E9;
	Thu, 30 Jul 2026 15:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425246;
	bh=x4W5YfRbOFbTzwWJBFvIsJtjn+IVws/CtvrU7CpLCYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZW2YaTnx74Dtls3VRM9xdESkWMzg/cstDru4WWYcz9vNvJVPXDTXNxXioIGLQ7RVq
	 j0EJNSDfJZmX+sIfieFuCXZIhNmVZ3pHbHi6ynTZ6xPwXPDbSZpKMbeOkHK2z2/iXi
	 OzMbYrVY4xUAZjG0bfLC0ur1d05/E+LO+RgETPMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 673/675] net: stmmac: fix dwmac4 transmit performance regression
Date: Thu, 30 Jul 2026 16:16:43 +0200
Message-ID: <20260730141459.466339310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 5ccde4c81e843ab6b3a324c8e2aa96d9b1270a1a upstream.

dwmac4's transmit performance dropped by a factor of four due to an
incorrect assumption about which definitions are for what. This
highlights the need for sane register macros.

Commit 8409495bf6c9 ("net: stmmac: cores: remove many xxx_SHIFT
definitions") changed the way the txpbl value is merged into the
register:

        value = readl(ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, chan));
-       value = value | (txpbl << DMA_BUS_MODE_PBL_SHIFT);
+       value = value | FIELD_PREP(DMA_BUS_MODE_PBL, txpbl);

With the following in the header file:

 #define DMA_BUS_MODE_PBL               BIT(16)
-#define DMA_BUS_MODE_PBL_SHIFT         16

The assumption here was that DMA_BUS_MODE_PBL was the mask for
DMA_BUS_MODE_PBL_SHIFT, but this turns out not to be the case.

The field is actually six bits wide, buts 21:16, and is called
TXPBL.

What's even more confusing is, there turns out to be a PBLX8
single bit in the DMA_CHAN_CONTROL register (0x1100 for channel 0),
and DMA_BUS_MODE_PBL seems to be used for that. However, this bit
et.al. was listed under a comment "/* DMA SYS Bus Mode bitmap */"
which is for register 0x1004.

Fix this up by adding an appropriately named field definition under
the DMA_CHAN_TX_CONTROL() register address definition.

Move the RPBL mask definition under DMA_CHAN_RX_CONTROL(), correctly
renaming it as well.

Also move the PBL bit definition under DMA_CHAN_CONTROL(), correctly
renaming it.

This removes confusion over the PBL fields.

Fixes: 8409495bf6c9 ("net: stmmac: cores: remove many xxx_SHIFT definitions")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Bisected-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://lore.kernel.org/51859704-57fd-4913-b09d-9ac58a57f185@bootlin.com
Tested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/E1vgY1k-00000003vOC-0Z1H@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c |    8 ++++----
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h |    7 ++++---
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -76,7 +76,7 @@ static void dwmac4_dma_init_rx_chan(stru
 	u32 rxpbl = dma_cfg->rxpbl ?: dma_cfg->pbl;
 
 	value = readl(ioaddr + DMA_CHAN_RX_CONTROL(dwmac4_addrs, chan));
-	value = value | FIELD_PREP(DMA_BUS_MODE_RPBL_MASK, rxpbl);
+	value = value | FIELD_PREP(DMA_CHAN_RX_CTRL_RXPBL_MASK, rxpbl);
 	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(dwmac4_addrs, chan));
 
 	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) && likely(dma_cfg->eame))
@@ -97,7 +97,7 @@ static void dwmac4_dma_init_tx_chan(stru
 	u32 txpbl = dma_cfg->txpbl ?: dma_cfg->pbl;
 
 	value = readl(ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, chan));
-	value = value | FIELD_PREP(DMA_BUS_MODE_PBL, txpbl);
+	value = value | FIELD_PREP(DMA_CHAN_TX_CTRL_TXPBL_MASK, txpbl);
 
 	/* Enable OSP to get best performance */
 	value |= DMA_CONTROL_OSP;
@@ -122,7 +122,7 @@ static void dwmac4_dma_init_channel(stru
 	/* common channel control register config */
 	value = readl(ioaddr + DMA_CHAN_CONTROL(dwmac4_addrs, chan));
 	if (dma_cfg->pblx8)
-		value = value | DMA_BUS_MODE_PBL;
+		value = value | DMA_CHAN_CTRL_PBLX8;
 	writel(value, ioaddr + DMA_CHAN_CONTROL(dwmac4_addrs, chan));
 
 	/* Mask interrupts by writing to CSR7 */
@@ -140,7 +140,7 @@ static void dwmac410_dma_init_channel(st
 	/* common channel control register config */
 	value = readl(ioaddr + DMA_CHAN_CONTROL(dwmac4_addrs, chan));
 	if (dma_cfg->pblx8)
-		value = value | DMA_BUS_MODE_PBL;
+		value = value | DMA_CHAN_CTRL_PBLX8;
 
 	writel(value, ioaddr + DMA_CHAN_CONTROL(dwmac4_addrs, chan));
 
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
@@ -32,8 +32,6 @@
 
 /* DMA SYS Bus Mode bitmap */
 #define DMA_BUS_MODE_SPH		BIT(24)
-#define DMA_BUS_MODE_PBL		BIT(16)
-#define DMA_BUS_MODE_RPBL_MASK		GENMASK(21, 16)
 #define DMA_BUS_MODE_MB			BIT(14)
 #define DMA_BUS_MODE_FB			BIT(0)
 
@@ -126,18 +124,21 @@ static inline u32 dma_chanx_base_addr(co
 #define DMA_CHAN_STATUS(addrs, x)	(dma_chanx_base_addr(addrs, x) + 0x60)
 
 /* DMA Control X */
+#define DMA_CHAN_CTRL_PBLX8		BIT(16)
 #define DMA_CONTROL_SPH			BIT(24)
 #define DMA_CONTROL_MSS_MASK		GENMASK(13, 0)
 
 /* DMA Tx Channel X Control register defines */
 #define DMA_CONTROL_EDSE		BIT(28)
+#define DMA_CHAN_TX_CTRL_TXPBL_MASK	GENMASK(21, 16)
 #define DMA_CONTROL_TSE			BIT(12)
 #define DMA_CONTROL_OSP			BIT(4)
 #define DMA_CONTROL_ST			BIT(0)
 
 /* DMA Rx Channel X Control register defines */
-#define DMA_CONTROL_SR			BIT(0)
+#define DMA_CHAN_RX_CTRL_RXPBL_MASK	GENMASK(21, 16)
 #define DMA_RBSZ_MASK			GENMASK(14, 1)
+#define DMA_CONTROL_SR			BIT(0)
 
 /* Interrupt status per channel */
 #define DMA_CHAN_STATUS_REB		GENMASK(21, 19)


