Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131F12DB7A3;
	Sun,  7 Jun 2026 10:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827484; cv=none; b=r0nevuwvx/3mDpqiXvbxxNxHc7OGYsJS0uaZ+kyq139hJTz2+LDexkPhpc7I6oWGCAa8/5hDyJCD+189VbIpbeQtagp+QQdqgaJZd3xbsYzC0nIUp8W2p1IrxLc3V+8C+i7eE7VLLKbj3Hx85hwpY9jTX6zeV+8G4ZRVUXUnwek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827484; c=relaxed/simple;
	bh=X06o6peZPVjDhX3xUTY5ofoBql9wI2bIfUABBeJf8wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/UqtojWryNLYh26a0IXdeAkzPlKwb2rb+Cz11da7q9SPR8QjS0nSvdSmSRZdj3RD8DVT6Ic2VLcBxwLfi3mzsV2B5OVAkoxApdEkUNiQVOrkit90+4TWHQLuzcEtDM0usaMvd9KmoWhc7LicV/SO1eR53zT9vt9iIiI5i90FGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPrRljTE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPrRljTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BF51F00893;
	Sun,  7 Jun 2026 10:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827482;
	bh=WXdz+lZ8F5lLxXi4aTrHvlip2HMglQ1XbRAXnAQhkyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPrRljTECOW6nJOYsJx2Jpc+zeq6JPiiutfzYh/gfRUnyln5MyITByow/uNvki6Jn
	 7pPJ5qt97mTuR2sygJhRB46LdPTZMHwT0Qco9RFc7Jt/TOuM6Qw1c7hTUwlvyIeNni
	 w1LM5irVEwkY0DIGoCDcbrP4STibPeCtZnkV1uRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ming <ming.li@zohomail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/307] cxl/test: Update mock dev array before calling platform_device_add()
Date: Sun,  7 Jun 2026 11:57:36 +0200
Message-ID: <20260607095729.910425596@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 050725afa45d16..0d0c434426e7bf 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -1058,6 +1058,23 @@ static void mock_companion(struct acpi_device *adev, struct device *dev)
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
@@ -1072,13 +1089,10 @@ static __init int cxl_rch_topo_init(void)
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
@@ -1130,13 +1144,10 @@ static __init int cxl_single_topo_init(void)
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
@@ -1155,12 +1166,9 @@ static __init int cxl_single_topo_init(void)
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
@@ -1173,12 +1181,9 @@ static __init int cxl_single_topo_init(void)
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
@@ -1192,12 +1197,9 @@ static __init int cxl_single_topo_init(void)
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
@@ -1270,12 +1272,9 @@ static int cxl_mem_init(void)
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
@@ -1288,12 +1287,9 @@ static int cxl_mem_init(void)
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
@@ -1307,12 +1303,9 @@ static int cxl_mem_init(void)
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
@@ -1373,13 +1366,10 @@ static __init int cxl_test_init(void)
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
@@ -1397,12 +1387,9 @@ static __init int cxl_test_init(void)
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
@@ -1415,12 +1402,9 @@ static __init int cxl_test_init(void)
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
@@ -1433,12 +1417,9 @@ static __init int cxl_test_init(void)
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
@@ -1456,9 +1437,9 @@ static __init int cxl_test_init(void)
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



