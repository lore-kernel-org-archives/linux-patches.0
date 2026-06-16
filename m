Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38ED3AA1A8;
	Tue, 16 Jun 2026 17:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630128; cv=none; b=eM1KV+Zmrpe2vSeCEaay3OzmiK40o5eteEJCX3N/dpxG8ej0ShjPOt71kwqCgAjDlRzQts6UVtU+EfqLH+8hs4FrDM2nbYpRcSzYuZWDkp/yiW0Bv3wtD6VDxNCmMqi3JLmQp8mRPs72Eyed/BeeCxIxDG50q/bCEcxrmy9WjcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630128; c=relaxed/simple;
	bh=dxlrJIWOwK+L+ozDy2F3k+oHfVp172R5Ja9UIohmq0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OS07cyuaxPut9kq9YEnibeMkwYibmL25dguxxHWMJHlQ07cGb/udcdbcWpFpHWuuXMjpfP7yvTiIwRM3SlnhnL8NhDwreB9DoF8/U57CY9TcgKwnJiGndJ87DLAp2EmpL37CqtJgw9KmetCuJP6S5TQQzq00QX8Hv3HCQc6o5XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMrMU6SK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMrMU6SK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3EB1F000E9;
	Tue, 16 Jun 2026 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630126;
	bh=OtbVPygGkrNP1s7VWgk8zqrLb8xojDL8hkaZ5DGdraQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMrMU6SKYKYq4W76GLtURLtBgt0yzsmp/dQLVGri17+kBx3o96RQaFetgi23UylY5
	 Qf2TRlNMKE2m63RlXUpwXNi4Djj8LRu6XPlL494qZ8O+kxGlWSY7PXQBnxE4PsnkDs
	 bUykRvhPVd80y3rTNnHUcqaGRaX8CH4k5NAepGq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 416/452] serial: samsung_tty: Use port lock wrappers
Date: Tue, 16 Jun 2026 20:30:43 +0530
Message-ID: <20260616145138.631473187@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

[ Upstream commit 97d7a9aeba1d424c2359f1686d02c75d798ad184 ]

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
Link: https://lore.kernel.org/r/20230914183831.587273-54-john.ogness@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a3bb136bff5e ("tty: serial: samsung: Remove redundant port lock acquisition in rx helpers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/samsung_tty.c |   50 +++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

--- a/drivers/tty/serial/samsung_tty.c
+++ b/drivers/tty/serial/samsung_tty.c
@@ -248,7 +248,7 @@ static void s3c24xx_serial_rx_enable(str
 	unsigned int ucon, ufcon;
 	int count = 10000;
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 
 	while (--count && !s3c24xx_serial_txempty_nofifo(port))
 		udelay(100);
@@ -262,7 +262,7 @@ static void s3c24xx_serial_rx_enable(str
 	wr_regl(port, S3C2410_UCON, ucon);
 
 	ourport->rx_enabled = 1;
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static void s3c24xx_serial_rx_disable(struct uart_port *port)
@@ -271,14 +271,14 @@ static void s3c24xx_serial_rx_disable(st
 	unsigned long flags;
 	unsigned int ucon;
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 
 	ucon = rd_regl(port, S3C2410_UCON);
 	ucon &= ~S3C2410_UCON_RXIRQMODE;
 	wr_regl(port, S3C2410_UCON, ucon);
 
 	ourport->rx_enabled = 0;
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static void s3c24xx_serial_stop_tx(struct uart_port *port)
@@ -344,7 +344,7 @@ static void s3c24xx_serial_tx_dma_comple
 				dma->tx_transfer_addr, dma->tx_size,
 				DMA_TO_DEVICE);
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 
 	uart_xmit_advance(port, count);
 	ourport->tx_in_progress = 0;
@@ -353,7 +353,7 @@ static void s3c24xx_serial_tx_dma_comple
 		uart_write_wakeup(port);
 
 	s3c24xx_serial_start_next_tx(ourport);
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static void enable_tx_dma(struct s3c24xx_uart_port *ourport)
@@ -619,7 +619,7 @@ static void s3c24xx_serial_rx_dma_comple
 	received  = dma->rx_bytes_requested - state.residue;
 	async_tx_ack(dma->rx_desc);
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 
 	if (received)
 		s3c24xx_uart_copy_rx_to_tty(ourport, t, received);
@@ -631,7 +631,7 @@ static void s3c24xx_serial_rx_dma_comple
 
 	s3c64xx_start_rx_dma(ourport);
 
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static void s3c64xx_start_rx_dma(struct s3c24xx_uart_port *ourport)
@@ -722,7 +722,7 @@ static irqreturn_t s3c24xx_serial_rx_cha
 	utrstat = rd_regl(port, S3C2410_UTRSTAT);
 	rd_regl(port, S3C2410_UFSTAT);
 
-	spin_lock(&port->lock);
+	uart_port_lock(port);
 
 	if (!(utrstat & S3C2410_UTRSTAT_TIMEOUT)) {
 		s3c64xx_start_rx_dma(ourport);
@@ -751,7 +751,7 @@ static irqreturn_t s3c24xx_serial_rx_cha
 	wr_regl(port, S3C2410_UTRSTAT, S3C2410_UTRSTAT_TIMEOUT);
 
 finish:
-	spin_unlock(&port->lock);
+	uart_port_unlock(port);
 
 	return IRQ_HANDLED;
 }
@@ -849,9 +849,9 @@ static irqreturn_t s3c24xx_serial_rx_cha
 	struct s3c24xx_uart_port *ourport = dev_id;
 	struct uart_port *port = &ourport->port;
 
-	spin_lock(&port->lock);
+	uart_port_lock(port);
 	s3c24xx_serial_rx_drain_fifo(ourport);
-	spin_unlock(&port->lock);
+	uart_port_unlock(port);
 
 	return IRQ_HANDLED;
 }
@@ -932,11 +932,11 @@ static irqreturn_t s3c24xx_serial_tx_irq
 	struct s3c24xx_uart_port *ourport = id;
 	struct uart_port *port = &ourport->port;
 
-	spin_lock(&port->lock);
+	uart_port_lock(port);
 
 	s3c24xx_serial_tx_chars(ourport);
 
-	spin_unlock(&port->lock);
+	uart_port_unlock(port);
 	return IRQ_HANDLED;
 }
 
@@ -1032,7 +1032,7 @@ static void s3c24xx_serial_break_ctl(str
 	unsigned long flags;
 	unsigned int ucon;
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 
 	ucon = rd_regl(port, S3C2410_UCON);
 
@@ -1043,7 +1043,7 @@ static void s3c24xx_serial_break_ctl(str
 
 	wr_regl(port, S3C2410_UCON, ucon);
 
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static int s3c24xx_serial_request_dma(struct s3c24xx_uart_port *p)
@@ -1302,7 +1302,7 @@ static int s3c64xx_serial_startup(struct
 	ourport->rx_enabled = 1;
 	ourport->tx_enabled = 0;
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 
 	ufcon = rd_regl(port, S3C2410_UFCON);
 	ufcon |= S3C2410_UFCON_RESETRX | S5PV210_UFCON_RXTRIG8;
@@ -1312,7 +1312,7 @@ static int s3c64xx_serial_startup(struct
 
 	enable_rx_pio(ourport);
 
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 
 	/* Enable Rx Interrupt */
 	s3c24xx_clear_bit(port, S3C64XX_UINTM_RXD, S3C64XX_UINTM);
@@ -1340,7 +1340,7 @@ static int apple_s5l_serial_startup(stru
 	ourport->rx_enabled = 1;
 	ourport->tx_enabled = 0;
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 
 	ufcon = rd_regl(port, S3C2410_UFCON);
 	ufcon |= S3C2410_UFCON_RESETRX | S5PV210_UFCON_RXTRIG8;
@@ -1350,7 +1350,7 @@ static int apple_s5l_serial_startup(stru
 
 	enable_rx_pio(ourport);
 
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 
 	/* Enable Rx Interrupt */
 	s3c24xx_set_bit(port, APPLE_S5L_UCON_RXTHRESH_ENA, S3C2410_UCON);
@@ -1625,7 +1625,7 @@ static void s3c24xx_serial_set_termios(s
 		ulcon |= S3C2410_LCON_PNONE;
 	}
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 
 	dev_dbg(port->dev,
 		"setting ulcon to %08x, brddiv to %d, udivslot %08x\n",
@@ -1683,7 +1683,7 @@ static void s3c24xx_serial_set_termios(s
 	if ((termios->c_cflag & CREAD) == 0)
 		port->ignore_status_mask |= RXSTAT_DUMMY_READ;
 
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static const char *s3c24xx_serial_type(struct uart_port *port)
@@ -2375,14 +2375,14 @@ s3c24xx_serial_console_write(struct cons
 	if (cons_uart->sysrq)
 		locked = false;
 	else if (oops_in_progress)
-		locked = spin_trylock_irqsave(&cons_uart->lock, flags);
+		locked = uart_port_trylock_irqsave(cons_uart, &flags);
 	else
-		spin_lock_irqsave(&cons_uart->lock, flags);
+		uart_port_lock_irqsave(cons_uart, &flags);
 
 	uart_console_write(cons_uart, s, count, s3c24xx_serial_console_putchar);
 
 	if (locked)
-		spin_unlock_irqrestore(&cons_uart->lock, flags);
+		uart_port_unlock_irqrestore(cons_uart, flags);
 }
 
 /* Shouldn't be __init, as it can be instantiated from other module */


