Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210999;
	b=G2Qr7O48rbh8ex7y6hIDjRd1ua6tUT9HdjSbyw9BkUuQpRlP87WzEoLfZfNB3cSsmCgQ
	 4pbgslej/FRGdH7O5NsevxZFDD2pXYRg5t0VJ8b+wF8kWxtR4k9IoUdbYGGQVz3OTqIrs
	 mTBPU9CFMGEsrDT4mt+dttKQJvbBBWkIGUdIxpa0BrR67fIrHm2v0RIuvFllqRZbfjIZF
	 PUMnMkPLp4Qo4woWLus9eLfskLhYf8NNOS4daWM/GFm13uv9mLjYWqtw2SEMg5TeSBqIP
	 kMD9VAFU3NRQepIY4EmdgZD39sZSwsALv2X665BYPWPzitOqLQBJdNSXTJvjTDfFE1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MqPgYBLZJhxS9VefRbukaA1E9GC77vQicZD84/apdIA=;
	b=pY+rKTwqGnioWbO9/CTzVjNwER+aTTPpM11mV6q7/kxbQ9+OfGgdy0ziOTq/6mIWTi6v
	 N/S6JgKlL1VmiWJZx7tEUz4h6xjZzVvRcz/RCqnGOCgTLkuZeNs7F+bbE8wKf3shlGrEk
	 6hORILYgjDmV2OK6NNhyEswEUaJWnQYRilB8kkyw9at5dnIO7kNjapht4RhpcGGx+gROy
	 yaZZ2DyzO0O+54zdLhRbpN9fLn4fefvpQGBTD/2pZzLPKtNJLVMlA8w6a+0e0B1R36mva
	 wMI9CxllT/CTlUwu1UHz4DGg/kKuzs6ws0q1Z2y9jNY1x2WMKrKspjN48waM0y4wReA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IUzMnNXs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC113606A31D;
	Wed, 28 Oct 2026 18:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IUzMnNXs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8E31F01825;
	Wed, 28 Oct 2026 18:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210998;
	bh=MqPgYBLZJhxS9VefRbukaA1E9GC77vQicZD84/apdIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUzMnNXsIOI/Yv6R6aoK3vF9QHjTqkIsJr8up7nxx6p4g5B5BtH+TJlPVhK19vmaS
	 8DY80b9ZopdKrlhcEPK/UOrHwiIguN6XYpuOBUqaJMUTw3gM2138dPmawVBYkJVszW
	 1p5iLcb5VyYESxkI4g4SM2AmLtrJ797bG9Izyp9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Simon Gassner <simon.gassner@noxsystems.com>
Subject: [PATCH 5.15 221/571] serial: tegra: dont clear the Tx FIFO on an Rx-only reset
Date: Wed, 28 Oct 2026 17:56:08 +0100
Message-ID: <20261028170013.244046672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Gassner <simon.gassner@noxsystems.com>

commit 8aebfde6e84dceb7d47fe8001e50b754eb45d5df upstream.

tegra_uart_fifo_reset() applies the Tegra30 workaround for
"cannot clear the Tx FIFO while FIFO mode is enabled"
unconditionally: it leaves FIFO mode, writes the requested FCR
clear bits, and re-enters FIFO mode. Leaving FIFO mode empties
both FIFOs, so an Rx-only reset discards queued Tx data as well.

The break handler in tegra_uart_decode_rx_error() calls it with
UART_FCR_CLEAR_RCVR only. On a half-duplex RS485 board whose Rx
line is pulled low while the transceiver drives the bus, every
transmission raises a spurious break, and all but the first
character of the frame is lost.

Only take the FIFO-mode path when the caller actually asked for
CLEAR_XMIT. Likewise only wait for TEMT in that case: with the Tx
FIFO deliberately left intact, that loop would otherwise spin for
a full frame time in hard IRQ context with the port lock held.

Tested on a Colibri T30 (Tegra30) with Rx DMA:

 - Break during transmission: the reset still fires from
   tegra_uart_decode_rx_error(), and the complete frame now
   reaches the peer. Before this change only the character in
   the shift register was sent.
 - Internal loopback with a generated break: the Rx FIFO is
   correctly cleared by the plain FCR write, and subsequent
   receive works with no frame, parity or overrun errors.

Fixes: e9ea096dd225 ("serial: tegra: add serial driver")
Cc: stable@kernel.org
Signed-off-by: Simon Gassner <simon.gassner@noxsystems.com>
Link: https://patch.msgid.link/20261001060539.32659-1-simon.gassner@noxsystems.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial-tegra.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -307,11 +307,19 @@ static void tegra_uart_fifo_reset(struct
 {
 	unsigned long fcr = tup->fcr_shadow;
 	unsigned int lsr, tmout = 10000;
+	bool clear_tx = !!(fcr_bits & UART_FCR_CLEAR_XMIT);
 
 	if (tup->rts_active)
 		set_rts(tup, false);
 
-	if (tup->cdata->allow_txfifo_reset_fifo_mode) {
+	/*
+	 * Leaving FIFO mode below is a workaround for a Tegra30
+	 * restriction on clearing the Tx FIFO while FIFO mode is
+	 * enabled. It empties both FIFOs, so applying it to an
+	 * Rx-only reset would destroy an in-flight transmission.
+	 * Only take that path when the caller asked for CLEAR_XMIT.
+	 */
+	if (tup->cdata->allow_txfifo_reset_fifo_mode || !clear_tx) {
 		fcr |= fcr_bits & (UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
 		tegra_uart_write(tup, fcr, UART_FCR);
 	} else {
@@ -336,9 +344,15 @@ static void tegra_uart_fifo_reset(struct
 	 */
 	tegra_uart_wait_cycle_time(tup, 32);
 
+	/*
+	 * Only wait for the transmitter to drain when the Tx FIFO was
+	 * part of the reset. For an Rx-only reset it is left intact,
+	 * and waiting for TEMT here would spin for a full frame time.
+	 */
 	do {
 		lsr = tegra_uart_read(tup, UART_LSR);
-		if ((lsr & UART_LSR_TEMT) && !(lsr & UART_LSR_DR))
+		if ((!clear_tx || (lsr & UART_LSR_TEMT)) &&
+		    !(lsr & UART_LSR_DR))
 			break;
 		udelay(1);
 	} while (--tmout);


