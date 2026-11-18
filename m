Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041377;
	b=4f/B2IKmrlmKx5rUhC0OXGwsB40gpbVB/L5lC5CrKKc6wFMS02g02HiISMdJDVSCHUiF
	 7z5LET18XFKheToS86sm1LHmUIT6td3WYXnIEWdOYr3TGYvhc1Nl/gb+aLTq1UsPp3n6p
	 YsZCAX0KZlp/UtH+deA6bB3n4IrPFrZ/yH0yCqVfpvIVyuPOa7Fdl3v6IHrqHUsw6KzJ3
	 Lr2/F6m/Lad2/kH0vdPBsH8kGrjw2XAMOL5ccEPnTUUUIC9m42lRmyH8YCFYnNSHbyO0z
	 +8RJmEkasJuitnf70+VhZjnk2O/+WmpQqijGgfHQnT9AT+NZoRJIOcEN+KtNihOdc+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KuGs9vg5PYuuFkqPn+ADtg2ZiQI5t1idppiboOJL9Vs=;
	b=BEUcPTtvm2Zr0sijwnQfLheEtlTKSMZAa4uE/K09hrVfJujeaWkZ1heQ3D77IWIvhGd7
	 j1mxv1z8lcsjow40w93ECAU1b5WF5uNPOLqcQUnv5SrClb4mgAtbw1H2xAGzbInkgKbV6
	 CxiXClsm/KMmuPro2JZr5LHvhk9dfR9eEfltPksUzOoH1zXxXuC3ZBqFyzZDXi+xG4gOX
	 hhH41+Du7rMYvq18E7O3n1lMYjJ+RNP8mUWEpTRV0gMPiZsm+xItVUBabla6QM85X9lC/
	 TYS4FDzHdnEgAh0j6A7BmIFrkrta6N3b9FBkgYzfBT0+q3vTo7rM8jZAhio6RNWxF8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhJD8ynh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6430A606A31C;
	Wed, 18 Nov 2026 22:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhJD8ynh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC0B1F000C4;
	Wed, 18 Nov 2026 22:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041377;
	bh=KuGs9vg5PYuuFkqPn+ADtg2ZiQI5t1idppiboOJL9Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhJD8ynhMkMEsNo9NGOCNaGo1hZ0w75LLJlX8P7eH35/YGRap22zG9Hz//cVMccyE
	 HmlmdLyVSv3DYt0wQPKULCX9+ZC0Skix/jJ+ljyejUlZpElDOsL1322izj7avHOAC/
	 Tbkx42FrccKeKxULn/vjcKcECIpYS3P031p2UHTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2791/3318] serial: max310x: dont power down the port mid-transmission on close
Date: Wed, 18 Nov 2026 15:56:53 +0100
Message-ID: <20261118150444.416280914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/tty/serial/max310x.c | 44 ++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 992b10a112b01..f2bd189f7f015 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -287,6 +287,7 @@ struct max310x_one {
 	struct work_struct	md_work;
 	struct work_struct	rs_work;
 	struct regmap		*regmap;
+	unsigned int		char_time_us;
 	unsigned int		baud;
 	bool			tx_break;	/* break_ctl() owns the transceiver */
 
@@ -973,6 +974,7 @@ static void max310x_set_termios(struct uart_port *port,
 				struct ktermios *termios,
 				const struct ktermios *old)
 {
+	unsigned int frame_bits = tty_get_frame_size(termios->c_cflag);
 	unsigned int lcr = 0, flow = 0;
 	int baud;
 
@@ -1083,10 +1085,13 @@ static void max310x_set_termios(struct uart_port *port,
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
 
@@ -1143,9 +1148,10 @@ static int max310x_startup(struct uart_port *port)
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
@@ -1179,9 +1185,39 @@ static int max310x_startup(struct uart_port *port)
 
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
 
-- 
2.53.0



