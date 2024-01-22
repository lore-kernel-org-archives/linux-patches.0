Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8426EB61;
	Tue, 23 Jan 2024 02:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975416; cv=none; b=FxW0MA912rnk2tWs+MdILxFcx71uJBCrmOg+URJ8F6VW5ngiGch9WoBi7iD5ILF+aNNkVVljMUIJkfFaG77mN98Y788XtzNdN0YFsLXt7FtNXYCc3SDBk8xNRA5T8CaZNB4y+UZL1b1/ecyWWft946s2kUfLEx5yNucfpuXn0Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975416; c=relaxed/simple;
	bh=gOGQ2AoleU8kApo8eYXgK8muZ1uzf0XoYFTP/bnV298=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fN8HpVqtFw3fE8CAAvQJQVNlYmacCgbPROApMwOpivzG3s8b+a2fwwSEQRefQAw18RcLgJwSSSddHSpwiJsCfaPwJ3OsFxc/p7siTSO6ZRWiWkXBKRIZeSrGQu6QQkTcvyHG1GyqkVOeSO2ko287uT4qB/yA+lMauQ/2w0HYnmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8ErKbte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8ErKbte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BBCC43390;
	Tue, 23 Jan 2024 02:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975416;
	bh=gOGQ2AoleU8kApo8eYXgK8muZ1uzf0XoYFTP/bnV298=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8ErKbteKeSnTVdP62T7lU6PlilziRT+RH8nesKPXv2KNtbTWiEQER2dYpNsBdkht
	 fiGUkxAcm3eUl6i0H1XrsuoiRCsbC9XV9j0f2vv7F9l9uX000AZlrRtzkImz4ywnrr
	 euetvNsSLPd6eydZlULMfT+BofAUq4Rbha658m1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 375/583] serial: core, imx: do not set RS485 enabled if it is not supported
Date: Mon, 22 Jan 2024 15:57:06 -0800
Message-ID: <20240122235823.489756343@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2214,7 +2214,6 @@ static enum hrtimer_restart imx_trigger_
 	return HRTIMER_NORESTART;
 }
 
-static const struct serial_rs485 imx_no_rs485 = {};	/* No RS485 if no RTS */
 static const struct serial_rs485 imx_rs485_supported = {
 	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND | SER_RS485_RTS_AFTER_SEND |
 		 SER_RS485_RX_DURING_TX,
@@ -2298,8 +2297,6 @@ static int imx_uart_probe(struct platfor
 	/* RTS is required to control the RS485 transmitter */
 	if (sport->have_rtscts || sport->have_rtsgpio)
 		sport->port.rs485_supported = imx_rs485_supported;
-	else
-		sport->port.rs485_supported = imx_no_rs485;
 	sport->port.flags = UPF_BOOT_AUTOCONF;
 	timer_setup(&sport->timer, imx_uart_timeout, 0);
 
@@ -2336,10 +2333,6 @@ static int imx_uart_probe(struct platfor
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
@@ -3576,6 +3576,9 @@ int uart_get_rs485_mode(struct uart_port
 	int ret;
 	int rx_during_tx_gpio_flag;
 
+	if (!(port->rs485_supported.flags & SER_RS485_ENABLED))
+		return 0;
+
 	ret = device_property_read_u32_array(dev, "rs485-rts-delay",
 					     rs485_delay, 2);
 	if (!ret) {


