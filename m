Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB0A76034;
	Mon, 29 Jan 2024 17:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548620; cv=none; b=jAi7TYjXzIHyvtWY7Mw6NQNsobXRsg/KmrbxhRVN3qhq+H71fPFgKxscznq4qQyw/LaMWj+FXRUR1UQ09zjlGWt+oNbdqOOMDd+ZGA6gxl47irXY3pt2+pfxIHxH0uRudr2d6F4QmGxfy/k6CGIq9Md4BIco+mXFn25vucdxN0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548620; c=relaxed/simple;
	bh=Aq5/U2GlU8gMaNsWpry22jYd4SGm+7GHI6zvGrp2hPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaqoJdK+H6LzdU7VumFB/Be9WiQ5+NgUu1L/AB2oUVdj5Zz42w4oIkDia8yI+4cbSO4Kd7KRJ8nUluTIvnCdPVK+fsETGXqh/buWFVP82uulgopR4yQArj0BjvlwbU8gZGfcuDtgmbRyZkPDZH7KXyk7ejcypskEPG4WiGyX9QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMutsJPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMutsJPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC74EC43394;
	Mon, 29 Jan 2024 17:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548619;
	bh=Aq5/U2GlU8gMaNsWpry22jYd4SGm+7GHI6zvGrp2hPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMutsJPICN4qCtruzHQY5+OEfPCwCYyaF70iBPAY6WmO4v94D8oOc0S4g7eQY8b7r
	 3Vje18M758ugeNB3L/P47608FPJHJzObUBCJQuSMnahXC3qB+7pHaUMKZfv4fvIqRU
	 sitLMOezMWof3GpsOp0ok7GtjrFjqkXyz+6fCUZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 289/331] serial: sc16is7xx: Use port lock wrappers
Date: Mon, 29 Jan 2024 09:05:53 -0800
Message-ID: <20240129170023.313121341@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3276d21ec1c6..425093ce3f24 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -642,9 +642,9 @@ static void sc16is7xx_handle_tx(struct uart_port *port)
 	}
 
 	if (uart_circ_empty(xmit) || uart_tx_stopped(port)) {
-		spin_lock_irqsave(&port->lock, flags);
+		uart_port_lock_irqsave(port, &flags);
 		sc16is7xx_stop_tx(port);
-		spin_unlock_irqrestore(&port->lock, flags);
+		uart_port_unlock_irqrestore(port, flags);
 		return;
 	}
 
@@ -670,13 +670,13 @@ static void sc16is7xx_handle_tx(struct uart_port *port)
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
@@ -707,7 +707,7 @@ static void sc16is7xx_update_mlines(struct sc16is7xx_one *one)
 
 	one->old_mctrl = status;
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 	if ((changed & TIOCM_RNG) && (status & TIOCM_RNG))
 		port->icount.rng++;
 	if (changed & TIOCM_DSR)
@@ -718,7 +718,7 @@ static void sc16is7xx_update_mlines(struct sc16is7xx_one *one)
 		uart_handle_cts_change(port, status & TIOCM_CTS);
 
 	wake_up_interruptible(&port->state->port.delta_msr_wait);
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static bool sc16is7xx_port_irq(struct sc16is7xx_port *s, int portno)
@@ -812,9 +812,9 @@ static void sc16is7xx_tx_proc(struct kthread_work *ws)
 	sc16is7xx_handle_tx(port);
 	mutex_unlock(&one->efr_lock);
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 	sc16is7xx_ier_set(port, SC16IS7XX_IER_THRI_BIT);
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static void sc16is7xx_reconf_rs485(struct uart_port *port)
@@ -825,14 +825,14 @@ static void sc16is7xx_reconf_rs485(struct uart_port *port)
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
@@ -843,10 +843,10 @@ static void sc16is7xx_reg_proc(struct kthread_work *ws)
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
@@ -952,18 +952,18 @@ static void sc16is7xx_throttle(struct uart_port *port)
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
@@ -1101,7 +1101,7 @@ static void sc16is7xx_set_termios(struct uart_port *port,
 	/* Setup baudrate generator */
 	baud = sc16is7xx_set_baud(port, baud);
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 
 	/* Update timeout according to new baud rate */
 	uart_update_timeout(port, termios->c_cflag, baud);
@@ -1109,7 +1109,7 @@ static void sc16is7xx_set_termios(struct uart_port *port,
 	if (UART_ENABLE_MS(port, termios->c_cflag))
 		sc16is7xx_enable_ms(port);
 
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static int sc16is7xx_config_rs485(struct uart_port *port, struct ktermios *termios,
@@ -1195,9 +1195,9 @@ static int sc16is7xx_startup(struct uart_port *port)
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



