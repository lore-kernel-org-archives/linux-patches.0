Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B3F657AB;
	Tue, 23 Jan 2024 00:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971580; cv=none; b=dPPC1I5Qr+qh1Uhy4Sbt9D5fI4LSapFreY7v71+y5NjRA3u4abbCQc5L55/H3S4MjC3MpnNKnRf8ve1oFdHNLCojcghMdPgT9kbOvEWYmt3vw0ztn9kV9Z6rhxBDk1cmGCQCHMmhsKENPpo0Ia5jE4my0TEg0AvJMsROvAIEdpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971580; c=relaxed/simple;
	bh=AUT75iNh/GrPMDYO1q6i/EIx9eom2WS80aNvXoqydGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G0pNtNdrIs+Ilq2R12lLloyOmqBcm6H8Aeejb0qORHmam0r+ACKY4Lx5o36flq8wUcPHZw//g0Peq6xlYcVEWr7/rEeUjgHBEoX9yXPQA5bln+w0bJ7m7l+xJocBTREKK7Fcob6IhanD8lgvzlMejWY17YJ8uwkaxAEJWsjdi+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMMdpbzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMMdpbzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86EDC433F1;
	Tue, 23 Jan 2024 00:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971580;
	bh=AUT75iNh/GrPMDYO1q6i/EIx9eom2WS80aNvXoqydGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMMdpbzi+oSJOFIb0hmb7u9+Tq+n9a91K5t5q18Fb9AApBX196cn0RYqdADdpFUhd
	 lBcIGmLA6AzM7yP7e7q7zC3G5CUjzzVdP5tdB2zBOeFul/xbzc0AhmS5uOA/X1KoTD
	 iNNkNoIE3M4TpJqyBhth4caiHoNkPMtTeQa1B4no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.1 273/417] serial: core, imx: do not set RS485 enabled if it is not supported
Date: Mon, 22 Jan 2024 15:57:21 -0800
Message-ID: <20240122235801.309496249@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

commit 74eab89b26ac433ad857292f4707b43c1a8f0209 upstream.

If the imx driver cannot support RS485 it nullifies the ports
rs485_supported structure. But it still calls uart_get_rs485_mode() which
may set the RS485_ENABLED flag nevertheless.

This may lead to an attempt to configure RS485 even if it is not supported
when the flag is evaluated in uart_configure_port() at port startup.

Avoid this by bailing out of uart_get_rs485_mode() if the RS485_ENABLED
flag is not supported by the caller.

With this fix a check for RTS availability is now obsolete in the imx
driver, since it can not evaluate to true any more. So remove this check.

Furthermore the explicit nullifcation of rs485_supported is not needed,
since the memory has already been set to zeros at allocation. So remove
this, too.

Fixes: 00d7a00e2a6f ("serial: imx: Fill in rs485_supported")
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc:  <stable@vger.kernel.org>
Suggested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240103061818.564-6-l.sanfilippo@kunbus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c         |    7 -------
 drivers/tty/serial/serial_core.c |    3 +++
 2 files changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2229,7 +2229,6 @@ static enum hrtimer_restart imx_trigger_
 	return HRTIMER_NORESTART;
 }
 
-static const struct serial_rs485 imx_no_rs485 = {};	/* No RS485 if no RTS */
 static const struct serial_rs485 imx_rs485_supported = {
 	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND | SER_RS485_RTS_AFTER_SEND |
 		 SER_RS485_RX_DURING_TX,
@@ -2319,8 +2318,6 @@ static int imx_uart_probe(struct platfor
 	/* RTS is required to control the RS485 transmitter */
 	if (sport->have_rtscts || sport->have_rtsgpio)
 		sport->port.rs485_supported = imx_rs485_supported;
-	else
-		sport->port.rs485_supported = imx_no_rs485;
 	sport->port.flags = UPF_BOOT_AUTOCONF;
 	timer_setup(&sport->timer, imx_uart_timeout, 0);
 
@@ -2364,10 +2361,6 @@ static int imx_uart_probe(struct platfor
 		return ret;
 	}
 
-	if (sport->port.rs485.flags & SER_RS485_ENABLED &&
-	    (!sport->have_rtscts && !sport->have_rtsgpio))
-		dev_err(&pdev->dev, "no RTS control, disabling rs485\n");
-
 	/*
 	 * If using the i.MX UART RTS/CTS control then the RTS (CTS_B)
 	 * signal cannot be set low during transmission in case the
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3428,6 +3428,9 @@ int uart_get_rs485_mode(struct uart_port
 	u32 rs485_delay[2];
 	int ret;
 
+	if (!(port->rs485_supported.flags & SER_RS485_ENABLED))
+		return 0;
+
 	ret = device_property_read_u32_array(dev, "rs485-rts-delay",
 					     rs485_delay, 2);
 	if (!ret) {


