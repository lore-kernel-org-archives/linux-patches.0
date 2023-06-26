Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3559134CE
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2167BC433C0;
	Mon, 26 Jun 2023 18:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803879;
	bh=vLQbXwcygw6NILeCjHqCwZleHo5s7H+9gD6WiMTDPMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xr/QHNmyM6UXEkNXfN/2JzuMlaKT6IBYRTWPJThAoW62a/zEssgQHhgCCbXz6NkjS
	 ZElPYl3cEEjVB4b9IvTZRHYrVxVdtlnFZFw0h5pAmX6QWNfHB4hyGVYosi7h6AfSPq
	 lSNfbX8jLdhIwij5uBs5TclnX63aFiMG8hUi5Cgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Songjun Wu <songjun.wu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/41] serial: lantiq: Change ltq_w32_mask to asc_update_bits
Date: Mon, 26 Jun 2023 20:11:24 +0200
Message-ID: <20230626180736.298698585@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180736.243379844@linuxfoundation.org>
References: <20230626180736.243379844@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Songjun Wu <songjun.wu@linux.intel.com>

[ Upstream commit fccf231ae907dc9eb45eb8a9adb961195066b2c6 ]

ltq prefix is platform specific function, asc prefix
is more generic.

Signed-off-by: Songjun Wu <songjun.wu@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 306320034e8f ("serial: lantiq: add missing interrupt ack")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/lantiq.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/lantiq.c b/drivers/tty/serial/lantiq.c
index 044128277248b..848286a12c20b 100644
--- a/drivers/tty/serial/lantiq.c
+++ b/drivers/tty/serial/lantiq.c
@@ -113,6 +113,13 @@ struct ltq_uart_port {
 	unsigned int		err_irq;
 };
 
+static inline void asc_update_bits(u32 clear, u32 set, void __iomem *reg)
+{
+	u32 tmp = readl(reg);
+
+	writel((tmp & ~clear) | set, reg);
+}
+
 static inline struct
 ltq_uart_port *to_ltq_uart_port(struct uart_port *port)
 {
@@ -163,16 +170,16 @@ lqasc_rx_chars(struct uart_port *port)
 		if (rsr & ASCSTATE_ANY) {
 			if (rsr & ASCSTATE_PE) {
 				port->icount.parity++;
-				ltq_w32_mask(0, ASCWHBSTATE_CLRPE,
+				asc_update_bits(0, ASCWHBSTATE_CLRPE,
 					port->membase + LTQ_ASC_WHBSTATE);
 			} else if (rsr & ASCSTATE_FE) {
 				port->icount.frame++;
-				ltq_w32_mask(0, ASCWHBSTATE_CLRFE,
+				asc_update_bits(0, ASCWHBSTATE_CLRFE,
 					port->membase + LTQ_ASC_WHBSTATE);
 			}
 			if (rsr & ASCSTATE_ROE) {
 				port->icount.overrun++;
-				ltq_w32_mask(0, ASCWHBSTATE_CLRROE,
+				asc_update_bits(0, ASCWHBSTATE_CLRROE,
 					port->membase + LTQ_ASC_WHBSTATE);
 			}
 
@@ -252,7 +259,7 @@ lqasc_err_int(int irq, void *_port)
 	struct uart_port *port = (struct uart_port *)_port;
 	spin_lock_irqsave(&ltq_asc_lock, flags);
 	/* clear any pending interrupts */
-	ltq_w32_mask(0, ASCWHBSTATE_CLRPE | ASCWHBSTATE_CLRFE |
+	asc_update_bits(0, ASCWHBSTATE_CLRPE | ASCWHBSTATE_CLRFE |
 		ASCWHBSTATE_CLRROE, port->membase + LTQ_ASC_WHBSTATE);
 	spin_unlock_irqrestore(&ltq_asc_lock, flags);
 	return IRQ_HANDLED;
@@ -304,7 +311,7 @@ lqasc_startup(struct uart_port *port)
 		clk_enable(ltq_port->clk);
 	port->uartclk = clk_get_rate(ltq_port->fpiclk);
 
-	ltq_w32_mask(ASCCLC_DISS | ASCCLC_RMCMASK, (1 << ASCCLC_RMCOFFSET),
+	asc_update_bits(ASCCLC_DISS | ASCCLC_RMCMASK, (1 << ASCCLC_RMCOFFSET),
 		port->membase + LTQ_ASC_CLC);
 
 	ltq_w32(0, port->membase + LTQ_ASC_PISEL);
@@ -320,7 +327,7 @@ lqasc_startup(struct uart_port *port)
 	 * setting enable bits
 	 */
 	wmb();
-	ltq_w32_mask(0, ASCCON_M_8ASYNC | ASCCON_FEN | ASCCON_TOEN |
+	asc_update_bits(0, ASCCON_M_8ASYNC | ASCCON_FEN | ASCCON_TOEN |
 		ASCCON_ROEN, port->membase + LTQ_ASC_CON);
 
 	retval = request_irq(ltq_port->tx_irq, lqasc_tx_int,
@@ -364,9 +371,9 @@ lqasc_shutdown(struct uart_port *port)
 	free_irq(ltq_port->err_irq, port);
 
 	ltq_w32(0, port->membase + LTQ_ASC_CON);
-	ltq_w32_mask(ASCRXFCON_RXFEN, ASCRXFCON_RXFFLU,
+	asc_update_bits(ASCRXFCON_RXFEN, ASCRXFCON_RXFFLU,
 		port->membase + LTQ_ASC_RXFCON);
-	ltq_w32_mask(ASCTXFCON_TXFEN, ASCTXFCON_TXFFLU,
+	asc_update_bits(ASCTXFCON_TXFEN, ASCTXFCON_TXFFLU,
 		port->membase + LTQ_ASC_TXFCON);
 	if (!IS_ERR(ltq_port->clk))
 		clk_disable(ltq_port->clk);
@@ -438,7 +445,7 @@ lqasc_set_termios(struct uart_port *port,
 	spin_lock_irqsave(&ltq_asc_lock, flags);
 
 	/* set up CON */
-	ltq_w32_mask(0, con, port->membase + LTQ_ASC_CON);
+	asc_update_bits(0, con, port->membase + LTQ_ASC_CON);
 
 	/* Set baud rate - take a divider of 2 into account */
 	baud = uart_get_baud_rate(port, new, old, 0, port->uartclk / 16);
@@ -446,19 +453,19 @@ lqasc_set_termios(struct uart_port *port,
 	divisor = divisor / 2 - 1;
 
 	/* disable the baudrate generator */
-	ltq_w32_mask(ASCCON_R, 0, port->membase + LTQ_ASC_CON);
+	asc_update_bits(ASCCON_R, 0, port->membase + LTQ_ASC_CON);
 
 	/* make sure the fractional divider is off */
-	ltq_w32_mask(ASCCON_FDE, 0, port->membase + LTQ_ASC_CON);
+	asc_update_bits(ASCCON_FDE, 0, port->membase + LTQ_ASC_CON);
 
 	/* set up to use divisor of 2 */
-	ltq_w32_mask(ASCCON_BRS, 0, port->membase + LTQ_ASC_CON);
+	asc_update_bits(ASCCON_BRS, 0, port->membase + LTQ_ASC_CON);
 
 	/* now we can write the new baudrate into the register */
 	ltq_w32(divisor, port->membase + LTQ_ASC_BG);
 
 	/* turn the baudrate generator back on */
-	ltq_w32_mask(0, ASCCON_R, port->membase + LTQ_ASC_CON);
+	asc_update_bits(0, ASCCON_R, port->membase + LTQ_ASC_CON);
 
 	/* enable rx */
 	ltq_w32(ASCWHBSTATE_SETREN, port->membase + LTQ_ASC_WHBSTATE);
-- 
2.39.2



