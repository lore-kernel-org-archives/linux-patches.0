Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB3723A4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C665AC433D2;
	Mon,  8 May 2023 10:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541862;
	bh=DIqXE/rduwq1UarrMQ1Jq/W/c0e/a1wL96CNqt6ytpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfpJ0NW+0O3cnQLCaUKZmh4hwhEuQzUQd0PoCrtF3LLEm9E6spd/kYUfgf7pQIdoi
	 T2RFcmc8Qk2oYPbE9vs1Esv/An1I6lAF5mm+3QIXb2K+A6AueMNxfxV3M1vkE/OVkq
	 U5rqokNpl5T0xt/XD3ID33pE2dyQFmto9Wm/lPT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanket Goswami <Sanket.Goswami@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 251/663] platform/x86/amd: pmc: Utilize SMN index 0 for driver probe
Date: Mon,  8 May 2023 11:41:17 +0200
Message-Id: <20230508094436.401479251@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 310e782a99c7f16fb533a45d8f9c16defefa5aab ]

The current SMN index used for the driver probe seems to be meant
for the BIOS pair and there are potential concurrency problems that can
occur with an inopportune SMI.

It is been advised to use SMN_INDEX_0 instead of SMN_INDEX_2, which is
what amd_nb.c provides and this function has protections to ensure that
only one caller can use it at a time.

Fixes: 156ec4731cb2 ("platform/x86: amd-pmc: Add AMD platform support for S2Idle")
Co-developed-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20230409185348.556161-6-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/Kconfig |  2 +-
 drivers/platform/x86/amd/pmc.c   | 23 +++++------------------
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/platform/x86/amd/Kconfig b/drivers/platform/x86/amd/Kconfig
index 2ce8cb2170dfc..d9685aef0887d 100644
--- a/drivers/platform/x86/amd/Kconfig
+++ b/drivers/platform/x86/amd/Kconfig
@@ -7,7 +7,7 @@ source "drivers/platform/x86/amd/pmf/Kconfig"
 
 config AMD_PMC
 	tristate "AMD SoC PMC driver"
-	depends on ACPI && PCI && RTC_CLASS
+	depends on ACPI && PCI && RTC_CLASS && AMD_NB
 	select SERIO
 	help
 	  The driver provides support for AMD Power Management Controller
diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index 52f5b54ba5d6f..f8ef1fa742718 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -10,6 +10,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <asm/amd_nb.h>
 #include <linux/acpi.h>
 #include <linux/bitfield.h>
 #include <linux/bits.h>
@@ -55,8 +56,6 @@
 #define S2D_TELEMETRY_DRAMBYTES_MAX	0x1000000
 
 /* Base address of SMU for mapping physical address to virtual address */
-#define AMD_PMC_SMU_INDEX_ADDRESS	0xB8
-#define AMD_PMC_SMU_INDEX_DATA		0xBC
 #define AMD_PMC_MAPPING_SIZE		0x01000
 #define AMD_PMC_BASE_ADDR_OFFSET	0x10000
 #define AMD_PMC_BASE_ADDR_LO		0x13B102E8
@@ -962,30 +961,18 @@ static int amd_pmc_probe(struct platform_device *pdev)
 
 	dev->cpu_id = rdev->device;
 	dev->rdev = rdev;
-	err = pci_write_config_dword(rdev, AMD_PMC_SMU_INDEX_ADDRESS, AMD_PMC_BASE_ADDR_LO);
-	if (err) {
-		dev_err(dev->dev, "error writing to 0x%x\n", AMD_PMC_SMU_INDEX_ADDRESS);
-		err = pcibios_err_to_errno(err);
-		goto err_pci_dev_put;
-	}
-
-	err = pci_read_config_dword(rdev, AMD_PMC_SMU_INDEX_DATA, &val);
+	err = amd_smn_read(0, AMD_PMC_BASE_ADDR_LO, &val);
 	if (err) {
+		dev_err(dev->dev, "error reading 0x%x\n", AMD_PMC_BASE_ADDR_LO);
 		err = pcibios_err_to_errno(err);
 		goto err_pci_dev_put;
 	}
 
 	base_addr_lo = val & AMD_PMC_BASE_ADDR_HI_MASK;
 
-	err = pci_write_config_dword(rdev, AMD_PMC_SMU_INDEX_ADDRESS, AMD_PMC_BASE_ADDR_HI);
-	if (err) {
-		dev_err(dev->dev, "error writing to 0x%x\n", AMD_PMC_SMU_INDEX_ADDRESS);
-		err = pcibios_err_to_errno(err);
-		goto err_pci_dev_put;
-	}
-
-	err = pci_read_config_dword(rdev, AMD_PMC_SMU_INDEX_DATA, &val);
+	err = amd_smn_read(0, AMD_PMC_BASE_ADDR_HI, &val);
 	if (err) {
+		dev_err(dev->dev, "error reading 0x%x\n", AMD_PMC_BASE_ADDR_HI);
 		err = pcibios_err_to_errno(err);
 		goto err_pci_dev_put;
 	}
-- 
2.39.2



