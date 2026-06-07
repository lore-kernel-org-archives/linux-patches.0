Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C093242DF;
	Sun,  7 Jun 2026 10:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829795; cv=none; b=OJVo9McOU6JVTYxziXr1NzVhiDv54qAK398wPk3S0xcois34lyTZxmegq7KOPCOBB5TihX33vyTv3bo2HFolNARzc2wT46SKQy5DBGbGREhDoWyKRAFY9mSBkn4WvYDi/sInnws/Hy9mPzJ85kD3TDsg4hR7yjbuHhHhX3WlRo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829795; c=relaxed/simple;
	bh=ZrXTcrD6ZoY2Frgzzr8BzmQB4kPPVsWM4/zybF3ziYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcHX3yH1oezzaghqaEx1WfZBQQfe+WRQ3VzCShb2sWcSRIYxWdIcZ0rwLYqC5U+NMdAF5XZxFh4QtC/CJI3LoYXyIfwDClicO3O1i0aZnJXU05Gl73wTjva8pDGRkG5BzUb7yg3XCoDELbhyLqxeK9xij3PJdatS2OzYgRYzYkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYvM5IYE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYvM5IYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA7F1F00893;
	Sun,  7 Jun 2026 10:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829793;
	bh=pLoPHCVaz+sBquB/o6Us+FFMfJYX5QeGjY3P5QkKACk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vYvM5IYEVV+11mLv9coHsHytJXVb+ApkUCpV0SGggxzUpI5cy5u8BQEhgi/ANNaJ6
	 UbYo+zw0aj5GMGgv99Fd2ZJ9P2UnunNjDWGazGQ27gDb8AUX2Ay4g0sXMQpMw2MuJS
	 x5li1Ze9eaunuzeNVitdRj/K5GYeBBxvGCmP+BoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.0 298/332] serial: qcom_geni: fix kfifo underflow when flush precedes DMA completion IRQ
Date: Sun,  7 Jun 2026 12:01:07 +0200
Message-ID: <20260607095739.006909366@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

commit 452d6fa37ae9b021f4f6d397dbae077f7296f6f4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1030,8 +1030,20 @@ static void qcom_geni_serial_handle_tx_d
 {
 	struct qcom_geni_serial_port *port = to_dev_port(uport);
 	struct tty_port *tport = &uport->state->port;
+	unsigned int fifo_len = kfifo_len(&tport->xmit_fifo);
+
+	/*
+	 * Only advance the kfifo if it still contains the bytes that were
+	 * transferred. uart_flush_buffer() may have run before this IRQ
+	 * fired: it calls kfifo_reset() under the port lock, making
+	 * fifo_len = 0 while tx_remaining remains non-zero. Calling
+	 * uart_xmit_advance() in that case would underflow kfifo->out past
+	 * kfifo->in, making kfifo_len() wrap to UART_XMIT_SIZE - tx_remaining
+	 * and triggering a spurious large DMA transfer of stale data.
+	 */
+	if (fifo_len >= port->tx_remaining)
+		uart_xmit_advance(uport, port->tx_remaining);
 
-	uart_xmit_advance(uport, port->tx_remaining);
 	geni_se_tx_dma_unprep(&port->se, port->tx_dma_addr, port->tx_remaining);
 	port->tx_dma_addr = 0;
 	port->tx_remaining = 0;


