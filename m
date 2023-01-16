Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4318E6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB95FC433D2;
	Mon, 16 Jan 2023 16:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887595;
	bh=Gs4EHS7OKBi1zaE9jA1U/E2h8za93rQpnt3j6Uz0xgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdG3Q3kvlKz040R5K6Dm7swVoyuqO9yyFj3XIbEWYjtIVcIUf7O9KwQ2+e2fqmv+A
	 ApkHeJWVTFVyCL7JnVuGj2qHZCnpm+XC5wFPQL36ASTZ4TdTDBd1fmzpceLLsSfUoq
	 Ak1wnhRqps4bID4oKq28x//4xPfb/tCeij6eLSxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahung Cheng <ahcheng@nvidia.com>,
	Shardar Mohammed <smohammed@nvidia.com>,
	Krishna Yarlagadda <kyarlagadda@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 209/521] serial: tegra: avoid reg access when clk disabled
Date: Mon, 16 Jan 2023 16:47:51 +0100
Message-Id: <20230116154856.501068374@linuxfoundation.org>
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

From: Ahung Cheng <ahcheng@nvidia.com>

[ Upstream commit 494f79bd2365703e4093efa0ecf4b139d83aba97 ]

This avoids two race conditions from the UART shutdown sequence both
leading to 'Machine check error in AXI2APB' and kernel oops.

One was that the clock was disabled before the DMA was terminated making
it possible for the DMA callbacks to be called after the clock was
disabled. These callbacks could write to the UART registers causing
timeout.

The second was that the clock was disabled before the UART was
completely flagged as closed. This is done after the shutdown is called
and a new write could be started after the clock was disabled.
tegra_uart_start_pio_tx could be called causing timeout.

Given that the baud rate is reset at the end of shutdown sequence, this
fix is to examine the baud rate to avoid register access from both race
conditions.

Besides, terminate the DMA before disabling the clock.

Signed-off-by: Ahung Cheng <ahcheng@nvidia.com>
Signed-off-by: Shardar Mohammed <smohammed@nvidia.com>
Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/1567572187-29820-3-git-send-email-kyarlagadda@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 109a951a9f1f ("serial: tegra: Read DMA status before terminating")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial-tegra.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index ee480a1480e8..c113a0b1ece1 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -126,6 +126,8 @@ struct tegra_uart_port {
 
 static void tegra_uart_start_next_tx(struct tegra_uart_port *tup);
 static int tegra_uart_start_rx_dma(struct tegra_uart_port *tup);
+static void tegra_uart_dma_channel_free(struct tegra_uart_port *tup,
+					bool dma_to_memory);
 
 static inline unsigned long tegra_uart_read(struct tegra_uart_port *tup,
 		unsigned long reg)
@@ -440,6 +442,9 @@ static void tegra_uart_start_next_tx(struct tegra_uart_port *tup)
 	unsigned long count;
 	struct circ_buf *xmit = &tup->uport.state->xmit;
 
+	if (!tup->current_baud)
+		return;
+
 	tail = (unsigned long)&xmit->buf[xmit->tail];
 	count = CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE);
 	if (!count)
@@ -803,6 +808,12 @@ static void tegra_uart_hw_deinit(struct tegra_uart_port *tup)
 	tup->current_baud = 0;
 	spin_unlock_irqrestore(&tup->uport.lock, flags);
 
+	tup->rx_in_progress = 0;
+	tup->tx_in_progress = 0;
+
+	tegra_uart_dma_channel_free(tup, true);
+	tegra_uart_dma_channel_free(tup, false);
+
 	clk_disable_unprepare(tup->uart_clk);
 }
 
@@ -1040,12 +1051,6 @@ static void tegra_uart_shutdown(struct uart_port *u)
 	struct tegra_uart_port *tup = to_tegra_uport(u);
 
 	tegra_uart_hw_deinit(tup);
-
-	tup->rx_in_progress = 0;
-	tup->tx_in_progress = 0;
-
-	tegra_uart_dma_channel_free(tup, true);
-	tegra_uart_dma_channel_free(tup, false);
 	free_irq(u->irq, tup);
 }
 
-- 
2.35.1



