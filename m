Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE03356754;
	Wed, 20 May 2026 16:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294536; cv=none; b=f7cZlDNmPutb+I0G+pg9esgu25UTWkInsGbBFqMNVR81/qGc2LTeHllRBbY7ZFSsEw2H2txJnT6Lb/rxkP0lk9oV4T/8iMJpDXmA5lOp7TPlFr1Ii9SG0Awyd//N4u8ubB/K/sIU40etsx+FpCejbceC9G0/Wm2XfYB1Orh/SH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294536; c=relaxed/simple;
	bh=TiC+OBPymeKcDGPLCfrHQpBfgZJFicQQTvZ60amCTPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mKwPFNXhAKZzR3UB+QMYDsI+44hziyYjllsQeBbU4jarSOa+/Mb46NH7lMRNwKWcRtLuC3J05Sux+/E7Yv1AgSrirLrQJcd6vTV0nLTQqbxGMlBB/QAUtL2Pt0++yD4v40eVTofqZWKdUDtuH7ciRDScXdPFJSdflmRc6EkDDx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGF+HT+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGF+HT+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7941F000E9;
	Wed, 20 May 2026 16:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294534;
	bh=GR4szUdE+9ZHOEs3SqM2n+3bGd1tFFmo13DlLxb3gDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGF+HT+cmHNmuTOMTnfgVIHuv/6DbfjAt5OtBaNp6iILjfOcZx/SxheLMdtpedKtd
	 gbG47YRsEMoZFXsubKFL0V7art7j6JaN5Z8B1Cfoh22CW578fFCAW1heymclPw8zbz
	 ig/3uEuxZLtjLWeZacPzRgb14tYbCXyOKC7tyjgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0039/1146] vdpa: use generic driver_override infrastructure
Date: Wed, 20 May 2026 18:04:49 +0200
Message-ID: <20260520162149.267015111@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 34874beb0152e..caf0ee5d6856c 100644
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
index 2bfe3baa63f42..782c42d25db16 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -72,9 +72,6 @@ struct vdpa_mgmt_dev;
  * struct vdpa_device - representation of a vDPA device
  * @dev: underlying device
  * @vmap: the metadata passed to upper layer to be used for mapping
- * @driver_override: driver name to force a match; do not set directly,
- *                   because core frees it; use driver_set_override() to
- *                   set or clear it.
  * @config: the configuration ops for this device.
  * @map: the map ops for this device
  * @cf_lock: Protects get and set access to configuration layout.
@@ -90,7 +87,6 @@ struct vdpa_mgmt_dev;
 struct vdpa_device {
 	struct device dev;
 	union virtio_map vmap;
-	const char *driver_override;
 	const struct vdpa_config_ops *config;
 	const struct virtio_map_ops *map;
 	struct rw_semaphore cf_lock; /* Protects get/set config */
-- 
2.53.0



