Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2092D8378;
	Sun,  7 Jun 2026 10:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829322; cv=none; b=GAsjmDQW6ONybsU8OMsDRsgAcNoKiSOwt4hqqRPj9nr4wv7xHufQAAPyIV4Fiij0gSS8ya1mIROEYW0b6gczTb4GQ2IBBXCqKWorb3vHoEhUffXkUIaaRqC8/ZxLFtz1rTR0HNMiA0LdEHdUPXoBIZfA2HZPjT7/XrKCubnrSkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829322; c=relaxed/simple;
	bh=N+ETN/j9mhfgG3dIgNOaVIUTQ+qHuDCweLQGx0kHCQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BB3Rkbh+qpLn+cMFVU945FATMUBdKbdwAlMKn0HbmSW7Gx5qymKLAHKIRZHfCUC6NhFcv3vUOFsDkc7CEEuHdJ4Tm0pmF2QmljcSsIBnx+/IaLV7uKNdG/XyLul6djtEi3RwZlb08UoGb/hEP8GYESbVLvNXMCWLSSN6UbyScX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fScPbgun; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fScPbgun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C88E1F00893;
	Sun,  7 Jun 2026 10:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829321;
	bh=d7pn3Qu/ZGUe5J76k8QzLa24DWVlzjZ0DUTASN74fQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fScPbgun7ozwIJGtW63Adc93N1gR7wusjlGlyzZj4iIBbtnBmfjHAT/Y4sIhi9IIZ
	 FmQCEirajzTdca2ljrQ81+J6TzbzpZ/7hmKeHEKfbYfRUw122UsNy2FQAgAj96RQcE
	 T2A2kp9YVI4RLR35XT1DHhBQeGzmbku6RNi406TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 6.12 214/307] tty: serial: samsung: Remove redundant port lock acquisition in rx helpers
Date: Sun,  7 Jun 2026 12:00:11 +0200
Message-ID: <20260607095735.583551579@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
Message-ID: <20260607100011.2EBOcX2gE4-DwQi_6-PPVg20boXpc93mjwZCo0ui3Gk@z>

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -243,12 +243,9 @@ static bool s3c24xx_serial_txempty_nofif
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
 
@@ -261,23 +258,18 @@ static void s3c24xx_serial_rx_enable(str
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


