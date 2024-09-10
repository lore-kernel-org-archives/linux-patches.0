Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5513B144D1A;
	Tue, 10 Sep 2024 10:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964226; cv=none; b=EiNWumy1epnoiQoTLzP64TCWFFdIP9trLhBhu5Nt0NVZ3OzfoFfeTE+yzeXHOrurPEupfNca+lNDIrcmVCmmXXip2WHbgZfm9HwrGFxJINH3aVnNmcg9gJac5I2IugOjqoS0/JnD6vFPBq02agAEu26R2vytHZm3qhuwD2N/uEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964226; c=relaxed/simple;
	bh=CqRQTBv3MphYCPg8vygHMuV21dAb3Vec33a8nh1xJwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWhUicfxWdEqz3z276m75mUs6XkWnfNgTi504f6wXEykcKtkxuNoWiEBDwSx9i9NWDuR7NV3eCOzfKL737IcyBPtoD9o3U6cmX1LUA8rrBVGeBLM1iI+28h3Vodtf/z44djvsANIpXPl8ac6DGJhsorq60gbuBR9dHMRXvz5nss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRl1QoU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRl1QoU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4C1C4CEC3;
	Tue, 10 Sep 2024 10:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964226;
	bh=CqRQTBv3MphYCPg8vygHMuV21dAb3Vec33a8nh1xJwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRl1QoU6dMTN4pd42+dVzwQejS5TYTdlsPwxYlaBUQAmluPjk9NlP0OWKlWy2PtDv
	 RcRY2reikcaoMIWiCnDn1X/zFF49EyYDWwSlmH+72zgSTgAP0qtKITjR1sdJNwyU/8
	 pYmJEri45BQT0Qfzs6x5U24npibctcqJDC1/Qr7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Jocic <martin.jocic@kvaser.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/269] can: kvaser_pciefd: Use a single write when releasing RX buffers
Date: Tue, 10 Sep 2024 11:31:37 +0200
Message-ID: <20240910092612.112181412@linuxfoundation.org>
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

[ Upstream commit dd885d90c047dbdd2773c1d33954cbd8747d81e2 ]

Kvaser's PCIe cards uses the KCAN FPGA IP block which has dual 4K
buffers for incoming messages shared by all (currently up to eight)
channels. While the driver processes messages in one buffer, new
incoming messages are stored in the other and so on.

The design of KCAN is such that a buffer must be fully read and then
released. Releasing a buffer will make the FPGA switch buffers. If the
other buffer contains at least one incoming message the FPGA will also
instantly issue a new interrupt, if not the interrupt will be issued
after receiving the first new message.

With IRQx interrupts, it takes a little time for the interrupt to
happen, enough for any previous ISR call to do it's business and
return, but MSI interrupts are way faster so this time is reduced to
almost nothing.

So with MSI, releasing the buffer HAS to be the very last action of
the ISR before returning, otherwise the new interrupt might be
"masked" by the kernel because the previous ISR call hasn't returned.
And the interrupts are edge-triggered so we cannot loose one, or the
ping-pong reading process will stop.

This is why this patch modifies the driver to use a single write to
the SRB_CMD register before returning.

Signed-off-by: Martin Jocic <martin.jocic@kvaser.com>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20240830153113.2081440-1-martin.jocic@kvaser.com
Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 96b6e3d13e67..c490b4ba065b 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1626,6 +1626,7 @@ static irqreturn_t kvaser_pciefd_irq_handler(int irq, void *dev)
 	const struct kvaser_pciefd_irq_mask *irq_mask = pcie->driver_data->irq_mask;
 	u32 pci_irq = ioread32(KVASER_PCIEFD_PCI_IRQ_ADDR(pcie));
 	u32 srb_irq = 0;
+	u32 srb_release = 0;
 	int i;
 
 	if (!(pci_irq & irq_mask->all))
@@ -1639,17 +1640,14 @@ static irqreturn_t kvaser_pciefd_irq_handler(int irq, void *dev)
 			kvaser_pciefd_transmit_irq(pcie->can[i]);
 	}
 
-	if (srb_irq & KVASER_PCIEFD_SRB_IRQ_DPD0) {
-		/* Reset DMA buffer 0, may trigger new interrupt */
-		iowrite32(KVASER_PCIEFD_SRB_CMD_RDB0,
-			  KVASER_PCIEFD_SRB_ADDR(pcie) + KVASER_PCIEFD_SRB_CMD_REG);
-	}
+	if (srb_irq & KVASER_PCIEFD_SRB_IRQ_DPD0)
+		srb_release |= KVASER_PCIEFD_SRB_CMD_RDB0;
 
-	if (srb_irq & KVASER_PCIEFD_SRB_IRQ_DPD1) {
-		/* Reset DMA buffer 1, may trigger new interrupt */
-		iowrite32(KVASER_PCIEFD_SRB_CMD_RDB1,
-			  KVASER_PCIEFD_SRB_ADDR(pcie) + KVASER_PCIEFD_SRB_CMD_REG);
-	}
+	if (srb_irq & KVASER_PCIEFD_SRB_IRQ_DPD1)
+		srb_release |= KVASER_PCIEFD_SRB_CMD_RDB1;
+
+	if (srb_release)
+		iowrite32(srb_release, KVASER_PCIEFD_SRB_ADDR(pcie) + KVASER_PCIEFD_SRB_CMD_REG);
 
 	return IRQ_HANDLED;
 }
-- 
2.43.0



