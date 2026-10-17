Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B71C3B8BBB;
	Sat, 17 Oct 2026 17:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258257; cv=none; b=hqFmZpqCAJQQcgN7xLHAKcEgmwhLLbLaYg8kqZj67SukxiGpQy21nzOmHOiXigdFp6WL4vUzYF4G7kjRFDqGkMoLwnuoTnX29TTEocHduEl1BmWqMCQMgnv8lYHWyju83AjdOIYPR+OCgQ3t+cJaeK+k3Pgz3suDVLRGiYa2caw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258257; c=relaxed/simple;
	bh=KsCnAVRzmJe+ywcLhZ9C9IT3ChUQG7uAiYEV63qO7sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWGF9u+8j2kaTjqTiHtgf8PnjLFvQYFx4DBxhww02dvhqnDgh1x7qFRah6tAuL35TEyE20nx3rlNXkLaTMfWzGfijJZkNOnqIRSYazzYAstQWxGC4kyz+ySduHyXySOAQjpxkJIewdjC/0pN/i7k7a9g8UZuC8XA5+jwm2/QA2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dwjDdMMw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwjDdMMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA661F000C4;
	Sat, 17 Oct 2026 17:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258256;
	bh=1/MQ5Jghu1K7lVGCDpvgCHHe+9uWTy+bmlEHYXCh9TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dwjDdMMww5NztZ4Aoelb8Wm8/JOtt5mS4oLL7t1/bvlLKj1TIAgOkr9c+hvWNYwaX
	 KVT3Gx9vVd9WVoGi4X5BtBDPRgFaOZWdV0MTDRdm+DyMauBO2N29Apakf2ZULQUnYp
	 YojEBoP49hwlCPgA9guXLRDX4obnfurTjZxTkhe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0824/1674] serial: ip22zilog: Use port lock wrappers
Date: Sat, 17 Oct 2026 17:51:36 +0200
Message-ID: <20261017160452.276371796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 893d225197d5fc6d112e8edb258265e885dd5246 ]

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
Link: https://lore.kernel.org/r/20230914183831.587273-31-john.ogness@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 3fc36ae6abd2 ("tty: serial: ip22zilog: Use platform device for probing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/ip22zilog.c | 36 +++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/serial/ip22zilog.c b/drivers/tty/serial/ip22zilog.c
index 845ff706bc59d..320b29cd4683b 100644
--- a/drivers/tty/serial/ip22zilog.c
+++ b/drivers/tty/serial/ip22zilog.c
@@ -432,7 +432,7 @@ static irqreturn_t ip22zilog_interrupt(int irq, void *dev_id)
 		unsigned char r3;
 		bool push = false;
 
-		spin_lock(&up->port.lock);
+		uart_port_lock(&up->port);
 		r3 = read_zsreg(channel, R3);
 
 		/* Channel A */
@@ -448,7 +448,7 @@ static irqreturn_t ip22zilog_interrupt(int irq, void *dev_id)
 			if (r3 & CHATxIP)
 				ip22zilog_transmit_chars(up, channel);
 		}
-		spin_unlock(&up->port.lock);
+		uart_port_unlock(&up->port);
 
 		if (push)
 			tty_flip_buffer_push(&up->port.state->port);
@@ -458,7 +458,7 @@ static irqreturn_t ip22zilog_interrupt(int irq, void *dev_id)
 		channel = ZILOG_CHANNEL_FROM_PORT(&up->port);
 		push = false;
 
-		spin_lock(&up->port.lock);
+		uart_port_lock(&up->port);
 		if (r3 & (CHBEXT | CHBTxIP | CHBRxIP)) {
 			writeb(RES_H_IUS, &channel->control);
 			ZSDELAY();
@@ -471,7 +471,7 @@ static irqreturn_t ip22zilog_interrupt(int irq, void *dev_id)
 			if (r3 & CHBTxIP)
 				ip22zilog_transmit_chars(up, channel);
 		}
-		spin_unlock(&up->port.lock);
+		uart_port_unlock(&up->port);
 
 		if (push)
 			tty_flip_buffer_push(&up->port.state->port);
@@ -504,11 +504,11 @@ static unsigned int ip22zilog_tx_empty(struct uart_port *port)
 	unsigned char status;
 	unsigned int ret;
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 
 	status = ip22zilog_read_channel_status(port);
 
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 
 	if (status & Tx_BUF_EMP)
 		ret = TIOCSER_TEMT;
@@ -664,7 +664,7 @@ static void ip22zilog_break_ctl(struct uart_port *port, int break_state)
 	else
 		clear_bits |= SND_BRK;
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 
 	new_reg = (up->curregs[R5] | set_bits) & ~clear_bits;
 	if (new_reg != up->curregs[R5]) {
@@ -674,7 +674,7 @@ static void ip22zilog_break_ctl(struct uart_port *port, int break_state)
 		write_zsreg(channel, R5, up->curregs[R5]);
 	}
 
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static void __ip22zilog_reset(struct uart_ip22zilog_port *up)
@@ -735,9 +735,9 @@ static int ip22zilog_startup(struct uart_port *port)
 	if (ZS_IS_CONS(up))
 		return 0;
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 	__ip22zilog_startup(up);
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 	return 0;
 }
 
@@ -775,7 +775,7 @@ static void ip22zilog_shutdown(struct uart_port *port)
 	if (ZS_IS_CONS(up))
 		return;
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 
 	channel = ZILOG_CHANNEL_FROM_PORT(port);
 
@@ -788,7 +788,7 @@ static void ip22zilog_shutdown(struct uart_port *port)
 	up->curregs[R5] &= ~SND_BRK;
 	ip22zilog_maybe_update_regs(up, channel);
 
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 /* Shared by TTY driver and serial console setup.  The port lock is held
@@ -880,7 +880,7 @@ ip22zilog_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	baud = uart_get_baud_rate(port, termios, old, 1200, 76800);
 
-	spin_lock_irqsave(&up->port.lock, flags);
+	uart_port_lock_irqsave(&up->port, &flags);
 
 	brg = BPS_TO_BRG(baud, ZS_CLOCK / ZS_CLOCK_DIVISOR);
 
@@ -894,7 +894,7 @@ ip22zilog_set_termios(struct uart_port *port, struct ktermios *termios,
 	ip22zilog_maybe_update_regs(up, ZILOG_CHANNEL_FROM_PORT(port));
 	uart_update_timeout(port, termios->c_cflag, baud);
 
-	spin_unlock_irqrestore(&up->port.lock, flags);
+	uart_port_unlock_irqrestore(&up->port, flags);
 }
 
 static const char *ip22zilog_type(struct uart_port *port)
@@ -1016,10 +1016,10 @@ ip22zilog_console_write(struct console *con, const char *s, unsigned int count)
 	struct uart_ip22zilog_port *up = &ip22zilog_port_table[con->index];
 	unsigned long flags;
 
-	spin_lock_irqsave(&up->port.lock, flags);
+	uart_port_lock_irqsave(&up->port, &flags);
 	uart_console_write(&up->port, s, count, ip22zilog_put_char);
 	udelay(2);
-	spin_unlock_irqrestore(&up->port.lock, flags);
+	uart_port_unlock_irqrestore(&up->port, flags);
 }
 
 static int __init ip22zilog_console_setup(struct console *con, char *options)
@@ -1034,13 +1034,13 @@ static int __init ip22zilog_console_setup(struct console *con, char *options)
 
 	printk(KERN_INFO "Console: ttyS%d (IP22-Zilog)\n", con->index);
 
-	spin_lock_irqsave(&up->port.lock, flags);
+	uart_port_lock_irqsave(&up->port, &flags);
 
 	up->curregs[R15] |= BRKIE;
 
 	__ip22zilog_startup(up);
 
-	spin_unlock_irqrestore(&up->port.lock, flags);
+	uart_port_unlock_irqrestore(&up->port, flags);
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
-- 
2.53.0



