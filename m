Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B80E33D4E9;
	Wed, 20 May 2026 17:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297440; cv=none; b=FydMkGxnAemWhfbbnEDSjfVdzTl+Rd3t4CwtcBru3W4xfiAW9FmajotclLklm1vriRCrz0eNpTXg3OxoD+r1XFXrWn6I4BBP6SjdM3ghMB9pqP+TH0cO2cdC159Ji8mKERHM5vO42ifZx3mJhwOlw6eLakhKbMsY9nBM3dF0lDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297440; c=relaxed/simple;
	bh=dFKZDYioTUdcMqumyxhhrQd/VwVRsyBZO9Hqsa/3I4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n6n9nQ+oDYm+b1i6Es6bEFhE3Vdc+l6L4p/LOwvQ0HxSEE1fHX5uXwMKVtfzIiiDpAXGWUR/WstmbsxC/89dMMbYc6aGZvj56MILfQu7CJFt33GmfeliwF8rkqIViDMeUy4CT/Iyq4s5EOktW8kZDWJf3X3qTtDHtFqLAt2GmEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlU5jdA+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlU5jdA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689011F00893;
	Wed, 20 May 2026 17:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297438;
	bh=Tcg2dkYHEM/xLoqYeVSLNY4T8Nb+aQQzwNW6+L4/jwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UlU5jdA+P5O2f8DnUG/1BZ9YKAB7a3gubGmE37eE0YU+8D+m0eBZXhe3g3Ny6mxBM
	 X5rCnYFQFVm69UYJF6Swh23w4NM2t2N9zWGSxcl8PpmshmYIjZ45rm7gD2My3T0a/k
	 3FXfQX+zsv7wT7nxBCIA4UKNQ6HaWxjgKbNbtARY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/957] platform/wmi: use generic driver_override infrastructure
Date: Wed, 20 May 2026 18:08:34 +0200
Message-ID: <20260520162135.234488860@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 8a700b1fc94df4d847a04f14ebc7f8532592b367 ]

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
Fixes: 12046f8c77e0 ("platform/x86: wmi: Add driver_override support")
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Acked-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260324005919.2408620-7-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 36 +++++-------------------------------
 include/linux/wmi.h        |  4 ----
 2 files changed, 5 insertions(+), 35 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 4e86a422f05f1..6f8e96476fd07 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -702,39 +702,11 @@ static ssize_t expensive_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(expensive);
 
-static ssize_t driver_override_show(struct device *dev, struct device_attribute *attr,
-				    char *buf)
-{
-	struct wmi_device *wdev = to_wmi_device(dev);
-	ssize_t ret;
-
-	device_lock(dev);
-	ret = sysfs_emit(buf, "%s\n", wdev->driver_override);
-	device_unlock(dev);
-
-	return ret;
-}
-
-static ssize_t driver_override_store(struct device *dev, struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	struct wmi_device *wdev = to_wmi_device(dev);
-	int ret;
-
-	ret = driver_set_override(dev, &wdev->driver_override, buf, count);
-	if (ret < 0)
-		return ret;
-
-	return count;
-}
-static DEVICE_ATTR_RW(driver_override);
-
 static struct attribute *wmi_attrs[] = {
 	&dev_attr_modalias.attr,
 	&dev_attr_guid.attr,
 	&dev_attr_instance_count.attr,
 	&dev_attr_expensive.attr,
-	&dev_attr_driver_override.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(wmi);
@@ -803,7 +775,6 @@ static void wmi_dev_release(struct device *dev)
 {
 	struct wmi_block *wblock = dev_to_wblock(dev);
 
-	kfree(wblock->dev.driver_override);
 	kfree(wblock);
 }
 
@@ -812,10 +783,12 @@ static int wmi_dev_match(struct device *dev, const struct device_driver *driver)
 	const struct wmi_driver *wmi_driver = to_wmi_driver(driver);
 	struct wmi_block *wblock = dev_to_wblock(dev);
 	const struct wmi_device_id *id = wmi_driver->id_table;
+	int ret;
 
 	/* When driver_override is set, only bind to the matching driver */
-	if (wblock->dev.driver_override)
-		return !strcmp(wblock->dev.driver_override, driver->name);
+	ret = device_match_driver_override(dev, driver);
+	if (ret >= 0)
+		return ret;
 
 	if (id == NULL)
 		return 0;
@@ -936,6 +909,7 @@ static struct class wmi_bus_class = {
 static const struct bus_type wmi_bus_type = {
 	.name = "wmi",
 	.dev_groups = wmi_groups,
+	.driver_override = true,
 	.match = wmi_dev_match,
 	.uevent = wmi_dev_uevent,
 	.probe = wmi_dev_probe,
diff --git a/include/linux/wmi.h b/include/linux/wmi.h
index 10751c8e5e6a0..c20bb22133381 100644
--- a/include/linux/wmi.h
+++ b/include/linux/wmi.h
@@ -16,16 +16,12 @@
  * struct wmi_device - WMI device structure
  * @dev: Device associated with this WMI device
  * @setable: True for devices implementing the Set Control Method
- * @driver_override: Driver name to force a match; do not set directly,
- *		     because core frees it; use driver_set_override() to
- *		     set or clear it.
  *
  * This represents WMI devices discovered by the WMI driver core.
  */
 struct wmi_device {
 	struct device dev;
 	bool setable;
-	const char *driver_override;
 };
 
 /**
-- 
2.53.0



