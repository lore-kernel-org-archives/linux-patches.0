Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B5833F0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFE4C433F0;
	Mon, 16 Jan 2023 16:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886030;
	bh=XmTihP20Bm58/Hvh7Wfp7+cHUtt3s9WdP9VMvUm2h1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5BfxvYBxuIJum5y7uEvr5Y3HTir5kd4+sLBZ+58Fv9apr9m7h7tB0DADDU+oGL0j
	 UQd89n37kkPq7dJUEs1kthX6pxdAqrzafSAQi9xlAQcpuLGRTZ5wgyQYtNxk/p7sZX
	 jtorLmZ0dVYTmZHNpBU5D452WibHCDuGqtx/htQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <digetx@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 275/658] tty: serial: tegra: Activate RX DMA transfer by request
Date: Mon, 16 Jan 2023 16:46:03 +0100
Message-Id: <20230116154922.164300586@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit d5e3fadb70125c6c41f692cf1c0e626c12e11de1 ]

This allows DMA engine to go into runtime-suspended mode whenever there is
no data to receive, instead of keeping DMA active all the time while TTY
is opened (i.e. permanently active in practice, like in the case of UART
Bluetooth).

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20200112180919.5194-2-digetx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 109a951a9f1f ("serial: tegra: Read DMA status before terminating")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial-tegra.c | 78 ++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 32 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index c5f43cd39664..431edb89e90f 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -141,6 +141,7 @@ struct tegra_uart_port {
 	int					configured_rate;
 	bool					use_rx_pio;
 	bool					use_tx_pio;
+	bool					rx_dma_active;
 };
 
 static void tegra_uart_start_next_tx(struct tegra_uart_port *tup);
@@ -733,6 +734,7 @@ static void tegra_uart_rx_dma_complete(void *args)
 	if (tup->rts_active)
 		set_rts(tup, false);
 
+	tup->rx_dma_active = false;
 	tegra_uart_rx_buffer_push(tup, 0);
 	tegra_uart_start_rx_dma(tup);
 
@@ -744,18 +746,27 @@ static void tegra_uart_rx_dma_complete(void *args)
 	spin_unlock_irqrestore(&u->lock, flags);
 }
 
-static void tegra_uart_handle_rx_dma(struct tegra_uart_port *tup)
+static void tegra_uart_terminate_rx_dma(struct tegra_uart_port *tup)
 {
 	struct dma_tx_state state;
 
-	/* Deactivate flow control to stop sender */
-	if (tup->rts_active)
-		set_rts(tup, false);
+	if (!tup->rx_dma_active)
+		return;
 
 	dmaengine_terminate_all(tup->rx_dma_chan);
 	dmaengine_tx_status(tup->rx_dma_chan, tup->rx_cookie, &state);
+
 	tegra_uart_rx_buffer_push(tup, state.residue);
-	tegra_uart_start_rx_dma(tup);
+	tup->rx_dma_active = false;
+}
+
+static void tegra_uart_handle_rx_dma(struct tegra_uart_port *tup)
+{
+	/* Deactivate flow control to stop sender */
+	if (tup->rts_active)
+		set_rts(tup, false);
+
+	tegra_uart_terminate_rx_dma(tup);
 
 	if (tup->rts_active)
 		set_rts(tup, true);
@@ -765,6 +776,9 @@ static int tegra_uart_start_rx_dma(struct tegra_uart_port *tup)
 {
 	unsigned int count = TEGRA_UART_RX_DMA_BUFFER_SIZE;
 
+	if (tup->rx_dma_active)
+		return 0;
+
 	tup->rx_dma_desc = dmaengine_prep_slave_single(tup->rx_dma_chan,
 				tup->rx_dma_buf_phys, count, DMA_DEV_TO_MEM,
 				DMA_PREP_INTERRUPT);
@@ -773,6 +787,7 @@ static int tegra_uart_start_rx_dma(struct tegra_uart_port *tup)
 		return -EIO;
 	}
 
+	tup->rx_dma_active = true;
 	tup->rx_dma_desc->callback = tegra_uart_rx_dma_complete;
 	tup->rx_dma_desc->callback_param = tup;
 	dma_sync_single_for_device(tup->uport.dev, tup->rx_dma_buf_phys,
@@ -822,6 +837,7 @@ static irqreturn_t tegra_uart_isr(int irq, void *data)
 	struct uart_port *u = &tup->uport;
 	unsigned long iir;
 	unsigned long ier;
+	bool is_rx_start = false;
 	bool is_rx_int = false;
 	unsigned long flags;
 
@@ -834,10 +850,12 @@ static irqreturn_t tegra_uart_isr(int irq, void *data)
 				if (tup->rx_in_progress) {
 					ier = tup->ier_shadow;
 					ier |= (UART_IER_RLSI | UART_IER_RTOIE |
-						TEGRA_UART_IER_EORD);
+						TEGRA_UART_IER_EORD | UART_IER_RDI);
 					tup->ier_shadow = ier;
 					tegra_uart_write(tup, ier, UART_IER);
 				}
+			} else if (is_rx_start) {
+				tegra_uart_start_rx_dma(tup);
 			}
 			spin_unlock_irqrestore(&u->lock, flags);
 			return IRQ_HANDLED;
@@ -856,17 +874,23 @@ static irqreturn_t tegra_uart_isr(int irq, void *data)
 
 		case 4: /* End of data */
 		case 6: /* Rx timeout */
-		case 2: /* Receive */
-			if (!tup->use_rx_pio && !is_rx_int) {
-				is_rx_int = true;
+			if (!tup->use_rx_pio) {
+				is_rx_int = tup->rx_in_progress;
 				/* Disable Rx interrupts */
 				ier = tup->ier_shadow;
-				ier |= UART_IER_RDI;
-				tegra_uart_write(tup, ier, UART_IER);
 				ier &= ~(UART_IER_RDI | UART_IER_RLSI |
 					UART_IER_RTOIE | TEGRA_UART_IER_EORD);
 				tup->ier_shadow = ier;
 				tegra_uart_write(tup, ier, UART_IER);
+				break;
+			}
+			/* Fall through */
+		case 2: /* Receive */
+			if (!tup->use_rx_pio) {
+				is_rx_start = tup->rx_in_progress;
+				tup->ier_shadow  &= ~UART_IER_RDI;
+				tegra_uart_write(tup, tup->ier_shadow,
+						 UART_IER);
 			} else {
 				do_handle_rx_pio(tup);
 			}
@@ -888,7 +912,6 @@ static void tegra_uart_stop_rx(struct uart_port *u)
 {
 	struct tegra_uart_port *tup = to_tegra_uport(u);
 	struct tty_port *port = &tup->uport.state->port;
-	struct dma_tx_state state;
 	unsigned long ier;
 
 	if (tup->rts_active)
@@ -905,13 +928,11 @@ static void tegra_uart_stop_rx(struct uart_port *u)
 	tup->ier_shadow = ier;
 	tegra_uart_write(tup, ier, UART_IER);
 	tup->rx_in_progress = 0;
-	if (tup->rx_dma_chan && !tup->use_rx_pio) {
-		dmaengine_terminate_all(tup->rx_dma_chan);
-		dmaengine_tx_status(tup->rx_dma_chan, tup->rx_cookie, &state);
-		tegra_uart_rx_buffer_push(tup, state.residue);
-	} else {
+
+	if (!tup->use_rx_pio)
+		tegra_uart_terminate_rx_dma(tup);
+	else
 		tegra_uart_handle_rx_pio(tup, port);
-	}
 }
 
 static void tegra_uart_hw_deinit(struct tegra_uart_port *tup)
@@ -1056,12 +1077,6 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 		tup->lcr_shadow = TEGRA_UART_DEFAULT_LSR;
 		tup->fcr_shadow |= UART_FCR_DMA_SELECT;
 		tegra_uart_write(tup, tup->fcr_shadow, UART_FCR);
-
-		ret = tegra_uart_start_rx_dma(tup);
-		if (ret < 0) {
-			dev_err(tup->uport.dev, "Not able to start Rx DMA\n");
-			return ret;
-		}
 	} else {
 		tegra_uart_write(tup, tup->fcr_shadow, UART_FCR);
 	}
@@ -1071,10 +1086,6 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	 * Enable IE_RXS for the receive status interrupts like line errros.
 	 * Enable IE_RX_TIMEOUT to get the bytes which cannot be DMA'd.
 	 *
-	 * If using DMA mode, enable EORD instead of receive interrupt which
-	 * will interrupt after the UART is done with the receive instead of
-	 * the interrupt when the FIFO "threshold" is reached.
-	 *
 	 * EORD is different interrupt than RX_TIMEOUT - RX_TIMEOUT occurs when
 	 * the DATA is sitting in the FIFO and couldn't be transferred to the
 	 * DMA as the DMA size alignment (4 bytes) is not met. EORD will be
@@ -1085,11 +1096,14 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	 * both the EORD as well as RX_TIMEOUT - SW sees RX_TIMEOUT first
 	 * then the EORD.
 	 */
+	tup->ier_shadow = UART_IER_RLSI | UART_IER_RTOIE | UART_IER_RDI;
+
+	/*
+	 * If using DMA mode, enable EORD interrupt to notify about RX
+	 * completion.
+	 */
 	if (!tup->use_rx_pio)
-		tup->ier_shadow = UART_IER_RLSI | UART_IER_RTOIE |
-			TEGRA_UART_IER_EORD;
-	else
-		tup->ier_shadow = UART_IER_RLSI | UART_IER_RTOIE | UART_IER_RDI;
+		tup->ier_shadow |= TEGRA_UART_IER_EORD;
 
 	tegra_uart_write(tup, tup->ier_shadow, UART_IER);
 	return 0;
-- 
2.35.1



