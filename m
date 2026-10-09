Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143CA4E4C5E;
	Fri,  9 Oct 2026 14:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557368; cv=none; b=f0coXQR2TbJ0m6B+ItQ95AanJbNPHIG2ymv3tLPi9wvJH9vbzLtR0Z11W7Pmeq9z2Vo3pLaAHvuuJ21eUL+2zHZObcaYeT1eVQCWMbnGwWwjCGpjZS26lmAUkCB4cA+w3h3tzMk2y8NhsWD0GgyhaIc2fH9874ef05cYvm0AR8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557368; c=relaxed/simple;
	bh=2eTMz5QzF3ycZPFZ2RNb8IE9oR4cshwee7G9XLt6Wd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOJJlYUX0w79NklaPD+IQE83N+9Yf+/QBn6eBOho0VmOVuPJYaGFofQF26rej7ZHB0z5BBodFprTRKXZVRlZSplvIGdbZk5+alYVUEVO5OnMuNole/pQopds5kpQsVM+G0KFTq/uMx5Q1xPnfDvjYJSUo3pKp0IKC9utDmYfQBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYeMbNB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYeMbNB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3191F000FF;
	Fri,  9 Oct 2026 14:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557367;
	bh=+yWGnAnGZbb6oZtEy8UN7zSP9PhYuUvyaeRBi22Ab7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYeMbNB3ViGQ4Bjg1whFf5uTY+tjyYU8z79zEKSc7siU0aZQEK5VdU5Pq0MpJzdaY
	 kxOWn/Xbl4ouSYXlJ+r92AkBmDtsDNdC92DtXOMx6XUWES16pqke6KpE8v7qW02dnb
	 Z+F1wDPuiS1Dm2hukWJAksEa+1MqprAT6Vf9RydM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Bowler <nbowler@draconx.ca>,
	syzbot+473d7477c523b41d4046@syzkaller.appspotmail.com,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.2 344/428] USB: serial: fix ioctl hangup race
Date: Fri,  9 Oct 2026 16:11:21 +0200
Message-ID: <20261009140953.711129109@linuxfoundation.org>
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

commit ae0e61d95677efa778379853e495d748e6efbf95 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/generic.c    |   10 +++-
 drivers/usb/serial/usb-serial.c |   94 +++++++++++++++++++++++++++++++---------
 drivers/usb/serial/xr_serial.c  |   10 +---
 3 files changed, 86 insertions(+), 28 deletions(-)

--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -266,6 +266,7 @@ EXPORT_SYMBOL_GPL(usb_serial_generic_cha
 void usb_serial_generic_wait_until_sent(struct tty_struct *tty, long timeout)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
 	unsigned int bps;
 	unsigned long period;
 	unsigned long expire;
@@ -285,7 +286,14 @@ void usb_serial_generic_wait_until_sent(
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
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -400,17 +400,13 @@ static unsigned int serial_chars_in_buff
 static void serial_wait_until_sent(struct tty_struct *tty, int timeout)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct usb_serial *serial = port->serial;
 
 	dev_dbg(&port->dev, "%s\n", __func__);
 
 	if (!port->serial->type->wait_until_sent)
 		return;
 
-	mutex_lock(&serial->disc_mutex);
-	if (!serial->disconnected)
-		port->serial->type->wait_until_sent(tty, timeout);
-	mutex_unlock(&serial->disc_mutex);
+	port->serial->type->wait_until_sent(tty, timeout);
 }
 
 static void serial_throttle(struct tty_struct *tty)
@@ -438,8 +434,13 @@ static int serial_get_serial(struct tty_
 	struct usb_serial_port *port = tty->driver_data;
 	struct tty_port *tport = &port->port;
 	unsigned int close_delay, closing_wait;
+	int ret = 0;
 
 	mutex_lock(&tport->mutex);
+	if (tty_io_error(tty)) {
+		ret = -EIO;
+		goto out_unlock;
+	}
 
 	close_delay = jiffies_to_msecs(tport->close_delay) / 10;
 	closing_wait = tport->closing_wait;
@@ -452,10 +453,10 @@ static int serial_get_serial(struct tty_
 
 	if (port->serial->type->get_serial)
 		port->serial->type->get_serial(tty, ss);
-
+out_unlock:
 	mutex_unlock(&tport->mutex);
 
-	return 0;
+	return ret;
 }
 
 static int serial_set_serial(struct tty_struct *tty, struct serial_struct *ss)
@@ -471,6 +472,10 @@ static int serial_set_serial(struct tty_
 		closing_wait = msecs_to_jiffies(closing_wait * 10);
 
 	mutex_lock(&tport->mutex);
+	if (tty_io_error(tty)) {
+		ret = -EIO;
+		goto out_unlock;
+	}
 
 	if (!capable(CAP_SYS_ADMIN)) {
 		if (close_delay != tport->close_delay ||
@@ -498,6 +503,7 @@ static int serial_ioctl(struct tty_struc
 					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
 	int retval = -ENOIOCTLCMD;
 
 	dev_dbg(&port->dev, "%s - cmd 0x%04x\n", __func__, cmd);
@@ -508,8 +514,21 @@ static int serial_ioctl(struct tty_struc
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
@@ -519,25 +538,40 @@ static void serial_set_termios(struct tt
 		               const struct ktermios *old)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
 
 	dev_dbg(&port->dev, "%s\n", __func__);
 
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
+	int ret;
 
 	dev_dbg(&port->dev, "%s\n", __func__);
 
-	if (port->serial->type->break_ctl)
-		return port->serial->type->break_ctl(tty, break_state);
+	if (!port->serial->type->break_ctl)
+		return -ENOTTY;
+
+	mutex_lock(&tport->mutex);
+	if (tty_io_error(tty))
+		ret = -EIO;
+	else
+		ret = port->serial->type->break_ctl(tty, break_state);
+	mutex_unlock(&tport->mutex);
 
-	return -ENOTTY;
+	return ret;
 }
 
 static int serial_proc_show(struct seq_file *m, void *v)
@@ -578,24 +612,44 @@ static int serial_proc_show(struct seq_f
 static int serial_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
+	int ret;
 
 	dev_dbg(&port->dev, "%s\n", __func__);
 
-	if (port->serial->type->tiocmget)
-		return port->serial->type->tiocmget(tty);
-	return -ENOTTY;
+	if (!port->serial->type->tiocmget)
+		return -ENOTTY;
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
 
 	dev_dbg(&port->dev, "%s\n", __func__);
 
-	if (port->serial->type->tiocmset)
-		return port->serial->type->tiocmset(tty, set, clear);
-	return -ENOTTY;
+	if (!port->serial->type->tiocmset)
+		return -ENOTTY;
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
--- a/drivers/usb/serial/xr_serial.c
+++ b/drivers/usb/serial/xr_serial.c
@@ -850,12 +850,9 @@ static int xr_get_rs485_config(struct tt
 	struct usb_serial_port *port = tty->driver_data;
 	struct xr_data *data = usb_get_serial_port_data(port);
 
-	down_read(&tty->termios_rwsem);
-	if (copy_to_user(argp, &data->rs485, sizeof(data->rs485))) {
-		up_read(&tty->termios_rwsem);
+	/* core holds port mutex */
+	if (copy_to_user(argp, &data->rs485, sizeof(data->rs485)))
 		return -EFAULT;
-	}
-	up_read(&tty->termios_rwsem);
 
 	return 0;
 }
@@ -871,10 +868,9 @@ static int xr_set_rs485_config(struct tt
 		return -EFAULT;
 	xr_sanitize_serial_rs485(&rs485);
 
-	down_write(&tty->termios_rwsem);
+	/* core holds termios rwsem and port mutex */
 	data->rs485 = rs485;
 	xr_set_flow_mode(tty, port, NULL);
-	up_write(&tty->termios_rwsem);
 
 	if (copy_to_user(argp, &rs485, sizeof(rs485)))
 		return -EFAULT;


