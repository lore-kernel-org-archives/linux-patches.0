Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9477C0A6;
	Mon,  8 Apr 2024 13:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582457; cv=none; b=hd/++Tt+a0ic1t1gGAcRPXlPiUCaHjLa9lHoXUeInTI6PH0i4Pj9krgsVWax378TaOX5En5wxB2eDxIhtb0rRnTASNyLkI8CynlxwU/uuJkcyfjkPbetrP8NOgymoQ331qCp0LI6O+iUAviJxweMHOwwZsvOr4UDd7CqExE8c6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582457; c=relaxed/simple;
	bh=hS7mWQJBRZcixIxnsgqdNstf8WybhjBvycj5fg1q8kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIbqNwmDCRL4KGccc5+9iAEkIZSVwIcDqnwD5dKZo2VTuHYyD/3h42d2gyE+9jfVHjJihxPd12p2zFDfhvpXMp6ypUsaMw32rK5WAmnmWRPLpcvFYPPUuXGmgNBfUBrcRymS0bVTNRvLTXZSLLxAKlW63lDG+rmeefSZeeNqQcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgfEV0E9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgfEV0E9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7326C433F1;
	Mon,  8 Apr 2024 13:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582457;
	bh=hS7mWQJBRZcixIxnsgqdNstf8WybhjBvycj5fg1q8kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgfEV0E9qYxMygOj5HVwNJdExvIUaOkNJ2fdGTQMIV9y1jz7dzezExWUfAn4hHAXy
	 zv1XdEINAtySxepLDdFDUCY2dG9pfbZLuhdZ8E4BQZ/vcqD/YODZcZK9wweP3x4Fde
	 C25cJcGRrqITEKffWCSXNFcj075VgL1HIbpHgqmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rickard x Andersson <rickaran@axis.com>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>
Subject: [PATCH 5.15 147/690] tty: serial: imx: Fix broken RS485
Date: Mon,  8 Apr 2024 14:50:13 +0200
Message-ID: <20240408125404.838576463@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rickard x Andersson <rickaran@axis.com>

commit 672448ccf9b6a676f96f9352cbf91f4d35f4084a upstream.

When about to transmit the function imx_uart_start_tx is called and in
some RS485 configurations this function will call imx_uart_stop_rx. The
problem is that imx_uart_stop_rx will enable loopback in order to
release the RS485 bus, but when loopback is enabled transmitted data
will just be looped to RX.

This patch fixes the above problem by not enabling loopback when about
to transmit.

This driver now works well when used for RS485 half duplex master
configurations.

Fixes: 79d0224f6bf2 ("tty: serial: imx: Handle RS485 DE signal active high")
Cc: stable <stable@kernel.org>
Signed-off-by: Rickard x Andersson <rickaran@axis.com>
Tested-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Link: https://lore.kernel.org/r/20240221115304.509811-1-rickaran@axis.com
Signed-off-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -491,8 +491,7 @@ static void imx_uart_stop_tx(struct uart
 	}
 }
 
-/* called with port.lock taken and irqs off */
-static void imx_uart_stop_rx(struct uart_port *port)
+static void imx_uart_stop_rx_with_loopback_ctrl(struct uart_port *port, bool loopback)
 {
 	struct imx_port *sport = (struct imx_port *)port;
 	u32 ucr1, ucr2, ucr4, uts;
@@ -514,7 +513,7 @@ static void imx_uart_stop_rx(struct uart
 	/* See SER_RS485_ENABLED/UTS_LOOP comment in imx_uart_probe() */
 	if (port->rs485.flags & SER_RS485_ENABLED &&
 	    port->rs485.flags & SER_RS485_RTS_ON_SEND &&
-	    sport->have_rtscts && !sport->have_rtsgpio) {
+	    sport->have_rtscts && !sport->have_rtsgpio && loopback) {
 		uts = imx_uart_readl(sport, imx_uart_uts_reg(sport));
 		uts |= UTS_LOOP;
 		imx_uart_writel(sport, uts, imx_uart_uts_reg(sport));
@@ -527,6 +526,16 @@ static void imx_uart_stop_rx(struct uart
 }
 
 /* called with port.lock taken and irqs off */
+static void imx_uart_stop_rx(struct uart_port *port)
+{
+	/*
+	 * Stop RX and enable loopback in order to make sure RS485 bus
+	 * is not blocked. Se comment in imx_uart_probe().
+	 */
+	imx_uart_stop_rx_with_loopback_ctrl(port, true);
+}
+
+/* called with port.lock taken and irqs off */
 static void imx_uart_enable_ms(struct uart_port *port)
 {
 	struct imx_port *sport = (struct imx_port *)port;
@@ -714,8 +723,13 @@ static void imx_uart_start_tx(struct uar
 				imx_uart_rts_inactive(sport, &ucr2);
 			imx_uart_writel(sport, ucr2, UCR2);
 
+			/*
+			 * Since we are about to transmit we can not stop RX
+			 * with loopback enabled because that will make our
+			 * transmitted data being just looped to RX.
+			 */
 			if (!(port->rs485.flags & SER_RS485_RX_DURING_TX))
-				imx_uart_stop_rx(port);
+				imx_uart_stop_rx_with_loopback_ctrl(port, false);
 
 			sport->tx_state = WAIT_AFTER_RTS;
 			start_hrtimer_ms(&sport->trigger_start_tx,


