Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C2522D7A6;
	Mon, 10 Mar 2025 17:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629551; cv=none; b=WyTJIa4BF6Xl7ipyFtIG0TUfOYaJsZU7vi8rju25ylpns22wdPPJUgdxYlNZC11pXHVSmoULwapwN6GglfES/0ftG0LF9TYcxyrbj+Vffdl3Y8fBiR5PhVKWIw/a3znZULwfHbK12C6Y+pRS4tExq+iG8EJO7tzZ6QEfc97c0O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629551; c=relaxed/simple;
	bh=JsyC1fXxLqPqqbLZMoa0jYuJ9CzX1D7PWlPmb65TCcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhBAxXUpc5GnaHj7jx3fgG/p9VVUlYAqj5ivA2YPzEvBjEeMv0hwOn2CzlnUtG+Z3957RCLq2IgP3RLvODLLrmzwAjbEYD78pVeXpziT0UCzNsGctuz/hkZG3z/bYi5P73zUk025P3UzdtRvcdbr00iPKNi/GBnpNNtaYvxq1Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYn0X0Mt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYn0X0Mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529A4C4CEE5;
	Mon, 10 Mar 2025 17:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629550;
	bh=JsyC1fXxLqPqqbLZMoa0jYuJ9CzX1D7PWlPmb65TCcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYn0X0Mtzt8ohiMuWraFf0ppLRUs6RMF4BDkHfPy0cfC1gBwWRmZkXI54drfaeR1W
	 bCR6wxlTfKnCcncG/eIfiYWddSwyI5hF75JIS3Jrmkeco7iy6G6ng/Fxutw6wHsex1
	 mAmHCmSpVf8ykf3qVNIldsZcUOyWdHA0o9CCPNrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	John Ogness <john.ogness@linutronix.de>
Subject: [PATCH 5.15 334/620] tty: xilinx_uartps: split sysrq handling
Date: Mon, 10 Mar 2025 18:03:00 +0100
Message-ID: <20250310170558.795457624@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@linux.dev>

commit b06f388994500297bb91be60ffaf6825ecfd2afe upstream.

lockdep detects the following circular locking dependency:

CPU 0                      CPU 1
========================== ============================
cdns_uart_isr()            printk()
  uart_port_lock(port)       console_lock()
			     cdns_uart_console_write()
                               if (!port->sysrq)
                                 uart_port_lock(port)
  uart_handle_break()
    port->sysrq = ...
  uart_handle_sysrq_char()
    printk()
      console_lock()

The fixed commit attempts to avoid this situation by only taking the
port lock in cdns_uart_console_write if port->sysrq unset. However, if
(as shown above) cdns_uart_console_write runs before port->sysrq is set,
then it will try to take the port lock anyway. This may result in a
deadlock.

Fix this by splitting sysrq handling into two parts. We use the prepare
helper under the port lock and defer handling until we release the lock.

Fixes: 74ea66d4ca06 ("tty: xuartps: Improve sysrq handling")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Cc: stable@vger.kernel.org # c980248179d: serial: xilinx_uartps: Use port lock wrappers
Acked-by: John Ogness <john.ogness@linutronix.de>
Link: https://lore.kernel.org/r/20250110213822.2107462-1-sean.anderson@linux.dev
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/xilinx_uartps.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -268,7 +268,7 @@ static void cdns_uart_handle_rx(void *de
 				continue;
 		}
 
-		if (uart_handle_sysrq_char(port, data))
+		if (uart_prepare_sysrq_char(port, data))
 			continue;
 
 		if (is_rxbs_support) {
@@ -385,7 +385,7 @@ static irqreturn_t cdns_uart_isr(int irq
 	    !(readl(port->membase + CDNS_UART_CR) & CDNS_UART_CR_RX_DIS))
 		cdns_uart_handle_rx(dev_id, isrstatus);
 
-	spin_unlock(&port->lock);
+	uart_unlock_and_check_sysrq(port);
 	return IRQ_HANDLED;
 }
 
@@ -1217,10 +1217,8 @@ static void cdns_uart_console_write(stru
 	unsigned int imr, ctrl;
 	int locked = 1;
 
-	if (port->sysrq)
-		locked = 0;
-	else if (oops_in_progress)
-		locked = spin_trylock_irqsave(&port->lock, flags);
+	if (oops_in_progress)
+		locked = uart_port_trylock_irqsave(port, &flags);
 	else
 		spin_lock_irqsave(&port->lock, flags);
 


