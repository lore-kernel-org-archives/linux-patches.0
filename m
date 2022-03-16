Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AD23D6E
	for <patches@lists.linux.dev>; Wed, 16 Mar 2022 23:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647471798; x=1679007798;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3TxITivwCM+dr7cUscjF6XgtGPRS3PeiWb3I5HOqWKs=;
  b=bFyWSJjx2zZpgGAIlKXPGnLEPqVSnCxkNoyPYOBv/K2HCRpl4tQdMB/n
   WBLXoPs6ykh1hsg40E4rtpMm4BsKQB48una+aEZJGipixYnOBFt3sfCvH
   nm/gJ/L8ZVKOztiU0Gh12bOnuSE6fACvjABsYK3OVLnOXbb7Kx5zYdFvD
   SKActHJj2I9RdflZVbI3kBfZimpcPiiNRpDJ+zUrB+FXorxn4wUApBcTw
   6BAVKcib26+nrfDXew0L+Jq+9tv5JjLvm7d94Yn53V27Sxb6jTVKHhvsG
   oNjOKWuG5rfXD3sd2qQtqaqThLwI7F6yKi6pPYJdlzWNBUMbyKPRwpsuu
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="238895930"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="238895930"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 16:03:17 -0700
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="498621393"
Received: from msimpso1-cxt.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.132.128])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 16:03:16 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 3/7] cxl/port: Surface ram and pmem resources
Date: Wed, 16 Mar 2022 16:02:59 -0700
Message-Id: <20220316230303.1813397-4-ben.widawsky@intel.com>
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

CXL Type 2 and 3 endpoints may contain Host-managed Device Memory (HDM).
This memory can be either volatile, persistent, or some combination of
both. Similar to the root decoder the port's resources can be considered
the host memory of which decoders allocate out of. Unlike the root
decoder resource, device resources are in the device physical address
space domain.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/core/port.c | 54 +++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h       |  7 ++++++
 drivers/cxl/mem.c       |  7 ++++--
 3 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index c46f0b01ce3c..6653de4dfb43 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2020 Intel Corporation. All rights reserved. */
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/workqueue.h>
+#include <linux/genalloc.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -503,6 +504,59 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_add_port, CXL);
 
+static int *gen_pool_vcookie;
+static int *gen_pool_pcookie;
+
+struct cxl_port *devm_cxl_add_endpoint_port(struct device *host,
+					    struct device *uport,
+					    resource_size_t component_reg_phys,
+					    u64 capacity, u64 pmem_offset,
+					    struct cxl_port *parent_port)
+{
+	int rc;
+	struct cxl_port *ep =
+		devm_cxl_add_port(host, uport, component_reg_phys, parent_port);
+	if (IS_ERR(ep) || !capacity)
+		return ep;
+
+	ep->media = devm_gen_pool_create(&ep->dev, ilog2(SZ_256M), NUMA_NO_NODE, NULL);
+	if (IS_ERR(ep->media)) {
+		ep = ERR_CAST(ep->media);
+		goto err_out;
+	}
+
+	if (pmem_offset) {
+		rc = gen_pool_add_owner(ep->media, 0, -1, pmem_offset,
+					NUMA_NO_NODE, &gen_pool_vcookie);
+		if (rc) {
+			ep = ERR_PTR(rc);
+			goto err_out;
+		}
+		dev_dbg(&ep->dev, "Created volatile capacity pool: %zx\n",
+			gen_pool_avail(ep->media));
+	}
+
+	if (pmem_offset < capacity) {
+		rc = gen_pool_add_owner(ep->media, pmem_offset, -1,
+					capacity - pmem_offset, NUMA_NO_NODE,
+					&gen_pool_pcookie);
+		if (rc) {
+			ep = ERR_PTR(rc);
+			goto err_out;
+		}
+		dev_dbg(&ep->dev, "Created persistent capacity pool: %zx\n",
+			gen_pool_avail(ep->media));
+	}
+
+	return ep;
+
+err_out:
+	dev_err(&ep->dev, "Failed to allocated gen pools\n");
+	put_device(&ep->dev);
+	return ep;
+}
+EXPORT_SYMBOL_NS_GPL(devm_cxl_add_endpoint_port, CXL);
+
 struct pci_bus *cxl_port_to_pci_bus(struct cxl_port *port)
 {
 	/* There is no pci_bus associated with a CXL platform-root port */
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index f523268060fd..d18e93e77f7e 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -330,6 +330,7 @@ struct cxl_nvdimm {
  * @component_reg_phys: component register capability base address (optional)
  * @dead: last ep has been removed, force port re-creation
  * @depth: How deep this port is relative to the root. depth 0 is the root.
+ * @media: Media's address space (endpoint only)
  */
 struct cxl_port {
 	struct device dev;
@@ -341,6 +342,7 @@ struct cxl_port {
 	resource_size_t component_reg_phys;
 	bool dead;
 	unsigned int depth;
+	struct gen_pool *media;
 };
 
 /**
@@ -389,6 +391,11 @@ struct pci_bus *cxl_port_to_pci_bus(struct cxl_port *port);
 struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 				   resource_size_t component_reg_phys,
 				   struct cxl_port *parent_port);
+struct cxl_port *devm_cxl_add_endpoint_port(struct device *host,
+					    struct device *uport,
+					    resource_size_t component_reg_phys,
+					    u64 capacity, u64 pmem_offset,
+					    struct cxl_port *parent_port);
 struct cxl_port *find_cxl_root(struct device *dev);
 int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
 int cxl_bus_rescan(void);
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 91fb8d5b21a7..b6f8edaed802 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -50,9 +50,12 @@ static int create_endpoint(struct cxl_memdev *cxlmd,
 {
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct cxl_port *endpoint;
+	u64 partition = range_len(&cxlds->ram_range);
+	u64 size = range_len(&cxlds->ram_range) + range_len(&cxlds->pmem_range);
 
-	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
-				     cxlds->component_reg_phys, parent_port);
+	endpoint = devm_cxl_add_endpoint_port(&parent_port->dev, &cxlmd->dev,
+					      cxlds->component_reg_phys, size,
+					      partition, parent_port);
 	if (IS_ERR(endpoint))
 		return PTR_ERR(endpoint);
 
-- 
2.35.1

