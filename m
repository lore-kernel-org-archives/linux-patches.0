Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E36611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879C2C433D2;
	Sun, 28 May 2023 19:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303064;
	bh=g63N/8IHgm2wznptnbX0o8k72ZjzpAYpVXhLBN+UQ40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9UheyqKCVhbnSMfkxk9dQtbhnVxjY9TwX06Mqj0ICzgN0uLl7lP0XOJmpUaNz9c4
	 D72OTYg9Sz2IdBt60N+aOdgUu2wKoDmqpVyMt7Hamx8pJYjUal/t7kg98GChccQAhk
	 gbsIkdIxMc0MJnI5/ZTAGB+9J4ME9ueJ5thErbh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 139/211] can: kvaser_pciefd: Empty SRB buffer in probe
Date: Sun, 28 May 2023 20:11:00 +0100
Message-Id: <20230528190846.972339781@linuxfoundation.org>
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

commit c589557dd1426f5adf90c7a919d4fde5a3e4ef64 upstream.

Empty the "Shared receive buffer" (SRB) in probe, to assure we start in a
known state, and don't process any irrelevant packets.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20230516134318.104279-5-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/kvaser_pciefd.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -70,10 +70,12 @@ MODULE_DESCRIPTION("CAN driver for Kvase
 #define KVASER_PCIEFD_SYSID_BUILD_REG (KVASER_PCIEFD_SYSID_BASE + 0x14)
 /* Shared receive buffer registers */
 #define KVASER_PCIEFD_SRB_BASE 0x1f200
+#define KVASER_PCIEFD_SRB_FIFO_LAST_REG (KVASER_PCIEFD_SRB_BASE + 0x1f4)
 #define KVASER_PCIEFD_SRB_CMD_REG (KVASER_PCIEFD_SRB_BASE + 0x200)
 #define KVASER_PCIEFD_SRB_IEN_REG (KVASER_PCIEFD_SRB_BASE + 0x204)
 #define KVASER_PCIEFD_SRB_IRQ_REG (KVASER_PCIEFD_SRB_BASE + 0x20c)
 #define KVASER_PCIEFD_SRB_STAT_REG (KVASER_PCIEFD_SRB_BASE + 0x210)
+#define KVASER_PCIEFD_SRB_RX_NR_PACKETS_REG (KVASER_PCIEFD_SRB_BASE + 0x214)
 #define KVASER_PCIEFD_SRB_CTRL_REG (KVASER_PCIEFD_SRB_BASE + 0x218)
 /* EPCS flash controller registers */
 #define KVASER_PCIEFD_SPI_BASE 0x1fc00
@@ -110,6 +112,9 @@ MODULE_DESCRIPTION("CAN driver for Kvase
 /* DMA support */
 #define KVASER_PCIEFD_SRB_STAT_DMA BIT(24)
 
+/* SRB current packet level */
+#define KVASER_PCIEFD_SRB_RX_NR_PACKETS_MASK 0xff
+
 /* DMA Enable */
 #define KVASER_PCIEFD_SRB_CTRL_DMA_ENABLE BIT(0)
 
@@ -1055,6 +1060,7 @@ static int kvaser_pciefd_setup_dma(struc
 {
 	int i;
 	u32 srb_status;
+	u32 srb_packet_count;
 	dma_addr_t dma_addr[KVASER_PCIEFD_DMA_COUNT];
 
 	/* Disable the DMA */
@@ -1082,6 +1088,15 @@ static int kvaser_pciefd_setup_dma(struc
 		  KVASER_PCIEFD_SRB_CMD_RDB1,
 		  pcie->reg_base + KVASER_PCIEFD_SRB_CMD_REG);
 
+	/* Empty Rx FIFO */
+	srb_packet_count = ioread32(pcie->reg_base + KVASER_PCIEFD_SRB_RX_NR_PACKETS_REG) &
+			   KVASER_PCIEFD_SRB_RX_NR_PACKETS_MASK;
+	while (srb_packet_count) {
+		/* Drop current packet in FIFO */
+		ioread32(pcie->reg_base + KVASER_PCIEFD_SRB_FIFO_LAST_REG);
+		srb_packet_count--;
+	}
+
 	srb_status = ioread32(pcie->reg_base + KVASER_PCIEFD_SRB_STAT_REG);
 	if (!(srb_status & KVASER_PCIEFD_SRB_STAT_DI)) {
 		dev_err(&pcie->pci->dev, "DMA not idle before enabling\n");


