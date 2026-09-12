Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2203837204A;
	Sat, 12 Sep 2026 07:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197194; cv=none; b=YR9/3xmM5CtBzZaUjzB62nXnjUlGb/fsfBm04UpmWWFT6cbFRp1PdXRSncMdl245CSKJuO2UFC8uiqOZZy8UykDbxx3VS3+Cr/aNvQ4BGuJNYqpQLvy8EBh+rovFH3PtDJqkhcyk9yqszc6E823iVEMBwz591r1hyAgCulbORy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197194; c=relaxed/simple;
	bh=QxDYUtIIkIqc0M2dggXhc4JQcAq8etiydYd4LUbJ30Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3U10hjL51Tz9uklgeukFHMNtAR0a6rnVB+3b9ldmOXdD1WslfTsiGlBWyOgq1wRRuchbAjp+TSTfGcw5EzcAgDhTHCu6XSRyDVZ7v6BDj3DrTvsotCL/E4GPQvekUpmR5uggNJqc7P9X2pC2JQVsev1YSwcoGW7Fb8aYd56IIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1KGp33e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1KGp33e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5459A1F000FF;
	Sat, 12 Sep 2026 07:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197193;
	bh=QGjh1tLYVUtRauNe/tsITvjjXaOPwoLkLTuWmDKEby4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1KGp33eHi9iuPQcBGwcwjiD9PSzTub7E4y7luKJqk0IB2t+POFGonAW8gn0/peyP
	 UGjjgcWItyslZHJ1Coe1YFbfppddebzwPsaoOohnKvpZtnvv7/gUNgLgLfPmrZEfaR
	 VCjJInKuDsucAgpWkI8ahBk3LphaXX8CjV6AHMyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0120/1815] cxl/test: Add hierarchy enumeration support for type2 device
Date: Sat, 12 Sep 2026 08:31:10 +0200
Message-ID: <20260912065651.829115005@linuxfoundation.org>
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

[ Upstream commit 6b2e585142e68b4af821a1eca4d1e8d54bd49bb8 ]

Add enumeration of type2 device hierarchy in cxl-test. The type2 device
is setup to be directly attached to a root port instead of rp -> switch
-> device that type3 hierarchy is setup..

Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260629221104.3891733-5-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 98ba41c3236b ("cxl/test: Propagate -ENOMEM on platform_device_alloc() failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c | 232 ++++++++++++++++++++++++++++-------
 1 file changed, 189 insertions(+), 43 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 202645c78f806..4f649ff0cb05b 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -27,6 +27,7 @@ static bool fail_autoassemble;
 #define NR_CXL_SWITCH_PORTS 2
 #define NR_CXL_PORT_DECODERS 8
 #define NR_BRIDGES (NR_CXL_HOST_BRIDGES + NR_CXL_SINGLE_HOST + NR_CXL_RCH)
+#define NR_CXL_TYPE2_ACCEL 1
 
 #define MOCK_AUTO_REGION_SIZE_DEFAULT SZ_512M
 static int mock_auto_region_size = MOCK_AUTO_REGION_SIZE_DEFAULT;
@@ -1724,19 +1725,93 @@ static void cxl_single_topo_exit(void)
 	}
 }
 
-static void cxl_mem_exit(void)
+static void cxl_type3_mem_exit(void)
 {
+	struct platform_device *pdev;
 	int i;
 
-	for (i = ARRAY_SIZE(cxl_rcd) - 1; i >= 0; i--)
+	for (i = ARRAY_SIZE(cxl_rcd) - 1; i >= 0; i--) {
+		pdev = cxl_rcd[i];
+		if (!pdev)
+			continue;
 		platform_device_unregister(cxl_rcd[i]);
-	for (i = ARRAY_SIZE(cxl_mem_single) - 1; i >= 0; i--)
+	}
+
+	for (i = ARRAY_SIZE(cxl_mem_single) - 1; i >= 0; i--) {
+		pdev = cxl_mem_single[i];
+		if (!pdev)
+			continue;
 		platform_device_unregister(cxl_mem_single[i]);
-	for (i = ARRAY_SIZE(cxl_mem) - 1; i >= 0; i--)
-		platform_device_unregister(cxl_mem[i]);
+	}
+
+	for (i = ARRAY_SIZE(cxl_mem) - 1; i >= 0; i--) {
+		pdev = cxl_mem[i];
+		if (!pdev)
+			continue;
+		platform_device_unregister(pdev);
+	}
 }
 
-static int cxl_mem_init(void)
+static void cxl_type2_mem_exit(void)
+{
+	for (int i = NR_CXL_TYPE2_ACCEL - 1; i >= 0; i--) {
+		struct platform_device *pdev = cxl_mem[i];
+
+		if (!pdev)
+			continue;
+		platform_device_unregister(pdev);
+	}
+}
+
+static void cxl_mem_exit(void)
+{
+	if (type2_test) {
+		cxl_type2_mem_exit();
+		return;
+	}
+
+	cxl_type3_mem_exit();
+}
+
+static int cxl_type2_mem_init(void)
+{
+	int i, rc;
+
+	for (i = 0; i < NR_CXL_TYPE2_ACCEL; i++) {
+		struct platform_device *dport = cxl_root_port[i];
+		struct platform_device *pdev;
+
+		pdev = platform_device_alloc("cxl_type2_accel", i);
+		if (!pdev) {
+			rc = -ENOMEM;
+			goto err_mem;
+		}
+		pdev->dev.parent = &dport->dev;
+		set_dev_node(&pdev->dev, i % 2);
+
+		rc = platform_device_add(pdev);
+		if (rc) {
+			rc = -ENOMEM;
+			platform_device_put(pdev);
+			goto err_mem;
+		}
+		cxl_mem[i] = pdev;
+	}
+
+	return 0;
+
+err_mem:
+	for (i = NR_CXL_TYPE2_ACCEL - 1; i >= 0; i--) {
+		struct platform_device *pdev = cxl_mem[i];
+
+		if (!pdev)
+			continue;
+		platform_device_unregister(pdev);
+	}
+	return rc;
+}
+
+static int cxl_type3_mem_init(void)
 {
 	int i, rc;
 
@@ -1745,8 +1820,10 @@ static int cxl_mem_init(void)
 		struct platform_device *pdev;
 
 		pdev = platform_device_alloc("cxl_mem", i);
-		if (!pdev)
+		if (!pdev) {
+			rc = -ENOMEM;
 			goto err_mem;
+		}
 		pdev->dev.parent = &dport->dev;
 		set_dev_node(&pdev->dev, i % 2);
 
@@ -1760,8 +1837,10 @@ static int cxl_mem_init(void)
 		struct platform_device *pdev;
 
 		pdev = platform_device_alloc("cxl_mem", NR_MEM_MULTI + i);
-		if (!pdev)
+		if (!pdev) {
+			rc = -ENOMEM;
 			goto err_single;
+		}
 		pdev->dev.parent = &dport->dev;
 		set_dev_node(&pdev->dev, i % 2);
 
@@ -1776,8 +1855,10 @@ static int cxl_mem_init(void)
 		struct platform_device *pdev;
 
 		pdev = platform_device_alloc("cxl_rcd", idx);
-		if (!pdev)
+		if (!pdev) {
+			rc = -ENOMEM;
 			goto err_rcd;
+		}
 		pdev->dev.parent = &rch->dev;
 		set_dev_node(&pdev->dev, i % 2);
 
@@ -1800,6 +1881,13 @@ static int cxl_mem_init(void)
 	return rc;
 }
 
+static int cxl_mem_init(void)
+{
+	if (type2_test)
+		return cxl_type2_mem_init();
+	return cxl_type3_mem_init();
+}
+
 static ssize_t
 decoder_reset_preserve_registry_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
@@ -2035,6 +2123,92 @@ static int cxl_switches_populate(void)
 	return 0;
 }
 
+static void cxl_type2_topo_exit(void)
+{
+	cxl_rootports_remove();
+	host_bridges_remove();
+}
+
+static int cxl_type2_topo_init(void)
+{
+	int rc;
+
+	rc = host_bridges_populate();
+	if (rc)
+		return rc;
+
+	rc = cxl_rootports_populate();
+	if (rc) {
+		host_bridges_remove();
+		return rc;
+	}
+
+	return 0;
+}
+
+static void cxl_type3_topo_exit(void)
+{
+	cxl_rch_topo_exit();
+	cxl_single_topo_exit();
+	cxl_switches_remove();
+	cxl_rootports_remove();
+	host_bridges_remove();
+}
+
+static int cxl_type3_topo_init(void)
+{
+	int rc;
+
+	rc = host_bridges_populate();
+	if (rc)
+		return rc;
+
+	rc = cxl_rootports_populate();
+	if (rc)
+		goto err_host_bridges;
+
+	rc = cxl_switches_populate();
+	if (rc)
+		goto err_root_ports;
+
+	rc = cxl_single_topo_init();
+	if (rc)
+		goto err_switches;
+
+	rc = cxl_rch_topo_init();
+	if (rc)
+		goto err_single;
+
+	return 0;
+
+err_single:
+	cxl_single_topo_exit();
+err_switches:
+	cxl_switches_remove();
+err_root_ports:
+	cxl_rootports_remove();
+err_host_bridges:
+	host_bridges_remove();
+	return rc;
+}
+
+static void cxl_topo_exit(void)
+{
+	if (type2_test) {
+		cxl_type2_topo_exit();
+		return;
+	}
+
+	cxl_type3_topo_exit();
+}
+
+static int cxl_topo_init(void)
+{
+	if (type2_test)
+		return cxl_type2_topo_init();
+	return cxl_type3_topo_init();
+}
+
 static __init int cxl_test_init(void)
 {
 	struct range mappable;
@@ -2084,29 +2258,13 @@ static __init int cxl_test_init(void)
 	if (rc)
 		goto err_populate;
 
-	rc = host_bridges_populate();
+	rc = cxl_topo_init();
 	if (rc)
 		goto err_populate;
 
-	rc = cxl_rootports_populate();
-	if (rc)
-		goto err_host_bridges;
-
-	rc = cxl_switches_populate();
-	if (rc)
-		goto err_root_ports;
-
-	rc = cxl_single_topo_init();
-	if (rc)
-		goto err_switches;
-
-	rc = cxl_rch_topo_init();
-	if (rc)
-		goto err_single;
-
 	cxl_acpi = platform_device_alloc("cxl_acpi", 0);
 	if (!cxl_acpi)
-		goto err_rch;
+		goto err_topo;
 
 	mock_companion(&acpi0017_mock, &cxl_acpi->dev);
 	acpi0017_mock.dev.bus = &platform_bus_type;
@@ -2114,7 +2272,7 @@ static __init int cxl_test_init(void)
 
 	rc = cxl_mock_platform_device_add(cxl_acpi, NULL);
 	if (rc)
-		goto err_rch;
+		goto err_topo;
 
 	rc = cxl_mem_init();
 	if (rc)
@@ -2130,16 +2288,8 @@ static __init int cxl_test_init(void)
 	cxl_mem_exit();
 err_root:
 	platform_device_unregister(cxl_acpi);
-err_rch:
-	cxl_rch_topo_exit();
-err_single:
-	cxl_single_topo_exit();
-err_switches:
-	cxl_switches_remove();
-err_root_ports:
-	cxl_rootports_remove();
-err_host_bridges:
-	host_bridges_remove();
+err_topo:
+	cxl_topo_exit();
 err_populate:
 	depopulate_all_mock_resources();
 err_gen_pool_add:
@@ -2165,11 +2315,7 @@ static __exit void cxl_test_exit(void)
 	hmem_test_exit();
 	cxl_mem_exit();
 	platform_device_unregister(cxl_acpi);
-	cxl_rch_topo_exit();
-	cxl_single_topo_exit();
-	cxl_switches_remove();
-	cxl_rootports_remove();
-	host_bridges_remove();
+	cxl_topo_exit();
 	depopulate_all_mock_resources();
 	gen_pool_destroy(cxl_mock_pool);
 	unregister_cxl_mock_ops(&cxl_mock_ops);
-- 
2.53.0



