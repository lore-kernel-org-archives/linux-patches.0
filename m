Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA9C1D516A;
	Thu, 13 Feb 2025 15:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458985; cv=none; b=iHo6atgvQsZQzEJ+hrOZsf53CEGmWeREJZRDkczPpXd9sKQaSWVTttk4yg4MlfB6Wmmtbj+UKNqAtxUaBayjOhMrddTK9cYxY8FOYYfsC5tQmSSfT6vuJ1xL5ON251vrK8jGEMldQJvy2HrJ81Q/D6OvP2W452+ryCFH9P03QWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458985; c=relaxed/simple;
	bh=pwl7/PnoJxAVH0AfQKgegkjUpG+VylTfbpm4Hd64Fy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfxxnnczlpitbUlO5POMEQ+iMQx+7zBtsd/95+GgawvVIeM5IXozD38hPjiHhmnbeYjwR0H4aLYAuvYE4s1hjrrNy/R9hSTcoEkCDTWZYt79y2CaiqN0de8VNxCin/lM/hlcZYYXsi2EUgB/Yvmxvf26J+1lSg/DCsDqZsl14xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HcBj2v+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HcBj2v+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918F8C4CED1;
	Thu, 13 Feb 2025 15:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458985;
	bh=pwl7/PnoJxAVH0AfQKgegkjUpG+VylTfbpm4Hd64Fy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HcBj2v+oY66qK0NXGEfMZTw0dsamnlr7Stm+1zIezBKmDTPCx5yJ6JVjIP2Hljurd
	 j0CsK4qb3z9BgCnHCVPIKNtcNtKyu6QFy4lh9cQynludIVrPnpkB/UfM7oK5QbHe+d
	 i2/tQb2DVsLEc9sqmpnd9qdCVdC2OkW4LeiaLLTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	John Ogness <john.ogness@linutronix.de>
Subject: [PATCH 6.13 102/443] tty: xilinx_uartps: split sysrq handling
Date: Thu, 13 Feb 2025 15:24:27 +0100
Message-ID: <20250213142444.546865250@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/xilinx_uartps.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -287,7 +287,7 @@ static void cdns_uart_handle_rx(void *de
 				continue;
 		}
 
-		if (uart_handle_sysrq_char(port, data))
+		if (uart_prepare_sysrq_char(port, data))
 			continue;
 
 		if (is_rxbs_support) {
@@ -495,7 +495,7 @@ static irqreturn_t cdns_uart_isr(int irq
 	    !(readl(port->membase + CDNS_UART_CR) & CDNS_UART_CR_RX_DIS))
 		cdns_uart_handle_rx(dev_id, isrstatus);
 
-	uart_port_unlock(port);
+	uart_unlock_and_check_sysrq(port);
 	return IRQ_HANDLED;
 }
 
@@ -1380,9 +1380,7 @@ static void cdns_uart_console_write(stru
 	unsigned int imr, ctrl;
 	int locked = 1;
 
-	if (port->sysrq)
-		locked = 0;
-	else if (oops_in_progress)
+	if (oops_in_progress)
 		locked = uart_port_trylock_irqsave(port, &flags);
 	else
 		uart_port_lock_irqsave(port, &flags);


