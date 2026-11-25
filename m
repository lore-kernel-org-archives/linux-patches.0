Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626128;
	b=c6jRStmDc5grPX6YyBLgnm3Wlj/shh/gZ9DtGXOR5nnt+6JSHdcu7eHHaeHkcBRm7jvE
	 GghlW/ewRxcYsnIO+PYtKbdqaNMk34vCbLTqB4l7m1K5BTwU9CgBAqueOOWvkHZlyQlLb
	 vhobTqSYQNzAqXMhqXh3NQAHUXyvAAI5LOCe0fTtJJVECV3NPtB4qV/DGujTaNCJljqC+
	 8JfZw7xl/gJk1MySwLZYoqMyxa1swLlo+4BZUTO3uaspGpB25mpMi/JForx54ROt1BZ4s
	 VT0Uv/regA3iZK1BHKPvOhihluOBEx619/AuVvavufAEtkFjYt+U5y1Of9/64FAq/+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wjixxwhy6MurZO6QWJPkRhcrfLbK1gRqxY0wOpSaicM=;
	b=pl2HSyezcz0IUeOQ0bHWRFHoc0qgMlnbYowKmvO0qA6bbHC9LvmLXhMI24+Sw0FYgICf
	 7yI9ovF3hKLwjNIz0cEqloW0GZrSsY8w2LltwU5NF0i0BBRH/8hlh0IIOqsuSl8u6T1GO
	 UJnvrV6uAFGVFIJhmcjZlFpGtHFyz4Mr/f7unYvWutgDq24X6w3vKQ93IpH9mUjBD1GfG
	 PBnUzHz/BvELkUrq7i3Whg3b6iY9jUxerA9XDt3EYGH9h1L0bhoONdQtdw5p1Bi7TFi7Z
	 zpCzZtX2bm8hl/WN7+gVwjaxHi6QU7AgO6jQ3dE9/spc89PdPhOzUHCexV0j0PMhX/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UNSvyMnw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60AD606A31E;
	Wed, 25 Nov 2026 17:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UNSvyMnw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367BE1F000C6;
	Wed, 25 Nov 2026 17:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626127;
	bh=Wjixxwhy6MurZO6QWJPkRhcrfLbK1gRqxY0wOpSaicM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNSvyMnwMyO34OvlvlIEcp9q+o6W0dqiuruPThYjfemFCrO+mXdnlhWIRVrJnHMzD
	 aegyM/4rbQUhbF7zCJS2zgBeX454tM4hAHkeyd+E4jIGiPVgMy6aMh6JRGBNjsvlvA
	 DHW5UvHAkD65bbtkd7Xo+0nmgqJ9LFPpv/bNK5Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.12 740/816] USB: serial: oti6858: fix the teardown order in close
Date: Wed, 25 Nov 2026 15:38:08 +0100
Message-ID: <20261125143906.308575903@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit f184ae84a5d19554d980a918a9c8baaef87ac301 upstream.

The driver passes a baton around: the completion handler of the
interrupt urb either resubmits the urb, submits the read urb or
schedules one of the two delayed works, and the works and the bulk
completion handlers submit the interrupt urb again.

oti6858_close() cancels the works first and kills the urbs afterwards.
An interrupt urb that completes in between schedules a work again:

	oti6858_close()
	  cancel_delayed_work_sync(setup)
	  cancel_delayed_work_sync(write)
				oti6858_read_int_callback()
				  schedule_delayed_work(setup)
	  usb_kill_urb(interrupt_in_urb)	/* not in flight */
				setup_line()
				  usb_submit_urb(interrupt_in_urb)

The port is now closed with the baton still going round. The next open
fails because the interrupt urb is already submitted, and if the device
is unplugged, oti6858_port_remove() frees the private data while a work
may be pending or running.

Poison the interrupt urb first: that waits for the handler and makes all
further submissions fail, so nothing schedules the works any more. Then
cancel the works, after which only the bulk urbs are left, kill those,
and make the interrupt urb usable again for the next open. Don't print
an error for the submissions that fail with -EPERM in this window, as
oti6858_read_bulk_callback() already does.

Fixes: 49cdee0ed0fc ("USB: oti6858 usb-serial driver (in Nokia CA-42 cable)")
Cc: stable <stable@kernel.org>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/oti6858.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -251,7 +251,7 @@ static void setup_line(struct work_struc
 
 	dev_dbg(&port->dev, "%s(): submitting interrupt urb\n", __func__);
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
-	if (result != 0) {
+	if (result != 0 && result != -EPERM) {
 		dev_err(&port->dev, "%s(): usb_submit_urb() failed with error %d\n",
 			__func__, result);
 	}
@@ -303,7 +303,7 @@ static void send_data(struct work_struct
 
 		dev_dbg(&port->dev, "%s(): submitting interrupt urb\n", __func__);
 		result = usb_submit_urb(port->interrupt_in_urb, GFP_NOIO);
-		if (result != 0) {
+		if (result != 0 && result != -EPERM) {
 			dev_err(&port->dev, "%s(): usb_submit_urb() failed with error %d\n",
 				__func__, result);
 		}
@@ -564,6 +564,13 @@ static void oti6858_close(struct usb_ser
 
 	dev_dbg(&port->dev, "%s(): after buf_clear()\n", __func__);
 
+	/*
+	 * The interrupt urb schedules the works, and the works and the bulk
+	 * urbs resubmit the interrupt urb: keep it from being submitted until
+	 * all of them are gone.
+	 */
+	usb_poison_urb(port->interrupt_in_urb);
+
 	/* cancel scheduled setup */
 	cancel_delayed_work_sync(&priv->delayed_setup_work);
 	cancel_delayed_work_sync(&priv->delayed_write_work);
@@ -572,7 +579,8 @@ static void oti6858_close(struct usb_ser
 	dev_dbg(&port->dev, "%s(): shutting down urbs\n", __func__);
 	usb_kill_urb(port->write_urb);
 	usb_kill_urb(port->read_urb);
-	usb_kill_urb(port->interrupt_in_urb);
+
+	usb_unpoison_urb(port->interrupt_in_urb);
 }
 
 static int oti6858_tiocmset(struct tty_struct *tty,
@@ -829,7 +837,7 @@ static void oti6858_write_bulk_callback(
 	/* schedule the interrupt urb if we are still open */
 	dev_dbg(&port->dev, "%s(): submitting interrupt urb\n", __func__);
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_ATOMIC);
-	if (result != 0) {
+	if (result != 0 && result != -EPERM) {
 		dev_err(&port->dev, "%s(): failed submitting int urb,"
 					" error %d\n", __func__, result);
 	}


