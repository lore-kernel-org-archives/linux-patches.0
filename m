Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0434F15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F02C433D6;
	Mon,  5 Dec 2022 19:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269066;
	bh=mKd4u7DQy6H6eSbrrZ7VtAIHtcZuZvqsbGxiWT4q6uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgdetyyO1CsnAy86NODhGwHiWyU2oNZPZZv5I9Wm4jisdKt33fBk3rW2xkYTvL7On
	 SLOtkflRo7G5gwzPnVvLXIbEkQD7g2bSoODql3wYNYCoN7iHfk0OJSzMCN1ePxuC9Q
	 reHbQCb1eXch5oxxYqIiAbCyieyD6PTIjFY/sZCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/120] serial: stm32: Deassert Transmit Enable on ->rs485_config()
Date: Mon,  5 Dec 2022 20:10:53 +0100
Message-Id: <20221205190809.922093005@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit adafbbf6895eb0ce41a313c6ee68870ab9aa93cd ]

The STM32 USART can control RS-485 Transmit Enable in hardware.  Since
commit 7df5081cbf5e ("serial: stm32: Add RS485 RTS GPIO control"),
it can alternatively be controlled in software.  That was done to allow
RS-485 even if the RTS pin is unavailable because it's pinmuxed to a
different function.

However the commit neglected to deassert Transmit Enable upon invocation
of the ->rs485_config() callback.  Fix it.

Avoid forward declarations by moving stm32_usart_tx_empty(),
stm32_usart_rs485_rts_enable() and stm32_usart_rs485_rts_disable()
further up in the driver.

Fixes: 7df5081cbf5e ("serial: stm32: Add RS485 RTS GPIO control")
Cc: stable@vger.kernel.org # v5.9+
Cc: Marek Vasut <marex@denx.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/6059eab35dba394468335ef640df8b0050fd9dbd.1662886616.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 100 ++++++++++++++++---------------
 1 file changed, 53 insertions(+), 47 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 86f044a96de1..ce7ff7a0207f 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -61,6 +61,53 @@ static void stm32_usart_clr_bits(struct uart_port *port, u32 reg, u32 bits)
 	writel_relaxed(val, port->membase + reg);
 }
 
+static unsigned int stm32_usart_tx_empty(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+
+	if (readl_relaxed(port->membase + ofs->isr) & USART_SR_TC)
+		return TIOCSER_TEMT;
+
+	return 0;
+}
+
+static void stm32_usart_rs485_rts_enable(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	struct serial_rs485 *rs485conf = &port->rs485;
+
+	if (stm32_port->hw_flow_control ||
+	    !(rs485conf->flags & SER_RS485_ENABLED))
+		return;
+
+	if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl | TIOCM_RTS);
+	} else {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl & ~TIOCM_RTS);
+	}
+}
+
+static void stm32_usart_rs485_rts_disable(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	struct serial_rs485 *rs485conf = &port->rs485;
+
+	if (stm32_port->hw_flow_control ||
+	    !(rs485conf->flags & SER_RS485_ENABLED))
+		return;
+
+	if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl & ~TIOCM_RTS);
+	} else {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl | TIOCM_RTS);
+	}
+}
+
 static void stm32_usart_config_reg_rs485(u32 *cr1, u32 *cr3, u32 delay_ADE,
 					 u32 delay_DDE, u32 baud)
 {
@@ -149,6 +196,12 @@ static int stm32_usart_config_rs485(struct uart_port *port,
 
 	stm32_usart_set_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
 
+	/* Adjust RTS polarity in case it's driven in software */
+	if (stm32_usart_tx_empty(port))
+		stm32_usart_rs485_rts_disable(port);
+	else
+		stm32_usart_rs485_rts_enable(port);
+
 	return 0;
 }
 
@@ -341,42 +394,6 @@ static void stm32_usart_tc_interrupt_disable(struct uart_port *port)
 	stm32_usart_clr_bits(port, ofs->cr1, USART_CR1_TCIE);
 }
 
-static void stm32_usart_rs485_rts_enable(struct uart_port *port)
-{
-	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct serial_rs485 *rs485conf = &port->rs485;
-
-	if (stm32_port->hw_flow_control ||
-	    !(rs485conf->flags & SER_RS485_ENABLED))
-		return;
-
-	if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
-		mctrl_gpio_set(stm32_port->gpios,
-			       stm32_port->port.mctrl | TIOCM_RTS);
-	} else {
-		mctrl_gpio_set(stm32_port->gpios,
-			       stm32_port->port.mctrl & ~TIOCM_RTS);
-	}
-}
-
-static void stm32_usart_rs485_rts_disable(struct uart_port *port)
-{
-	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct serial_rs485 *rs485conf = &port->rs485;
-
-	if (stm32_port->hw_flow_control ||
-	    !(rs485conf->flags & SER_RS485_ENABLED))
-		return;
-
-	if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
-		mctrl_gpio_set(stm32_port->gpios,
-			       stm32_port->port.mctrl & ~TIOCM_RTS);
-	} else {
-		mctrl_gpio_set(stm32_port->gpios,
-			       stm32_port->port.mctrl | TIOCM_RTS);
-	}
-}
-
 static void stm32_usart_transmit_chars_pio(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
@@ -590,17 +607,6 @@ static irqreturn_t stm32_usart_threaded_interrupt(int irq, void *ptr)
 	return IRQ_HANDLED;
 }
 
-static unsigned int stm32_usart_tx_empty(struct uart_port *port)
-{
-	struct stm32_port *stm32_port = to_stm32_port(port);
-	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
-
-	if (readl_relaxed(port->membase + ofs->isr) & USART_SR_TC)
-		return TIOCSER_TEMT;
-
-	return 0;
-}
-
 static void stm32_usart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-- 
2.35.1



