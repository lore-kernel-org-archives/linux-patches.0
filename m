Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208952;
	b=vwsX4qPSBdAQZJzbNeIMW+/AGppuLdne77LnTpD31XflTqsxuAlGC1Bma6GrNmRcgr4t
	 NpmSbKUJ9XzFEabCAdaUF87Gf2p34tOPe9Gw4zsxfYLHy6ATRq+eHhVeOxI43BSzDlPv2
	 XGvpj+BEiOCvEzgVPovvx4EwRNQgiW01i3XTT1E8v09v8U6GBFOnAqDSokrRrIpNd6olj
	 T4nGRJgKa0mNlmCpswQXKO3v7Y+oGSLAKUtOu0Ai0jQWR8vhRh5R/6WuByJ7gzP0LzEPq
	 vIqheGa+gUgD6/E/DWqN0EgghgBO2PoEJcuBSHlyoKFpsDhaZGzZ1khKB/pOPrlUxRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V9hQemiiUv+0rg7nQmvmfGmvAD/A3CRUyL/kdNVJ4Mw=;
	b=mftUEZ3jOSuw+35/JEcclx2BxMo6XLICPB4iixe42AezFmyxVnhOFYX82aakj56h6uH3
	 +WHNDd8r3UdxkVa3aaJxIrj6hQzYBN7hDo8Dqs5l5bAHrAfOv1BVsZYV1lakU3czDgPjB
	 dcU7jctWbZxgTFaMsR63PnXlrzDZRraQ0+58oQKf1IAPnmO1N43dtP6LhWA5nD3QI4xt2
	 PNNszMVhQtuXFG2uHZf9Npgwjn4V4v18t3Pp8h8Sermn5y5KSvKzGrP8vskCdXhz33x5p
	 YpfjmOff9fXLWdWBzso7QLeErkkoOlDRe5e4d7+6PdmW44zDm+hpXfFiszKQKe8x3MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ofG1H1vk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E79606A323;
	Wed, 28 Oct 2026 17:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ofG1H1vk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2132C1F01829;
	Wed, 28 Oct 2026 17:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208951;
	bh=V9hQemiiUv+0rg7nQmvmfGmvAD/A3CRUyL/kdNVJ4Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofG1H1vknDe3E56e55vwvv7Waw1lsh4JGLZsVTpb9EazzlWrhB+OqWWSdYJj/Pbd7
	 DoPZCGJtDI/TbCye8+lBusycz9S/04turmKU/AZSQM1S5y7yfUgI0iIgN69XsyIKsB
	 lLJ3KUeKFdWmwMBsiQJbUDnkVJ7LqfLvDidf9dTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 300/516] USB: serial: fix driver deregistration order
Date: Wed, 28 Oct 2026 17:57:32 +0100
Message-ID: <20261028170010.597988228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/serial/bus.c        |  4 ++++
 drivers/usb/serial/usb-serial.c | 21 ++++++++++++++++++---
 include/linux/usb/serial.h      |  1 +
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/bus.c b/drivers/usb/serial/bus.c
index bbb981041c10e..de6d9f9ecd3a5 100644
--- a/drivers/usb/serial/bus.c
+++ b/drivers/usb/serial/bus.c
@@ -188,3 +188,7 @@ void usb_serial_bus_deregister(struct usb_serial_driver *driver)
 	free_dynids(driver);
 }
 
+void usb_serial_bus_remove_new_id(struct usb_serial_driver *driver)
+{
+	driver_remove_file(&driver->driver, &driver_attr_new_id);
+}
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 338fd0d5e65e1..bc3ec34f9f913 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1432,7 +1432,7 @@ int usb_serial_register_drivers(struct usb_serial_driver *const serial_drivers[]
 {
 	int rc;
 	struct usb_driver *udriver;
-	struct usb_serial_driver * const *sd;
+	struct usb_serial_driver * const *sd, * const *s;
 
 	/*
 	 * udriver must be registered before any of the serial drivers,
@@ -1484,9 +1484,11 @@ int usb_serial_register_drivers(struct usb_serial_driver *const serial_drivers[]
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
@@ -1504,10 +1506,23 @@ EXPORT_SYMBOL_GPL(usb_serial_register_drivers);
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
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 8e67eff9039fa..d98521605f8d6 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -378,6 +378,7 @@ void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
 
 int usb_serial_bus_register(struct usb_serial_driver *device);
 void usb_serial_bus_deregister(struct usb_serial_driver *device);
+void usb_serial_bus_remove_new_id(struct usb_serial_driver *driver);
 
 extern struct bus_type usb_serial_bus_type;
 extern struct tty_driver *usb_serial_tty_driver;
-- 
2.53.0



