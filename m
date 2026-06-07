Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEE03242DF;
	Sun,  7 Jun 2026 10:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829826; cv=none; b=tktIa49uJXieI8W/b8XQwzztlVlDmdnTeIWnYwQwh2unC1COm5J2eHPUukVAKFHXHzjl4k8RF5FqA06VxZ6jPZoi+sflVPgnFAaxj5EcR93Ak75rfbVVCpPfx6XjxOWYASJCj2UN0gYeyRxL8o4KKezTN/iGm8zOrm+WbHPUQS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829826; c=relaxed/simple;
	bh=2Jk+9T+9RdF8ZUFR4cxAiqDTnqPluDRHqw6ipvMwtMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sjzbD98D/4k0hzGMBqPwh41iqbWRmfMWPC82wVchPE44Orm5w8vIxdVfAhtAZdJ0qOmLwV3jrN0tpfJiRo63pjvtBbuBXA/0tlbYigDu3W41iWuBtNd8i6asWPmLHc0yppfKLLnIH1Lc/D1xPQOlVG0x/gzSskt/VxU8X1PotJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbKQ61zT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbKQ61zT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC7C1F00893;
	Sun,  7 Jun 2026 10:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829825;
	bh=W3CtLPKBeDu3YqbBOhSNQP9Ljg9fwHWbSGNZ28T0PTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wbKQ61zT4KnqrxJub8amu5AA/9SZgd0PFA5XnCYvEqMLsHKEvmfxMHwZeTful54H2
	 v/g67WsHFtjPMXzQyWJni74yOqXjMpW0/9eIEX0Crs5bLI3ArPkQtGLfNp52sO/hBQ
	 +0TTF6YkzJXpqTT40XvV14FjI+vSPRnpIXC3OEM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jacques Nilo <jnilo@free.fr>
Subject: [PATCH 7.0 316/332] serial: 8250: dispatch SysRq character in serial8250_handle_irq()
Date: Sun,  7 Jun 2026 12:01:25 +0200
Message-ID: <20260607095739.726621997@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacques Nilo <jnilo@free.fr>

commit 71f42b2149a1307a97165b409493665579462ea0 upstream.

serial8250_handle_irq() captures a SysRq character into port->sysrq_ch
inside serial8250_handle_irq_locked() via uart_prepare_sysrq_char()
(reached from serial8250_read_char()). Dispatch of that captured
character to handle_sysrq() is expected to happen at port-unlock time,
through uart_unlock_and_check_sysrq[_irqrestore]().

After commit 8324a54f604d ("serial: 8250: Add
serial8250_handle_irq_locked()") the function was reduced to a wrapper
that takes the port lock via guard(uart_port_lock_irqsave) whose
destructor is plain uart_port_unlock_irqrestore(). The sysrq-aware
unlock helper is no longer called, so port->sysrq_ch is captured but
never dispatched: BREAK + SysRq key is consumed silently.

This was the very condition Johan Hovold's 853a9ae29e978 ("serial:
8250: fix handle_irq locking", 2021) introduced
uart_unlock_and_check_sysrq_irqrestore() to address.

Switch to the new guard(uart_port_lock_check_sysrq_irqsave), whose
destructor is the sysrq-aware unlock helper, restoring the pre-split
behaviour. Update the Context: comment on serial8250_handle_irq_locked()
so future HW-specific 8250 wrappers know to use the same guard or the
explicit sysrq-aware unlock.

Verified on RTL8196E with CONFIG_MAGIC_SYSRQ_SERIAL=y: BREAK + 'h' on
the console UART produces the SysRq help dump in dmesg and the brk
counter in /proc/tty/driver/serial increments correctly.

Fixes: 8324a54f604d ("serial: 8250: Add serial8250_handle_irq_locked()")
Cc: stable@vger.kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Jacques Nilo <jnilo@free.fr>
Link: https://patch.msgid.link/52692ae6c3501f7940347cef364ad7fcacaab7e5.1778675349.git.jnilo@free.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1784,7 +1784,10 @@ static bool handle_rx_dma(struct uart_82
 }
 
 /*
- * Context: port's lock must be held by the caller.
+ * Context: port's lock must be held by the caller. The caller must
+ * release it via guard(uart_port_lock_check_sysrq_irqsave) or
+ * uart_unlock_and_check_sysrq_irqrestore(), which captures SysRq
+ * character on unlock.
  */
 void serial8250_handle_irq_locked(struct uart_port *port, unsigned int iir)
 {
@@ -1837,7 +1840,7 @@ int serial8250_handle_irq(struct uart_po
 	if (iir & UART_IIR_NO_INT)
 		return 0;
 
-	guard(uart_port_lock_irqsave)(port);
+	guard(uart_port_lock_check_sysrq_irqsave)(port);
 	serial8250_handle_irq_locked(port, iir);
 
 	return 1;


