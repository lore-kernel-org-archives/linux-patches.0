Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD71C17623C;
	Tue, 16 Jul 2024 16:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146278; cv=none; b=EOy6q629rl5taKhE//slGmxy4enafKHvNjBns8w40U2SjUHOvVnVaGs6Ko0uV5IhCsRwHjj425xohao9Md+ZRpgwghelRF7GKc+InpcF7lJ2m42MfYp2MygViYbJK/9Ok6GncLsEueho8b/MTJ86F/gwplKZ8IHx8llb9r4BUPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146278; c=relaxed/simple;
	bh=kws84CPu5RHY24Dyw6Q56cN5UXEG+JYha7Gl1vE9vCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkQZRAJa/f19Z/ALwjULlNvaM/1kaxXkiUcfHYK/GjG1jg6pQGVmTpVWalxoiHH+oVo1qXMXnSuSQU0Y7n4F3hZA+xJ4diGotY8FhlbeFk6s36OaFev3fIiDcjPbwtpfAN37jC4W2OoZqXZd8J3m6ap/By86I1XjT6TL4PDl8LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufSfbexN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufSfbexN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C65C4AF0D;
	Tue, 16 Jul 2024 16:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146278;
	bh=kws84CPu5RHY24Dyw6Q56cN5UXEG+JYha7Gl1vE9vCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufSfbexN5ZVO/5MCY5nWBuQTYwAigncsAH5U5Qq5C/PQtoWXQ8vrQPWB/rgZdv7Ty
	 ti+BFhuPWalwFGj3r/+m2lhr/pbYf+F/uGM3Gn2O8u8m6knsFjpdsHPrwmy01XofB4
	 aCLFW6eCvwgkTw12z4CkgfR659tzRh02wwaE+gTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Smirnov <d.smirnov@inbox.lv>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 113/144] USB: serial: mos7840: fix crash on resume
Date: Tue, 16 Jul 2024 17:33:02 +0200
Message-ID: <20240716152756.871148125@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1735,6 +1735,49 @@ static void mos7840_port_remove(struct u
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
@@ -1762,6 +1805,8 @@ static struct usb_serial_driver moschip7
 	.port_probe = mos7840_port_probe,
 	.port_remove = mos7840_port_remove,
 	.read_bulk_callback = mos7840_bulk_in_callback,
+	.suspend = mos7840_suspend,
+	.resume = mos7840_resume,
 };
 
 static struct usb_serial_driver * const serial_drivers[] = {


