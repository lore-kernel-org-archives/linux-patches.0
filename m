Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC03E2D5937;
	Tue, 31 Mar 2026 16:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974705; cv=none; b=DxyJ78f87pwH6MmtJOeGzj24GN2DA6ao0+xPbzapv9gG0+ejhqZyP1n0RtqHjxej4vV7Nkm3/h2VS0nAQL4otwE5B4Yd6UzzGyou58xkbC4Ke7Uc/5TQeU8IfrZotQ1u672QKiTtapsn0l/cenykVX2XaBexgJ7pehtFurPndZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974705; c=relaxed/simple;
	bh=Im8JxrRHGa2KxiKmdmprlBiMRPDlSVtd+VraZn++ybU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b98ZX7l4tLGw/HVDx/xmZTBDv3lM96R42c3zc5Ij960Voku+4cTbON9EbVziaV2ZjNa5vpcxv/V2iAgl4XH3KfhRCBDqthPTgvDIaGxD3W4jGTtwq8v8eARIJQ8W+QIv96uESjOmXaGcc7VE7UnaXlZ7VhePCssGWxXU+7B1xvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcr4Bivu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcr4Bivu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73545C19423;
	Tue, 31 Mar 2026 16:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974705;
	bh=Im8JxrRHGa2KxiKmdmprlBiMRPDlSVtd+VraZn++ybU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcr4BivuMUQBRC7v5oh4YawLTBG0nshHqfD3SnFp6Jrt2pRN7LdEbN7BTsdATQaJg
	 FBtmH2rlYkXSU9C3cfYtCaOczB5RzgI1PEXekoWiqmcqIZMSinn/uRBlChBMRaVeiC
	 StCVLjepniTirTiTtZRgsNf2O6/3B47p1rJoe5hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 013/342] driver core: generalize driver_override in struct device
Date: Tue, 31 Mar 2026 18:17:26 +0200
Message-ID: <20260331161759.396784556@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit cb3d1049f4ea77d5ad93f17d8ac1f2ed4da70501 ]

Currently, there are 12 busses (including platform and PCI) that
duplicate the driver_override logic for their individual devices.

All of them seem to be prone to the bug described in [1].

While this could be solved for every bus individually using a separate
lock, solving this in the driver-core generically results in less (and
cleaner) changes overall.

Thus, move driver_override to struct device, provide corresponding
accessors for busses and handle locking with a separate lock internally.

In particular, add device_set_driver_override(),
device_has_driver_override(), device_match_driver_override() and
generalize the sysfs store() and show() callbacks via a driver_override
feature flag in struct bus_type.

Until all busses have migrated, keep driver_set_override() in place.

Note that we can't use the device lock for the reasons described in [2].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220789 [1]
Link: https://lore.kernel.org/driver-core/DGRGTIRHA62X.3RY09D9SOK77P@kernel.org/ [2]
Tested-by: Gui-Dong Han <hanguidong02@gmail.com>
Co-developed-by: Gui-Dong Han <hanguidong02@gmail.com>
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260303115720.48783-2-dakr@kernel.org
[ Use dev->bus instead of sp->bus for consistency; fix commit message to
  refer to the struct bus_type's driver_override feature flag. - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Stable-dep-of: 2b38efc05bf7 ("driver core: platform: use generic driver_override infrastructure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/bus.c         | 43 ++++++++++++++++++++++++++-
 drivers/base/core.c        |  2 ++
 drivers/base/dd.c          | 60 ++++++++++++++++++++++++++++++++++++++
 include/linux/device.h     | 54 ++++++++++++++++++++++++++++++++++
 include/linux/device/bus.h |  4 +++
 5 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 9eb7771706f01..7c7d8d97215be 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -504,6 +504,36 @@ int bus_for_each_drv(const struct bus_type *bus, struct device_driver *start,
 }
 EXPORT_SYMBOL_GPL(bus_for_each_drv);
 
+static ssize_t driver_override_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	int ret;
+
+	ret = __device_set_driver_override(dev, buf, count);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static ssize_t driver_override_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	guard(spinlock)(&dev->driver_override.lock);
+	return sysfs_emit(buf, "%s\n", dev->driver_override.name);
+}
+static DEVICE_ATTR_RW(driver_override);
+
+static struct attribute *driver_override_dev_attrs[] = {
+	&dev_attr_driver_override.attr,
+	NULL,
+};
+
+static const struct attribute_group driver_override_dev_group = {
+	.attrs = driver_override_dev_attrs,
+};
+
 /**
  * bus_add_device - add device to bus
  * @dev: device being added
@@ -537,9 +567,15 @@ int bus_add_device(struct device *dev)
 	if (error)
 		goto out_put;
 
+	if (dev->bus->driver_override) {
+		error = device_add_group(dev, &driver_override_dev_group);
+		if (error)
+			goto out_groups;
+	}
+
 	error = sysfs_create_link(&sp->devices_kset->kobj, &dev->kobj, dev_name(dev));
 	if (error)
-		goto out_groups;
+		goto out_override;
 
 	error = sysfs_create_link(&dev->kobj, &sp->subsys.kobj, "subsystem");
 	if (error)
@@ -550,6 +586,9 @@ int bus_add_device(struct device *dev)
 
 out_subsys:
 	sysfs_remove_link(&sp->devices_kset->kobj, dev_name(dev));
+out_override:
+	if (dev->bus->driver_override)
+		device_remove_group(dev, &driver_override_dev_group);
 out_groups:
 	device_remove_groups(dev, sp->bus->dev_groups);
 out_put:
@@ -607,6 +646,8 @@ void bus_remove_device(struct device *dev)
 
 	sysfs_remove_link(&dev->kobj, "subsystem");
 	sysfs_remove_link(&sp->devices_kset->kobj, dev_name(dev));
+	if (dev->bus->driver_override)
+		device_remove_group(dev, &driver_override_dev_group);
 	device_remove_groups(dev, dev->bus->dev_groups);
 	if (klist_node_attached(&dev->p->knode_bus))
 		klist_del(&dev->p->knode_bus);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 40de2f51a1b1a..9863bd3705255 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2556,6 +2556,7 @@ static void device_release(struct kobject *kobj)
 	devres_release_all(dev);
 
 	kfree(dev->dma_range_map);
+	kfree(dev->driver_override.name);
 
 	if (dev->release)
 		dev->release(dev);
@@ -3159,6 +3160,7 @@ void device_initialize(struct device *dev)
 	kobject_init(&dev->kobj, &device_ktype);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	mutex_init(&dev->mutex);
+	spin_lock_init(&dev->driver_override.lock);
 	lockdep_set_novalidate_class(&dev->mutex);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index bea8da5f8a3a9..37c7e54e0e4c7 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -381,6 +381,66 @@ static void __exit deferred_probe_exit(void)
 }
 __exitcall(deferred_probe_exit);
 
+int __device_set_driver_override(struct device *dev, const char *s, size_t len)
+{
+	const char *new, *old;
+	char *cp;
+
+	if (!s)
+		return -EINVAL;
+
+	/*
+	 * The stored value will be used in sysfs show callback (sysfs_emit()),
+	 * which has a length limit of PAGE_SIZE and adds a trailing newline.
+	 * Thus we can store one character less to avoid truncation during sysfs
+	 * show.
+	 */
+	if (len >= (PAGE_SIZE - 1))
+		return -EINVAL;
+
+	/*
+	 * Compute the real length of the string in case userspace sends us a
+	 * bunch of \0 characters like python likes to do.
+	 */
+	len = strlen(s);
+
+	if (!len) {
+		/* Empty string passed - clear override */
+		spin_lock(&dev->driver_override.lock);
+		old = dev->driver_override.name;
+		dev->driver_override.name = NULL;
+		spin_unlock(&dev->driver_override.lock);
+		kfree(old);
+
+		return 0;
+	}
+
+	cp = strnchr(s, len, '\n');
+	if (cp)
+		len = cp - s;
+
+	new = kstrndup(s, len, GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+
+	spin_lock(&dev->driver_override.lock);
+	old = dev->driver_override.name;
+	if (cp != s) {
+		dev->driver_override.name = new;
+		spin_unlock(&dev->driver_override.lock);
+	} else {
+		/* "\n" passed - clear override */
+		dev->driver_override.name = NULL;
+		spin_unlock(&dev->driver_override.lock);
+
+		kfree(new);
+	}
+	kfree(old);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__device_set_driver_override);
+
 /**
  * device_is_bound() - Check if device is bound to a driver
  * @dev: device to check
diff --git a/include/linux/device.h b/include/linux/device.h
index 0be95294b6e61..e65d564f01cd7 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -483,6 +483,8 @@ struct device_physical_location {
  * 		on.  This shrinks the "Board Support Packages" (BSPs) and
  * 		minimizes board-specific #ifdefs in drivers.
  * @driver_data: Private pointer for driver specific info.
+ * @driver_override: Driver name to force a match.  Do not touch directly; use
+ *		     device_set_driver_override() instead.
  * @links:	Links to suppliers and consumers of this device.
  * @power:	For device power management.
  *		See Documentation/driver-api/pm/devices.rst for details.
@@ -576,6 +578,10 @@ struct device {
 					   core doesn't touch it */
 	void		*driver_data;	/* Driver data, set and get with
 					   dev_set_drvdata/dev_get_drvdata */
+	struct {
+		const char	*name;
+		spinlock_t	lock;
+	} driver_override;
 	struct mutex		mutex;	/* mutex to synchronize calls to
 					 * its driver.
 					 */
@@ -701,6 +707,54 @@ struct device_link {
 
 #define kobj_to_dev(__kobj)	container_of_const(__kobj, struct device, kobj)
 
+int __device_set_driver_override(struct device *dev, const char *s, size_t len);
+
+/**
+ * device_set_driver_override() - Helper to set or clear driver override.
+ * @dev: Device to change
+ * @s: NUL-terminated string, new driver name to force a match, pass empty
+ *     string to clear it ("" or "\n", where the latter is only for sysfs
+ *     interface).
+ *
+ * Helper to set or clear driver override of a device.
+ *
+ * Returns: 0 on success or a negative error code on failure.
+ */
+static inline int device_set_driver_override(struct device *dev, const char *s)
+{
+	return __device_set_driver_override(dev, s, s ? strlen(s) : 0);
+}
+
+/**
+ * device_has_driver_override() - Check if a driver override has been set.
+ * @dev: device to check
+ *
+ * Returns true if a driver override has been set for this device.
+ */
+static inline bool device_has_driver_override(struct device *dev)
+{
+	guard(spinlock)(&dev->driver_override.lock);
+	return !!dev->driver_override.name;
+}
+
+/**
+ * device_match_driver_override() - Match a driver against the device's driver_override.
+ * @dev: device to check
+ * @drv: driver to match against
+ *
+ * Returns > 0 if a driver override is set and matches the given driver, 0 if a
+ * driver override is set but does not match, or < 0 if a driver override is not
+ * set at all.
+ */
+static inline int device_match_driver_override(struct device *dev,
+					       const struct device_driver *drv)
+{
+	guard(spinlock)(&dev->driver_override.lock);
+	if (dev->driver_override.name)
+		return !strcmp(dev->driver_override.name, drv->name);
+	return -1;
+}
+
 /**
  * device_iommu_mapped - Returns true when the device DMA is translated
  *			 by an IOMMU
diff --git a/include/linux/device/bus.h b/include/linux/device/bus.h
index 99b1002b3e318..f047b40a30b74 100644
--- a/include/linux/device/bus.h
+++ b/include/linux/device/bus.h
@@ -63,6 +63,9 @@ struct fwnode_handle;
  *			this bus.
  * @pm:		Power management operations of this bus, callback the specific
  *		device driver's pm-ops.
+ * @driver_override:	Set to true if this bus supports the driver_override
+ *			mechanism, which allows userspace to force a specific
+ *			driver to bind to a device via a sysfs attribute.
  * @need_parent_lock:	When probing or removing a device on this bus, the
  *			device core should lock the device's parent.
  *
@@ -104,6 +107,7 @@ struct bus_type {
 
 	const struct dev_pm_ops *pm;
 
+	bool driver_override;
 	bool need_parent_lock;
 };
 
-- 
2.51.0



