Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759C829DB8F;
	Tue, 31 Mar 2026 16:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976225; cv=none; b=gnIhdqf0uKQuzjOsKB1BuCS/j3yjKcRP9wObauJW74UwfOcu/1SyCPK7Egc9aAWsvGGnNn8Yn5Sya+k2LBX1jLpqiUtDr2ctwxtFjPLLq4zgiRLzCpLKO/MwcobTMcOfxDGIo1dp1NRsG4fJtn8ookPlWMwIp1fEua/TrXrkj94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976225; c=relaxed/simple;
	bh=ump3C1APbrVtF6JKn20A9PSMZ2K4ZTkPLza0m64zcQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRqWusu3BYxbv8vd5NBVp2sg87HBZskay3Gnk9J78mNOuv+0+I4c45Pb7J14AzwZsNF0uSmNX2WrbN+puee0ghhOcrHGI5MhEwB3L+WqR38tY7UD9x9wh9X3m3wyUiCXGVgAdaZA0RKdBvb8WV+o5i/nuK0C+4laAUmzJaubaaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbYI/ss/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbYI/ss/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0362AC19423;
	Tue, 31 Mar 2026 16:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976225;
	bh=ump3C1APbrVtF6JKn20A9PSMZ2K4ZTkPLza0m64zcQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbYI/ss/Z/Fh47HM5RUlHcDGYiANZulLZ1fi2yFxv1hrP008rmLOexTGFhvHLtWO5
	 VI0EJp4Z/O58iO0faW5GvhFmoOYyQR7zU0GDoC5jtx7Gjquc1kq6wNUUYQBjeeIAf6
	 rjx6OvypuqqKHHuK+6yttA596mgw8dE5f4A/DomU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/309] driver core: platform: use generic driver_override infrastructure
Date: Tue, 31 Mar 2026 18:18:34 +0200
Message-ID: <20260331161753.893246375@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

[ Upstream commit 2b38efc05bf7a8568ec74bfffea0f5cfa62bc01d ]

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
Fixes: 3d713e0e382e ("driver core: platform: add device binding path 'driver_override'")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260303115720.48783-5-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c         | 37 +++++----------------------------
 drivers/bus/simple-pm-bus.c     |  4 ++--
 drivers/clk/imx/clk-scu.c       |  3 +--
 drivers/slimbus/qcom-ngd-ctrl.c |  6 ++----
 include/linux/platform_device.h |  5 -----
 sound/soc/samsung/i2s.c         |  6 +++---
 6 files changed, 13 insertions(+), 48 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 09450349cf323..019d3f26807d9 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -562,7 +562,6 @@ static void platform_device_release(struct device *dev)
 	kfree(pa->pdev.dev.platform_data);
 	kfree(pa->pdev.mfd_cell);
 	kfree(pa->pdev.resource);
-	kfree(pa->pdev.driver_override);
 	kfree(pa);
 }
 
@@ -1265,38 +1264,9 @@ static ssize_t numa_node_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(numa_node);
 
-static ssize_t driver_override_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	ssize_t len;
-
-	device_lock(dev);
-	len = sysfs_emit(buf, "%s\n", pdev->driver_override);
-	device_unlock(dev);
-
-	return len;
-}
-
-static ssize_t driver_override_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	int ret;
-
-	ret = driver_set_override(dev, &pdev->driver_override, buf, count);
-	if (ret)
-		return ret;
-
-	return count;
-}
-static DEVICE_ATTR_RW(driver_override);
-
 static struct attribute *platform_dev_attrs[] = {
 	&dev_attr_modalias.attr,
 	&dev_attr_numa_node.attr,
-	&dev_attr_driver_override.attr,
 	NULL,
 };
 
@@ -1336,10 +1306,12 @@ static int platform_match(struct device *dev, const struct device_driver *drv)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct platform_driver *pdrv = to_platform_driver(drv);
+	int ret;
 
 	/* When driver_override is set, only bind to the matching driver */
-	if (pdev->driver_override)
-		return !strcmp(pdev->driver_override, drv->name);
+	ret = device_match_driver_override(dev, drv);
+	if (ret >= 0)
+		return ret;
 
 	/* Attempt an OF style match first */
 	if (of_driver_match_device(dev, drv))
@@ -1475,6 +1447,7 @@ static const struct dev_pm_ops platform_dev_pm_ops = {
 const struct bus_type platform_bus_type = {
 	.name		= "platform",
 	.dev_groups	= platform_dev_groups,
+	.driver_override = true,
 	.match		= platform_match,
 	.uevent		= platform_uevent,
 	.probe		= platform_probe,
diff --git a/drivers/bus/simple-pm-bus.c b/drivers/bus/simple-pm-bus.c
index d8e029e7e53f7..50f8b4e2ba5bc 100644
--- a/drivers/bus/simple-pm-bus.c
+++ b/drivers/bus/simple-pm-bus.c
@@ -36,7 +36,7 @@ static int simple_pm_bus_probe(struct platform_device *pdev)
 	 * that's not listed in simple_pm_bus_of_match. We don't want to do any
 	 * of the simple-pm-bus tasks for these devices, so return early.
 	 */
-	if (pdev->driver_override)
+	if (device_has_driver_override(&pdev->dev))
 		return 0;
 
 	match = of_match_device(dev->driver->of_match_table, dev);
@@ -78,7 +78,7 @@ static void simple_pm_bus_remove(struct platform_device *pdev)
 {
 	const void *data = of_device_get_match_data(&pdev->dev);
 
-	if (pdev->driver_override || data)
+	if (device_has_driver_override(&pdev->dev) || data)
 		return;
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
diff --git a/drivers/clk/imx/clk-scu.c b/drivers/clk/imx/clk-scu.c
index 34c9dc1fb20e5..c03f7821824d1 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -696,8 +696,7 @@ struct clk_hw *imx_clk_scu_alloc_dev(const char *name,
 	if (ret)
 		goto put_device;
 
-	ret = driver_set_override(&pdev->dev, &pdev->driver_override,
-				  "imx-scu-clk", strlen("imx-scu-clk"));
+	ret = device_set_driver_override(&pdev->dev, "imx-scu-clk");
 	if (ret)
 		goto put_device;
 
diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index cd40ab839c541..db45654f16955 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1539,10 +1539,8 @@ static int of_qcom_slim_ngd_register(struct device *parent,
 		ngd->id = id;
 		ngd->pdev->dev.parent = parent;
 
-		ret = driver_set_override(&ngd->pdev->dev,
-					  &ngd->pdev->driver_override,
-					  QCOM_SLIM_NGD_DRV_NAME,
-					  strlen(QCOM_SLIM_NGD_DRV_NAME));
+		ret = device_set_driver_override(&ngd->pdev->dev,
+						 QCOM_SLIM_NGD_DRV_NAME);
 		if (ret) {
 			platform_device_put(ngd->pdev);
 			kfree(ngd);
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 074754c23d330..bc843d76066a5 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -31,11 +31,6 @@ struct platform_device {
 	struct resource	*resource;
 
 	const struct platform_device_id	*id_entry;
-	/*
-	 * Driver name to force a match.  Do not set directly, because core
-	 * frees it.  Use driver_set_override() to set or clear it.
-	 */
-	const char *driver_override;
 
 	/* MFD cell pointer */
 	struct mfd_cell *mfd_cell;
diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index e9964f0e010ae..140907a41a70d 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -1360,10 +1360,10 @@ static int i2s_create_secondary_device(struct samsung_i2s_priv *priv)
 	if (!pdev_sec)
 		return -ENOMEM;
 
-	pdev_sec->driver_override = kstrdup("samsung-i2s", GFP_KERNEL);
-	if (!pdev_sec->driver_override) {
+	ret = device_set_driver_override(&pdev_sec->dev, "samsung-i2s");
+	if (ret) {
 		platform_device_put(pdev_sec);
-		return -ENOMEM;
+		return ret;
 	}
 
 	ret = platform_device_add(pdev_sec);
-- 
2.51.0



