Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5C51494B8;
	Mon, 12 Aug 2024 16:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480486; cv=none; b=rRy5qltfk6JskPVC59buis7e06tsLc9YZ6oiMfh5DBs4gaQkMEXbbI5YZKz+bE93G2JjeFXzqSDfQi+thUyic+KfUwH3VF9zO1UUhJeILFClVcc9qds41aUFsEdE+gfr9BMPQ06yQAKh0AJqjR0IMDRYtgvqpRmoBCY9K7qHvEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480486; c=relaxed/simple;
	bh=5MfL1MD6qAaHz2JejL/yyizEx4f6aiIPKs+bo56NXVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbBPzWNMgbYYbRwQUzvE4881YO8PIeOOnlbOLRMLeLLZ+dGIE3Asv6wSEi1I4p3O7Kuydu2t1AogwRvx+dy8jAKuKFgBBsmz6Q0jbZ1q8zq7avTjss95oWMDYeCEpX6s494amtVyAESe19P6UmGcNIEUHEcyICRBMT6NPqzO2Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwoC9bk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwoC9bk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA61C32782;
	Mon, 12 Aug 2024 16:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480486;
	bh=5MfL1MD6qAaHz2JejL/yyizEx4f6aiIPKs+bo56NXVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwoC9bk1fm+GMHJlxzkmlh3SXQLgoaz2URihOCyvjd/ubZM/ivkWZ245XcVoCko0l
	 GWpn7g7KNXebH0tE8bmo0Fko2/fGiKmzsAMzjyhs21hPuMQrzF/ZSffNk9TVjZRiTj
	 yL3VLJDM1mE6onNivKcpD62FhZ1a/pSx2mn5L8do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.10 210/263] serial: sc16is7xx: fix TX fifo corruption
Date: Mon, 12 Aug 2024 18:03:31 +0200
Message-ID: <20240812160154.584199099@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 133f4c00b8b2bfcacead9b81e7e8edfceb4b06c4 upstream.

Sometimes, when a packet is received on channel A at almost the same time
as a packet is about to be transmitted on channel B, we observe with a
logic analyzer that the received packet on channel A is transmitted on
channel B. In other words, the Tx buffer data on channel B is corrupted
with data from channel A.

The problem appeared since commit 4409df5866b7 ("serial: sc16is7xx: change
EFR lock to operate on each channels"), which changed the EFR locking to
operate on each channel instead of chip-wise.

This commit has introduced a regression, because the EFR lock is used not
only to protect the EFR registers access, but also, in a very obscure and
undocumented way, to protect access to the data buffer, which is shared by
the Tx and Rx handlers, but also by each channel of the IC.

Fix this regression first by switching to kfifo_out_linear_ptr() in
sc16is7xx_handle_tx() to eliminate the need for a shared Rx/Tx buffer.

Secondly, replace the chip-wise Rx buffer with a separate Rx buffer for
each channel.

Fixes: 4409df5866b7 ("serial: sc16is7xx: change EFR lock to operate on each channels")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240723125302.1305372-2-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -326,6 +326,7 @@ struct sc16is7xx_one {
 	struct kthread_work		reg_work;
 	struct kthread_delayed_work	ms_work;
 	struct sc16is7xx_one_config	config;
+	unsigned char			buf[SC16IS7XX_FIFO_SIZE]; /* Rx buffer. */
 	unsigned int			old_mctrl;
 	u8				old_lcr; /* Value before EFR access. */
 	bool				irda_mode;
@@ -339,7 +340,6 @@ struct sc16is7xx_port {
 	unsigned long			gpio_valid_mask;
 #endif
 	u8				mctrl_mask;
-	unsigned char			buf[SC16IS7XX_FIFO_SIZE];
 	struct kthread_worker		kworker;
 	struct task_struct		*kworker_task;
 	struct sc16is7xx_one		p[];
@@ -611,18 +611,18 @@ static int sc16is7xx_set_baud(struct uar
 static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
 				unsigned int iir)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 	unsigned int lsr = 0, bytes_read, i;
 	bool read_lsr = (iir == SC16IS7XX_IIR_RLSE_SRC) ? true : false;
 	u8 ch, flag;
 
-	if (unlikely(rxlen >= sizeof(s->buf))) {
+	if (unlikely(rxlen >= sizeof(one->buf))) {
 		dev_warn_ratelimited(port->dev,
 				     "ttySC%i: Possible RX FIFO overrun: %d\n",
 				     port->line, rxlen);
 		port->icount.buf_overrun++;
 		/* Ensure sanity of RX level */
-		rxlen = sizeof(s->buf);
+		rxlen = sizeof(one->buf);
 	}
 
 	while (rxlen) {
@@ -635,10 +635,10 @@ static void sc16is7xx_handle_rx(struct u
 			lsr = 0;
 
 		if (read_lsr) {
-			s->buf[0] = sc16is7xx_port_read(port, SC16IS7XX_RHR_REG);
+			one->buf[0] = sc16is7xx_port_read(port, SC16IS7XX_RHR_REG);
 			bytes_read = 1;
 		} else {
-			sc16is7xx_fifo_read(port, s->buf, rxlen);
+			sc16is7xx_fifo_read(port, one->buf, rxlen);
 			bytes_read = rxlen;
 		}
 
@@ -671,7 +671,7 @@ static void sc16is7xx_handle_rx(struct u
 		}
 
 		for (i = 0; i < bytes_read; ++i) {
-			ch = s->buf[i];
+			ch = one->buf[i];
 			if (uart_handle_sysrq_char(port, ch))
 				continue;
 
@@ -689,10 +689,10 @@ static void sc16is7xx_handle_rx(struct u
 
 static void sc16is7xx_handle_tx(struct uart_port *port)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	struct tty_port *tport = &port->state->port;
 	unsigned long flags;
 	unsigned int txlen;
+	unsigned char *tail;
 
 	if (unlikely(port->x_char)) {
 		sc16is7xx_port_write(port, SC16IS7XX_THR_REG, port->x_char);
@@ -717,8 +717,9 @@ static void sc16is7xx_handle_tx(struct u
 		txlen = 0;
 	}
 
-	txlen = uart_fifo_out(port, s->buf, txlen);
-	sc16is7xx_fifo_write(port, s->buf, txlen);
+	txlen = kfifo_out_linear_ptr(&tport->xmit_fifo, &tail, txlen);
+	sc16is7xx_fifo_write(port, tail, txlen);
+	uart_xmit_advance(port, txlen);
 
 	uart_port_lock_irqsave(port, &flags);
 	if (kfifo_len(&tport->xmit_fifo) < WAKEUP_CHARS)


