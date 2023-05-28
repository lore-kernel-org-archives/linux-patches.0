Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2317611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED3EC433EF;
	Sun, 28 May 2023 19:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303069;
	bh=jNLVgv27fS9XcjCO4LXkTZ4eZTRMZG3xxJNE5RCdZwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFqko0okKSvrN4KsICfESMQa/LTZHPV7yVgOSxvN4upDKJwaAc0kEK/gaPiiZMBsK
	 NenkJ22dX9nA84R6ikCd9VGo2Hift7tyQROLQzy+hjgzsTCk18saOIIg0jOEihNJXa
	 m+zTWI8pRl9QiIJCJ0LHqI1Clp84aVHsbBieiZvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 141/211] can: kvaser_pciefd: Do not send EFLUSH command on TFD interrupt
Date: Sun, 28 May 2023 20:11:02 +0100
Message-Id: <20230528190847.018105197@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jimmy Assarsson <extja@kvaser.com>

commit 262d7a52ba27525e3c1203230c9f0524e48bbb34 upstream.

Under certain circumstances we send two EFLUSH commands, resulting in two
EFLUSH ack packets, while only expecting a single EFLUSH ack.
This can cause the driver Tx flush completion to get out of sync.

To avoid this problem, don't enable the "Transmit buffer flush done" (TFD)
interrupt and remove the code handling it.
Now we only send EFLUSH command after receiving status packet with
"Init detected" (IDET) bit set.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20230516134318.104279-6-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/kvaser_pciefd.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -533,7 +533,7 @@ static int kvaser_pciefd_set_tx_irq(stru
 	      KVASER_PCIEFD_KCAN_IRQ_TOF | KVASER_PCIEFD_KCAN_IRQ_ABD |
 	      KVASER_PCIEFD_KCAN_IRQ_TAE | KVASER_PCIEFD_KCAN_IRQ_TAL |
 	      KVASER_PCIEFD_KCAN_IRQ_FDIC | KVASER_PCIEFD_KCAN_IRQ_BPP |
-	      KVASER_PCIEFD_KCAN_IRQ_TAR | KVASER_PCIEFD_KCAN_IRQ_TFD;
+	      KVASER_PCIEFD_KCAN_IRQ_TAR;
 
 	iowrite32(msk, can->reg_base + KVASER_PCIEFD_KCAN_IEN_REG);
 
@@ -581,7 +581,7 @@ static void kvaser_pciefd_start_controll
 
 	spin_lock_irqsave(&can->lock, irq);
 	iowrite32(-1, can->reg_base + KVASER_PCIEFD_KCAN_IRQ_REG);
-	iowrite32(KVASER_PCIEFD_KCAN_IRQ_ABD | KVASER_PCIEFD_KCAN_IRQ_TFD,
+	iowrite32(KVASER_PCIEFD_KCAN_IRQ_ABD,
 		  can->reg_base + KVASER_PCIEFD_KCAN_IEN_REG);
 
 	status = ioread32(can->reg_base + KVASER_PCIEFD_KCAN_STAT_REG);
@@ -624,7 +624,7 @@ static int kvaser_pciefd_bus_on(struct k
 	iowrite32(0, can->reg_base + KVASER_PCIEFD_KCAN_IEN_REG);
 	iowrite32(-1, can->reg_base + KVASER_PCIEFD_KCAN_IRQ_REG);
 
-	iowrite32(KVASER_PCIEFD_KCAN_IRQ_ABD | KVASER_PCIEFD_KCAN_IRQ_TFD,
+	iowrite32(KVASER_PCIEFD_KCAN_IRQ_ABD,
 		  can->reg_base + KVASER_PCIEFD_KCAN_IEN_REG);
 
 	mode = ioread32(can->reg_base + KVASER_PCIEFD_KCAN_MODE_REG);
@@ -1011,8 +1011,7 @@ static int kvaser_pciefd_setup_can_ctrls
 		SET_NETDEV_DEV(netdev, &pcie->pci->dev);
 
 		iowrite32(-1, can->reg_base + KVASER_PCIEFD_KCAN_IRQ_REG);
-		iowrite32(KVASER_PCIEFD_KCAN_IRQ_ABD |
-			  KVASER_PCIEFD_KCAN_IRQ_TFD,
+		iowrite32(KVASER_PCIEFD_KCAN_IRQ_ABD,
 			  can->reg_base + KVASER_PCIEFD_KCAN_IEN_REG);
 
 		pcie->can[i] = can;
@@ -1441,9 +1440,6 @@ static int kvaser_pciefd_handle_status_p
 		cmd = KVASER_PCIEFD_KCAN_CMD_AT;
 		cmd |= ++can->cmd_seq << KVASER_PCIEFD_KCAN_CMD_SEQ_SHIFT;
 		iowrite32(cmd, can->reg_base + KVASER_PCIEFD_KCAN_CMD_REG);
-
-		iowrite32(KVASER_PCIEFD_KCAN_IRQ_TFD,
-			  can->reg_base + KVASER_PCIEFD_KCAN_IEN_REG);
 	} else if (p->header[0] & KVASER_PCIEFD_SPACK_IDET &&
 		   p->header[0] & KVASER_PCIEFD_SPACK_IRM &&
 		   cmdseq == (p->header[1] & KVASER_PCIEFD_PACKET_SEQ_MSK) &&
@@ -1732,15 +1728,6 @@ static int kvaser_pciefd_transmit_irq(st
 	if (irq & KVASER_PCIEFD_KCAN_IRQ_TOF)
 		netdev_err(can->can.dev, "Tx FIFO overflow\n");
 
-	if (irq & KVASER_PCIEFD_KCAN_IRQ_TFD) {
-		u8 count = ioread32(can->reg_base +
-				    KVASER_PCIEFD_KCAN_TX_NPACKETS_REG) & 0xff;
-
-		if (count == 0)
-			iowrite32(KVASER_PCIEFD_KCAN_CTRL_EFLUSH,
-				  can->reg_base + KVASER_PCIEFD_KCAN_CTRL_REG);
-	}
-
 	if (irq & KVASER_PCIEFD_KCAN_IRQ_BPP)
 		netdev_err(can->can.dev,
 			   "Fail to change bittiming, when not in reset mode\n");


