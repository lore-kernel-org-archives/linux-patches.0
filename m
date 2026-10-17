Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D772A3B6BFE;
	Sat, 17 Oct 2026 17:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256704; cv=none; b=d5yF0KsXAAoha/8DCqQLlWGToM+rxpy+D1eCGOIqtmFvbaQvxUSbkhxHYkLJHamQwBRawMkEKoYEYVDj0JiHe9ey3WOvU2OQFAh0vcO9vVuh79G8CVdxqHuiUwIBvVwNORp/mkvqhEGbCj9byFZwVjZQsc20tyyttqZg7PC3MHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256704; c=relaxed/simple;
	bh=OTT0Zw4koJUyqpX/FpHeLYtf0RvNFdTEGIEBRS872+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOyJUsv0g8F9izZEQjLiGeg198F60IZsF/gekvI2lLi3NJ6i1IKCjidqm4j0rDAgOSRrhIXU/ozsqFgQYSNZQunp1kE//gZn9ZEGiOVi0RH5ldyODZ5mHG+WrPAS4iyF78ER1vlOEKxbi995pfvJklxuxMNdXJxJ8pW/CU5w+Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gL+9LLyY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gL+9LLyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C0B1F000C4;
	Sat, 17 Oct 2026 17:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256703;
	bh=eJF8R+KFlREI+xEE99ZOQY2RftcJ08DiE9ZMwVz3t3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gL+9LLyYfxyHzvKZJglINcSvgkBZ0wyzt5Ijy/COd/WDHOe2bgL/KuZ0D6PvjFNgz
	 Dia9hA9oFTA97DKdJenpbCCNyoZ/jcn8N0ZPyxQyc+pth83F9M3YHdMPvCrRYcCnjf
	 A80MWK/fKSanKD9kMYAky/5CwxjeGL01NuRnaobc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 0324/1674] USB: serial: fix driver deregistration order
Date: Sat, 17 Oct 2026 17:43:16 +0200
Message-ID: <20261017160439.443130535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 646e5b28b4fdbc1b828a2398d6ced2c1dd308a46 upstream.

USB serial driver modules register one driver for the USB bus and one or
more drivers for the ports on the USB serial bus.

When unloading a driver module, the USB driver must be deregistered
before the USB serial bus drivers so that I/O is stopped before
unbinding the ports to avoid use-after-free in completion handlers
accessing port data.

Note that the "new_id" attributes must first be removed to prevent new
ids from being added and triggering a probe of the USB driver after it
has been deregistered.

Fixes: 765e0ba62613 ("usb-serial: new API for driver registration")
Cc: stable@vger.kernel.org	# 3.4
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/bus.c        |    4 ++++
 drivers/usb/serial/usb-serial.c |   21 ++++++++++++++++++---
 include/linux/usb/serial.h      |    1 +
 3 files changed, 23 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/bus.c
+++ b/drivers/usb/serial/bus.c
@@ -169,3 +169,7 @@ void usb_serial_bus_deregister(struct us
 	free_dynids(driver);
 }
 
+void usb_serial_bus_remove_new_id(struct usb_serial_driver *driver)
+{
+	driver_remove_file(&driver->driver, &driver_attr_new_id);
+}
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1471,7 +1471,7 @@ int usb_serial_register_drivers(struct u
 {
 	int rc;
 	struct usb_driver *udriver;
-	struct usb_serial_driver * const *sd;
+	struct usb_serial_driver * const *sd, * const *s;
 
 	/*
 	 * udriver must be registered before any of the serial drivers,
@@ -1523,9 +1523,11 @@ int usb_serial_register_drivers(struct u
 	return 0;
 
 err_deregister_drivers:
+	for (s = serial_drivers; s < sd; ++s)
+		usb_serial_bus_remove_new_id(*s);
+	usb_deregister(udriver);
 	while (sd-- > serial_drivers)
 		usb_serial_deregister(*sd);
-	usb_deregister(udriver);
 err_free_driver:
 	kfree(udriver);
 	return rc;
@@ -1543,10 +1545,23 @@ EXPORT_SYMBOL_GPL(usb_serial_register_dr
 void usb_serial_deregister_drivers(struct usb_serial_driver *const serial_drivers[])
 {
 	struct usb_driver *udriver = (*serial_drivers)->usb_driver;
+	struct usb_serial_driver * const *sd;
+
+	/*
+	 * udriver must be deregistered before the serial drivers so that
+	 * I/O is stopped before unbinding the ports.
+	 *
+	 * Remove the new_id attributes to prevent ids from being added and
+	 * triggering a probe of udriver after it has been deregistered.
+	 */
+	for (sd = serial_drivers; *sd; ++sd)
+		usb_serial_bus_remove_new_id(*sd);
+
+	usb_deregister(udriver);
 
 	for (; *serial_drivers; ++serial_drivers)
 		usb_serial_deregister(*serial_drivers);
-	usb_deregister(udriver);
+
 	kfree(udriver);
 }
 EXPORT_SYMBOL_GPL(usb_serial_deregister_drivers);
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -377,6 +377,7 @@ void usb_serial_handle_dcd_change(struct
 
 int usb_serial_bus_register(struct usb_serial_driver *device);
 void usb_serial_bus_deregister(struct usb_serial_driver *device);
+void usb_serial_bus_remove_new_id(struct usb_serial_driver *driver);
 
 extern const struct bus_type usb_serial_bus_type;
 extern struct tty_driver *usb_serial_tty_driver;


