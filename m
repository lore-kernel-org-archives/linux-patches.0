Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18E022083;
	Tue, 26 Aug 2025 13:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216559; cv=none; b=k/zunCQxsLLSmQF4Wm1edWbAMnl7OIHcknO3Vg0oH7nHniV4J8Dx2vpNlbt2y77dLh5pQXViPLwEsLKwZWD5eOFMxlIWUZCO8hQSfADBtMg+9FKEzeDte48qdL+8nsaqKfyLumnujuAHvwHQLT9SqiFG+2oP2ywT++LqPdO4wCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216559; c=relaxed/simple;
	bh=vnU0OpZ4FEmZAHsne9XsmpC/VUEqitOjhmH4Eqa+GJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hubP+bXnOIkHACFuFL22KepikWcn3N8yTK2Y7iBaPNW1mwvs6sfbC9P6fSt20+1l/rexp1suHoDVFQOvkvo4rFT6WLfMaouphOpisV/Vkq2w1/SWm6RrPwt1py607+WungPHKXOunRRd4L1Ud37G5Z8kmK4Ex/BWO0I7isY3IGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4/QoOuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4/QoOuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BDBC4CEF1;
	Tue, 26 Aug 2025 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216559;
	bh=vnU0OpZ4FEmZAHsne9XsmpC/VUEqitOjhmH4Eqa+GJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4/QoOuQHcP31SJ8abaip2Q7gPCi9UFAU9/mlnoPvXMNnG2sNX+BzXdlsaj7BSQr3
	 Zgl5WvI70KUTXz1Db0pgv4YzfOYERO+XM0JymfUfIldii00KYOw6aOw6J/5/MT41sm
	 jCHqeNT/qK0rBFEo+G3YY9OrlmqNrmJBEvqSs+hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	John Ogness <john.ogness@linutronix.de>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 456/644] serial: 8250: fix panic due to PSLVERR
Date: Tue, 26 Aug 2025 13:09:07 +0200
Message-ID: <20250826110957.776429706@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Applied fix to serial8250_do_startup() instead of serial8250_initialize() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2332,9 +2332,8 @@ int serial8250_do_startup(struct uart_po
 	/*
 	 * Now, initialize the UART
 	 */
-	serial_port_out(port, UART_LCR, UART_LCR_WLEN8);
-
 	spin_lock_irqsave(&port->lock, flags);
+	serial_port_out(port, UART_LCR, UART_LCR_WLEN8);
 	if (up->port.flags & UPF_FOURPORT) {
 		if (!up->port.irq)
 			up->port.mctrl |= TIOCM_OUT1;


