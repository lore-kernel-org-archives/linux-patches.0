Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9BC47A0DC;
	Thu, 20 Aug 2026 16:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244485; cv=none; b=oZWAGwSxqf0kvQwBtMeLYjf6Odhs7jnoazn/6WPiFcu6KoLS8HexR2YYAnMpz4a8yz3w7hngRBr6bO1mcjwZxUYdePhRtvH5Sp1MfZsKvBgXhEM3bcivoFyvEZ0mITM+eQt79YBea5+rmE7UgfIf6XCUbVkmzDrHMaflR6EdMNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244485; c=relaxed/simple;
	bh=0N6eZEEyJOhnasQP585yTZbtyD8j32Z+hDP+as40BSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpVQkjWdgv95/Vsz3jaK2f1qeTq64NDBVfUVtoMmpnFE/l8RWqi0YFB3C3SaaQnzzUb9lO2oSBIEXO06UK3kne8e16Kmgtpf+pY5W+LS54Z4+bImvFIP+pFYusxQHahfNckrfcDwm6tlu6mV0lr7bafR1NSOXDj5NFDk3SMQ7uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9hIlrhs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9hIlrhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A607E1F000E9;
	Thu, 20 Aug 2026 16:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244484;
	bh=Ol8KvC9Enq6yRr7ZlMY2UKGXJDMmrKqBOmqRfsOtdqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9hIlrhsJG/JKjrgfdBL3Kv0+ZhbTXHIt07YmuOLOQjUc0S017wbybddhPQWyn9ey
	 IydksbyBacukuEPmfynK/I4ek0skLzl2wo68s3vQlFjRXM1PKvjGeTo+6Szw93rU2y
	 gKi/E2ZgNbTlCloTC5A6ujux9cGp5qIMxor3xT9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/235] USB: serial: keyspan_pda: refactor write-room handling
Date: Thu, 20 Aug 2026 16:56:12 +0200
Message-ID: <20260820145220.567801702@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 79fe6826a5ebee2724d432a736ec04d8dca143ba ]

Add helper to retrieve the available device transfer-buffer space.

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Stable-dep-of: 42a97c0480f9 ("USB: serial: keyspan_pda: fix data loss on receive throttling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan_pda.c |  113 +++++++++++++++++----------------------
 1 file changed, 50 insertions(+), 63 deletions(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -98,6 +98,42 @@ static const struct usb_device_id id_tab
 };
 #endif
 
+static int keyspan_pda_get_write_room(struct keyspan_pda_private *priv)
+{
+	struct usb_serial_port *port = priv->port;
+	struct usb_serial *serial = priv->serial;
+	u8 *room;
+	int rc;
+
+	room = kmalloc(1, GFP_KERNEL);
+	if (!room)
+		return -ENOMEM;
+
+	rc = usb_control_msg(serial->dev,
+			     usb_rcvctrlpipe(serial->dev, 0),
+			     6, /* write_room */
+			     USB_TYPE_VENDOR | USB_RECIP_INTERFACE
+			     | USB_DIR_IN,
+			     0, /* value: 0 means "remaining room" */
+			     0, /* index */
+			     room,
+			     1,
+			     2000);
+	if (rc != 1) {
+		if (rc >= 0)
+			rc = -EIO;
+		dev_dbg(&port->dev, "roomquery failed: %d\n", rc);
+		goto out_free;
+	}
+
+	dev_dbg(&port->dev, "roomquery says %d\n", *room);
+	rc = *room;
+out_free:
+	kfree(room);
+
+	return rc;
+}
+
 static void keyspan_pda_request_unthrottle(struct work_struct *work)
 {
 	struct keyspan_pda_private *priv =
@@ -436,7 +472,6 @@ static int keyspan_pda_tiocmset(struct t
 static int keyspan_pda_write(struct tty_struct *tty,
 	struct usb_serial_port *port, const unsigned char *buf, int count)
 {
-	struct usb_serial *serial = port->serial;
 	int request_unthrottle = 0;
 	int rc = 0;
 	struct keyspan_pda_private *priv;
@@ -479,38 +514,11 @@ static int keyspan_pda_write(struct tty_
 	   device how much room it really has.  This is done only on
 	   scheduler time, since usb_control_msg() sleeps. */
 	if (count > priv->tx_room && !in_interrupt()) {
-		u8 *room;
-
-		room = kmalloc(1, GFP_KERNEL);
-		if (!room) {
-			rc = -ENOMEM;
+		rc = keyspan_pda_get_write_room(priv);
+		if (rc < 0)
 			goto exit;
-		}
 
-		rc = usb_control_msg(serial->dev,
-				     usb_rcvctrlpipe(serial->dev, 0),
-				     6, /* write_room */
-				     USB_TYPE_VENDOR | USB_RECIP_INTERFACE
-				     | USB_DIR_IN,
-				     0, /* value: 0 means "remaining room" */
-				     0, /* index */
-				     room,
-				     1,
-				     2000);
-		if (rc > 0) {
-			dev_dbg(&port->dev, "roomquery says %d\n", *room);
-			priv->tx_room = *room;
-		}
-		kfree(room);
-		if (rc < 0) {
-			dev_dbg(&port->dev, "roomquery failed\n");
-			goto exit;
-		}
-		if (rc == 0) {
-			dev_dbg(&port->dev, "roomquery returned 0 bytes\n");
-			rc = -EIO; /* device didn't return any data */
-			goto exit;
-		}
+		priv->tx_room = rc;
 	}
 
 	if (count >= priv->tx_room) {
@@ -612,48 +620,27 @@ static void keyspan_pda_dtr_rts(struct u
 static int keyspan_pda_open(struct tty_struct *tty,
 					struct usb_serial_port *port)
 {
-	struct usb_serial *serial = port->serial;
-	u8 *room;
-	int rc = 0;
-	struct keyspan_pda_private *priv;
+	struct keyspan_pda_private *priv = usb_get_serial_port_data(port);
+	int rc;
 
 	/* find out how much room is in the Tx ring */
-	room = kmalloc(1, GFP_KERNEL);
-	if (!room)
-		return -ENOMEM;
+	rc = keyspan_pda_get_write_room(priv);
+	if (rc < 0)
+		return rc;
 
-	rc = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-			     6, /* write_room */
-			     USB_TYPE_VENDOR | USB_RECIP_INTERFACE
-			     | USB_DIR_IN,
-			     0, /* value */
-			     0, /* index */
-			     room,
-			     1,
-			     2000);
-	if (rc < 0) {
-		dev_dbg(&port->dev, "%s - roomquery failed\n", __func__);
-		goto error;
-	}
-	if (rc == 0) {
-		dev_dbg(&port->dev, "%s - roomquery returned 0 bytes\n", __func__);
-		rc = -EIO;
-		goto error;
-	}
-	priv = usb_get_serial_port_data(port);
-	priv->tx_room = *room;
-	priv->tx_throttled = *room ? 0 : 1;
+	priv->tx_room = rc;
+	priv->tx_throttled = rc ? 0 : 1;
 
 	/*Start reading from the device*/
 	rc = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
 	if (rc) {
 		dev_dbg(&port->dev, "%s - usb_submit_urb(read int) failed\n", __func__);
-		goto error;
+		return rc;
 	}
-error:
-	kfree(room);
-	return rc;
+
+	return 0;
 }
+
 static void keyspan_pda_close(struct usb_serial_port *port)
 {
 	struct keyspan_pda_private *priv = usb_get_serial_port_data(port);


