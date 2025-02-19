Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB011C5F29;
	Wed, 19 Feb 2025 08:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954928; cv=none; b=p2xSaGpwt0qMQlXWq36y7CGumNBW7NQeY4sP3wOMqLk+bT13KQv0kX7sRnpGKHuNGKc0YywRLzGYzPGsHBAk2du40I44rrnN5QsbP2TIRXtKzTu6i8DcCZt+bCKtVZuWc5PcrIESyxR84PdBtM4xDSSf8ql3H778k2gp0QPT8kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954928; c=relaxed/simple;
	bh=ZOun5kMH95zw3ONdTVLpPhrDmENKBCFC2yRqjlZ+QBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDFBmiZIGKGj43f5mDeL52E6hHajSRrNmu7Nmp7RUZJDtsCbqqzAhkBYuvdBa40pPxYnjxScBkH3k9b0fkjbNKv7k6Kyw+yWRC9GufaJTvqIdVOzYD3w/qIvjZGoNkonRyegoMZVnYSWMAmpBt7IX4zGTs8wQCRVqeUPGO0VXlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNZK2mIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNZK2mIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C92FC4CED1;
	Wed, 19 Feb 2025 08:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954928;
	bh=ZOun5kMH95zw3ONdTVLpPhrDmENKBCFC2yRqjlZ+QBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNZK2mItisb87cnk01RLxuFOPLo3kbcjGY/LQ7WwF5LDbwPiMusSFX2LLht3gOK2n
	 tMvejhIO/JeHBp204tzo9mdV2NqLG8Gr6Hkd0CkM/dyx0HgExkzIDuPPq1rKOBFDVW
	 JcZfrn6sTngku340MAXJy6AqZmtqburBSpFPUxnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rengarajan S <rengarajan.s@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/230] 8250: microchip: pci1xxxx: Add workaround for RTS bit toggle
Date: Wed, 19 Feb 2025 09:26:36 +0100
Message-ID: <20250219082604.793688813@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rengarajan S <rengarajan.s@microchip.com>

[ Upstream commit e95cb63e57381f00d9274533ea7fd0ac3bf4e5b0 ]

In the B0 revision, the RTS pin remains high due to incorrect hardware
mapping. To address this issue, enable auto-direction control with the
RTS bit in ADCL_CFG_REG. This configuration ensures that the RTS pin
goes low when the terminal is opened and high when the terminal is
closed. Additionally, we reset the step counter for Rx and Tx engines
by writing into FRAC_DIV_CFG_REG.

Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://lore.kernel.org/r/20241218094017.18290-1-rengarajan.s@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_pci1xxxx.c | 60 ++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_pci1xxxx.c b/drivers/tty/serial/8250/8250_pci1xxxx.c
index d3930bf32fe4c..f462b3d1c104c 100644
--- a/drivers/tty/serial/8250/8250_pci1xxxx.c
+++ b/drivers/tty/serial/8250/8250_pci1xxxx.c
@@ -78,6 +78,12 @@
 #define UART_TX_BYTE_FIFO			0x00
 #define UART_FIFO_CTL				0x02
 
+#define UART_MODEM_CTL_REG			0x04
+#define UART_MODEM_CTL_RTS_SET			BIT(1)
+
+#define UART_LINE_STAT_REG			0x05
+#define UART_LINE_XMIT_CHECK_MASK		GENMASK(6, 5)
+
 #define UART_ACTV_REG				0x11
 #define UART_BLOCK_SET_ACTIVE			BIT(0)
 
@@ -94,6 +100,7 @@
 #define UART_BIT_SAMPLE_CNT_16			16
 #define BAUD_CLOCK_DIV_INT_MSK			GENMASK(31, 8)
 #define ADCL_CFG_RTS_DELAY_MASK			GENMASK(11, 8)
+#define FRAC_DIV_TX_END_POINT_MASK		GENMASK(23, 20)
 
 #define UART_WAKE_REG				0x8C
 #define UART_WAKE_MASK_REG			0x90
@@ -134,6 +141,11 @@
 #define UART_BST_STAT_LSR_FRAME_ERR		0x8000000
 #define UART_BST_STAT_LSR_THRE			0x20000000
 
+#define GET_MODEM_CTL_RTS_STATUS(reg)		((reg) & UART_MODEM_CTL_RTS_SET)
+#define GET_RTS_PIN_STATUS(val)			(((val) & TIOCM_RTS) >> 1)
+#define RTS_TOGGLE_STATUS_MASK(val, reg)	(GET_MODEM_CTL_RTS_STATUS(reg) \
+						 != GET_RTS_PIN_STATUS(val))
+
 struct pci1xxxx_8250 {
 	unsigned int nr;
 	u8 dev_rev;
@@ -254,6 +266,47 @@ static void pci1xxxx_set_divisor(struct uart_port *port, unsigned int baud,
 	       port->membase + UART_BAUD_CLK_DIVISOR_REG);
 }
 
+static void pci1xxxx_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	u32 fract_div_cfg_reg;
+	u32 line_stat_reg;
+	u32 modem_ctl_reg;
+	u32 adcl_cfg_reg;
+
+	adcl_cfg_reg = readl(port->membase + ADCL_CFG_REG);
+
+	/* HW is responsible in ADCL_EN case */
+	if ((adcl_cfg_reg & (ADCL_CFG_EN | ADCL_CFG_PIN_SEL)))
+		return;
+
+	modem_ctl_reg = readl(port->membase + UART_MODEM_CTL_REG);
+
+	serial8250_do_set_mctrl(port, mctrl);
+
+	if (RTS_TOGGLE_STATUS_MASK(mctrl, modem_ctl_reg)) {
+		line_stat_reg = readl(port->membase + UART_LINE_STAT_REG);
+		if (line_stat_reg & UART_LINE_XMIT_CHECK_MASK) {
+			fract_div_cfg_reg = readl(port->membase +
+						  FRAC_DIV_CFG_REG);
+
+			writel((fract_div_cfg_reg &
+			       ~(FRAC_DIV_TX_END_POINT_MASK)),
+			       port->membase + FRAC_DIV_CFG_REG);
+
+			/* Enable ADC and set the nRTS pin */
+			writel((adcl_cfg_reg | (ADCL_CFG_EN |
+			       ADCL_CFG_PIN_SEL)),
+			       port->membase + ADCL_CFG_REG);
+
+			/* Revert to the original settings */
+			writel(adcl_cfg_reg, port->membase + ADCL_CFG_REG);
+
+			writel(fract_div_cfg_reg, port->membase +
+			       FRAC_DIV_CFG_REG);
+		}
+	}
+}
+
 static int pci1xxxx_rs485_config(struct uart_port *port,
 				 struct ktermios *termios,
 				 struct serial_rs485 *rs485)
@@ -631,9 +684,14 @@ static int pci1xxxx_setup(struct pci_dev *pdev,
 	port->port.rs485_config = pci1xxxx_rs485_config;
 	port->port.rs485_supported = pci1xxxx_rs485_supported;
 
-	/* From C0 rev Burst operation is supported */
+	/*
+	 * C0 and later revisions support Burst operation.
+	 * RTS workaround in mctrl is applicable only to B0.
+	 */
 	if (rev >= 0xC0)
 		port->port.handle_irq = pci1xxxx_handle_irq;
+	else if (rev == 0xB0)
+		port->port.set_mctrl = pci1xxxx_set_mctrl;
 
 	ret = serial8250_pci_setup_port(pdev, port, 0, PORT_OFFSET * port_idx, 0);
 	if (ret < 0)
-- 
2.39.5



