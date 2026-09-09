Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40B84A2A7C;
	Wed,  9 Sep 2026 14:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964630; cv=none; b=MrFe4LF3DNxxg1nMxAXSz1LiHvbkM5wlJa7AvUCw7Ob7yJdigS9AsojlexYvsBJ1ymI26BLBy9TOzSf0dzvUlW9/FfvEzSCeR5OIlojrYQMYpFQ6gaVZ/Y1EP5Nr7WaGK8LprfQ7UuNnYm2foE2xOZiEPFkN5e++UcKacdHo/0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964630; c=relaxed/simple;
	bh=mag2pJeUdFpcQNNMXO0m4jlB/uCGajkY55j3uGTrVgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSCoSYq4YuUZc51TR2A4u97jubVqENi9FYSumYPOzMz+zpynmsLo2eZT2d9oBKd4gdXWcvo0mRk6dFt4IwBDZtkJjyyl7J+JUMqolgtNqVagkKji7LfrjBexUTs5lB/BB0/v1ppJLq4wAdE4NZVcWe5f1P8eaUD6OwYshYY6vGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swgaNFeS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swgaNFeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636CF1F00A3A;
	Wed,  9 Sep 2026 14:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964628;
	bh=vptuvHUITVabPg5io6YzAZCBYCcf1kjjsCaadtxho74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=swgaNFeSlT5g+Xdo05/WOxSuOxpGU0cPkT6XIBrljy+Yw8DiqGAg5JXvF5Qok9Pwp
	 50App/fuVjUXvmtQR4myuizCTE0WcO5NsppbP63SiJrd15jaXELvezAhfsYV75lNu3
	 VPyDw0Uq6geo8qpPYfHNC2Xj8DJdLi4BTUyQy5bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Flavien Solt <flavien@nus.edu.sg>,
	Dan Williams <djbw@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Ben Cheatham <benjamin.cheatham@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 490/583] cxl/mce: Make the MCE notifier per-region
Date: Wed,  9 Sep 2026 15:42:55 +0200
Message-ID: <20260909134254.782021557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 775d0f4558f4cec0ee0c8966595d1add1791f36e ]

Flavien Solt reported lifetime issues with the CXL MCE notifier, which
can lead to NULL dereferences and use-after-free in the MCE handler.
The notifier was registered per memory device and stored in 'struct
cxl_memdev_state', even though it only needs the region state (the
region's SPA range and its extended linear cache size).

Instead of keeping the memory device and endpoint alive, the correct fix
is to move the notifier into 'struct cxl_region' and register it from
cxl_region_probe() as it should be a per-region notifier. Setup the
registration to only happen for regions that have an extended linear
cache as that is the only current usage.

Remove cxl_port_get_spa_cache_alias() as it is now dead code.

[ dj: Update dev_warn() when notifier fails due to kconfig. (Ben) ]

Reported-by: Flavien Solt <flavien@nus.edu.sg>
Suggested-by: Dan Williams <djbw@kernel.org>
Fixes: 516e5bd0b6bf ("cxl: Add mce notifier to emit aliased address for extended linear cache")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>
Link: https://patch.msgid.link/20260616224912.2567474-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/mbox.c   |    8 --------
 drivers/cxl/core/mce.c    |   27 +++++++++++++--------------
 drivers/cxl/core/region.c |   43 +++++++++++++++----------------------------
 drivers/cxl/cxl.h         |    8 ++------
 drivers/cxl/cxlmem.h      |    2 --
 5 files changed, 30 insertions(+), 58 deletions(-)

--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -11,7 +11,6 @@
 
 #include "core.h"
 #include "trace.h"
-#include "mce.h"
 
 static bool cxl_raw_allow_all;
 
@@ -1524,7 +1523,6 @@ EXPORT_SYMBOL_NS_GPL(cxl_mailbox_init, "
 struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev)
 {
 	struct cxl_memdev_state *mds;
-	int rc;
 
 	mds = devm_kzalloc(dev, sizeof(*mds), GFP_KERNEL);
 	if (!mds) {
@@ -1539,12 +1537,6 @@ struct cxl_memdev_state *cxl_memdev_stat
 	mds->cxlds.reg_map.resource = CXL_RESOURCE_NONE;
 	mds->cxlds.type = CXL_DEVTYPE_CLASSMEM;
 
-	rc = devm_cxl_register_mce_notifier(dev, &mds->mce_notifier);
-	if (rc == -EOPNOTSUPP)
-		dev_warn(dev, "CXL MCE unsupported\n");
-	else if (rc)
-		return ERR_PTR(rc);
-
 	return mds;
 }
 EXPORT_SYMBOL_NS_GPL(cxl_memdev_state_create, "CXL");
--- a/drivers/cxl/core/mce.c
+++ b/drivers/cxl/core/mce.c
@@ -4,16 +4,16 @@
 #include <linux/notifier.h>
 #include <linux/set_memory.h>
 #include <asm/mce.h>
-#include <cxlmem.h>
+#include <cxl.h>
+#include "core.h"
 #include "mce.h"
 
 static int cxl_handle_mce(struct notifier_block *nb, unsigned long val,
 			  void *data)
 {
-	struct cxl_memdev_state *mds = container_of(nb, struct cxl_memdev_state,
-						    mce_notifier);
-	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
-	struct cxl_port *endpoint = cxlmd->endpoint;
+	struct cxl_region *cxlr = container_of(nb, struct cxl_region,
+					       mce_notifier);
+	struct cxl_region_params *p = &cxlr->params;
 	struct mce *mce = data;
 	u64 spa, spa_alias;
 	unsigned long pfn;
@@ -21,26 +21,25 @@ static int cxl_handle_mce(struct notifie
 	if (!mce || !mce_usable_address(mce))
 		return NOTIFY_DONE;
 
-	if (!endpoint)
-		return NOTIFY_DONE;
-
 	spa = mce->addr & MCI_ADDR_PHYSADDR;
 
-	pfn = spa >> PAGE_SHIFT;
-	if (!pfn_valid(pfn))
+	if (!cxl_resource_contains_addr(p->res, spa))
 		return NOTIFY_DONE;
 
-	spa_alias = cxl_port_get_spa_cache_alias(endpoint, spa);
-	if (spa_alias == ~0ULL)
-		return NOTIFY_DONE;
+	if (spa >= p->res->start + p->cache_size)
+		spa_alias = spa - p->cache_size;
+	else
+		spa_alias = spa + p->cache_size;
 
 	pfn = spa_alias >> PAGE_SHIFT;
+	if (!pfn_valid(pfn))
+		return NOTIFY_DONE;
 
 	/*
 	 * Take down the aliased memory page. The original memory page flagged
 	 * by the MCE will be taken cared of by the standard MCE handler.
 	 */
-	dev_emerg(mds->cxlds.dev, "Offlining aliased SPA address0: %#llx\n",
+	dev_emerg(&cxlr->dev, "Offlining aliased SPA address0: %#llx\n",
 		  spa_alias);
 	if (!memory_failure(pfn, 0))
 		set_mce_nospec(pfn);
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -15,6 +15,7 @@
 #include <cxlmem.h>
 #include <cxl.h>
 #include "core.h"
+#include "mce.h"
 
 /**
  * DOC: cxl core region
@@ -3605,34 +3606,6 @@ int cxl_add_to_region(struct cxl_endpoin
 }
 EXPORT_SYMBOL_NS_GPL(cxl_add_to_region, "CXL");
 
-u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa)
-{
-	struct cxl_region_ref *iter;
-	unsigned long index;
-
-	if (!endpoint)
-		return ~0ULL;
-
-	guard(rwsem_write)(&cxl_rwsem.region);
-
-	xa_for_each(&endpoint->regions, index, iter) {
-		struct cxl_region_params *p = &iter->region->params;
-
-		if (cxl_resource_contains_addr(p->res, spa)) {
-			if (!p->cache_size)
-				return ~0ULL;
-
-			if (spa >= p->res->start + p->cache_size)
-				return spa - p->cache_size;
-
-			return spa + p->cache_size;
-		}
-	}
-
-	return ~0ULL;
-}
-EXPORT_SYMBOL_NS_GPL(cxl_port_get_spa_cache_alias, "CXL");
-
 static int is_system_ram(struct resource *res, void *arg)
 {
 	struct cxl_region *cxlr = arg;
@@ -3858,6 +3831,20 @@ static int cxl_region_probe(struct devic
 	if (rc)
 		return rc;
 
+	/*
+	 * Regions fronted by an extended linear cache need the MCE notifier to
+	 * offline the aliased page on a memory error.
+	 */
+	if (p->cache_size) {
+		rc = devm_cxl_register_mce_notifier(&cxlr->dev,
+						    &cxlr->mce_notifier);
+		if (rc == -EOPNOTSUPP)
+			dev_warn(&cxlr->dev,
+				 "CONFIG_CXL_MCE disabled, MCE notifier not registered\n");
+		else if (rc)
+			return rc;
+	}
+
 	rc = cxl_region_setup_poison(cxlr);
 	if (rc)
 		return rc;
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -540,6 +540,7 @@ enum cxl_partition_mode {
  * @coord: QoS access coordinates for the region
  * @node_notifier: notifier for setting the access coordinates to node
  * @adist_notifier: notifier for calculating the abstract distance of node
+ * @mce_notifier: notifier for MCE
  */
 struct cxl_region {
 	struct device dev;
@@ -553,6 +554,7 @@ struct cxl_region {
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
 	struct notifier_block node_notifier;
 	struct notifier_block adist_notifier;
+	struct notifier_block mce_notifier;
 };
 
 struct cxl_nvdimm_bridge {
@@ -886,7 +888,6 @@ bool is_cxl_pmem_region(struct device *d
 struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
 int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
 struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
-u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
 bool cxl_region_contains_resource(const struct resource *res);
 #else
 static inline bool is_cxl_pmem_region(struct device *dev)
@@ -905,11 +906,6 @@ static inline struct cxl_dax_region *to_
 {
 	return NULL;
 }
-static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
-					       u64 spa)
-{
-	return 0;
-}
 static inline bool cxl_region_contains_resource(const struct resource *res)
 {
 	return false;
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -484,7 +484,6 @@ static inline struct cxl_dev_state *mbox
  * @poison: poison driver state info
  * @security: security driver state info
  * @fw: firmware upload / activation state
- * @mce_notifier: MCE notifier
  *
  * See CXL 3.0 8.2.9.8.2 Capacity Configuration and Label Storage for
  * details on capacity parameters.
@@ -504,7 +503,6 @@ struct cxl_memdev_state {
 	struct cxl_poison_state poison;
 	struct cxl_security_state security;
 	struct cxl_fw_state fw;
-	struct notifier_block mce_notifier;
 };
 
 static inline struct cxl_memdev_state *


