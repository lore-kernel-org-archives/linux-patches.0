Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3E727733;
	Tue, 16 Jul 2024 15:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145118; cv=none; b=D3wsPXingpbBCQNAlSZ3AhhvnmggIhB4SYX5ICUWaO11uVNVgchhgO45lPr6oONjZxMsw7aSblM+1KYhHZjcbBuEGxUxFbcTdmDmqnfcXnIpTftpX/zmz5VUtFsSNNf1BzFU8xWgEhOKuv90uuOS+TaqurRkm6gy8sLJgaOBBas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145118; c=relaxed/simple;
	bh=vBBD4WEsgEe8G4uB4Xuhd77u2hZVEN+u0+BgnAB4dp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+VtqzBQOjCrI0IVsaL4qyl/YRl5qBL1pr+ssDe3GrzdowkvAMrrHXE93VcgywLQhxX8RL2lr3rC+pM6AsF8n7cCohv/hacM3XA+dYgEKNYFRg03WDWFmX+oRtcc+6Rvb+HagvsINzT1VEAeG3kZZyGlTL0+pLRna9gw9K+DooM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMa3eKqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMa3eKqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A9AC4AF0B;
	Tue, 16 Jul 2024 15:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145117;
	bh=vBBD4WEsgEe8G4uB4Xuhd77u2hZVEN+u0+BgnAB4dp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMa3eKqzJD1O55HU7Jz+rQGGpQquro+PgOCYL7vNxWf9H3P0sacbYD5FI39aNJnGj
	 HGQIO8JQYtjlFZ1p9z9vFHzq0jIzXxX1GjNNDjpTOEk3bCiUFxId20yHGt8nObFlYi
	 EnZwUHS89VT2qmBtTd5hXqgdiWg9QFZ7lYmuGfps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	stable <stable@kernel.org>,
	Marek Vasut <marex@denx.de>
Subject: [PATCH 6.9 105/143] serial: imx: ensure RTS signal is not left active after shutdown
Date: Tue, 16 Jul 2024 17:31:41 +0200
Message-ID: <20240716152800.016969563@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit 1af2156e58f3af1216ce2f0456b3b8949faa5c7e upstream.

If a process is killed while writing to a /dev/ttymxc* device in RS485
mode, we observe that the RTS signal is left high, thus making it
impossible for other devices to transmit anything.

Moreover, the ->tx_state variable is left in state SEND, which means
that when one next opens the device and configures baud rate etc., the
initialization code in imx_uart_set_termios dutifully ensures the RTS
pin is pulled down, but since ->tx_state is already SEND, the logic in
imx_uart_start_tx() does not in fact pull the pin high before
transmitting, so nothing actually gets on the wire on the other side
of the transceiver. Only when that transmission is allowed to complete
is the state machine then back in a consistent state.

This is completely reproducible by doing something as simple as

  seq 10000 > /dev/ttymxc0

and hitting ctrl-C, and watching with a logic analyzer.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: stable <stable@kernel.org>
Reviewed-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20240625184206.508837-1-linux@rasmusvillemoes.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1560,6 +1560,7 @@ static void imx_uart_shutdown(struct uar
 	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long flags;
 	u32 ucr1, ucr2, ucr4, uts;
+	int loops;
 
 	if (sport->dma_is_enabled) {
 		dmaengine_terminate_sync(sport->dma_chan_tx);
@@ -1622,6 +1623,56 @@ static void imx_uart_shutdown(struct uar
 	ucr4 &= ~UCR4_TCEN;
 	imx_uart_writel(sport, ucr4, UCR4);
 
+	/*
+	 * We have to ensure the tx state machine ends up in OFF. This
+	 * is especially important for rs485 where we must not leave
+	 * the RTS signal high, blocking the bus indefinitely.
+	 *
+	 * All interrupts are now disabled, so imx_uart_stop_tx() will
+	 * no longer be called from imx_uart_transmit_buffer(). It may
+	 * still be called via the hrtimers, and if those are in play,
+	 * we have to honour the delays.
+	 */
+	if (sport->tx_state == WAIT_AFTER_RTS || sport->tx_state == SEND)
+		imx_uart_stop_tx(port);
+
+	/*
+	 * In many cases (rs232 mode, or if tx_state was
+	 * WAIT_AFTER_RTS, or if tx_state was SEND and there is no
+	 * delay_rts_after_send), this will have moved directly to
+	 * OFF. In rs485 mode, tx_state might already have been
+	 * WAIT_AFTER_SEND and the hrtimer thus already started, or
+	 * the above imx_uart_stop_tx() call could have started it. In
+	 * those cases, we have to wait for the hrtimer to fire and
+	 * complete the transition to OFF.
+	 */
+	loops = port->rs485.flags & SER_RS485_ENABLED ?
+		port->rs485.delay_rts_after_send : 0;
+	while (sport->tx_state != OFF && loops--) {
+		uart_port_unlock_irqrestore(&sport->port, flags);
+		msleep(1);
+		uart_port_lock_irqsave(&sport->port, &flags);
+	}
+
+	if (sport->tx_state != OFF) {
+		dev_warn(sport->port.dev, "unexpected tx_state %d\n",
+			 sport->tx_state);
+		/*
+		 * This machine may be busted, but ensure the RTS
+		 * signal is inactive in order not to block other
+		 * devices.
+		 */
+		if (port->rs485.flags & SER_RS485_ENABLED) {
+			ucr2 = imx_uart_readl(sport, UCR2);
+			if (port->rs485.flags & SER_RS485_RTS_AFTER_SEND)
+				imx_uart_rts_active(sport, &ucr2);
+			else
+				imx_uart_rts_inactive(sport, &ucr2);
+			imx_uart_writel(sport, ucr2, UCR2);
+		}
+		sport->tx_state = OFF;
+	}
+
 	uart_port_unlock_irqrestore(&sport->port, flags);
 
 	clk_disable_unprepare(sport->clk_per);


