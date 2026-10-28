Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208935;
	b=x4Arf85LtWxQG6Ly+uIFffDuburhSwydXjFsGZhJE4K1ueR97rpjx1OCm3CqBcUZ+NjH
	 ae+bZGM0hFJAJBS/5EbkDQADJalMsq350NMjeO/w/xRez/NCWAp397XSjd1uYxFtAzivG
	 npuN0p6ucuixb3ZhTDn4r2+6CMFGYS2mNMcHyYpYI7+Oir5yndmSYqOXf+UlF6wG+9dQX
	 I/Chu5pX+ne+OZ9v3CeEIBqHGPGVzGiI5XP2rWM5heEPo6/K7KPpXYUjgF850E2JpqZCP
	 r7ktGkdnQyGp6zO5VH35sWIEH5shc/H7NUdsm2b/AgXj92SYg/kMNrHdQAbmYJS2R7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sjV8F+5eH4UkqgUZeqcjux2hdm/1yj0LTWazU9phVa4=;
	b=uXASkCHLs/go31G07+bJDGZ4Yp9neOnh1vb+yFfJKP8xci+Wedwh4cLehmDXpQmwAbXe
	 STmGBk/RXSHCb9nqFGkK8xxVcdI4RWMVz0WVP0q0fbYL8z0OWv2qMlsDkLhRIcfIdHQze
	 0myXFpKKQP0LhdVdp2N1jbVjyvUKaEM1hEbVPnHnJ4BLlI40SGQyKdGABMHo000MERcV1
	 BNegQ0X7yBgjruNPQeuIvNYABKb0GphNK98zo5O9VLAo9p5GbJcg/2K0BYiGeIsgw0xJ9
	 NPp2HyIVPq8kDPUD2vEMeVchDC/uYoEwRWGgxyCxhylOqtANsnQYydBRzweTDWa/qDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OPpIt5pB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF21606A31A;
	Wed, 28 Oct 2026 17:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OPpIt5pB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACFC1F01825;
	Wed, 28 Oct 2026 17:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208934;
	bh=sjV8F+5eH4UkqgUZeqcjux2hdm/1yj0LTWazU9phVa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPpIt5pBB7++WKEhFiM+gn2QcFU2oKTyV++YZmMgzpBWklCY+HvBzmrUKoc2gJhFy
	 Dtu/vtX3DoC+fU7gmb1O/MDR/IX8J8lmd9tROzUKtvu/nrfUNKVZegvPWXTN82emNr
	 CPt1/uE/OneW8O9KqedqB+GnrT13gpyoENnKLdi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Bowler <nbowler@draconx.ca>,
	syzbot+473d7477c523b41d4046@syzkaller.appspotmail.com,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 295/516] USB: serial: fix ioctl hangup race
Date: Wed, 28 Oct 2026 17:57:27 +0100
Message-ID: <20261028170010.480602317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit ae0e61d95677efa778379853e495d748e6efbf95 ]

The tty ioctls can race with hangup and end up calling into a tty driver
for a device that is already gone or powered down.

Serialise the callbacks using the tty port mutex and add the missing
checks to make sure the port has not been hung up before accessing port
driver data or hardware.

This specifically avoids dereferencing a NULL-pointer if a device is
disconnected during lengthy break signalling.

Note that TIOCGICOUNT and TIOCMIWAIT do not access port driver data or
hardware and are therefore not affected by the race.

Fixes: f34d7a5b7010 ("tty: The big operations rework")
Reported-by: Nick Bowler <nbowler@draconx.ca>
Link: https://lore.kernel.org/all/CADyTPExB2kYOOwkO0JqGhKaYVDqO9uS9WCw0J=MCTdVhcGOogA@mail.gmail.com/
Reported-by: syzbot+473d7477c523b41d4046@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6a9087a4.4d659fcc.734b4.0013.GAE@google.com
Cc: stable@vger.kernel.org	# 2.6.26
Signed-off-by: Johan Hovold <johan@kernel.org>
[ sashal: adapted locking to the older USB-serial callback interfaces. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/generic.c    |  10 ++-
 drivers/usb/serial/usb-serial.c | 111 +++++++++++++++++++++++++-------
 drivers/usb/serial/usb_wwan.c   |   6 +-
 3 files changed, 99 insertions(+), 28 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index d10aa3d2ee490..be4c34dc990ed 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -268,6 +268,7 @@ EXPORT_SYMBOL_GPL(usb_serial_generic_chars_in_buffer);
 void usb_serial_generic_wait_until_sent(struct tty_struct *tty, long timeout)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
 	unsigned int bps;
 	unsigned long period;
 	unsigned long expire;
@@ -287,7 +288,14 @@ void usb_serial_generic_wait_until_sent(struct tty_struct *tty, long timeout)
 					__func__, jiffies_to_msecs(timeout),
 					jiffies_to_msecs(period));
 	expire = jiffies + timeout;
-	while (!port->serial->type->tx_empty(port)) {
+	for (;;) {
+		mutex_lock(&tport->mutex);
+		if (tty_io_error(tty) || port->serial->type->tx_empty(port)) {
+			mutex_unlock(&tport->mutex);
+			break;
+		}
+		mutex_unlock(&tport->mutex);
+
 		schedule_timeout_interruptible(period);
 		if (signal_pending(current))
 			break;
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 38980e851667a..aad5e167d1eab 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -363,17 +363,13 @@ static int serial_chars_in_buffer(struct tty_struct *tty)
 static void serial_wait_until_sent(struct tty_struct *tty, int timeout)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct usb_serial *serial = port->serial;
 
 	dev_dbg(tty->dev, "%s\n", __func__);
 
 	if (!port->serial->type->wait_until_sent)
 		return;
 
-	mutex_lock(&serial->disc_mutex);
-	if (!serial->disconnected)
-		port->serial->type->wait_until_sent(tty, timeout);
-	mutex_unlock(&serial->disc_mutex);
+	port->serial->type->wait_until_sent(tty, timeout);
 }
 
 static void serial_throttle(struct tty_struct *tty)
@@ -399,25 +395,46 @@ static void serial_unthrottle(struct tty_struct *tty)
 static int serial_get_serial(struct tty_struct *tty, struct serial_struct *ss)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
+	int ret;
 
-	if (port->serial->type->get_serial)
-		return port->serial->type->get_serial(tty, ss);
-	return -ENOTTY;
+	if (!port->serial->type->get_serial)
+		return -ENOTTY;
+
+	mutex_lock(&tport->mutex);
+	if (tty_io_error(tty))
+		ret = -EIO;
+	else
+		ret = port->serial->type->get_serial(tty, ss);
+	mutex_unlock(&tport->mutex);
+
+	return ret;
 }
 
 static int serial_set_serial(struct tty_struct *tty, struct serial_struct *ss)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
+	int ret;
+
+	if (!port->serial->type->set_serial)
+		return -ENOTTY;
+
+	mutex_lock(&tport->mutex);
+	if (tty_io_error(tty))
+		ret = -EIO;
+	else
+		ret = port->serial->type->set_serial(tty, ss);
+	mutex_unlock(&tport->mutex);
 
-	if (port->serial->type->set_serial)
-		return port->serial->type->set_serial(tty, ss);
-	return -ENOTTY;
+	return ret;
 }
 
 static int serial_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
 	int retval = -ENOIOCTLCMD;
 
 	dev_dbg(tty->dev, "%s - cmd 0x%04x\n", __func__, cmd);
@@ -428,8 +445,21 @@ static int serial_ioctl(struct tty_struct *tty,
 			retval = port->serial->type->tiocmiwait(tty, arg);
 		break;
 	default:
-		if (port->serial->type->ioctl)
+		if (!port->serial->type->ioctl)
+			break;
+
+		if (cmd == TIOCSRS485)
+			down_write(&tty->termios_rwsem);
+
+		mutex_lock(&tport->mutex);
+		if (tty_io_error(tty))
+			retval = -EIO;
+		else
 			retval = port->serial->type->ioctl(tty, cmd, arg);
+		mutex_unlock(&tport->mutex);
+
+		if (cmd == TIOCSRS485)
+			up_write(&tty->termios_rwsem);
 	}
 
 	return retval;
@@ -438,25 +468,40 @@ static int serial_ioctl(struct tty_struct *tty,
 static void serial_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
 
 	dev_dbg(tty->dev, "%s\n", __func__);
 
-	if (port->serial->type->set_termios)
-		port->serial->type->set_termios(tty, port, old);
-	else
+	if (!port->serial->type->set_termios) {
 		tty_termios_copy_hw(&tty->termios, old);
+		return;
+	}
+
+	mutex_lock(&tport->mutex);
+	if (!tty_io_error(tty))
+		port->serial->type->set_termios(tty, port, old);
+	mutex_unlock(&tport->mutex);
 }
 
 static int serial_break(struct tty_struct *tty, int break_state)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
+	int ret = 0;
 
 	dev_dbg(tty->dev, "%s\n", __func__);
 
-	if (port->serial->type->break_ctl)
+	if (!port->serial->type->break_ctl)
+		return 0;
+
+	mutex_lock(&tport->mutex);
+	if (tty_io_error(tty))
+		ret = -EIO;
+	else
 		port->serial->type->break_ctl(tty, break_state);
+	mutex_unlock(&tport->mutex);
 
-	return 0;
+	return ret;
 }
 
 static int serial_proc_show(struct seq_file *m, void *v)
@@ -497,24 +542,44 @@ static int serial_proc_show(struct seq_file *m, void *v)
 static int serial_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
+	int ret;
 
 	dev_dbg(tty->dev, "%s\n", __func__);
 
-	if (port->serial->type->tiocmget)
-		return port->serial->type->tiocmget(tty);
-	return -EINVAL;
+	if (!port->serial->type->tiocmget)
+		return -EINVAL;
+
+	mutex_lock(&tport->mutex);
+	if (tty_io_error(tty))
+		ret = -EIO;
+	else
+		ret = port->serial->type->tiocmget(tty);
+	mutex_unlock(&tport->mutex);
+
+	return ret;
 }
 
 static int serial_tiocmset(struct tty_struct *tty,
 			    unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
+	int ret;
 
 	dev_dbg(tty->dev, "%s\n", __func__);
 
-	if (port->serial->type->tiocmset)
-		return port->serial->type->tiocmset(tty, set, clear);
-	return -EINVAL;
+	if (!port->serial->type->tiocmset)
+		return -EINVAL;
+
+	mutex_lock(&tport->mutex);
+	if (tty_io_error(tty))
+		ret = -EIO;
+	else
+		ret = port->serial->type->tiocmset(tty, set, clear);
+	mutex_unlock(&tport->mutex);
+
+	return ret;
 }
 
 static int serial_get_icount(struct tty_struct *tty,
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 628a75d1232ae..b91eaaad9fabc 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -139,7 +139,7 @@ int usb_wwan_get_serial_info(struct tty_struct *tty,
 
 	ss->line            = port->minor;
 	ss->port            = port->port_number;
-	ss->baud_base       = tty_get_baud_rate(port->port.tty);
+	ss->baud_base       = tty_get_baud_rate(tty);
 	ss->close_delay	    = jiffies_to_msecs(port->port.close_delay) / 10;
 	ss->closing_wait    = port->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
 				 ASYNC_CLOSING_WAIT_NONE :
@@ -160,8 +160,7 @@ int usb_wwan_set_serial_info(struct tty_struct *tty,
 			ASYNC_CLOSING_WAIT_NONE :
 			msecs_to_jiffies(ss->closing_wait * 10);
 
-	mutex_lock(&port->port.mutex);
-
+	/* core holds the port mutex */
 	if (!capable(CAP_SYS_ADMIN)) {
 		if ((close_delay != port->port.close_delay) ||
 		    (closing_wait != port->port.closing_wait))
@@ -173,7 +172,6 @@ int usb_wwan_set_serial_info(struct tty_struct *tty,
 		port->port.closing_wait = closing_wait;
 	}
 
-	mutex_unlock(&port->port.mutex);
 	return retval;
 }
 EXPORT_SYMBOL(usb_wwan_set_serial_info);
-- 
2.53.0



