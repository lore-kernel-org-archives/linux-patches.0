Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C694DBD62;
	Fri,  9 Oct 2026 14:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556264; cv=none; b=hGznDujgfrdlbTjmzJOtWZaMImJfKM0HUhBoFUVCapET3A9Bb6ql54sOmQGdmHeF+lkgAkQEkrBTpTJT1pCiog8OvASXfzzby0gEKcC9YpGKPFUYzc3xlaItt/zCZRqsZqtuFZafy5J93xBPG6Bgl3GzHKgFgVCiruArq4BvgHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556264; c=relaxed/simple;
	bh=ZsLQuLocj1zMLkH8ylTV1Z/adwLjHq9BsSgDp6C+w3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYiIyP2+URdWScTQvzF1/wvln8R7NvjNCX8VIU8p+V8AiHxZx3SMiFbPk+u2WFlQj3Yfqq92Z9xWBv+zQb2D7ZvIYh6Dt9ejUNCjZW7uxlSzFLkipjq0QLOCsXDCFz6SwPw2AUVZzdXtlgqcnFY5T9AEXXwyNknNpVBzCOXb2fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PV+A7d4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PV+A7d4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7931F000FF;
	Fri,  9 Oct 2026 14:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556263;
	bh=w/WcsbnVAfVEoMVfFlf2zQA1nGQyJ7DYJvNYlWeeXl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PV+A7d4ww/bo43JplyQQCaSw0+IGqWD1OuAkD7hIs5NdLo3asukI08G3g3vN2YfEU
	 ZIoDhEI9dNyR/XiCUduG9KMtahEd+/9qGPR3hwo2+l5eOzmQexdPTidasDILeA/6cx
	 bYX7IkSpXQvaitpExb1qBXk3PVIvIptpFHGgDBZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Tobias Gannert <tobias.gannert@ziehl-abegg.de>,
	Joachim Knorr <joachim.knorr@ziehl-abegg.de>,
	Paul Mbewe <paultyson.mbewe@ziehl-abegg.de>
Subject: [PATCH 6.18 206/403] serial: sc16is7xx: fix TX gap caused by kfifo circular buffer wrap-around
Date: Fri,  9 Oct 2026 16:09:27 +0200
Message-ID: <20261009140956.955678469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
@@ -699,7 +699,6 @@ static void sc16is7xx_handle_tx(struct u
 	struct tty_port *tport = &port->state->port;
 	unsigned long flags;
 	unsigned int txlen;
-	unsigned char *tail;
 
 	if (unlikely(port->x_char)) {
 		sc16is7xx_port_write(port, SC16IS7XX_THR_REG, port->x_char);
@@ -724,9 +723,19 @@ static void sc16is7xx_handle_tx(struct u
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


