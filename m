Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A5E3D6E
	for <patches@lists.linux.dev>; Wed, 16 Mar 2022 23:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647471801; x=1679007801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ntgvNKnP5SdlVeS55GoLo93G0RxPxxBQBHJ5YIpBFvE=;
  b=MN+83NCz9NAqgN3mIeTxv0tAvAHeiI+mwi/8WJdBtwYvmlcD5K90t00T
   m+K8rLxMcruGj7cJMt3hp9beVbmtJAsNgReKke8MULigSDmU33GGI66pC
   1X9JpbOWqphX642JDgiw8qkpXjdPFO3FaIegUpIrb6IPqJXJnG6hs5TMX
   FUNIRk0seqJCgNzl2ni2m4aBEQ2Ubc4CSdy4rzVhGGxj6TRI+9zsTU3lG
   HEk+yyK+w1eHUccr8HSh9N/u3qXoi3SyMDexIMckBOjsKBKA1Aui/bIvm
   YbztOJ+I56Zbtsyto9BsYw+Xe6i78YzYq2uSGH74n1GgrlLNX2vsbzDAK
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="238895936"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="238895936"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 16:03:17 -0700
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="498621407"
Received: from msimpso1-cxt.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.132.128])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 16:03:17 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 6/7] cxl/region: Add region creation ABI
Date: Wed, 16 Mar 2022 16:03:02 -0700
Message-Id: <20220316230303.1813397-7-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316230303.1813397-1-ben.widawsky@intel.com>
References: <20220316230303.1813397-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Regions are created as a child of the decoder that encompasses an
address space with constraints. Regions have a number of attributes that
must be configured before the region can be activated.

Multiple processes which are trying not to race with each other
shouldn't need special userspace synchronization to do so.

// Allocate a new region name
region=$(cat /sys/bus/cxl/devices/decoder0.0/create_pmem_region)

// Create a new region by name
while
region=$(cat /sys/bus/cxl/devices/decoder0.0/create_pmem_region)
! echo $region > /sys/bus/cxl/devices/decoder0.0/create_pmem_region
do true; done

// Region now exists in sysfs
stat -t /sys/bus/cxl/devices/decoder0.0/$region

// Delete the region, and name
echo $region > /sys/bus/cxl/devices/decoder0.0/delete_region

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>

---
Changes since v5 (all Dan):
- Fix erroneous return on create
- forward declare to_cxl_region instead of cxl_region_release
- Use REGION_DEAD in the right place
- Allocate next id in region_alloc
- Use memregion_alloc/free
- Remove port/decoder from region name
- Use simple integer for create/delete
- Update commit message (Dan)
- Make attr be called create_pmem_region (Dan)
---
 Documentation/ABI/testing/sysfs-bus-cxl       |  23 +
 .../driver-api/cxl/memory-devices.rst         |  11 +
 drivers/cxl/Kconfig                           |   5 +
 drivers/cxl/core/Makefile                     |   1 +
 drivers/cxl/core/port.c                       |  27 +-
 drivers/cxl/core/region.c                     | 586 +++++-------------
 drivers/cxl/cxl.h                             |   5 +
 drivers/cxl/region.h                          |  27 +
 tools/testing/cxl/Kbuild                      |   1 +
 9 files changed, 241 insertions(+), 445 deletions(-)
 create mode 100644 drivers/cxl/region.h

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 01fee09b8473..5229f4bd109a 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -174,3 +174,26 @@ Description:
 		Provide a knob to set/get whether the desired media is volatile
 		or persistent. This applies only to decoders of devtype
 		"cxl_decoder_endpoint",
+
+What:		/sys/bus/cxl/devices/decoderX.Y/create_pmem_region
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Write an integer value to instantiate a new region to be named
+		regionZ within the decode range bounded by decoderX.Y. Where X,
+		Y, and Z are unsigned integers, and where decoderX.Y exists in
+		the CXL sysfs topology. The value written must match the current
+		value returned from reading this attribute. This behavior lets
+		the kernel arbitrate racing attempts to create a region. The
+		thread that fails to write loops and tries the next value.
+		Regions must subsequently configured and bound to a region
+		driver before they can be used.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/delete_region
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Deletes the named region. The attribute expects a region number
+		as an integer.
diff --git a/Documentation/driver-api/cxl/memory-devices.rst b/Documentation/driver-api/cxl/memory-devices.rst
index db476bb170b6..66ddc58a21b1 100644
--- a/Documentation/driver-api/cxl/memory-devices.rst
+++ b/Documentation/driver-api/cxl/memory-devices.rst
@@ -362,6 +362,17 @@ CXL Core
 .. kernel-doc:: drivers/cxl/core/mbox.c
    :doc: cxl mbox
 
+CXL Regions
+-----------
+.. kernel-doc:: drivers/cxl/region.h
+   :identifiers:
+
+.. kernel-doc:: drivers/cxl/core/region.c
+   :doc: cxl core region
+
+.. kernel-doc:: drivers/cxl/core/region.c
+   :identifiers:
+
 External Interfaces
 ===================
 
diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
index 8796fd4b22bc..7ce86eee8bda 100644
--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -99,4 +99,9 @@ config CXL_PORT
 	default CXL_BUS
 	select DEVICE_PRIVATE
 
+config CXL_REGION
+	tristate
+	default CXL_BUS
+	select MEMREGION
+
 endif
diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index 6d37cd78b151..39ce8f2f2373 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_CXL_BUS) += cxl_core.o
 ccflags-y += -I$(srctree)/drivers/cxl
 cxl_core-y := port.o
 cxl_core-y += pmem.o
+cxl_core-y += region.o
 cxl_core-y += regs.o
 cxl_core-y += memdev.o
 cxl_core-y += mbox.o
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 89505de0843a..3916669e6f11 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2020 Intel Corporation. All rights reserved. */
 #include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/memregion.h>
 #include <linux/workqueue.h>
 #include <linux/genalloc.h>
 #include <linux/device.h>
@@ -11,6 +12,7 @@
 #include <linux/idr.h>
 #include <cxlmem.h>
 #include <cxlpci.h>
+#include <region.h>
 #include <cxl.h>
 #include "core.h"
 
@@ -368,6 +370,8 @@ static struct attribute_group cxl_decoder_base_attribute_group = {
 };
 
 static struct attribute *cxl_decoder_root_attrs[] = {
+	&dev_attr_create_pmem_region.attr,
+	&dev_attr_delete_region.attr,
 	&dev_attr_cap_pmem.attr,
 	&dev_attr_cap_ram.attr,
 	&dev_attr_cap_type2.attr,
@@ -426,6 +430,8 @@ static void cxl_decoder_release(struct device *dev)
 	struct cxl_decoder *cxld = to_cxl_decoder(dev);
 	struct cxl_port *port = to_cxl_port(dev->parent);
 
+	if (is_root_decoder(dev))
+		memregion_free(to_cxl_root_decoder(cxld)->next_region_id);
 	ida_free(&port->decoder_ida, cxld->id);
 	kfree(cxld);
 	put_device(&port->dev);
@@ -1545,12 +1551,21 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
 	device_set_pm_not_required(dev);
 	dev->parent = &port->dev;
 	dev->bus = &cxl_bus_type;
-	if (is_cxl_root(port))
+	if (is_cxl_root(port)) {
+		struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxld);
+
 		cxld->dev.type = &cxl_decoder_root_type;
-	else if (is_cxl_endpoint(port))
+		mutex_init(&cxlrd->id_lock);
+		rc = memregion_alloc(GFP_KERNEL);
+		if (rc < 0)
+			goto err;
+
+		cxlrd->next_region_id = rc;
+	} else if (is_cxl_endpoint(port)) {
 		cxld->dev.type = &cxl_decoder_endpoint_type;
-	else
+	} else {
 		cxld->dev.type = &cxl_decoder_switch_type;
+	}
 
 	/* Pre initialize an "empty" decoder */
 	cxld->interleave_ways = 1;
@@ -1828,6 +1843,12 @@ bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd)
 }
 EXPORT_SYMBOL_NS_GPL(schedule_cxl_memdev_detach, CXL);
 
+bool schedule_cxl_region_unregister(struct cxl_region *cxlr)
+{
+	return queue_work(cxl_bus_wq, &cxlr->detach_work);
+}
+EXPORT_SYMBOL_NS_GPL(schedule_cxl_region_unregister, CXL);
+
 /* for user tooling to ensure port disable work has completed */
 static ssize_t flush_store(struct bus_type *bus, const char *buf, size_t count)
 {
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index f0a821de94cf..52baa8c1526a 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1,417 +1,46 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright(c) 2021 Intel Corporation. All rights reserved. */
-#include <linux/io-64-nonatomic-lo-hi.h>
+/* Copyright(c) 2022 Intel Corporation. All rights reserved. */
+#include <linux/memregion.h>
 #include <linux/device.h>
 #include <linux/module.h>
-#include <linux/sizes.h>
 #include <linux/slab.h>
-#include <linux/uuid.h>
 #include <linux/idr.h>
 #include <region.h>
-#include <cxlmem.h>
 #include <cxl.h>
 #include "core.h"
 
-#include "core.h"
-
 /**
  * DOC: cxl core region
  *
- * Regions are managed through the Linux device model. Each region instance is a
- * unique struct device. CXL core provides functionality to create, destroy, and
- * configure regions. This is all implemented here. Binding a region
- * (programming the hardware) is handled by a separate region driver.
+ * CXL Regions represent mapped memory capacity in system physical address
+ * space. Whereas the CXL Root Decoders identify the bounds of potential CXL
+ * Memory ranges, Regions represent the active mapped capacity by the HDM
+ * Decoder Capability structures throughout the Host Bridges, Switches, and
+ * Endpoints in the topology.
  */
 
-struct cxl_region *to_cxl_region(struct device *dev);
-static const struct attribute_group region_interleave_group;
+static struct cxl_region *to_cxl_region(struct device *dev);
 
-static bool is_region_active(struct cxl_region *cxlr)
-{
-	return cxlr->active;
-}
-
-/*
- * Most sanity checking is left up to region binding. This does the most basic
- * check to determine whether or not the core should try probing the driver.
- */
-bool is_cxl_region_configured(const struct cxl_region *cxlr)
-{
-	/* zero sized regions aren't a thing. */
-	if (cxlr->config.size <= 0)
-		return false;
-
-	/* all regions have at least 1 target */
-	if (!cxlr->config.targets[0])
-		return false;
-
-	return true;
-}
-EXPORT_SYMBOL_GPL(is_cxl_region_configured);
-
-static void remove_target(struct cxl_region *cxlr, int target)
-{
-	struct cxl_memdev *cxlmd;
-
-	cxlmd = cxlr->config.targets[target];
-	if (cxlmd)
-		put_device(&cxlmd->dev);
-	cxlr->config.targets[target] = NULL;
-}
-
-static ssize_t interleave_ways_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
+static void cxl_region_release(struct device *dev)
 {
 	struct cxl_region *cxlr = to_cxl_region(dev);
 
-	return sysfs_emit(buf, "%d\n", cxlr->config.interleave_ways);
+	memregion_free(cxlr->id);
+	kfree(cxlr);
 }
 
-static ssize_t interleave_ways_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t len)
-{
-	struct cxl_region *cxlr = to_cxl_region(dev);
-	int ret, prev_iw;
-	int val;
-
-	prev_iw = cxlr->config.interleave_ways;
-	ret = kstrtoint(buf, 0, &val);
-	if (ret)
-		return ret;
-	if (ret < 0 || ret > CXL_DECODER_MAX_INTERLEAVE)
-		return -EINVAL;
-
-	cxlr->config.interleave_ways = val;
-
-	ret = sysfs_update_group(&dev->kobj, &region_interleave_group);
-	if (ret < 0)
-		goto err;
-
-	sysfs_notify(&dev->kobj, NULL, "target_interleave");
-
-	while (prev_iw > cxlr->config.interleave_ways)
-		remove_target(cxlr, --prev_iw);
-
-	return len;
-
-err:
-	cxlr->config.interleave_ways = prev_iw;
-	return ret;
-}
-static DEVICE_ATTR_RW(interleave_ways);
-
-static ssize_t interleave_granularity_show(struct device *dev,
-					   struct device_attribute *attr,
-					   char *buf)
-{
-	struct cxl_region *cxlr = to_cxl_region(dev);
-
-	return sysfs_emit(buf, "%d\n", cxlr->config.interleave_granularity);
-}
-
-static ssize_t interleave_granularity_store(struct device *dev,
-					    struct device_attribute *attr,
-					    const char *buf, size_t len)
-{
-	struct cxl_region *cxlr = to_cxl_region(dev);
-	int val, ret;
-
-	ret = kstrtoint(buf, 0, &val);
-	if (ret)
-		return ret;
-	cxlr->config.interleave_granularity = val;
-
-	return len;
-}
-static DEVICE_ATTR_RW(interleave_granularity);
-
-static ssize_t offset_show(struct device *dev, struct device_attribute *attr,
-			   char *buf)
-{
-	struct cxl_decoder *cxld = to_cxl_decoder(dev->parent);
-	struct cxl_region *cxlr = to_cxl_region(dev);
-	resource_size_t offset;
-
-	if (!cxlr->res)
-		return sysfs_emit(buf, "\n");
-
-	offset = cxld->platform_res.start - cxlr->res->start;
-
-	return sysfs_emit(buf, "%pa\n", &offset);
-}
-static DEVICE_ATTR_RO(offset);
-
-static ssize_t size_show(struct device *dev, struct device_attribute *attr,
-			 char *buf)
-{
-	struct cxl_region *cxlr = to_cxl_region(dev);
-
-	return sysfs_emit(buf, "%llu\n", cxlr->config.size);
-}
-
-static ssize_t size_store(struct device *dev, struct device_attribute *attr,
-			  const char *buf, size_t len)
-{
-	struct cxl_region *cxlr = to_cxl_region(dev);
-	unsigned long long val;
-	ssize_t rc;
-
-	rc = kstrtoull(buf, 0, &val);
-	if (rc)
-		return rc;
-
-	device_lock(&cxlr->dev);
-	if (is_region_active(cxlr))
-		rc = -EBUSY;
-	else
-		cxlr->config.size = val;
-	device_unlock(&cxlr->dev);
-
-	return rc ? rc : len;
-}
-static DEVICE_ATTR_RW(size);
-
-static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
-			 char *buf)
-{
-	struct cxl_region *cxlr = to_cxl_region(dev);
-
-	return sysfs_emit(buf, "%pUb\n", &cxlr->config.uuid);
-}
-
-static ssize_t uuid_store(struct device *dev, struct device_attribute *attr,
-			  const char *buf, size_t len)
-{
-	struct cxl_region *cxlr = to_cxl_region(dev);
-	ssize_t rc;
-
-	if (len != UUID_STRING_LEN + 1)
-		return -EINVAL;
-
-	device_lock(&cxlr->dev);
-	if (is_region_active(cxlr))
-		rc = -EBUSY;
-	else
-		rc = uuid_parse(buf, &cxlr->config.uuid);
-	device_unlock(&cxlr->dev);
-
-	return rc ? rc : len;
-}
-static DEVICE_ATTR_RW(uuid);
-
-static struct attribute *region_attrs[] = {
-	&dev_attr_interleave_ways.attr,
-	&dev_attr_interleave_granularity.attr,
-	&dev_attr_offset.attr,
-	&dev_attr_size.attr,
-	&dev_attr_uuid.attr,
-	NULL,
-};
-
-static const struct attribute_group region_group = {
-	.attrs = region_attrs,
-};
-
-static size_t show_targetN(struct cxl_region *cxlr, char *buf, int n)
-{
-	int ret;
-
-	device_lock(&cxlr->dev);
-	if (!cxlr->config.targets[n])
-		ret = sysfs_emit(buf, "\n");
-	else
-		ret = sysfs_emit(buf, "%s\n",
-				 dev_name(&cxlr->config.targets[n]->dev));
-	device_unlock(&cxlr->dev);
-
-	return ret;
-}
-
-static size_t set_targetN(struct cxl_region *cxlr, const char *buf, int n,
-			  size_t len)
-{
-	struct device *memdev_dev;
-	struct cxl_memdev *cxlmd;
-
-	device_lock(&cxlr->dev);
-
-	if (len == 1 || cxlr->config.targets[n])
-		remove_target(cxlr, n);
-
-	/* Remove target special case */
-	if (len == 1) {
-		device_unlock(&cxlr->dev);
-		return len;
-	}
-
-	memdev_dev = bus_find_device_by_name(&cxl_bus_type, NULL, buf);
-	if (!memdev_dev) {
-		device_unlock(&cxlr->dev);
-		return -ENOENT;
-	}
-
-	/* reference to memdev held until target is unset or region goes away */
-
-	cxlmd = to_cxl_memdev(memdev_dev);
-	cxlr->config.targets[n] = cxlmd;
-
-	device_unlock(&cxlr->dev);
-
-	return len;
-}
-
-#define TARGET_ATTR_RW(n)                                                      \
-	static ssize_t target##n##_show(                                       \
-		struct device *dev, struct device_attribute *attr, char *buf)  \
-	{                                                                      \
-		return show_targetN(to_cxl_region(dev), buf, (n));             \
-	}                                                                      \
-	static ssize_t target##n##_store(struct device *dev,                   \
-					 struct device_attribute *attr,        \
-					 const char *buf, size_t len)          \
-	{                                                                      \
-		return set_targetN(to_cxl_region(dev), buf, (n), len);         \
-	}                                                                      \
-	static DEVICE_ATTR_RW(target##n)
-
-TARGET_ATTR_RW(0);
-TARGET_ATTR_RW(1);
-TARGET_ATTR_RW(2);
-TARGET_ATTR_RW(3);
-TARGET_ATTR_RW(4);
-TARGET_ATTR_RW(5);
-TARGET_ATTR_RW(6);
-TARGET_ATTR_RW(7);
-TARGET_ATTR_RW(8);
-TARGET_ATTR_RW(9);
-TARGET_ATTR_RW(10);
-TARGET_ATTR_RW(11);
-TARGET_ATTR_RW(12);
-TARGET_ATTR_RW(13);
-TARGET_ATTR_RW(14);
-TARGET_ATTR_RW(15);
-
-static struct attribute *interleave_attrs[] = {
-	&dev_attr_target0.attr,
-	&dev_attr_target1.attr,
-	&dev_attr_target2.attr,
-	&dev_attr_target3.attr,
-	&dev_attr_target4.attr,
-	&dev_attr_target5.attr,
-	&dev_attr_target6.attr,
-	&dev_attr_target7.attr,
-	&dev_attr_target8.attr,
-	&dev_attr_target9.attr,
-	&dev_attr_target10.attr,
-	&dev_attr_target11.attr,
-	&dev_attr_target12.attr,
-	&dev_attr_target13.attr,
-	&dev_attr_target14.attr,
-	&dev_attr_target15.attr,
-	NULL,
-};
-
-static umode_t visible_targets(struct kobject *kobj, struct attribute *a, int n)
-{
-	struct device *dev = container_of(kobj, struct device, kobj);
-	struct cxl_region *cxlr = to_cxl_region(dev);
-
-	if (n < cxlr->config.interleave_ways)
-		return a->mode;
-	return 0;
-}
-
-static const struct attribute_group region_interleave_group = {
-	.attrs = interleave_attrs,
-	.is_visible = visible_targets,
-};
-
-static const struct attribute_group *region_groups[] = {
-	&cxl_base_attribute_group,	
-	&region_group,
-	&region_interleave_group,
-	NULL,
-};
-
-static void cxl_region_release(struct device *dev);
-
-const struct device_type cxl_region_type = {
+static const struct device_type cxl_region_type = {
 	.name = "cxl_region",
 	.release = cxl_region_release,
-	.groups = region_groups
 };
 
-static ssize_t create_region_show(struct device *dev,
-				  struct device_attribute *attr, char *buf)
+bool is_cxl_region(struct device *dev)
 {
-	struct cxl_port *port = to_cxl_port(dev->parent);
-	struct cxl_decoder *cxld = to_cxl_decoder(dev);
-	int rc;
-
-	if (dev_WARN_ONCE(dev, !is_root_decoder(dev),
-			  "Invalid decoder selected for region.")) {
-		return -ENODEV;
-	}
-
-	rc = ida_alloc(&cxld->region_ida, GFP_KERNEL);
-	if (rc < 0) {
-		dev_err(&cxld->dev, "Couldn't get a new id\n");
-		return rc;
-	}
-
-	return sysfs_emit(buf, "region%d.%d:%d\n", port->id, cxld->id, rc);
+	return dev->type == &cxl_region_type;
 }
+EXPORT_SYMBOL_NS_GPL(is_cxl_region, CXL);
 
-static ssize_t create_region_store(struct device *dev,
-				   struct device_attribute *attr,
-				   const char *buf, size_t len)
-{
-	struct cxl_port *port = to_cxl_port(dev->parent);
-	struct cxl_decoder *cxld = to_cxl_decoder(dev);
-	int decoder_id, port_id, region_id;
-	struct cxl_region *cxlr;
-	ssize_t rc;
-
-	if (sscanf(buf, "region%d.%d:%d", &port_id, &decoder_id, &region_id) != 3)
-		return -EINVAL;
-
-	if (decoder_id != cxld->id)
-		return -EINVAL;
-
-	if (port_id != port->id)
-		return -EINVAL;
-
-	cxlr = cxl_alloc_region(cxld, region_id);
-	if (IS_ERR(cxlr))
-		return PTR_ERR(cxlr);
-
-	rc = cxl_add_region(cxld, cxlr);
-	if (rc) {
-		kfree(cxlr);
-		return rc;
-	}
-
-	return len;
-}
-DEVICE_ATTR_RW(create_region);
-
-static ssize_t delete_region_store(struct device *dev,
-				   struct device_attribute *attr,
-				   const char *buf, size_t len)
-{
-	struct cxl_decoder *cxld = to_cxl_decoder(dev);
-	int rc;
-
-	rc = cxl_delete_region(cxld, buf);
-	if (rc)
-		return rc;
-
-	return len;
-}
-DEVICE_ATTR_WO(delete_region);
-
-struct cxl_region *to_cxl_region(struct device *dev)
+static struct cxl_region *to_cxl_region(struct device *dev)
 {
 	if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
 			  "not a cxl_region device\n"))
@@ -419,39 +48,58 @@ struct cxl_region *to_cxl_region(struct device *dev)
 
 	return container_of(dev, struct cxl_region, dev);
 }
-EXPORT_SYMBOL_GPL(to_cxl_region);
 
-static void cxl_region_release(struct device *dev)
-{
-	struct cxl_decoder *cxld = to_cxl_decoder(dev->parent);
-	struct cxl_region *cxlr = to_cxl_region(dev);
-	int i;
-
-	ida_free(&cxld->region_ida, cxlr->id);
-	for (i = 0; i < cxlr->config.interleave_ways; i++)
-		remove_target(cxlr, i);
-	kfree(cxlr);
-}
-
-struct cxl_region *cxl_alloc_region(struct cxl_decoder *cxld, int id)
+static void unregister_region(struct work_struct *work)
 {
 	struct cxl_region *cxlr;
 
-	cxlr = kzalloc(sizeof(*cxlr), GFP_KERNEL);
-	if (!cxlr)
-		return ERR_PTR(-ENOMEM);
+	cxlr = container_of(work, typeof(*cxlr), detach_work);
+	device_unregister(&cxlr->dev);
+}
 
-	INIT_LIST_HEAD(&cxlr->staged_list);
-	INIT_LIST_HEAD(&cxlr->commit_list);
-	cxlr->id = id;
+static void schedule_unregister(void *cxlr)
+{
+	schedule_cxl_region_unregister(cxlr);
+}
+
+static struct cxl_region *cxl_region_alloc(struct cxl_decoder *cxld)
+{
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxld);
+	struct cxl_region *cxlr;
+	struct device *dev;
+	int rc;
+
+	lockdep_assert_held(&cxlrd->id_lock);
+
+	rc = memregion_alloc(GFP_KERNEL);
+	if (rc < 0) {
+		dev_dbg(dev, "Failed to get next cached id (%d)\n", rc);
+		return ERR_PTR(rc);
+	}
+
+	cxlr = kzalloc(sizeof(*cxlr), GFP_KERNEL);
+	if (!cxlr) {
+		memregion_free(rc);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	cxlr->id = cxlrd->next_region_id;
+	cxlrd->next_region_id = rc;
+
+	dev = &cxlr->dev;
+	device_initialize(dev);
+	dev->parent = &cxld->dev;
+	device_set_pm_not_required(dev);
+	dev->bus = &cxl_bus_type;
+	dev->type = &cxl_region_type;
+	INIT_WORK(&cxlr->detach_work, unregister_region);
 
 	return cxlr;
 }
 
 /**
- * cxl_add_region - Adds a region to a decoder
+ * devm_cxl_add_region - Adds a region to a decoder
  * @cxld: Parent decoder.
- * @cxlr: Region to be added to the decoder.
  *
  * This is the second step of region initialization. Regions exist within an
  * address space which is mapped by a @cxld. That @cxld must be a root decoder,
@@ -461,35 +109,98 @@ struct cxl_region *cxl_alloc_region(struct cxl_decoder *cxld, int id)
  * code. The region will be named "regionX.Y.Z" where X is the port, Y is the
  * decoder id, and Z is the region number.
  */
-int cxl_add_region(struct cxl_decoder *cxld, struct cxl_region *cxlr)
+static struct cxl_region *devm_cxl_add_region(struct cxl_decoder *cxld)
 {
 	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
-	struct device *dev = &cxlr->dev;
+	struct cxl_region *cxlr;
+	struct device *dev;
 	int rc;
 
-	device_initialize(dev);
-	dev->parent = &cxld->dev;
-	device_set_pm_not_required(dev);
-	dev->bus = &cxl_bus_type;
-	dev->type = &cxl_region_type;
-	rc = dev_set_name(dev, "region%d.%d:%d", port->id, cxld->id, cxlr->id);
+	cxlr = cxl_region_alloc(cxld);
+	if (IS_ERR(cxlr))
+		return cxlr;
+
+	dev = &cxlr->dev;
+
+	rc = dev_set_name(dev, "region%d", cxlr->id);
 	if (rc)
-		goto err;
+		goto err_out;
 
 	cxl_set_lock_class(dev);
 	rc = device_add(dev);
 	if (rc)
-		goto err;
+		goto err_put;
 
-	dev_dbg(dev, "Added to %s\n", dev_name(&cxld->dev));
+	rc = devm_add_action_or_reset(port->uport, schedule_unregister, cxlr);
+	if (rc)
+		goto err_put;
 
-	return 0;
+	return cxlr;
 
-err:
+err_put:
+	put_device(&cxld->dev);
+
+err_out:
 	put_device(dev);
+	return ERR_PTR(rc);
+}
+
+static ssize_t create_pmem_region_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxld);
+	size_t rc;
+
+	/*
+	 * There's no point in returning known bad answers when the lock is held
+	 * on the store side, even though the answer given here may be
+	 * immediately invalidated as soon as the lock is dropped it's still
+	 * useful to throttle readers in the presence of writers.
+	 */
+	rc = mutex_lock_interruptible(&cxlrd->id_lock);
+	if (rc)
+		return rc;
+	rc = sysfs_emit(buf, "%d\n", cxlrd->next_region_id);
+	mutex_unlock(&cxlrd->id_lock);
+
 	return rc;
 }
 
+static ssize_t create_pmem_region_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxld);
+	struct cxl_region *cxlr;
+	size_t id, rc;
+
+	rc = kstrtoul(buf, 10, &id);
+	if (rc)
+		return rc;
+
+	rc = mutex_lock_interruptible(&cxlrd->id_lock);
+	if (rc)
+		return rc;
+
+	if (cxlrd->next_region_id != id) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	cxlr = devm_cxl_add_region(cxld);
+	rc = 0;
+	dev_dbg(dev, "Created %s\n", dev_name(&cxlr->dev));
+
+out:
+	mutex_unlock(&cxlrd->id_lock);
+	if (rc)
+		return rc;
+	return len;
+}
+DEVICE_ATTR_RW(create_pmem_region);
+
 static struct cxl_region *cxl_find_region_by_name(struct cxl_decoder *cxld,
 						  const char *name)
 {
@@ -502,30 +213,21 @@ static struct cxl_region *cxl_find_region_by_name(struct cxl_decoder *cxld,
 	return to_cxl_region(region_dev);
 }
 
-/**
- * cxl_delete_region - Deletes a region
- * @cxld: Parent decoder
- * @region_name: Named region, ie. regionX.Y:Z
- */
-int cxl_delete_region(struct cxl_decoder *cxld, const char *region_name)
+static ssize_t delete_region_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t len)
 {
+	struct cxl_port *port = to_cxl_port(dev->parent);
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
 	struct cxl_region *cxlr;
 
-	device_lock(&cxld->dev);
-
-	cxlr = cxl_find_region_by_name(cxld, region_name);
-	if (IS_ERR(cxlr)) {
-		device_unlock(&cxld->dev);
+	cxlr = cxl_find_region_by_name(cxld, buf);
+	if (IS_ERR(cxlr))
 		return PTR_ERR(cxlr);
-	}
 
-	dev_dbg(&cxld->dev, "Requested removal of %s from %s\n",
-		dev_name(&cxlr->dev), dev_name(&cxld->dev));
+	/* Reference held for wq */
+	devm_release_action(port->uport, schedule_unregister, cxlr);
 
-	device_unregister(&cxlr->dev);
-	device_unlock(&cxld->dev);
-
-	put_device(&cxlr->dev);
-
-	return 0;
+	return len;
 }
+DEVICE_ATTR_WO(delete_region);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 8944d0fdd58a..1631b0aeca85 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -491,6 +491,8 @@ struct cxl_hdm *devm_cxl_setup_hdm(struct cxl_port *port);
 int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm);
 int devm_cxl_add_passthrough_decoder(struct cxl_port *port);
 
+bool is_cxl_region(struct device *dev);
+
 extern struct bus_type cxl_bus_type;
 
 struct cxl_driver {
@@ -545,6 +547,7 @@ enum cxl_lock_class {
 	CXL_ROOT_LOCK,
 	CXL_NVDIMM_LOCK,
 	CXL_NVDIMM_BRIDGE_LOCK,
+	CXL_REGION_LOCK,
 	CXL_PORT_LOCK = 2,
 	/*
 	 * Be careful to add new lock classes here, CXL_PORT_LOCK is
@@ -585,6 +588,8 @@ static inline int cxl_lock_class(struct device *dev)
 		return CXL_NVDIMM_BRIDGE_LOCK;
 	else if (is_cxl_nvdimm(dev))
 		return CXL_NVDIMM_LOCK;
+	else if (is_cxl_region(dev))
+		return CXL_REGION_LOCK;
 	else
 		return CXL_ANON_LOCK;
 }
diff --git a/drivers/cxl/region.h b/drivers/cxl/region.h
new file mode 100644
index 000000000000..6a0118dcdf2f
--- /dev/null
+++ b/drivers/cxl/region.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2021 Intel Corporation. */
+#ifndef __CXL_REGION_H__
+#define __CXL_REGION_H__
+
+#include <linux/uuid.h>
+
+#include "cxl.h"
+
+/**
+ * struct cxl_region - CXL region
+ * @dev: This region's device.
+ * @id: This region's id. Id is globally unique across all regions.
+ * @flags: Flags representing the current state of the region.
+ * @detach_work: Async unregister to allow attrs to take device_lock.
+ */
+struct cxl_region {
+	struct device dev;
+	int id;
+	unsigned long flags;
+#define REGION_DEAD 0
+	struct work_struct detach_work;
+};
+
+bool schedule_cxl_region_unregister(struct cxl_region *cxlr);
+
+#endif
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 82e49ab0937d..3fe6d34e6d59 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -46,6 +46,7 @@ cxl_core-y += $(CXL_CORE_SRC)/memdev.o
 cxl_core-y += $(CXL_CORE_SRC)/mbox.o
 cxl_core-y += $(CXL_CORE_SRC)/pci.o
 cxl_core-y += $(CXL_CORE_SRC)/hdm.o
+cxl_core-y += $(CXL_CORE_SRC)/region.o
 cxl_core-y += config_check.o
 
 obj-m += test/
-- 
2.35.1

