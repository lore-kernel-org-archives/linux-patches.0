Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5077218B46D;
	Tue, 10 Sep 2024 10:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964223; cv=none; b=gxo4p6F0D/4/gYa1pwNsdkB10j+YZ/Tnoax4oAt6UZ7ss86va6hqd5eS0FevKi/50QFE8akUdunpY1LynxvsdHCLt+cSa78KP/3MG0rCfI4rerbLN6P+YhWusIuB7YVEp8WSOHcIPSw2A27e7ioAHDl7Xskh5SSAm2QHPOujX1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964223; c=relaxed/simple;
	bh=zhGpm1+cjX97VglQRnTvcV7s8Qq9SY1KKnTqG2C1Vlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ahk+xFmo/45WmduxiKOIFDK6OOCySGenCbQgCc5RxQcdTM9TePPUaVAd41fly+lWjU/JhiSKn8GyB0LfF6OBpUy3eQOL91nOWhdkzqHPJYRnAZKmcGIeLMdJvLz1JIChpbBwHbLsZh4g7qVP67VQ7uPq2NUBk5GZCigmVreybsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBk3y+Gg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBk3y+Gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9574C4CEC3;
	Tue, 10 Sep 2024 10:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964223;
	bh=zhGpm1+cjX97VglQRnTvcV7s8Qq9SY1KKnTqG2C1Vlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBk3y+GgdZTVIqUkCexewXEODXAU6Hyf7+Dy0Zjo70dpKZHnglcsn7P1nOUN6x2w6
	 HCkDXRDx1AwDt3rqwTffBPuYj5CFhBaaH1/U2SJ9ox5zI0yafiubsOsQ68jG8DADU7
	 +fQTBSeGS4cNck4IGIXhraU/V/Aks66O/6QR8CK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Jocic <martin.jocic@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/269] can: kvaser_pciefd: Move reset of DMA RX buffers to the end of the ISR
Date: Tue, 10 Sep 2024 11:31:36 +0200
Message-ID: <20240910092612.078058310@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Martin Jocic <martin.jocic@kvaser.com>

[ Upstream commit 48f827d4f48f5243e37b9240029ce3f456d1f490 ]

A new interrupt is triggered by resetting the DMA RX buffers.
Since MSI interrupts are faster than legacy interrupts, the reset
of the DMA buffers must be moved to the very end of the ISR,
otherwise a new MSI interrupt will be masked by the current one.

Signed-off-by: Martin Jocic <martin.jocic@kvaser.com>
Link: https://lore.kernel.org/all/20240620181320.235465-2-martin.jocic@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: dd885d90c047 ("can: kvaser_pciefd: Use a single write when releasing RX buffers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index a933b4c8165c..96b6e3d13e67 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1580,23 +1580,15 @@ static int kvaser_pciefd_read_buffer(struct kvaser_pciefd *pcie, int dma_buf)
 	return res;
 }
 
-static void kvaser_pciefd_receive_irq(struct kvaser_pciefd *pcie)
+static u32 kvaser_pciefd_receive_irq(struct kvaser_pciefd *pcie)
 {
 	u32 irq = ioread32(KVASER_PCIEFD_SRB_ADDR(pcie) + KVASER_PCIEFD_SRB_IRQ_REG);
 
-	if (irq & KVASER_PCIEFD_SRB_IRQ_DPD0) {
+	if (irq & KVASER_PCIEFD_SRB_IRQ_DPD0)
 		kvaser_pciefd_read_buffer(pcie, 0);
-		/* Reset DMA buffer 0 */
-		iowrite32(KVASER_PCIEFD_SRB_CMD_RDB0,
-			  KVASER_PCIEFD_SRB_ADDR(pcie) + KVASER_PCIEFD_SRB_CMD_REG);
-	}
 
-	if (irq & KVASER_PCIEFD_SRB_IRQ_DPD1) {
+	if (irq & KVASER_PCIEFD_SRB_IRQ_DPD1)
 		kvaser_pciefd_read_buffer(pcie, 1);
-		/* Reset DMA buffer 1 */
-		iowrite32(KVASER_PCIEFD_SRB_CMD_RDB1,
-			  KVASER_PCIEFD_SRB_ADDR(pcie) + KVASER_PCIEFD_SRB_CMD_REG);
-	}
 
 	if (irq & KVASER_PCIEFD_SRB_IRQ_DOF0 ||
 	    irq & KVASER_PCIEFD_SRB_IRQ_DOF1 ||
@@ -1605,6 +1597,7 @@ static void kvaser_pciefd_receive_irq(struct kvaser_pciefd *pcie)
 		dev_err(&pcie->pci->dev, "DMA IRQ error 0x%08X\n", irq);
 
 	iowrite32(irq, KVASER_PCIEFD_SRB_ADDR(pcie) + KVASER_PCIEFD_SRB_IRQ_REG);
+	return irq;
 }
 
 static void kvaser_pciefd_transmit_irq(struct kvaser_pciefd_can *can)
@@ -1632,19 +1625,32 @@ static irqreturn_t kvaser_pciefd_irq_handler(int irq, void *dev)
 	struct kvaser_pciefd *pcie = (struct kvaser_pciefd *)dev;
 	const struct kvaser_pciefd_irq_mask *irq_mask = pcie->driver_data->irq_mask;
 	u32 pci_irq = ioread32(KVASER_PCIEFD_PCI_IRQ_ADDR(pcie));
+	u32 srb_irq = 0;
 	int i;
 
 	if (!(pci_irq & irq_mask->all))
 		return IRQ_NONE;
 
 	if (pci_irq & irq_mask->kcan_rx0)
-		kvaser_pciefd_receive_irq(pcie);
+		srb_irq = kvaser_pciefd_receive_irq(pcie);
 
 	for (i = 0; i < pcie->nr_channels; i++) {
 		if (pci_irq & irq_mask->kcan_tx[i])
 			kvaser_pciefd_transmit_irq(pcie->can[i]);
 	}
 
+	if (srb_irq & KVASER_PCIEFD_SRB_IRQ_DPD0) {
+		/* Reset DMA buffer 0, may trigger new interrupt */
+		iowrite32(KVASER_PCIEFD_SRB_CMD_RDB0,
+			  KVASER_PCIEFD_SRB_ADDR(pcie) + KVASER_PCIEFD_SRB_CMD_REG);
+	}
+
+	if (srb_irq & KVASER_PCIEFD_SRB_IRQ_DPD1) {
+		/* Reset DMA buffer 1, may trigger new interrupt */
+		iowrite32(KVASER_PCIEFD_SRB_CMD_RDB1,
+			  KVASER_PCIEFD_SRB_ADDR(pcie) + KVASER_PCIEFD_SRB_CMD_REG);
+	}
+
 	return IRQ_HANDLED;
 }
 
-- 
2.43.0



