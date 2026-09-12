Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0E136E484;
	Sat, 12 Sep 2026 09:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206970; cv=none; b=LSodQ2t+f0TYdw5uK4q5h4cytgFI8dJFkr0PvTsCTfQLddmKFtr7KxjpkNX7HLEQyqSwyjIPaokDIPy/MYKTGM8qab4b6gKpWfEP8/K0rpVg/LpwVVOsJgaWzuh6i1aRlRLp6cNeoSetQUVWrwjOYLTZc+3c4zu4hi1XGPbs1qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206970; c=relaxed/simple;
	bh=TYXhrqWKIRGp8pDLh37zdWtyhxVbDGM79V/gldFXVBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUJm4fSDo+CT6I0tYJIKSuJ4fh9SAaN4ic6c/DKSRQiDvRpLwveBTP2xzy/Kqt5wQhGzKGxMToHEyT0Ya36Ul4C1t8utLYNF/DCQ/c6qObBLDt/vfl/u1jClyH10N738849LJcnIdOBGdRLvLL4aL1OqfUUXZBn+pvRu9kGiZqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0Bp+jIj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0Bp+jIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AED1F000FF;
	Sat, 12 Sep 2026 09:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206969;
	bh=56IYWSuihE/n0UBllEXyZjNwmRUia0v46OUkT4ME+Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W0Bp+jIjZeaWByxeyOUCr9ENkQfeI+xA5wNZJYFj2xc5P/Ulnjv1OxGwdkph6zjMc
	 2QRZSlDuF5/Kr4EvMLE1JzKqA4zC248n/7RWMCf+v0YPXm1QBDa9GmObQVUwMjh2Ni
	 BOpgATu+YjdE2yfj15CfC7d3+EkOYmShASFgp6bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0314/1518] serial: qcom-geni: do not advance stale DMA completions
Date: Sat, 12 Sep 2026 08:41:23 +0200
Message-ID: <20260912065630.583391171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 1d561a00cbbd9..953b737357103 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -136,6 +136,7 @@ struct qcom_geni_serial_port {
 
 	unsigned int tx_remaining;
 	unsigned int tx_queued;
+	bool tx_dma_stale;
 	int wakeup_irq;
 	bool rx_tx_swap;
 	bool cts_rts_swap;
@@ -688,6 +689,7 @@ static void qcom_geni_serial_start_tx_dma(struct uart_port *uport)
 	}
 
 	port->tx_remaining = xmit_size;
+	port->tx_dma_stale = false;
 }
 
 static void qcom_geni_serial_start_tx_fifo(struct uart_port *uport)
@@ -1020,6 +1022,7 @@ static void qcom_geni_serial_handle_tx_dma(struct uart_port *uport)
 	struct qcom_geni_serial_port *port = to_dev_port(uport);
 	struct tty_port *tport = &uport->state->port;
 	unsigned int fifo_len = kfifo_len(&tport->xmit_fifo);
+	bool tx_dma_stale = port->tx_dma_stale;
 
 	/*
 	 * Only advance the kfifo if it still contains the bytes that were
@@ -1030,12 +1033,13 @@ static void qcom_geni_serial_handle_tx_dma(struct uart_port *uport)
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
@@ -1173,6 +1177,10 @@ static void qcom_geni_serial_shutdown(struct uart_port *uport)
 
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



