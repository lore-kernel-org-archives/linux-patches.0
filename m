Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5070371CF7
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 05:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774589229; cv=none; b=QycvYOofPRVcp+Wugt0XPa8ACKBGHm/d8MGuQ7QEIJAyjj4BPpywznXjFCB2dt0k4CTCbovTd7ObrzckU4IxPFQAcTl4becVCdFSpRtLs0OPkkCJVUXqmbxAhYFynF+jmegE4pbiQF/59Yr/FMD7/ZVeS8cVeKCLt6Fw2ZhnvIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774589229; c=relaxed/simple;
	bh=g+HkjXqWenJhni3594LF6ZTauUtUHF1lsY/zkRi+MtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbgbDcyfuo3UbNHEA1WyoT49tjFuPouJ3XmthwOITVroAyA9GCyk0CWvOYTlltN1cKdGtjkVRIopcaVD9UfOj62EQbURaszcWDAGaGgQ4bMQQPqSj/DACPdDerPOo60HGjUC8ve3xyR8uvf1hhuP3Ol/P8RgCCALBdZ66z2b6vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mUQKv4Lh; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mUQKv4Lh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774589228; x=1806125228;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g+HkjXqWenJhni3594LF6ZTauUtUHF1lsY/zkRi+MtM=;
  b=mUQKv4LhFnIXvbTPmmnnrMKkue0qqvoD/BX6MPC/XL8yC6qXPWeUFiMM
   TgQC1cVHyIzlUuNnj72UM4THncBhGcY6XNSS+0o38ljwr9PuDogU7Vfji
   NF6bPDPvoXuS762ERbx3hARawpRYyhcnu+td72fKDCZUxqW4I0EWGtvRU
   hF4+u1xLq6gSD920/VK2LYRYSEn4yVBmopgizEW7IXaiPn6fM1trR3jK6
   MP+5zrPJ4xqOtK/7p2XlhzQEXVxeknOt+g/o+j6dQ6EO9vttS5eEHGNgK
   pXwt0B1O/svgEPdMFfggz/h3nIh7x8bBQc1EV2p4AO4Q8okZjpZLxIA6j
   Q==;
X-CSE-ConnectionGUID: wHTVi0ZoQUqJyzJyyuAi/g==
X-CSE-MsgGUID: OJPXl5VFSq+FJCxuwxyF3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="101117949"
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="101117949"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 22:27:06 -0700
X-CSE-ConnectionGUID: /eYqAix/TtCHyo5hj5avnA==
X-CSE-MsgGUID: XS9Lx2MVTky6taRgabrkew==
X-ExtLoop1: 1
Received: from dwillia2-desk.jf.intel.com ([10.88.27.145])
  by fmviesa003.fm.intel.com with ESMTP; 26 Mar 2026 22:27:05 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: dave.jiang@intel.com
Cc: patches@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com
Subject: [PATCH 3/9] cxl/region: Limit visibility of cxl_region_contains_resource()
Date: Thu, 26 Mar 2026 22:28:15 -0700
Message-ID: <20260327052821.440749-4-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327052821.440749-1-dan.j.williams@intel.com>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dax_hmem dependency on cxl_region_contains_resource() is a one-off
special case. It is not suitable for other use cases.

Move the definition to the other CONFIG_CXL_REGION guarded definitions in
drivers/cxl/cxl.h and include that by a relative path include. This matches
what drivers/dax/cxl.c does for its limited private usage of CXL core
symbols.

Reduce the symbol export visibility from global to just dax_hmem, to
further clarify its applicability.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/cxl.h         |  5 +++++
 include/cxl/cxl.h         | 15 ---------------
 drivers/cxl/core/region.c |  3 +--
 drivers/dax/hmem/hmem.c   |  2 +-
 4 files changed, 7 insertions(+), 18 deletions(-)
 delete mode 100644 include/cxl/cxl.h

diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 30a31968f266..84ad04a02bde 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -941,6 +941,7 @@ struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
 int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
 struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
 u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
+bool cxl_region_contains_resource(struct resource *res);
 #else
 static inline bool is_cxl_pmem_region(struct device *dev)
 {
@@ -963,6 +964,10 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
 {
 	return 0;
 }
+static inline bool cxl_region_contains_resource(struct resource *res)
+{
+	return false;
+}
 #endif
 
 void cxl_endpoint_parse_cdat(struct cxl_port *port);
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
deleted file mode 100644
index b12d3d0f6658..000000000000
--- a/include/cxl/cxl.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (c) 2026 Advanced Micro Devices, Inc. */
-#ifndef _CXL_H_
-#define _CXL_H_
-
-#ifdef CONFIG_CXL_REGION
-bool cxl_region_contains_resource(struct resource *res);
-#else
-static inline bool cxl_region_contains_resource(struct resource *res)
-{
-	return false;
-}
-#endif
-
-#endif /* _CXL_H_ */
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index b72556c1458b..12a9572f34d5 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -12,7 +12,6 @@
 #include <linux/idr.h>
 #include <linux/memory-tiers.h>
 #include <linux/string_choices.h>
-#include <cxl/cxl.h>
 #include <cxlmem.h>
 #include <cxl.h>
 #include "core.h"
@@ -4253,7 +4252,7 @@ bool cxl_region_contains_resource(struct resource *res)
 	return bus_for_each_dev(&cxl_bus_type, NULL, res,
 				region_contains_resource) != 0;
 }
-EXPORT_SYMBOL_GPL(cxl_region_contains_resource);
+EXPORT_SYMBOL_FOR_MODULES(cxl_region_contains_resource, "dax_hmem");
 
 static int cxl_region_can_probe(struct cxl_region *cxlr)
 {
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index 9ceda6b5cadf..0051e553c33f 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -3,7 +3,7 @@
 #include <linux/memregion.h>
 #include <linux/module.h>
 #include <linux/dax.h>
-#include <cxl/cxl.h>
+#include "../../cxl/cxl.h"
 #include "../bus.h"
 
 static bool region_idle;
-- 
2.53.0

