Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5F437A858;
	Thu, 20 Aug 2026 16:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244448; cv=none; b=Mlsxh3RV7l+SR+ChfgWQQNSufd7RANn1Jwn34BuiBoEgolBxKC8hMkehHmzFsrMCrLt9qMynPThn6ZreoT02j8Fhttb7p+zOK1k0XcvudYHsXFRgFrXj4MjQE4kkIoCHHeSnBcgeW45sbtjGYVncl3OCKfFN8iUJU/cyGc3/0L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244448; c=relaxed/simple;
	bh=PIMok5oxb53f23C/4xCQQnX2onsCoPo+I2lUVHqse9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RcVC4mKsDhskN2KVryI9VCDgrnI4eg61qx7Jr9LsTSwedI90o58R9tRP8dpMMgwhC8XC1vB9NSFxM/6P4I1L9mb07eV30ePxmOXcZw5kbLIdUsdDpNs21PTPtffXCGAYa0KbqiPffGDc9NlRUYxPw/U+llArGSaoy4AQdmvo9HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cc0dR2JW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cc0dR2JW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9F51F000E9;
	Thu, 20 Aug 2026 16:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244447;
	bh=1lEDw2Sr6dAD3Za8bsB4vaexOlbRsBOayD3ew1Wn1nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cc0dR2JWnv4PJKLXoMZzdN/P1MM6INhJgifUa5GTRec94fRzf63ZSMM+FT/wxYodo
	 gQhBqRpf9yL1BUQ07k/JOe3spVmHpXzNdXJFIXJ2BkPFiuDO4orX+3D0M19oVqK5Rb
	 xxaWpVY8qtTc9DdtxQc4JAtn1g6cngsvhrcTWf7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Mo=C5=84?= <tomasz.mon@camlingroup.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/235] sc16is7xx: Properly resume TX after stop
Date: Thu, 20 Aug 2026 16:56:47 +0200
Message-ID: <20260820145221.686689868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Moń <tomasz.mon@camlingroup.com>

[ Upstream commit cc4c1d05eb10c3ad4c6315f1897bc56b1e7429aa ]

sc16is7xx_stop_tx() clears THRI bit and thus disables THRI interrupt.
This makes it possible for transmission to cease indefinitely when more
than 64 characters are being sent.

The sc16is7xx_handle_tx() call executed by sc16is7xx_tx_proc() can send
up to FIFO length (64) characters. If more characters are written to the
output buffer, then the THRI interrupt is needed.

Solve the issue by enabling THRI interrupt in sc16is7xx_tx_proc().

Signed-off-by: Tomasz Moń <tomasz.mon@camlingroup.com>
Link: https://lore.kernel.org/r/20220301060332.2561851-2-tomasz.mon@camlingroup.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: af071d9e07e5 ("serial: sc16is7xx: implement gpio get_direction() callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   47 +++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -307,7 +307,8 @@ struct sc16is7xx_devtype {
 
 struct sc16is7xx_one_config {
 	unsigned int			flags;
-	u8				ier_clear;
+	u8				ier_mask;
+	u8				ier_val;
 };
 
 struct sc16is7xx_one {
@@ -341,6 +342,9 @@ static struct uart_driver sc16is7xx_uart
 	.nr		= SC16IS7XX_MAX_DEVS,
 };
 
+static void sc16is7xx_ier_set(struct uart_port *port, u8 bit);
+static void sc16is7xx_stop_tx(struct uart_port *port);
+
 #define to_sc16is7xx_port(p,e)	((container_of((p), struct sc16is7xx_port, e)))
 #define to_sc16is7xx_one(p,e)	((container_of((p), struct sc16is7xx_one, e)))
 
@@ -650,6 +654,7 @@ static void sc16is7xx_handle_tx(struct u
 	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	struct circ_buf *xmit = &port->state->xmit;
 	unsigned int txlen, to_send, i;
+	unsigned long flags;
 
 	if (unlikely(port->x_char)) {
 		sc16is7xx_port_write(port, SC16IS7XX_THR_REG, port->x_char);
@@ -658,8 +663,12 @@ static void sc16is7xx_handle_tx(struct u
 		return;
 	}
 
-	if (uart_circ_empty(xmit) || uart_tx_stopped(port))
+	if (uart_circ_empty(xmit) || uart_tx_stopped(port)) {
+		spin_lock_irqsave(&port->lock, flags);
+		sc16is7xx_stop_tx(port);
+		spin_unlock_irqrestore(&port->lock, flags);
 		return;
+	}
 
 	/* Get length of data pending in circular buffer */
 	to_send = uart_circ_chars_pending(xmit);
@@ -686,8 +695,13 @@ static void sc16is7xx_handle_tx(struct u
 		sc16is7xx_fifo_write(port, to_send);
 	}
 
+	spin_lock_irqsave(&port->lock, flags);
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
+
+	if (uart_circ_empty(xmit))
+		sc16is7xx_stop_tx(port);
+	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static bool sc16is7xx_port_irq(struct sc16is7xx_port *s, int portno)
@@ -762,6 +776,7 @@ static void sc16is7xx_tx_proc(struct kth
 {
 	struct uart_port *port = &(to_sc16is7xx_one(ws, tx_work)->port);
 	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
+	unsigned long flags;
 
 	if ((port->rs485.flags & SER_RS485_ENABLED) &&
 	    (port->rs485.delay_rts_before_send > 0))
@@ -770,6 +785,10 @@ static void sc16is7xx_tx_proc(struct kth
 	mutex_lock(&s->efr_lock);
 	sc16is7xx_handle_tx(port);
 	mutex_unlock(&s->efr_lock);
+
+	spin_lock_irqsave(&port->lock, flags);
+	sc16is7xx_ier_set(port, SC16IS7XX_IER_THRI_BIT);
+	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static void sc16is7xx_reconf_rs485(struct uart_port *port)
@@ -819,7 +838,7 @@ static void sc16is7xx_reg_proc(struct kt
 	}
 	if (config.flags & SC16IS7XX_RECONF_IER)
 		sc16is7xx_port_update(&one->port, SC16IS7XX_IER_REG,
-				      config.ier_clear, 0);
+				      config.ier_mask, config.ier_val);
 
 	if (config.flags & SC16IS7XX_RECONF_RS485)
 		sc16is7xx_reconf_rs485(&one->port);
@@ -830,8 +849,24 @@ static void sc16is7xx_ier_clear(struct u
 	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
+	lockdep_assert_held_once(&port->lock);
+
+	one->config.flags |= SC16IS7XX_RECONF_IER;
+	one->config.ier_mask |= bit;
+	one->config.ier_val &= ~bit;
+	kthread_queue_work(&s->kworker, &one->reg_work);
+}
+
+static void sc16is7xx_ier_set(struct uart_port *port, u8 bit)
+{
+	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
+
+	lockdep_assert_held_once(&port->lock);
+
 	one->config.flags |= SC16IS7XX_RECONF_IER;
-	one->config.ier_clear |= bit;
+	one->config.ier_mask |= bit;
+	one->config.ier_val |= bit;
 	kthread_queue_work(&s->kworker, &one->reg_work);
 }
 
@@ -1059,8 +1094,8 @@ static int sc16is7xx_startup(struct uart
 			      SC16IS7XX_EFCR_TXDISABLE_BIT,
 			      0);
 
-	/* Enable RX, TX interrupts */
-	val = SC16IS7XX_IER_RDI_BIT | SC16IS7XX_IER_THRI_BIT;
+	/* Enable RX interrupt */
+	val = SC16IS7XX_IER_RDI_BIT;
 	sc16is7xx_port_write(port, SC16IS7XX_IER_REG, val);
 
 	return 0;


