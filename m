Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061548;
	b=YKutwTwtGK6rUSnAxaCxup/3AGatQvBMH1fwSsag35q79cezCyHKdrtc+N7CJFqzmGs4
	 10MkoXLLkHszxoOYGiuferN+0X2T4p/zEL//V4i98zi6jFdi4ekRkUUkMTZX9dJm+B/ou
	 WfsAt5CI3ZI2Qzpz2FFfsnbIWD/rrXrSDCUHRGnluTT1Ds0U36tRxROrdLf02b/tECGse
	 RYMSSy8buOqEPzbPTt5eIGqnUxtBwkI8o8zxFkOKgaxPd18h9mv/FcyL0ktiHj061k7DF
	 bcjzxkPRvk/Bb83QlV1qEov8wCwe5IUNPQldIqcF0ZsEcrZcAKM+6NaW7FI2nmYxLJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5h1zB6WhTo9Bfd0aUuw9KbInlWPr85MfmSxxAtPR2II=;
	b=n1LcWNUqr6g1KZ9smgI78tfNaJ52K7boskciNe+sWv6GKtiK3WJ2RkPbpZyj3MghEnjc
	 MgkQP99g7jndWrHTaGwdwL+YCJd0nOQzq/igQDmPYyXvIUUiOO6bXjMHZBxpvgrVXHVLs
	 /S+Ys7BZgjCRCmX8IT3YO7IDjHz2CTVtbcdaAQ8DGp2nGfbJZzvyh8+fcvchX7AkZpvAp
	 GXvv2wH+3TZ5PFbASiNMmDCWf4J7YF0yrVzYPXVbRHbX8FPOj8YNWoqpZcA/5/ItGI+0C
	 NlPEP6tlBDoILqAjQAcSZ36R0f1QRIXuh1bjLZbryDPghx09RkO2DD8sMWii89SovDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jaUjpQ4k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A3B60A2602;
	Thu, 19 Nov 2026 04:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jaUjpQ4k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22C21F000C4;
	Thu, 19 Nov 2026 04:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061548;
	bh=5h1zB6WhTo9Bfd0aUuw9KbInlWPr85MfmSxxAtPR2II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jaUjpQ4kYqXyQpvSQ/w9qWeh0qWjh9m+9LC4n2lo80C9YeAVE7gbnVdkDdlWlT8I3
	 WhwswdO3uARm1hj42BS67nogp1m6MYZX5dYJ2VaEMb9oV9eHmfC14dmxZADeucd7MN
	 1n6Jo23cDuhCgq355/fN0oSSWgIBhyY2Q+EZaOws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1590/1848] serial: max310x: centralize the RS485 transceiver programming
Date: Wed, 18 Nov 2026 16:00:28 +0100
Message-ID: <20261118150026.079592238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

[ Upstream commit 56051740bf9720335a1a56e87a99e3491c33ce54 ]

The HDPIXDELAY RTS delays and the MODE1 auto-transceiver enable are
programmed in three places - the rs485-config worker, startup() and
break_ctl()'s break-off restore - each with its own copy of the
register sequence. Move the sequence into a helper,
max310x_set_rts_ctl_params(), together with the tx_break guard that
keeps the MODE1 write away from a break in progress; the break-off
restore reapplies the current configuration through the same helper.

No functional change intended. The copies differed only in that
startup() clamped the delays to the 4-bit field while the worker wrote
them unclamped; the helper clamps, and the difference is unreachable
while rs485_config() still rejects delays above 15 ms with -ERANGE.
Break-off additionally rewrites HDPIXDELAY with the values it already
holds, a no-op on the wire.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Link: https://patch.msgid.link/20261008-max310x-rs485-sw-delay-v8-3-6ba881f81e1f@vaisala.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 7784d6aee59a ("serial: max310x: fix RS485 delays being programmed as bit-times")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 85 ++++++++++++++++++++----------------
 1 file changed, 47 insertions(+), 38 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 68bec54fb9864..184de3da6846e 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -898,6 +898,38 @@ static void max310x_set_mctrl(struct uart_port *port, unsigned int mctrl)
 	schedule_work(&one->md_work);
 }
 
+/*
+ * Program the chip's RS485 RTS timing (HDPIXDELAY) and the auto
+ * transceiver control (MODE1) from the current configuration. The
+ * rs485-config worker, startup() and break_ctl()'s break-off restore
+ * each carried their own copy of this sequence.
+ */
+static void max310x_set_rts_ctl_params(struct max310x_one *one)
+{
+	struct uart_port *port = &one->port;
+	unsigned int delay;
+	u8 mode1 = 0;
+
+	delay = (clamp(port->rs485.delay_rts_before_send, 0U, 15U) << 4) |
+		clamp(port->rs485.delay_rts_after_send, 0U, 15U);
+	max310x_port_write(port, MAX310X_HDPIXDELAY_REG, delay);
+
+	if (port->rs485.flags & SER_RS485_ENABLED)
+		mode1 = MAX310X_MODE1_TRNSCVCTRL_BIT;
+
+	/*
+	 * A break owns the transceiver: break_ctl() disabled auto-RTS and
+	 * drives RTS manually, and restores it from the current
+	 * configuration when the break ends. Touching MODE1 here would
+	 * release the transceiver mid-break.
+	 */
+	if (one->tx_break)
+		return;
+
+	max310x_port_update(port, MAX310X_MODE1_REG,
+			    MAX310X_MODE1_TRNSCVCTRL_BIT, mode1);
+}
+
 static void max310x_break_ctl(struct uart_port *port, int break_state)
 {
 	struct max310x_one *one = to_max310x_port(port);
@@ -920,10 +952,7 @@ static void max310x_break_ctl(struct uart_port *port, int break_state)
 		max310x_port_update(port, MAX310X_MODE1_REG,
 				    MAX310X_MODE1_TRNSCVCTRL_BIT, 0);
 	} else {
-		max310x_port_update(port, MAX310X_MODE1_REG,
-				    MAX310X_MODE1_TRNSCVCTRL_BIT,
-				    (port->rs485.flags & SER_RS485_ENABLED) ?
-				    MAX310X_MODE1_TRNSCVCTRL_BIT : 0);
+		max310x_set_rts_ctl_params(one);
 	}
 	max310x_rts_ctl(port, break_state);
 }
@@ -1045,36 +1074,23 @@ static void max310x_set_termios(struct uart_port *port,
 static void max310x_rs_proc(struct work_struct *ws)
 {
 	struct max310x_one *one = container_of(ws, struct max310x_one, rs_work);
-	unsigned int delay, mode1 = 0, mode2 = 0;
+	unsigned int mode2 = 0;
 
 	/*
 	 * Serialize against break_ctl() and set_termios(), which run under
-	 * port->mutex: the tx_break test below and the MODE1 write must not
+	 * port->mutex: the tx_break-guarded register writes must not
 	 * straddle a break starting or ending.
 	 */
 	guard(mutex)(&one->port.state->port.mutex);
 
-	delay = (one->port.rs485.delay_rts_before_send << 4) |
-		one->port.rs485.delay_rts_after_send;
-	max310x_port_write(&one->port, MAX310X_HDPIXDELAY_REG, delay);
+	max310x_set_rts_ctl_params(one);
 
-	if (one->port.rs485.flags & SER_RS485_ENABLED) {
-		mode1 = MAX310X_MODE1_TRNSCVCTRL_BIT;
+	if (one->port.rs485.flags & SER_RS485_ENABLED &&
+	    !(one->port.rs485.flags & SER_RS485_RX_DURING_TX))
+		mode2 = MAX310X_MODE2_ECHOSUPR_BIT;
 
-		if (!(one->port.rs485.flags & SER_RS485_RX_DURING_TX))
-			mode2 = MAX310X_MODE2_ECHOSUPR_BIT;
-	}
-
-	/*
-	 * A break owns the transceiver: break_ctl() disabled auto-RTS and
-	 * drives RTS manually, and restores it when the break ends. Leave
-	 * MODE1 alone meanwhile or the break goes undriven mid-way.
-	 */
-	if (!one->tx_break)
-		max310x_port_update(&one->port, MAX310X_MODE1_REG,
-				    MAX310X_MODE1_TRNSCVCTRL_BIT, mode1);
 	max310x_port_update(&one->port, MAX310X_MODE2_REG,
-			MAX310X_MODE2_ECHOSUPR_BIT, mode2);
+			    MAX310X_MODE2_ECHOSUPR_BIT, mode2);
 }
 
 static int max310x_rs485_config(struct uart_port *port,
@@ -1121,21 +1137,14 @@ static int max310x_startup(struct uart_port *port)
 	max310x_port_update(port, MAX310X_MODE2_REG,
 			    MAX310X_MODE2_FIFORST_BIT, 0);
 
-	/* Configure mode1/mode2 to have rs485/rs232 enabled at startup */
-	val = (clamp(port->rs485.delay_rts_before_send, 0U, 15U) << 4) |
-		clamp(port->rs485.delay_rts_after_send, 0U, 15U);
-	max310x_port_write(port, MAX310X_HDPIXDELAY_REG, val);
-
-	if (port->rs485.flags & SER_RS485_ENABLED) {
-		max310x_port_update(port, MAX310X_MODE1_REG,
-				    MAX310X_MODE1_TRNSCVCTRL_BIT,
-				    MAX310X_MODE1_TRNSCVCTRL_BIT);
+	/* Configure the RS485 RTS timing and the RS485/RS232 mode bits. */
+	max310x_set_rts_ctl_params(one);
 
-		if (!(port->rs485.flags & SER_RS485_RX_DURING_TX))
-			max310x_port_update(port, MAX310X_MODE2_REG,
-					    MAX310X_MODE2_ECHOSUPR_BIT,
-					    MAX310X_MODE2_ECHOSUPR_BIT);
-	}
+	if (port->rs485.flags & SER_RS485_ENABLED &&
+	    !(port->rs485.flags & SER_RS485_RX_DURING_TX))
+		max310x_port_update(port, MAX310X_MODE2_REG,
+				    MAX310X_MODE2_ECHOSUPR_BIT,
+				    MAX310X_MODE2_ECHOSUPR_BIT);
 
 	/* Configure flow control levels */
 	/* Flow control halt level 96, resume level 48 */
-- 
2.53.0



