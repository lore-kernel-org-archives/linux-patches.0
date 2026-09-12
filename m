Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5AC3C1D57;
	Sat, 12 Sep 2026 07:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197198; cv=none; b=WNiJJEjP0vx/M24O//iY5R18NECksmi1ObF8Qn9zGW5CRbxS0c7YPVc/wfsSWOXJHafiqMwE7mxWBMj/MBRGpAQAlLMUdzOF/6KLjB2hvE8TnVGSkFL4BUy86E8ePWqn0OCckQIfHq/ksQUllcGWkyl0izeQ04/uoavqM2feTUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197198; c=relaxed/simple;
	bh=kKs/7igtbudn4SxAGaSfQY+/Ddgklps8jWoFx8srk/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCEe1LVv/7+UKWOVNcaGVw6IL2pgt5Jjv83/LdNxpWAr60TEnA/ID8NvQsYE+CcgKCvy5OZVmTxT1V0HWRVdrloIPG3KXISOTsgtbu1anwfCSsbw3heXbUHiBVtRBxxRHjx3zX8nv1LTsdY5YBOJCiH9BiVz3eq8J3oXdnAvYBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaU9VfWk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaU9VfWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBE11F000FF;
	Sat, 12 Sep 2026 07:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197196;
	bh=rMltXA8vDrmU82wl7L9D5g/cgDu9gYpKkPxKbadMlL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TaU9VfWkTzyil+r/WStlHSxgmfBRspnpJxckHaqTmj7t50xADjfhxxWTQ+jcQC5Zx
	 m1v5Qw8DNs1jPzj/UQqIEsbvPz4EU+4Y6qQDsXJTPItNjxHEjyAvPbOOE4AGaHuHcN
	 lrlTRXrgbplY9jBN6CfnUuWk7AnhJmALWF1gIm1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0121/1815] cxl/test: Propagate -ENOMEM on platform_device_alloc() failures
Date: Sat, 12 Sep 2026 08:31:11 +0200
Message-ID: <20260912065651.855458435@linuxfoundation.org>
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

[ Upstream commit 98ba41c3236b9a3bad206dbd9cf18c98ced75726 ]

Set rc = -ENOMEM at every platform_device_alloc() failure site in
cxl_rch_topo_init(), cxl_single_topo_init() and cxl_test_init() so the
failure is propagated and the module load aborts cleanly.

The cxl_acpi allocation site originates in the commit below, while the
host-bridge/root-port/uport/dport allocation sites fixed here were added
later in the single-host and RCH topology configs.

Fixes: 67dcdd4d3b83 ("tools/testing/cxl: Introduce a mocked-up CXL port hierarchy")
Fixes: e41c8452b9b2 ("tools/testing/cxl: Add a single-port host-bridge regression config")
Fixes: c9435dbee119 ("tools/testing/cxl: Add an RCH topology")
Assisted-by: Claude:claude-opus-4-8
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260629221104.3891733-6-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 4f649ff0cb05b..8a4248207fe32 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -1564,8 +1564,10 @@ static __init int cxl_rch_topo_init(void)
 		struct platform_device *pdev;
 
 		pdev = platform_device_alloc("cxl_host_bridge", idx);
-		if (!pdev)
+		if (!pdev) {
+			rc = -ENOMEM;
 			goto err_bridge;
+		}
 
 		mock_companion(adev, &pdev->dev);
 		rc = cxl_mock_platform_device_add(pdev, &cxl_rch[i]);
@@ -1619,8 +1621,10 @@ static __init int cxl_single_topo_init(void)
 
 		pdev = platform_device_alloc("cxl_host_bridge",
 					     NR_CXL_HOST_BRIDGES + i);
-		if (!pdev)
+		if (!pdev) {
+			rc = -ENOMEM;
 			goto err_bridge;
+		}
 
 		mock_companion(adev, &pdev->dev);
 		rc = cxl_mock_platform_device_add(pdev, &cxl_hb_single[i]);
@@ -1641,8 +1645,10 @@ static __init int cxl_single_topo_init(void)
 
 		pdev = platform_device_alloc("cxl_root_port",
 					     NR_MULTI_ROOT + i);
-		if (!pdev)
+		if (!pdev) {
+			rc = -ENOMEM;
 			goto err_port;
+		}
 		pdev->dev.parent = &bridge->dev;
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_root_single[i]);
@@ -1656,8 +1662,10 @@ static __init int cxl_single_topo_init(void)
 
 		pdev = platform_device_alloc("cxl_switch_uport",
 					     NR_MULTI_ROOT + i);
-		if (!pdev)
+		if (!pdev) {
+			rc = -ENOMEM;
 			goto err_uport;
+		}
 		pdev->dev.parent = &root_port->dev;
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_swu_single[i]);
@@ -1672,8 +1680,10 @@ static __init int cxl_single_topo_init(void)
 
 		pdev = platform_device_alloc("cxl_switch_dport",
 					     i + NR_MEM_MULTI);
-		if (!pdev)
+		if (!pdev) {
+			rc = -ENOMEM;
 			goto err_dport;
+		}
 		pdev->dev.parent = &uport->dev;
 
 		rc = cxl_mock_platform_device_add(pdev, &cxl_swd_single[i]);
@@ -2263,8 +2273,10 @@ static __init int cxl_test_init(void)
 		goto err_populate;
 
 	cxl_acpi = platform_device_alloc("cxl_acpi", 0);
-	if (!cxl_acpi)
+	if (!cxl_acpi) {
+		rc = -ENOMEM;
 		goto err_topo;
+	}
 
 	mock_companion(&acpi0017_mock, &cxl_acpi->dev);
 	acpi0017_mock.dev.bus = &platform_bus_type;
-- 
2.53.0



