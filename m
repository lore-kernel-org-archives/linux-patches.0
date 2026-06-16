Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3DC47A0D4;
	Tue, 16 Jun 2026 17:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630174; cv=none; b=rrKiVFFmRl3wDjfOQ00m5F5Ob+YKEKFt6ZwiT0pqdHaIac0cp32CTxWTsY9bj1i11UIkEe1ryA2kncHIHbSz3ggIqxoim+0JZ53p+GiM3L4wD8ldoCt06F8Q+b20vL0za2Ov4HGtFznJ19c7hg3d2y9kXyuF/AO4bjsFJ6Eh46c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630174; c=relaxed/simple;
	bh=FpM/Xe6SZgHYM1mPbTiPuwwxASoRF1rZUGtl1riNJ0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAhawkTd4OfXe7TD1SzyFb2mfqtMTGtISVi2/rk4mz3d8NIUCf5nvMG1wX9T2ca3x9xOn3w57bAEysEf4BeybQVOkEIJUz0zgB3Z7CCwQlRYeXhu/EH9s1+Za0SFauISVM30u//KAvpUb2wJvB3ftDsrBJz5BYSWq1TAZ5JwOYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwTHyMUt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwTHyMUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC4C1F000E9;
	Tue, 16 Jun 2026 17:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630172;
	bh=XpxqKcom45IgpX80NN01Hl9niqt1xNZ44vaW/sz9ArE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QwTHyMUt3mQqS4z8PhacFf0oCdfsuoaCSmmO8b1E6q7vDJ8DsLAGeREybgMFxfYdN
	 7aqKRtpuuvZ6oCDn8+/MbTauHnk2JrZy3l4KUPpeeGkWlvYwxGwSzyvGLfY2rei4e8
	 jFWgZ5JRaJmMCMggvIwJygLaWIQVMRfqRnqdU/mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 425/452] serial: qcom_geni: fix kfifo underflow when flush precedes DMA completion IRQ
Date: Tue, 16 Jun 2026 20:30:52 +0530
Message-ID: <20260616145139.032352558@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

[ Upstream commit 452d6fa37ae9b021f4f6d397dbae077f7296f6f4 ]

When uart_flush_buffer() runs before the DMA completion IRQ is delivered,
the following race can occur (all steps serialized by uart_port_lock):

  1. DMA starts: tx_remaining = N, kfifo contains N bytes
  2. DMA completes in hardware; IRQ is pending but not yet delivered
  3. uart_flush_buffer() acquires the port lock and calls kfifo_reset(),
     making kfifo_len() = 0 while tx_remaining remains N
  4. uart_flush_buffer() releases the port lock
  5. DMA IRQ fires; handle_tx_dma() acquires the port lock and calls
     uart_xmit_advance(uport, tx_remaining) on an empty kfifo

uart_xmit_advance() increments kfifo->out by tx_remaining. Since
kfifo_reset() already set both in and out to 0, out wraps past in,
causing kfifo_len() to return UART_XMIT_SIZE - tx_remaining. The next
start_tx_dma() call then submits a DMA transfer of stale buffer data.

Fix this by snapshotting kfifo_len() at the start of handle_tx_dma()
and skipping uart_xmit_advance() when fifo_len < tx_remaining, which
indicates the kfifo was reset by a preceding flush.

Fixes: 2aaa43c70778 ("tty: serial: qcom-geni-serial: add support for serial engine DMA")
Cc: stable <stable@kernel.org>
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260506-serial-dma-stale-tx-buf-v1-1-e3ccb360d719@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -962,8 +962,21 @@ static void qcom_geni_serial_handle_tx_d
 {
 	struct qcom_geni_serial_port *port = to_dev_port(uport);
 	struct circ_buf *xmit = &uport->state->xmit;
+	unsigned int chars_pending = uart_circ_chars_pending(xmit);
+
+	/*
+	 * Only advance the buffer if it still contains the bytes that were
+	 * transferred. uart_flush_buffer() may have run before this IRQ
+	 * fired: it clears the circular buffer under the port lock, making
+	 * chars_pending = 0 while tx_remaining remains non-zero. Calling
+	 * uart_xmit_advance() in that case would advance xmit->tail past
+	 * xmit->head, making uart_circ_chars_pending() wrap to
+	 * UART_XMIT_SIZE - tx_remaining and triggering a spurious large DMA
+	 * transfer of stale data.
+	 */
+	if (chars_pending >= port->tx_remaining)
+		uart_xmit_advance(uport, port->tx_remaining);
 
-	uart_xmit_advance(uport, port->tx_remaining);
 	geni_se_tx_dma_unprep(&port->se, port->tx_dma_addr, port->tx_remaining);
 	port->tx_dma_addr = 0;
 	port->tx_remaining = 0;


