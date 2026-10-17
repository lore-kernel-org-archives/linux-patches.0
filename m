Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8797F3B2FCA;
	Sat, 17 Oct 2026 17:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259516; cv=none; b=NfKgmP7ECON7KWr8QY4kleDdPUV29u6euQQNSlKy6p0qO30psZksxOWVZAEqCfAbe3SoHFaTHFsaeFyctXWmDwXqeEb80NANeHe26eByskEGv9fnPzrrFsJ1V/tB8mb3rE+r4ETWjOxmbp83qmOcAkC6YEmtSQgaAeaduNtpSd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259516; c=relaxed/simple;
	bh=60Onc37aYEIhkgUflJv2+1HcMeeFtFdqMmfFCD8Svkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qk+29Yyxg8V+yiIgJwhT81bnsaqOX7jjYDxJOWXCEZkb/PYXOrWF2xYFVv5Erv1I8FYAnSiUc8gaotWr0b+zPHLLw0rwF5EvVxqPGZUaSji05sVp/pFGNpUxxNs9fTROWdIzkDyFsmO+9YFa9GrsGoVcfNvf9dt/+8/lHKhPpqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvwHKcTE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvwHKcTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D511F000C4;
	Sat, 17 Oct 2026 17:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259515;
	bh=P4EtQyCYHAftQmKDKUKeUegrWtpfJUGFqqiZrauvhVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tvwHKcTEJ7nXoRl2C/rIlUnYg2aen8faIHYcr0o77M0e4wje1yLOygzZDA5pcD30F
	 Fq461jkxmcnsMXOh/ztH7s4pJG1IK9HU+M1jH/OhjkpS1nhw9FyI1J+eh4b46Y4xuh
	 SA28tROywTbLPD9HFoIZ7JGaVv8xcsLmcVHOX6p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1233/1674] Drivers: hv: vmbus: use generic driver_override infrastructure
Date: Sat, 17 Oct 2026 17:58:25 +0200
Message-ID: <20261017160502.789088490@linuxfoundation.org>
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
index da5c42201680b..416c1383f5afd 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -530,34 +530,6 @@ static ssize_t device_show(struct device *dev,
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
-	len = snprintf(buf, PAGE_SIZE, "%s\n", hv_dev->driver_override);
-	device_unlock(dev);
-
-	return len;
-}
-static DEVICE_ATTR_RW(driver_override);
-
 /* Set up per device attributes in /sys/bus/vmbus/devices/<bus device> */
 static struct attribute *vmbus_dev_attrs[] = {
 	&dev_attr_id.attr,
@@ -588,7 +560,6 @@ static struct attribute *vmbus_dev_attrs[] = {
 	&dev_attr_channel_vp_mapping.attr,
 	&dev_attr_vendor.attr,
 	&dev_attr_device.attr,
-	&dev_attr_driver_override.attr,
 	NULL,
 };
 
@@ -700,9 +671,11 @@ static const struct hv_vmbus_device_id *hv_vmbus_get_id(struct hv_driver *drv,
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
@@ -710,8 +683,11 @@ static const struct hv_vmbus_device_id *hv_vmbus_get_id(struct hv_driver *drv,
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
@@ -990,6 +966,7 @@ static const struct dev_pm_ops vmbus_pm = {
 /* The one and only one */
 static struct bus_type  hv_bus = {
 	.name =		"vmbus",
+	.driver_override =	true,
 	.match =		vmbus_match,
 	.shutdown =		vmbus_shutdown,
 	.remove =		vmbus_remove,
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index e4ad9760774e1..20f180a081235 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1305,11 +1305,6 @@ struct hv_device {
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



