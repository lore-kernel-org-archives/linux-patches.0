Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8E8163AA7;
	Mon, 29 Jan 2024 17:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548388; cv=none; b=XcL0Q9S8RLV/LsDkMzF9b8WCUgU3nYgVTB76M7IJI+4BQQUks3NY7AKc+o1BMibIh3wV38N6pMWI0ndxRmOH9tcGn3QVQ4FcKrpLHmxR071CKoVl0eODEd2NBjRYI6PGYyunrWS/BEtvn2/7G/8wK42I2qt/yrIu05KHWy9k+yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548388; c=relaxed/simple;
	bh=xjF6DJt8HdpOMy+Ufd/LmCRIWPfCFzO/6mzyStv6qxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVH+4qr8wsvyGme6UpqXWlkfTCt+U7FN32enlhS1UJCY712G8eqp1T9llhWqcUYluUHwSCX7GLwh5G0y27OqiC/rbd9R26eDi8g4zML4cfpulIzFHhsZOblTjTqDThwZfNun9DPW8cYIlfpLB0eeNQJUL3S8h+G8og7bAo8Xrc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUnnJepy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUnnJepy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34B7C433F1;
	Mon, 29 Jan 2024 17:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548387;
	bh=xjF6DJt8HdpOMy+Ufd/LmCRIWPfCFzO/6mzyStv6qxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUnnJepy0J0Ix0ZaMUZKR9DJLaSBPP4PHj3LrhPnWhc7ldslXgweN0sYvHWnudiKd
	 X8qQC5FnKH/pHDMPeTspWVCAl+VeMzSgRQ5nrrDqZAXhfcuIFn0oQwttoIyvg4/yHt
	 aNVF+CFUTYifAJElBixAk0Vwbqr89wavV1XQUNiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/185] serial: sc16is7xx: Use port lock wrappers
Date: Mon, 29 Jan 2024 09:06:00 -0800
Message-ID: <20240129170003.730858166@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit b465848be8a652e2c5fefe102661fb660cff8497 ]

When a serial port is used for kernel console output, then all
modifications to the UART registers which are done from other contexts,
e.g. getty, termios, are interference points for the kernel console.

So far this has been ignored and the printk output is based on the
principle of hope. The rework of the console infrastructure which aims to
support threaded and atomic consoles, requires to mark sections which
modify the UART registers as unsafe. This allows the atomic write function
to make informed decisions and eventually to restore operational state. It
also allows to prevent the regular UART code from modifying UART registers
while printk output is in progress.

All modifications of UART registers are guarded by the UART port lock,
which provides an obvious synchronization point with the console
infrastructure.

To avoid adding this functionality to all UART drivers, wrap the
spin_[un]lock*() invocations for uart_port::lock into helper functions
which just contain the spin_[un]lock*() invocations for now. In a
subsequent step these helpers will gain the console synchronization
mechanisms.

Converted with coccinelle. No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Link: https://lore.kernel.org/r/20230914183831.587273-56-john.ogness@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 9915753037eb ("serial: sc16is7xx: fix unconditional activation of THRI interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 40 +++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index ab9159441d02..4def1b7266f6 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -641,9 +641,9 @@ static void sc16is7xx_handle_tx(struct uart_port *port)
 	}
 
 	if (uart_circ_empty(xmit) || uart_tx_stopped(port)) {
-		spin_lock_irqsave(&port->lock, flags);
+		uart_port_lock_irqsave(port, &flags);
 		sc16is7xx_stop_tx(port);
-		spin_unlock_irqrestore(&port->lock, flags);
+		uart_port_unlock_irqrestore(port, flags);
 		return;
 	}
 
@@ -672,13 +672,13 @@ static void sc16is7xx_handle_tx(struct uart_port *port)
 		sc16is7xx_fifo_write(port, to_send);
 	}
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
 
 	if (uart_circ_empty(xmit))
 		sc16is7xx_stop_tx(port);
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static unsigned int sc16is7xx_get_hwmctrl(struct uart_port *port)
@@ -709,7 +709,7 @@ static void sc16is7xx_update_mlines(struct sc16is7xx_one *one)
 
 	one->old_mctrl = status;
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 	if ((changed & TIOCM_RNG) && (status & TIOCM_RNG))
 		port->icount.rng++;
 	if (changed & TIOCM_DSR)
@@ -720,7 +720,7 @@ static void sc16is7xx_update_mlines(struct sc16is7xx_one *one)
 		uart_handle_cts_change(port, status & TIOCM_CTS);
 
 	wake_up_interruptible(&port->state->port.delta_msr_wait);
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static bool sc16is7xx_port_irq(struct sc16is7xx_port *s, int portno)
@@ -814,9 +814,9 @@ static void sc16is7xx_tx_proc(struct kthread_work *ws)
 	sc16is7xx_handle_tx(port);
 	mutex_unlock(&one->efr_lock);
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 	sc16is7xx_ier_set(port, SC16IS7XX_IER_THRI_BIT);
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static void sc16is7xx_reconf_rs485(struct uart_port *port)
@@ -827,14 +827,14 @@ static void sc16is7xx_reconf_rs485(struct uart_port *port)
 	struct serial_rs485 *rs485 = &port->rs485;
 	unsigned long irqflags;
 
-	spin_lock_irqsave(&port->lock, irqflags);
+	uart_port_lock_irqsave(port, &irqflags);
 	if (rs485->flags & SER_RS485_ENABLED) {
 		efcr |=	SC16IS7XX_EFCR_AUTO_RS485_BIT;
 
 		if (rs485->flags & SER_RS485_RTS_AFTER_SEND)
 			efcr |= SC16IS7XX_EFCR_RTS_INVERT_BIT;
 	}
-	spin_unlock_irqrestore(&port->lock, irqflags);
+	uart_port_unlock_irqrestore(port, irqflags);
 
 	sc16is7xx_port_update(port, SC16IS7XX_EFCR_REG, mask, efcr);
 }
@@ -845,10 +845,10 @@ static void sc16is7xx_reg_proc(struct kthread_work *ws)
 	struct sc16is7xx_one_config config;
 	unsigned long irqflags;
 
-	spin_lock_irqsave(&one->port.lock, irqflags);
+	uart_port_lock_irqsave(&one->port, &irqflags);
 	config = one->config;
 	memset(&one->config, 0, sizeof(one->config));
-	spin_unlock_irqrestore(&one->port.lock, irqflags);
+	uart_port_unlock_irqrestore(&one->port, irqflags);
 
 	if (config.flags & SC16IS7XX_RECONF_MD) {
 		u8 mcr = 0;
@@ -954,18 +954,18 @@ static void sc16is7xx_throttle(struct uart_port *port)
 	 * value set in MCR register. Stop reading data from RX FIFO so the
 	 * AutoRTS feature will de-activate RTS output.
 	 */
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 	sc16is7xx_ier_clear(port, SC16IS7XX_IER_RDI_BIT);
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static void sc16is7xx_unthrottle(struct uart_port *port)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 	sc16is7xx_ier_set(port, SC16IS7XX_IER_RDI_BIT);
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static unsigned int sc16is7xx_tx_empty(struct uart_port *port)
@@ -1103,7 +1103,7 @@ static void sc16is7xx_set_termios(struct uart_port *port,
 	/* Setup baudrate generator */
 	baud = sc16is7xx_set_baud(port, baud);
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 
 	/* Update timeout according to new baud rate */
 	uart_update_timeout(port, termios->c_cflag, baud);
@@ -1111,7 +1111,7 @@ static void sc16is7xx_set_termios(struct uart_port *port,
 	if (UART_ENABLE_MS(port, termios->c_cflag))
 		sc16is7xx_enable_ms(port);
 
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static int sc16is7xx_config_rs485(struct uart_port *port, struct ktermios *termios,
@@ -1197,9 +1197,9 @@ static int sc16is7xx_startup(struct uart_port *port)
 	sc16is7xx_port_write(port, SC16IS7XX_IER_REG, val);
 
 	/* Enable modem status polling */
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 	sc16is7xx_enable_ms(port);
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 
 	return 0;
 }
-- 
2.43.0



