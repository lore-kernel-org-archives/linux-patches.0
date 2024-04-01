Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2EE482DF;
	Mon,  1 Apr 2024 17:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991208; cv=none; b=m/YQq72vjjtuMv1lypByOAPav8oa5ksWp50I5smx10K9mUdfmmJC4BApqghf2+2qGOtoLAqNtCR+WgVCwgXUXBiIz/xu4AaGDOF+CgooCa84uc7Th5yq1GpAHAOFZbaaPwc3VGwpvmfRqqm8UiPzCYlH8fJOCefRF23NZJp5Txw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991208; c=relaxed/simple;
	bh=LvefC8e+G82DIq1Zv71Uay3GTG9naCloffJfyZ1gJfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfKdWjXg1TeFFVKQWx7UbCW5WWKrWAtxo4BEbNFzdNGMi+WXMtJI11OMirdlHfbM+6AXn9xSkRGACBXvnRZOZLBnUs3h1wX2FJcr3aGw8PyN94pheMmahzAEiv22QqKgWi7pgaflk6pcyTeQFXbdzU8Wo7uz0Cc2RfqZs5kYHEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUcRDArL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUcRDArL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7963C433F1;
	Mon,  1 Apr 2024 17:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991208;
	bh=LvefC8e+G82DIq1Zv71Uay3GTG9naCloffJfyZ1gJfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUcRDArLjbO+ogxACyPq8cPA/+Hg7v8olU0S0utzyhllkQhs5A02w3d25abKaOnla
	 lnmuiCgCikUxV6eRAIedKCdL81VE6Kxz1hlbyI7hkiqklN7qCUXZiXZuhNnDv3x7wE
	 /uZnC9yV0YNMSC98ocAZ00U+VcNGrOqGcLkdEUEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rickard x Andersson <rickaran@axis.com>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>
Subject: [PATCH 6.1 196/272] tty: serial: imx: Fix broken RS485
Date: Mon,  1 Apr 2024 17:46:26 +0200
Message-ID: <20240401152537.001532776@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -496,8 +496,7 @@ static void imx_uart_stop_tx(struct uart
 	}
 }
 
-/* called with port.lock taken and irqs off */
-static void imx_uart_stop_rx(struct uart_port *port)
+static void imx_uart_stop_rx_with_loopback_ctrl(struct uart_port *port, bool loopback)
 {
 	struct imx_port *sport = (struct imx_port *)port;
 	u32 ucr1, ucr2, ucr4, uts;
@@ -519,7 +518,7 @@ static void imx_uart_stop_rx(struct uart
 	/* See SER_RS485_ENABLED/UTS_LOOP comment in imx_uart_probe() */
 	if (port->rs485.flags & SER_RS485_ENABLED &&
 	    port->rs485.flags & SER_RS485_RTS_ON_SEND &&
-	    sport->have_rtscts && !sport->have_rtsgpio) {
+	    sport->have_rtscts && !sport->have_rtsgpio && loopback) {
 		uts = imx_uart_readl(sport, imx_uart_uts_reg(sport));
 		uts |= UTS_LOOP;
 		imx_uart_writel(sport, uts, imx_uart_uts_reg(sport));
@@ -532,6 +531,16 @@ static void imx_uart_stop_rx(struct uart
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
@@ -719,8 +728,13 @@ static void imx_uart_start_tx(struct uar
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
 


