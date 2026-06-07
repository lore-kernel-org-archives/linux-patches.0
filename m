Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3B54204E;
	Sun,  7 Jun 2026 10:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827027; cv=none; b=cCf8+QFa8yCtE+re2q0loxpIiDzmGIe9Cjy1IxSdg/76iDsO/q17KN2sF6Sl6aiMHymB7YB31Pi1MJY4Ogy+9QoUqJbu9nZMpdpx5sLr53tea9DD7ajt1qNfl9MfEN1LNQ9VFBpX/RYyHO5uZtW/F3uzyEdPMDB+TuY1b2gaogM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827027; c=relaxed/simple;
	bh=uoItW4Q4Bf8VJ9KQadYV7By7R/YxlMxxTNTdiKYEC/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlgTKHeJdSErDRSlQy73lplbX8/JdQGb+EMaZINj6mDg7dnd2WEkgi1EPHbJoCW01GVCE55R0GMCyGj5p0uWI918vc8glpcmdVoooLtbY8cwl4bdHAedUfwcFV4CdzevL2lgZXQLG56UhqQNB+069b2MJOQInhTP/yhoBayz1tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yj00aYIl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yj00aYIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A29B1F00893;
	Sun,  7 Jun 2026 10:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827026;
	bh=nqtBj/ZMkBC4tRfm2+CgrevZhUWNndbtZZigbtvtOd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yj00aYIlwQCGiCz3qLkBZzbvBIMPsPw3n0e8uMXcUlN1zbu9qyBCSuvPhf9WRPNwU
	 Hxl17oKtER4VfbLHK1jZlvD6F05Panniu6ziYnxlUMxgvTVtwJLuiHM0dB2Xp8qiIL
	 zkHj22NUmzCHJsDVE2nPruJDfqmzsrGbK2d+jY54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ming <ming.li@zohomail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 056/332] cxl/test: Update mock dev array before calling platform_device_add()
Date: Sun,  7 Jun 2026 11:57:05 +0200
Message-ID: <20260607095730.184870392@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Ming <ming.li@zohomail.com>

[ Upstream commit d90f236f8b9e354848bd226f581db27755ab901d ]

CXL test environment hits the following error sometimes.

 cxl_mem mem9: endpoint7 failed probe

All mock memdevs are platform firmware devices added by cxl_test module,
and cxl_test module also provides a platform device driver for them to
create a memdev device to CXL subsystem. cxl_test module uses
cxl_rcd/mem_single/mem arrays to store different types of mock memdevs.
CXL drivers calls registered mock functions for a mock memdev by
checking if a given memdev is in these arrays.

When cxl_test module adds these mock memdevs, it always calls
platform_device_add() before adding them to a suitable mock memdev
array. However, there is a small window where CXL drivers calls mock
function for a added memdev before it added to a mock memdev array. In
above case, cxl endpoint driver considers a added memdev was not a mock
memdev, then calling devm_cxl_endpoint_decoders_setup() for it rather
than mock_endpoint_decoders_setup().

An appropriate solution is that adding a new mock device to a mock
device array before calling platform_device_add() for it. It can
guarantee the new mock device is visible to CXL subsystem.

This patch introduces a new helped called cxl_mock_platform_device_add()
to handle the issue, and uses the function for all mock devices addition.

Fixes: 3a2b97b3210b ("cxl/test: Improve init-order fidelity relative to real-world systems")
Signed-off-by: Li Ming <ming.li@zohomail.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260520121457.234404-1-ming.li@zohomail.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c | 105 ++++++++++++++---------------------
 1 file changed, 43 insertions(+), 62 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 81e2aef3627a44..f4c26441fc41af 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -1144,6 +1144,23 @@ static void mock_companion(struct acpi_device *adev, struct device *dev)
 #define SZ_64G (SZ_32G * 2)
 #endif
 
+static int cxl_mock_platform_device_add(struct platform_device *pdev,
+					struct platform_device **ppdev)
+{
+	int rc;
+
+	if (ppdev)
+		*ppdev = pdev;
+	rc = platform_device_add(pdev);
+	if (rc) {
+		platform_device_put(pdev);
+		if (ppdev)
+			*ppdev = NULL;
+	}
+
+	return rc;
+}
+
 static __init int cxl_rch_topo_init(void)
 {
 	int rc, i;
@@ -1158,13 +1175,10 @@ static __init int cxl_rch_topo_init(void)
 			goto err_bridge;
 
 		mock_companion(adev, &pdev->dev);
-		rc = platform_device_add(pdev);
-		if (rc) {
-			platform_device_put(pdev);
+		rc = cxl_mock_platform_device_add(pdev, &cxl_rch[i]);
+		if (rc)
 			goto err_bridge;
-		}
 
-		cxl_rch[i] = pdev;
 		mock_pci_bus[idx].bridge = &pdev->dev;
 		rc = sysfs_create_link(&pdev->dev.kobj, &pdev->dev.kobj,
 				       "firmware_node");
@@ -1216,13 +1230,10 @@ static __init int cxl_single_topo_init(void)
 			goto err_bridge;
 
 		mock_companion(adev, &pdev->dev);
-		rc = platform_device_add(pdev);
-		if (rc) {
-			platform_device_put(pdev);
+		rc = cxl_mock_platform_device_add(pdev, &cxl_hb_single[i]);
+		if (rc)
 			goto err_bridge;
-		}
 
-		cxl_hb_single[i] = pdev;
 		mock_pci_bus[i + NR_CXL_HOST_BRIDGES].bridge = &pdev->dev;
 		rc = sysfs_create_link(&pdev->dev.kobj, &pdev->dev.kobj,
 				       "physical_node");
@@ -1241,12 +1252,9 @@ static __init int cxl_single_topo_init(void)
 			goto err_port;
 		pdev->dev.parent = &bridge->dev;
 
-		rc = platform_device_add(pdev);
-		if (rc) {
-			platform_device_put(pdev);
+		rc = cxl_mock_platform_device_add(pdev, &cxl_root_single[i]);
+		if (rc)
 			goto err_port;
-		}
-		cxl_root_single[i] = pdev;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(cxl_swu_single); i++) {
@@ -1259,12 +1267,9 @@ static __init int cxl_single_topo_init(void)
 			goto err_uport;
 		pdev->dev.parent = &root_port->dev;
 
-		rc = platform_device_add(pdev);
-		if (rc) {
-			platform_device_put(pdev);
+		rc = cxl_mock_platform_device_add(pdev, &cxl_swu_single[i]);
+		if (rc)
 			goto err_uport;
-		}
-		cxl_swu_single[i] = pdev;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(cxl_swd_single); i++) {
@@ -1278,12 +1283,9 @@ static __init int cxl_single_topo_init(void)
 			goto err_dport;
 		pdev->dev.parent = &uport->dev;
 
-		rc = platform_device_add(pdev);
-		if (rc) {
-			platform_device_put(pdev);
+		rc = cxl_mock_platform_device_add(pdev, &cxl_swd_single[i]);
+		if (rc)
 			goto err_dport;
-		}
-		cxl_swd_single[i] = pdev;
 	}
 
 	return 0;
@@ -1356,12 +1358,9 @@ static int cxl_mem_init(void)
 		pdev->dev.parent = &dport->dev;
 		set_dev_node(&pdev->dev, i % 2);
 
-		rc = platform_device_add(pdev);
-		if (rc) {
-			platform_device_put(pdev);
+		rc = cxl_mock_platform_device_add(pdev, &cxl_mem[i]);
+		if (rc)
 			goto err_mem;
-		}
-		cxl_mem[i] = pdev;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(cxl_mem_single); i++) {
@@ -1374,12 +1373,9 @@ static int cxl_mem_init(void)
 		pdev->dev.parent = &dport->dev;
 		set_dev_node(&pdev->dev, i % 2);
 
-		rc = platform_device_add(pdev);
-		if (rc) {
-			platform_device_put(pdev);
+		rc = cxl_mock_platform_device_add(pdev, &cxl_mem_single[i]);
+		if (rc)
 			goto err_single;
-		}
-		cxl_mem_single[i] = pdev;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(cxl_rcd); i++) {
@@ -1393,12 +1389,9 @@ static int cxl_mem_init(void)
 		pdev->dev.parent = &rch->dev;
 		set_dev_node(&pdev->dev, i % 2);
 
-		rc = platform_device_add(pdev);
-		if (rc) {
-			platform_device_put(pdev);
+		rc = cxl_mock_platform_device_add(pdev, &cxl_rcd[i]);
+		if (rc)
 			goto err_rcd;
-		}
-		cxl_rcd[i] = pdev;
 	}
 
 	return 0;
@@ -1463,13 +1456,10 @@ static __init int cxl_test_init(void)
 			goto err_bridge;
 
 		mock_companion(adev, &pdev->dev);
-		rc = platform_device_add(pdev);
-		if (rc) {
-			platform_device_put(pdev);
+		rc = cxl_mock_platform_device_add(pdev, &cxl_host_bridge[i]);
+		if (rc)
 			goto err_bridge;
-		}
 
-		cxl_host_bridge[i] = pdev;
 		mock_pci_bus[i].bridge = &pdev->dev;
 		rc = sysfs_create_link(&pdev->dev.kobj, &pdev->dev.kobj,
 				       "physical_node");
@@ -1487,12 +1477,9 @@ static __init int cxl_test_init(void)
 			goto err_port;
 		pdev->dev.parent = &bridge->dev;
 
-		rc = platform_device_add(pdev);
-		if (rc) {
-			platform_device_put(pdev);
+		rc = cxl_mock_platform_device_add(pdev, &cxl_root_port[i]);
+		if (rc)
 			goto err_port;
-		}
-		cxl_root_port[i] = pdev;
 	}
 
 	BUILD_BUG_ON(ARRAY_SIZE(cxl_switch_uport) != ARRAY_SIZE(cxl_root_port));
@@ -1505,12 +1492,9 @@ static __init int cxl_test_init(void)
 			goto err_uport;
 		pdev->dev.parent = &root_port->dev;
 
-		rc = platform_device_add(pdev);
-		if (rc) {
-			platform_device_put(pdev);
+		rc = cxl_mock_platform_device_add(pdev, &cxl_switch_uport[i]);
+		if (rc)
 			goto err_uport;
-		}
-		cxl_switch_uport[i] = pdev;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(cxl_switch_dport); i++) {
@@ -1523,12 +1507,9 @@ static __init int cxl_test_init(void)
 			goto err_dport;
 		pdev->dev.parent = &uport->dev;
 
-		rc = platform_device_add(pdev);
-		if (rc) {
-			platform_device_put(pdev);
+		rc = cxl_mock_platform_device_add(pdev, &cxl_switch_dport[i]);
+		if (rc)
 			goto err_dport;
-		}
-		cxl_switch_dport[i] = pdev;
 	}
 
 	rc = cxl_single_topo_init();
@@ -1546,9 +1527,9 @@ static __init int cxl_test_init(void)
 	mock_companion(&acpi0017_mock, &cxl_acpi->dev);
 	acpi0017_mock.dev.bus = &platform_bus_type;
 
-	rc = platform_device_add(cxl_acpi);
+	rc = cxl_mock_platform_device_add(cxl_acpi, NULL);
 	if (rc)
-		goto err_root;
+		goto err_rch;
 
 	rc = cxl_mem_init();
 	if (rc)
-- 
2.53.0



