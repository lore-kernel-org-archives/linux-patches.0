Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B40B347C6;
	Mon, 29 Dec 2025 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025693; cv=none; b=dOnK2vpLX8UiQlZQrBqFcj9tuoCH+V6hNiX+XrhwRkcmfb4eypCEv6nzO4ZadzAhVDJVqk0/vkF1iohe7w9BoYyxbGveZGccbbNCFOctMIsPSJLO0rQZ1aJwKBzETEwtUaeWZcF9chossDWXy3kWSw6tNSMsQjn1PRVr4dspJVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025693; c=relaxed/simple;
	bh=7TutfBuyZBbzkEFVc4uwKBt1F1x8pnZnpI108fEqhoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Me0tEmPmpYgBZ8+dykbF1fJVPbOT0CKraINYav9Y0acu63uqJGHvQYBbeKtd4CVBXqtVHs+jjaz+xk/HuAJpl9ikP12ThZgqrhyBqImEBymE1TPzWiM0bLubtUVz8DyXDy82ZuMOEe20b8/IpCuGBhZY3/4w6D/EUOv1Wv1/ucI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eteaHKYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eteaHKYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A32C4CEF7;
	Mon, 29 Dec 2025 16:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025692;
	bh=7TutfBuyZBbzkEFVc4uwKBt1F1x8pnZnpI108fEqhoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eteaHKYdWABIeWSHrGAiVHAlMYAayXU1k0vMw7aXqWeX1amouZGVS1rqzMAFiqvs5
	 EgmwJtken1Cwtk/tLBlgHPJC8boXQUN/Juh56KHlZrOWOUOT+vPcYEdHXBpNPfrmhy
	 uyFRpg49MnT7eavYHwG8NR08GSbpXIrWDKMmwHpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jakub Turek <jakub.turek@elsta.tech>
Subject: [PATCH 6.18 302/430] serial: xilinx_uartps: fix rs485 delay_rts_after_send
Date: Mon, 29 Dec 2025 17:11:44 +0100
Message-ID: <20251229160735.449722786@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: j.turek <jakub.turek@elsta.tech>

commit 267ee93c417e685d9f8e079e41c70ba6ee4df5a5 upstream.

RTS line control with delay should be triggered when there is no more
bytes in kfifo and hardware buffer is empty. Without this patch RTS
control is scheduled right after feeding hardware buffer and this is too
early.

RTS line may change state before hardware buffer is empty.

With this patch delayed RTS state change is triggered when function
cdns_uart_handle_tx is called from cdns_uart_isr on
CDNS_UART_IXR_TXEMPTY exactly when hardware completed transmission

Fixes: fccc9d9233f9 ("tty: serial: uartps: Add rs485 support to uartps driver")
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20251221103221.1971125-1-jakub.turek@elsta.tech
Signed-off-by: Jakub Turek  <jakub.turek@elsta.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/xilinx_uartps.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -430,10 +430,17 @@ static void cdns_uart_handle_tx(void *de
 	struct tty_port *tport = &port->state->port;
 	unsigned int numbytes;
 	unsigned char ch;
+	ktime_t rts_delay;
 
 	if (kfifo_is_empty(&tport->xmit_fifo) || uart_tx_stopped(port)) {
 		/* Disable the TX Empty interrupt */
 		writel(CDNS_UART_IXR_TXEMPTY, port->membase + CDNS_UART_IDR);
+		/* Set RTS line after delay */
+		if (cdns_uart->port->rs485.flags & SER_RS485_ENABLED) {
+			cdns_uart->tx_timer.function = &cdns_rs485_rx_callback;
+			rts_delay = ns_to_ktime(cdns_calc_after_tx_delay(cdns_uart));
+			hrtimer_start(&cdns_uart->tx_timer, rts_delay, HRTIMER_MODE_REL);
+		}
 		return;
 	}
 
@@ -450,13 +457,6 @@ static void cdns_uart_handle_tx(void *de
 
 	/* Enable the TX Empty interrupt */
 	writel(CDNS_UART_IXR_TXEMPTY, cdns_uart->port->membase + CDNS_UART_IER);
-
-	if (cdns_uart->port->rs485.flags & SER_RS485_ENABLED &&
-	    (kfifo_is_empty(&tport->xmit_fifo) || uart_tx_stopped(port))) {
-		hrtimer_update_function(&cdns_uart->tx_timer, cdns_rs485_rx_callback);
-		hrtimer_start(&cdns_uart->tx_timer,
-			      ns_to_ktime(cdns_calc_after_tx_delay(cdns_uart)), HRTIMER_MODE_REL);
-	}
 }
 
 /**


