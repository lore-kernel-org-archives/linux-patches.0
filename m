Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E851313B2AC;
	Wed,  3 Jul 2024 11:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005618; cv=none; b=ldy7OEb734RCT+OCOHYJljL09r2ojWKc/b5Ep6K7topbTJSi2JCQHVqIII2Ksp12aoNCkrB6NYRFcjGWECn9aThHsFjyciOIuO6MC03k2zDh+9QZKea5UC+1urmHsVzVZ9lzuBILE8iexU5i/P9gKcZ220M1/BlAZkjEwhKphyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005618; c=relaxed/simple;
	bh=OUVV2tRxT6jEq5XvwVq+rDMc0clEeHpkSk25UnvSb2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGZH9e7jAPn35O9ISi1sLICbN/hA5BXsnR/3wcCAxamseJtC5zhVFaVPsoGR/k9wbNvMpzFTwW1cPnv97phWZqZJOpAVryX9heszkRc0zHhAoIz0PrfZcTw8MlxmZxoo0LIeErfhlcXmJhuPl5PtpXlsEKkMOB9BL3LJgQCKkIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W21KIGw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W21KIGw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64998C2BD10;
	Wed,  3 Jul 2024 11:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005617;
	bh=OUVV2tRxT6jEq5XvwVq+rDMc0clEeHpkSk25UnvSb2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W21KIGw03h0PI7ndIOKZ8ePHL8okQzjEmdzUHHaVOo36oDdHFhWBV9gWuKa2RoIZi
	 M8Ezk4nABfWCQc+jyjrFjZFnNkz6EC/GJfK7xL/Jzc0DZ8jBk32LzNNIHZF3y54c4C
	 deQcn97YL6TKz0M9mQifJ4fj/2w2YdnkQY5bkIMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Brown <doug@schmorgal.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 138/356] serial: 8250_pxa: Configure tx_loadsz to match FIFO IRQ level
Date: Wed,  3 Jul 2024 12:37:54 +0200
Message-ID: <20240703102918.322235889@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Doug Brown <doug@schmorgal.com>

commit 5208e7ced520a813b4f4774451fbac4e517e78b2 upstream.

The FIFO is 64 bytes, but the FCR is configured to fire the TX interrupt
when the FIFO is half empty (bit 3 = 0). Thus, we should only write 32
bytes when a TX interrupt occurs.

This fixes a problem observed on the PXA168 that dropped a bunch of TX
bytes during large transmissions.

Fixes: ab28f51c77cd ("serial: rewrite pxa2xx-uart to use 8250_core")
Signed-off-by: Doug Brown <doug@schmorgal.com>
Link: https://lore.kernel.org/r/20240519191929.122202-1-doug@schmorgal.com
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pxa.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/8250/8250_pxa.c
+++ b/drivers/tty/serial/8250/8250_pxa.c
@@ -125,6 +125,7 @@ static int serial_pxa_probe(struct platf
 	uart.port.regshift = 2;
 	uart.port.irq = irq;
 	uart.port.fifosize = 64;
+	uart.tx_loadsz = 32;
 	uart.port.flags = UPF_IOREMAP | UPF_SKIP_TEST | UPF_FIXED_TYPE;
 	uart.port.dev = &pdev->dev;
 	uart.port.uartclk = clk_get_rate(data->clk);


