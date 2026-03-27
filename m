Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D251368940
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 05:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774589231; cv=none; b=P2IHiUkZyrc9yfkNWRB3lcfwJeH+Jg5Vk1DQc9p9FXYUS+dubnfQVH5YDS0ett87w2XTb/z5ns4ymJMpt53ofFWAbyzEo5VnHAdJS/DFMyEiYHo3bQkzaDZFM2upm7oNk9k2Abqkcn3cwidL1eD5o322kxQS/LtqVwcQs1YGQz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774589231; c=relaxed/simple;
	bh=S56Goy31aO+T4okhoU7DEAPJKmH4ZG9kIytdLEeZcgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3R+XvVvjXl9pKqtLHT0NF7jLTDFoSE6eY0/c0ax487A2WWFQxfQr6liLTiYc5H747VULbOTVjMhgZcHZ3n8PGFtVjF3X1ZNusQ8fy2GPK55T+r7dmSeGvToJZPLTM4+V2LQwQCE+kPs8dnnfGl+Br2h92frKf0ESKYbt/Oqmf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EQzmWhWF; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EQzmWhWF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774589229; x=1806125229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S56Goy31aO+T4okhoU7DEAPJKmH4ZG9kIytdLEeZcgE=;
  b=EQzmWhWF9UHkDlysYpunnEmHC9eEtn7XAo7fwN8Uy0vbE+DXTljYWxhJ
   q4u2GXtjlVLsPb2kXAs5zrZemNYIhkj/NXxXKLGGABRpxLxXgEJCBKnqB
   ZMcKZDUcbOr4YPjNfRakhttPHCMlry+q/NSqD6WauhsyPLljgsJOjKVPw
   CbjdsoknR6QhIjOPlxhuEdoLMDBG/foxUJCOz2wa3NZ1vk87kTTKStmXm
   kRNe6MeQC6O/JxOMg3QSt353VaZObFaqAmeibHwHriKGg8bDxO8aXjqTF
   LaUx4f05jMfAi5YTspP9hBwBc8n3xQXN8jOamcQZ5/tu6nDqjj9b2E7m5
   A==;
X-CSE-ConnectionGUID: z3mWJoahRsqt+LkCWKcePw==
X-CSE-MsgGUID: sZfz7QU+RWirNtxa5InU1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="101117958"
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="101117958"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 22:27:06 -0700
X-CSE-ConnectionGUID: w3SL8QsAREq0BAUIa5UkNQ==
X-CSE-MsgGUID: Jk/NAKIDTi6m83bNJs0Vsg==
X-ExtLoop1: 1
Received: from dwillia2-desk.jf.intel.com ([10.88.27.145])
  by fmviesa003.fm.intel.com with ESMTP; 26 Mar 2026 22:27:06 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: dave.jiang@intel.com
Cc: patches@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com
Subject: [PATCH 6/9] dax/hmem: Fix singleton confusion between dax_hmem_work and hmem devices
Date: Thu, 26 Mar 2026 22:28:18 -0700
Message-ID: <20260327052821.440749-7-dan.j.williams@intel.com>
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

dax_hmem (ab)uses a platform device to allow for a module to autoload in
the presence of "Soft Reserved" resources. The dax_hmem driver had no
dependencies on the "hmem_platform" device being a singleton until the
recent "dax_hmem vs dax_cxl" takeover solution.

Replace the layering violation of dax_hmem_work assuming that there will
never be more than one "hmem_platform" device associated with a global work
item with a dax_hmem local workqueue that can theoretically support any
number of hmem_platform devices.

Fixup the reference counting to only pin the device while it is live in the
queue.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/bus.h         |  15 +++++-
 drivers/dax/hmem/device.c |  28 ++++++----
 drivers/dax/hmem/hmem.c   | 108 +++++++++++++++++++-------------------
 3 files changed, 85 insertions(+), 66 deletions(-)

diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index ebbfe2d6da14..7b1a83f1ce1f 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -3,7 +3,9 @@
 #ifndef __DAX_BUS_H__
 #define __DAX_BUS_H__
 #include <linux/device.h>
+#include <linux/platform_device.h>
 #include <linux/range.h>
+#include <linux/workqueue.h>
 
 struct dev_dax;
 struct resource;
@@ -49,8 +51,19 @@ void dax_driver_unregister(struct dax_device_driver *dax_drv);
 void kill_dev_dax(struct dev_dax *dev_dax);
 bool static_dev_dax(struct dev_dax *dev_dax);
 
+struct hmem_platform_device {
+	struct platform_device pdev;
+	struct work_struct work;
+	bool did_probe;
+};
+
+static inline struct hmem_platform_device *
+to_hmem_platform_device(struct platform_device *pdev)
+{
+	return container_of(pdev, struct hmem_platform_device, pdev);
+}
+
 #if IS_ENABLED(CONFIG_DEV_DAX_HMEM)
-extern bool dax_hmem_initial_probe;
 void dax_hmem_flush_work(void);
 #else
 static inline void dax_hmem_flush_work(void) { }
diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
index 675d56276d78..d70359b4307b 100644
--- a/drivers/dax/hmem/device.c
+++ b/drivers/dax/hmem/device.c
@@ -4,13 +4,11 @@
 #include <linux/module.h>
 #include <linux/dax.h>
 #include <linux/mm.h>
+#include "../bus.h"
 
 static bool nohmem;
 module_param_named(disable, nohmem, bool, 0444);
 
-bool dax_hmem_initial_probe;
-EXPORT_SYMBOL_FOR_MODULES(dax_hmem_initial_probe, "dax_hmem");
-
 static bool platform_initialized;
 static DEFINE_MUTEX(hmem_resource_lock);
 static struct resource hmem_active = {
@@ -36,9 +34,21 @@ int walk_hmem_resources(struct device *host, walk_hmem_fn fn)
 }
 EXPORT_SYMBOL_GPL(walk_hmem_resources);
 
+static void hmem_work(struct work_struct *work)
+{
+	/* place holder until dax_hmem driver attaches */
+}
+
+static struct hmem_platform_device hmem_platform = {
+	.pdev = {
+		.name = "hmem_platform",
+		.id = 0,
+	},
+	.work = __WORK_INITIALIZER(hmem_platform.work, hmem_work),
+};
+
 static void __hmem_register_resource(int target_nid, struct resource *res)
 {
-	struct platform_device *pdev;
 	struct resource *new;
 	int rc;
 
@@ -54,17 +64,13 @@ static void __hmem_register_resource(int target_nid, struct resource *res)
 	if (platform_initialized)
 		return;
 
-	pdev = platform_device_alloc("hmem_platform", 0);
-	if (!pdev) {
+	rc = platform_device_register(&hmem_platform.pdev);
+	if (rc) {
 		pr_err_once("failed to register device-dax hmem_platform device\n");
 		return;
 	}
 
-	rc = platform_device_add(pdev);
-	if (rc)
-		platform_device_put(pdev);
-	else
-		platform_initialized = true;
+	platform_initialized = true;
 }
 
 void hmem_register_resource(int target_nid, struct resource *res)
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index dd3d7f93baee..e1dae83dae8d 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -59,20 +59,11 @@ static void release_hmem(void *pdev)
 	platform_device_unregister(pdev);
 }
 
-struct dax_defer_work {
-	struct platform_device *pdev;
-	struct work_struct work;
-};
-
-static void process_defer_work(struct work_struct *w);
-
-static struct dax_defer_work dax_hmem_work = {
-	.work = __WORK_INITIALIZER(dax_hmem_work.work, process_defer_work),
-};
+static struct workqueue_struct *dax_hmem_wq;
 
 void dax_hmem_flush_work(void)
 {
-	flush_work(&dax_hmem_work.work);
+	flush_workqueue(dax_hmem_wq);
 }
 EXPORT_SYMBOL_FOR_MODULES(dax_hmem_flush_work, "dax_cxl");
 
@@ -134,24 +125,6 @@ static int __hmem_register_device(struct device *host, int target_nid,
 	return rc;
 }
 
-static int hmem_register_device(struct device *host, int target_nid,
-				const struct resource *res)
-{
-	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
-	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
-			      IORES_DESC_CXL) != REGION_DISJOINT) {
-		if (!dax_hmem_initial_probe) {
-			dev_dbg(host, "await CXL initial probe: %pr\n", res);
-			queue_work(system_long_wq, &dax_hmem_work.work);
-			return 0;
-		}
-		dev_dbg(host, "deferring range to CXL: %pr\n", res);
-		return 0;
-	}
-
-	return __hmem_register_device(host, target_nid, res);
-}
-
 static int hmem_register_cxl_device(struct device *host, int target_nid,
 				    const struct resource *res)
 {
@@ -170,35 +143,55 @@ static int hmem_register_cxl_device(struct device *host, int target_nid,
 
 static void process_defer_work(struct work_struct *w)
 {
-	struct dax_defer_work *work = container_of(w, typeof(*work), work);
-	struct platform_device *pdev;
-
-	if (!work->pdev)
-		return;
-
-	pdev = work->pdev;
+	struct hmem_platform_device *hpdev = container_of(w, typeof(*hpdev), work);
+	struct device *dev = &hpdev->pdev.dev;
 
 	/* Relies on cxl_acpi and cxl_pci having had a chance to load */
 	wait_for_device_probe();
 
-	guard(device)(&pdev->dev);
-	if (!pdev->dev.driver)
-		return;
+	guard(device)(dev);
+	if (!dev->driver)
+		goto out;
 
-	if (!dax_hmem_initial_probe) {
-		dax_hmem_initial_probe = true;
-		walk_hmem_resources(&pdev->dev, hmem_register_cxl_device);
+	if (!hpdev->did_probe) {
+		hpdev->did_probe = true;
+		walk_hmem_resources(dev, hmem_register_cxl_device);
 	}
+out:
+	put_device(dev);
+}
+
+static int hmem_register_device(struct device *host, int target_nid,
+				const struct resource *res)
+{
+	struct platform_device *pdev = to_platform_device(host);
+	struct hmem_platform_device *hpdev = to_hmem_platform_device(pdev);
+
+	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
+	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
+			      IORES_DESC_CXL) != REGION_DISJOINT) {
+		if (!hpdev->did_probe) {
+			dev_dbg(host, "await CXL initial probe: %pr\n", res);
+			hpdev->work.func = process_defer_work;
+			get_device(host);
+			if (!queue_work(dax_hmem_wq, &hpdev->work))
+				put_device(host);
+			return 0;
+		}
+		dev_dbg(host, "deferring range to CXL: %pr\n", res);
+		return 0;
+	}
+
+	return __hmem_register_device(host, target_nid, res);
 }
 
 static int dax_hmem_platform_probe(struct platform_device *pdev)
 {
-	if (work_pending(&dax_hmem_work.work))
-		return -EBUSY;
+	struct hmem_platform_device *hpdev = to_hmem_platform_device(pdev);
 
-	if (!dax_hmem_work.pdev)
-		dax_hmem_work.pdev =
-			to_platform_device(get_device(&pdev->dev));
+	/* queue is only flushed on module unload, fail rebind with pending work */
+	if (work_pending(&hpdev->work))
+		return -EBUSY;
 
 	return walk_hmem_resources(&pdev->dev, hmem_register_device);
 }
@@ -224,26 +217,33 @@ static __init int dax_hmem_init(void)
 		request_module("cxl_pci");
 	}
 
+	dax_hmem_wq = alloc_ordered_workqueue("dax_hmem_wq", 0);
+	if (!dax_hmem_wq)
+		return -ENOMEM;
+
 	rc = platform_driver_register(&dax_hmem_platform_driver);
 	if (rc)
-		return rc;
+		goto err_platform_driver;
 
 	rc = platform_driver_register(&dax_hmem_driver);
 	if (rc)
-		platform_driver_unregister(&dax_hmem_platform_driver);
+		goto err_driver;
+
+	return 0;
+
+err_driver:
+	platform_driver_unregister(&dax_hmem_platform_driver);
+err_platform_driver:
+	destroy_workqueue(dax_hmem_wq);
 
 	return rc;
 }
 
 static __exit void dax_hmem_exit(void)
 {
-	if (dax_hmem_work.pdev) {
-		flush_work(&dax_hmem_work.work);
-		put_device(&dax_hmem_work.pdev->dev);
-	}
-
 	platform_driver_unregister(&dax_hmem_driver);
 	platform_driver_unregister(&dax_hmem_platform_driver);
+	destroy_workqueue(dax_hmem_wq);
 }
 
 module_init(dax_hmem_init);
-- 
2.53.0

