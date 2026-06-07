Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93162DFF04;
	Sun,  7 Jun 2026 10:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829350; cv=none; b=NTzEBLjogzz+vl4eWUVFuaFyUhlqoQyY8CaGTQ+FX8m+28kO3lXlAZgwd9CWT1AJnqKGtziu0KHhKnnBbnXLlMt4zy8/r6mDIpE9++NSfbz4cOQH0mMFCc04eCe73KeoY+FIqCn92nm4iW68N7O7lk7O8eZcHOfFe1bi74/O0Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829350; c=relaxed/simple;
	bh=3qmM8CbV78cMB7l2uydIm6jk1+2FLjyPUtFsb3rICO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l59QRiwbvviBmq54LHBAWGA2kcGKEZ3dax76httyM7+MmXQVQS+8k4hheJ+gMXhWS/DG2BOvQGlHOKjJqQA78J+p4oJoyIt07hz76z5X6f2HNR7f4D2DaLwC4WXVxqfZ8VPIjuU8XDvHhDDY/IkKOVigH37p2X8zPk/8NZS0BF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvJb+QkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvJb+QkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C88B1F00893;
	Sun,  7 Jun 2026 10:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829349;
	bh=dXf5DvzPmYx5xHBdSxCNX9LQIYtVfe7N3+2WqfxmjEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uvJb+QkNxieCWi6HXtZITgwt/WXtSZAk9GTR5mVOB2T5+AUgpaFU5EJUmdIvwVCWJ
	 UwvnRvfWNWhNVgKI84N3to3tVQ2EE0Wx/IOshquNmhnevPntv79Xu7McHD10NlNvPr
	 naQBzRgsOyjfq5LM/lGuXb0p9VL8KROHYu0L+RK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.0 271/332] USB: serial: mct_u232: fix memory corruption with small endpoint
Date: Sun,  7 Jun 2026 12:00:40 +0200
Message-ID: <20260607095737.994596907@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 915b36d701950503c4ea0f6e314b10868e59fce3 upstream.

The driver overrides the maximum transfer size for a specific device
which only accepts 16 byte packets for its 32 byte bulk-out endpoint.

Make sure to never increase the maximum transfer size to prevent slab
corruption should a malicious device report a smaller endpoint max
packet size than expected.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/mct_u232.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -378,6 +378,7 @@ static int mct_u232_port_probe(struct us
 {
 	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv;
+	u16 pid;
 
 	/* check first to simplify error handling */
 	if (!serial->port[1] || !serial->port[1]->interrupt_in_urb) {
@@ -385,6 +386,16 @@ static int mct_u232_port_probe(struct us
 		return -ENODEV;
 	}
 
+	/*
+	 * Compensate for a hardware bug: although the Sitecom U232-P25
+	 * device reports a maximum output packet size of 32 bytes,
+	 * it seems to be able to accept only 16 bytes (and that's what
+	 * SniffUSB says too...)
+	 */
+	pid = le16_to_cpu(serial->dev->descriptor.idProduct);
+	if (pid == MCT_U232_SITECOM_PID)
+		port->bulk_out_size = min(16, port->bulk_out_size);
+
 	priv = kzalloc_obj(*priv);
 	if (!priv)
 		return -ENOMEM;
@@ -410,7 +421,6 @@ static void mct_u232_port_remove(struct
 
 static int  mct_u232_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 	int retval = 0;
 	unsigned int control_state;
@@ -418,15 +428,6 @@ static int  mct_u232_open(struct tty_str
 	unsigned char last_lcr;
 	unsigned char last_msr;
 
-	/* Compensate for a hardware bug: although the Sitecom U232-P25
-	 * device reports a maximum output packet size of 32 bytes,
-	 * it seems to be able to accept only 16 bytes (and that's what
-	 * SniffUSB says too...)
-	 */
-	if (le16_to_cpu(serial->dev->descriptor.idProduct)
-						== MCT_U232_SITECOM_PID)
-		port->bulk_out_size = 16;
-
 	/* Do a defined restart: the normal serial device seems to
 	 * always turn on DTR and RTS here, so do the same. I'm not
 	 * sure if this is really necessary. But it should not harm


