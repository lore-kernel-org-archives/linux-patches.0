Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0834E64CFD;
	Tue, 23 Jan 2024 00:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971591; cv=none; b=hiMYXeOUM9tEQcdx9Mpeu46SoS5fNC9uZQx7/U4da6bL18nkDeTBjVGy2F5Vbtx7akQiIa9PiogcoMGWFEYDfWHfAkYs2B4GW9KLiuTFYEXlajkqrt60nJ+XZk563c+tTXxIM4HFdFLbTFeDUSauw5xuyVAoVJk4Ru4dN5KieS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971591; c=relaxed/simple;
	bh=WdU9xLpKsf5M8/OxwKQGXXd+d7qtdIR5OZK6UEyuxVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NjV5UBob3Ovg9gwutfWIQoEc5DAbU8RxFjVGeAzgU75K+nIxYJip7UAiHDyZHYbv9/K3+P26cHBckXJQPFM6fRxAH7WMQxlvswp8c5WmWZpQdXeMx49zDu1/+bRfvXfLuwXJf5nQEyWVTFXvqdT01HpBS8csw67wBZTF/mW9Om4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s70aRrJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s70aRrJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE391C433C7;
	Tue, 23 Jan 2024 00:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971590;
	bh=WdU9xLpKsf5M8/OxwKQGXXd+d7qtdIR5OZK6UEyuxVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s70aRrJuA09/3uDmP6LMGbCxiE2/ZZ6exvQTGZI99Yrer/l+xiQq923lhsjhSWUSI
	 ZxVi76g3BLocB85EVciV7WCtoiV0uxLOdSNV5jSEDSKrMsOa2apiKsXiazgBlb7rQF
	 xGK1OEMkNVU3Jwt3V54Y+dOxbZ0AL2/dmaLCN74U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 6.1 275/417] serial: 8250_exar: Set missing rs485_supported flag
Date: Mon, 22 Jan 2024 15:57:23 -0800
Message-ID: <20240122235801.375814402@linuxfoundation.org>
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
@@ -442,7 +442,7 @@ static int generic_rs485_config(struct u
 }
 
 static const struct serial_rs485 generic_rs485_supported = {
-	.flags = SER_RS485_ENABLED,
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND,
 };
 
 static const struct exar8250_platform exar8250_default_platform = {
@@ -486,7 +486,8 @@ static int iot2040_rs485_config(struct u
 }
 
 static const struct serial_rs485 iot2040_rs485_supported = {
-	.flags = SER_RS485_ENABLED | SER_RS485_RX_DURING_TX | SER_RS485_TERMINATE_BUS,
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND |
+		 SER_RS485_RX_DURING_TX | SER_RS485_TERMINATE_BUS,
 };
 
 static const struct property_entry iot2040_gpio_properties[] = {


