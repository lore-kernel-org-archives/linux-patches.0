Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019780;
	b=qMan9xXCimwdTAvtygMMx9cWShRV3WnB8HezYIa6lH/ghYjrdg4yZLt5lg9pxH0+qNRJ
	 iOb23gz9bvB+imj1wrde0qgDHINfgUkQWU8yD6TUblAu1rgE3wEuwcTyf8s8P68MBDQ6x
	 9C3BW0Yw8AG2BErRxeokcP2dZak9qQuLAcFpab5JcXv6Fmo/7RrYp0EoA047peyz6+GHj
	 h2sV/NAuV1i8F1jE0kh9j3TZZzQF5h7nVrS/U7Eh9/ZUyNbz3AB/2BNxXN2Zxs7F8k6b9
	 ql7szEX6n6/1p/mOcBbPaH5wJaGvns7mO/JWMWn973ogePSLWnYP4a7uyv6BwCxXWOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BEwH+bTgkaUFvxpPsFm69pKPoAX1QFgOqTxFb64imcA=;
	b=3QM5yk6FZZoKdcLyGuY8WtQIy11r7gQvRjysIxPxOjoUyOFpAZMm0UH5rrzgkzmV1rq1
	 box7pZKBPxF5JEh5EbbZkK45/q3DiN8M1esyQNenO+wEOLW3/8phxNU8DKiW+M76nu+2x
	 lI33gOK46QP+UgMw2mJjUoRFSZn7Vzr8X3wG8veHQvNibaWLpeOtZWhH8k5M+sTrXeF23
	 3v+91YZ1PSqH+JPO58V18EpDjfTs4O/tZIHmLjWhL66KvCc05YjYzsJ6lONT9eO8LNCDE
	 lfg+VIwewd09UzteGoJLm/GDYASraNWz04F48zu4RFM0eIT1rxlP/uYojbUEAkLnzDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EdUxz5Ld;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C015606A31C;
	Wed, 18 Nov 2026 16:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EdUxz5Ld
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010E51F000C4;
	Wed, 18 Nov 2026 16:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019780;
	bh=BEwH+bTgkaUFvxpPsFm69pKPoAX1QFgOqTxFb64imcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdUxz5LdfCgNsMWw5l+CjvBX6h9iyJTgNaDCHcWGGJcWX/t/P1aFk3Mo5Nh30g05f
	 6BuVVJg9Q/RnYnGCy4YHt52RTkmNXInpDY0uISaM9q+KY4q0yJ7OVsiGY22TTeKioj
	 0g5OlXqONYrDvnijSjVxJsMjud4pg3z1goAuQOU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1719/2651] serial: max310x: dont power down the port mid-transmission on close
Date: Wed, 18 Nov 2026 15:49:19 +0100
Message-ID: <20261118150349.521305182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -300,6 +300,7 @@ struct max310x_one {
 	struct work_struct	md_work;
 	struct work_struct	rs_work;
 	struct regmap		*regmap;
+	unsigned int		char_time_us;
 	unsigned int		baud;
 	bool			tx_break;	/* break_ctl() owns the transceiver */
 
@@ -1014,6 +1015,7 @@ static void max310x_set_termios(struct u
 				struct ktermios *termios,
 				const struct ktermios *old)
 {
+	unsigned int frame_bits = tty_get_frame_size(termios->c_cflag);
 	unsigned int lcr = 0, flow = 0;
 	int baud;
 
@@ -1126,10 +1128,13 @@ static void max310x_set_termios(struct u
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
 
@@ -1186,9 +1191,10 @@ static int max310x_startup(struct uart_p
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
@@ -1225,9 +1231,39 @@ static int max310x_startup(struct uart_p
 
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
 


