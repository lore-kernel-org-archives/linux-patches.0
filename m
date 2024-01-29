Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCF773721;
	Mon, 29 Jan 2024 17:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548529; cv=none; b=FI2fAwJHeCZ0o+xEQfxT7NkQ2mfaPBVdV/jkKRqSkhm2K0fiJ+ZGeKXgmj+AoD4auHNjhab7dJp4xdvsctagnSh6Vfol4Pdp8HGWsfY4oAq7RyXjmgI6Bmx+81UAJVAWoJa8Cou55FMQP7iDKTyjI8T8swP4jUMTBynrxoLRXkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548529; c=relaxed/simple;
	bh=Ccp/PN58CB4VwlxsfmNVgePQqrahfxiatVdkqU/ODiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GU9d90eThKIa2sdg5zyjPQpTvuYGD505U08/A6MRPajT/SO6aKPSjetZ8XKeYE3Gpa2CtCdJ4fxIUvYqeCBDoA0Miygc7+JTFBhgNln3PA+SB1vbNMfSYD4ipHZs7hK0RZxVIfbtc770pem/KyyG5JTwzsJZN7b+gLPIqrPp54I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSs1DUo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSs1DUo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AA8C433F1;
	Mon, 29 Jan 2024 17:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548529;
	bh=Ccp/PN58CB4VwlxsfmNVgePQqrahfxiatVdkqU/ODiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSs1DUo0gGpfHhpOj4T7W2QaCti6BrA+DPkzJD/cgrTESDHD/49RUbXHCn5j6OqoU
	 PbMZAS9MLW2zJoP35jkqCOFmgE/TKlNLVEpZI4BiMwxud6qlDzZtBnEnwwBdcYG06n
	 sG/P9RsFdU9g8VTMsZXNr9dSL1d814vA/ODv3I2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 6.6 139/331] serial: Do not hold the port lock when setting rx-during-tx GPIO
Date: Mon, 29 Jan 2024 09:03:23 -0800
Message-ID: <20240129170019.012656054@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

commit 07c30ea5861fb26a77dade8cdc787252f6122fb1 upstream.

Both the imx and stm32 driver set the rx-during-tx GPIO in rs485_config().
Since this function is called with the port lock held, this can be a
problem in case that setting the GPIO line can sleep (e.g. if a GPIO
expander is used which is connected via SPI or I2C).

Avoid this issue by moving the GPIO setting outside of the port lock into
the serial core and thus making it a generic feature.

Also with commit c54d48543689 ("serial: stm32: Add support for rs485
RX_DURING_TX output GPIO") the SER_RS485_RX_DURING_TX flag is only set if a
rx-during-tx GPIO is _not_ available, which is wrong. Fix this, too.

Furthermore reset old GPIO settings in case that changing the RS485
configuration failed.

Fixes: c54d48543689 ("serial: stm32: Add support for rs485 RX_DURING_TX output GPIO")
Fixes: ca530cfa968c ("serial: imx: Add support for RS485 RX_DURING_TX output GPIO")
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc:  <stable@vger.kernel.org>
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Link: https://lore.kernel.org/r/20240103061818.564-2-l.sanfilippo@kunbus.com
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c         |    4 ----
 drivers/tty/serial/serial_core.c |   26 ++++++++++++++++++++++++--
 drivers/tty/serial/stm32-usart.c |    8 ++------
 3 files changed, 26 insertions(+), 12 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1947,10 +1947,6 @@ static int imx_uart_rs485_config(struct
 	    rs485conf->flags & SER_RS485_RX_DURING_TX)
 		imx_uart_start_rx(port);
 
-	if (port->rs485_rx_during_tx_gpio)
-		gpiod_set_value_cansleep(port->rs485_rx_during_tx_gpio,
-					 !!(rs485conf->flags & SER_RS485_RX_DURING_TX));
-
 	return 0;
 }
 
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1409,6 +1409,16 @@ static void uart_set_rs485_termination(s
 				 !!(rs485->flags & SER_RS485_TERMINATE_BUS));
 }
 
+static void uart_set_rs485_rx_during_tx(struct uart_port *port,
+					const struct serial_rs485 *rs485)
+{
+	if (!(rs485->flags & SER_RS485_ENABLED))
+		return;
+
+	gpiod_set_value_cansleep(port->rs485_rx_during_tx_gpio,
+				 !!(rs485->flags & SER_RS485_RX_DURING_TX));
+}
+
 static int uart_rs485_config(struct uart_port *port)
 {
 	struct serial_rs485 *rs485 = &port->rs485;
@@ -1420,12 +1430,17 @@ static int uart_rs485_config(struct uart
 
 	uart_sanitize_serial_rs485(port, rs485);
 	uart_set_rs485_termination(port, rs485);
+	uart_set_rs485_rx_during_tx(port, rs485);
 
 	spin_lock_irqsave(&port->lock, flags);
 	ret = port->rs485_config(port, NULL, rs485);
 	spin_unlock_irqrestore(&port->lock, flags);
-	if (ret)
+	if (ret) {
 		memset(rs485, 0, sizeof(*rs485));
+		/* unset GPIOs */
+		gpiod_set_value_cansleep(port->rs485_term_gpio, 0);
+		gpiod_set_value_cansleep(port->rs485_rx_during_tx_gpio, 0);
+	}
 
 	return ret;
 }
@@ -1464,6 +1479,7 @@ static int uart_set_rs485_config(struct
 		return ret;
 	uart_sanitize_serial_rs485(port, &rs485);
 	uart_set_rs485_termination(port, &rs485);
+	uart_set_rs485_rx_during_tx(port, &rs485);
 
 	spin_lock_irqsave(&port->lock, flags);
 	ret = port->rs485_config(port, &tty->termios, &rs485);
@@ -1475,8 +1491,14 @@ static int uart_set_rs485_config(struct
 			port->ops->set_mctrl(port, port->mctrl);
 	}
 	spin_unlock_irqrestore(&port->lock, flags);
-	if (ret)
+	if (ret) {
+		/* restore old GPIO settings */
+		gpiod_set_value_cansleep(port->rs485_term_gpio,
+			!!(port->rs485.flags & SER_RS485_TERMINATE_BUS));
+		gpiod_set_value_cansleep(port->rs485_rx_during_tx_gpio,
+			!!(port->rs485.flags & SER_RS485_RX_DURING_TX));
 		return ret;
+	}
 
 	if (copy_to_user(rs485_user, &port->rs485, sizeof(port->rs485)))
 		return -EFAULT;
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -226,12 +226,6 @@ static int stm32_usart_config_rs485(stru
 
 	stm32_usart_clr_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
 
-	if (port->rs485_rx_during_tx_gpio)
-		gpiod_set_value_cansleep(port->rs485_rx_during_tx_gpio,
-					 !!(rs485conf->flags & SER_RS485_RX_DURING_TX));
-	else
-		rs485conf->flags |= SER_RS485_RX_DURING_TX;
-
 	if (rs485conf->flags & SER_RS485_ENABLED) {
 		cr1 = readl_relaxed(port->membase + ofs->cr1);
 		cr3 = readl_relaxed(port->membase + ofs->cr3);
@@ -256,6 +250,8 @@ static int stm32_usart_config_rs485(stru
 
 		writel_relaxed(cr3, port->membase + ofs->cr3);
 		writel_relaxed(cr1, port->membase + ofs->cr1);
+
+		rs485conf->flags |= SER_RS485_RX_DURING_TX;
 	} else {
 		stm32_usart_clr_bits(port, ofs->cr3,
 				     USART_CR3_DEM | USART_CR3_DEP);


