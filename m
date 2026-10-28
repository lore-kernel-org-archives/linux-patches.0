Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211291;
	b=0o4G4qGeQT2DmEqSZUkSC+4ZJ2WUvMe6CiIli0NaS1/a57HvLF1FAWeMK8kUrnssvufZ
	 wjMdEbPvWOeAx3+OfpdJSuplWD+w1lNgDa0BaiLUefbb6PgCrbBtAnXJvDrjkQ7v0WCOH
	 BRGe7KJuZE6mYL2yJbifBk0wdoXq+VpvBHoOO2dbxM94cHAlZEz57C8YKEZhUVPA1pXRX
	 YBsPH8rU40wUGSoItLXRLd9krLlcJTCsoyQCk6EalHKQ6Dx3uf0RdZ7myruxkTTB8KWVJ
	 VFIrgwtxgR+R9QiHzPUNF0QQxHWW9XGjv6UJDa3DNQc4WWijmC7KL/DtqKiAJrM6Txg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p8ETmxA5nDySAHIPr+gSXcO1MTn50T9g682P7WNQkC4=;
	b=ca64tr2YfbtEGwbEfxEavHysDJifiWOqno7YcaF6r1mHEtB/vEiKd0Stu4lm3jC+falG
	 IHnnb3b2movEDS5FQyGVPbZNgPmcC1zg1vVsX4sBlgaWa0skIm7XRHgwX1DyKQfaRsAsh
	 8JQ/HnI1CepdjCR/4b9n7h2/4QMAwJF7jisOKJG6c23GGLXvO30tRItsmHXnm+d0qcCHt
	 vw11cEoFEYXjLpa+nRiLboIz6o2MUF7PnS7k7nLjYas88lz2mU4iUugTH/WffVsBNKAm5
	 ak0gZAqTbNLkbS3aiQZPi4kjpgPFBqDvW3/oIkyHQDfyJP7GN7nw6VQcQNhFwuF73AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jkRWS3i3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846B760A383F;
	Wed, 28 Oct 2026 18:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jkRWS3i3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59441F01825;
	Wed, 28 Oct 2026 18:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211291;
	bh=p8ETmxA5nDySAHIPr+gSXcO1MTn50T9g682P7WNQkC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkRWS3i3m833MwyDWEEBdA6SRLM9FQjtuEYLb7efNTDK4s1ORaLRz48KG4ayoeCAV
	 l3FuLwEjiB1HZo93UGwCNl/oeHJv69B6ofhjeLe4Bl756O8TabaPysPDdRCRBaa3kN
	 sCNAtZcGBdlrurZfzYVzrqWYPr+IePUtjqV1Cw+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 327/571] USB: serial: fix driver deregistration order
Date: Wed, 28 Oct 2026 17:57:54 +0100
Message-ID: <20261028170015.763844697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 646e5b28b4fdbc1b828a2398d6ced2c1dd308a46 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/bus.c        |    4 ++++
 drivers/usb/serial/usb-serial.c |   21 ++++++++++++++++++---
 include/linux/usb/serial.h      |    1 +
 3 files changed, 23 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/bus.c
+++ b/drivers/usb/serial/bus.c
@@ -171,3 +171,7 @@ void usb_serial_bus_deregister(struct us
 	free_dynids(driver);
 }
 
+void usb_serial_bus_remove_new_id(struct usb_serial_driver *driver)
+{
+	driver_remove_file(&driver->driver, &driver_attr_new_id);
+}
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1530,7 +1530,7 @@ int usb_serial_register_drivers(struct u
 {
 	int rc;
 	struct usb_driver *udriver;
-	struct usb_serial_driver * const *sd;
+	struct usb_serial_driver * const *sd, * const *s;
 
 	/*
 	 * udriver must be registered before any of the serial drivers,
@@ -1582,9 +1582,11 @@ int usb_serial_register_drivers(struct u
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
@@ -1602,10 +1604,23 @@ EXPORT_SYMBOL_GPL(usb_serial_register_dr
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
@@ -382,6 +382,7 @@ void usb_serial_handle_dcd_change(struct
 
 int usb_serial_bus_register(struct usb_serial_driver *device);
 void usb_serial_bus_deregister(struct usb_serial_driver *device);
+void usb_serial_bus_remove_new_id(struct usb_serial_driver *driver);
 
 extern struct bus_type usb_serial_bus_type;
 extern struct tty_driver *usb_serial_tty_driver;


