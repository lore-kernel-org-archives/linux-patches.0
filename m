Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182C61DDCE;
	Tue, 16 Jul 2024 16:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145723; cv=none; b=BjYiYSUY87EkX5y3nVFI3UzclS1pYeJ7PDhk+4AXlb6XhKI8FnZO18n2A9ooyLM4F5BZleOJkHQzwE4eWh43a3ltgvMacOxVlqJlkl+rf5wy94zvcF7r+N6vztWCQVSx8kdzST7a8vyhFgj8c75h1TIf/Jp6mYyxI7BMwUreaKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145723; c=relaxed/simple;
	bh=/nHaGSlSXQEzquDxW+a2xbIJf6l9+HGvfBhA/33GfJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibhFTaa+CnvFavQg+T/PgSsB1MIYgNfRnOW85W2veIoX8ow1D134/8M0CBDscWNkZnvKbuTq452FFLtOwt9ME/2a9BgQx8/yDwTtCt/Kx8oAC8RXNV/ep2kWGxc+zDUpq0+PTeIwV7vd37YKgBM1MdaSNVJ25wRmYSdEBl13K/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVW/U4A/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVW/U4A/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864E3C116B1;
	Tue, 16 Jul 2024 16:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145722;
	bh=/nHaGSlSXQEzquDxW+a2xbIJf6l9+HGvfBhA/33GfJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVW/U4A/Px2ISSQ6YMTjEjhJmvCTnPTpSC2BWwmDiqbm1hDbO0v7AheNCd7pvhRT4
	 nTZ1HEggiPQ60f7dbOM6BN7LtMXdaBcbIwhFk6kmOez+nb47/mcrNGhYgSn+nfR+KY
	 0FiiOII+px0arJb+X3hP8ysn+i0BlDSENXSB4Ej0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Smirnov <d.smirnov@inbox.lv>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 063/121] USB: serial: mos7840: fix crash on resume
Date: Tue, 16 Jul 2024 17:32:05 +0200
Message-ID: <20240716152753.752117676@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Smirnov <d.smirnov@inbox.lv>

commit c15a688e49987385baa8804bf65d570e362f8576 upstream.

Since commit c49cfa917025 ("USB: serial: use generic method if no
alternative is provided in usb serial layer"), USB serial core calls the
generic resume implementation when the driver has not provided one.

This can trigger a crash on resume with mos7840 since support for
multiple read URBs was added back in 2011. Specifically, both port read
URBs are now submitted on resume for open ports, but the context pointer
of the second URB is left set to the core rather than mos7840 port
structure.

Fix this by implementing dedicated suspend and resume functions for
mos7840.

Tested with Delock 87414 USB 2.0 to 4x serial adapter.

Signed-off-by: Dmitry Smirnov <d.smirnov@inbox.lv>
[ johan: analyse crash and rewrite commit message; set busy flag on
         resume; drop bulk-in check; drop unnecessary usb_kill_urb() ]
Fixes: d83b405383c9 ("USB: serial: add support for multiple read urbs")
Cc: stable@vger.kernel.org	# 3.3
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/mos7840.c |   45 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1737,6 +1737,49 @@ static void mos7840_port_remove(struct u
 	kfree(mos7840_port);
 }
 
+static int mos7840_suspend(struct usb_serial *serial, pm_message_t message)
+{
+	struct moschip_port *mos7840_port;
+	struct usb_serial_port *port;
+	int i;
+
+	for (i = 0; i < serial->num_ports; ++i) {
+		port = serial->port[i];
+		if (!tty_port_initialized(&port->port))
+			continue;
+
+		mos7840_port = usb_get_serial_port_data(port);
+
+		usb_kill_urb(mos7840_port->read_urb);
+		mos7840_port->read_urb_busy = false;
+	}
+
+	return 0;
+}
+
+static int mos7840_resume(struct usb_serial *serial)
+{
+	struct moschip_port *mos7840_port;
+	struct usb_serial_port *port;
+	int res;
+	int i;
+
+	for (i = 0; i < serial->num_ports; ++i) {
+		port = serial->port[i];
+		if (!tty_port_initialized(&port->port))
+			continue;
+
+		mos7840_port = usb_get_serial_port_data(port);
+
+		mos7840_port->read_urb_busy = true;
+		res = usb_submit_urb(mos7840_port->read_urb, GFP_NOIO);
+		if (res)
+			mos7840_port->read_urb_busy = false;
+	}
+
+	return 0;
+}
+
 static struct usb_serial_driver moschip7840_4port_device = {
 	.driver = {
 		   .owner = THIS_MODULE,
@@ -1764,6 +1807,8 @@ static struct usb_serial_driver moschip7
 	.port_probe = mos7840_port_probe,
 	.port_remove = mos7840_port_remove,
 	.read_bulk_callback = mos7840_bulk_in_callback,
+	.suspend = mos7840_suspend,
+	.resume = mos7840_resume,
 };
 
 static struct usb_serial_driver * const serial_drivers[] = {


