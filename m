Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2494625E818;
	Tue, 11 Mar 2025 15:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707081; cv=none; b=vBMdNTxNEdSEi7eiKc5NxiGCyMgifz15louu0yo4y8ZCMRNQVpoxSZlEMqu0DLk09xK7KvLI6zTasAJdqeRwUeZgRr7WANgS+TWYZZdrWzEk1jwniMv66K0ADiysg/kYy4djRfwwCHTXluhpMuZ0Uaefy9iWJbk6dwI9v0FXK/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707081; c=relaxed/simple;
	bh=4rYzCf/dtEPlafpSFM3YiC9o3n3r02BPU41s4pAtugQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=do7ATwI0o5mWOuOSWKHWl5NY/fa6CG+9otuy8PCHe4rsSfYfrhUBoy8S9jtwszEw5mQHfH/O2DdEjjxLwDC3XeUOS2FC849wXneiCUHVTl3a+3VxldQQmPVGrH/mu22Tm4yjBNWtxmySvI9w6zgSCx97T4Ki5BXH0rOCTYHMkng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5T6AQrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5T6AQrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51DAC4CEEA;
	Tue, 11 Mar 2025 15:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707081;
	bh=4rYzCf/dtEPlafpSFM3YiC9o3n3r02BPU41s4pAtugQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5T6AQrmylLwKGVexqtyqmnegHyqLWFEgh6u8j7iiix5x8aijgweBh/0LSz7J3CcG
	 i9f8woDmfSTpu/in7s7uy4tRQpehuE1ylQNQKLsvxskaIjuJ/HokIYlkax/TCMxhBY
	 XW5pOvag8EwV85gaNXFJrgQjMIdKorLylZ5zkTT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	John Keeping <jkeeping@inmusicbrands.com>
Subject: [PATCH 5.10 267/462] serial: 8250: Fix fifo underflow on flush
Date: Tue, 11 Mar 2025 15:58:53 +0100
Message-ID: <20250311145808.914735834@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

commit 9e512eaaf8f4008c44ede3dfc0fbc9d9c5118583 upstream.

When flushing the serial port's buffer, uart_flush_buffer() calls
kfifo_reset() but if there is an outstanding DMA transfer then the
completion function will consume data from the kfifo via
uart_xmit_advance(), underflowing and leading to ongoing DMA as the
driver tries to transmit another 2^32 bytes.

This is readily reproduced with serial-generic and amidi sending even
short messages as closing the device on exit will wait for the fifo to
drain and in the underflow case amidi hangs for 30 seconds on exit in
tty_wait_until_sent().  A trace of that gives:

     kworker/1:1-84    [001]    51.769423: bprint:               serial8250_tx_dma: tx_size=3 fifo_len=3
           amidi-763   [001]    51.769460: bprint:               uart_flush_buffer: resetting fifo
 irq/21-fe530000-76    [000]    51.769474: bprint:               __dma_tx_complete: tx_size=3
 irq/21-fe530000-76    [000]    51.769479: bprint:               serial8250_tx_dma: tx_size=4096 fifo_len=4294967293
 irq/21-fe530000-76    [000]    51.781295: bprint:               __dma_tx_complete: tx_size=4096
 irq/21-fe530000-76    [000]    51.781301: bprint:               serial8250_tx_dma: tx_size=4096 fifo_len=4294963197
 irq/21-fe530000-76    [000]    51.793131: bprint:               __dma_tx_complete: tx_size=4096
 irq/21-fe530000-76    [000]    51.793135: bprint:               serial8250_tx_dma: tx_size=4096 fifo_len=4294959101
 irq/21-fe530000-76    [000]    51.804949: bprint:               __dma_tx_complete: tx_size=4096

Since the port lock is held in when the kfifo is reset in
uart_flush_buffer() and in __dma_tx_complete(), adding a flush_buffer
hook to adjust the outstanding DMA byte count is sufficient to avoid the
kfifo underflow.

Fixes: 9ee4b83e51f74 ("serial: 8250: Add support for dmaengine")
Cc: stable <stable@kernel.org>
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Link: https://lore.kernel.org/r/20250208124148.1189191-1-jkeeping@inmusicbrands.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250.h      |    2 ++
 drivers/tty/serial/8250/8250_dma.c  |   16 ++++++++++++++++
 drivers/tty/serial/8250/8250_port.c |    9 +++++++++
 3 files changed, 27 insertions(+)

--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -325,6 +325,7 @@ static inline int is_omap1510_8250(struc
 
 #ifdef CONFIG_SERIAL_8250_DMA
 extern int serial8250_tx_dma(struct uart_8250_port *);
+extern void serial8250_tx_dma_flush(struct uart_8250_port *);
 extern int serial8250_rx_dma(struct uart_8250_port *);
 extern void serial8250_rx_dma_flush(struct uart_8250_port *);
 extern int serial8250_request_dma(struct uart_8250_port *);
@@ -341,6 +342,7 @@ static inline int serial8250_tx_dma(stru
 {
 	return -1;
 }
+static inline void serial8250_tx_dma_flush(struct uart_8250_port *p) { }
 static inline int serial8250_rx_dma(struct uart_8250_port *p)
 {
 	return -1;
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -135,6 +135,22 @@ err:
 	return ret;
 }
 
+void serial8250_tx_dma_flush(struct uart_8250_port *p)
+{
+	struct uart_8250_dma *dma = p->dma;
+
+	if (!dma->tx_running)
+		return;
+
+	/*
+	 * kfifo_reset() has been called by the serial core, avoid
+	 * advancing and underflowing in __dma_tx_complete().
+	 */
+	dma->tx_size = 0;
+
+	dmaengine_terminate_async(dma->rxchan);
+}
+
 int serial8250_rx_dma(struct uart_8250_port *p)
 {
 	struct uart_8250_dma		*dma = p->dma;
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2509,6 +2509,14 @@ static unsigned int npcm_get_divisor(str
 	return DIV_ROUND_CLOSEST(port->uartclk, 16 * baud + 2) - 2;
 }
 
+static void serial8250_flush_buffer(struct uart_port *port)
+{
+	struct uart_8250_port *up = up_to_u8250p(port);
+
+	if (up->dma)
+		serial8250_tx_dma_flush(up);
+}
+
 static unsigned int serial8250_do_get_divisor(struct uart_port *port,
 					      unsigned int baud,
 					      unsigned int *frac)
@@ -3209,6 +3217,7 @@ static const struct uart_ops serial8250_
 	.break_ctl	= serial8250_break_ctl,
 	.startup	= serial8250_startup,
 	.shutdown	= serial8250_shutdown,
+	.flush_buffer	= serial8250_flush_buffer,
 	.set_termios	= serial8250_set_termios,
 	.set_ldisc	= serial8250_set_ldisc,
 	.pm		= serial8250_pm,


