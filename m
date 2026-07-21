Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B462C46D55F;
	Tue, 21 Jul 2026 15:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648947; cv=none; b=I2NGGGOjmwUfgEtAoct0zp7U5doq3qJYJlsW62V0QduIxD2DUkOEg0IMw/u2hz5jobfYMhmvyicGT3XnXcJGdOYtLxABXhVyaK260XmGo2YZZE8IiquY5BggUqxUspp+SlqyP0faivzsAXGOSED/M+rXAy7rn6gBTdM46Jjo66Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648947; c=relaxed/simple;
	bh=w7GzBlG7QeXQHK0vmxFJA5LJQIukCu7Lbnji5tUWDf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUbXN9gUvQwai2lPcXuRyJ2uTkuchdKPSMg4H1PLfQwE15N7xHIc/LTDU6UIk5MxpX6wOivAAdx7JE6quxIi69sa3kqyu4QRs0oVkNbVNB3wrW1kmW+mi3sU4Ha1ytdSYBA0Lcr5a30it7QYrey2IAwKSQkjEt4HcqpQfGVR7o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EsiRolz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EsiRolz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2797E1F000E9;
	Tue, 21 Jul 2026 15:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648946;
	bh=WDFYmEDumy+BsbriOFObnHrkNHYCH9Rq02/Ab/pYiWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0EsiRolzYypH2OytN9tSfrbnT5E90943vleUCaKB51MpkBQk1smJsQIOmXaiChZei
	 yQ5l7mbs3aX2U2UUybeeaXPQG0967w1F6RdukINmAQl94aKmCzoODkXEKBZ8rneoke
	 YtYyXvlxXK3oD2G57TbZ/4JHvnAMhmbDjiRXmUPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0391/2077] cdx: use generic driver_override infrastructure
Date: Tue, 21 Jul 2026 17:01:04 +0200
Message-ID: <20260721152601.928435092@linuxfoundation.org>
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

[ Upstream commit d541aa1897f67f4f14c805785bff894bcc61dca1 ]

When a driver is probed through __driver_attach(), the bus' match()
callback is called without the device lock held, thus accessing the
driver_override field without a lock, which can cause a UAF.

Fix this by using the driver-core driver_override infrastructure taking
care of proper locking internally.

Note that calling match() from __driver_attach() without the device lock
held is intentional. [1]

Link: https://lore.kernel.org/driver-core/DGRGTIRHA62X.3RY09D9SOK77P@kernel.org/ [1]
Reported-by: Gui-Dong Han <hanguidong02@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220789
Fixes: 2959ab247061 ("cdx: add the cdx bus driver")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260505133935.3772495-3-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cdx/cdx.c           | 40 +++++--------------------------------
 include/linux/cdx/cdx_bus.h |  4 ----
 2 files changed, 5 insertions(+), 39 deletions(-)

diff --git a/drivers/cdx/cdx.c b/drivers/cdx/cdx.c
index 9196dc50a48db4..d3d23024726215 100644
--- a/drivers/cdx/cdx.c
+++ b/drivers/cdx/cdx.c
@@ -156,8 +156,6 @@ static int cdx_unregister_device(struct device *dev,
 	} else {
 		cdx_destroy_res_attr(cdx_dev, MAX_CDX_DEV_RESOURCES);
 		debugfs_remove_recursive(cdx_dev->debugfs_dir);
-		kfree(cdx_dev->driver_override);
-		cdx_dev->driver_override = NULL;
 	}
 
 	/*
@@ -268,6 +266,7 @@ static int cdx_bus_match(struct device *dev, const struct device_driver *drv)
 	const struct cdx_driver *cdx_drv = to_cdx_driver(drv);
 	const struct cdx_device_id *found_id = NULL;
 	const struct cdx_device_id *ids;
+	int ret;
 
 	if (cdx_dev->is_bus)
 		return false;
@@ -275,7 +274,8 @@ static int cdx_bus_match(struct device *dev, const struct device_driver *drv)
 	ids = cdx_drv->match_id_table;
 
 	/* When driver_override is set, only bind to the matching driver */
-	if (cdx_dev->driver_override && strcmp(cdx_dev->driver_override, drv->name))
+	ret = device_match_driver_override(dev, drv);
+	if (ret == 0)
 		return false;
 
 	found_id = cdx_match_id(ids, cdx_dev);
@@ -289,7 +289,7 @@ static int cdx_bus_match(struct device *dev, const struct device_driver *drv)
 		 */
 		if (!found_id->override_only)
 			return true;
-		if (cdx_dev->driver_override)
+		if (ret > 0)
 			return true;
 
 		ids = found_id + 1;
@@ -453,36 +453,6 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(modalias);
 
-static ssize_t driver_override_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	struct cdx_device *cdx_dev = to_cdx_device(dev);
-	int ret;
-
-	if (WARN_ON(dev->bus != &cdx_bus_type))
-		return -EINVAL;
-
-	ret = driver_set_override(dev, &cdx_dev->driver_override, buf, count);
-	if (ret)
-		return ret;
-
-	return count;
-}
-
-static ssize_t driver_override_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
-{
-	struct cdx_device *cdx_dev = to_cdx_device(dev);
-	ssize_t len;
-
-	device_lock(dev);
-	len = sysfs_emit(buf, "%s\n", cdx_dev->driver_override);
-	device_unlock(dev);
-	return len;
-}
-static DEVICE_ATTR_RW(driver_override);
-
 static ssize_t enable_store(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
@@ -552,7 +522,6 @@ static struct attribute *cdx_dev_attrs[] = {
 	&dev_attr_class.attr,
 	&dev_attr_revision.attr,
 	&dev_attr_modalias.attr,
-	&dev_attr_driver_override.attr,
 	NULL,
 };
 
@@ -646,6 +615,7 @@ ATTRIBUTE_GROUPS(cdx_bus);
 
 const struct bus_type cdx_bus_type = {
 	.name		= "cdx",
+	.driver_override = true,
 	.match		= cdx_bus_match,
 	.probe		= cdx_probe,
 	.remove		= cdx_remove,
diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
index b1ba97f6c9ad66..f54770f110bc8b 100644
--- a/include/linux/cdx/cdx_bus.h
+++ b/include/linux/cdx/cdx_bus.h
@@ -137,9 +137,6 @@ struct cdx_controller {
  * @enabled: is this bus enabled
  * @msi_dev_id: MSI Device ID associated with CDX device
  * @num_msi: Number of MSI's supported by the device
- * @driver_override: driver name to force a match; do not set directly,
- *                   because core frees it; use driver_set_override() to
- *                   set or clear it.
  * @irqchip_lock: lock to synchronize irq/msi configuration
  * @msi_write_pending: MSI write pending for this device
  */
@@ -165,7 +162,6 @@ struct cdx_device {
 	bool enabled;
 	u32 msi_dev_id;
 	u32 num_msi;
-	const char *driver_override;
 	struct mutex irqchip_lock;
 	bool msi_write_pending;
 };
-- 
2.53.0



