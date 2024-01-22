Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B931E1474B5;
	Tue, 23 Jan 2024 00:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969715; cv=none; b=LxZHPEwqNJnbMDBrEKzEGyH3rJHEawJNA0iohszln1caCuM1uxNzsTF+e7Ey5yHF9JK8ubKQNtGQn/u+8h66Hnv+UdHH41/zxCjMHxGRZry8hrLzUhYKbIK8Xd4AU7M5Ixqagl6nX5DEX/ubGxE2sXYY1wzHhGaNI1YxvK8JaaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969715; c=relaxed/simple;
	bh=hwhH6eEFQZCtBsZDk4V3mKNkw09/uHpxp2ObkgyIpWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WgoybfnX8ObKSgKbtp4d5+leK3bFNXEGpynQdAzV6OFCXxopMj3kE1lkJYjA+cK3Id0RFD0lLsg29clOve5jpOCBLEgMUM50CmWFYlPusCqT35cdQidfKrXOPlQaudNFAe0Zw78IfIc0+ktcBp6k800HT8mJvrXPOzeueuv1bPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzMm/Kn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzMm/Kn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633F2C433C7;
	Tue, 23 Jan 2024 00:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969715;
	bh=hwhH6eEFQZCtBsZDk4V3mKNkw09/uHpxp2ObkgyIpWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gzMm/Kn9FjSYQmBhtAf4w2fLBmbg9oHABb20ODYgko33rmN/lfqEDExlXGFa9GFNG
	 yh0ur2gb6oL+e/ObQZeral6/B25fXzFV6vb9oTKEDHnFuUYgk5CNhDo/475TWs8U+b
	 LsDFXF12fvFOI+VqvhxfiNPdmPs+alo2azwTIqXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 6.7 416/641] serial: 8250_exar: Set missing rs485_supported flag
Date: Mon, 22 Jan 2024 15:55:20 -0800
Message-ID: <20240122235830.992990144@linuxfoundation.org>
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
@@ -480,7 +480,7 @@ static int sealevel_rs485_config(struct
 }
 
 static const struct serial_rs485 generic_rs485_supported = {
-	.flags = SER_RS485_ENABLED,
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND,
 };
 
 static const struct exar8250_platform exar8250_default_platform = {
@@ -524,7 +524,8 @@ static int iot2040_rs485_config(struct u
 }
 
 static const struct serial_rs485 iot2040_rs485_supported = {
-	.flags = SER_RS485_ENABLED | SER_RS485_RX_DURING_TX | SER_RS485_TERMINATE_BUS,
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND |
+		 SER_RS485_RX_DURING_TX | SER_RS485_TERMINATE_BUS,
 };
 
 static const struct property_entry iot2040_gpio_properties[] = {


