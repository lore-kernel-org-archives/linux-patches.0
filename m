Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFAB423788;
	Mon, 17 Aug 2026 13:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975103; cv=none; b=KEU4sMdxl5R+RCWT/ucXuvu5JDMnOEo8F9CpcuJxXm5TtW0yxVTgOmAW+4vUADXqyb2uXxvmZWDhD7tjRzV2/NIYbybNz4ouAQVP87YxnfPilT5d2Ue08uQic3VgFtuAGojhBTpw28nOMxaTujQNNkKRcV8//yLPKyTHXPvKeYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975103; c=relaxed/simple;
	bh=eCPcezXOo/tmq6yI+9C6EXQtg/RAaMiJCC6BxinaDbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sybI9AJqUEllYVxlthF9Rnj84452Vk5scBsuTmdvHjT4VAKGHGsMhIm7G09b2aCzN8w8e0NJgff4SWV3/iFRuwYDksAKOEsLffjNJv24ON6pOTWiuE5Tqs/TEgqDfYjVjo1ijwIJmWHrajt/AK7cfsMFsQYp8vdsVwv993rdYD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7ZuY9e3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7ZuY9e3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C061F000E9;
	Mon, 17 Aug 2026 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975102;
	bh=IenpAjKJB5d+79pdp9QpnxWT2JJkXB5lcJIHHeJwQQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7ZuY9e3a4rhAvNzCgAoBgBCxwTH9i8POnwiWgpKOPuDghYIqou5Zs6Do2gXE8oe8
	 f7k7WKpheFYMT9SpiXzUKD1NPO3G0Is/F2z/Dx/Z1VkQcsOpCVqzcCnPV9zGk3yiA+
	 zc4x8sQrEEOyPsC605DvVV7A7Fq8zoUnhcrwDayM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>,
	stable <stable@kernel.org>,
	Praveen Talari <praveen.talari@oss.qualcomm.com>
Subject: [PATCH 6.18 164/250] serial: qcom-geni: fix TX DMA buffer flush
Date: Mon, 17 Aug 2026 15:32:05 +0200
Message-ID: <20260817132543.329888103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Sebastian Götte <linux@jaseg.de>

commit e3c04834ae1ab5e9cfbe8ac54ec734aa4774249d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |   43 +++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -149,6 +149,7 @@ static const struct uart_ops qcom_geni_u
 static struct uart_driver qcom_geni_console_driver;
 static struct uart_driver qcom_geni_uart_driver;
 
+static void qcom_geni_serial_stop_tx_dma(struct uart_port *uport);
 static void __qcom_geni_serial_cancel_tx_cmd(struct uart_port *uport);
 static void qcom_geni_serial_cancel_tx_cmd(struct uart_port *uport);
 static int qcom_geni_serial_port_setup(struct uart_port *uport);
@@ -627,35 +628,34 @@ static unsigned int qcom_geni_serial_tx_
 	return !readl(uport->membase + SE_GENI_TX_FIFO_STATUS);
 }
 
+static void qcom_geni_serial_flush_buffer_dma(struct uart_port *uport)
+{
+	struct qcom_geni_serial_port *port = to_dev_port(uport);
+
+	qcom_geni_serial_stop_tx_dma(uport);
+	port->tx_remaining = 0;
+	port->tx_queued = 0;
+}
+
 static void qcom_geni_serial_stop_tx_dma(struct uart_port *uport)
 {
 	struct qcom_geni_serial_port *port = to_dev_port(uport);
-	bool done;
 
-	if (!qcom_geni_serial_main_active(uport))
-		return;
+	if (qcom_geni_serial_main_active(uport))
+		__qcom_geni_serial_cancel_tx_cmd(uport);
 
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
 	}
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
-	}
-
-	writel(M_CMD_CANCEL_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
 }
 
 static void qcom_geni_serial_start_tx_dma(struct uart_port *uport)
@@ -1171,7 +1171,7 @@ static void qcom_geni_serial_shutdown(st
 	uart_port_unlock_irq(uport);
 }
 
-static void qcom_geni_serial_flush_buffer(struct uart_port *uport)
+static void qcom_geni_serial_flush_buffer_fifo(struct uart_port *uport)
 {
 	qcom_geni_serial_cancel_tx_cmd(uport);
 }
@@ -1695,7 +1695,7 @@ static const struct uart_ops qcom_geni_c
 	.request_port = qcom_geni_serial_request_port,
 	.config_port = qcom_geni_serial_config_port,
 	.shutdown = qcom_geni_serial_shutdown,
-	.flush_buffer = qcom_geni_serial_flush_buffer,
+	.flush_buffer = qcom_geni_serial_flush_buffer_fifo,
 	.type = qcom_geni_serial_get_type,
 	.set_mctrl = qcom_geni_serial_set_mctrl,
 	.get_mctrl = qcom_geni_serial_get_mctrl,
@@ -1718,6 +1718,7 @@ static const struct uart_ops qcom_geni_u
 	.request_port = qcom_geni_serial_request_port,
 	.config_port = qcom_geni_serial_config_port,
 	.shutdown = qcom_geni_serial_shutdown,
+	.flush_buffer = qcom_geni_serial_flush_buffer_dma,
 	.type = qcom_geni_serial_get_type,
 	.set_mctrl = qcom_geni_serial_set_mctrl,
 	.get_mctrl = qcom_geni_serial_get_mctrl,


