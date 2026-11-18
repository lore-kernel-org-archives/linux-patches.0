Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031595;
	b=XeGc/hct+4Gc0/v+fn2ePd1MrL7zKTI71tG56bgRR20ednR62ddVs3H0sX/Z6aLrmRE5
	 /92yxDdrcZ4PzLJY/MFoBlnXhyy0cDVOO0W/mWM3vBPtA/nLWnRoxxKwu89sT4TP7E3bs
	 n643+6zjURHYt2M5qxLn91CMyqs9kmU/mKHJITAZF9ikkhqz9DRfAizDSApnAkyydrgiS
	 nCwDQmWe7RdnbEjp4qYUs7EvioWRUxSmMQh+Z9quinALpmzDIg7Pw3IEC8cGfhe+DgK9L
	 6Xa87X8xLxGHgk1EymcLzs7UiJtswI4sVnCbNEWHSlVbydS+LXOwBzr3KJvbPscw8pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wzI/9JMHXDaf6XFe2QomRVvHlDFOVOwORuN2MFPv5n4=;
	b=UY6cR+o0vM4A2p3y+MKfCrkgufhfCFvoBp6mdAi/1PlxVSQM123X5dslukA3fOEVcgW9
	 dtvcwPfIwcPnHnjOFCk5BgerYHI+ljr/p94mdMo0dNmyfXwllKt1mDF5/kLtnmVGxqBNq
	 dFsiDSIOgJTJrkJKfnFbrVkII5DLkDDttmlHjqX011AZZ0T/TtgqDtyxVqJbk4oE0xQC7
	 cCBpQjdEnV9la2IbUwU9lALg8TkI1FzGaoX+zGgtTXxwLjNoTQeCl2lAk3/9A/dY6kxvB
	 bOCrES8ec3KqsFhfI6MTSZ37Qsy9g7XZdUL7bjWMFlL4+s5FVIl3010nCAaV2HsA75Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iERqtIe1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A11606A320;
	Wed, 18 Nov 2026 19:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iERqtIe1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45E71F000C4;
	Wed, 18 Nov 2026 19:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031595;
	bh=wzI/9JMHXDaf6XFe2QomRVvHlDFOVOwORuN2MFPv5n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iERqtIe1FOWBoxmTt40PKWKiWsm+Es51VGtC6wGsWy+uuEijTEbbtl0gQa5jsfWia
	 Ei5fquJyjZnPq11Tdj3xq3dBdQfspgKXSG1E9lJ8Unei4g1yOm3xcRRUOFybh2u99W
	 QbmYxt8WDOLOcweaYPoVuKADkURBFnxAWjvhD3OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1114/1756] serial: max310x: fix breaks not reaching the wire in RS485 mode
Date: Wed, 18 Nov 2026 15:54:01 +0100
Message-ID: <20261118150054.490924002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

[ Upstream commit 4efacb600bf98b13e0659f05afa4549795277e35 ]

The chip's auto-RTS (MODE1.TRNSCVCTRL) asserts the RS485 transceiver
only while FIFO data is shifting out, and a break is not FIFO data: on
an RS485 port a requested break sets the TX break bit but the
transceiver is never enabled, so the break never reaches the wire.
Break-led protocols cannot work at all.

Disable auto-RTS for the break duration and drive RTS manually via the
LCR RTS bit, then restore auto-RTS when the break ends. Track the break
in tx_break and leave MODE1 alone in the rs485-config worker while it
is set - a TIOCSRS485 arriving mid-break would otherwise re-enable
auto-RTS on top of the manual RTS and release the transceiver before
the break ends; break_ctl() restores auto-RTS from the then-current
configuration when the break completes. The worker runs under
port->mutex - break_ctl() and set_termios() already do - so the
tx_break test and the MODE1 write cannot straddle a break starting or
ending, and startup() clears tx_break alongside the latched TXBREAK
bit, since a port can be closed with a break still asserted.

Only the break assertion is gated on RS485 being enabled; the restore
at break end runs unconditionally and derives MODE1 from the current
configuration. Returning early for a port whose RS485 was disabled
mid-break - that reconfigure is deferred like any other - would leak
the manually driven RTS and leave the transceiver holding the bus
indefinitely after the break ends. On a non-RS485 port the restore is
a no-op: nothing else writes the LCR RTS bit.

Fixes: 55367c620aed ("serial: max310x: Add support for RS-485 mode")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Link: https://patch.msgid.link/20261008-max310x-rs485-sw-delay-v8-2-6ba881f81e1f@vaisala.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 49 ++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index ea09a77e89c03..c9052adcfe19a 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -285,6 +285,7 @@ struct max310x_one {
 	struct work_struct	md_work;
 	struct work_struct	rs_work;
 	struct regmap		*regmap;
+	bool			tx_break;	/* break_ctl() owns the transceiver */
 
 	u8 rx_buf[MAX310X_FIFO_SIZE];
 };
@@ -651,6 +652,12 @@ static void max310x_batch_read(struct uart_port *port, u8 *rxbuf, unsigned int l
 	regmap_noinc_read(one->regmap, MAX310X_RHR_REG, rxbuf, len);
 }
 
+static void max310x_rts_ctl(struct uart_port *port, bool rts_state)
+{
+	max310x_port_update(port, MAX310X_LCR_REG, MAX310X_LCR_RTS_BIT,
+			    rts_state ? MAX310X_LCR_RTS_BIT : 0);
+}
+
 static void max310x_handle_rx(struct uart_port *port, unsigned int rxlen)
 {
 	struct max310x_one *one = to_max310x_port(port);
@@ -886,9 +893,32 @@ static void max310x_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 static void max310x_break_ctl(struct uart_port *port, int break_state)
 {
+	struct max310x_one *one = to_max310x_port(port);
+
+	one->tx_break = break_state;
+
 	max310x_port_update(port, MAX310X_LCR_REG,
 			    MAX310X_LCR_TXBREAK_BIT,
 			    break_state ? MAX310X_LCR_TXBREAK_BIT : 0);
+
+	/*
+	 * The chip's auto-RTS asserts the transceiver only while FIFO data is
+	 * shifting out, and a break is not FIFO data. Disable auto-RTS for the
+	 * break duration and drive RTS manually so the break reaches the wire;
+	 * restore auto-RTS when the break ends.
+	 */
+	if (break_state) {
+		if (!(port->rs485.flags & SER_RS485_ENABLED))
+			return;
+		max310x_port_update(port, MAX310X_MODE1_REG,
+				    MAX310X_MODE1_TRNSCVCTRL_BIT, 0);
+	} else {
+		max310x_port_update(port, MAX310X_MODE1_REG,
+				    MAX310X_MODE1_TRNSCVCTRL_BIT,
+				    (port->rs485.flags & SER_RS485_ENABLED) ?
+				    MAX310X_MODE1_TRNSCVCTRL_BIT : 0);
+	}
+	max310x_rts_ctl(port, break_state);
 }
 
 static void max310x_set_termios(struct uart_port *port,
@@ -1012,6 +1042,13 @@ static void max310x_rs_proc(struct work_struct *ws)
 	struct max310x_one *one = container_of(ws, struct max310x_one, rs_work);
 	unsigned int delay, mode1 = 0, mode2 = 0;
 
+	/*
+	 * Serialize against break_ctl() and set_termios(), which run under
+	 * port->mutex: the tx_break test below and the MODE1 write must not
+	 * straddle a break starting or ending.
+	 */
+	guard(mutex)(&one->port.state->port.mutex);
+
 	delay = (one->port.rs485.delay_rts_before_send << 4) |
 		one->port.rs485.delay_rts_after_send;
 	max310x_port_write(&one->port, MAX310X_HDPIXDELAY_REG, delay);
@@ -1023,8 +1060,14 @@ static void max310x_rs_proc(struct work_struct *ws)
 			mode2 = MAX310X_MODE2_ECHOSUPR_BIT;
 	}
 
-	max310x_port_update(&one->port, MAX310X_MODE1_REG,
-			MAX310X_MODE1_TRNSCVCTRL_BIT, mode1);
+	/*
+	 * A break owns the transceiver: break_ctl() disabled auto-RTS and
+	 * drives RTS manually, and restores it when the break ends. Leave
+	 * MODE1 alone meanwhile or the break goes undriven mid-way.
+	 */
+	if (!one->tx_break)
+		max310x_port_update(&one->port, MAX310X_MODE1_REG,
+				    MAX310X_MODE1_TRNSCVCTRL_BIT, mode1);
 	max310x_port_update(&one->port, MAX310X_MODE2_REG,
 			MAX310X_MODE2_ECHOSUPR_BIT, mode2);
 }
@@ -1047,6 +1090,7 @@ static int max310x_rs485_config(struct uart_port *port, struct ktermios *termios
 
 static int max310x_startup(struct uart_port *port)
 {
+	struct max310x_one *one = to_max310x_port(port);
 	unsigned int val;
 
 	max310x_power(port, 1);
@@ -1056,6 +1100,7 @@ static int max310x_startup(struct uart_port *port)
 	 * closed with a break still asserted, and set_termios() no longer
 	 * rewrites it.
 	 */
+	one->tx_break = false;
 	max310x_port_update(port, MAX310X_LCR_REG, MAX310X_LCR_TXBREAK_BIT, 0);
 
 	/* Configure MODE1 register */
-- 
2.53.0



