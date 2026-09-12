Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F2A3806C6;
	Sat, 12 Sep 2026 07:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197190; cv=none; b=jznqHG0Bv3rkDWSZ60NHcKiJsX5FM2xpIHfzcB3ugOopBVuGxWVDvfT6PaxrPgVUDB/LaftF7fKMQjmyOd6NC8M2dP0CALqNJTKLNtWztQTUbHHM4ANTuTZj4/OeKsVib9jzAKFMwTzBB6PyzwpQlBM1tHY3nZcC5idbPUTgeTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197190; c=relaxed/simple;
	bh=RsMfKXwEEpShfxOPYuIebYuFGAswL3zbOuGiiQpKebU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7gCDljZO6ZeHLAduucfQmPnzjH09NV+zQa8Hlloqv8MsBv2B2u+zootYSZhXFBUajm7n5M+lgOI9xcvriZdcc0d9vd7K3T8yQDj05vTuAd1O7+p44cs3fCdlFV3rd0uMz/AnU3M6yjDcfX8R4+uJct8ii2xlr0rMIZJK0fyVho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1l9qs3J2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1l9qs3J2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882561F000FF;
	Sat, 12 Sep 2026 07:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197189;
	bh=LXZt8YWqyTKtB+bvUIXmQuZado2WEWHT0I79W9J8c8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1l9qs3J2QzVYGZyV68TLEwsRS0g+aMDvGxpRFtstCddvrFuZDOqGEdY6wU9LXaSVm
	 v3XBg2V8pUHwlV2R5gCYrQ+Zdeh3I5bluK2jKUjqn0uG3vuYyR3+je4IAcS3EDG9Yd
	 rtpC5ZcOkhGslnIJagYRSN+WkOn9XrKGaG6+LG/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0119/1815] cxl/test: Refactor platform device enumerations
Date: Sat, 12 Sep 2026 08:31:09 +0200
Message-ID: <20260912065651.804990475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit a6d37152d284a49249a545861d1094cb678b5d32 ]

Split all the host bridges, rootports, upstream and downstream ports
enumerations to separate helper functions. This should make adding
type2 hierarchy easier later on.

Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260629221104.3891733-4-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 98ba41c3236b ("cxl/test: Propagate -ENOMEM on platform_device_alloc() failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c | 288 ++++++++++++++++++++++++-----------
 1 file changed, 202 insertions(+), 86 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 057724f27c6b9..202645c78f806 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -1841,62 +1841,34 @@ static bool __init have_multiple_modparms(void)
 	return count > 1;
 }
 
-static __init int cxl_test_init(void)
+static void host_bridges_remove(void)
 {
-	int rc, i;
-	struct range mappable;
-
-	/* Enforce a single module param active at a time */
-	if (have_multiple_modparms())
-		return -EINVAL;
-
-	if (!IS_ALIGNED(mock_auto_region_size, PMD_SIZE)) {
-		pr_err_once("mock_auto_region_size %d must be PMD-aligned\n",
-			    mock_auto_region_size);
-		return -EINVAL;
-	}
-
-	cxl_acpi_test();
-	cxl_core_test();
-	cxl_mem_test();
-	cxl_pmem_test();
-	cxl_port_test();
-
-	register_cxl_mock_ops(&cxl_mock_ops);
+	int i;
 
-	cxl_mock_pool = gen_pool_create(ilog2(SZ_2M), NUMA_NO_NODE);
-	if (!cxl_mock_pool) {
-		rc = -ENOMEM;
-		goto err_gen_pool_create;
-	}
-	mappable = mhp_get_pluggable_range(true);
+	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--) {
+		struct platform_device *pdev = cxl_host_bridge[i];
 
-	rc = gen_pool_add(cxl_mock_pool,
-			  min(iomem_resource.end + 1 - SZ_64G,
-			      mappable.end + 1 - SZ_64G),
-			  SZ_64G, NUMA_NO_NODE);
-	if (rc)
-		goto err_gen_pool_add;
+		if (!pdev)
+			continue;
 
-	if (interleave_arithmetic == 1) {
-		cfmws_start = CFMWS_XOR_ARRAY_START;
-		cfmws_end = CFMWS_XOR_ARRAY_END;
-	} else {
-		cfmws_start = CFMWS_MOD_ARRAY_START;
-		cfmws_end = CFMWS_MOD_ARRAY_END;
+		sysfs_remove_link(&pdev->dev.kobj, "physical_node");
+		platform_device_unregister(cxl_host_bridge[i]);
 	}
+}
 
-	rc = populate_cedt();
-	if (rc)
-		goto err_populate;
+static int host_bridges_populate(void)
+{
+	int rc = 0;
 
-	for (i = 0; i < ARRAY_SIZE(cxl_host_bridge); i++) {
+	for (int i = 0; i < ARRAY_SIZE(cxl_host_bridge); i++) {
 		struct acpi_device *adev = &host_bridge[i];
 		struct platform_device *pdev;
 
 		pdev = platform_device_alloc("cxl_host_bridge", i);
-		if (!pdev)
+		if (!pdev) {
+			rc = -ENOMEM;
 			goto err_bridge;
+		}
 
 		mock_companion(adev, &pdev->dev);
 		rc = cxl_mock_platform_device_add(pdev, &cxl_host_bridge[i]);
@@ -1910,14 +1882,40 @@ static __init int cxl_test_init(void)
 			goto err_bridge;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(cxl_root_port); i++) {
+	return 0;
+
+err_bridge:
+	host_bridges_remove();
+	return rc;
+}
+
+static void cxl_rootports_remove(void)
+{
+	for (int i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--) {
+		struct platform_device *pdev = cxl_root_port[i];
+
+		if (!pdev)
+			continue;
+
+		platform_device_unregister(pdev);
+	}
+}
+
+static int cxl_rootports_populate(void)
+{
+	int rc = 0;
+
+	for (int i = 0; i < ARRAY_SIZE(cxl_root_port); i++) {
 		struct platform_device *bridge =
 			cxl_host_bridge[i % ARRAY_SIZE(cxl_host_bridge)];
 		struct platform_device *pdev;
 
 		pdev = platform_device_alloc("cxl_root_port", i);
-		if (!pdev)
+		if (!pdev) {
+			rc = -ENOMEM;
 			goto err_port;
+		}
+
 		pdev->dev.parent = &bridge->dev;
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_root_port[i]);
@@ -1925,14 +1923,39 @@ static __init int cxl_test_init(void)
 			goto err_port;
 	}
 
-	BUILD_BUG_ON(ARRAY_SIZE(cxl_switch_uport) != ARRAY_SIZE(cxl_root_port));
-	for (i = 0; i < ARRAY_SIZE(cxl_switch_uport); i++) {
+	return 0;
+
+err_port:
+	cxl_rootports_remove();
+	return rc;
+}
+
+static void cxl_usps_remove(void)
+{
+	for (int i = ARRAY_SIZE(cxl_switch_uport) - 1; i >= 0; i--) {
+		struct platform_device *pdev = cxl_switch_uport[i];
+
+		if (!pdev)
+			continue;
+
+		platform_device_unregister(cxl_switch_uport[i]);
+	}
+}
+
+static int cxl_usps_populate(void)
+{
+	int rc = 0;
+
+	for (int i = 0; i < ARRAY_SIZE(cxl_switch_uport); i++) {
 		struct platform_device *root_port = cxl_root_port[i];
 		struct platform_device *pdev;
 
 		pdev = platform_device_alloc("cxl_switch_uport", i);
-		if (!pdev)
+		if (!pdev) {
+			rc = -ENOMEM;
 			goto err_uport;
+		}
+
 		pdev->dev.parent = &root_port->dev;
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_switch_uport[i]);
@@ -1940,14 +1963,40 @@ static __init int cxl_test_init(void)
 			goto err_uport;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(cxl_switch_dport); i++) {
+	return 0;
+
+err_uport:
+	cxl_usps_remove();
+	return rc;
+}
+
+static void cxl_dsps_remove(void)
+{
+	for (int i = ARRAY_SIZE(cxl_switch_dport) - 1; i >= 0; i--) {
+		struct platform_device *pdev = cxl_switch_dport[i];
+
+		if (!pdev)
+			continue;
+
+		platform_device_unregister(cxl_switch_dport[i]);
+	}
+}
+
+
+static int cxl_dsps_populate(void)
+{
+	int rc = 0;
+
+	for (int i = 0; i < ARRAY_SIZE(cxl_switch_dport); i++) {
 		struct platform_device *uport =
 			cxl_switch_uport[i % ARRAY_SIZE(cxl_switch_uport)];
 		struct platform_device *pdev;
 
 		pdev = platform_device_alloc("cxl_switch_dport", i);
-		if (!pdev)
+		if (!pdev) {
+			rc = -ENOMEM;
 			goto err_dport;
+		}
 		pdev->dev.parent = &uport->dev;
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_switch_dport[i]);
@@ -1955,9 +2004,101 @@ static __init int cxl_test_init(void)
 			goto err_dport;
 	}
 
+	return 0;
+
+err_dport:
+	cxl_dsps_remove();
+	return rc;
+}
+
+static void cxl_switches_remove(void)
+{
+	cxl_dsps_remove();
+	cxl_usps_remove();
+}
+
+static int cxl_switches_populate(void)
+{
+	int rc;
+
+	BUILD_BUG_ON(ARRAY_SIZE(cxl_switch_uport) != ARRAY_SIZE(cxl_root_port));
+	rc = cxl_usps_populate();
+	if (rc)
+		return rc;
+
+	rc = cxl_dsps_populate();
+	if (rc) {
+		cxl_usps_remove();
+		return rc;
+	}
+
+	return 0;
+}
+
+static __init int cxl_test_init(void)
+{
+	struct range mappable;
+	int rc;
+
+	/* Enforce a single module param active at a time */
+	if (have_multiple_modparms())
+		return -EINVAL;
+
+	if (!IS_ALIGNED(mock_auto_region_size, PMD_SIZE)) {
+		pr_err_once("mock_auto_region_size %d must be PMD-aligned\n",
+			    mock_auto_region_size);
+		return -EINVAL;
+	}
+
+	cxl_acpi_test();
+	cxl_core_test();
+	cxl_mem_test();
+	cxl_pmem_test();
+	cxl_port_test();
+
+	register_cxl_mock_ops(&cxl_mock_ops);
+
+	cxl_mock_pool = gen_pool_create(ilog2(SZ_2M), NUMA_NO_NODE);
+	if (!cxl_mock_pool) {
+		rc = -ENOMEM;
+		goto err_gen_pool_create;
+	}
+	mappable = mhp_get_pluggable_range(true);
+
+	rc = gen_pool_add(cxl_mock_pool,
+			  min(iomem_resource.end + 1 - SZ_64G,
+			      mappable.end + 1 - SZ_64G),
+			  SZ_64G, NUMA_NO_NODE);
+	if (rc)
+		goto err_gen_pool_add;
+
+	if (interleave_arithmetic == 1) {
+		cfmws_start = CFMWS_XOR_ARRAY_START;
+		cfmws_end = CFMWS_XOR_ARRAY_END;
+	} else {
+		cfmws_start = CFMWS_MOD_ARRAY_START;
+		cfmws_end = CFMWS_MOD_ARRAY_END;
+	}
+
+	rc = populate_cedt();
+	if (rc)
+		goto err_populate;
+
+	rc = host_bridges_populate();
+	if (rc)
+		goto err_populate;
+
+	rc = cxl_rootports_populate();
+	if (rc)
+		goto err_host_bridges;
+
+	rc = cxl_switches_populate();
+	if (rc)
+		goto err_root_ports;
+
 	rc = cxl_single_topo_init();
 	if (rc)
-		goto err_dport;
+		goto err_switches;
 
 	rc = cxl_rch_topo_init();
 	if (rc)
@@ -1993,24 +2134,12 @@ static __init int cxl_test_init(void)
 	cxl_rch_topo_exit();
 err_single:
 	cxl_single_topo_exit();
-err_dport:
-	for (i = ARRAY_SIZE(cxl_switch_dport) - 1; i >= 0; i--)
-		platform_device_unregister(cxl_switch_dport[i]);
-err_uport:
-	for (i = ARRAY_SIZE(cxl_switch_uport) - 1; i >= 0; i--)
-		platform_device_unregister(cxl_switch_uport[i]);
-err_port:
-	for (i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--)
-		platform_device_unregister(cxl_root_port[i]);
-err_bridge:
-	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--) {
-		struct platform_device *pdev = cxl_host_bridge[i];
-
-		if (!pdev)
-			continue;
-		sysfs_remove_link(&pdev->dev.kobj, "physical_node");
-		platform_device_unregister(cxl_host_bridge[i]);
-	}
+err_switches:
+	cxl_switches_remove();
+err_root_ports:
+	cxl_rootports_remove();
+err_host_bridges:
+	host_bridges_remove();
 err_populate:
 	depopulate_all_mock_resources();
 err_gen_pool_add:
@@ -2033,27 +2162,14 @@ static void free_decoder_registry(void)
 
 static __exit void cxl_test_exit(void)
 {
-	int i;
-
 	hmem_test_exit();
 	cxl_mem_exit();
 	platform_device_unregister(cxl_acpi);
 	cxl_rch_topo_exit();
 	cxl_single_topo_exit();
-	for (i = ARRAY_SIZE(cxl_switch_dport) - 1; i >= 0; i--)
-		platform_device_unregister(cxl_switch_dport[i]);
-	for (i = ARRAY_SIZE(cxl_switch_uport) - 1; i >= 0; i--)
-		platform_device_unregister(cxl_switch_uport[i]);
-	for (i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--)
-		platform_device_unregister(cxl_root_port[i]);
-	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--) {
-		struct platform_device *pdev = cxl_host_bridge[i];
-
-		if (!pdev)
-			continue;
-		sysfs_remove_link(&pdev->dev.kobj, "physical_node");
-		platform_device_unregister(cxl_host_bridge[i]);
-	}
+	cxl_switches_remove();
+	cxl_rootports_remove();
+	host_bridges_remove();
 	depopulate_all_mock_resources();
 	gen_pool_destroy(cxl_mock_pool);
 	unregister_cxl_mock_ops(&cxl_mock_ops);
-- 
2.53.0



