Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFAF1494AC;
	Tue, 27 Aug 2024 14:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769711; cv=none; b=mHGK0BWle2PPP0iouxa4GHak5Q8iYr7re6MoKM6UqH3J2oHdk0mCIWCjOQB/iUKRx15wkfRd7XT8wCZAJdNCSxWCU/ZCfFyjOZC//M4PVHTPHEL5Ogy3FB7zzOiDRrtUboVsIl7i5NTvtSIPbvuj6wQT/OlXO/dOImvpI/ofxG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769711; c=relaxed/simple;
	bh=A/VDI6mIIXVnhFubwbIhDSGMC8dldFGNi108UpBW998=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FP4YGdtjWc+SxxmdjZ9VBGTlnOSwR/q2gOH9Q+z4g0K+pfqPDg0ejaniheWwvEFbcSAQ020UJd4kaJtLijpiFlBOGGx+m757CZriG7jRaGdXtRoYX+k1P8qkOj6AcW5cpPu/TtFutmzYiW89qI1zt4Ycl2ls/Nit624mYEW4/UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0Lf9eEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0Lf9eEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E1DC4AF1C;
	Tue, 27 Aug 2024 14:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769711;
	bh=A/VDI6mIIXVnhFubwbIhDSGMC8dldFGNi108UpBW998=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0Lf9eEa585Xrzvoi12ERNrBlUFDIoGIpJojcVPy43t/nu7mpPftIMDoejP4ItbU3
	 Ym0bTXXpu1mT+ShVmZHJHq8WR8rbYJHiDj3VKoDrWyLwDDZz105qhvS+kPMWFAcmJh
	 DvYkdLCyCfJmV1ulOS8NWz7EErb0Q12eWTIUjA4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Othacehe <othacehe@gnu.org>,
	stable <stable@kernel.org>,
	Alexander Dahl <ada@thorsis.com>
Subject: [PATCH 6.6 002/341] tty: atmel_serial: use the correct RTS flag.
Date: Tue, 27 Aug 2024 16:33:53 +0200
Message-ID: <20240827143843.497707633@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Othacehe <othacehe@gnu.org>

commit c9f6613b16123989f2c3bd04b1d9b2365d6914e7 upstream.

In RS485 mode, the RTS pin is driven high by hardware when the transmitter
is operating. This behaviour cannot be changed. This means that the driver
should claim that it supports SER_RS485_RTS_ON_SEND and not
SER_RS485_RTS_AFTER_SEND.

Otherwise, when configuring the port with the SER_RS485_RTS_ON_SEND, one
get the following warning:

kern.warning kernel: atmel_usart_serial atmel_usart_serial.2.auto:
ttyS1 (1): invalid RTS setting, using RTS_AFTER_SEND instead

which is contradictory with what's really happening.

Signed-off-by: Mathieu Othacehe <othacehe@gnu.org>
Cc: stable <stable@kernel.org>
Tested-by: Alexander Dahl <ada@thorsis.com>
Fixes: af47c491e3c7 ("serial: atmel: Fill in rs485_supported")
Link: https://lore.kernel.org/r/20240808060637.19886-1-othacehe@gnu.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/atmel_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2522,7 +2522,7 @@ static const struct uart_ops atmel_pops
 };
 
 static const struct serial_rs485 atmel_rs485_supported = {
-	.flags = SER_RS485_ENABLED | SER_RS485_RTS_AFTER_SEND | SER_RS485_RX_DURING_TX,
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND | SER_RS485_RX_DURING_TX,
 	.delay_rts_before_send = 1,
 	.delay_rts_after_send = 1,
 };


