Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034976;
	b=hGQpdcq4GCyAEGfTJ19ou9BIHHSHpCALvSTt6FVFsT9OWMntCuh0/E4kuEPNQ0zR3gRA
	 xp9L5Q8PZOLyIkCe7G/u61Jh4vpx9lXHmmJtS2uymspsld+wRuOv/0I1n2+jgoEynQC8r
	 m3bOHNXAT49sXZcIsQrQVx9fip+7cZY6wbmdeOMP1y1M0qWNlEAmeE4CVLCLLJS41BIKl
	 bgpiPhC0w2r0G3SsBFnKLmExoQnymxyGy/3fU/KyJDfF4EcdHbIWOeoXk6VK3Av6yYFoz
	 NJAaJYOEPlyUbqx/R7jMKxq0zE2xVhN3R36KOMXD/tHyxYyBu+n4QQFVG7fXk+E47Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P/BfdhvNfJQiWrkeHzjBRGo5XOfpFgcEWjY36xn9SDY=;
	b=VhDCKT+TnekBTTGi7IpS5+PQ+x+Hp1MrM/rMbNcja53TWkqCOthhJQnM8dghRrzy6smM
	 0bGayjXgA8qceZ4rpSnoBZEawlNtoqS6mJ6W0d7j+t8gyjctUSlfsQ2PI8IgZEiVLBSA/
	 cN2GUZf6rtIKIxu79ZZo9/Qyn/uMSDe8oWCkBHA53NRtunCOTg9WeeNG1AaPc8QdSSRAK
	 zZIBMCQmHlA2+z2i1dy6pRizQeJV1kpMUKqOPhedADSCByvEVqGsxLroraAsDqd8DAiB3
	 yMbWfHigKZiySGCqtdC/1Y1sVJhKLqS+7eajzRUUYNkbMCQOorVtIPy46BjanRbt6mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RXSoyh+X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9656606A31C;
	Wed, 18 Nov 2026 20:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RXSoyh+X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCDB1F000C6;
	Wed, 18 Nov 2026 20:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034976;
	bh=P/BfdhvNfJQiWrkeHzjBRGo5XOfpFgcEWjY36xn9SDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXSoyh+X9RYDK/j5s5/ai10Ww9xsGp61z3ObEdEtAhgYkgCJackixtZS7tBkEL+E/
	 KhEcptPyMIg8qdIRSnisBNsGIdWYCr41Dx5NDseHjBgUgA4rjqPR80qkEvd32j8XsL
	 6ROnSux/3agfxwdjKXUezenmOnLGLSjaLSkSrp78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Johan Hovold <johan@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.6 0561/3318] driver core: fix parent lock use-after-free on USB disconnect
Date: Wed, 18 Nov 2026 15:19:43 +0100
Message-ID: <20261118150334.200632806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 0f554506a3fc6a21e714adf38cc3eb0ffe1bb452 upstream.

USB interfaces should be probed with their parent USB device lock held
and the USB bus therefore sets the need_parent_lock bus flag so that
driver core takes the parent lock when needed.

Driver core is only guaranteed to hold a reference to the parent device
during initial probe however and nothing prevents the device and its
parent from being deregistered and the parent potentially freed, for
example, while iterating over devices in driver_attach() or
bus_rescan_devices_helper().

Since commit 524134d42231 ("USB: don't cancel queued resets when
unbinding drivers") USB interfaces hold a reference to their parent USB
device, but a parent hub may still go away while probing a USB device
(e.g. via the drivers_probe sysfs interface). This can lead to a
use-after-free when taking the parent device lock before checking the
device->p->dead flag of the device being probed.

As only USB interfaces actually need the parent lock, make the
need_parent_lock feature even more fine grained by making it a device
type rather than bus feature. By requiring that any users also make sure
that their devices hold a reference to their parents (like USB does),
driver core can lock a device and its parent without first checking if
the device has been deregistered.

Note that this will also increase parallelism when using asynchronous
probe as USB devices connected to the same hub can now be probed in
parallel.

Fixes: bf74ad5bc417 ("[PATCH] Hold the device's parent's lock during probe and remove")
Cc: stable@vger.kernel.org	# 2.6.16: 524134d42231: USB: don't cancel queued resets when unbinding drivers
Cc: stable@vger.kernel.org	# 2.6.16
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20261014133109.1392265-2-johan@kernel.org
[ Fix mention of bus vs. device type in __device_driver_{un}lock().
  - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/bus.c         |    4 ++--
 drivers/base/dd.c          |    8 ++++----
 drivers/usb/core/driver.c  |    1 -
 drivers/usb/core/message.c |    1 +
 include/linux/device.h     |    5 +++++
 include/linux/device/bus.h |    3 ---
 6 files changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -823,10 +823,10 @@ static int __must_check bus_rescan_devic
 	int ret = 0;
 
 	if (!dev->driver) {
-		if (dev->parent && dev->bus->need_parent_lock)
+		if (dev->type && dev->type->need_parent_lock)
 			device_lock(dev->parent);
 		ret = device_attach(dev);
-		if (dev->parent && dev->bus->need_parent_lock)
+		if (dev->type && dev->type->need_parent_lock)
 			device_unlock(dev->parent);
 	}
 	return ret < 0 ? ret : 0;
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1162,7 +1162,7 @@ void device_initial_probe(struct device
 /*
  * __device_driver_lock - acquire locks needed to manipulate dev->drv
  * @dev: Device we will update driver info for
- * @parent: Parent device. Needed if the bus requires parent lock
+ * @parent: Parent device. Needed if the device type requires parent lock
  *
  * This function will take the required locks for manipulating dev->drv.
  * Normally this will just be the @dev lock, but when called for a USB
@@ -1170,7 +1170,7 @@ void device_initial_probe(struct device
  */
 static void __device_driver_lock(struct device *dev, struct device *parent)
 {
-	if (parent && dev->bus->need_parent_lock)
+	if (dev->type && dev->type->need_parent_lock && parent)
 		device_lock(parent);
 	device_lock(dev);
 }
@@ -1178,7 +1178,7 @@ static void __device_driver_lock(struct
 /*
  * __device_driver_unlock - release locks needed to manipulate dev->drv
  * @dev: Device we will update driver info for
- * @parent: Parent device. Needed if the bus requires parent lock
+ * @parent: Parent device. Needed if the device type requires parent lock
  *
  * This function will release the required locks for manipulating dev->drv.
  * Normally this will just be the @dev lock, but when called for a
@@ -1187,7 +1187,7 @@ static void __device_driver_lock(struct
 static void __device_driver_unlock(struct device *dev, struct device *parent)
 {
 	device_unlock(dev);
-	if (parent && dev->bus->need_parent_lock)
+	if (dev->type && dev->type->need_parent_lock && parent)
 		device_unlock(parent);
 }
 
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -2031,5 +2031,4 @@ const struct bus_type usb_bus_type = {
 	.name =		"usb",
 	.match =	usb_device_match,
 	.uevent =	usb_uevent,
-	.need_parent_lock =	true,
 };
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1917,6 +1917,7 @@ struct device_type usb_if_device_type =
 	.name =		"usb_interface",
 	.release =	usb_release_interface,
 	.uevent =	usb_if_uevent,
+	.need_parent_lock =	true,
 };
 
 static struct usb_interface_assoc_descriptor *find_iad(struct usb_device *dev,
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -85,6 +85,10 @@ int subsys_virtual_register(struct bus_t
  * information, equivalent to the kobj_type of a kobject.
  * If "name" is specified, the uevent will contain it in
  * the DEVTYPE variable.
+ *
+ * @need_parent_lock:	When probing or removing a device of this type,
+ *			driver core should lock the device's parent. Note that
+ *			the device must hold a reference to its parent.
  */
 struct device_type {
 	const char *name;
@@ -95,6 +99,7 @@ struct device_type {
 	void (*release)(struct device *dev);
 
 	const struct dev_pm_ops *pm;
+	bool need_parent_lock;
 };
 
 /**
--- a/include/linux/device/bus.h
+++ b/include/linux/device/bus.h
@@ -69,8 +69,6 @@ struct fwnode_handle;
  * @driver_override:	Set to true if this bus supports the driver_override
  *			mechanism, which allows userspace to force a specific
  *			driver to bind to a device via a sysfs attribute.
- * @need_parent_lock:	When probing or removing a device on this bus, the
- *			device core should lock the device's parent.
  *
  * A bus is a channel between the processor and one or more devices. For the
  * purposes of the device model, all devices are connected via a bus, even if
@@ -113,7 +111,6 @@ struct bus_type {
 	const struct iommu_ops *iommu_ops;
 
 	bool driver_override;
-	bool need_parent_lock;
 };
 
 int __must_check bus_register(const struct bus_type *bus);


