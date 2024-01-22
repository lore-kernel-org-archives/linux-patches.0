Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CC61468ED;
	Tue, 23 Jan 2024 00:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969710; cv=none; b=i7P5Tlw2AltIFHTHm7L5uKdXXzeWfiYJkBFXzqcfMzx1lfUh77v+93m+/+j2B/4F2+/E8RWIG5japZIf+v8sozMhfdIEDCsXkeYR8+/UMytP5xpRXalPpZqcArW88EbtgbFA+mvqvw4WdT8YCp9OlK07GXMh6S5neNf1/vN46Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969710; c=relaxed/simple;
	bh=E2f4MFnRxtG9cnjHAajBlber7thOsRMoj2Q34aks8+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kxf/6UwUCr+Kajh+x3CmVdichctMhRdy1gfTqZZiG/dZg65IhmNuGuOtxJ4/9wQsKHoUhAnoFplAZBaRJSm2MRTTlT+yjuRPIQaeL+J1fvuEc0HVN3mJg5xS+TnMsKp2qT4SVCJzxSRq5UnK0tlnHjAytKThwPx/E5H9UkXRLVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFVgZIzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFVgZIzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D840C43390;
	Tue, 23 Jan 2024 00:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969710;
	bh=E2f4MFnRxtG9cnjHAajBlber7thOsRMoj2Q34aks8+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFVgZIzpXxsxsx18h97MUeV8ICGeubK5sxgDe1x6auAF2fd5QC+7+/r6RQla6s2Yi
	 LzEiCRgSf9kMbxQm3vv3IFNhj3tCiLcdvXpMdOctIneMOePj3ggsw8zQ9Mwm/PruqC
	 i9Ig/A+MT2NDYypSnjIDnocYlFVCx3O+HmNE1tt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.7 414/641] serial: core, imx: do not set RS485 enabled if it is not supported
Date: Mon, 22 Jan 2024 15:55:18 -0800
Message-ID: <20240122235830.927133140@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2206,7 +2206,6 @@ static enum hrtimer_restart imx_trigger_
 	return HRTIMER_NORESTART;
 }
 
-static const struct serial_rs485 imx_no_rs485 = {};	/* No RS485 if no RTS */
 static const struct serial_rs485 imx_rs485_supported = {
 	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND | SER_RS485_RTS_AFTER_SEND |
 		 SER_RS485_RX_DURING_TX,
@@ -2290,8 +2289,6 @@ static int imx_uart_probe(struct platfor
 	/* RTS is required to control the RS485 transmitter */
 	if (sport->have_rtscts || sport->have_rtsgpio)
 		sport->port.rs485_supported = imx_rs485_supported;
-	else
-		sport->port.rs485_supported = imx_no_rs485;
 	sport->port.flags = UPF_BOOT_AUTOCONF;
 	timer_setup(&sport->timer, imx_uart_timeout, 0);
 
@@ -2328,10 +2325,6 @@ static int imx_uart_probe(struct platfor
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
@@ -3600,6 +3600,9 @@ int uart_get_rs485_mode(struct uart_port
 	u32 rs485_delay[2];
 	int ret;
 
+	if (!(port->rs485_supported.flags & SER_RS485_ENABLED))
+		return 0;
+
 	ret = device_property_read_u32_array(dev, "rs485-rts-delay",
 					     rs485_delay, 2);
 	if (!ret) {


