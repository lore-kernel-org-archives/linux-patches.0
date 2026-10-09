Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB13F4E433E;
	Fri,  9 Oct 2026 15:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791558285; cv=none; b=Wf49BSReFxpd0d0OEzXC5UkSSg8ysuxkGmtjWWPYgigeHAsQfZhT5zHiNnSYo2vQTIliwuG9WCwgHU6zL5cz6BBD9GXdlC6oFeO5eRNRc7AabjGTN91XEQ4PDI6dd/rfyhB+1HV1eJwJsgw9DAAKcv39ow0xGYh3mmO0rDP9Zv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791558285; c=relaxed/simple;
	bh=f8iXvIi1ttdRZBJAKhg4vklz/txzF/ysUkbLrDEr+oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6g7hudvCanqBvn61CcNhLJu9jtBqWDjf2CObQLtFiUv70gz35I4o4qV99fFTcom9JKWsKnRuh5Hd5ohYTtRRUho+GezUeF7SYrSGmroiNfK2IilG4wEB9YW+vRDUlD+Od7/N1IvbOk3NCnWM7pnt9D+V+qIl+JYhLDoRa+RKlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JukJJgzX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JukJJgzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CD21F00893;
	Fri,  9 Oct 2026 15:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791558283;
	bh=LZgZzks2sxPQSudUKnPUc3PaaNlp+lM3kEfKM3QUpGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JukJJgzXo4frOyK0fuJTR7zH8Yv++4ommadVRVlvXSEtVefrd76VoTdNucsSrm93t
	 aZtgm3bwu/fmsXt6KfbPlS/7p2guWyqT4W4b6yVABb5azQxslECqbhWW37tx/yi3eG
	 FuZ14HN38cuM1EYHugz27pIdZeo18JC+LW/LTa1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	stable@kernel.org
Subject: [PATCH 7.2 254/428] serial: fix ioctl hangup race
Date: Fri,  9 Oct 2026 16:09:51 +0200
Message-ID: <20261009140951.685330917@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 8ca59f7baee7c72cf7729950b4ab2e7f910c9549 upstream.

The tty ioctls can race with hangup and end up calling into a tty
driver for a device that is already gone or powered down.

Add the missing checks to make sure the port has not been hung up before
accessing the hardware to avoid issues like kernel panic due to
unclocked accesses.

Note that TIOCGSERIAL, TIOCGICOUNT do not access hardware and are
therefore not affected by the race.

Also note that the initialised check in uart_set_ldisc() added by commit
2f70e49ed860 ("serial_core: Check for port state when tty is in error
state") should have been done under the port lock to avoid racing with
uart_do_autoconfig().

Fixes: 04f378b198da ("tty: BKL pushdown")
Cc: stable@kernel.org	# 2.6.26
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260910130816.642699-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |   41 +++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -895,7 +895,7 @@ static int uart_set_info(struct tty_stru
 	upf_t old_flags, new_flags;
 	int retval;
 
-	if (!uport)
+	if (!uport || tty_io_error(tty))
 		return -EIO;
 
 	new_port = new_info->port;
@@ -1118,7 +1118,7 @@ static int uart_break_ctl(struct tty_str
 	guard(mutex)(&port->mutex);
 
 	uport = uart_port_check(state);
-	if (!uport)
+	if (!uport || tty_io_error(tty))
 		return -EIO;
 
 	if (uport->type != PORT_UNKNOWN && uport->ops->break_ctl)
@@ -1143,7 +1143,7 @@ static int uart_do_autoconfig(struct tty
 	 */
 	scoped_cond_guard(mutex_intr, return -ERESTARTSYS, &port->mutex) {
 		uport = uart_port_check(state);
-		if (!uport)
+		if (!uport || tty_io_error(tty))
 			return -EIO;
 
 		if (tty_port_users(port) != 1)
@@ -1198,7 +1198,7 @@ static void uart_enable_ms(struct uart_p
  * FIXME: This wants extracting into a common all driver implementation
  * of TIOCMWAIT using tty_port.
  */
-static int uart_wait_modem_status(struct uart_state *state, unsigned long arg)
+static int uart_wait_modem_status(struct tty_struct *tty, struct uart_state *state, unsigned long arg)
 {
 	struct uart_port *uport;
 	struct tty_port *port = &state->port;
@@ -1212,11 +1212,21 @@ static int uart_wait_modem_status(struct
 	uport = uart_port_ref(state);
 	if (!uport)
 		return -EIO;
+
+	mutex_lock(&port->mutex);
+	if (tty_io_error(tty)) {
+		mutex_unlock(&port->mutex);
+		ret = -EIO;
+		goto out_deref;
+	}
+
 	uart_port_lock_irq(uport);
 	memcpy(&cprev, &uport->icount, sizeof(struct uart_icount));
 	uart_enable_ms(uport);
 	uart_port_unlock_irq(uport);
 
+	mutex_unlock(&port->mutex);
+
 	add_wait_queue(&port->delta_msr_wait, &wait);
 	for (;;) {
 		uart_port_lock_irq(uport);
@@ -1250,6 +1260,7 @@ static int uart_wait_modem_status(struct
 	}
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&port->delta_msr_wait, &wait);
+out_deref:
 	uart_port_deref(uport);
 
 	return ret;
@@ -1572,7 +1583,7 @@ uart_ioctl(struct tty_struct *tty, unsig
 
 	/* This should only be used when the hardware is present. */
 	if (cmd == TIOCMIWAIT)
-		return uart_wait_modem_status(state, arg);
+		return uart_wait_modem_status(tty, state, arg);
 
 	/* rs485_config requires more locking than others */
 	if (cmd == TIOCSRS485)
@@ -1628,14 +1639,13 @@ static void uart_set_ldisc(struct tty_st
 {
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *uport;
-	struct tty_port *port = &state->port;
-
-	if (!tty_port_initialized(port))
-		return;
 
 	guard(mutex)(&state->port.mutex);
 	uport = uart_port_check(state);
-	if (uport && uport->ops->set_ldisc)
+	if (!uport || tty_io_error(tty))
+		return;
+
+	if (uport->ops->set_ldisc)
 		uport->ops->set_ldisc(uport, &tty->termios);
 }
 
@@ -1651,7 +1661,7 @@ static void uart_set_termios(struct tty_
 	guard(mutex)(&state->port.mutex);
 
 	uport = uart_port_check(state);
-	if (!uport)
+	if (!uport || tty_io_error(tty))
 		return;
 
 	/*
@@ -1803,7 +1813,14 @@ static void uart_wait_until_sent(struct
 	 * 'timeout' / 'expire' give us the maximum amount of time
 	 * we wait.
 	 */
-	while (!port->ops->tx_empty(port)) {
+	for (;;) {
+		mutex_lock(&state->port.mutex);
+		if (tty_io_error(tty) || port->ops->tx_empty(port)) {
+			mutex_unlock(&state->port.mutex);
+			break;
+		}
+		mutex_unlock(&state->port.mutex);
+
 		msleep_interruptible(jiffies_to_msecs(char_time));
 		if (signal_pending(current))
 			break;


