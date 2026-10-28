Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212919;
	b=BVW9YM4F1AsV23IHc0s2+eba/sU43nd/pT4TzFrT91o4G8V0ZkjaVUq7tX54HeSO3vRt
	 iDWYqiFS/DnFigUWc9m+a3W0XTl4C5Uf+nR6aHvvyfwspzoBy0fkgBBX384vX/kA6mFL1
	 QLn38SV4+iGDI8h8Sn6GYRX1UPAkII3I5E/cTgt97gvmxdHKD4klqEJCn4DsLYd6cSib/
	 RMhho0Twj1N3XhncfyOI6s+P5X9fz5MyJtbc3Q5GAC/yW2eHOBDzLQpslw27ANNd26wlg
	 u+gnO+KCd59xLAQM7/u0CZoSAwJlyrxL+Rp+CWIDRFN3LoOkgcgJT2+qq1L35ould1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZlkCGfODUSFv2AIIttHp64yDkTqILDnS6joxYrpVcuE=;
	b=H0OLMN0gzZfs6h68nyrsCGr9JJpoJblGiKn0W9kwmO9UcVmWZUFirDMhHAE3PINTxIh6
	 KGP3qTNXRNb9zMt+9LolgsLlIMIuRmWMxK6k4j4W1PFc8gPCdMoLC30malzYUVDaEn0JH
	 yOU7Mylrg/iJiJTSUBwjeHm3KLqMZvDBG7F0kisA+j6oqaxkzJLel6kR9EKL6N/Vg2+u3
	 powUx932DHypdR4lSSSkaDJC9JcK9gYRPSBTbiVTFROefUEaySAhYRCKdOrLsl2kFuC4i
	 Gm8t5hNE+3WITiGqsMz69s5nSr/RsxYIksk00u4zxP28QIhgywxYJUrnPedQZvCHRVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GM554MXp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80640606A323;
	Wed, 28 Oct 2026 18:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GM554MXp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D046B1F01825;
	Wed, 28 Oct 2026 18:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212919;
	bh=ZlkCGfODUSFv2AIIttHp64yDkTqILDnS6joxYrpVcuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GM554MXpZGgnCTXj3jkTNKaykaXLqj7SjB9bU+67dpRfKbN6fJzMhw9NnYdqZ9CQn
	 PPcqWmB47sqtYRW3+hiOlHLJSJM6ahwK5Vv1FPyG2cr+9quiETT1TwJlpmT12Y24Wh
	 ss1cscif7L6ykVDjkGkrv1VB/jOCmJVuMGuAUCqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0323/1887] USB: serial: fix driver deregistration order
Date: Wed, 28 Oct 2026 17:40:19 +0100
Message-ID: <20261028170506.580493523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 
 extern struct bus_type usb_serial_bus_type;
 extern struct tty_driver *usb_serial_tty_driver;


