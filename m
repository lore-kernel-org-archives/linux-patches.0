Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044729;
	b=CRLBMETo+vOzMAYrTJap+IhmMmg7f50kLQB5a3GKlnA7FymX873KjTnWvsLg7BA8Jyge
	 mOyMnDbV+gSXp2agzNIGvm48O0m6LeFc/7kRAFqFpPjDSmoYFlHeq/DAzXzU+JTsuzKx7
	 pODW8vOy9TVoly/JXtrBHbDEfG/A/wwqE50betS5mNyOqCz6ZKtH+QGVNmKeCQs6+PyuH
	 l09g6JMXUDdCkC4fZtgjpO558GiV3rxNj+01q0hvk9CQzlAEmts6OyTFk2OHfJ/t7B9DM
	 xaSq5whiII2DWcIyw+4Rs3OpG8YTmKqGRtxHMV+RejIxpXMNWOWj/sFi45ardtP4BwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XjUMoctp3EYgSNvWDgYTMV9PfFeLAaYQaviit237zD0=;
	b=P1qEn2dThy2CaIIQXRZ+/JHm2J461l75riUnmmPOt4cxR92BYykilupJJp9Byn84qDKN
	 6IZSBsziXHf/OO04wKla4+cDMXdszFUfsQ1jXEgFIglS2DTCqNzSAtKZRHTaiXsYmt3bt
	 hnTF97kAt3HQm46Dfg5Old8u4FIvNRv4YXCLsnPFdQzvbl8ktSIBzwXvlPqDZQ7QdBclA
	 kEdnnbVVH5p8ommBoBznV5nBmbZBgqDhKuCpQLxyIe+7K1v1VDc4VBvgrL/Jeibd7Bbfo
	 1X+DrmWK9t9UaeYVT2yuuZy6NSKSrDwr+6uZIODO++rp91u4VK06wDXvub/VEBHEGmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciqp23PT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D62D606A325;
	Wed, 18 Nov 2026 23:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciqp23PT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C1E1F000C4;
	Wed, 18 Nov 2026 23:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044729;
	bh=XjUMoctp3EYgSNvWDgYTMV9PfFeLAaYQaviit237zD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ciqp23PTmnMFnRdhUmQFySmlc1zrhVA/J447Syri/RW+kmsoO38q49aQ2UAwIz/qc
	 TS6BP67AkQaf37SMuGs0A+qYsEMG9QPGOptFDLarwNg6pdXNIfr8s2kPD0TAoFGoDF
	 XTzEHleTCnOjjm/c9eWPaw0aeI7KXfHCG/tBMGag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Johan Hovold <johan@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0669/2857] driver core: fix parent lock use-after-free on USB disconnect
Date: Wed, 18 Nov 2026 15:28:23 +0100
Message-ID: <20261118150225.647858627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

[ Upstream commit 0f554506a3fc6a21e714adf38cc3eb0ffe1bb452 ]

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
[ sashal: adjusted struct bus_type context around need_parent_lock to preserve existing fields ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/bus.c         | 4 ++--
 drivers/base/dd.c          | 8 ++++----
 drivers/usb/core/driver.c  | 1 -
 drivers/usb/core/message.c | 1 +
 include/linux/device.h     | 5 +++++
 include/linux/device/bus.h | 3 ---
 6 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 941532ddfdc68..b2d4c08848a8c 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -689,10 +689,10 @@ static int __must_check bus_rescan_devices_helper(struct device *dev,
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
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 16f9d895ee24e..71653ce21efab 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1086,7 +1086,7 @@ void device_initial_probe(struct device *dev)
 /*
  * __device_driver_lock - acquire locks needed to manipulate dev->drv
  * @dev: Device we will update driver info for
- * @parent: Parent device. Needed if the bus requires parent lock
+ * @parent: Parent device. Needed if the device type requires parent lock
  *
  * This function will take the required locks for manipulating dev->drv.
  * Normally this will just be the @dev lock, but when called for a USB
@@ -1094,7 +1094,7 @@ void device_initial_probe(struct device *dev)
  */
 static void __device_driver_lock(struct device *dev, struct device *parent)
 {
-	if (parent && dev->bus->need_parent_lock)
+	if (dev->type && dev->type->need_parent_lock && parent)
 		device_lock(parent);
 	device_lock(dev);
 }
@@ -1102,7 +1102,7 @@ static void __device_driver_lock(struct device *dev, struct device *parent)
 /*
  * __device_driver_unlock - release locks needed to manipulate dev->drv
  * @dev: Device we will update driver info for
- * @parent: Parent device. Needed if the bus requires parent lock
+ * @parent: Parent device. Needed if the device type requires parent lock
  *
  * This function will release the required locks for manipulating dev->drv.
  * Normally this will just be the @dev lock, but when called for a
@@ -1111,7 +1111,7 @@ static void __device_driver_lock(struct device *dev, struct device *parent)
 static void __device_driver_unlock(struct device *dev, struct device *parent)
 {
 	device_unlock(dev);
-	if (parent && dev->bus->need_parent_lock)
+	if (dev->type && dev->type->need_parent_lock && parent)
 		device_unlock(parent);
 }
 
diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 145ebfb1325af..f911e362b1811 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -2031,5 +2031,4 @@ struct bus_type usb_bus_type = {
 	.name =		"usb",
 	.match =	usb_device_match,
 	.uevent =	usb_uevent,
-	.need_parent_lock =	true,
 };
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 58046946411f1..037f90089eda4 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1915,6 +1915,7 @@ struct device_type usb_if_device_type = {
 	.name =		"usb_interface",
 	.release =	usb_release_interface,
 	.uevent =	usb_if_uevent,
+	.need_parent_lock =	true,
 };
 
 static struct usb_interface_assoc_descriptor *find_iad(struct usb_device *dev,
diff --git a/include/linux/device.h b/include/linux/device.h
index 0e83be1bccc44..b35162a3ab8b3 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -85,6 +85,10 @@ int subsys_virtual_register(struct bus_type *subsys,
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
 
 /* interface for exporting device attributes */
diff --git a/include/linux/device/bus.h b/include/linux/device/bus.h
index d8b29ccd07e56..05667a8e340ad 100644
--- a/include/linux/device/bus.h
+++ b/include/linux/device/bus.h
@@ -69,8 +69,6 @@ struct fwnode_handle;
  * @p:		The private data of the driver core, only the driver core can
  *		touch this.
  * @lock_key:	Lock class key for use by the lock validator
- * @need_parent_lock:	When probing or removing a device on this bus, the
- *			device core should lock the device's parent.
  *
  * A bus is a channel between the processor and one or more devices. For the
  * purposes of the device model, all devices are connected via a bus, even if
@@ -114,7 +112,6 @@ struct bus_type {
 	struct subsys_private *p;
 	struct lock_class_key lock_key;
 
-	bool need_parent_lock;
 };
 
 extern int __must_check bus_register(struct bus_type *bus);
-- 
2.53.0



