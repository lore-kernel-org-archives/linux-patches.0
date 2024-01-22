Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39F46EB67;
	Tue, 23 Jan 2024 02:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975419; cv=none; b=L5uQQWHgscuHkBGrCw2AKtaO2yf5weHzndOgv7YyNg3EsvNcKyWLwDIX0EgwdB6YmhL9IjUx4Vs3gMm1nCSJhLhpu5/1+QRt7QP0KXFclGxeZfHVL2jkjHiENjnW87/X/m/8nB+JtLjEjCt4OF66yUOKLb/oB7AxzgfAoomnwpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975419; c=relaxed/simple;
	bh=5FM8tlKliZty0KiH9FjWz0KmwKOCz27HnRdNWe7xF1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ee0busPoAjAcS5AjayRb6MFnfBQrYqaqvKqdSna67nGo/2y1qIRJMJsAaFbjoV/yerAtzF53QcEBMCGtF+Q6gaghl3825ZmspUgtbKLkjHMnjrKTXsIVNwncOmPrLcxyh/+KlMWW9umNK3voYFoShYQ0SOYE1DzdNOiF2zwMeDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dPTov8kN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPTov8kN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80FDC43601;
	Tue, 23 Jan 2024 02:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975418;
	bh=5FM8tlKliZty0KiH9FjWz0KmwKOCz27HnRdNWe7xF1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPTov8kNrncUgGM989LscWMyUYN85ziE9npUNLzukXdD/f3ZrKnf0EeDjiu4evcuz
	 AMwxkQ6GFEyOLRiVpHWNtTK56C3kYlC+IAE3i6qC2p6lPoyZnwDjXLWQ40Cgj2W8C5
	 hNEFBHtOouem3pLF0ysS1NK6DJjLr1Fi4oO3dMY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 6.6 377/583] serial: 8250_exar: Set missing rs485_supported flag
Date: Mon, 22 Jan 2024 15:57:08 -0800
Message-ID: <20240122235823.553500226@linuxfoundation.org>
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

commit 0c2a5f471ce58bca8f8ab5fcb911aff91eaaa5eb upstream.

The UART supports an auto-RTS mode in which the RTS pin is automatically
activated during transmission. So mark this mode as being supported even
if RTS is not controlled by the driver but the UART.

Also the serial core expects now at least one of both modes rts-on-send or
rts-after-send to be supported. This is since during sanitization
unsupported flags are deleted from a RS485 configuration set by userspace.
However if the configuration ends up with both flags unset, the core prints
a warning since it considers such a configuration invalid (see
uart_sanitize_serial_rs485()).

Cc:  <stable@vger.kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Link: https://lore.kernel.org/r/20240103061818.564-8-l.sanfilippo@kunbus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_exar.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -446,7 +446,7 @@ static int generic_rs485_config(struct u
 }
 
 static const struct serial_rs485 generic_rs485_supported = {
-	.flags = SER_RS485_ENABLED,
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND,
 };
 
 static const struct exar8250_platform exar8250_default_platform = {
@@ -490,7 +490,8 @@ static int iot2040_rs485_config(struct u
 }
 
 static const struct serial_rs485 iot2040_rs485_supported = {
-	.flags = SER_RS485_ENABLED | SER_RS485_RX_DURING_TX | SER_RS485_TERMINATE_BUS,
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND |
+		 SER_RS485_RX_DURING_TX | SER_RS485_TERMINATE_BUS,
 };
 
 static const struct property_entry iot2040_gpio_properties[] = {


