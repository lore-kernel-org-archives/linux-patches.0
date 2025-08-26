Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED8572627;
	Tue, 26 Aug 2025 11:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756206781; cv=none; b=DubF3BVuC1AkE8z9jhtd4jQMynljGue0ibH7cHENuTe9gTI3nOEfSt7VTMkES/MEnnLXMdceA+kVJrVAvkKyQUOMi4zKrXP4yASiGUbdJ4d6gRCuNBEImluP/PXMR6Dcj0E4O1y71efShP9i1zEJhr/D6bFh+oAHQAmigzulXCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756206781; c=relaxed/simple;
	bh=gyxlKtz/QtYR6R0q9Z7REqN9FRwP0qP0MhRrxZDtGIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmYINbYQAJpm5bTXywPpRI3JJnspfJid0X8eH3FLFKJz+YbSDW+IvtpwZeNQbmSoWAWD60UNfg14LPcP5AlFOaQd8+jBF4BqAvzOgg7ZCh/W9eUua8vrDrVHU9xJWBIAzgdk1A1dLMPx+NrVUqwyIltFA3bi8WyuTgYvvROyhG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJwVe3QN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJwVe3QN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE824C4CEF1;
	Tue, 26 Aug 2025 11:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756206781;
	bh=gyxlKtz/QtYR6R0q9Z7REqN9FRwP0qP0MhRrxZDtGIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJwVe3QNRzQKE5u+eZKM19UYMMvX0fWYe36CGpOnT3u8qBlJ0EEy1fsgwlhpd47Kq
	 AKRunRJV3N+clhaRFFqFZVaIvyAa2mNVsVVE7DVHgK2sC5yJJFxZc2h0F15FIfdo6h
	 sMblXVzpE1bB2l/lSQXBJRetFHabE1VQ4Zua2W/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	John Ogness <john.ogness@linutronix.de>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/322] serial: 8250: fix panic due to PSLVERR
Date: Tue, 26 Aug 2025 13:06:56 +0200
Message-ID: <20250826110915.218809285@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunhui Cui <cuiyunhui@bytedance.com>

commit 7f8fdd4dbffc05982b96caf586f77a014b2a9353 upstream.

When the PSLVERR_RESP_EN parameter is set to 1, the device generates
an error response if an attempt is made to read an empty RBR (Receive
Buffer Register) while the FIFO is enabled.

In serial8250_do_startup(), calling serial_port_out(port, UART_LCR,
UART_LCR_WLEN8) triggers dw8250_check_lcr(), which invokes
dw8250_force_idle() and serial8250_clear_and_reinit_fifos(). The latter
function enables the FIFO via serial_out(p, UART_FCR, p->fcr).
Execution proceeds to the serial_port_in(port, UART_RX).
This satisfies the PSLVERR trigger condition.

When another CPU (e.g., using printk()) is accessing the UART (UART
is busy), the current CPU fails the check (value & ~UART_LCR_SPAR) ==
(lcr & ~UART_LCR_SPAR) in dw8250_check_lcr(), causing it to enter
dw8250_force_idle().

Put serial_port_out(port, UART_LCR, UART_LCR_WLEN8) under the port->lock
to fix this issue.

Panic backtrace:
[    0.442336] Oops - unknown exception [#1]
[    0.442343] epc : dw8250_serial_in32+0x1e/0x4a
[    0.442351]  ra : serial8250_do_startup+0x2c8/0x88e
...
[    0.442416] console_on_rootfs+0x26/0x70

Fixes: c49436b657d0 ("serial: 8250_dw: Improve unwritable LCR workaround")
Link: https://lore.kernel.org/all/84cydt5peu.fsf@jogness.linutronix.de/T/
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250723023322.464-2-cuiyunhui@bytedance.com
[ adapted to inline code structure without separate serial8250_initialize helper function ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2351,9 +2351,8 @@ int serial8250_do_startup(struct uart_po
 	/*
 	 * Now, initialize the UART
 	 */
-	serial_port_out(port, UART_LCR, UART_LCR_WLEN8);
-
 	uart_port_lock_irqsave(port, &flags);
+	serial_port_out(port, UART_LCR, UART_LCR_WLEN8);
 	if (up->port.flags & UPF_FOURPORT) {
 		if (!up->port.irq)
 			up->port.mctrl |= TIOCM_OUT1;


