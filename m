Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752E13D6B
	for <patches@lists.linux.dev>; Wed, 16 Mar 2022 23:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647471801; x=1679007801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pVuifyKJmLAnfsPY+9wV8c+rrzVGz18sO6H1e91/mw4=;
  b=ha2ktpiaQbG7WZNutLnWty8ku9R6XlyB7ejZPBdptMAXCjfQQHP+rdw/
   CtMMu1OmRDUrvLX62+CTPgLTXCG4caHBVQf8MKWg9SMVx8wK8qb2xXMdN
   Pmh8N3WVT4M5QOE3ONcIYfacU49eUGhqfKAxcNcPJLIwCHooSvj1hAjKb
   OraSRqRjMvmvkqeXiw2WnJP/SfUJngnSDjtoCV7YFhhmTPcxDXX06j6Yo
   QkXRzbbZbXTj7wtt8PeT9tl0JbceuWSWbsDSlMgo2b/YAMFPBnEzvhV/8
   6dSXl++FhDtn3MbY+E3x6B4pjItBrQhbYV89BLFUNaefNuvQeAkLuT0yl
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="238895937"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="238895937"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 16:03:18 -0700
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="498621413"
Received: from msimpso1-cxt.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.132.128])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 16:03:17 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	kernel test robot <lkp@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 7/7] cxl/region: Introduce concept of region configuration
Date: Wed, 16 Mar 2022 16:03:03 -0700
Message-Id: <20220316230303.1813397-8-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316230303.1813397-1-ben.widawsky@intel.com>
References: <20220316230303.1813397-1-ben.widawsky@intel.com>
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
---
 Documentation/ABI/testing/sysfs-bus-cxl |  55 ++++
 drivers/cxl/core/port.c                 |  33 ++-
 drivers/cxl/core/region.c               | 357 +++++++++++++++++++++++-
 drivers/cxl/cxl.h                       |  16 ++
 drivers/cxl/region.h                    |  66 +++++
 5 files changed, 516 insertions(+), 11 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 5229f4bd109a..fe9f8d3a1fc8 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -197,3 +197,58 @@ Contact:	linux-cxl@vger.kernel.org
 Description:
 		Deletes the named region. The attribute expects a region number
 		as an integer.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/resource
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		A region is a contiguous partition of a CXL Root decoder address
+		space. Region capacity is allocated by writing to the size
+		attribute, the resulting physical address base determined by the
+		driver is reflected here.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/size
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		System physical address space to be consumed by the region.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/interleave_ways
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Configures the number of devices participating in the region is
+		set by writing this value. Each device will provide
+		1/interleave_ways of storage for the region.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/interleave_granularity
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Set the number of consecutive bytes each device in the
+		interleave set will claim. The possible interleave granularity
+		values are determined by the CXL spec and the participating
+		devices.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/uuid
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Write a unique identifier for the region. This field must be set
+		for persistent regions and it must not conflict with the UUID of
+		another region. If this field is set for volatile regions, the
+		value is ignored.
+
+What: /sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/endpoint_decoder[0..interleave_ways]
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Write a decoder object that is unused and will participate in
+		decoding memory transactions for the interleave set, ie.
+		decoderX.Y. All attributes must be populated.
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 3916669e6f11..cfeff49f6b66 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -216,6 +216,15 @@ static ssize_t size_store(struct device *dev, struct device_attribute *attr,
 	mutex_unlock(&cxled->res_lock);
 	return rc ? rc : len;
 }
+
+static ssize_t size_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct range r = cxl_get_decoder_extent(cxld);
+
+	return sysfs_emit(buf, "%#llx\n", range_len(&r));
+}
 static DEVICE_ATTR_RW(size);
 
 static ssize_t volatile_show(struct device *dev, struct device_attribute *attr,
@@ -1734,18 +1743,24 @@ EXPORT_SYMBOL_NS_GPL(cxl_decoder_add, CXL);
 static void cxld_unregister(void *dev)
 {
 	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct cxl_endpoint_decoder *cxled;
+	struct cxl_port *ep;
 
-	if (is_endpoint_decoder(&cxld->dev)) {
-		struct cxl_endpoint_decoder *cxled =
-			to_cxl_endpoint_decoder(cxld);
-		struct cxl_port *ep = to_cxl_port(cxld->dev.parent);
+	if (!is_endpoint_decoder(&cxld->dev))
+		goto out;
 
-		if (!range_len(&cxled->drange))
-			goto out;
+	cxled = to_cxl_endpoint_decoder(cxld);
+	ep = to_cxl_port(cxld->dev.parent);
 
-		gen_pool_free(ep->media, cxled->drange.start,
-			      range_len(&cxled->drange));
-	}
+	if (!range_len(&cxled->drange))
+		goto out;
+
+	gen_pool_free(ep->media, cxled->drange.start,
+		      range_len(&cxled->drange));
+
+	mutex_lock(&cxled->cxlr->remove_lock);
+	device_release_driver(&cxled->cxlr->dev);
+	mutex_unlock(&cxled->cxlr->remove_lock);
 
 out:
 	device_unregister(dev);
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 52baa8c1526a..9c1a581b7035 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3,9 +3,12 @@
 #include <linux/memregion.h>
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
 
@@ -17,21 +20,369 @@
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
+static void remove_target(struct cxl_region *cxlr, int target)
+{
+	struct cxl_endpoint_decoder *cxled;
+
+	mutex_lock(&cxlr->remove_lock);
+	cxled = cxlr->targets[target];
+	if (cxled) {
+		cxled->cxlr = NULL;
+		put_device(&cxled->base.dev);
+	}
+	cxlr->targets[target] = NULL;
+	mutex_unlock(&cxlr->remove_lock);
+}
 
 static void cxl_region_release(struct device *dev)
 {
 	struct cxl_region *cxlr = to_cxl_region(dev);
+	int i;
 
 	memregion_free(cxlr->id);
+	for (i = 0; i < cxlr->interleave_ways; i++)
+		remove_target(cxlr, i);
 	kfree(cxlr);
 }
 
+static ssize_t interleave_ways_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	return sysfs_emit(buf, "%d\n", cxlr->interleave_ways);
+}
+
+static ssize_t interleave_ways_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_decoder *rootd;
+	int rc, val;
+
+	rc = kstrtoint(buf, 0, &val);
+	if (rc)
+		return rc;
+
+	if (device_lock_interruptible(dev) < 0)
+		return -EINTR;
+
+	if (dev->driver) {
+		device_unlock(dev);
+		return -EBUSY;
+	}
+
+	if (cxlr->interleave_ways) {
+		device_unlock(dev);
+		return -EEXIST;
+	}
+
+	if (!cxlr->interleave_granularity) {
+		dev_dbg(&cxlr->dev, "IG must be set before IW\n");
+		device_unlock(dev);
+		return -EILSEQ;
+	}
+
+	rootd = to_cxl_decoder(cxlr->dev.parent);
+	if (!cxl_is_interleave_ways_valid(cxlr, rootd, val)) {
+		device_unlock(dev);
+		return -EINVAL;
+	}
+
+	cxlr->interleave_ways = val;
+	device_unlock(dev);
+
+	rc = sysfs_update_group(&cxlr->dev.kobj, &region_interleave_group);
+	if (rc < 0) {
+		cxlr->interleave_ways = 0;
+		return rc;
+	}
+
+	return len;
+}
+static DEVICE_ATTR_RW(interleave_ways);
+
+static ssize_t interleave_granularity_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	return sysfs_emit(buf, "%d\n", cxlr->interleave_granularity);
+}
+
+static ssize_t interleave_granularity_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t len)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_decoder *rootd;
+	int val, ret;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (device_lock_interruptible(dev) < 0)
+		return -EINTR;
+
+	if (dev->driver) {
+		device_unlock(dev);
+		return -EBUSY;
+	}
+
+	if (cxlr->interleave_granularity) {
+		device_unlock(dev);
+		return -EEXIST;
+	}
+
+	rootd = to_cxl_decoder(cxlr->dev.parent);
+	if (!cxl_is_interleave_granularity_valid(rootd, val)) {
+		device_unlock(dev);
+		return -EINVAL;
+	}
+
+	cxlr->interleave_granularity = val;
+	device_unlock(dev);
+
+	return len;
+}
+static DEVICE_ATTR_RW(interleave_granularity);
+
+static ssize_t offset_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	if (!cxlr->res)
+		return sysfs_emit(buf, "\n");
+
+	return sysfs_emit(buf, "%pa\n", &cxlr->res->start);
+}
+static DEVICE_ATTR_RO(offset);
+
+static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
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
+static ssize_t uuid_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t len)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
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
+	if (device_lock_interruptible(dev) < 0)
+		return -EINTR;
+
+	if (dev->driver) {
+		device_unlock(dev);
+		return -EBUSY;
+	}
+
+	if (!uuid_is_null(&cxlr->uuid)) {
+		device_unlock(dev);
+		return -EEXIST;
+	}
+
+	rc = bus_for_each_dev(&cxl_bus_type, NULL, cxlr, is_dupe);
+	if (rc < 0) {
+		device_unlock(dev);
+		return false;
+	}
+
+	cxlr->uuid = temp;
+	device_unlock(dev);
+	return len;
+}
+static DEVICE_ATTR_RW(uuid);
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
+	return sysfs_emit(buf, "%s\n", dev_name(&cxlr->targets[n]->base.dev));
+}
+
+static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int n,
+			    size_t len)
+{
+	struct cxl_endpoint_decoder *cxled;
+	struct cxl_decoder *cxld;
+	struct device *cxld_dev;
+
+	if (device_lock_interruptible(&cxlr->dev) < 0)
+		return -EINTR;
+
+	if (cxlr->dev.driver) {
+		device_unlock(&cxlr->dev);
+		return -EBUSY;
+	}
+
+	if (cxlr->targets[n]) {
+		device_unlock(&cxlr->dev);
+		return -EEXIST;
+	}
+
+	cxld_dev = bus_find_device_by_name(&cxl_bus_type, NULL, buf);
+	if (!cxld_dev)
+		return -ENOENT;
+
+	if (!is_cxl_decoder(cxld_dev)) {
+		put_device(cxld_dev);
+		return -EINVAL;
+	}
+
+	if (!is_cxl_endpoint(to_cxl_port(cxld_dev->parent))) {
+		put_device(cxld_dev);
+		return -EINVAL;
+	}
+
+	cxld = to_cxl_decoder(cxld_dev);
+	if (cxld->flags & CXL_DECODER_F_ENABLE) {
+		put_device(cxld_dev);
+		return -EBUSY;
+	}
+
+	/* decoder reference is held until teardown */
+	cxled = to_cxl_endpoint_decoder(cxld);
+	cxlr->targets[n] = cxled;
+	cxled->cxlr = cxlr;
+
+	return len;
+}
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
+		return store_targetN(to_cxl_region(dev), buf, (n), len);       \
+	}                                                                      \
+	static DEVICE_ATTR_RW(target##n)
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
 
 bool is_cxl_region(struct device *dev)
@@ -40,7 +391,7 @@ bool is_cxl_region(struct device *dev)
 }
 EXPORT_SYMBOL_NS_GPL(is_cxl_region, CXL);
 
-static struct cxl_region *to_cxl_region(struct device *dev)
+struct cxl_region *to_cxl_region(struct device *dev)
 {
 	if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
 			  "not a cxl_region device\n"))
@@ -48,6 +399,7 @@ static struct cxl_region *to_cxl_region(struct device *dev)
 
 	return container_of(dev, struct cxl_region, dev);
 }
+EXPORT_SYMBOL_NS_GPL(to_cxl_region, CXL);
 
 static void unregister_region(struct work_struct *work)
 {
@@ -93,6 +445,7 @@ static struct cxl_region *cxl_region_alloc(struct cxl_decoder *cxld)
 	dev->bus = &cxl_bus_type;
 	dev->type = &cxl_region_type;
 	INIT_WORK(&cxlr->detach_work, unregister_region);
+	mutex_init(&cxlr->remove_lock);
 
 	return cxlr;
 }
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 1631b0aeca85..fffe85764aae 100644
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
@@ -250,6 +263,7 @@ struct cxl_decoder {
  * @skip: The skip count as specified in the CXL specification.
  * @res_lock: Synchronize device's resource usage
  * @volatil: Configuration param. Decoder target is non-persistent mem
+ * @cxlr: Region this decoder belongs to.
  */
 struct cxl_endpoint_decoder {
 	struct cxl_decoder base;
@@ -258,6 +272,7 @@ struct cxl_endpoint_decoder {
 	u64 skip;
 	struct mutex res_lock; /* sync access to decoder's resource */
 	bool volatil;
+	struct cxl_region *cxlr;
 };
 
 /**
@@ -286,6 +301,7 @@ struct cxl_root_decoder {
 	struct cxl_decoder_targets *targets;
 	int next_region_id;
 	struct mutex id_lock; /* synchronizes access to next_region_id */
+	struct list_head regions;
 };
 
 #define _to_cxl_decoder(x)                                                     \
diff --git a/drivers/cxl/region.h b/drivers/cxl/region.h
index 6a0118dcdf2f..4bc8e2529890 100644
--- a/drivers/cxl/region.h
+++ b/drivers/cxl/region.h
@@ -13,6 +13,14 @@
  * @id: This region's id. Id is globally unique across all regions.
  * @flags: Flags representing the current state of the region.
  * @detach_work: Async unregister to allow attrs to take device_lock.
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
@@ -20,8 +28,66 @@ struct cxl_region {
 	unsigned long flags;
 #define REGION_DEAD 0
 	struct work_struct detach_work;
+	struct mutex remove_lock; /* serialize region removal */
+
+	struct list_head list;
+	struct resource *res;
+
+	u64 size;
+	uuid_t uuid;
+	int interleave_ways;
+	int interleave_granularity;
+	struct cxl_endpoint_decoder *targets[CXL_DECODER_MAX_INTERLEAVE];
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

