Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E8114C580;
	Wed, 19 Jun 2024 13:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804125; cv=none; b=M2QVFQVW422Y8tCUmidfgZs4HklEKe/3PqYaaI7VmFZI7lS9ez5gJGiAIESCkVZoLDSdUlK/mhhk4HRW4P0UjiNQc2YlxFYmzJDlr/6KSq5X0b9A6w00G/3O3GNyo5IcviHmdHtGencbklb11Pr7FmzPdpeULvacAbnzkxG0A0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804125; c=relaxed/simple;
	bh=k9nUsWFYW3H+xIPly7BPE67emRGM/I/iKoXUnz5T21U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbynAFpqf/z8acnl1W9+QtDJshv7Sm24U6O4CeRrnrflhwIFDe1Y51ptGNtVHPzHo9FvD6zbKBULICxPKx+3WoUPMD3567/ZVtstWetOOk/NpSABmXCf1+87mJk8GFcN8VROBk7C7zhF2myyikkZFEr87x1PLaE/mwbh740/vYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWO1w1gq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWO1w1gq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EF0C2BBFC;
	Wed, 19 Jun 2024 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804125;
	bh=k9nUsWFYW3H+xIPly7BPE67emRGM/I/iKoXUnz5T21U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWO1w1gqmnzXDMPVGfybm6VPW7gALDr2RqUedGW14WayN46qS4bLZZ+AsoslVl1uG
	 SMP8RoncJa53kZGwZlnFG31EGiBIAycD06wj/o1r+9lm1cIUBoJAaWnBG0G0Yvt/TA
	 pdtP8FSEI8R/cWhCKu0wdGgY5aGH3q7L64giD0xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Brown <doug@schmorgal.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 203/217] serial: 8250_pxa: Configure tx_loadsz to match FIFO IRQ level
Date: Wed, 19 Jun 2024 14:57:26 +0200
Message-ID: <20240619125604.520183859@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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
@@ -124,6 +124,7 @@ static int serial_pxa_probe(struct platf
 	uart.port.regshift = 2;
 	uart.port.irq = irq;
 	uart.port.fifosize = 64;
+	uart.tx_loadsz = 32;
 	uart.port.flags = UPF_IOREMAP | UPF_SKIP_TEST | UPF_FIXED_TYPE;
 	uart.port.dev = &pdev->dev;
 	uart.port.uartclk = clk_get_rate(data->clk);


