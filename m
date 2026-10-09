Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4CA4E0B91;
	Fri,  9 Oct 2026 14:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556895; cv=none; b=iKBaw7ZzIbzv0B69rVAjloTAB/DcHh3e3GVXInb6IYVw8e3U8TIk/r0rVdIZeYAAtpNYaUKATLtnTQ9O4cmQA2hnQblrLnwMCAnvuV7xnwrQvq+6qOr89XCVxqX1rcADk1NqQcAvYXPpAtQKLpssQmh8bmRC1zBbyBWx1dTL+h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556895; c=relaxed/simple;
	bh=kf5zFBhj/qD6NISkoMQMg5ArQ+MJBjObIHivi+6L8pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeGsPis4K9fadS53HgZUX5tG/CaPIS7Zbwm1L1/Aq4gJi1T5CVoFL2Lv6KOQWgBL8515e2uRYxG+MDRwYu47KQ31LZNbJKKnL+uFGKTHMP3DDvodsCAjZMqn28cKBKz/SjJChn6JnBIV8tRY6XXyvJoalIhG/Ue65885Al+ZwEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izsM8V/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izsM8V/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B23A1F000FF;
	Fri,  9 Oct 2026 14:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556893;
	bh=+cH9OPeoRbw/aOpre2tEzukTIwfAeoqWiebpk6vxiIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izsM8V/GmA3xhgmUNa5OuFX94axQ8nU3mbjPdMtcPELYNLY3oPl+woD6VYmEMdTdD
	 MbVV0d11mDjRhp2Ux+4VL8NgUpFXapA2/j8KGDMFfoc1B/jD0Lf5jPw71jeu25NUmO
	 0aH0caKazXbGxnqQBCP7kTBDAfw/X5Urc6GglUFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Tobias Gannert <tobias.gannert@ziehl-abegg.de>,
	Joachim Knorr <joachim.knorr@ziehl-abegg.de>,
	Paul Mbewe <paultyson.mbewe@ziehl-abegg.de>
Subject: [PATCH 7.2 259/428] serial: sc16is7xx: fix TX gap caused by kfifo circular buffer wrap-around
Date: Fri,  9 Oct 2026 16:09:56 +0200
Message-ID: <20261009140951.791879136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Paul Mbewe <paultyson.mbewe@ziehl-abegg.de>

commit abfafa6fc3c17b7dffa5dce3acc8dba70ed656b9 upstream.

kfifo_out_linear_ptr() returns only one contiguous linear segment of the
xmit kfifo. When transmit data wraps around the end of the kfifo, only
the first segment up to the buffer end is sent. The remaining data at
the start of the kfifo is not sent until the next TX interrupt fires,
resulting in a visible mid-frame TX gap on the wire.

The resulting gap is unintended: data remains queued in the xmit kfifo,
but the hardware TX FIFO drains empty before the remaining segment is
sent. Such gaps can break timing-sensitive serial protocols such as
Modbus RTU.

Modbus RTU requires a message to be transmitted as a continuous stream.
For baud rates above 19200, the Modbus Serial Line guide recommends a
fixed 750 us inter-character timeout. On the tested 115200-baud system,
oscilloscope measurements showed mid-frame gaps exceeding that value.
Receivers using the recommended timeout may therefore discard the
incomplete message.

The incomplete transfer also causes unnecessary TX interrupts: instead
of using all available hardware TX FIFO space in one go, the driver
requires an extra interrupt to send the remaining segment after the
wrap.

After the tty xmit buffer was converted to a kfifo, the driver used
uart_fifo_out() to copy data into a linear staging buffer, allowing a
transfer to span the kfifo wrap-around boundary. Commit 133f4c00b8b2
("serial: sc16is7xx: fix TX fifo corruption") replaced uart_fifo_out()
with a single kfifo_out_linear_ptr() call to remove the shared TX/RX
buffer. Since kfifo_out_linear_ptr() exposes only one contiguous
segment, that change lost the wrap-around handling.

Fix this by calling kfifo_out_linear_ptr() in a loop, advancing through
all contiguous segments until the available hardware TX FIFO space is
exhausted or the xmit kfifo is empty.

This fixes the kfifo wrap-around gap independently of the stale-TXLVL
refill issue.

Tested on SC16IS752 over SPI driving RS-485 at 115200 baud 8N1 on an
i.MX6ULL-based board. Oscilloscope measurements confirmed mid-frame
breaks at the kfifo wrap-around boundary before the fix; no such breaks
were observed afterward.

Fixes: 133f4c00b8b2 ("serial: sc16is7xx: fix TX fifo corruption")
Cc: stable@kernel.org
Reported-by: Tobias Gannert <tobias.gannert@ziehl-abegg.de>
Reviewed-by: Joachim Knorr <joachim.knorr@ziehl-abegg.de>
Link: https://lore.kernel.org/linux-serial/20260623112225.82386-2-paultyson.mbewe@ziehl-abegg.de/
Signed-off-by: Paul Mbewe <paultyson.mbewe@ziehl-abegg.de>
Link: https://patch.msgid.link/20260930143207.542930-1-paultyson.mbewe@ziehl-abegg.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -652,7 +652,6 @@ static void sc16is7xx_handle_tx(struct u
 	struct tty_port *tport = &port->state->port;
 	unsigned long flags;
 	unsigned int txlen;
-	unsigned char *tail;
 
 	if (unlikely(port->x_char)) {
 		sc16is7xx_port_write(port, SC16IS7XX_THR_REG, port->x_char);
@@ -677,9 +676,19 @@ static void sc16is7xx_handle_tx(struct u
 		txlen = 0;
 	}
 
-	txlen = kfifo_out_linear_ptr(&tport->xmit_fifo, &tail, txlen);
-	sc16is7xx_fifo_write(port, tail, txlen);
-	uart_xmit_advance(port, txlen);
+	/* Handle circular buffer wrap-around by sending multiple segments */
+	while (txlen > 0 && !kfifo_is_empty(&tport->xmit_fifo)) {
+		unsigned char *tail;
+		unsigned int to_send;
+
+		to_send = kfifo_out_linear_ptr(&tport->xmit_fifo, &tail, txlen);
+		if (!to_send)
+			break;
+
+		sc16is7xx_fifo_write(port, tail, to_send);
+		uart_xmit_advance(port, to_send);
+		txlen -= to_send;
+	}
 
 	uart_port_lock_irqsave(port, &flags);
 	if (kfifo_len(&tport->xmit_fifo) < WAKEUP_CHARS)


