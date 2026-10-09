Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D094E4C5E;
	Fri,  9 Oct 2026 14:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557359; cv=none; b=SlSRPC5xohP2VPc02lh/fhugJvqqo/IpyIQdQswbBu9zuZSEOF3gRUzLHtuT8UCwxz60ANcjLUW/ZfZ/ZiTThj2ZanjMzX+QB7lbKOUTshl2z/Gt+GWRYH8YrPoJ0ku7HbcZIPj+5DX2eZqjY5HsyAHtp7SdQ0/koA4/ij5rpXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557359; c=relaxed/simple;
	bh=H0bTe+PGBeK/Tc5u+t57beG12waOjP1uujlX6rtrCbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/EWDcHEtBkZlMB/OS6hwNDmPc814ZEkbZzhJhlqb40J9vpQgS8JCF9orfoj+2ZDUKE6Q1eZ2HqV/I617a8UQp9MieYGBc0qkGVMEgBYq/vj6YdhuhXZVMuaFhOQvhl6fLQJoJVXQTKhQGH8STd6DYuK4ScoJEIRH4MRMoLSfZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxPRrkGV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxPRrkGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E007C1F000FF;
	Fri,  9 Oct 2026 14:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557358;
	bh=9XWw8qEp0zOuqq1BXtKRnkGk/b/lFWwgt9g9zBTlUcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qxPRrkGVq3Z+GN6Dd7UEaDFBwAG4cmqU1Xc/uiYxlMcNRhHokWOo7cm5GP3G13Ovj
	 628wGRLg0RCtlz4JwXtAoGJ8fT/YiY5BGnq+BYUAHv9B7s0tz4wYkwyeYJbfRE2YyU
	 /NpN+DLj7hs5N0DudjNRetVcxrva8vKyPla8Kq5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.2 343/428] USB: serial: fix driver deregistration order
Date: Fri,  9 Oct 2026 16:11:20 +0200
Message-ID: <20261009140953.688976235@linuxfoundation.org>
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
@@ -1470,7 +1470,7 @@ int __usb_serial_register_drivers(struct
 {
 	int rc;
 	struct usb_driver *udriver;
-	struct usb_serial_driver * const *sd;
+	struct usb_serial_driver * const *sd, * const *s;
 
 	/*
 	 * udriver must be registered before any of the serial drivers,
@@ -1523,9 +1523,11 @@ int __usb_serial_register_drivers(struct
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
@@ -1543,10 +1545,23 @@ EXPORT_SYMBOL_GPL(__usb_serial_register_
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
@@ -381,6 +381,7 @@ void usb_serial_handle_dcd_change(struct
 
 int usb_serial_bus_register(struct usb_serial_driver *device);
 void usb_serial_bus_deregister(struct usb_serial_driver *device);
+void usb_serial_bus_remove_new_id(struct usb_serial_driver *driver);
 
 extern const struct bus_type usb_serial_bus_type;
 extern struct tty_driver *usb_serial_tty_driver;


