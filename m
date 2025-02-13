Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E092A14658D;
	Thu, 13 Feb 2025 15:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460999; cv=none; b=YMNlAe0VRCxcPtfn6W8ll6kgSMMbU+RRxLWsZMjQlVP55FSF9iBB8zowYrn11lCOQheh+72w2Prph285Q4Tth2R26NpIE0iZoFLKVpzOYjq0VmbEV1w/gIJpzX2ULJ4VMaSD5G0Rds1sgzBpY2buFtRGwRVUsOoWCcD3NngtNzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460999; c=relaxed/simple;
	bh=wEIuAMUf3O9Q5RD6PiL2tlpJFPSotbXCXCbCxbA7UQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=an8VgvnSW++TBCyuZeKfytlMb8AqULYrrNfx+AZjZujBP33+6LJYp4Dg+keKJl62JZHkPBUPBWrYlNBi8QgGM8QXQ/ZbBKwB/B1O89ZaIwTCG+XmZdtJk6qRoccp5iKOonH5mhmBHgv/txTrX7COQB9YBHnRjXv7VAN/P3Es98E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8xiV6mk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8xiV6mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572ACC4CED1;
	Thu, 13 Feb 2025 15:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460998;
	bh=wEIuAMUf3O9Q5RD6PiL2tlpJFPSotbXCXCbCxbA7UQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8xiV6mkXUwSwO+Uliy1w4YF9WBuJeMY792ApAwGMQttzaWvRCv1rwDBlkdE4FALL
	 gMSdRmYJPR1Ym3lPygu0nFxxxJbDkmN0Acd+K5f+oVdtGiguhgtQFNIo0o/nZ3UchG
	 eGmYuYQxf2ODRgNP6bPuTcDfMx1FrYxKBzapvajg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	John Ogness <john.ogness@linutronix.de>
Subject: [PATCH 6.6 271/273] tty: xilinx_uartps: split sysrq handling
Date: Thu, 13 Feb 2025 15:30:43 +0100
Message-ID: <20250213142418.133119000@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -369,7 +369,7 @@ static irqreturn_t cdns_uart_isr(int irq
 	    !(readl(port->membase + CDNS_UART_CR) & CDNS_UART_CR_RX_DIS))
 		cdns_uart_handle_rx(dev_id, isrstatus);
 
-	spin_unlock(&port->lock);
+	uart_unlock_and_check_sysrq(port);
 	return IRQ_HANDLED;
 }
 
@@ -1229,10 +1229,8 @@ static void cdns_uart_console_write(stru
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
 


