Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E3F2CA3
	for <patches@lists.linux.dev>; Fri,  7 Jan 2022 00:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641515892; x=1673051892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v+UW4m504aj7Y2/rdh0uUTe2dZa+1eAla8ODkXKHIW8=;
  b=knETnuix+m/ebRi7/LFcScN/k6W+ZP7CUgSfowkArq1xPW63kgQBJHre
   9gkpgD4U8nLIu0s4O1PYjMU5nak+Lu4FaRkd79DC887EEgRerjmlCvAx6
   vyUkhyK69vp1acohK9++t8LlQDhOIxpKb6OL4rPpOm18TLw58GKMpUf1A
   ICcjVvrS5VjMR8j9SWMcHrpMFGyzJAq4iofFQRPucm9rGVqYFMAcN8I3U
   3LCzBvQgdJPv1eXjyqwyKMJCwot4l39SW2PA2YtxeaXDwt1N5/LLTd7Ls
   rGx4Xs8mTCtItBZSHsvzXOMuvc4zK2sDm2VrplR7M47fnnrGrPuOxy8pn
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="223466609"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="223466609"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:38:10 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="471123185"
Received: from elenawei-mobl2.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.138.104])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:38:09 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	linux-nvdimm@lists.01.org,
	linux-pci@vger.kernel.org
Cc: patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 02/13] cxl/core: Track port depth
Date: Thu,  6 Jan 2022 16:37:45 -0800
Message-Id: <20220107003756.806582-3-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107003756.806582-1-ben.widawsky@intel.com>
References: <20220107003756.806582-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/core/port.c | 7 ++++++-
 drivers/cxl/cxl.h       | 2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 5a1ffadd5d0d..ecab7cfa88f0 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -436,13 +436,18 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 {
 	struct cxl_port *port;
 	struct device *dev;
-	int rc;
+	int rc, depth = parent_port ? parent_port->depth + 1 : 0;
 
 	port = cxl_port_alloc(uport, component_reg_phys, parent_port);
 	if (IS_ERR(port))
 		return port;
 
+	if (dev_WARN_ONCE(&port->dev, parent_port && !depth,
+			  "Invalid parent port depth\n"))
+		return ERR_PTR(-ENODEV);
+
 	port->host = host;
+	port->depth = depth;
 	dev = &port->dev;
 	if (is_cxl_memdev(uport))
 		rc = dev_set_name(dev, "endpoint%d", port->id);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 276b93316e7f..6eeb82711443 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -272,6 +272,7 @@ struct cxl_walk_context {
  * @decoder_ida: allocator for decoder ids
  * @component_reg_phys: component register capability base address (optional)
  * @dead: last ep has been removed, force port re-creation
+ * @depth: How deep this port is relative to the root. depth 0 is the root.
  */
 struct cxl_port {
 	struct device dev;
@@ -283,6 +284,7 @@ struct cxl_port {
 	struct ida decoder_ida;
 	resource_size_t component_reg_phys;
 	bool dead;
+	unsigned int depth;
 };
 
 /**
-- 
2.34.1

