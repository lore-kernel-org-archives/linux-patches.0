Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600EA187325;
	Tue, 10 Sep 2024 09:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961808; cv=none; b=qTIuaunNKKfPvRnP7Cg/eWpk9Hz43DgaWb/xgzpEvA+hN7+lmR/0DSDx6keCOWFwmisitk310TX9NHazFmqoGn6QMUV0ofx8riQ6iN8pj+EqEpO/okGdVL5VsH3602rGByWYdkJffosaIbuknV1wUUnNZpg3cpS5BMUoC/VZcE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961808; c=relaxed/simple;
	bh=+zXP7E/XeGkINuNMvN3biACxhk70o3ZEWgdMNy2PPHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gE1kZt/2+yf1fzHpy7ZO6EnLnAU6/rWX+hLjN/claPTVRZwq+cGlMbzvHjqeeH4pfmSAOxzX/RDd6joKK6Z5myovxBlqjnSSJeyBkxwgq/ViU+ezmkJlpRqxWyfrN7oQlA2YMu/3amUa5IjhMEM1/T5xo8E/ZbqiC+SW19YVtiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTdew3j9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTdew3j9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E5EC4CEC3;
	Tue, 10 Sep 2024 09:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961808;
	bh=+zXP7E/XeGkINuNMvN3biACxhk70o3ZEWgdMNy2PPHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTdew3j9su1J79EWc7bKir6cgCS1YwKhygek1N20IuAet7BX21b4m5joABKiu1MBH
	 I7vbVvgNLcg8pPvhqZNbOi/eMPwLskswEK7TB2N7uJKWXwxAGjxmx3YBrU3xWaApc6
	 GaXOmWTwXEZaxmTwGlsdQboEP1XpTT6x56GNa/Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Jocic <martin.jocic@kvaser.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 169/375] can: kvaser_pciefd: Use a single write when releasing RX buffers
Date: Tue, 10 Sep 2024 11:29:26 +0200
Message-ID: <20240910092628.153294533@linuxfoundation.org>
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
index cc39befc9290..ab15a2ae8a20 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1686,6 +1686,7 @@ static irqreturn_t kvaser_pciefd_irq_handler(int irq, void *dev)
 	const struct kvaser_pciefd_irq_mask *irq_mask = pcie->driver_data->irq_mask;
 	u32 pci_irq = ioread32(KVASER_PCIEFD_PCI_IRQ_ADDR(pcie));
 	u32 srb_irq = 0;
+	u32 srb_release = 0;
 	int i;
 
 	if (!(pci_irq & irq_mask->all))
@@ -1699,17 +1700,14 @@ static irqreturn_t kvaser_pciefd_irq_handler(int irq, void *dev)
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



