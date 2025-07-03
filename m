Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323522E7BD6;
	Thu,  3 Jul 2025 15:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555103; cv=none; b=oj7guw5NPX4eJIq0CCHZcQkgEfFZVtTwgCQwE/3hBhDe4LgTnNNe1ciSMZh40Zl0LXd/AVRJ28rqhStBtRYl7PT0p4sJmHdh3GaNfsruFoOI2qmE9I4eDVXzDlfj8UB+GQQah8h9TG4C3Il8xtBzKGUPTDuYNZP3oA+VAzaMX4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555103; c=relaxed/simple;
	bh=DxVtDiQxl76D2w2rUQDrmKT8tHVb0qv+yZGOfZAPMKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9KxmVzqpi+A3ecUa3/TG+ecUAgNlvxOgdXWBozgeMDWsMDwbWaryHqnJ1/kKMZN8/cheIVNjFjppPJDZzZFiWf+LaNtHP6tBcqeUJ1yxtfMo/1uzkcu7/LxOY4hRKoIsLVQgaZJCGoDsOB9OCdaUy3Gl2qBIhQ6U7EPenFP9oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=quqUIBT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quqUIBT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96090C4CEE3;
	Thu,  3 Jul 2025 15:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555103;
	bh=DxVtDiQxl76D2w2rUQDrmKT8tHVb0qv+yZGOfZAPMKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quqUIBT8k8qcO3v3xz/LOZpW7YXpsB7u+e9oBhPwXuE25PiwXSLmDOmvl84eFgBE/
	 9AMfydgNa4kKq9niwulwIzDB6zzLJvvxCqZncyfxZgSgMZGhK4s81DhY+BqHgokFiD
	 lFm1HiIu/Q+zVNNdTFE0qw0pedqZyUpwZiSg7Jpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fabio Estevam <festevam@gmail.com>,
	Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH 6.15 176/263] serial: imx: Restore original RXTL for console to fix data loss
Date: Thu,  3 Jul 2025 16:41:36 +0200
Message-ID: <20250703144011.402327052@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@gmail.com>

commit f23c52aafb1675ab1d1f46914556d8e29cbbf7b3 upstream.

Commit 7a637784d517 ("serial: imx: reduce RX interrupt frequency")
introduced a regression on the i.MX6UL EVK board. The issue can be
reproduced with the following steps:

- Open vi on the board.
- Paste a text file (~150 characters).
- Save the file, then repeat the process.
- Compare the sha256sum of the saved files.

The checksums do not match due to missing characters or entire lines.

Fix this by restoring the RXTL value to 1 when the UART is used as a
console.

This ensures timely RX interrupts and reliable data reception in console
mode.

With this change, pasted content is saved correctly, and checksums are
always consistent.

Cc: stable <stable@kernel.org>
Fixes: 7a637784d517 ("serial: imx: reduce RX interrupt frequency")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20250619114617.2791939-1-festevam@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -235,6 +235,7 @@ struct imx_port {
 	enum imx_tx_state	tx_state;
 	struct hrtimer		trigger_start_tx;
 	struct hrtimer		trigger_stop_tx;
+	unsigned int		rxtl;
 };
 
 struct imx_port_ucrs {
@@ -1339,6 +1340,7 @@ static void imx_uart_clear_rx_errors(str
 
 #define TXTL_DEFAULT 8
 #define RXTL_DEFAULT 8 /* 8 characters or aging timer */
+#define RXTL_CONSOLE_DEFAULT 1
 #define TXTL_DMA 8 /* DMA burst setting */
 #define RXTL_DMA 9 /* DMA burst setting */
 
@@ -1457,7 +1459,7 @@ static void imx_uart_disable_dma(struct
 	ucr1 &= ~(UCR1_RXDMAEN | UCR1_TXDMAEN | UCR1_ATDMAEN);
 	imx_uart_writel(sport, ucr1, UCR1);
 
-	imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
+	imx_uart_setup_ufcr(sport, TXTL_DEFAULT, sport->rxtl);
 
 	sport->dma_is_enabled = 0;
 }
@@ -1482,7 +1484,12 @@ static int imx_uart_startup(struct uart_
 		return retval;
 	}
 
-	imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
+	if (uart_console(&sport->port))
+		sport->rxtl = RXTL_CONSOLE_DEFAULT;
+	else
+		sport->rxtl = RXTL_DEFAULT;
+
+	imx_uart_setup_ufcr(sport, TXTL_DEFAULT, sport->rxtl);
 
 	/* disable the DREN bit (Data Ready interrupt enable) before
 	 * requesting IRQs
@@ -1948,7 +1955,7 @@ static int imx_uart_poll_init(struct uar
 	if (retval)
 		clk_disable_unprepare(sport->clk_ipg);
 
-	imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
+	imx_uart_setup_ufcr(sport, TXTL_DEFAULT, sport->rxtl);
 
 	uart_port_lock_irqsave(&sport->port, &flags);
 
@@ -2040,7 +2047,7 @@ static int imx_uart_rs485_config(struct
 		/* If the receiver trigger is 0, set it to a default value */
 		ufcr = imx_uart_readl(sport, UFCR);
 		if ((ufcr & UFCR_RXTL_MASK) == 0)
-			imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
+			imx_uart_setup_ufcr(sport, TXTL_DEFAULT, sport->rxtl);
 		imx_uart_start_rx(port);
 	}
 
@@ -2302,7 +2309,7 @@ imx_uart_console_setup(struct console *c
 	else
 		imx_uart_console_get_options(sport, &baud, &parity, &bits);
 
-	imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
+	imx_uart_setup_ufcr(sport, TXTL_DEFAULT, sport->rxtl);
 
 	retval = uart_set_options(&sport->port, co, baud, parity, bits, flow);
 


