Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53DC15492
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhGOhMLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32957C433D9;
	Mon, 23 Oct 2023 11:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060249;
	bh=+DFrvvdWTWSD0E6F9u09jK5esv7AVfZkgokUxbvWvRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhGOhMLqAMEohzWOm0tXbvP+CKDUEzc1xSns3R/pUPUPZ0sHmoucf7MUNs6CwnfAX
	 IaNvMxHFVgqXP+qJnpfeloy5OIQYcxQrHdSovcj1mgJupaqJEvHNUlWRPrPuau39Px
	 9CAkUaXPfhY733UT5VuHzDPtiLDYQOszzNNJD3W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/196] serial: Move uart_change_speed() earlier
Date: Mon, 23 Oct 2023 12:55:47 +0200
Message-ID: <20231023104830.866155200@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 8e90cf29aef77b59ed6a6f6466add2af79621f26 ]

Move uart_change_speed() earlier to get rid of its forward declaration.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230309080923.11778-5-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8679328eb859 ("serial: Reduce spinlocked portion of uart_rs485_config()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 94 ++++++++++++++++----------------
 1 file changed, 46 insertions(+), 48 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 2cc5c68c8689f..07e694c4f4827 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -48,8 +48,6 @@ static struct lock_class_key port_lock_key;
  */
 #define RS485_MAX_RTS_DELAY	100 /* msecs */
 
-static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
-			      const struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
 static void uart_change_pm(struct uart_state *state,
 			   enum uart_pm_state pm_state);
@@ -177,6 +175,52 @@ static void uart_port_dtr_rts(struct uart_port *uport, int raise)
 		uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 }
 
+/* Caller holds port mutex */
+static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
+			      const struct ktermios *old_termios)
+{
+	struct uart_port *uport = uart_port_check(state);
+	struct ktermios *termios;
+	int hw_stopped;
+
+	/*
+	 * If we have no tty, termios, or the port does not exist,
+	 * then we can't set the parameters for this port.
+	 */
+	if (!tty || uport->type == PORT_UNKNOWN)
+		return;
+
+	termios = &tty->termios;
+	uport->ops->set_termios(uport, termios, old_termios);
+
+	/*
+	 * Set modem status enables based on termios cflag
+	 */
+	spin_lock_irq(&uport->lock);
+	if (termios->c_cflag & CRTSCTS)
+		uport->status |= UPSTAT_CTS_ENABLE;
+	else
+		uport->status &= ~UPSTAT_CTS_ENABLE;
+
+	if (termios->c_cflag & CLOCAL)
+		uport->status &= ~UPSTAT_DCD_ENABLE;
+	else
+		uport->status |= UPSTAT_DCD_ENABLE;
+
+	/* reset sw-assisted CTS flow control based on (possibly) new mode */
+	hw_stopped = uport->hw_stopped;
+	uport->hw_stopped = uart_softcts_mode(uport) &&
+			    !(uport->ops->get_mctrl(uport) & TIOCM_CTS);
+	if (uport->hw_stopped) {
+		if (!hw_stopped)
+			uport->ops->stop_tx(uport);
+	} else {
+		if (hw_stopped)
+			__uart_start(tty);
+	}
+	spin_unlock_irq(&uport->lock);
+}
+
 /*
  * Startup the port.  This will be called once per open.  All calls
  * will be serialised by the per-port mutex.
@@ -485,52 +529,6 @@ uart_get_divisor(struct uart_port *port, unsigned int baud)
 }
 EXPORT_SYMBOL(uart_get_divisor);
 
-/* Caller holds port mutex */
-static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
-			      const struct ktermios *old_termios)
-{
-	struct uart_port *uport = uart_port_check(state);
-	struct ktermios *termios;
-	int hw_stopped;
-
-	/*
-	 * If we have no tty, termios, or the port does not exist,
-	 * then we can't set the parameters for this port.
-	 */
-	if (!tty || uport->type == PORT_UNKNOWN)
-		return;
-
-	termios = &tty->termios;
-	uport->ops->set_termios(uport, termios, old_termios);
-
-	/*
-	 * Set modem status enables based on termios cflag
-	 */
-	spin_lock_irq(&uport->lock);
-	if (termios->c_cflag & CRTSCTS)
-		uport->status |= UPSTAT_CTS_ENABLE;
-	else
-		uport->status &= ~UPSTAT_CTS_ENABLE;
-
-	if (termios->c_cflag & CLOCAL)
-		uport->status &= ~UPSTAT_DCD_ENABLE;
-	else
-		uport->status |= UPSTAT_DCD_ENABLE;
-
-	/* reset sw-assisted CTS flow control based on (possibly) new mode */
-	hw_stopped = uport->hw_stopped;
-	uport->hw_stopped = uart_softcts_mode(uport) &&
-				!(uport->ops->get_mctrl(uport) & TIOCM_CTS);
-	if (uport->hw_stopped) {
-		if (!hw_stopped)
-			uport->ops->stop_tx(uport);
-	} else {
-		if (hw_stopped)
-			__uart_start(tty);
-	}
-	spin_unlock_irq(&uport->lock);
-}
-
 static int uart_put_char(struct tty_struct *tty, unsigned char c)
 {
 	struct uart_state *state = tty->driver_data;
-- 
2.40.1



