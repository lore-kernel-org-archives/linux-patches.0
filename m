Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04F81C6887;
	Tue, 27 Aug 2024 15:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770902; cv=none; b=L8V5uGRv/YUoajFVVbPVhy0FEs9yRyePF0AqTFsdHAEUSW40qVXZ/XY/v5PKvElm/oRFTUyuPrUIW49wMEe2+RgXh2KKYsZBALs5K4h3jDhzY5XBfgtQUwB01gs312QEicmP7co/Eedg6LUscn040geE5+FEd1qclezgtaYAL+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770902; c=relaxed/simple;
	bh=NitfEoV6gR+O8l+kU2GxNtpsT5R8vGu8vaRYb2FKEVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GthPJRl/TQzxqJp5+tj1FHxHjTCGcls6mN0RnK8I3W1O2UCg883nlQCVj6UQTe9TGsGomfGKh8Pk8wQoivcSSIydOmrPFpLmIl43W6MgGiTMgJlhvkkOq5NsPdsFYEImV0LtT2f8KMeZhvB06BUAPDySPxSUer544znJYTtruEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYfpbuXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYfpbuXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A414C4AF1C;
	Tue, 27 Aug 2024 15:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770902;
	bh=NitfEoV6gR+O8l+kU2GxNtpsT5R8vGu8vaRYb2FKEVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYfpbuXBk1c1gs7Bj8jgrPsMDDhuJnDEplI6O+jSTCcGezhi32lYeaT0Uhpi7i29X
	 rqyrEXfbjnSyjrixgzve9f14q0lZhj+8D0mqnZTVl+sPx7CZrHVHIgaK/jM/MZ6FEr
	 8OTJvPV2SwMRzDxuCSwHeJD6rH2N+k+vJkTYa/20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Othacehe <othacehe@gnu.org>,
	stable <stable@kernel.org>,
	Alexander Dahl <ada@thorsis.com>
Subject: [PATCH 6.10 003/273] tty: atmel_serial: use the correct RTS flag.
Date: Tue, 27 Aug 2024 16:35:27 +0200
Message-ID: <20240827143833.507389844@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2514,7 +2514,7 @@ static const struct uart_ops atmel_pops
 };
 
 static const struct serial_rs485 atmel_rs485_supported = {
-	.flags = SER_RS485_ENABLED | SER_RS485_RTS_AFTER_SEND | SER_RS485_RX_DURING_TX,
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND | SER_RS485_RX_DURING_TX,
 	.delay_rts_before_send = 1,
 	.delay_rts_after_send = 1,
 };


