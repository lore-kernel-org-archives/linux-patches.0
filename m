Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9D733ADB5;
	Fri,  9 Jan 2026 12:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963192; cv=none; b=OkzOgFfgfv6C6FlbxKgqVgLkLSf+SUjubGXHMa6qCEGlyoEebNlkfOD7sYimdXHiF2rRK7qJhIioRq3yMaMS/oGUaAzuRO3gZFXY1l5ygdoKoQm1RoSKTLV08CJg4nEUcvHAUhCf0RTMzpCjIvTwOJzG2jw4IpIfWZ6ez3Sr7Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963192; c=relaxed/simple;
	bh=Ibc/c61Bwh2No7GIL7HaS+dslWEtjydexrbPR45/VHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UAIEPewTOFzUnCii4Ja6lrsQn09+kGmPzrfI3Gb7KnTQcE86/9ykznSCSwJYUgnokrj0ir7shV7j4j0KKy8NFy54t0L5+ykBXWK+Xi/3fbxfsLzmaW2EuOOVYcWNgutMg3n4/gYLDaPMPUbhNZCOS2zxOumTE2RLUoAk09AFcNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n36Wd3pN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n36Wd3pN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CFFC19421;
	Fri,  9 Jan 2026 12:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963192;
	bh=Ibc/c61Bwh2No7GIL7HaS+dslWEtjydexrbPR45/VHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n36Wd3pNMPFuQnwv38lBUzE2hgFZQa/LqmOYgWmXU+XX3SYJVziywR0h4bLkjTRp9
	 DLUREr5vNSj8Yy4KT37ddIgsBF9S5Q75cv6pVS37ZhuuABLO2aHLTZgWzVxndTKLRt
	 bsIe2JzJ7ZdtmHnWAZs1qCrLG+CiYhCnyyQzSlf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Karsten Keil <isdn@linux-pingi.de>,
	David Lin <dtwlin@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Alex Elder <elder@kernel.org>,
	Oliver Neukum <oneukum@suse.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 597/634] tty: introduce and use tty_port_tty_vhangup() helper
Date: Fri,  9 Jan 2026 12:44:35 +0100
Message-ID: <20260109112140.091484782@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>

[ Upstream commit 2b5eac0f8c6e79bc152c8804f9f88d16717013ab ]

This code (tty_get -> vhangup -> tty_put) is repeated on few places.
Introduce a helper similar to tty_port_tty_hangup() (asynchronous) to
handle even vhangup (synchronous).

And use it on those places.

In fact, reuse the tty_port_tty_hangup()'s code and call tty_vhangup()
depending on a new bool parameter.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: David Lin <dtwlin@gmail.com>
Cc: Johan Hovold <johan@kernel.org>
Cc: Alex Elder <elder@kernel.org>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20250611100319.186924-2-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 74098cc06e75 ("xhci: dbgtty: fix device unregister: fixup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/capi/capi.c         |    8 +-------
 drivers/staging/greybus/uart.c   |    7 +------
 drivers/tty/serial/serial_core.c |    7 +------
 drivers/tty/tty_port.c           |   12 ++++++++----
 drivers/usb/class/cdc-acm.c      |    7 +------
 drivers/usb/serial/usb-serial.c  |    7 +------
 include/linux/tty_port.h         |   12 +++++++++++-
 net/bluetooth/rfcomm/tty.c       |    7 +------
 8 files changed, 25 insertions(+), 42 deletions(-)

--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -304,15 +304,9 @@ static void capincci_alloc_minor(struct
 static void capincci_free_minor(struct capincci *np)
 {
 	struct capiminor *mp = np->minorp;
-	struct tty_struct *tty;
 
 	if (mp) {
-		tty = tty_port_tty_get(&mp->port);
-		if (tty) {
-			tty_vhangup(tty);
-			tty_kref_put(tty);
-		}
-
+		tty_port_tty_vhangup(&mp->port);
 		capiminor_free(mp);
 	}
 }
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -915,7 +915,6 @@ static void gb_uart_remove(struct gbphy_
 {
 	struct gb_tty *gb_tty = gb_gbphy_get_data(gbphy_dev);
 	struct gb_connection *connection = gb_tty->connection;
-	struct tty_struct *tty;
 	int ret;
 
 	ret = gbphy_runtime_get_sync(gbphy_dev);
@@ -928,11 +927,7 @@ static void gb_uart_remove(struct gbphy_
 	wake_up_all(&gb_tty->wioctl);
 	mutex_unlock(&gb_tty->mutex);
 
-	tty = tty_port_tty_get(&gb_tty->port);
-	if (tty) {
-		tty_vhangup(tty);
-		tty_kref_put(tty);
-	}
+	tty_port_tty_vhangup(&gb_tty->port);
 
 	gb_connection_disable_rx(connection);
 	tty_unregister_device(gb_tty_driver, gb_tty->minor);
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3191,7 +3191,6 @@ void uart_remove_one_port(struct uart_dr
 	struct uart_state *state = drv->state + uport->line;
 	struct tty_port *port = &state->port;
 	struct uart_port *uart_port;
-	struct tty_struct *tty;
 
 	mutex_lock(&port_mutex);
 
@@ -3217,11 +3216,7 @@ void uart_remove_one_port(struct uart_dr
 	 */
 	tty_port_unregister_device(port, drv->tty_driver, uport->line);
 
-	tty = tty_port_tty_get(port);
-	if (tty) {
-		tty_vhangup(port->tty);
-		tty_kref_put(tty);
-	}
+	tty_port_tty_vhangup(port);
 
 	/*
 	 * If the port is used as a console, unregister it
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -416,15 +416,19 @@ EXPORT_SYMBOL(tty_port_hangup);
  * @port: tty port
  * @check_clocal: hang only ttys with %CLOCAL unset?
  */
-void tty_port_tty_hangup(struct tty_port *port, bool check_clocal)
+void __tty_port_tty_hangup(struct tty_port *port, bool check_clocal, bool async)
 {
 	struct tty_struct *tty = tty_port_tty_get(port);
 
-	if (tty && (!check_clocal || !C_CLOCAL(tty)))
-		tty_hangup(tty);
+	if (tty && (!check_clocal || !C_CLOCAL(tty))) {
+		if (async)
+			tty_hangup(tty);
+		else
+			tty_vhangup(tty);
+	}
 	tty_kref_put(tty);
 }
-EXPORT_SYMBOL_GPL(tty_port_tty_hangup);
+EXPORT_SYMBOL_GPL(__tty_port_tty_hangup);
 
 /**
  * tty_port_tty_wakeup - helper to wake up a tty
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1548,7 +1548,6 @@ err_put_port:
 static void acm_disconnect(struct usb_interface *intf)
 {
 	struct acm *acm = usb_get_intfdata(intf);
-	struct tty_struct *tty;
 	int i;
 
 	/* sibling interface is already cleaning up */
@@ -1575,11 +1574,7 @@ static void acm_disconnect(struct usb_in
 	usb_set_intfdata(acm->data, NULL);
 	mutex_unlock(&acm->mutex);
 
-	tty = tty_port_tty_get(&acm->port);
-	if (tty) {
-		tty_vhangup(tty);
-		tty_kref_put(tty);
-	}
+	tty_port_tty_vhangup(&acm->port);
 
 	cancel_delayed_work_sync(&acm->dwork);
 
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1179,7 +1179,6 @@ static void usb_serial_disconnect(struct
 	struct usb_serial *serial = usb_get_intfdata(interface);
 	struct device *dev = &interface->dev;
 	struct usb_serial_port *port;
-	struct tty_struct *tty;
 
 	/* sibling interface is cleaning up */
 	if (!serial)
@@ -1194,11 +1193,7 @@ static void usb_serial_disconnect(struct
 
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
-		tty = tty_port_tty_get(&port->port);
-		if (tty) {
-			tty_vhangup(tty);
-			tty_kref_put(tty);
-		}
+		tty_port_tty_vhangup(&port->port);
 		usb_serial_port_poison_urbs(port);
 		wake_up_interruptible(&port->port.delta_msr_wait);
 		cancel_work_sync(&port->work);
--- a/include/linux/tty_port.h
+++ b/include/linux/tty_port.h
@@ -234,7 +234,7 @@ int tty_port_carrier_raised(struct tty_p
 void tty_port_raise_dtr_rts(struct tty_port *port);
 void tty_port_lower_dtr_rts(struct tty_port *port);
 void tty_port_hangup(struct tty_port *port);
-void tty_port_tty_hangup(struct tty_port *port, bool check_clocal);
+void __tty_port_tty_hangup(struct tty_port *port, bool check_clocal, bool async);
 void tty_port_tty_wakeup(struct tty_port *port);
 int tty_port_block_til_ready(struct tty_port *port, struct tty_struct *tty,
 		struct file *filp);
@@ -253,4 +253,14 @@ static inline int tty_port_users(struct
 	return port->count + port->blocked_open;
 }
 
+static inline void tty_port_tty_hangup(struct tty_port *port, bool check_clocal)
+{
+	__tty_port_tty_hangup(port, check_clocal, true);
+}
+
+static inline void tty_port_tty_vhangup(struct tty_port *port)
+{
+	__tty_port_tty_hangup(port, false, false);
+}
+
 #endif
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -438,7 +438,6 @@ static int __rfcomm_release_dev(void __u
 {
 	struct rfcomm_dev_req req;
 	struct rfcomm_dev *dev;
-	struct tty_struct *tty;
 
 	if (copy_from_user(&req, arg, sizeof(req)))
 		return -EFAULT;
@@ -464,11 +463,7 @@ static int __rfcomm_release_dev(void __u
 		rfcomm_dlc_close(dev->dlc, 0);
 
 	/* Shut down TTY synchronously before freeing rfcomm_dev */
-	tty = tty_port_tty_get(&dev->port);
-	if (tty) {
-		tty_vhangup(tty);
-		tty_kref_put(tty);
-	}
+	tty_port_tty_vhangup(&dev->port);
 
 	if (!test_bit(RFCOMM_TTY_OWNED, &dev->status))
 		tty_port_put(&dev->port);


