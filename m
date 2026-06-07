Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073C22DFF04;
	Sun,  7 Jun 2026 10:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829149; cv=none; b=dHo9nttdtanj27jCiQGWViAgWjTauEQBH5fzgtewMfy418vBZ6y2TZ+povTeWMWmdzMHrKS3V3De0fTzkEr4Snng/gKZVppdGllrllTKxmbkl/O1a3DOxPa3ydSE5Zc8UMA1QWTxxeiGA0x3ZkSvxP7grzu3aXZAN7ZqZznXvg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829149; c=relaxed/simple;
	bh=ImW1mgwrhGoCzLp51XDvCPq5oc8e0UT1CNZUoijJ4Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dy9sZgt5uDZ9nS7OB1P32sTIUU5bTO04eP5DT2gILzPwY+UIv4vmJh7BKvXFZ2zRuFeLCAELLahV+4v0vkSxIiHzcJ6OiYMbudmOtoESSZidY4Mu0lQaD/6H5/V8VPasK1Gn92muWAiNkvIrQjaThF0leYZHtTEdu4/q/j07l38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dn1T+xWI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dn1T+xWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C21D1F00893;
	Sun,  7 Jun 2026 10:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829147;
	bh=zX9NcxV1Kt7ii98gXbkvIs+62U4SeKuz4JC8lXAmnJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dn1T+xWI+SuiVt8yY/iPQIS9RogDeAr6YNGDgO/1fcUvYl6945Ra0QR5MXGGYWzBY
	 lS6YXZp+tfQq6o230ScYNl3al0WjxT3d5NqaK82C6OvZKvFjAF1QlLNe8tDFHSdG7y
	 ZcTsp//ydr/2O53XC088BTBNpNDROZA5bCJObivU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 7.0 249/332] tty: serial: samsung: Remove redundant port lock acquisition in rx helpers
Date: Sun,  7 Jun 2026 12:00:18 +0200
Message-ID: <20260607095737.193805815@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

commit a3bb136bff5e6a5e48cdd813246c9c4686feaaa9 upstream.

Sashiko identified a deadlock when the console flow is engaged [1].

When console flow control is enabled (UPF_CONS_FLOW),
s3c24xx_serial_stop_tx() calls s3c24xx_serial_rx_enable() and
s3c24xx_serial_start_tx() calls s3c24xx_serial_rx_disable().

The serial core framework invokes the .stop_tx() and .start_tx()
callbacks with the port->lock spinlock already held. Furthermore, all
internal driver paths that invoke stop_tx (such as the DMA TX
completion handler s3c24xx_serial_tx_dma_complete() or the PIO TX IRQ
handler s3c24xx_serial_tx_irq()) also acquire port->lock prior to
calling it. (Note that s3c24xx_serial_start_tx() is only invoked by the
serial core).

However, s3c24xx_serial_rx_enable() and s3c24xx_serial_rx_disable()
unconditionally attempt to acquire port->lock again using
uart_port_lock_irqsave(). Since spinlocks are not recursive, this
causes a deadlock on the same CPU when console flow control is engaged.

Remove the redundant lock acquisition from both rx helper functions.

Cc: stable <stable@kernel.org>
Fixes: b497549a035c ("[ARM] S3C24XX: Split serial driver into core and per-cpu drivers")
Reported-by: John Ogness <john.ogness@linutronix.de>
Closes: https://sashiko.dev/#/patchset/20260506121606.5805-1-john.ogness%40linutronix.de [1]
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://patch.msgid.link/20260515-samsung-tty-flow-control-deadlock-v1-1-93255edbc9bc@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/samsung_tty.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/tty/serial/samsung_tty.c
+++ b/drivers/tty/serial/samsung_tty.c
@@ -245,12 +245,9 @@ static bool s3c24xx_serial_txempty_nofif
 static void s3c24xx_serial_rx_enable(struct uart_port *port)
 {
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
-	unsigned long flags;
 	int count = 10000;
 	u32 ucon, ufcon;
 
-	uart_port_lock_irqsave(port, &flags);
-
 	while (--count && !s3c24xx_serial_txempty_nofifo(port))
 		udelay(100);
 
@@ -263,23 +260,18 @@ static void s3c24xx_serial_rx_enable(str
 	wr_regl(port, S3C2410_UCON, ucon);
 
 	ourport->rx_enabled = 1;
-	uart_port_unlock_irqrestore(port, flags);
 }
 
 static void s3c24xx_serial_rx_disable(struct uart_port *port)
 {
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
-	unsigned long flags;
 	u32 ucon;
 
-	uart_port_lock_irqsave(port, &flags);
-
 	ucon = rd_regl(port, S3C2410_UCON);
 	ucon &= ~S3C2410_UCON_RXIRQMODE;
 	wr_regl(port, S3C2410_UCON, ucon);
 
 	ourport->rx_enabled = 0;
-	uart_port_unlock_irqrestore(port, flags);
 }
 
 static void s3c24xx_serial_stop_tx(struct uart_port *port)


