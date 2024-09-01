Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0B81C68C;
	Sun,  1 Sep 2024 16:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208850; cv=none; b=AK0R8Ivx0aqGRhSLr7btxqV7OcQhbGUT7Y8L2yzWE//ScbcxiVFVp9LQtj1PqKTSDNCLtVBenyfRdxiNfJUrqzNMJMYEn7s7JtMOXFfk4hahvurZ5/Z/kwOl330SdFvzaqqDFMB6qE+ef3b9865s1Y3X9/968X9mJuB2I5lY190=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208850; c=relaxed/simple;
	bh=4Hv8NubanigQLE6LQEnBB96RRjUbHzLetrdYXEvQkdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLDG3jNosOCi+moxf8zxsR2JyxbH7/r+qNnGz7B2/VzeOQuW0YqCBUaMK+ZLswapGsDDecWnF1LHibzdF2rutQKsp0gaGZCFSYuIUlXLfXxXY6pTDJFPnOREcps2cwBm0V6+99d4qzNI2OoKK4iJS/DkF1IdXR310V8wbo2233c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL/QzCvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL/QzCvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6FBC4CEC3;
	Sun,  1 Sep 2024 16:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208850;
	bh=4Hv8NubanigQLE6LQEnBB96RRjUbHzLetrdYXEvQkdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eL/QzCvB7vVUPexWuLr9l/T/VosUuxcYqXndKKCk1VPmBbRxeYhun5fwEdZgRM4ga
	 LXk8AC1knuUDT66IYrUnfZiFfP1IpUe7R/uDU3uSjxGD/FV2prXWJPj8isZlis8zU5
	 +I+OPifZOvDExtqEVL9hx2WQxgm6r3XtnwIT014Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/134] net: axienet: Autodetect 64-bit DMA capability
Date: Sun,  1 Sep 2024 18:16:12 +0200
Message-ID: <20240901160811.092353197@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit f735c40ed93ccaeb52d026def47ac1a423df7133 ]

When newer revisions of the Axienet IP are configured for a 64-bit bus,
we *need* to write to the MSB part of the an address registers,
otherwise the IP won't recognise this as a DMA start condition.
This is even true when the actual DMA address comes from the lower 4 GB.

To autodetect this configuration, at probe time we write all 1's to such
an MSB register, and see if any bits stick. If this is configured for a
32-bit bus, those MSB registers are RES0, so reading back 0 indicates
that no MSB writes are necessary.
On the other hands reading anything other than 0 indicated the need to
write the MSB registers, so we set the respective flag.

The actual DMA mask stays at 32-bit for now. To help bisecting, a
separate patch will enable allocations from higher addresses.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9ff2f816e2aa ("net: axienet: Fix register defines comment description")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  1 +
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 26 +++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 84c4c3655516a..fbaf3c987d9c1 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -161,6 +161,7 @@
 #define XAE_FCC_OFFSET		0x0000040C /* Flow Control Configuration */
 #define XAE_EMMC_OFFSET		0x00000410 /* EMAC mode configuration */
 #define XAE_PHYC_OFFSET		0x00000414 /* RGMII/SGMII configuration */
+#define XAE_ID_OFFSET		0x000004F8 /* Identification register */
 #define XAE_MDIO_MC_OFFSET	0x00000500 /* MII Management Config */
 #define XAE_MDIO_MCR_OFFSET	0x00000504 /* MII Management Control */
 #define XAE_MDIO_MWD_OFFSET	0x00000508 /* MII Management Write Data */
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 5440f39c5760d..1156719210cdb 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -152,6 +152,9 @@ static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
 				 dma_addr_t addr)
 {
 	axienet_dma_out32(lp, reg, lower_32_bits(addr));
+
+	if (lp->features & XAE_FEATURE_DMA_64BIT)
+		axienet_dma_out32(lp, reg + 4, upper_32_bits(addr));
 }
 
 static void desc_set_phys_addr(struct axienet_local *lp, dma_addr_t addr,
@@ -1954,6 +1957,29 @@ static int axienet_probe(struct platform_device *pdev)
 		goto free_netdev;
 	}
 
+	/* Autodetect the need for 64-bit DMA pointers.
+	 * When the IP is configured for a bus width bigger than 32 bits,
+	 * writing the MSB registers is mandatory, even if they are all 0.
+	 * We can detect this case by writing all 1's to one such register
+	 * and see if that sticks: when the IP is configured for 32 bits
+	 * only, those registers are RES0.
+	 * Those MSB registers were introduced in IP v7.1, which we check first.
+	 */
+	if ((axienet_ior(lp, XAE_ID_OFFSET) >> 24) >= 0x9) {
+		void __iomem *desc = lp->dma_regs + XAXIDMA_TX_CDESC_OFFSET + 4;
+
+		iowrite32(0x0, desc);
+		if (ioread32(desc) == 0) {	/* sanity check */
+			iowrite32(0xffffffff, desc);
+			if (ioread32(desc) > 0) {
+				lp->features |= XAE_FEATURE_DMA_64BIT;
+				dev_info(&pdev->dev,
+					 "autodetected 64-bit DMA range\n");
+			}
+			iowrite32(0x0, desc);
+		}
+	}
+
 	/* Check for Ethernet core IRQ (optional) */
 	if (lp->eth_irq <= 0)
 		dev_info(&pdev->dev, "Ethernet core IRQ not defined\n");
-- 
2.43.0



