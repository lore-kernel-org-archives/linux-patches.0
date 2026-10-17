Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241FE36B93B;
	Sat, 17 Oct 2026 16:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254057; cv=none; b=gDvEOHSCmMcXqedgeO+De/WnVUdGiZx38QqVtCLqFnMTA4ItyeQ2r7mzgh3jXzD6NW9FyWL8KWt5x1q6TM42kfMLbEq/xuYmDIqKDoiPLgoML24LYLAfSG1ll/X7Pq3CeiifWjXEHXkdrA4zNGSm5ZjIZxVfWOVn/Dv6toyfbGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254057; c=relaxed/simple;
	bh=zqR8V7n5s7pMkJ/Q1rgMeLQanvNmfNB0ADOF9RNbb8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n5CVTzeaGJQNi3kAkNOJG6ae98R6LwjE4D7kVNDvJPoMCxhaXwyEwdVr00L9QS/YpZelHDCyE/WLoG9+XTvsh9zCDhOwnJdrlDbM503gorIruMemuMcwmRz6zoxigWKb2RllSW7KPdCeHSr+fwOLwGYfrXMYPmf/m6z/FJY3w98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPYE8oHg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPYE8oHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECB91F000C4;
	Sat, 17 Oct 2026 16:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254056;
	bh=zhaHj/14Yp6e6WWyJ5STk1ln8cDByXTqJjUt2kUCkZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPYE8oHgim5D9ra0A13UvBqM1sfDrsUO9dNC/IGkO0CDIniFD7aPcOl10wYqOu3iV
	 VXCe/SX7gJCmvlCmMzVPmGkWCmgyaFpzOFP8GBCuGlA5NAg6qv/pJPh6HgFANivE6O
	 hfh3GPuFoaTA2g+Z9lDGbBG30EiW9pThGzKS1SSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 320/869] vdpa: use generic driver_override infrastructure
Date: Sat, 17 Oct 2026 17:52:41 +0200
Message-ID: <20261017160045.281565229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 85bb534ff12aab6916058897b39c748940a7a4c6 ]

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
Fixes: 539fec78edb4 ("vdpa: add driver_override support")
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20260324005919.2408620-9-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa.c  | 48 +++++---------------------------------------
 include/linux/vdpa.h |  4 ----
 2 files changed, 5 insertions(+), 47 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 8a372b51c21ad..0fb00c8bde5e3 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -67,57 +67,20 @@ static void vdpa_dev_remove(struct device *d)
 
 static int vdpa_dev_match(struct device *dev, const struct device_driver *drv)
 {
-	struct vdpa_device *vdev = dev_to_vdpa(dev);
+	int ret;
 
 	/* Check override first, and if set, only use the named driver */
-	if (vdev->driver_override)
-		return strcmp(vdev->driver_override, drv->name) == 0;
+	ret = device_match_driver_override(dev, drv);
+	if (ret >= 0)
+		return ret;
 
 	/* Currently devices must be supported by all vDPA bus drivers */
 	return 1;
 }
 
-static ssize_t driver_override_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	struct vdpa_device *vdev = dev_to_vdpa(dev);
-	int ret;
-
-	ret = driver_set_override(dev, &vdev->driver_override, buf, count);
-	if (ret)
-		return ret;
-
-	return count;
-}
-
-static ssize_t driver_override_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
-{
-	struct vdpa_device *vdev = dev_to_vdpa(dev);
-	ssize_t len;
-
-	device_lock(dev);
-	len = sysfs_emit(buf, "%s\n", vdev->driver_override);
-	device_unlock(dev);
-
-	return len;
-}
-static DEVICE_ATTR_RW(driver_override);
-
-static struct attribute *vdpa_dev_attrs[] = {
-	&dev_attr_driver_override.attr,
-	NULL,
-};
-
-static const struct attribute_group vdpa_dev_group = {
-	.attrs  = vdpa_dev_attrs,
-};
-__ATTRIBUTE_GROUPS(vdpa_dev);
-
 static const struct bus_type vdpa_bus = {
 	.name  = "vdpa",
-	.dev_groups = vdpa_dev_groups,
+	.driver_override = true,
 	.match = vdpa_dev_match,
 	.probe = vdpa_dev_probe,
 	.remove = vdpa_dev_remove,
@@ -132,7 +95,6 @@ static void vdpa_release_dev(struct device *d)
 		ops->free(vdev);
 
 	ida_free(&vdpa_index_ida, vdev->index);
-	kfree(vdev->driver_override);
 	kfree(vdev);
 }
 
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 2e7a30fe6b925..c1da2f6ee5d3f 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -71,9 +71,6 @@ struct vdpa_mgmt_dev;
  * struct vdpa_device - representation of a vDPA device
  * @dev: underlying device
  * @dma_dev: the actual device that is performing DMA
- * @driver_override: driver name to force a match; do not set directly,
- *                   because core frees it; use driver_set_override() to
- *                   set or clear it.
  * @config: the configuration ops for this device.
  * @cf_lock: Protects get and set access to configuration layout.
  * @index: device index
@@ -88,7 +85,6 @@ struct vdpa_mgmt_dev;
 struct vdpa_device {
 	struct device dev;
 	struct device *dma_dev;
-	const char *driver_override;
 	const struct vdpa_config_ops *config;
 	struct rw_semaphore cf_lock; /* Protects get/set config */
 	unsigned int index;
-- 
2.53.0



