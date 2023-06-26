Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD5D13AC5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB6FC433C0;
	Mon, 26 Jun 2023 18:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804027;
	bh=WZLZwGPK51yvCqzRbMpYG/k+SwXB9cFqeyr7fRLyEG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJuBOW4U2Z1IbbGy/Qso948JqLbQP0dK8JCs4Cw/V0kpTD7J89ZvFIBpYjIaz0+bh
	 Wz/PvGwdgrG8k4IIfxcRsDHfeKuzaNNCrm18tluzPJJFSiJ8AZZtxNh/trB7+1/yuX
	 D9pH0WR2+91vo+AJGFFE30Q0v1VcCzAWaFOF23/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/170] tty: serial: fsl_lpuart: make rx_watermark configurable for different platforms
Date: Mon, 26 Jun 2023 20:09:33 +0200
Message-ID: <20230626180800.703125608@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit 34ebb26f12a84b744f43c5c4869516f122a2dfaa ]

Add rx_watermark parameter for struct lpuart_port to make the receive
watermark configurable for different platforms.
No function changed.

Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20230130064449.9564-2-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a82c3df955f8 ("tty: serial: fsl_lpuart: reduce RX watermark to 0 on LS1028A")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index dc7ac1ddbca5e..82066f17bdfb1 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -257,6 +257,7 @@ struct lpuart_port {
 	unsigned int		txfifo_size;
 	unsigned int		rxfifo_size;
 
+	u8			rx_watermark;
 	bool			lpuart_dma_tx_use;
 	bool			lpuart_dma_rx_use;
 	struct dma_chan		*dma_tx_chan;
@@ -283,38 +284,45 @@ struct lpuart_soc_data {
 	enum lpuart_type devtype;
 	char iotype;
 	u8 reg_off;
+	u8 rx_watermark;
 };
 
 static const struct lpuart_soc_data vf_data = {
 	.devtype = VF610_LPUART,
 	.iotype = UPIO_MEM,
+	.rx_watermark = 1,
 };
 
 static const struct lpuart_soc_data ls1021a_data = {
 	.devtype = LS1021A_LPUART,
 	.iotype = UPIO_MEM32BE,
+	.rx_watermark = 1,
 };
 
 static const struct lpuart_soc_data ls1028a_data = {
 	.devtype = LS1028A_LPUART,
 	.iotype = UPIO_MEM32,
+	.rx_watermark = 1,
 };
 
 static struct lpuart_soc_data imx7ulp_data = {
 	.devtype = IMX7ULP_LPUART,
 	.iotype = UPIO_MEM32,
 	.reg_off = IMX_REG_OFF,
+	.rx_watermark = 1,
 };
 
 static struct lpuart_soc_data imx8qxp_data = {
 	.devtype = IMX8QXP_LPUART,
 	.iotype = UPIO_MEM32,
 	.reg_off = IMX_REG_OFF,
+	.rx_watermark = 1,
 };
 static struct lpuart_soc_data imxrt1050_data = {
 	.devtype = IMXRT1050_LPUART,
 	.iotype = UPIO_MEM32,
 	.reg_off = IMX_REG_OFF,
+	.rx_watermark = 1,
 };
 
 static const struct of_device_id lpuart_dt_ids[] = {
@@ -1533,7 +1541,7 @@ static void lpuart_setup_watermark(struct lpuart_port *sport)
 	}
 
 	writeb(0, sport->port.membase + UARTTWFIFO);
-	writeb(1, sport->port.membase + UARTRWFIFO);
+	writeb(sport->rx_watermark, sport->port.membase + UARTRWFIFO);
 
 	/* Restore cr2 */
 	writeb(cr2_saved, sport->port.membase + UARTCR2);
@@ -1568,7 +1576,8 @@ static void lpuart32_setup_watermark(struct lpuart_port *sport)
 	lpuart32_write(&sport->port, val, UARTFIFO);
 
 	/* set the watermark */
-	val = (0x1 << UARTWATER_RXWATER_OFF) | (0x0 << UARTWATER_TXWATER_OFF);
+	val = (sport->rx_watermark << UARTWATER_RXWATER_OFF) |
+	      (0x0 << UARTWATER_TXWATER_OFF);
 	lpuart32_write(&sport->port, val, UARTWATER);
 
 	/* Restore cr2 */
@@ -2714,6 +2723,7 @@ static int lpuart_probe(struct platform_device *pdev)
 	sport->port.dev = &pdev->dev;
 	sport->port.type = PORT_LPUART;
 	sport->devtype = sdata->devtype;
+	sport->rx_watermark = sdata->rx_watermark;
 	ret = platform_get_irq(pdev, 0);
 	if (ret < 0)
 		return ret;
-- 
2.39.2



