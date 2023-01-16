Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B306FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0354C433EF;
	Mon, 16 Jan 2023 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888407;
	bh=Yr0DvrpDO605IOmGGzySm0bXFY3ZxoaZJxxugPVjwoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGV7ZNUaqb+KWLK/AHU8VSn4sfKDRAdzNOLZN0AYoiosghW63CbYEsd3y77x8ueyK
	 wTzFzMw34+7h1zvZofYUrUvxIwg2JWHAP8yHYeYYnFk2bvmI7hNU6qO89Mdi2Otmdf
	 Z8vtdv6Z7cw/NEpzxGj/3XGqke9GKVDNKDfbbqYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <digetx@gmail.com>
Subject: [PATCH 4.19 516/521] tty: serial: tegra: Handle RX transfer in PIO mode if DMA wasnt started
Date: Mon, 16 Jan 2023 16:52:58 +0100
Message-Id: <20230116154910.302197118@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

commit 1f69a1273b3f204a9c00dc3bbdcc4afcd0787428 upstream.

It is possible to get an instant RX timeout or end-of-transfer interrupt
before RX DMA was started, if transaction is less than 16 bytes. Transfer
should be handled in PIO mode in this case because DMA can't handle it.
This patch brings back the original behaviour of the driver that was
changed by accident by a previous commit, it fixes occasional Bluetooth HW
initialization failures which I started to notice recently.

Fixes: d5e3fadb7012 ("tty: serial: tegra: Activate RX DMA transfer by request")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20200209164415.9632-1-digetx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial-tegra.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -638,11 +638,22 @@ static void tegra_uart_copy_rx_to_tty(st
 				TEGRA_UART_RX_DMA_BUFFER_SIZE, DMA_TO_DEVICE);
 }
 
+static void do_handle_rx_pio(struct tegra_uart_port *tup)
+{
+	struct tty_struct *tty = tty_port_tty_get(&tup->uport.state->port);
+	struct tty_port *port = &tup->uport.state->port;
+
+	tegra_uart_handle_rx_pio(tup, port);
+	if (tty) {
+		tty_flip_buffer_push(port);
+		tty_kref_put(tty);
+	}
+}
+
 static void tegra_uart_rx_buffer_push(struct tegra_uart_port *tup,
 				      unsigned int residue)
 {
 	struct tty_port *port = &tup->uport.state->port;
-	struct tty_struct *tty = tty_port_tty_get(port);
 	unsigned int count;
 
 	async_tx_ack(tup->rx_dma_desc);
@@ -651,11 +662,7 @@ static void tegra_uart_rx_buffer_push(st
 	/* If we are here, DMA is stopped */
 	tegra_uart_copy_rx_to_tty(tup, port, count);
 
-	tegra_uart_handle_rx_pio(tup, port);
-	if (tty) {
-		tty_flip_buffer_push(port);
-		tty_kref_put(tty);
-	}
+	do_handle_rx_pio(tup);
 }
 
 static void tegra_uart_rx_dma_complete(void *args)
@@ -695,8 +702,10 @@ static void tegra_uart_terminate_rx_dma(
 {
 	struct dma_tx_state state;
 
-	if (!tup->rx_dma_active)
+	if (!tup->rx_dma_active) {
+		do_handle_rx_pio(tup);
 		return;
+	}
 
 	dmaengine_pause(tup->rx_dma_chan);
 	dmaengine_tx_status(tup->rx_dma_chan, tup->rx_cookie, &state);
@@ -765,18 +774,6 @@ static void tegra_uart_handle_modem_sign
 		uart_handle_cts_change(&tup->uport, msr & UART_MSR_CTS);
 }
 
-static void do_handle_rx_pio(struct tegra_uart_port *tup)
-{
-	struct tty_struct *tty = tty_port_tty_get(&tup->uport.state->port);
-	struct tty_port *port = &tup->uport.state->port;
-
-	tegra_uart_handle_rx_pio(tup, port);
-	if (tty) {
-		tty_flip_buffer_push(port);
-		tty_kref_put(tty);
-	}
-}
-
 static irqreturn_t tegra_uart_isr(int irq, void *data)
 {
 	struct tegra_uart_port *tup = data;


