Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263BD1D0412;
	Wed,  2 Oct 2024 13:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875255; cv=none; b=a0JM6eyv4J5A2uMfKQTJNCTURPrzNxZThO4uWWkj4qOSOZxGdDOh0Wa67wpdaYiZ+S2nC6yeIA6rCcQNnDl//eV84B6H7qJJWlfpc8hHF4PKdN1RbOCb8lT44QD/Gc3NOWv1A+s6ilOb8rXBXddPeYlkrhucUj6yT01AoPKhW64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875255; c=relaxed/simple;
	bh=+JpUY/l1YqXXA7SJRxi6grIjDT+BGJLn3aWlJUjzvpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKjLIfuDpPbI1hM54OLL1oZazhDvkMBopHEaWKRI6A4Su74q3dCEVpmsejhanYpDkhWCMLATiE6IACx3H3Jgem7NmN6pyD9Fay175BDMcWNqVmua8DpIOB358M7FrdSASzLoMwep3EQG1pRbcRBuc7UK3vnh1fmapbb7NvT01+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IkwVfTBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IkwVfTBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7223AC4CEC5;
	Wed,  2 Oct 2024 13:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875255;
	bh=+JpUY/l1YqXXA7SJRxi6grIjDT+BGJLn3aWlJUjzvpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IkwVfTBXiVlH6d4uvOkUB1vQtY0jdmE2ZaqMalWpY9jTxhMKbi5YY7UU7GvGuIRdl
	 Y/oMCO8PW3Gw3RosrDJKJc9SQERTvxax/DCSecOjbon/WpGVylyCcaf2KaWPcRiCe9
	 z4Ek1b51oUaz79W+w7tbGxa1X+eZRKEH9qnh8td4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna chaitanya chundru <quic_krichai@quicinc.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 041/695] perf/dwc_pcie: Fix registration issue in multi PCIe controller instances
Date: Wed,  2 Oct 2024 14:50:39 +0200
Message-ID: <20241002125824.131772164@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna chaitanya chundru <quic_krichai@quicinc.com>

[ Upstream commit e669388537c472142804eb5a0449cc23d5409694 ]

When there are multiple of instances of PCIe controllers, registration
to perf driver fails with this error.
sysfs: cannot create duplicate filename '/devices/platform/dwc_pcie_pmu.0'
CPU: 0 PID: 166 Comm: modprobe Not tainted 6.10.0-rc2-next-20240607-dirty
Hardware name: Qualcomm SA8775P Ride (DT)
Call trace:
 dump_backtrace.part.8+0x98/0xf0
 show_stack+0x14/0x1c
 dump_stack_lvl+0x74/0x88
 dump_stack+0x14/0x1c
 sysfs_warn_dup+0x60/0x78
 sysfs_create_dir_ns+0xe8/0x100
 kobject_add_internal+0x94/0x224
 kobject_add+0xa8/0x118
 device_add+0x298/0x7b4
 platform_device_add+0x1a0/0x228
 platform_device_register_full+0x11c/0x148
 dwc_pcie_register_dev+0x74/0xf0 [dwc_pcie_pmu]
 dwc_pcie_pmu_init+0x7c/0x1000 [dwc_pcie_pmu]
 do_one_initcall+0x58/0x1c0
 do_init_module+0x58/0x208
 load_module+0x1804/0x188c
 __do_sys_init_module+0x18c/0x1f0
 __arm64_sys_init_module+0x14/0x1c
 invoke_syscall+0x40/0xf8
 el0_svc_common.constprop.1+0x70/0xf4
 do_el0_svc+0x18/0x20
 el0_svc+0x28/0xb0
 el0t_64_sync_handler+0x9c/0xc0
 el0t_64_sync+0x160/0x164
kobject: kobject_add_internal failed for dwc_pcie_pmu.0 with -EEXIST,
don't try to register things with the same name in the same directory.

This is because of having same bdf value for devices under two different
controllers.

Update the logic to use sbdf which is a unique number in case of
multi instance also.

Fixes: af9597adc2f1 ("drivers/perf: add DesignWare PCIe PMU driver")
Signed-off-by: Krishna chaitanya chundru <quic_krichai@quicinc.com>
Reviewed-by: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20240816-dwc_pmu_fix-v2-1-198b8ab1077c@quicinc.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/dwc_pcie_pmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/perf/dwc_pcie_pmu.c b/drivers/perf/dwc_pcie_pmu.c
index c5e328f238419..85a5155d60180 100644
--- a/drivers/perf/dwc_pcie_pmu.c
+++ b/drivers/perf/dwc_pcie_pmu.c
@@ -556,10 +556,10 @@ static int dwc_pcie_register_dev(struct pci_dev *pdev)
 {
 	struct platform_device *plat_dev;
 	struct dwc_pcie_dev_info *dev_info;
-	u32 bdf;
+	u32 sbdf;
 
-	bdf = PCI_DEVID(pdev->bus->number, pdev->devfn);
-	plat_dev = platform_device_register_data(NULL, "dwc_pcie_pmu", bdf,
+	sbdf = (pci_domain_nr(pdev->bus) << 16) | PCI_DEVID(pdev->bus->number, pdev->devfn);
+	plat_dev = platform_device_register_data(NULL, "dwc_pcie_pmu", sbdf,
 						 pdev, sizeof(*pdev));
 
 	if (IS_ERR(plat_dev))
@@ -611,15 +611,15 @@ static int dwc_pcie_pmu_probe(struct platform_device *plat_dev)
 	struct pci_dev *pdev = plat_dev->dev.platform_data;
 	struct dwc_pcie_pmu *pcie_pmu;
 	char *name;
-	u32 bdf, val;
+	u32 sbdf, val;
 	u16 vsec;
 	int ret;
 
 	vsec = pci_find_vsec_capability(pdev, pdev->vendor,
 					DWC_PCIE_VSEC_RAS_DES_ID);
 	pci_read_config_dword(pdev, vsec + PCI_VNDR_HEADER, &val);
-	bdf = PCI_DEVID(pdev->bus->number, pdev->devfn);
-	name = devm_kasprintf(&plat_dev->dev, GFP_KERNEL, "dwc_rootport_%x", bdf);
+	sbdf = plat_dev->id;
+	name = devm_kasprintf(&plat_dev->dev, GFP_KERNEL, "dwc_rootport_%x", sbdf);
 	if (!name)
 		return -ENOMEM;
 
@@ -650,7 +650,7 @@ static int dwc_pcie_pmu_probe(struct platform_device *plat_dev)
 	ret = cpuhp_state_add_instance(dwc_pcie_pmu_hp_state,
 				       &pcie_pmu->cpuhp_node);
 	if (ret) {
-		pci_err(pdev, "Error %d registering hotplug @%x\n", ret, bdf);
+		pci_err(pdev, "Error %d registering hotplug @%x\n", ret, sbdf);
 		return ret;
 	}
 
@@ -663,7 +663,7 @@ static int dwc_pcie_pmu_probe(struct platform_device *plat_dev)
 
 	ret = perf_pmu_register(&pcie_pmu->pmu, name, -1);
 	if (ret) {
-		pci_err(pdev, "Error %d registering PMU @%x\n", ret, bdf);
+		pci_err(pdev, "Error %d registering PMU @%x\n", ret, sbdf);
 		return ret;
 	}
 	ret = devm_add_action_or_reset(&plat_dev->dev, dwc_pcie_unregister_pmu,
-- 
2.43.0



