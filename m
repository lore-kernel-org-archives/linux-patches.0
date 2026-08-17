Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AC84457A3;
	Mon, 17 Aug 2026 13:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975114; cv=none; b=W/TycrBaSJ7EJMkXzvyJHzsYpOUxvBV6chV6RqeM3Yxls3LtV5islIHLT67vzBrTX9itPDAXmVEL7slFgmfRquxcNi/liekvcmAD/udNdg0tCxnUI4gUSwf2DUjo+1s8Lvz8ElMiXFQF80A5M43pxYo73kuc52BnTmaAWzKHb+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975114; c=relaxed/simple;
	bh=mcSngFKCsEZc90OszOwwA20ks90KEZ71jWTq+VS7RWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqCQ9EAf4tx5wOZfLmWOEWfIsMU0IkfQcSOb/5PcdL0Qeer6WWBXjBecPNGu78vUU6i6BJZc2gw4yaN9S9nSzm8lhEX3xD/OuuLeKF9OicaTvQKHD4QpbXFstTxmqDDXO3dR1cf33KRlamHpIt8dcLf4KzIEXqZZwZzCm8gadsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+tyAvCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+tyAvCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4361F00A3A;
	Mon, 17 Aug 2026 13:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975113;
	bh=1fPMm4wBolAsktAMvdJo4Q8iSwWdNNKGPJ6DIcVrgCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+tyAvCq5mXQQJhZF6/+IpZVXN2VGGwrWzTK7zGUUi7shMI+ldvt4JLnm4W/7Dxe8
	 sAEpVWgFs+ZFIiRnHLMjp5lr9Tj9uUL0nmpYqSi0zM+IKWW9Egjb4pmV6Jw0zd8UlE
	 /YPH8RZoAgdHkDEj2lrB+wqwWZ9gJuPt2Vvdo/d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH 6.18 168/250] serial: amba-pl011: cancel RS485 hrtimers after freeing IRQ
Date: Mon, 17 Aug 2026 15:32:09 +0200
Message-ID: <20260817132543.499996037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 36672c8d7d14e9c43287528455d2c97b526ea6ad upstream.

The RS485 trigger hrtimers are embedded in the devm-managed port and can
fire after it is freed. The IRQ handler can arm a timer, so free the IRQ
first and then cancel both timers.

Complete the RS485 stop without arming a timer, and cancel the timers
in remove() for the suspend-then-unbind path, where shutdown is not
called.

This issue was found by an in-house static analysis tool.

Fixes: 2c1fd53af21b ("serial: amba-pl011: Fix RTS handling in RS485 mode")
Cc: stable <stable@kernel.org>
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260731085915.326775-3-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |   52 ++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 17 deletions(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1269,11 +1269,30 @@ static inline bool pl011_dma_rx_running(
 #define pl011_dma_flush_buffer	NULL
 #endif
 
-static void pl011_rs485_tx_stop(struct uart_amba_port *uap)
+static void pl011_rs485_tx_stop_now(struct uart_amba_port *uap)
 {
 	struct uart_port *port = &uap->port;
 	u32 cr;
 
+	cr = pl011_read(uap, REG_CR);
+
+	if (port->rs485.flags & SER_RS485_RTS_AFTER_SEND)
+		cr &= ~UART011_CR_RTS;
+	else
+		cr |= UART011_CR_RTS;
+
+	/* Disable the transmitter and reenable the transceiver */
+	cr &= ~UART011_CR_TXE;
+	cr |= UART011_CR_RXE;
+	pl011_write(cr, uap, REG_CR);
+
+	uap->rs485_tx_state = OFF;
+}
+
+static void pl011_rs485_tx_stop(struct uart_amba_port *uap)
+{
+	struct uart_port *port = &uap->port;
+
 	if (uap->rs485_tx_state == SEND)
 		uap->rs485_tx_state = WAIT_AFTER_SEND;
 
@@ -1297,19 +1316,7 @@ static void pl011_rs485_tx_stop(struct u
 		hrtimer_try_to_cancel(&uap->trigger_start_tx);
 	}
 
-	cr = pl011_read(uap, REG_CR);
-
-	if (port->rs485.flags & SER_RS485_RTS_AFTER_SEND)
-		cr &= ~UART011_CR_RTS;
-	else
-		cr |= UART011_CR_RTS;
-
-	/* Disable the transmitter and reenable the transceiver */
-	cr &= ~UART011_CR_TXE;
-	cr |= UART011_CR_RXE;
-	pl011_write(cr, uap, REG_CR);
-
-	uap->rs485_tx_state = OFF;
+	pl011_rs485_tx_stop_now(uap);
 }
 
 static void pl011_stop_tx(struct uart_port *port)
@@ -2019,11 +2026,20 @@ static void pl011_shutdown(struct uart_p
 
 	pl011_dma_shutdown(uap);
 
-	if ((port->rs485.flags & SER_RS485_ENABLED && uap->rs485_tx_state != OFF))
-		pl011_rs485_tx_stop(uap);
-
 	free_irq(uap->port.irq, uap);
 
+	/*
+	 * free_irq() drains the UART interrupt handler, which can arm either
+	 * timer.  Cancel the timers afterwards to drain their callbacks too.
+	 */
+	hrtimer_cancel(&uap->trigger_start_tx);
+	hrtimer_cancel(&uap->trigger_stop_tx);
+
+	uart_port_lock_irq(port);
+	if (uap->rs485_tx_state != OFF)
+		pl011_rs485_tx_stop_now(uap);
+	uart_port_unlock_irq(port);
+
 	pl011_disable_uart(uap);
 
 	/*
@@ -2941,6 +2957,8 @@ static void pl011_remove(struct amba_dev
 	struct uart_amba_port *uap = amba_get_drvdata(dev);
 
 	uart_remove_one_port(&amba_reg, &uap->port);
+	hrtimer_cancel(&uap->trigger_start_tx);
+	hrtimer_cancel(&uap->trigger_stop_tx);
 	pl011_unregister_port(uap);
 }
 


