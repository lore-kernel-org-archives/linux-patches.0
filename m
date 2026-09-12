Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C54346AE3;
	Sat, 12 Sep 2026 07:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198273; cv=none; b=ILVEMo/9EZCZhbVnDzRb1NJ+InM1SBmOhq3gMzdZEZqnXv1MzlpRDBzKaIfrjFzR+DM9cW91w9wlTJVXAVwHSnu/gBdfA045aj6pTbJ/LgOd9p58Bk5+1XZ+EOIWTJeQHYxEnxoQTScfzrSjbvDevE49E1dvy6sNjn2igoQa1Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198273; c=relaxed/simple;
	bh=OAPSseQVgF3jW1LwQHf0icqCwKWecX3+78x/g05EDKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRYjaP6Pj3jnCbYCNeXTDyY9ZjHtFGOlr2S+wDwMvMsk7KBiFcY4dcS16MUiggQtlOBwUnUMxt2+PuYc2sRKRhqdMVshZfWSMEaf+DhjgFr5pfUmcRJNquXYufwmwc5tiLeYf9IUnGUUI15Bgg2/A9ysBRfUzNKVDwKd/wsy3kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNvO3Kdt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNvO3Kdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79941F000FF;
	Sat, 12 Sep 2026 07:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198272;
	bh=EuWRoiFOV4nn/rip39WhPXKbNdnAhYSDkxDhIMjrvDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNvO3KdtPr+v5QqBlp7D2PQNGTvF1o26czd/QRRceIUp86H/3B+aUEI3QKdrN2ozr
	 8Nid4XUALw0NYRvm8rZG5zFvWS0OQi+7u+aw5qijZ/1+PvrWhrFTpYpE/i81vUENuL
	 rYTqYs0wIMjMaqaaZD2Pa30SqnarewkNzJZVGWr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0319/1815] serial: qcom-geni: do not advance stale DMA completions
Date: Sat, 12 Sep 2026 08:34:29 +0200
Message-ID: <20260912065656.426751345@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 7ea38c49e7178960926657863299face6dc0e1b0 ]

The qcom GENI serial DMA TX completion path advances the transmit fifo by
the number of bytes recorded in port->tx_remaining.

If uart_flush_buffer() runs after the hardware has completed a DMA
transfer but before the DMA completion interrupt has been handled, the
serial core resets the transmit fifo while port->tx_remaining still
describes the old DMA transfer.

A previous fix avoided advancing an empty fifo by checking that the fifo
length is at least tx_remaining. That still does not distinguish the old
DMA payload from new bytes written after the flush. If userspace writes
new data before the stale DMA completion interrupt is handled, the fifo
can again contain at least tx_remaining bytes and the stale completion
can advance and discard those new bytes.

Mark an in-flight DMA transfer stale when the transmit fifo is flushed.
The later completion still unprepares the original DMA mapping using the
saved length, but it no longer advances the transmit fifo.

Fixes: 2aaa43c70778 ("tty: serial: qcom-geni-serial: add support for serial engine DMA")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260708131726.768692-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 1e39122ec09f4..1fc869ad84bd8 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -143,6 +143,7 @@ struct qcom_geni_serial_port {
 
 	unsigned int tx_remaining;
 	unsigned int tx_queued;
+	bool tx_dma_stale;
 	int wakeup_irq;
 	bool rx_tx_swap;
 	bool cts_rts_swap;
@@ -697,6 +698,7 @@ static void qcom_geni_serial_start_tx_dma(struct uart_port *uport)
 	}
 
 	port->tx_remaining = xmit_size;
+	port->tx_dma_stale = false;
 }
 
 static void qcom_geni_serial_start_tx_fifo(struct uart_port *uport)
@@ -1029,6 +1031,7 @@ static void qcom_geni_serial_handle_tx_dma(struct uart_port *uport)
 	struct qcom_geni_serial_port *port = to_dev_port(uport);
 	struct tty_port *tport = &uport->state->port;
 	unsigned int fifo_len = kfifo_len(&tport->xmit_fifo);
+	bool tx_dma_stale = port->tx_dma_stale;
 
 	/*
 	 * Only advance the kfifo if it still contains the bytes that were
@@ -1039,12 +1042,13 @@ static void qcom_geni_serial_handle_tx_dma(struct uart_port *uport)
 	 * kfifo->in, making kfifo_len() wrap to UART_XMIT_SIZE - tx_remaining
 	 * and triggering a spurious large DMA transfer of stale data.
 	 */
-	if (fifo_len >= port->tx_remaining)
+	if (!tx_dma_stale && fifo_len >= port->tx_remaining)
 		uart_xmit_advance(uport, port->tx_remaining);
 
 	geni_se_tx_dma_unprep(&port->se, port->tx_dma_addr, port->tx_remaining);
 	port->tx_dma_addr = 0;
 	port->tx_remaining = 0;
+	port->tx_dma_stale = false;
 
 	if (!kfifo_is_empty(&tport->xmit_fifo))
 		qcom_geni_serial_start_tx_dma(uport);
@@ -1182,6 +1186,10 @@ static void qcom_geni_serial_shutdown(struct uart_port *uport)
 
 static void qcom_geni_serial_flush_buffer_fifo(struct uart_port *uport)
 {
+	struct qcom_geni_serial_port *port = to_dev_port(uport);
+
+	if (port->tx_dma_addr)
+		port->tx_dma_stale = true;
 	qcom_geni_serial_cancel_tx_cmd(uport);
 }
 
-- 
2.53.0



