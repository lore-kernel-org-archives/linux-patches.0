Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026357;
	b=WzaHzLD+B9rorKTQL5HIojCaomS76L7jVBoGq3RR4u12y/fWKqGPc+tjLwKwXAb6EQUt
	 hCoApDLkaFm9c8y+rPmxs5E5U8Wrv/z6marUkVme4CGrQfKMNF8apaqFdX0ChPuKDLVSi
	 BPl/XfRFNMlt/c7nY2QHM0ogi91eypsPecVPAGFfKjn+jsgCIRotBjUZuQQS5omMEdR7W
	 lXqCtS8ewWNsguSc6mcZe252cf7+Fx96cgaUeg0qNhn/6VG1M6+ptUnNidV2/2B2m8+9B
	 5AuKcu+h96Yd2Ibg0TjwDty0uVPa5mUF5oh1i8fulVgHz+uBDn/OWgNwrGQm/6L45Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bS64lYd/O5NK+MiM264eI6UmYIFp/Nib3FDHgprLHPY=;
	b=JuyLfxXFdsm1PUphdliYa6/1rntcFQ9f2O6U/jF2gYYTwU+rNbT+SVpNIRc1biUoT/IC
	 d9Hfuiw0A5ZcXtxUEBkgqnbxdcU1xDW0n1AxJbHmilEtCILOOdm//gRszU3LtbzyaRYcL
	 Qkse6Ff/nZN+A5PHJv9WqrwK6Qu70uTAWbir847zYrd0Ru/WAe2B8qnQdwN2uE6kDTjwq
	 H8hQjay+YHUvCPIPQQ2+MzYy+RJlUOl7HsnlgQ+o+2rAeu4CIeJhnJ+TJPJtI1uX+iW5v
	 3FAwFaV/YMd+uWgJWBcUFd3zZ5l3NOIf+FAbFRrGUHT1besCNvbywKSUgwpz7SGHjJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ICKdALrL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2232F606A320;
	Wed, 18 Nov 2026 18:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ICKdALrL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED681F000C7;
	Wed, 18 Nov 2026 18:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026357;
	bh=bS64lYd/O5NK+MiM264eI6UmYIFp/Nib3FDHgprLHPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICKdALrLG4EmTiZ2JIXCz4k4Zh5rUC+tizh+Zxlx0n0xVpE0Vxhz20ufFSnY5iCbD
	 FNnlFNvwNUiiG9RoUiRQ/aeQJNwOGZUn7eMGDkpQ1CFX6zT5Yk+F+yjGpVpw7s6jZK
	 OJC7XA2of1bKZT44hXoY5nw44Ypluf+qNMXkzdR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1405/2151] serial: max310x: dont power down the port mid-transmission on close
Date: Wed, 18 Nov 2026 15:52:20 +0100
Message-ID: <20261118150213.163015554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

[ Upstream commit c3ad42ccd303113a08bd0b441fb5b3380f29c5bf ]

max310x_shutdown() powers the port down regardless of what the
transmitter is doing. The power-off stops the UART clock mid-character,
truncating the final frame, and on the auto-RTS path it freezes the
RTS output at its current level: a close() with data still queued
leaves the RS485 transceiver asserted until the next open, which also
emits the interrupted character corrupted.

Waiting for the data to drain is no better: the tty layer's
wait-until-sent is bounded by closing_wait, configurable to none, and
a hangup arrives with no wait at all, so draining a full FIFO blocks
close() in uninterruptible sleep for seconds at low baud rates - and
forever when CTS flow control blocks the FIFO.

Instead, set MODE1 TxDisabl: the character in flight completes and the
transmitter ceases with TX_ at idle. Give that character one character
time (the chip has no transmitter-idle status), then reset the FIFOs
so the auto-RTS engine sees the transmitter empty and releases RTS
within the configured after-send hold; wait that hold plus one bit
time before powering off. Abandoned data was explicitly not waited
for, and startup() resets the FIFOs and TxDisabl on open anyway.

Measured on a MAX14830: a truncating close() at 50 baud takes 0.23 s,
RTS releases one character plus the hold after the last stop bit on
both polarities, and the reopen corruption is gone.

Fixes: f65444187a66 ("serial: New serial driver MAX310X")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Link: https://patch.msgid.link/20261008-max310x-rs485-sw-delay-v8-5-6ba881f81e1f@vaisala.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c |   44 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -289,6 +289,7 @@ struct max310x_one {
 	struct work_struct	md_work;
 	struct work_struct	rs_work;
 	struct regmap		*regmap;
+	unsigned int		char_time_us;
 	unsigned int		baud;
 	bool			tx_break;	/* break_ctl() owns the transceiver */
 
@@ -984,6 +985,7 @@ static void max310x_set_termios(struct u
 				struct ktermios *termios,
 				const struct ktermios *old)
 {
+	unsigned int frame_bits = tty_get_frame_size(termios->c_cflag);
 	unsigned int lcr = 0, flow = 0;
 	int baud;
 
@@ -1096,10 +1098,13 @@ static void max310x_set_termios(struct u
 	uart_update_timeout(port, termios->c_cflag, baud);
 
 	/*
-	 * Cache the new baud rate and reprogram the RS485 RTS delays, whose
-	 * millisecond-to-bit-time conversion depends on it.
+	 * Cache the new baud rate and the time it takes to clock out one
+	 * character before reprogramming the RS485 RTS delays: the
+	 * millisecond-to-bit-time conversion divides by the baud rate.
 	 */
 	to_max310x_port(port)->baud = baud;
+	to_max310x_port(port)->char_time_us =
+		DIV_ROUND_UP(USEC_PER_SEC * frame_bits, baud);
 	max310x_set_rts_ctl_params(to_max310x_port(port));
 }
 
@@ -1156,9 +1161,10 @@ static int max310x_startup(struct uart_p
 	one->tx_break = false;
 	max310x_port_update(port, MAX310X_LCR_REG, MAX310X_LCR_TXBREAK_BIT, 0);
 
-	/* Configure MODE1 register */
+	/* Configure MODE1: re-enable the transmitter shutdown() stopped */
 	max310x_port_update(port, MAX310X_MODE1_REG,
-			    MAX310X_MODE1_TRNSCVCTRL_BIT, 0);
+			    MAX310X_MODE1_TRNSCVCTRL_BIT |
+			    MAX310X_MODE1_TXDIS_BIT, 0);
 
 	/* Configure MODE2 register & Reset FIFOs*/
 	val = MAX310X_MODE2_RXEMPTINV_BIT | MAX310X_MODE2_FIFORST_BIT;
@@ -1195,9 +1201,39 @@ static int max310x_startup(struct uart_p
 
 static void max310x_shutdown(struct uart_port *port)
 {
+	struct max310x_one *one = to_max310x_port(port);
+
 	/* Disable all interrupts */
 	max310x_port_write(port, MAX310X_IRQEN_REG, 0);
 
+	/*
+	 * Stop the transmitter: the character in flight completes, data
+	 * still queued is abandoned (the next startup() resets the FIFOs).
+	 */
+	max310x_port_update(port, MAX310X_MODE1_REG,
+			    MAX310X_MODE1_TXDIS_BIT, MAX310X_MODE1_TXDIS_BIT);
+
+	/*
+	 * Let the character in flight finish (the chip has no
+	 * transmitter-idle status), then empty the FIFO: auto-RTS releases
+	 * only once the transmitter is empty, and the power-off below
+	 * would freeze an asserted pin until the next open.
+	 */
+	fsleep(one->char_time_us);
+	max310x_port_update(port, MAX310X_MODE2_REG,
+			    MAX310X_MODE2_FIFORST_BIT,
+			    MAX310X_MODE2_FIFORST_BIT);
+	max310x_port_update(port, MAX310X_MODE2_REG,
+			    MAX310X_MODE2_FIFORST_BIT, 0);
+	if (port->rs485.flags & SER_RS485_ENABLED && one->baud) {
+		unsigned int hold = DIV_ROUND_UP(one->baud *
+				port->rs485.delay_rts_after_send,
+				MSEC_PER_SEC);
+
+		fsleep(max(DIV_ROUND_UP((hold + 1) * USEC_PER_SEC,
+					one->baud), 100U));
+	}
+
 	max310x_power(port, 0);
 }
 


