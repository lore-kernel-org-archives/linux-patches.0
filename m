Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D38D46D55F;
	Tue, 21 Jul 2026 15:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648953; cv=none; b=QhIo4ZIC7VIqpBsDJyUk+Y7GhLIdEMdL864IVXBVULa4U0XfFW/Jywz3584HGWODreYYsCzxrTOgp7w3tWrduT4Fefk5/Tnu0uMQnZ18Fweu7icdG5ay+HSxV3Q9yXfyd1UTKL6OOKFyGkY48GYxPyt3sbmIP3dKzTLmFPzeb60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648953; c=relaxed/simple;
	bh=RxaQX0Hj5msQp54lvsKKBm8wlpGRT9GSerZYWu8SU9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfAFEsrpUUJVYlOVa3jy+7tvLBkZim6SqNyv7kWmaLh/Sg1WoZAGQ1A2deaFqVRfAGoL1aATR6Z/0A+NPXeaMU2ubUxfFA6KIF677YK9GP5QrfNv4tg4vNgyxO6w55+yyhq4BOr8+kV+jPudj+D0rBMNpVgEQodJ5FKDsglO4mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBuINsvS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBuINsvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6304B1F000E9;
	Tue, 21 Jul 2026 15:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648951;
	bh=FGIUzk6xmiDjHVAENWXWHFS22MAyIunE+wGEOI4XV6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBuINsvSK1CD1aNzYyX80UIWhEqx7lC4JUoX6lrR9MCom5OQNA7Ak7dw7H1A5MQLY
	 jSDHE9E8rXYUqAEZN4QFX4G5ZX2UsOFvJnkzRPcbe8eiICWakI3Onm8ZqwalEm2UEa
	 HyM4GX/saad+95xLn3FJUDrAPMi5YDlcVWF3j9ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0393/2077] rpmsg: use generic driver_override infrastructure
Date: Tue, 21 Jul 2026 17:01:06 +0200
Message-ID: <20260721152601.980375631@linuxfoundation.org>
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

[ Upstream commit 55ced13c42921714e90f8fae94b6ed803330dc6a ]

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
Fixes: e95060478244 ("rpmsg: Introduce a driver override mechanism")
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260505133935.3772495-5-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c |  2 --
 drivers/rpmsg/rpmsg_core.c        | 43 +++++--------------------------
 drivers/rpmsg/virtio_rpmsg_bus.c  |  1 -
 include/linux/rpmsg.h             |  4 ---
 4 files changed, 7 insertions(+), 43 deletions(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 401a4ece0c9777..d9d4468e4cbdfd 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1626,7 +1626,6 @@ static void qcom_glink_rpdev_release(struct device *dev)
 {
 	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
 
-	kfree(rpdev->driver_override);
 	kfree(rpdev);
 }
 
@@ -1862,7 +1861,6 @@ static void qcom_glink_device_release(struct device *dev)
 
 	/* Release qcom_glink_alloc_channel() reference */
 	kref_put(&channel->refcount, qcom_glink_channel_release);
-	kfree(rpdev->driver_override);
 	kfree(rpdev);
 }
 
diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
index e7f7831d37f899..c56f69c22e420c 100644
--- a/drivers/rpmsg/rpmsg_core.c
+++ b/drivers/rpmsg/rpmsg_core.c
@@ -358,33 +358,6 @@ rpmsg_show_attr(src, src, "0x%x\n");
 rpmsg_show_attr(dst, dst, "0x%x\n");
 rpmsg_show_attr(announce, announce ? "true" : "false", "%s\n");
 
-static ssize_t driver_override_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
-	int ret;
-
-	ret = driver_set_override(dev, &rpdev->driver_override, buf, count);
-	if (ret)
-		return ret;
-
-	return count;
-}
-
-static ssize_t driver_override_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
-{
-	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
-	ssize_t len;
-
-	device_lock(dev);
-	len = sysfs_emit(buf, "%s\n", rpdev->driver_override);
-	device_unlock(dev);
-	return len;
-}
-static DEVICE_ATTR_RW(driver_override);
-
 static ssize_t modalias_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
@@ -405,7 +378,6 @@ static struct attribute *rpmsg_dev_attrs[] = {
 	&dev_attr_dst.attr,
 	&dev_attr_src.attr,
 	&dev_attr_announce.attr,
-	&dev_attr_driver_override.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(rpmsg_dev);
@@ -424,9 +396,11 @@ static int rpmsg_dev_match(struct device *dev, const struct device_driver *drv)
 	const struct rpmsg_driver *rpdrv = to_rpmsg_driver(drv);
 	const struct rpmsg_device_id *ids = rpdrv->id_table;
 	unsigned int i;
+	int ret;
 
-	if (rpdev->driver_override)
-		return !strcmp(rpdev->driver_override, drv->name);
+	ret = device_match_driver_override(dev, drv);
+	if (ret >= 0)
+		return ret;
 
 	if (ids)
 		for (i = 0; ids[i].name[0]; i++)
@@ -535,6 +509,7 @@ static const struct bus_type rpmsg_bus = {
 	.name		= "rpmsg",
 	.match		= rpmsg_dev_match,
 	.dev_groups	= rpmsg_dev_groups,
+	.driver_override = true,
 	.uevent		= rpmsg_uevent,
 	.probe		= rpmsg_dev_probe,
 	.remove		= rpmsg_dev_remove,
@@ -560,11 +535,9 @@ int rpmsg_register_device_override(struct rpmsg_device *rpdev,
 
 	device_initialize(dev);
 	if (driver_override) {
-		ret = driver_set_override(dev, &rpdev->driver_override,
-					  driver_override,
-					  strlen(driver_override));
+		ret = device_set_driver_override(dev, driver_override);
 		if (ret) {
-			dev_err(dev, "device_set_override failed: %d\n", ret);
+			dev_err(dev, "device_set_driver_override() failed: %d\n", ret);
 			put_device(dev);
 			return ret;
 		}
@@ -573,8 +546,6 @@ int rpmsg_register_device_override(struct rpmsg_device *rpdev,
 	ret = device_add(dev);
 	if (ret) {
 		dev_err(dev, "device_add failed: %d\n", ret);
-		kfree(rpdev->driver_override);
-		rpdev->driver_override = NULL;
 		put_device(dev);
 	}
 
diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 5ae15111fb4f18..1b8bb05924af73 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -374,7 +374,6 @@ static void virtio_rpmsg_release_device(struct device *dev)
 	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
 	struct virtio_rpmsg_channel *vch = to_virtio_rpmsg_channel(rpdev);
 
-	kfree(rpdev->driver_override);
 	kfree(vch);
 }
 
diff --git a/include/linux/rpmsg.h b/include/linux/rpmsg.h
index 83266ce1464204..2e40eb54155e02 100644
--- a/include/linux/rpmsg.h
+++ b/include/linux/rpmsg.h
@@ -41,9 +41,6 @@ struct rpmsg_channel_info {
  * rpmsg_device - device that belong to the rpmsg bus
  * @dev: the device struct
  * @id: device id (used to match between rpmsg drivers and devices)
- * @driver_override: driver name to force a match; do not set directly,
- *                   because core frees it; use driver_set_override() to
- *                   set or clear it.
  * @src: local address
  * @dst: destination address
  * @ept: the rpmsg endpoint of this channel
@@ -53,7 +50,6 @@ struct rpmsg_channel_info {
 struct rpmsg_device {
 	struct device dev;
 	struct rpmsg_device_id id;
-	const char *driver_override;
 	u32 src;
 	u32 dst;
 	struct rpmsg_endpoint *ept;
-- 
2.53.0



