Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF2D13AD09;
	Tue, 10 Sep 2024 09:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961805; cv=none; b=aBXTYb0zyTdqYWu+/YVHONjPi1TAqeE4ZfsnyLTU9/TgiKY2dKoIaScCSiqsb2NJ/AHiK4fjCAkT6oocHRFvy2nE5nkA1PjgqYkiqRunf+JpadG7jRSNbMcN9SeE1ShpZCFFGTYMA5+IckX0IpR+F+L0Zrqc4WQ8bj45pVxIED4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961805; c=relaxed/simple;
	bh=kPMAVadE91au/PlojT9MYUMMOGbR93IDVmg9TPFP5YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6Q+LA9Ug/fLA/omMWxjWjHJv66RVMTVikdRLsH8WkA7LNHIwU0Ieoc3JR8kWTLE+j13fkzj5OTxhCn6g1dtc0Ww8K4e3EtXkeiJWHxM4NAf7Yn7cKmx2ABdKCD0JKnANC2wnnbNkEXq0H65GgDtemtlM5z07c7h3BSmhpM//kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOuKTDSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOuKTDSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0532C4CEC3;
	Tue, 10 Sep 2024 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961805;
	bh=kPMAVadE91au/PlojT9MYUMMOGbR93IDVmg9TPFP5YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOuKTDSRSt2H7NkE6vsBOsA+eC4J/iZnLbq/5dp0WQuE0HXodsYPZEB+VDDCEEA9P
	 ucSyG+jF+z3mobx5f5yxtExr+91LOxXTGV1awQOmhgTl+v9+EMFoAYxFvdSmtBzjda
	 ddtlGd3tfRSuaiRGc4G8IHkqY3d/YX5bNtKnqwYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Jocic <martin.jocic@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 168/375] can: kvaser_pciefd: Move reset of DMA RX buffers to the end of the ISR
Date: Tue, 10 Sep 2024 11:29:25 +0200
Message-ID: <20240910092628.125224227@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index a026ea2f5b35..cc39befc9290 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1640,23 +1640,15 @@ static int kvaser_pciefd_read_buffer(struct kvaser_pciefd *pcie, int dma_buf)
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
@@ -1665,6 +1657,7 @@ static void kvaser_pciefd_receive_irq(struct kvaser_pciefd *pcie)
 		dev_err(&pcie->pci->dev, "DMA IRQ error 0x%08X\n", irq);
 
 	iowrite32(irq, KVASER_PCIEFD_SRB_ADDR(pcie) + KVASER_PCIEFD_SRB_IRQ_REG);
+	return irq;
 }
 
 static void kvaser_pciefd_transmit_irq(struct kvaser_pciefd_can *can)
@@ -1692,19 +1685,32 @@ static irqreturn_t kvaser_pciefd_irq_handler(int irq, void *dev)
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



