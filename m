Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E286B46D0A0;
	Tue, 21 Jul 2026 17:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656206; cv=none; b=WUyDzVQeJWcY4b1fdhrWmIsaburXkFHFkB6IJ61hk9O70WgavQWbxhfIMKRB8bCpl+OQAshgO3pHp8JPABo66RBE1pV+Yrr9T6cxrFx7EBv9wheyykC9AzLjsREfiBPXHKMl009UeLyGnOj5ITGrVzyQ8yVS94mUC9zuQuSIIDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656206; c=relaxed/simple;
	bh=XMRrwdKvIiyKGXxe+cq31OVkWGFNyL+k32CW4E7XlMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnpah4yTCyaiO/XTy87COXVFGDyHnWj+ALxpTlpJc1STZ1IyVLOoI9PS9DcbvIrklHC874ACCLSbbwSV8xy6kWNPVEWmMzurTnMDvtIqF/HiWW3I2Vycn+ILeUHUPjkJ6PIb8OKlQU3mMXoro0YH7LN6P0Coy1lFn3DUhvLoomA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2GRwkpA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2GRwkpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546EA1F00A3A;
	Tue, 21 Jul 2026 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656204;
	bh=ij5EklxEa3kP3o5uNzc6Sf6/I2FI1lE/hqk/xkNnYlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2GRwkpAo3QLKugUBK4QOi7ihJ54HI7yxPMPqZK1/Ujzz/S+qQfndMv6K3tMmlZZm
	 dWLIrWO/svq8+ut8ApYTIExo5dEc3aZEIprZS/Aw+m2DPFwEhdIQpGs+RM9z12V5Ne
	 EfLSrRuZOpkImB5KhgMNgAHoA/DTuz6Ldq/NDOh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0282/1611] rpmsg: use generic driver_override infrastructure
Date: Tue, 21 Jul 2026 17:06:38 +0200
Message-ID: <20260721152521.399044460@linuxfoundation.org>
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
index 3a15d9d108089f..833ff9cb8afe68 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1618,7 +1618,6 @@ static void qcom_glink_rpdev_release(struct device *dev)
 {
 	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
 
-	kfree(rpdev->driver_override);
 	kfree(rpdev);
 }
 
@@ -1870,7 +1869,6 @@ static void qcom_glink_device_release(struct device *dev)
 
 	/* Release qcom_glink_alloc_channel() reference */
 	kref_put(&channel->refcount, qcom_glink_channel_release);
-	kfree(rpdev->driver_override);
 	kfree(rpdev);
 }
 
diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
index 96964745065b1f..2b9f6d5a9a4fc9 100644
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
index 484890b4a6a744..d4fce3ac1c88de 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -372,7 +372,6 @@ static void virtio_rpmsg_release_device(struct device *dev)
 	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
 	struct virtio_rpmsg_channel *vch = to_virtio_rpmsg_channel(rpdev);
 
-	kfree(rpdev->driver_override);
 	kfree(vch);
 }
 
diff --git a/include/linux/rpmsg.h b/include/linux/rpmsg.h
index fb7ab91656458e..c2e3ef8480d55d 100644
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



