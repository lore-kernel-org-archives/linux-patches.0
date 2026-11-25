Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623571;
	b=DuDkHh3JYi3H0smfQQRujJxzZrU+oLJm7vpjN4cYQRteHmzu+tCq81I5ucvZ38bhcyHD
	 cg4hspNgRW6v/XZgoZov0D8Ba7zAdyyTPwaNU/m4uNJOSmvJDpKD0m8vsk5m3q498auzC
	 E8X5/HWQfQKGV619UXTTva1Ll20HiGYDnSV6/WKlemowDDmiksBrXFm1JyDwTY4H17Vp4
	 qS8ChkoQRyqT/sFLo8pFwHNH3tz5ayD6+q3B7qtxlq28OINA9/r0Db5h/hWPFZvfaElEi
	 6Qzr0dTYsFaBLOB+pYSEkGLWpEWCk308vXJ/w3DRAIHvdgWZK/cUOzSoY1GUiXQkuMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CLQP/jOeLmwxD5i6pHaOiINjVqnliwPFv2VwmXRnQrY=;
	b=eB8W2B4UqhCOVycGx6cRIhXky+ifWzqei5BkEF3s/EdR9RNLSOjpNbufvKK6XI2Ic5CA
	 naxmQzCqaKbiOX6ZfPIglCkxo+IccyXYTaaOUG6dWiQ3T3ef5yVzgLYJ+4kQ3hnze1gOs
	 Enq172w56gaZfo13y7vVCP0UEEPidkO5Zy0N8JdzrmFhNt4TGydS2Zh8SalHhlsAkFz0t
	 fzELvE5uQ2vbxTmrOPJtyp4KmDLq6rZbcFw0r4orjKANDAvXn+symGTvIl1w1h1kjw0tr
	 vwb6qIDLEvf5UFedTjtfFirnY4exYeoQb2rF+LLSsLxdyCv0QsAbTS85b0hu5X8NtLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G90343Di;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF30606A31E;
	Wed, 25 Nov 2026 16:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G90343Di
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF9E1F000C6;
	Wed, 25 Nov 2026 16:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623571;
	bh=CLQP/jOeLmwxD5i6pHaOiINjVqnliwPFv2VwmXRnQrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G90343DiTMdl57GjrHyRO6p8j4wC0PK4VKkDRjah66yceuXNBW7/9W6RaNccmjkmW
	 QdWza4RiC9ObkBpE+GwGhs3feIVr8dHcyRV9HXQXbhkNc3q+TIlnzumQTRZbz8yBw5
	 b9MBs4G/ntJD6IFVXWkh4I8RBn6PXj1ewlEmgrpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.18 903/990] USB: serial: oti6858: fix the teardown order in close
Date: Wed, 25 Nov 2026 15:37:50 +0100
Message-ID: <20261125143843.160944817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


