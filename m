Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415842C21F7;
	Sat, 12 Sep 2026 08:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200360; cv=none; b=ZLIfj8GVcnO3SD/z7ERDUtC5uqqkIL0JhOJyyKHNzt9fEP/3jJKTnu5bRnbOR/ZUaw+ETcO/fty32vLCMyvVB1+8fXTStiAEmZJORSps30ZKy3vU4tdsSuhB3mvA4g07hA4kzfB9cW96zABm6H0BZ9lawwBB1XHI6Gzj9E6Yxzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200360; c=relaxed/simple;
	bh=J1ZB4gKFR1wRqdiclCrEy5M86YI2Z6evQxvyckKUlUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2AsjYs5xYzfDb6LsYWKhGSaR0Iri1SN4B/mOxxDH4HvkEDEWPwzxiEvfUaCf0ULRnJGoluPIg+fxz8j/4NanXhVAyIBSHawnjSfik/Gz1qiaKzN7N1ABHavauJ1mydrxPtuzzNZe9lPcDAQgs48D6Znx9CSGNdWY5NzQtvRJtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qmx7OrZX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qmx7OrZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC001F000FF;
	Sat, 12 Sep 2026 08:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200359;
	bh=0XEgrXKPyjFu1ypt6MNGhX1Zdh1s6HYcXsZ+Z8k0vPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qmx7OrZXLmLYK95lvy2FIi0KX8wv9gVcqbkWOTvGY5TI2qFHjZLLAXnVfs6aX0bTK
	 mxQlqK78o4imSYO2rl8TxOTzdT9eyLKtJ2zZvFUe8kqYQWobjQCzqQItZygMCWmKF8
	 5xgxlv+qlM8Na+pvRT/AKdIwRXHnEnMihz5OJCRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Fushuai Wang <wangfushuai@baidu.com>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0772/1815] Revert "serial: 8250: Clear CON_PRINTBUFFER on port re-registration"
Date: Sat, 12 Sep 2026 08:42:02 +0200
Message-ID: <20260912065707.032100719@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fushuai Wang <wangfushuai@baidu.com>

[ Upstream commit 57c0741b8c15b93ba4aa92c6618cde6f3f4115b2 ]

This reverts commit d338ab1d90603f875c4f7ed223406535378173a5.

uart_console() only indicates that the port is selected as the console.
It does not mean that the console has already been registered or has
printed the buffered messages.

On platforms where an initial 8250 port is replaced when the real UART
device is registered, clearing CON_PRINTBUFFER causes the console to
start at the end of the printk ring buffer. Without earlycon, all
messages logged before UART registration are therefore lost.

Fixes: d338ab1d9060 ("serial: 8250: Clear CON_PRINTBUFFER on port re-registration")
Reported-by: Mark Brown <broonie@kernel.org>
Reported-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Link: https://lore.kernel.org/all/20260522101042.21976-1-fushuai.wang@linux.dev/
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Link: https://patch.msgid.link/20260724093151.53216-1-fushuai.wang@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index c0e8a4efbdcc8..f49862d90eebb 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -720,12 +720,8 @@ int serial8250_register_8250_port(const struct uart_8250_port *up)
 	/* Preserve specified console flow control. */
 	cons_flow = uart_cons_flow_enabled(&uart->port);
 
-	if (uart->port.dev) {
-		if (uart_console(&uart->port))
-			uart->port.cons->flags &= ~CON_PRINTBUFFER;
-
+	if (uart->port.dev)
 		uart_remove_one_port(&serial8250_reg, &uart->port);
-	}
 
 	uart->port.ctrl_id	= up->port.ctrl_id;
 	uart->port.port_id	= up->port.port_id;
-- 
2.53.0



