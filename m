Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A17E1C232C;
	Tue,  2 Jul 2024 17:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940636; cv=none; b=bVm/86VjKtBJr9gFMuXmixlYqTr0pg1IhYzcYM97spqrISnaZoooISmUlIifpVPe0zWKrDDXPslYtv09pGsif+ee1HItIN7oK3mENsqhq010jshRili2b6vuCC988fc2+s/zJtSA6qKVp+44r9xNPFRmQzo0gvIA0nUcH791xA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940636; c=relaxed/simple;
	bh=2Caxiraizr16XfD4xaynyZsX845GzRO202UK/iwJrr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQEHnigABGZ/TI6CnOl2ihnSltnkaiTZ7qhvzNHPWBOLgiFnqzv+uuolj3JWSM8Flx0JyofY8FLdv4P8Pd5pKNnI9OUHk8FWAHPoe+DLqSFH3UgqlP2YSZn8UDlkzL6l7a7pFnDmZ9Kk7lknr0XYCOei5QU/juvpEgEY4BldxyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyeJJl46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyeJJl46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F183C116B1;
	Tue,  2 Jul 2024 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940635;
	bh=2Caxiraizr16XfD4xaynyZsX845GzRO202UK/iwJrr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyeJJl46OqH4XLR41CjXMAbJ9urrTDY9WzT4irTD+FNNef05wNe7GdHG+Scy3Q5rv
	 Y5zT2UVh/gqbn3egQlg7tGhfFFJWiP/dWjTVh8WGtbaUf76+vXzhrbNRqTRU71MuAI
	 B6H34pm+ECufTQsSIzYmkert0wYgdeJZ4PDDno4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Li Ming <ming4.li@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 213/222] cxl/mem: Fix no cxl_nvd during pmem region auto-assembling
Date: Tue,  2 Jul 2024 19:04:11 +0200
Message-ID: <20240702170252.128195746@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Ming <ming4.li@intel.com>

[ Upstream commit 84ec985944ef34a34a1605b93ce401aa8737af96 ]

When CXL subsystem is auto-assembling a pmem region during cxl
endpoint port probing, always hit below calltrace.

 BUG: kernel NULL pointer dereference, address: 0000000000000078
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 RIP: 0010:cxl_pmem_region_probe+0x22e/0x360 [cxl_pmem]
 Call Trace:
  <TASK>
  ? __die+0x24/0x70
  ? page_fault_oops+0x82/0x160
  ? do_user_addr_fault+0x65/0x6b0
  ? exc_page_fault+0x7d/0x170
  ? asm_exc_page_fault+0x26/0x30
  ? cxl_pmem_region_probe+0x22e/0x360 [cxl_pmem]
  ? cxl_pmem_region_probe+0x1ac/0x360 [cxl_pmem]
  cxl_bus_probe+0x1b/0x60 [cxl_core]
  really_probe+0x173/0x410
  ? __pfx___device_attach_driver+0x10/0x10
  __driver_probe_device+0x80/0x170
  driver_probe_device+0x1e/0x90
  __device_attach_driver+0x90/0x120
  bus_for_each_drv+0x84/0xe0
  __device_attach+0xbc/0x1f0
  bus_probe_device+0x90/0xa0
  device_add+0x51c/0x710
  devm_cxl_add_pmem_region+0x1b5/0x380 [cxl_core]
  cxl_bus_probe+0x1b/0x60 [cxl_core]

The cxl_nvd of the memdev needs to be available during the pmem region
probe. Currently the cxl_nvd is registered after the endpoint port probe.
The endpoint probe, in the case of autoassembly of regions, can cause a
pmem region probe requiring the not yet available cxl_nvd. Adjust the
sequence so this dependency is met.

This requires adding a port parameter to cxl_find_nvdimm_bridge() that
can be used to query the ancestor root port. The endpoint port is not
yet available, but will share a common ancestor with its parent, so
start the query from there instead.

Fixes: f17b558d6663 ("cxl/pmem: Refactor nvdimm device registration, delete the workqueue")
Co-developed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Li Ming <ming4.li@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20240612064423.2567625-1-ming4.li@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pmem.c   | 16 +++++++++++-----
 drivers/cxl/core/region.c |  2 +-
 drivers/cxl/cxl.h         |  4 ++--
 drivers/cxl/mem.c         | 17 +++++++++--------
 4 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index e69625a8d6a1d..c00f3a933164f 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -62,10 +62,14 @@ static int match_nvdimm_bridge(struct device *dev, void *data)
 	return is_cxl_nvdimm_bridge(dev);
 }
 
-struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_memdev *cxlmd)
+/**
+ * cxl_find_nvdimm_bridge() - find a bridge device relative to a port
+ * @port: any descendant port of an nvdimm-bridge associated
+ *        root-cxl-port
+ */
+struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_port *port)
 {
-	struct cxl_root *cxl_root __free(put_cxl_root) =
-		find_cxl_root(cxlmd->endpoint);
+	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
 	struct device *dev;
 
 	if (!cxl_root)
@@ -242,18 +246,20 @@ static void cxlmd_release_nvdimm(void *_cxlmd)
 
 /**
  * devm_cxl_add_nvdimm() - add a bridge between a cxl_memdev and an nvdimm
+ * @parent_port: parent port for the (to be added) @cxlmd endpoint port
  * @cxlmd: cxl_memdev instance that will perform LIBNVDIMM operations
  *
  * Return: 0 on success negative error code on failure.
  */
-int devm_cxl_add_nvdimm(struct cxl_memdev *cxlmd)
+int devm_cxl_add_nvdimm(struct cxl_port *parent_port,
+			struct cxl_memdev *cxlmd)
 {
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct cxl_nvdimm *cxl_nvd;
 	struct device *dev;
 	int rc;
 
-	cxl_nvb = cxl_find_nvdimm_bridge(cxlmd);
+	cxl_nvb = cxl_find_nvdimm_bridge(parent_port);
 	if (!cxl_nvb)
 		return -ENODEV;
 
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index bcb30e04e0963..857afc8b72ff1 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2712,7 +2712,7 @@ static int cxl_pmem_region_alloc(struct cxl_region *cxlr)
 		 * bridge for one device is the same for all.
 		 */
 		if (i == 0) {
-			cxl_nvb = cxl_find_nvdimm_bridge(cxlmd);
+			cxl_nvb = cxl_find_nvdimm_bridge(cxlmd->endpoint);
 			if (!cxl_nvb)
 				return -ENODEV;
 			cxlr->cxl_nvb = cxl_nvb;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 72fa477407689..2b82dcaf70aa6 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -848,8 +848,8 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
 struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm_bridge(struct device *dev);
-int devm_cxl_add_nvdimm(struct cxl_memdev *cxlmd);
-struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_memdev *cxlmd);
+int devm_cxl_add_nvdimm(struct cxl_port *parent_port, struct cxl_memdev *cxlmd);
+struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_port *port);
 
 #ifdef CONFIG_CXL_REGION
 bool is_cxl_pmem_region(struct device *dev);
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 0c79d9ce877cc..2f1b49bfe162f 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -152,6 +152,15 @@ static int cxl_mem_probe(struct device *dev)
 		return -ENXIO;
 	}
 
+	if (resource_size(&cxlds->pmem_res) && IS_ENABLED(CONFIG_CXL_PMEM)) {
+		rc = devm_cxl_add_nvdimm(parent_port, cxlmd);
+		if (rc) {
+			if (rc == -ENODEV)
+				dev_info(dev, "PMEM disabled by platform\n");
+			return rc;
+		}
+	}
+
 	if (dport->rch)
 		endpoint_parent = parent_port->uport_dev;
 	else
@@ -174,14 +183,6 @@ static int cxl_mem_probe(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (resource_size(&cxlds->pmem_res) && IS_ENABLED(CONFIG_CXL_PMEM)) {
-		rc = devm_cxl_add_nvdimm(cxlmd);
-		if (rc == -ENODEV)
-			dev_info(dev, "PMEM disabled by platform\n");
-		else
-			return rc;
-	}
-
 	/*
 	 * The kernel may be operating out of CXL memory on this device,
 	 * there is no spec defined way to determine whether this device
-- 
2.43.0



