Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216104;
	b=fHOJYoza/dAXoPAsSh+yZJYSd2Rk4MkBZkHRm+eioEmmU+hryPp2Xsy8Q5GSn1bS1x0w
	 zO6M9BmW2p/IFBxzstTEeyKJEgN93Ay2iP4BngV42A6oupx862ZRn4/HN1Wg1pjo6AlLY
	 fvn4Rey41NjUmAxVhC+V/gYlIG6uysBC9rd2ccAXIBQMT9j7VT9FLEuvwjyOfqyaWpUwN
	 97SZhu/D2hYFo1HGLbznvvQV0B5POGwhLot4geAfWgkeWSecjFiI1AVRjfi7GVcbflY9I
	 6aBLl0vwc12bk/LR9AsnFboCplmhYhDumtlG1TJGZKclNxOS23zCtrpe398M58twIZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vMeJaZuqvsJTQUXNFHwOGWAIBxm7PEeoZthZgnS/Auc=;
	b=jtcIGeFeJ6gK+XVWTR8HTADODWlUw35CKJtmDzQxW/xzrD/PRNPOn//vnXOv04t+nfhA
	 rYI7WgzJRfk1OLivwgCOoWcHAOwSODj9IiAYaVxwG3lVQ44Bo6N6QmKCOa28rXHxar+eD
	 2wPzYG3fJfusR9F1GY1Hm6UvtW6Km8o5hu5R8+6D6L59luT4Myo6FcVXEsZSVoP4VRHh/
	 nXBIICYs9k+XptuarU9p+yXCNUAX3GaQW5RmwKDHzsCdV2shG99iKey66Z4LMoMTGuqUo
	 xCKI5kTOYEPOBoW6PXJppr3hK+CzzFWg8F/TWPDPagn+HjCHBHUHp9gsT4SZWmVux3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUEylZUu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CF5606A31A;
	Wed, 28 Oct 2026 19:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUEylZUu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BD61F01825;
	Wed, 28 Oct 2026 19:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216104;
	bh=vMeJaZuqvsJTQUXNFHwOGWAIBxm7PEeoZthZgnS/Auc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUEylZUuIw1SiT4JYB6HmO2oFExBBVycWhNxAVXaEHezWuVPDytmPn9jn5B/1FG1O
	 ZSH4m7vFh6l9wVnP5PybAzu78anVVpgj0Dihn7xNCxEklIodRaig1gcAUeu0FU00hb
	 N5/jHPM/SwuXFZMGBdvCj4Kgzys9WyK9FHPqSMlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1441/1887] serial: sc16is7xx: fix TX fifo corruption
Date: Wed, 28 Oct 2026 17:58:57 +0100
Message-ID: <20261028170532.250871011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/tty/serial/sc16is7xx.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index f0ba5a930b2c3..7e2f48ea0f331 100644
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
@@ -384,15 +384,13 @@ static void sc16is7xx_port_write(struct uart_port *port, u8 reg, u8 val)
 
 static void sc16is7xx_fifo_read(struct uart_port *port, unsigned int rxlen)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
-	regmap_noinc_read(one->regmap, SC16IS7XX_RHR_REG, s->buf, rxlen);
+	regmap_noinc_read(one->regmap, SC16IS7XX_RHR_REG, one->buf, rxlen);
 }
 
 static void sc16is7xx_fifo_write(struct uart_port *port, u8 to_send)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
 	/*
@@ -402,7 +400,7 @@ static void sc16is7xx_fifo_write(struct uart_port *port, u8 to_send)
 	if (unlikely(!to_send))
 		return;
 
-	regmap_noinc_write(one->regmap, SC16IS7XX_THR_REG, s->buf, to_send);
+	regmap_noinc_write(one->regmap, SC16IS7XX_THR_REG, one->buf, to_send);
 }
 
 static void sc16is7xx_port_update(struct uart_port *port, u8 reg,
@@ -619,17 +617,17 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
 				unsigned int iir)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 	unsigned int lsr = 0, ch, flag, bytes_read, i;
 	bool read_lsr = (iir == SC16IS7XX_IIR_RLSE_SRC) ? true : false;
 
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
@@ -642,7 +640,7 @@ static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
 			lsr = 0;
 
 		if (read_lsr) {
-			s->buf[0] = sc16is7xx_port_read(port, SC16IS7XX_RHR_REG);
+			one->buf[0] = sc16is7xx_port_read(port, SC16IS7XX_RHR_REG);
 			bytes_read = 1;
 		} else {
 			sc16is7xx_fifo_read(port, rxlen);
@@ -678,7 +676,7 @@ static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
 		}
 
 		for (i = 0; i < bytes_read; ++i) {
-			ch = s->buf[i];
+			ch = one->buf[i];
 			if (uart_handle_sysrq_char(port, ch))
 				continue;
 
@@ -696,7 +694,7 @@ static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
 
 static void sc16is7xx_handle_tx(struct uart_port *port)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 	struct circ_buf *xmit = &port->state->xmit;
 	unsigned int txlen, to_send, i;
 	unsigned long flags;
@@ -733,7 +731,7 @@ static void sc16is7xx_handle_tx(struct uart_port *port)
 
 		/* Convert to linear buffer */
 		for (i = 0; i < to_send; ++i) {
-			s->buf[i] = xmit->buf[xmit->tail];
+			one->buf[i] = xmit->buf[xmit->tail];
 			xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		}
 
-- 
2.53.0



