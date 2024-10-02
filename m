Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8BF1D079C;
	Wed,  2 Oct 2024 14:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879027; cv=none; b=WimdrQef23W1C7nYuS6bh4YHhgx2OoPdrmDq8Ud4WMPl19LLFA7MpcC/Om6/0gbx4X8NozlYPhXmoGg8FpyzQZ3Bw/R98Rj+cfK2YObFOVMeR/jPRCl/TWb5e4SHhT3Z28H3jhSwubYu0W7t9/Iik+c27TB4TdDOILZsQHF2qZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879027; c=relaxed/simple;
	bh=LEaD6dW9agN7w/pKUV7TGXBNz3m+9oHkm00CRnPW5Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E2nWGF/SfklXDSS6njxm42oGPL0ae3sjbxuHK7Hfruw2Ar8PhpkasiVzXJtCD+FAlPDwHoGVBKpzjvPxPQBDiKgX0ilbn7AvvSAzYVFLWYxnE7layKESUsJqcyvJA1Q98POGDKd/DZlLs//OvJ2bgDJlLq8pADB56IGEh+iDHFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUEy06HN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUEy06HN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6BCC4CEC2;
	Wed,  2 Oct 2024 14:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879027;
	bh=LEaD6dW9agN7w/pKUV7TGXBNz3m+9oHkm00CRnPW5Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUEy06HNFiJ+usAtXQN7osneOGbInLqX/PCEyMwYf9Yevuv6m0DZ/NcNS3UBRmvNg
	 3FH3lqJk0t3n6OkanQMmtSgngxOgM8YPcG7T+MKb6zHTGhdtKKsuS0+D51Jl1XO3eI
	 qI8gKRIA9dSV3g8iZD/VyNFnm4DSRBUnLcubYhlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 606/634] serial: qcom-geni: fix console corruption
Date: Wed,  2 Oct 2024 15:01:46 +0200
Message-ID: <20241002125835.033946317@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit cc4a0e5754a16bbc1e215c091349a7c83a2c5e14 ]

The Qualcomm serial console implementation is broken and can lose
characters when the serial port is also used for tty output.

Specifically, the console code only waits for the current tx command to
complete when all data has already been written to the fifo. When there
are on-going longer transfers this often means that console output is
lost when the console code inadvertently "hijacks" the current tx
command instead of starting a new one.

This can, for example, be observed during boot when console output that
should have been interspersed with init output is truncated:

	[    9.462317] qcom-snps-eusb2-hsphy fde000.phy: Registered Qcom-eUSB2 phy
	[  OK  ] Found device KBG50ZNS256G KIOXIA Wi[    9.471743ndows.
	[    9.539915] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller

Add a new state variable to track how much data has been written to the
fifo and use it to determine when the fifo and shift register are both
empty. This is needed since there is currently no other known way to
determine when the shift register is empty.

This in turn allows the console code to interrupt long transfers without
losing data.

Note that the oops-in-progress case is similarly broken as it does not
cancel any active command and also waits for the wrong status flag when
attempting to drain the fifo (TX_FIFO_NOT_EMPTY_EN is only set when
cancelling a command leaves data in the fifo).

Fixes: c4f528795d1a ("tty: serial: msm_geni_serial: Add serial driver support for GENI based QUP")
Fixes: a1fee899e5be ("tty: serial: qcom_geni_serial: Fix softlock")
Fixes: 9e957a155005 ("serial: qcom-geni: Don't cancel/abort if we can't get the port lock")
Cc: stable@vger.kernel.org	# 4.17
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240906131336.23625-7-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 45 +++++++++++++--------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 7bbd70c306201..f8f6e9466b400 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -131,6 +131,7 @@ struct qcom_geni_serial_port {
 	bool brk;
 
 	unsigned int tx_remaining;
+	unsigned int tx_queued;
 	int wakeup_irq;
 	bool rx_tx_swap;
 	bool cts_rts_swap;
@@ -144,6 +145,8 @@ static const struct uart_ops qcom_geni_uart_pops;
 static struct uart_driver qcom_geni_console_driver;
 static struct uart_driver qcom_geni_uart_driver;
 
+static void qcom_geni_serial_cancel_tx_cmd(struct uart_port *uport);
+
 static inline struct qcom_geni_serial_port *to_dev_port(struct uart_port *uport)
 {
 	return container_of(uport, struct qcom_geni_serial_port, uport);
@@ -393,6 +396,14 @@ static void qcom_geni_serial_poll_put_char(struct uart_port *uport,
 #endif
 
 #ifdef CONFIG_SERIAL_QCOM_GENI_CONSOLE
+static void qcom_geni_serial_drain_fifo(struct uart_port *uport)
+{
+	struct qcom_geni_serial_port *port = to_dev_port(uport);
+
+	qcom_geni_serial_poll_bitfield(uport, SE_GENI_M_GP_LENGTH, GP_LENGTH,
+			port->tx_queued);
+}
+
 static void qcom_geni_serial_wr_char(struct uart_port *uport, unsigned char ch)
 {
 	struct qcom_geni_private_data *private_data = uport->private_data;
@@ -468,7 +479,6 @@ static void qcom_geni_serial_console_write(struct console *co, const char *s,
 	struct qcom_geni_serial_port *port;
 	bool locked = true;
 	unsigned long flags;
-	u32 geni_status;
 
 	WARN_ON(co->index < 0 || co->index >= GENI_UART_CONS_PORTS);
 
@@ -482,34 +492,20 @@ static void qcom_geni_serial_console_write(struct console *co, const char *s,
 	else
 		uart_port_lock_irqsave(uport, &flags);
 
-	geni_status = readl(uport->membase + SE_GENI_STATUS);
+	if (qcom_geni_serial_main_active(uport)) {
+		/* Wait for completion or drain FIFO */
+		if (!locked || port->tx_remaining == 0)
+			qcom_geni_serial_poll_tx_done(uport);
+		else
+			qcom_geni_serial_drain_fifo(uport);
 
-	if (!locked) {
-		/*
-		 * We can only get here if an oops is in progress then we were
-		 * unable to get the lock. This means we can't safely access
-		 * our state variables like tx_remaining. About the best we
-		 * can do is wait for the FIFO to be empty before we start our
-		 * transfer, so we'll do that.
-		 */
-		qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
-					  M_TX_FIFO_NOT_EMPTY_EN, false);
-	} else if ((geni_status & M_GENI_CMD_ACTIVE) && !port->tx_remaining) {
-		/*
-		 * It seems we can't interrupt existing transfers if all data
-		 * has been sent, in which case we need to look for done first.
-		 */
-		qcom_geni_serial_poll_tx_done(uport);
+		qcom_geni_serial_cancel_tx_cmd(uport);
 	}
 
 	__qcom_geni_serial_console_write(uport, s, count);
 
-
-	if (locked) {
-		if (port->tx_remaining)
-			qcom_geni_serial_setup_tx(uport, port->tx_remaining);
+	if (locked)
 		uart_port_unlock_irqrestore(uport, flags);
-	}
 }
 
 static void handle_rx_console(struct uart_port *uport, u32 bytes, bool drop)
@@ -690,6 +686,7 @@ static void qcom_geni_serial_cancel_tx_cmd(struct uart_port *uport)
 	writel(M_CMD_CANCEL_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
 
 	port->tx_remaining = 0;
+	port->tx_queued = 0;
 }
 
 static void qcom_geni_serial_handle_rx_fifo(struct uart_port *uport, bool drop)
@@ -916,6 +913,7 @@ static void qcom_geni_serial_handle_tx_fifo(struct uart_port *uport,
 	if (!port->tx_remaining) {
 		qcom_geni_serial_setup_tx(uport, pending);
 		port->tx_remaining = pending;
+		port->tx_queued = 0;
 
 		irq_en = readl(uport->membase + SE_GENI_M_IRQ_EN);
 		if (!(irq_en & M_TX_FIFO_WATERMARK_EN))
@@ -924,6 +922,7 @@ static void qcom_geni_serial_handle_tx_fifo(struct uart_port *uport,
 	}
 
 	qcom_geni_serial_send_chunk_fifo(uport, chunk);
+	port->tx_queued += chunk;
 
 	/*
 	 * The tx fifo watermark is level triggered and latched. Though we had
-- 
2.43.0



