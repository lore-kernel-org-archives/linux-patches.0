Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F1246A5FD;
	Tue, 21 Jul 2026 15:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648950; cv=none; b=hYr1+u2aPW7vqGJ8YV5GQwXkS6N5aT2yRDxLGoUkg8HB7OmpVz85FXn8b3Pe0PUgrGujVcYaUZj5rKjScnsJ4LN7y/kInFLQfffbQ7uJ/DUv0TyY8+HZ2kE7Y96lJuRBtrNvXtsuCo9Stpaz/331GQWbtdTwWXRlPO8zpaq3emA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648950; c=relaxed/simple;
	bh=D/3xHzX16MMxqiwNVpEFq2uCGVT6BhqISJpCrtB62ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbzGbZlcC1j5GgtPsKNr3Ik4Lsn7W1kD/EgJMFszqb5C9mZ9NmGJMakfK0m0+m2aN/gLtcjUJ0VSuS3Z9wB1jrgI304PyMgLodP9dLIOkyvQXE/KTPi+0ojzjFYBQpRLapLQfklOZNwPW3lsawW5I21qCGBLAzmBcFgE9fWugsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RJpo+q+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RJpo+q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02BC1F000E9;
	Tue, 21 Jul 2026 15:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648949;
	bh=uZLReyvE/u8iP72j2FHgiup96z8ymO8gxR4UihXzFcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RJpo+q+4/lNfUsDlskLQr8dAq08yO484oJAfYaLvEa4PLCIsZkb+0vkAI8BVB7EK
	 Q90dCpUxVxsmNzkVtodajIQ1Ua6+IXCI0wu6tl2YmQFF/D/jZl65WQO4lqnIihWaPE
	 3RVX8bog8EdwbwD0HfXNIaxdBegvOkkbtDyz7YEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0392/2077] Drivers: hv: vmbus: use generic driver_override infrastructure
Date: Tue, 21 Jul 2026 17:01:05 +0200
Message-ID: <20260721152601.956774490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 331d8900121a1d74ecd45cd2db742ddcb5a0a565 ]

When a driver is probed through __driver_attach(), the bus' match()
callback is called without the device lock held, thus accessing the
driver_override field without a lock, which can cause a UAF.

Fix this by using the driver-core driver_override infrastructure taking
care of proper locking internally.

Note that calling match() from __driver_attach() without the device lock
held is intentional. [1]

Tested-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/driver-core/DGRGTIRHA62X.3RY09D9SOK77P@kernel.org/ [1]
Reported-by: Gui-Dong Han <hanguidong02@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220789
Fixes: d765edbb301c ("vmbus: add driver_override support")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260505133935.3772495-4-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 43 ++++++++++--------------------------------
 include/linux/hyperv.h |  5 -----
 2 files changed, 10 insertions(+), 38 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index b80a35c778ab46..23206640c61397 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -548,34 +548,6 @@ static ssize_t device_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(device);
 
-static ssize_t driver_override_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	struct hv_device *hv_dev = device_to_hv_device(dev);
-	int ret;
-
-	ret = driver_set_override(dev, &hv_dev->driver_override, buf, count);
-	if (ret)
-		return ret;
-
-	return count;
-}
-
-static ssize_t driver_override_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
-{
-	struct hv_device *hv_dev = device_to_hv_device(dev);
-	ssize_t len;
-
-	device_lock(dev);
-	len = sysfs_emit(buf, "%s\n", hv_dev->driver_override);
-	device_unlock(dev);
-
-	return len;
-}
-static DEVICE_ATTR_RW(driver_override);
-
 /* Set up per device attributes in /sys/bus/vmbus/devices/<bus device> */
 static struct attribute *vmbus_dev_attrs[] = {
 	&dev_attr_id.attr,
@@ -606,7 +578,6 @@ static struct attribute *vmbus_dev_attrs[] = {
 	&dev_attr_channel_vp_mapping.attr,
 	&dev_attr_vendor.attr,
 	&dev_attr_device.attr,
-	&dev_attr_driver_override.attr,
 	NULL,
 };
 
@@ -718,9 +689,11 @@ static const struct hv_vmbus_device_id *hv_vmbus_get_id(const struct hv_driver *
 {
 	const guid_t *guid = &dev->dev_type;
 	const struct hv_vmbus_device_id *id;
+	int ret;
 
-	/* When driver_override is set, only bind to the matching driver */
-	if (dev->driver_override && strcmp(dev->driver_override, drv->name))
+	/* If a driver override is set, only bind to the matching driver */
+	ret = device_match_driver_override(&dev->device, &drv->driver);
+	if (ret == 0)
 		return NULL;
 
 	/* Look at the dynamic ids first, before the static ones */
@@ -728,8 +701,11 @@ static const struct hv_vmbus_device_id *hv_vmbus_get_id(const struct hv_driver *
 	if (!id)
 		id = hv_vmbus_dev_match(drv->id_table, guid);
 
-	/* driver_override will always match, send a dummy id */
-	if (!id && dev->driver_override)
+	/*
+	 * If there's a matching driver override, this function should succeed,
+	 * thus return a dummy device ID if no matching ID is found.
+	 */
+	if (!id && ret > 0)
 		id = &vmbus_device_null;
 
 	return id;
@@ -1031,6 +1007,7 @@ static const struct dev_pm_ops vmbus_pm = {
 /* The one and only one */
 static const struct bus_type  hv_bus = {
 	.name =		"vmbus",
+	.driver_override =	true,
 	.match =		vmbus_match,
 	.shutdown =		vmbus_shutdown,
 	.remove =		vmbus_remove,
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 734b7ef98f4d2e..9de2c8d6037aad 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1272,11 +1272,6 @@ struct hv_device {
 	u16 device_id;
 
 	struct device device;
-	/*
-	 * Driver name to force a match.  Do not set directly, because core
-	 * frees it.  Use driver_set_override() to set or clear it.
-	 */
-	const char *driver_override;
 
 	struct vmbus_channel *channel;
 	struct kset	     *channels_kset;
-- 
2.53.0



