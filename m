Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFEC2EF656;
	Thu,  3 Jul 2025 15:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556180; cv=none; b=P5XBFJquQyotfx6DhHFWMf63hxtfakfvAEgkfoDNuztpvH8LDIUzKkBJRfAEOoX6Z21OtobC4bcdDQh7jqODPLpYdogiknsOtmkdtbmbUPZ4WGbjEbrpQMeQhkvIlbPUcQpFZSE7aWSK9p4WFGUewOiFkXyKK5/Si3DLPb2kWq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556180; c=relaxed/simple;
	bh=2LPxBqQo3d6XMiXcKrt5a0bHqIlnOW9q5xcbn45L6ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojhvAtMbKgNwVNUpl5OAjLbVVydWwT0nsw1ZZp0DeqqJn+lFno6Z9R/W5QYeNLEebW3l6C2U92uO1yRPc/EBZ3WZ3ko73tekiqaS4+2ST2GWyBFl9olVIiH3SYllECoT3T5mFC2dq6yBTrD44SOAbZesDyiTjRB5q1LdeE36fHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jf15oCXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jf15oCXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1DDC4CEE3;
	Thu,  3 Jul 2025 15:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556180;
	bh=2LPxBqQo3d6XMiXcKrt5a0bHqIlnOW9q5xcbn45L6ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jf15oCXgWxZ9Y1pK2mGXmNSrPUZryRSiMgMYSTW+MLB0izPqv4IBwk1/zmOYSOskj
	 00zZM3eCVrfQBepuZn9vdjA5eRBbQK//EMHb/qL95cvRgft03/EtUKHOrMv9RljA0R
	 K/6uLyZyDi14mSuaar7bdctCTTxFXLdWedrRofLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fabio Estevam <festevam@gmail.com>,
	Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH 6.1 092/132] serial: imx: Restore original RXTL for console to fix data loss
Date: Thu,  3 Jul 2025 16:43:01 +0200
Message-ID: <20250703143943.013794097@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -239,6 +239,7 @@ struct imx_port {
 	enum imx_tx_state	tx_state;
 	struct hrtimer		trigger_start_tx;
 	struct hrtimer		trigger_stop_tx;
+	unsigned int		rxtl;
 };
 
 struct imx_port_ucrs {
@@ -1320,6 +1321,7 @@ static void imx_uart_clear_rx_errors(str
 
 #define TXTL_DEFAULT 8
 #define RXTL_DEFAULT 8 /* 8 characters or aging timer */
+#define RXTL_CONSOLE_DEFAULT 1
 #define TXTL_DMA 8 /* DMA burst setting */
 #define RXTL_DMA 9 /* DMA burst setting */
 
@@ -1432,7 +1434,7 @@ static void imx_uart_disable_dma(struct
 	ucr1 &= ~(UCR1_RXDMAEN | UCR1_TXDMAEN | UCR1_ATDMAEN);
 	imx_uart_writel(sport, ucr1, UCR1);
 
-	imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
+	imx_uart_setup_ufcr(sport, TXTL_DEFAULT, sport->rxtl);
 
 	sport->dma_is_enabled = 0;
 }
@@ -1457,7 +1459,12 @@ static int imx_uart_startup(struct uart_
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
@@ -1906,7 +1913,7 @@ static int imx_uart_poll_init(struct uar
 	if (retval)
 		clk_disable_unprepare(sport->clk_ipg);
 
-	imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
+	imx_uart_setup_ufcr(sport, TXTL_DEFAULT, sport->rxtl);
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
@@ -1998,7 +2005,7 @@ static int imx_uart_rs485_config(struct
 		/* If the receiver trigger is 0, set it to a default value */
 		ufcr = imx_uart_readl(sport, UFCR);
 		if ((ufcr & UFCR_RXTL_MASK) == 0)
-			imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
+			imx_uart_setup_ufcr(sport, TXTL_DEFAULT, sport->rxtl);
 		imx_uart_start_rx(port);
 	}
 
@@ -2183,7 +2190,7 @@ imx_uart_console_setup(struct console *c
 	else
 		imx_uart_console_get_options(sport, &baud, &parity, &bits);
 
-	imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
+	imx_uart_setup_ufcr(sport, TXTL_DEFAULT, sport->rxtl);
 
 	retval = uart_set_options(&sport->port, co, baud, parity, bits, flow);
 


