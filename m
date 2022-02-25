Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A671B6B
	for <patches@lists.linux.dev>; Fri, 25 Feb 2022 06:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645768858; x=1677304858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=srpsz2FHR5cSX+JDns+FyxwO5nETB47lxKo2LDVZPsM=;
  b=MNi/pn8z2van0qcHQbIhV19mNZUxtrQhk6cmEGSNPVgVGaVnS8TUbLUk
   rYHQ/8w37+zrBtXOpCYt634tJ6MEwjBjizxHn2kVg7U7miQUIo8cdn/xD
   iXGUcFbEIN7DZVomIURCXZNh9yhYGJj2AjQqoUcEm35AH8R9ijHwXR3dQ
   zfboH2o/Gs/RvRHzTptqnAvM42I+hJugrg7s5i4iCmTpeoxVZyNbHZ05t
   aU2E1g2RiWEN6950L2Z0YpSdkHAU01lazxcVDtoxrFl3ebwmYQAMelSv2
   GuGuGMozYSI0MTJdP8EBFasvvfvoVJF1v025Nw2hyusONODq4T4NPB2+V
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="277063338"
X-IronPort-AV: E=Sophos;i="5.90,135,1643702400"; 
   d="scan'208";a="277063338"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 22:00:57 -0800
X-IronPort-AV: E=Sophos;i="5.90,135,1643702400"; 
   d="scan'208";a="549108240"
Received: from tperters-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.138.9])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 22:00:56 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	kernel test robot <lkp@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 2/2] cxl/region: Introduce concept of region configuration
Date: Thu, 24 Feb 2022 22:00:38 -0800
Message-Id: <20220225060038.1511562-3-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220225060038.1511562-1-ben.widawsky@intel.com>
References: <20220225060038.1511562-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The region creation APIs create a vacant region. Configuring the region
works in the same way as similar subsystems such as devdax. Sysfs attrs
will be provided to allow userspace to configure the region.  Finally
once all configuration is complete, userspace may activate the region.

Introduced here are the most basic attributes needed to configure a
region. Details of these attribute are described in the ABI
Documentation.

A example is provided below:

/sys/bus/cxl/devices/region0.0:0
├── devtype
├── interleave_granularity
├── interleave_ways
├── modalias
├── offset
├── size
├── subsystem -> ../../../../../../bus/cxl
├── target0
├── uevent
└── uuid

Reported-by: kernel test robot <lkp@intel.com> (v2)
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
Changes since v3:
- Make target be a decoder
- Use device_lock for protecting config/probe race
- Teardown region on decoder removal

Size is still not handled.
---
 Documentation/ABI/testing/sysfs-bus-cxl |  59 ++++
 drivers/cxl/core/port.c                 |   8 +
 drivers/cxl/core/region.c               | 351 +++++++++++++++++++++++-
 drivers/cxl/cxl.h                       |  16 +-
 drivers/cxl/region.h                    |  65 +++++
 5 files changed, 495 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index e5db45ea70ad..c447826e8286 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -186,3 +186,62 @@ Description:
 		Deletes the named region.  The attribute expects a region in the
 		form "regionX.Y:Z". The region's name, allocated by reading
 		create_region, will also be released.
+		Deletes the named region. A region must be unbound from the
+		region driver before being deleted. The attributes expects a
+		region in the form "regionX.Y:Z". The region's name, allocated
+		by reading create_region, will also be released.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/resource
+Date:		January, 2022
+KernelVersion:	v5.18
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		A region is a contiguous partition of a CXL Root decoder address
+		space. Region capacity is allocated by writing to the size
+		attribute, the resulting physical address base determined by the
+		driver is reflected here.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/size
+Date:		January, 2022
+KernelVersion:	v5.18
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		System physical address space to be consumed by the region.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/interleave_ways
+Date:		January, 2022
+KernelVersion:	v5.18
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Configures the number of devices participating in the region is
+		set by writing this value. Each device will provide
+		1/interleave_ways of storage for the region.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/interleave_granularity
+Date:		January, 2022
+KernelVersion:	v5.18
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Set the number of consecutive bytes each device in the
+		interleave set will claim. The possible interleave granularity
+		values are determined by the CXL spec and the participating
+		devices.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/uuid
+Date:		January, 2022
+KernelVersion:	v5.18
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Write a unique identifier for the region. This field must be set
+		for persistent regions and it must not conflict with the UUID of
+		another region. If this field is set for volatile regions, the
+		value is ignored.
+
+What: /sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/endpoint_decoder[0..interleave_ways]
+Date:		January, 2022
+KernelVersion:	v5.18
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Write a decoder object that is unused and will participate in
+		decoding memory transactions for the interleave set, ie.
+		decoderX.Y. All attributes must be populated.
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index f3e1313217a8..0eff36f748c3 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1415,6 +1415,14 @@ EXPORT_SYMBOL_NS_GPL(cxl_decoder_add, CXL);
 
 static void cxld_unregister(void *dev)
 {
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+
+	if (cxld->cxlr) {
+		mutex_lock(&cxld->cxlr->remove_lock);
+		device_release_driver(&cxld->cxlr->dev);
+		mutex_unlock(&cxld->cxlr->remove_lock);
+	}
+
 	device_unregister(dev);
 }
 
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index a934938f8630..2b17b0af48de 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2,9 +2,12 @@
 /* Copyright(c) 2022 Intel Corporation. All rights reserved. */
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/sizes.h>
 #include <linux/slab.h>
+#include <linux/uuid.h>
 #include <linux/idr.h>
 #include <region.h>
+#include <cxlmem.h>
 #include <cxl.h>
 #include "core.h"
 
@@ -16,28 +19,367 @@
  * Memory ranges, Regions represent the active mapped capacity by the HDM
  * Decoder Capability structures throughout the Host Bridges, Switches, and
  * Endpoints in the topology.
+ *
+ * Region configuration has some ordering constraints:
+ * - Size: Must be set after all targets
+ * - Targets: Must be set after interleave ways
+ * - Interleave ways: Must be set after Interleave Granularity
+ *
+ * UUID may be set at any time before binding the driver to the region.
  */
 
 
-static struct cxl_region *to_cxl_region(struct device *dev);
+static const struct attribute_group region_interleave_group;
+
+#define _REGION_ATTR_RO(name)                                                  \
+	static ssize_t name##_show(struct device *dev,                         \
+				   struct device_attribute *attr, char *buf)   \
+	{                                                                      \
+		struct cxl_region *cxlr = to_cxl_region(dev);                  \
+		if (cxlr->flags & REGION_DEAD)                                 \
+			return -ENODEV;                                        \
+		return show_##name(to_cxl_region(dev), buf);                   \
+	}
+
+#define REGION_ATTR_RO(name)                                                   \
+	_REGION_ATTR_RO(name)                                                  \
+	static DEVICE_ATTR_RO(name)
+
+#define _REGION_ATTR_WO(name)                                                  \
+	static ssize_t name##_store(struct device *dev,                        \
+				    struct device_attribute *attr,             \
+				    const char *buf, size_t len)               \
+	{                                                                      \
+		int ret;                                                       \
+		if (device_lock_interruptible(dev) < 0)                        \
+			return -EINTR;                                         \
+		if (dev->driver) {                                             \
+			device_unlock(dev);                                    \
+			return -EBUSY;                                         \
+		}                                                              \
+		ret = store_##name(to_cxl_region(dev), buf, len);              \
+		device_unlock(dev);                                            \
+		return ret;                                                    \
+	}
+
+#define REGION_ATTR_RW(name)                                                   \
+	_REGION_ATTR_RO(name)                                                  \
+	_REGION_ATTR_WO(name)                                                  \
+	static DEVICE_ATTR_RW(name)
+
+#define TARGET_ATTR_RW(n)                                                      \
+	static ssize_t target##n##_show(                                       \
+		struct device *dev, struct device_attribute *attr, char *buf)  \
+	{                                                                      \
+		return show_targetN(to_cxl_region(dev), buf, (n));             \
+	}                                                                      \
+	static ssize_t target##n##_store(struct device *dev,                   \
+					 struct device_attribute *attr,        \
+					 const char *buf, size_t len)          \
+	{                                                                      \
+		int ret;                                                       \
+		if (device_lock_interruptible(dev) < 0)                        \
+			return -EINTR;                                         \
+		if (dev->driver) {                                             \
+			device_unlock(dev);                                    \
+			return -EBUSY;                                         \
+		}                                                              \
+		ret = store_targetN(to_cxl_region(dev), buf, (n), len);        \
+		device_unlock(dev);                                            \
+		return ret;                                                    \
+	}                                                                      \
+	static DEVICE_ATTR_RW(target##n)
+
+static void remove_target(struct cxl_region *cxlr, int target)
+{
+	struct cxl_decoder *cxld;
+
+	mutex_lock(&cxlr->remove_lock);
+	cxld = cxlr->targets[target];
+	if (cxld) {
+		cxld->cxlr = NULL;
+		put_device(&cxld->dev);
+	}
+	cxlr->targets[target] = NULL;
+	mutex_unlock(&cxlr->remove_lock);
+}
 
 static void cxl_region_release(struct device *dev)
 {
 	struct cxl_decoder *cxld = to_cxl_decoder(dev->parent);
 	struct cxl_region *cxlr = to_cxl_region(dev);
+	int i;
 
 	dev_dbg(&cxld->dev, "Releasing %s\n", dev_name(dev));
 	ida_free(&cxld->region_ida, cxlr->id);
+	for (i = 0; i < cxlr->interleave_ways; i++)
+		remove_target(cxlr, i);
 	kfree(cxlr);
 	put_device(&cxld->dev);
 }
 
+static ssize_t show_interleave_ways(struct cxl_region *cxlr, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", cxlr->interleave_ways);
+}
+
+static ssize_t store_interleave_ways(struct cxl_region *cxlr, const char *buf,
+				     size_t len)
+{
+	struct cxl_decoder *rootd;
+	int ret, val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+	if (!cxlr->interleave_granularity) {
+		dev_dbg(&cxlr->dev, "IG must be set before IW\n");
+		return -ENXIO;
+	}
+	if (cxlr->interleave_ways)
+		return -EOPNOTSUPP;
+
+	rootd = to_cxl_decoder(cxlr->dev.parent);
+	if (!cxl_is_interleave_ways_valid(cxlr, rootd, val))
+		return -EINVAL;
+
+	cxlr->interleave_ways = val;
+
+	ret = sysfs_update_group(&cxlr->dev.kobj, &region_interleave_group);
+	if (ret < 0) {
+		cxlr->interleave_ways = 0;
+		return ret;
+	}
+
+	return len;
+}
+REGION_ATTR_RW(interleave_ways);
+
+static ssize_t show_interleave_granularity(struct cxl_region *cxlr, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", cxlr->interleave_granularity);
+}
+
+static ssize_t store_interleave_granularity(struct cxl_region *cxlr,
+					    const char *buf, size_t len)
+{
+	struct cxl_decoder *rootd;
+	int val, ret;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+	rootd = to_cxl_decoder(cxlr->dev.parent);
+	if (!cxl_is_interleave_granularity_valid(rootd, val))
+		return -EINVAL;
+
+	cxlr->interleave_granularity = val;
+
+	return len;
+}
+REGION_ATTR_RW(interleave_granularity);
+
+static ssize_t show_offset(struct cxl_region *cxlr, char *buf)
+{
+	if (!cxlr->res)
+		return sysfs_emit(buf, "\n");
+
+	return sysfs_emit(buf, "%pa\n", &cxlr->res->start);
+}
+REGION_ATTR_RO(offset);
+
+static ssize_t show_size(struct cxl_region *cxlr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n", cxlr->size);
+}
+
+static ssize_t store_size(struct cxl_region *cxlr, const char *buf, size_t len)
+{
+	unsigned long long val;
+	ssize_t rc;
+
+	rc = kstrtoull(buf, 0, &val);
+	if (rc)
+		return rc;
+
+	cxlr->size = val;
+	return len;
+}
+REGION_ATTR_RW(size);
+
+static ssize_t show_uuid(struct cxl_region *cxlr, char *buf)
+{
+	return sysfs_emit(buf, "%pUb\n", &cxlr->uuid);
+}
+
+static int is_dupe(struct device *match, void *_cxlr)
+{
+	struct cxl_region *c, *cxlr = _cxlr;
+
+	if (!is_cxl_region(match))
+		return 0;
+
+	if (&cxlr->dev == match)
+		return 0;
+
+	c = to_cxl_region(match);
+	if (uuid_equal(&c->uuid, &cxlr->uuid))
+		return -EEXIST;
+
+	return 0;
+}
+
+static ssize_t store_uuid(struct cxl_region *cxlr, const char *buf, size_t len)
+{
+	ssize_t rc;
+	uuid_t temp;
+
+	if (len != UUID_STRING_LEN + 1)
+		return -EINVAL;
+
+	rc = uuid_parse(buf, &temp);
+	if (rc)
+		return rc;
+
+	rc = bus_for_each_dev(&cxl_bus_type, NULL, cxlr, is_dupe);
+	if (rc < 0)
+		return false;
+
+	cxlr->uuid = temp;
+	return len;
+}
+REGION_ATTR_RW(uuid);
+
+static struct attribute *region_attrs[] = {
+	&dev_attr_interleave_ways.attr,
+	&dev_attr_interleave_granularity.attr,
+	&dev_attr_offset.attr,
+	&dev_attr_size.attr,
+	&dev_attr_uuid.attr,
+	NULL,
+};
+
+static const struct attribute_group region_group = {
+	.attrs = region_attrs,
+};
+
+static size_t show_targetN(struct cxl_region *cxlr, char *buf, int n)
+{
+	if (!cxlr->targets[n])
+		return sysfs_emit(buf, "\n");
+
+	return sysfs_emit(buf, "%s\n", dev_name(&cxlr->targets[n]->dev));
+}
+
+static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int n,
+			    size_t len)
+{
+	struct cxl_decoder *cxld;
+	struct device *cxld_dev;
+
+	if (len == 1 || cxlr->targets[n])
+		remove_target(cxlr, n);
+
+	/* Remove target special case */
+	if (len == 1) {
+		device_unlock(&cxlr->dev);
+		return len;
+	}
+
+	cxld_dev = bus_find_device_by_name(&cxl_bus_type, NULL, buf);
+	if (!cxld_dev)
+		return -ENOENT;
+
+	if (!is_cxl_decoder(cxld_dev)) {
+		put_device(cxld_dev);
+		return -EPERM;
+	}
+
+	if (!is_cxl_endpoint(to_cxl_port(cxld_dev->parent))) {
+		put_device(cxld_dev);
+		return -EINVAL;
+	}
+
+	/* decoder reference is held until teardown */
+	cxld = to_cxl_decoder(cxld_dev);
+	cxlr->targets[n] = cxld;
+	cxld->cxlr = cxlr;
+
+	return len;
+}
+
+TARGET_ATTR_RW(0);
+TARGET_ATTR_RW(1);
+TARGET_ATTR_RW(2);
+TARGET_ATTR_RW(3);
+TARGET_ATTR_RW(4);
+TARGET_ATTR_RW(5);
+TARGET_ATTR_RW(6);
+TARGET_ATTR_RW(7);
+TARGET_ATTR_RW(8);
+TARGET_ATTR_RW(9);
+TARGET_ATTR_RW(10);
+TARGET_ATTR_RW(11);
+TARGET_ATTR_RW(12);
+TARGET_ATTR_RW(13);
+TARGET_ATTR_RW(14);
+TARGET_ATTR_RW(15);
+
+static struct attribute *interleave_attrs[] = {
+	&dev_attr_target0.attr,
+	&dev_attr_target1.attr,
+	&dev_attr_target2.attr,
+	&dev_attr_target3.attr,
+	&dev_attr_target4.attr,
+	&dev_attr_target5.attr,
+	&dev_attr_target6.attr,
+	&dev_attr_target7.attr,
+	&dev_attr_target8.attr,
+	&dev_attr_target9.attr,
+	&dev_attr_target10.attr,
+	&dev_attr_target11.attr,
+	&dev_attr_target12.attr,
+	&dev_attr_target13.attr,
+	&dev_attr_target14.attr,
+	&dev_attr_target15.attr,
+	NULL,
+};
+
+static umode_t visible_targets(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	if (n < cxlr->interleave_ways)
+		return a->mode;
+	return 0;
+}
+
+static const struct attribute_group region_interleave_group = {
+	.attrs = interleave_attrs,
+	.is_visible = visible_targets,
+};
+
+static const struct attribute_group *region_groups[] = {
+	&region_group,
+	&region_interleave_group,
+	&cxl_base_attribute_group,
+	NULL,
+};
+
 static const struct device_type cxl_region_type = {
 	.name = "cxl_region",
 	.release = cxl_region_release,
+	.groups = region_groups
 };
 
-static struct cxl_region *to_cxl_region(struct device *dev)
+bool is_cxl_region(struct device *dev)
+{
+	return dev->type == &cxl_region_type;
+}
+EXPORT_SYMBOL_NS_GPL(is_cxl_region, CXL);
+
+struct cxl_region *to_cxl_region(struct device *dev)
 {
 	if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
 			  "not a cxl_region device\n"))
@@ -45,6 +387,7 @@ static struct cxl_region *to_cxl_region(struct device *dev)
 
 	return container_of(dev, struct cxl_region, dev);
 }
+EXPORT_SYMBOL_NS_GPL(to_cxl_region, CXL);
 
 static void unregister_region(struct work_struct *work)
 {
@@ -79,6 +422,8 @@ static struct cxl_region *cxl_region_alloc(struct cxl_decoder *cxld)
 		return ERR_PTR(-ENOMEM);
 	}
 
+	cxlr->id = cxld->next_region_id;
+
 	cxld->next_region_id = rc;
 
 	dev = &cxlr->dev;
@@ -88,6 +433,7 @@ static struct cxl_region *cxl_region_alloc(struct cxl_decoder *cxld)
 	dev->bus = &cxl_bus_type;
 	dev->type = &cxl_region_type;
 	INIT_WORK(&cxlr->unregister_work, unregister_region);
+	mutex_init(&cxlr->remove_lock);
 
 	return cxlr;
 }
@@ -118,7 +464,6 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_decoder *cxld)
 
 	dev = &cxlr->dev;
 
-	cxlr->id = cxld->next_region_id;
 	rc = dev_set_name(dev, "region%d.%d:%d", port->id, cxld->id, cxlr->id);
 	if (rc)
 		goto err_out;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index d5397f7dfcf4..26351ed0ba65 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -81,6 +81,19 @@ static inline int cxl_to_interleave_ways(u8 eniw)
 	}
 }
 
+static inline int cxl_from_ways(u8 ways)
+{
+	if (is_power_of_2(ways))
+		return ilog2(ways);
+
+	return ways / 3 + 8;
+}
+
+static inline int cxl_from_granularity(u16 g)
+{
+	return ilog2(g) - 8;
+}
+
 /* CXL 2.0 8.2.8.1 Device Capabilities Array Register */
 #define CXLDEV_CAP_ARRAY_OFFSET 0x0
 #define   CXLDEV_CAP_ARRAY_CAP_ID 0
@@ -223,6 +236,7 @@ enum cxl_decoder_type {
  * @target_lock: coordinate coherent reads of the target list
  * @region_ida: allocator for region ids.
  * @next_region_id: Cached region id for next region.
+ * @region: The region this decoder is associated with.
  * @nr_targets: number of elements in @target
  * @target: active ordered target list in current decoder configuration
  */
@@ -241,11 +255,11 @@ struct cxl_decoder {
 	struct mutex id_lock;
 	struct ida region_ida;
 	int next_region_id;
+	struct cxl_region *cxlr;
 	int nr_targets;
 	struct cxl_dport *target[];
 };
 
-
 /**
  * enum cxl_nvdimm_brige_state - state machine for managing bus rescans
  * @CXL_NVB_NEW: Set at bridge create and after cxl_pmem_wq is destroyed
diff --git a/drivers/cxl/region.h b/drivers/cxl/region.h
index 7025f6785f83..e78a049a5729 100644
--- a/drivers/cxl/region.h
+++ b/drivers/cxl/region.h
@@ -13,6 +13,14 @@
  * @id: This region's id. Id is globally unique across all regions.
  * @flags: Flags representing the current state of the region.
  * @unregister_work: Async unregister to allow attrs to take device_lock.
+ * @remove_lock: Coordinates region removal against decoder removal
+ * @list: Node in decoder's region list.
+ * @res: Resource this region carves out of the platform decode range.
+ * @size: Size of the region determined from LSA or userspace.
+ * @uuid: The UUID for this region.
+ * @interleave_ways: Number of interleave ways this region is configured for.
+ * @interleave_granularity: Interleave granularity of region
+ * @targets: The memory devices comprising the region.
  */
 struct cxl_region {
 	struct device dev;
@@ -20,9 +28,66 @@ struct cxl_region {
 	unsigned long flags;
 #define REGION_DEAD 0
 	struct work_struct unregister_work;
+	struct mutex remove_lock;
 
+	struct list_head list;
+	struct resource *res;
+
+	u64 size;
+	uuid_t uuid;
+	int interleave_ways;
+	int interleave_granularity;
+	struct cxl_decoder *targets[CXL_DECODER_MAX_INTERLEAVE];
 };
 
+bool is_cxl_region(struct device *dev);
+struct cxl_region *to_cxl_region(struct device *dev);
 bool schedule_cxl_region_unregister(struct cxl_region *cxlr);
 
+static inline bool cxl_is_interleave_ways_valid(const struct cxl_region *cxlr,
+						const struct cxl_decoder *rootd,
+						u8 ways)
+{
+	int root_ig, region_ig, root_eniw;
+
+	switch (ways) {
+	case 0 ... 4:
+	case 6:
+	case 8:
+	case 12:
+	case 16:
+		break;
+	default:
+		return false;
+	}
+
+	if (rootd->interleave_ways == 1)
+		return true;
+
+	root_ig = cxl_from_granularity(rootd->interleave_granularity);
+	region_ig = cxl_from_granularity(cxlr->interleave_granularity);
+	root_eniw = cxl_from_ways(rootd->interleave_ways);
+
+	return ((1 << (root_ig - region_ig)) * (1 << root_eniw)) <= ways;
+}
+
+static inline bool
+cxl_is_interleave_granularity_valid(const struct cxl_decoder *rootd, int ig)
+{
+	int rootd_hbig;
+
+	if (!is_power_of_2(ig))
+		return false;
+
+	/* 16K is the max */
+	if (ig >> 15)
+		return false;
+
+	rootd_hbig = cxl_from_granularity(rootd->interleave_granularity);
+	if (rootd_hbig < cxl_from_granularity(ig))
+		return false;
+
+	return true;
+}
+
 #endif
-- 
2.35.1

