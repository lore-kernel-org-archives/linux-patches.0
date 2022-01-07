Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDF52CA3
	for <patches@lists.linux.dev>; Fri,  7 Jan 2022 00:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641515893; x=1673051893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zCiUUcytCexUYYZvqVtEwyDzVzKLZ5yWtPaDBTJE3k0=;
  b=nvsM+ZjggpzkL4Y3yjYudP+Axj3c+8+zSkUw/bgcbZiPfmH77wGk/usB
   nu6TZZeLVg3cwZ4hqRpYl6Kmg7Q4tSN0Lz7UfT4A9dzuo3+CCDBiV5rbW
   rAEXLQ50n29lizylRzi6M3mCiaO3vo1NAbhidevPInxGb6g+ImJ+RqvT4
   u/OaJNZm3Ne/ix5+QSeeQi3403Z8MOtjqCmR93qKBmBJlBbazMsoVSf09
   Kpj1klrkkVW3bz6r7YLlkJTIN4lCgTLJxnafaYB7UzSPAbxYZHHFaPrJ5
   ORqUx988JwagFn36/PDrAk9qp4gWNUfvVNXalHOKEF9DfyP8cIV2s13d5
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="223466618"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="223466618"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:38:11 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="471123204"
Received: from elenawei-mobl2.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.138.104])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:38:10 -0800
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
Subject: [PATCH 05/13] cxl/mem: Cache port created by the mem dev
Date: Thu,  6 Jan 2022 16:37:48 -0800
Message-Id: <20220107003756.806582-6-ben.widawsky@intel.com>
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

Since region programming sees all components in the topology as a port,
it's required that endpoints are treated equally. The easiest way to go
from endpoint to port is to simply cache it at creation time.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/cxlmem.h |  2 ++
 drivers/cxl/mem.c    | 16 ++++++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 4ea0686e5f84..38d6129499c8 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -36,12 +36,14 @@
  * @cxlds: The device state backing this device
  * @id: id number of this memdev instance.
  * @component_reg_phys: register base of component registers
+ * @port: The port created by this device
  */
 struct cxl_memdev {
 	struct device dev;
 	struct cdev cdev;
 	struct cxl_dev_state *cxlds;
 	int id;
+	struct cxl_port *port;
 };
 
 static inline struct cxl_memdev *to_cxl_memdev(struct device *dev)
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 9e6e98e5ea06..2ed7554155d2 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -45,8 +45,8 @@ static int wait_for_media(struct cxl_memdev *cxlmd)
 	return 0;
 }
 
-static int create_endpoint(struct cxl_memdev *cxlmd,
-			   struct cxl_port *parent_port)
+static struct cxl_port *create_endpoint(struct cxl_memdev *cxlmd,
+					struct cxl_port *parent_port)
 {
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct cxl_port *endpoint;
@@ -54,10 +54,10 @@ static int create_endpoint(struct cxl_memdev *cxlmd,
 	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
 				     cxlds->component_reg_phys, parent_port);
 	if (IS_ERR(endpoint))
-		return PTR_ERR(endpoint);
+		return endpoint;
 
 	dev_dbg(&cxlmd->dev, "add: %s\n", dev_name(&endpoint->dev));
-	return 0;
+	return endpoint;
 }
 
 /**
@@ -123,7 +123,7 @@ static int cxl_mem_probe(struct device *dev)
 {
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
-	struct cxl_port *parent_port;
+	struct cxl_port *parent_port, *ep_port;
 	int rc;
 
 	rc = wait_for_media(cxlmd);
@@ -182,7 +182,11 @@ static int cxl_mem_probe(struct device *dev)
 		goto out;
 	}
 
-	rc = create_endpoint(cxlmd, parent_port);
+	ep_port = create_endpoint(cxlmd, parent_port);
+	if (IS_ERR(ep_port))
+		rc = PTR_ERR(ep_port);
+	else
+		cxlmd->port = ep_port;
 out:
 	device_unlock(&parent_port->dev);
 	put_device(&parent_port->dev);
-- 
2.34.1

