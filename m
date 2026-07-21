Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6A93B3C0A;
	Tue, 21 Jul 2026 20:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665868; cv=none; b=aZNL+ZzrFGBayOMEz1dG3KiST6e1Vl4ZA+3E7eApyr3aU2qGatSUzXMX3uyjNQD36b/wMSkj/wvQc1aJUfwUjdS8U07K50yKXmaE65HkO6EnQJjU/E0y4rk1E2AXJNEcyhkdqBnFskLByYoK5Ut7s2wJe/pzfnIhI3uwimT9jNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665868; c=relaxed/simple;
	bh=pRctaKzddsiqfG4qlxPS+KcXFbB9MnmbOZGYkpiM7Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6bDk7RYlmDGBmxFatz9zbPkrkT86blhty5WufHM+Vp+M1IezX3eSZE77Kz/8oK8VPrMqWNOq6WvDqSR5VyaktThxxUGISOmbqfSVJkPYHnSRGVVLjrc50D0oTNl1Ze0JGLkWNhf68wcahI/wqBPnT1xk3EknyiARNOundYKtks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZdQ/eAm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZdQ/eAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C911F000E9;
	Tue, 21 Jul 2026 20:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665866;
	bh=FhwgJmh1czpSsYIMEwFKh9Wg3sCO+QPSsJr+BDWL81A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZdQ/eAmhbpIx99EG3oNdgg+9GsCPx6gIebi3UfAEhHKlQQ+RH4yZ6e5ciOV5f/CF
	 S8Yna9uMXPjomND3RqpHghOMqw9tDzcdCWDLu4AGLoGXJkiUMGP//aP/Wf0oD9v9nb
	 L2i3hyJUs8NNU9nJprCPsCec2Cf4qBeqEOBc8ex0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0467/1266] rpmsg: use generic driver_override infrastructure
Date: Tue, 21 Jul 2026 17:15:04 +0200
Message-ID: <20260721152452.285353587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index da2fe69ba20482..f5909e45489346 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1526,7 +1526,6 @@ static void qcom_glink_rpdev_release(struct device *dev)
 {
 	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
 
-	kfree(rpdev->driver_override);
 	kfree(rpdev);
 }
 
@@ -1770,7 +1769,6 @@ static void qcom_glink_device_release(struct device *dev)
 
 	/* Release qcom_glink_alloc_channel() reference */
 	kref_put(&channel->refcount, qcom_glink_channel_release);
-	kfree(rpdev->driver_override);
 	kfree(rpdev);
 }
 
diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
index 662a674314045c..615d06af992902 100644
--- a/drivers/rpmsg/rpmsg_core.c
+++ b/drivers/rpmsg/rpmsg_core.c
@@ -419,33 +419,6 @@ rpmsg_show_attr(src, src, "0x%x\n");
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
@@ -466,7 +439,6 @@ static struct attribute *rpmsg_dev_attrs[] = {
 	&dev_attr_dst.attr,
 	&dev_attr_src.attr,
 	&dev_attr_announce.attr,
-	&dev_attr_driver_override.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(rpmsg_dev);
@@ -485,9 +457,11 @@ static int rpmsg_dev_match(struct device *dev, struct device_driver *drv)
 	struct rpmsg_driver *rpdrv = to_rpmsg_driver(drv);
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
@@ -597,6 +571,7 @@ static struct bus_type rpmsg_bus = {
 	.name		= "rpmsg",
 	.match		= rpmsg_dev_match,
 	.dev_groups	= rpmsg_dev_groups,
+	.driver_override = true,
 	.uevent		= rpmsg_uevent,
 	.probe		= rpmsg_dev_probe,
 	.remove		= rpmsg_dev_remove,
@@ -622,11 +597,9 @@ int rpmsg_register_device_override(struct rpmsg_device *rpdev,
 
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
@@ -635,8 +608,6 @@ int rpmsg_register_device_override(struct rpmsg_device *rpdev,
 	ret = device_add(dev);
 	if (ret) {
 		dev_err(dev, "device_add failed: %d\n", ret);
-		kfree(rpdev->driver_override);
-		rpdev->driver_override = NULL;
 		put_device(dev);
 	}
 
diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index f1af0f6746150e..905ac7910c98f3 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -378,7 +378,6 @@ static void virtio_rpmsg_release_device(struct device *dev)
 	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
 	struct virtio_rpmsg_channel *vch = to_virtio_rpmsg_channel(rpdev);
 
-	kfree(rpdev->driver_override);
 	kfree(vch);
 }
 
diff --git a/include/linux/rpmsg.h b/include/linux/rpmsg.h
index 90d8e4475f80ed..32819293670620 100644
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



