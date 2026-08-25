Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252F1459AD7;
	Tue, 25 Aug 2026 13:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665664; cv=none; b=ZzaEtRBYE8+3Jhmg+mfHX0/E/GxPvaaKf283i+OXkeQa1nZr+NvgEc+08h519Hc8RBWD7czaIt+Swi7mk3V571RnwjxVSLuE24qeuUaDXAJGmq942JtohskU9awhrGiW8PbgzCsh5NQyt4r9jdqsiWg0FKPEbZq1ATpqqPQc1eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665664; c=relaxed/simple;
	bh=+JsGVVTRwipROfMf7o1pz2QLdEvOBl5sP2cS8lpnV4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kZh5lkJpbIwD7UC1EoZHMJIK7EI3JJiaYzZWUqbahHd8cv8z//bUVYJpdIsAq+icDqu5tp5F8SFBlDsonp/pHDfSv9E683DbdfqAPrN8C8MV4dTCv8ss/AJWnwiactCn2Hwpi0rNT5AwtY5UCAv0A+TJC8ySltW2VS6zK+ktT/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k25O2/ju; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k25O2/ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7622A1F000E9;
	Tue, 25 Aug 2026 13:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665663;
	bh=LTpzWMrT9kXg6G+r1Q8vuTMYcQ/Lps4ZcSOu1s7Dmxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k25O2/juC/APm2lurSr6/t+ejmOInQruCXJJIg0F4GdvveYh7SrDuxu5DOWRweDWK
	 AeC2E63qOWl7FCEt0O0+EHVhoMimV0pqTRImKq2H279V07obE4N3EPPoBZ4fH5dYsa
	 2J6aFvkb29/xgU+4xsEZhVjOIJYYK4JBZ97RB6DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>,
	stable <stable@kernel.org>,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 08/87] serial: qcom-geni: fix TX DMA buffer flush
Date: Tue, 25 Aug 2026 15:25:31 +0200
Message-ID: <20260825132542.149321348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Sebastian Götte <linux@jaseg.de>

[ Upstream commit e3c04834ae1ab5e9cfbe8ac54ec734aa4774249d ]

When transmit flushing a qcom-geni UART during an ongoing TX DMA, the
UART gets stuck infinitely repeating corrupted TX DMA frames.

The DMA-mode uart_ops does not provide a flush_buffer callback, so an
in-flight transfer can complete after serial core has reset the transmit
kfifo, underflowing its length and resubmitting page-sized transfers
indefinitely. Add one that stops the transfer and clears tx_remaining
and tx_queued.

The stop path was also broken: it unmapped the buffer while the serial
engine could still read it, and never reset the TX DMA state machine.
Cancel the main sequencer command first, then reset the state machine
and wait for it before unmapping. Drop the early return so a pending
mapping is also cleaned up when the main command is inactive.

The bug can be triggered from userspace with a large write immediately
followed by TCOFLUSH. A following tcdrain will hang forever. The bug was
reproduced and this fix was validated on Arduino Uno Q (QRB2210)
using /dev/ttyHS1.

Assisted-by: Claude:claude-5-opus Codex:gpt-5
Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
Fixes: 2aaa43c70778 ("tty: serial: qcom-geni-serial: add support for serial engine DMA")
Cc: stable <stable@kernel.org>
Reviewed-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Link: https://patch.msgid.link/20260729174105.21838-2-git@jaseg.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Inlined `__qcom_geni_serial_cancel_tx_cmd()` as the existing open-coded cancel/abort block and dropped the `flush_buffer`→`flush_buffer_fifo` rename and `tx_queued` reset, which don't exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |   51 ++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 18 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -144,6 +144,7 @@ static const struct uart_ops qcom_geni_u
 static struct uart_driver qcom_geni_console_driver;
 static struct uart_driver qcom_geni_uart_driver;
 
+static void qcom_geni_serial_stop_tx_dma(struct uart_port *uport);
 static int qcom_geni_serial_port_setup(struct uart_port *uport);
 
 static inline struct qcom_geni_serial_port *to_dev_port(struct uart_port *uport)
@@ -597,35 +598,48 @@ static unsigned int qcom_geni_serial_tx_
 	return !readl(uport->membase + SE_GENI_TX_FIFO_STATUS);
 }
 
+static void qcom_geni_serial_flush_buffer_dma(struct uart_port *uport)
+{
+	struct qcom_geni_serial_port *port = to_dev_port(uport);
+
+	qcom_geni_serial_stop_tx_dma(uport);
+	port->tx_remaining = 0;
+}
+
 static void qcom_geni_serial_stop_tx_dma(struct uart_port *uport)
 {
 	struct qcom_geni_serial_port *port = to_dev_port(uport);
 	bool done;
 
-	if (!qcom_geni_serial_main_active(uport))
-		return;
+	if (qcom_geni_serial_main_active(uport)) {
+		geni_se_cancel_m_cmd(&port->se);
+
+		done = qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
+						 M_CMD_CANCEL_EN, true);
+		if (!done) {
+			geni_se_abort_m_cmd(&port->se);
+			done = qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
+							 M_CMD_ABORT_EN, true);
+			if (!done)
+				dev_err_ratelimited(uport->dev, "M_CMD_ABORT_EN not set");
+			writel(M_CMD_ABORT_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
+		}
+
+		writel(M_CMD_CANCEL_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
+	}
 
 	if (port->tx_dma_addr) {
+		writel(1, uport->membase + SE_DMA_TX_FSM_RST);
+		if (!qcom_geni_serial_poll_bit(uport, SE_DMA_TX_IRQ_STAT,
+					       TX_RESET_DONE, true))
+			dev_err_ratelimited(uport->dev, "TX DMA reset failed");
+		writel(TX_RESET_DONE | TX_DMA_DONE,
+		       uport->membase + SE_DMA_TX_IRQ_CLR);
+
 		geni_se_tx_dma_unprep(&port->se, port->tx_dma_addr,
 				      port->tx_remaining);
 		port->tx_dma_addr = 0;
-		port->tx_remaining = 0;
-	}
-
-	geni_se_cancel_m_cmd(&port->se);
-
-	done = qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
-					 M_CMD_CANCEL_EN, true);
-	if (!done) {
-		geni_se_abort_m_cmd(&port->se);
-		done = qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
-						 M_CMD_ABORT_EN, true);
-		if (!done)
-			dev_err_ratelimited(uport->dev, "M_CMD_ABORT_EN not set");
-		writel(M_CMD_ABORT_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
 	}
-
-	writel(M_CMD_CANCEL_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
 }
 
 static void qcom_geni_serial_start_tx_dma(struct uart_port *uport)
@@ -1600,6 +1614,7 @@ static const struct uart_ops qcom_geni_u
 	.request_port = qcom_geni_serial_request_port,
 	.config_port = qcom_geni_serial_config_port,
 	.shutdown = qcom_geni_serial_shutdown,
+	.flush_buffer = qcom_geni_serial_flush_buffer_dma,
 	.type = qcom_geni_serial_get_type,
 	.set_mctrl = qcom_geni_serial_set_mctrl,
 	.get_mctrl = qcom_geni_serial_get_mctrl,


