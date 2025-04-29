Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3C322DF91;
	Tue, 29 Apr 2025 17:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948309; cv=none; b=hZtUFtYbWAlm4ZyQxAoLmJaOLP/mJo6bF8xNgjxWNn/y63CIDbeVLItLBc8Waje7mtxQ0FqXN8rYncw4sVf8VwjOFIxefxzbLKlR55fashZOwwbJPoU70z2AE9CuhCCiXZ0d0H0uxelG59xnOFRRQZMyu6uPZN2HgsoNxvRntj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948309; c=relaxed/simple;
	bh=bwoGbFe51nGGB87f6J21M6247Aa+iheDRmH/Ab1OloM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOwHiUMJWeLTAlX/49gnXHb98gkgP9drpbvF8J+5zGY3iz0bL8dHZBb5soHpknZJnafk+nI2+EVXSdxhkhARw22kF6iSBL+8fdVogLkF1Tx0B9D+SjNjj5BEUr+1yAgPXwzaKPwUQmLVRBwLzEaco8bEwZA5N23TwMnfyH4RZ1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvLsSFd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvLsSFd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B80BC4CEE3;
	Tue, 29 Apr 2025 17:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948309;
	bh=bwoGbFe51nGGB87f6J21M6247Aa+iheDRmH/Ab1OloM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvLsSFd4J6VTTj1w9NgLuBMzS3VzqIFPasMZRxzodG2vXGqakdJBt4WE6Q8cHF1Mv
	 6H4971W4mw4q6zy6xMnmibgLUWciCVP0QGT3DV/xsxGxIEA0qegrlzsSNhVtS+7b9o
	 d8UYSQLkXQib0oxo6T7y1VRNMOUk16NUFDQr/Snw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 250/280] driver core: fix potential NULL pointer dereference in dev_uevent()
Date: Tue, 29 Apr 2025 18:43:11 +0200
Message-ID: <20250429161125.348994870@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 18daa52418e7e4629ed1703b64777294209d2622 upstream.

If userspace reads "uevent" device attribute at the same time as another
threads unbinds the device from its driver, change to dev->driver from a
valid pointer to NULL may result in crash. Fix this by using READ_ONCE()
when fetching the pointer, and take bus' drivers klist lock to make sure
driver instance will not disappear while we access it.

Use WRITE_ONCE() when setting the driver pointer to ensure there is no
tearing.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20250311052417.1846985-3-dmitry.torokhov@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/base.h |   13 ++++++++++++-
 drivers/base/bus.c  |    2 +-
 drivers/base/core.c |   33 +++++++++++++++++++++++++++++++--
 3 files changed, 44 insertions(+), 4 deletions(-)

--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -73,6 +73,7 @@ static inline void subsys_put(struct sub
 		kset_put(&sp->subsys);
 }
 
+struct subsys_private *bus_to_subsys(const struct bus_type *bus);
 struct subsys_private *class_to_subsys(const struct class *class);
 
 struct driver_private {
@@ -181,8 +182,18 @@ void device_driver_detach(struct device
 
 static inline void device_set_driver(struct device *dev, const struct device_driver *drv)
 {
+	/*
+	 * Majority (all?) read accesses to dev->driver happens either
+	 * while holding device lock or in bus/driver code that is only
+	 * invoked when the device is bound to a driver and there is no
+	 * concern of the pointer being changed while it is being read.
+	 * However when reading device's uevent file we read driver pointer
+	 * without taking device lock (so we do not block there for
+	 * arbitrary amount of time). We use WRITE_ONCE() here to prevent
+	 * tearing so that READ_ONCE() can safely be used in uevent code.
+	 */
 	// FIXME - this cast should not be needed "soon"
-	dev->driver = (struct device_driver *)drv;
+	WRITE_ONCE(dev->driver, (struct device_driver *)drv);
 }
 
 int devres_release_all(struct device *dev);
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -57,7 +57,7 @@ static int __must_check bus_rescan_devic
  * NULL.  A call to subsys_put() must be done when finished with the pointer in
  * order for it to be properly freed.
  */
-static struct subsys_private *bus_to_subsys(const struct bus_type *bus)
+struct subsys_private *bus_to_subsys(const struct bus_type *bus)
 {
 	struct subsys_private *sp = NULL;
 	struct kobject *kobj;
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2624,6 +2624,35 @@ static const char *dev_uevent_name(const
 	return NULL;
 }
 
+/*
+ * Try filling "DRIVER=<name>" uevent variable for a device. Because this
+ * function may race with binding and unbinding the device from a driver,
+ * we need to be careful. Binding is generally safe, at worst we miss the
+ * fact that the device is already bound to a driver (but the driver
+ * information that is delivered through uevents is best-effort, it may
+ * become obsolete as soon as it is generated anyways). Unbinding is more
+ * risky as driver pointer is transitioning to NULL, so READ_ONCE() should
+ * be used to make sure we are dealing with the same pointer, and to
+ * ensure that driver structure is not going to disappear from under us
+ * we take bus' drivers klist lock. The assumption that only registered
+ * driver can be bound to a device, and to unregister a driver bus code
+ * will take the same lock.
+ */
+static void dev_driver_uevent(const struct device *dev, struct kobj_uevent_env *env)
+{
+	struct subsys_private *sp = bus_to_subsys(dev->bus);
+
+	if (sp) {
+		scoped_guard(spinlock, &sp->klist_drivers.k_lock) {
+			struct device_driver *drv = READ_ONCE(dev->driver);
+			if (drv)
+				add_uevent_var(env, "DRIVER=%s", drv->name);
+		}
+
+		subsys_put(sp);
+	}
+}
+
 static int dev_uevent(const struct kobject *kobj, struct kobj_uevent_env *env)
 {
 	const struct device *dev = kobj_to_dev(kobj);
@@ -2655,8 +2684,8 @@ static int dev_uevent(const struct kobje
 	if (dev->type && dev->type->name)
 		add_uevent_var(env, "DEVTYPE=%s", dev->type->name);
 
-	if (dev->driver)
-		add_uevent_var(env, "DRIVER=%s", dev->driver->name);
+	/* Add "DRIVER=%s" variable if the device is bound to a driver */
+	dev_driver_uevent(dev, env);
 
 	/* Add common DT information about the device */
 	of_device_uevent(dev, env);


