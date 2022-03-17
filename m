Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C854ABB
	for <patches@lists.linux.dev>; Thu, 17 Mar 2022 23:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647559773; x=1679095773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N961zsMG5VRJiLz/5iAlWFNennMk3xxojxob0qljJ/w=;
  b=jPQPLaXWTXX6LImY3htAUM/wI5O+6kdPuzg7KDk67IYnYYZgXFI1e3QC
   JpqNXO+Wo/D/L8fkryYJ8NaL/FiQXYwRC/1WFfxgTkjzX4R2s7nI5Fx/Q
   B1LhB1EQhlpV10Cq1O+EncWT6HKjD6K8gPreMHcNhjkZUkEn6zpMV9QYh
   s7V2H2w3gkvio9krNjv8Zeh2H7zU+045/Y7yw8zD8+5oIpUQ2bjRxcfNp
   E+OUq9U4+5nzjfEJ8rRW7yxOhoO6o7jntBQXPtcRp6/g3DhR+zFgtW3+7
   noQ5m3sDJ68PyAafT++fOn/+VSWAZ8FiC8x1GBDx43RbNaH1yjgp/0fKf
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="244460505"
X-IronPort-AV: E=Sophos;i="5.90,190,1643702400"; 
   d="scan'208";a="244460505"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 16:29:21 -0700
X-IronPort-AV: E=Sophos;i="5.90,190,1643702400"; 
   d="scan'208";a="715228742"
Received: from gxiong-mobl2.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.133.64])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 16:29:20 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC v2 PATCH 5/7] cxl/core/port: add decoder attrs for size and volatility
Date: Thu, 17 Mar 2022 16:29:09 -0700
Message-Id: <20220317232909.2259338-1-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317214943.gxbwayoletild3eq@intel.com>
References: <20220317214943.gxbwayoletild3eq@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Endpoint decoders have the decoder-unique properties of having their
range being constrained by the media they're a part of, and, having a
concrete need to disambiguate between volatile and persistent capacity
(due to partitioning). As part of region programming, these decoders
will be required to be pre-configured, ie, have the size and volatility
set.

Endpoint decoders must consider two different address space for address
allocation. Sysram will need to be mapped for use of this memory if not
set up in the EFI memory map. Additionally, the CXL device itself has
it's own address space domain which requires allocation and management.
To handle the device address space, a gen_pool is used per device. Host
physical address space will get allocated as needed when the region is
created.

The existing gen_pool API is an almost perfect fit for managing the
device memory. There exists one impediment however. HDM decoders (as of
the CXL 2.0 spec) must map incremental address. 8.2.5.12.20 states,
"Decoder[m+1].Base >= (Decoder[m].Base+Decoder[m].Size)". To handle this
case, a custom gen_pool algorithm is implemented which searches for the
last enabled decoder and allocates at the next address after that. This
is like a first fit + fixed algorithm.

/sys/bus/cxl/devices/decoder3.0
├── devtype
├── interleave_granularity
├── interleave_ways
├── locked
├── modalias
├── size
├── start
├── subsystem -> ../../../../../../../bus/cxl
├── target_type
├── uevent
└── volatile

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---

Some cleanups based on the fact that decoders must be enabled sequentially and
therefore no gaps can exist.

---
 Documentation/ABI/testing/sysfs-bus-cxl |  13 +-
 drivers/cxl/Kconfig                     |   3 +-
 drivers/cxl/core/port.c                 | 157 +++++++++++++++++++++++-
 drivers/cxl/cxl.h                       |   6 +
 4 files changed, 176 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 7c2b846521f3..01fee09b8473 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -117,7 +117,9 @@ Description:
 		range is fixed. For decoders of devtype "cxl_decoder_switch" the
 		address is bounded by the decode range of the cxl_port ancestor
 		of the decoder's cxl_port, and dynamically updates based on the
-		active memory regions in that address space.
+		active memory regions in that address space. For decoders of
+		devtype "cxl_decoder_endpoint", size is a mutable value which
+		carves our space from the physical media.
 
 What:		/sys/bus/cxl/devices/decoderX.Y/locked
 Date:		June, 2021
@@ -163,3 +165,12 @@ Description:
 		memory (type-3). The 'target_type' attribute indicates the
 		current setting which may dynamically change based on what
 		memory regions are activated in this decode hierarchy.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/volatile
+Date:		March, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Provide a knob to set/get whether the desired media is volatile
+		or persistent. This applies only to decoders of devtype
+		"cxl_decoder_endpoint",
diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
index b88ab956bb7c..8796fd4b22bc 100644
--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -95,7 +95,8 @@ config CXL_MEM
 	  If unsure say 'm'.
 
 config CXL_PORT
-	default CXL_BUS
 	tristate
+	default CXL_BUS
+	select DEVICE_PRIVATE
 
 endif
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index fe50a42bed7b..320a5f2f3b7d 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -4,6 +4,7 @@
 #include <linux/workqueue.h>
 #include <linux/genalloc.h>
 #include <linux/device.h>
+#include <linux/ioport.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
@@ -86,8 +87,159 @@ static ssize_t size_show(struct device *dev, struct device_attribute *attr,
 	struct range r = cxl_get_decoder_extent(cxld);
 
 	return sysfs_emit(buf, "%#llx\n", range_len(&r));
+};
+
+static struct cxl_endpoint_decoder *
+get_prev_decoder(struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_port *port = to_cxl_port(cxled->base.dev.parent);
+	struct device *cxldd;
+	char *name;
+
+	if (cxled->base.id == 0)
+		return NULL;
+
+	name = kasprintf(GFP_KERNEL, "decoder%u.%u", port->id, cxled->base.id);
+	if (!name)
+		return ERR_PTR(-ENOMEM);
+
+	cxldd = device_find_child_by_name(&port->dev, name);
+	kfree(name);
+	if (cxldd) {
+		struct cxl_decoder *cxld = to_cxl_decoder(cxldd);
+
+		if (dev_WARN_ONCE(&port->dev,
+				  (cxld->flags & CXL_DECODER_F_ENABLE) == 0,
+				  "%s should be enabled\n",
+				  dev_name(&cxld->dev)))
+			return NULL;
+		return to_cxl_endpoint_decoder(cxld);
+	}
+
+	return NULL;
 }
-static DEVICE_ATTR_RO(size);
+
+unsigned long gen_pool_cxl_alloc(unsigned long *map, unsigned long size,
+				 unsigned long start, unsigned int nr,
+				 void *_cxled, struct gen_pool *pool,
+				 unsigned long start_addr)
+{
+	struct cxl_endpoint_decoder *p, *cxled = _cxled;
+	struct cxl_port *port = to_cxl_port(cxled->base.dev.parent);
+	unsigned long offset_bit;
+	unsigned long start_bit;
+
+	lockdep_assert_held(&port->media_lock);
+
+	p = get_prev_decoder(cxled);
+	if (p)
+		start_addr = p->drange.end + 1;
+	else
+		start_addr = 0;
+
+	/* From here on, it's fixed offset algo */
+	offset_bit = start_addr >> pool->min_alloc_order;
+
+	start_bit = bitmap_find_next_zero_area(map, size, start + offset_bit,
+					       nr, 0);
+	if (start_bit != offset_bit)
+		start_bit = size;
+	return start_bit;
+}
+
+static ssize_t size_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t len)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(cxld);
+	struct cxl_port *port = to_cxl_port(cxled->base.dev.parent);
+	unsigned long addr;
+	void *type;
+	u64 size;
+	int rc;
+
+	rc = kstrtou64(buf, 0, &size);
+	if (rc)
+		return rc;
+
+	if (size % SZ_256M)
+		return -EINVAL;
+
+	rc = mutex_lock_interruptible(&cxled->res_lock);
+	if (rc)
+		return rc;
+
+	/* No change */
+	if (range_len(&cxled->drange) == size)
+		goto out;
+
+	/* Extent was previously set */
+	if (range_len(&cxled->drange)) {
+		dev_dbg(dev, "freeing previous reservation %#llx-%#llx\n",
+				cxled->drange.start, cxled->drange.end);
+		gen_pool_free(port->media, cxled->drange.start,
+			      range_len(&cxled->drange));
+		cxl_set_decoder_extent(cxld, 0, 0);
+		if (!size)
+			goto out;
+	}
+
+	rc = mutex_lock_interruptible(&port->media_lock);
+	if (rc)
+		goto out;
+
+	addr = gen_pool_alloc_algo_owner(port->media, size, gen_pool_cxl_alloc,
+					 cxled, &type);
+	mutex_unlock(&port->media_lock);
+	if (!addr && !type) {
+		dev_dbg(dev, "couldn't find %llu bytes\n", size);
+		cxl_set_decoder_extent(cxld, 0, 0);
+		rc = -ENOSPC;
+	} else {
+		cxl_set_decoder_extent(cxld, addr, size);
+	}
+
+out:
+	mutex_unlock(&cxled->res_lock);
+	return rc ? rc : len;
+}
+static DEVICE_ATTR_RW(size);
+
+static ssize_t volatile_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(cxld);
+
+	return sysfs_emit(buf, "%u\n", cxled->volatil);
+}
+
+static ssize_t volatile_store(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t len)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(cxld);
+	bool p;
+	int rc;
+
+	rc = kstrtobool(buf, &p);
+	if (rc)
+		return rc;
+
+	rc = mutex_lock_interruptible(&cxled->res_lock);
+	if (rc)
+		return rc;
+
+	if (range_len(&cxled->drange) > 0)
+		rc = -EBUSY;
+	mutex_unlock(&cxled->res_lock);
+	if (rc)
+		return rc;
+
+	cxled->volatil = p;
+	return len;
+}
+static DEVICE_ATTR_RW(volatile);
 
 static ssize_t interleave_ways_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
@@ -243,6 +395,7 @@ static const struct attribute_group *cxl_decoder_switch_attribute_groups[] = {
 
 static struct attribute *cxl_decoder_endpoint_attrs[] = {
 	&dev_attr_target_type.attr,
+	&dev_attr_volatile.attr,
 	NULL,
 };
 
@@ -439,6 +592,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
 	ida_init(&port->decoder_ida);
 	INIT_LIST_HEAD(&port->dports);
 	INIT_LIST_HEAD(&port->endpoints);
+	mutex_init(&port->media_lock);
 
 	device_initialize(dev);
 	device_set_pm_not_required(dev);
@@ -1298,6 +1452,7 @@ static struct cxl_decoder *__cxl_decoder_alloc(struct cxl_port *port,
 		if (!cxled)
 			return NULL;
 		cxled->drange = (struct range){ 0, -1 };
+		mutex_init(&cxled->res_lock);
 		cxld = &cxled->base;
 	} else if (is_cxl_root(port)) {
 		struct cxl_root_decoder *cxlrd;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index e88b1efe54d3..8944d0fdd58a 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -248,12 +248,16 @@ struct cxl_decoder {
  * @hrange: Host physical address space consumed by this decoder.
  * @drange: device space consumed by this decoder.
  * @skip: The skip count as specified in the CXL specification.
+ * @res_lock: Synchronize device's resource usage
+ * @volatil: Configuration param. Decoder target is non-persistent mem
  */
 struct cxl_endpoint_decoder {
 	struct cxl_decoder base;
 	struct range hrange;
 	struct range drange;
 	u64 skip;
+	struct mutex res_lock; /* sync access to decoder's resource */
+	bool volatil;
 };
 
 /**
@@ -338,6 +342,7 @@ struct cxl_nvdimm {
  * @component_reg_phys: component register capability base address (optional)
  * @dead: last ep has been removed, force port re-creation
  * @depth: How deep this port is relative to the root. depth 0 is the root.
+ * @media_lock: Protects the media gen_pool
  * @media: Media's address space (endpoint only)
  */
 struct cxl_port {
@@ -350,6 +355,7 @@ struct cxl_port {
 	resource_size_t component_reg_phys;
 	bool dead;
 	unsigned int depth;
+	struct mutex media_lock;
 	struct gen_pool *media;
 };
 
-- 
2.35.1

