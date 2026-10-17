Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D927E356A12;
	Sat, 17 Oct 2026 17:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257674; cv=none; b=iu4Tiyx1Q6rCHUYxGLYUA46yhlffaAAHNV4O5q3+/IaFBZz86iPuuxajrwLdsNNj17fOHlv/+WmPU1wJ9GGCmw1xee1UznWTOjADdc4uqYGlYdDgSB1kvmj8AVtUgQxGbXS5eB6dC/EBnxq9no2sexXfj763OxYoFoem8nKWHyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257674; c=relaxed/simple;
	bh=2aMWHHs4tTyfxbRoANxWNb2wF96/wLmB8c/4DdV+OKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFgD7PDwNdpOz4wTdDVaiR3r5xH23zph4zRS02wAa3x3RUdqKnub19wCV7nFll4wFvF8k2hkH0x3wSasjXX7cl02wI0ExzqhsvB7J0NJpS7hSRDOjNJMhWYOPFKpGRj7drYwIAkRXTjLQIpvTr4q6+dMd5XCy99i3HJI7hWaDXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfLwuhVq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfLwuhVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71381F000C4;
	Sat, 17 Oct 2026 17:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257672;
	bh=Spl6ZnlWm4ffPAZ8smZOVZ0MQgXlprmiGCczRiUN6XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfLwuhVqJhgqPnZz4ov8G4zDeDCzN+VbFmjY1ZHCXIkdzmANW/ohk4epJ7/quvhZZ
	 Dtszvd1HeDWz9/h6c/pdvDGEzu6jb8C2Dhab3cq8rFnDE4QJoT4X2ybqN8hVEpfMLG
	 5YxTOnu5PhRnzK2SL2iMTsL5vCED+FOW93gsbLnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0634/1674] serial: sc16is7xx: fix TX fifo corruption
Date: Sat, 17 Oct 2026 17:48:26 +0200
Message-ID: <20261017160447.369080296@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 133f4c00b8b2bfcacead9b81e7e8edfceb4b06c4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 37 +++++++++++++++-------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 02b74a695c8e0..ac2380978ae70 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -336,6 +336,7 @@ struct sc16is7xx_one {
 	struct kthread_work		reg_work;
 	struct kthread_delayed_work	ms_work;
 	struct sc16is7xx_one_config	config;
+	unsigned char			buf[SC16IS7XX_FIFO_SIZE]; /* Rx buffer. */
 	unsigned int			old_mctrl;
 	u8				old_lcr; /* Value before EFR access. */
 	bool				irda_mode;
@@ -349,7 +350,6 @@ struct sc16is7xx_port {
 	unsigned long			gpio_valid_mask;
 #endif
 	u8				mctrl_mask;
-	unsigned char			buf[SC16IS7XX_FIFO_SIZE];
 	struct kthread_worker		kworker;
 	struct task_struct		*kworker_task;
 	struct sc16is7xx_one		p[];
@@ -382,17 +382,15 @@ static void sc16is7xx_port_write(struct uart_port *port, u8 reg, u8 val)
 	regmap_write(one->regmap, reg, val);
 }
 
-static void sc16is7xx_fifo_read(struct uart_port *port, unsigned int rxlen)
+static void sc16is7xx_fifo_read(struct uart_port *port, u8 *rxbuf, unsigned int rxlen)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
-	regmap_noinc_read(one->regmap, SC16IS7XX_RHR_REG, s->buf, rxlen);
+	regmap_noinc_read(one->regmap, SC16IS7XX_RHR_REG, rxbuf, rxlen);
 }
 
-static void sc16is7xx_fifo_write(struct uart_port *port, u8 to_send)
+static void sc16is7xx_fifo_write(struct uart_port *port, u8 *txbuf, u8 to_send)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
 	/*
@@ -402,7 +400,7 @@ static void sc16is7xx_fifo_write(struct uart_port *port, u8 to_send)
 	if (unlikely(!to_send))
 		return;
 
-	regmap_noinc_write(one->regmap, SC16IS7XX_THR_REG, s->buf, to_send);
+	regmap_noinc_write(one->regmap, SC16IS7XX_THR_REG, txbuf, to_send);
 }
 
 static void sc16is7xx_port_update(struct uart_port *port, u8 reg,
@@ -618,18 +616,18 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
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
@@ -642,10 +640,10 @@ static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
 			lsr = 0;
 
 		if (read_lsr) {
-			s->buf[0] = sc16is7xx_port_read(port, SC16IS7XX_RHR_REG);
+			one->buf[0] = sc16is7xx_port_read(port, SC16IS7XX_RHR_REG);
 			bytes_read = 1;
 		} else {
-			sc16is7xx_fifo_read(port, rxlen);
+			sc16is7xx_fifo_read(port, one->buf, rxlen);
 			bytes_read = rxlen;
 		}
 
@@ -678,7 +676,7 @@ static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
 		}
 
 		for (i = 0; i < bytes_read; ++i) {
-			ch = s->buf[i];
+			ch = one->buf[i];
 			if (uart_handle_sysrq_char(port, ch))
 				continue;
 
@@ -696,9 +694,8 @@ static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
 
 static void sc16is7xx_handle_tx(struct uart_port *port)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	struct circ_buf *xmit = &port->state->xmit;
-	unsigned int txlen, to_send, i;
+	unsigned int txlen, to_send;
 	unsigned long flags;
 
 	if (unlikely(port->x_char)) {
@@ -728,13 +725,11 @@ static void sc16is7xx_handle_tx(struct uart_port *port)
 		}
 		to_send = (to_send > txlen) ? txlen : to_send;
 
-		/* Convert to linear buffer */
-		for (i = 0; i < to_send; ++i) {
-			s->buf[i] = xmit->buf[xmit->tail];
-			uart_xmit_advance(port, 1);
-		}
+		to_send = min_t(unsigned int, to_send,
+				CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE));
 
-		sc16is7xx_fifo_write(port, to_send);
+		sc16is7xx_fifo_write(port, &xmit->buf[xmit->tail], to_send);
+		uart_xmit_advance(port, to_send);
 	}
 
 	uart_port_lock_irqsave(port, &flags);
-- 
2.53.0



