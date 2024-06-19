Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F62F12FB31;
	Wed, 19 Jun 2024 13:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802579; cv=none; b=B002gtFjrhsTYqI26TGdM5ip+xxCfdlgNR1c1UA0uuuQ29OJpXeyF3S0nwpcF7NpkoN+CFxnJ0QN0Dy+We3A1k95ZQfVdcfKpZokdvvd5aMp39H4ZYvvLGhSxWol5uMc1SQ5buGrZ2XVCJqKtQw/lTS2OvLYQ1WPyHDYD0hhgSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802579; c=relaxed/simple;
	bh=JduzhcQN04G+Dwz8yqURhrhb5c7oiZazWJklCw+uNI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYpFxJ458UC+XdCExtHUlNbRXg/bhBGC5DHX13grjIKHWYQhnztbpd/o6cYFIhrZA+bBXN6CdDsOSWecMNKXzByER1YV77OHesmdgQ438p9mRQBbXimEWReox5DllAcrlsNdnW9MyF6s3OUdi3LD6HFvonLdRhfdNhVRWNUJdY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r35cp9HX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r35cp9HX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233F1C2BBFC;
	Wed, 19 Jun 2024 13:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802579;
	bh=JduzhcQN04G+Dwz8yqURhrhb5c7oiZazWJklCw+uNI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r35cp9HXbksJMcYFwatDUWmgrF6eSjTvI3ic8u0cl3xXphe/2aJnAoouSrQPnG+Wc
	 t87gWdKALpYdNK5cXoEHEA3WFeCjGEtP6ng7JqghdWeKiOlJisgZu+hnWaqUO8xwA6
	 B/P3C/cYS/wGoanVYBct5ohVdS5JvgbubNFK03e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Brown <doug@schmorgal.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 244/267] serial: 8250_pxa: Configure tx_loadsz to match FIFO IRQ level
Date: Wed, 19 Jun 2024 14:56:35 +0200
Message-ID: <20240619125615.687293537@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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


