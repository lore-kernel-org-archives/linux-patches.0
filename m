Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A556525F7A5;
	Thu, 17 Apr 2025 17:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912591; cv=none; b=Gl+FDmOQa4ScYWUzIsKPvvO3ROG69dxCM9aWYS8+rMxNPkchTgiXREKpRMU+KZN6Q383M0YFQmW88StC4zMf5sl/HtPJLhYy1Jx3OY1UXsNwK7xsO+mn45seBq1zjqlnuhO/NvrIkiYxpZwt+SKRmBbWvsqYKBbEDdwdxmzbAW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912591; c=relaxed/simple;
	bh=QoGnGQ0i+ZYvxRRhw5dj9wL3vn6ZNqG8fyBS3rg7ttQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeN6V+VZfRDl1/vfGODcVJIaEBpoLv4WqtkQM5rXUs3GiHjX3dbEDJyWSYwmX9nXRyGO0+bAVD2QwBhtNDPsT/px5NLfiMKalZYNQW8iRgx2mPJte7QL98xi+gcEjlr59NmQFcrJWwd8qmZGF/SdTTgUpGdbsV3Hp5oXR0GdfTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BiAUnsh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BiAUnsh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163D3C4CEE4;
	Thu, 17 Apr 2025 17:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912591;
	bh=QoGnGQ0i+ZYvxRRhw5dj9wL3vn6ZNqG8fyBS3rg7ttQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BiAUnsh7xvFjwwpeJKdTIVC+FAa693luVKCX75emOyseDTYbmXyNsD+LuXHmimtAR
	 3PlcdYav9PxWNiXVakMp7UvNn2odmZ55Av/TILp0QgbOh4SIQ7TfxJsgGr8R/EZG3C
	 /zXUIQRQmw+jwuB58dHO7ldvnUYklmcJNA9hHsvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 060/449] perf/dwc_pcie: fix duplicate pci_dev devices
Date: Thu, 17 Apr 2025 19:45:48 +0200
Message-ID: <20250417175120.410151143@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunhui Cui <cuiyunhui@bytedance.com>

[ Upstream commit 7f35b429802a8065aa61e2a3f567089649f4d98e ]

During platform_device_register, wrongly using struct device
pci_dev as platform_data caused a kmemdup copy of pci_dev. Worse
still, accessing the duplicated device leads to list corruption as its
mutex content (e.g., list, magic) remains the same as the original.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250220121716.50324-3-cuiyunhui@bytedance.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/dwc_pcie_pmu.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/perf/dwc_pcie_pmu.c b/drivers/perf/dwc_pcie_pmu.c
index 19fa2ba8dd670..f851e070760c5 100644
--- a/drivers/perf/dwc_pcie_pmu.c
+++ b/drivers/perf/dwc_pcie_pmu.c
@@ -565,9 +565,7 @@ static int dwc_pcie_register_dev(struct pci_dev *pdev)
 	u32 sbdf;
 
 	sbdf = (pci_domain_nr(pdev->bus) << 16) | PCI_DEVID(pdev->bus->number, pdev->devfn);
-	plat_dev = platform_device_register_data(NULL, "dwc_pcie_pmu", sbdf,
-						 pdev, sizeof(*pdev));
-
+	plat_dev = platform_device_register_simple("dwc_pcie_pmu", sbdf, NULL, 0);
 	if (IS_ERR(plat_dev))
 		return PTR_ERR(plat_dev);
 
@@ -616,18 +614,26 @@ static struct notifier_block dwc_pcie_pmu_nb = {
 
 static int dwc_pcie_pmu_probe(struct platform_device *plat_dev)
 {
-	struct pci_dev *pdev = plat_dev->dev.platform_data;
+	struct pci_dev *pdev;
 	struct dwc_pcie_pmu *pcie_pmu;
 	char *name;
 	u32 sbdf;
 	u16 vsec;
 	int ret;
 
+	sbdf = plat_dev->id;
+	pdev = pci_get_domain_bus_and_slot(sbdf >> 16, PCI_BUS_NUM(sbdf & 0xffff),
+					   sbdf & 0xff);
+	if (!pdev) {
+		pr_err("No pdev found for the sbdf 0x%x\n", sbdf);
+		return -ENODEV;
+	}
+
 	vsec = dwc_pcie_des_cap(pdev);
 	if (!vsec)
 		return -ENODEV;
 
-	sbdf = plat_dev->id;
+	pci_dev_put(pdev);
 	name = devm_kasprintf(&plat_dev->dev, GFP_KERNEL, "dwc_rootport_%x", sbdf);
 	if (!name)
 		return -ENOMEM;
@@ -642,7 +648,7 @@ static int dwc_pcie_pmu_probe(struct platform_device *plat_dev)
 	pcie_pmu->on_cpu = -1;
 	pcie_pmu->pmu = (struct pmu){
 		.name		= name,
-		.parent		= &pdev->dev,
+		.parent		= &plat_dev->dev,
 		.module		= THIS_MODULE,
 		.attr_groups	= dwc_pcie_attr_groups,
 		.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
-- 
2.39.5



