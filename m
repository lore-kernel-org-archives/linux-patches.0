Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67C6471401;
	Tue, 21 Jul 2026 17:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656295; cv=none; b=SlwrEYALVClTYESozQAI3//mlrVgwfmXRhjJ8RGsvGX4JqVdTwuCYYpCtyGNVlUJ9Czr5bbTPeLHyqvNM76FrO4BaqScMu9/QQuFzK9cXWIgiwFLmCe/RO2pvNqjW2z48A4gf/aRXvh+KskNytU4smKZYzHwvAyGCkkzx/sXkS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656295; c=relaxed/simple;
	bh=9/8bTIlvb/CC3BmkTJh9B5gEC3h66A6q4Wugp8kubxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEMp8RsCS36xjdiedjPL3p9OMcvpg/Pcj8R3/flq3h2MaOmK+zz8xCLX7pQ2daC0Kkn2P+72LCYaBTVQNSJB5dJKIenF/rAgVlq5umGkn/tRgxkD0rtMEdlFPUqclg2b8MJqcKCaMtjYM//Ex+JzEiwfvMHAErsee3bvZAtp2PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItkxYJjL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItkxYJjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283101F000E9;
	Tue, 21 Jul 2026 17:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656294;
	bh=mn9UUbzWDu404IuyPVZRakYF9xcO+5bv7+BF32ZUJwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ItkxYJjL06hovThKhd6DdgApC2ItI0IogIwE2Rrc1Fwoc9hDLXn42LIlyy6hjAXpZ
	 dmHewSuABNmjpsXlDGh3ynljRcU8VMfNFC+B3LoCz9vN4Kdlbp3G5RWIj7rr8oJ1ax
	 TKLUMCI1exq5AqVGdzwl7dXwE/MM7Meh1/p7x2pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0280/1611] cdx: use generic driver_override infrastructure
Date: Tue, 21 Jul 2026 17:06:36 +0200
Message-ID: <20260721152521.353888928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3d50f8cd9c0bd7..9d6d24f49938b3 100644
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
 
@@ -653,6 +622,7 @@ ATTRIBUTE_GROUPS(cdx_bus);
 
 struct bus_type cdx_bus_type = {
 	.name		= "cdx",
+	.driver_override = true,
 	.match		= cdx_bus_match,
 	.probe		= cdx_probe,
 	.remove		= cdx_remove,
diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
index 79bb80e5679083..527f8851f0cde9 100644
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



