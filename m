Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58178476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4738AC433EF;
	Tue, 28 Mar 2023 14:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015249;
	bh=1/QBdaNGOaHGiQSySFrupojKy4ZCnT3rOWbgG/YO3QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hC4g4i2UeYl6atMHM8QPSC/EEEDmhP7ABKnnO9qr3NB9gSO8S7yZxeGuae8V98PMa
	 Kf75i4LB3M5FP2RB/v/wNtXmH52gRrXG8fQJMZ2eW8NrDm7Qiw9VW2KY89neJ9SLz2
	 jYDBFDz0/b64o807AJqHXLp3krHsOsKLuE1Emesg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.2 220/240] drm/amdgpu/nv: Apply ASPM quirk on Intel ADL + AMD Navi
Date: Tue, 28 Mar 2023 16:43:03 +0200
Message-Id: <20230328142628.878258509@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 2b072442f4962231a8516485012bb2d2551ef2fe upstream.

S2idle resume freeze can be observed on Intel ADL + AMD WX5500. This is
caused by commit 0064b0ce85bb ("drm/amd/pm: enable ASPM by default").

The root cause is still not clear for now.

So extend and apply the ASPM quirk from commit e02fe3bc7aba
("drm/amdgpu: vi: disable ASPM on Intel Alder Lake based systems"), to
workaround the issue on Navi cards too.

Fixes: 0064b0ce85bb ("drm/amd/pm: enable ASPM by default")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2458
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   15 +++++++++++++++
 drivers/gpu/drm/amd/amdgpu/nv.c            |    2 +-
 drivers/gpu/drm/amd/amdgpu/vi.c            |   17 +----------------
 4 files changed, 18 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1268,6 +1268,7 @@ void amdgpu_device_pci_config_reset(stru
 int amdgpu_device_pci_reset(struct amdgpu_device *adev);
 bool amdgpu_device_need_post(struct amdgpu_device *adev);
 bool amdgpu_device_should_use_aspm(struct amdgpu_device *adev);
+bool amdgpu_device_aspm_support_quirk(void);
 
 void amdgpu_cs_report_moved_bytes(struct amdgpu_device *adev, u64 num_bytes,
 				  u64 num_vis_bytes);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -79,6 +79,10 @@
 
 #include <drm/drm_drv.h>
 
+#if IS_ENABLED(CONFIG_X86)
+#include <asm/intel-family.h>
+#endif
+
 MODULE_FIRMWARE("amdgpu/vega10_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/vega12_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/raven_gpu_info.bin");
@@ -1354,6 +1358,17 @@ bool amdgpu_device_should_use_aspm(struc
 	return pcie_aspm_enabled(adev->pdev);
 }
 
+bool amdgpu_device_aspm_support_quirk(void)
+{
+#if IS_ENABLED(CONFIG_X86)
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	return !(c->x86 == 6 && c->x86_model == INTEL_FAM6_ALDERLAKE);
+#else
+	return true;
+#endif
+}
+
 /* if we get transitioned to only one device, take VGA back */
 /**
  * amdgpu_device_vga_set_decode - enable/disable vga decode
--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -527,7 +527,7 @@ static void nv_pcie_gen3_enable(struct a
 
 static void nv_program_aspm(struct amdgpu_device *adev)
 {
-	if (!amdgpu_device_should_use_aspm(adev))
+	if (!amdgpu_device_should_use_aspm(adev) || !amdgpu_device_aspm_support_quirk())
 		return;
 
 	if (!(adev->flags & AMD_IS_APU) &&
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -81,10 +81,6 @@
 #include "mxgpu_vi.h"
 #include "amdgpu_dm.h"
 
-#if IS_ENABLED(CONFIG_X86)
-#include <asm/intel-family.h>
-#endif
-
 #define ixPCIE_LC_L1_PM_SUBSTATE	0x100100C6
 #define PCIE_LC_L1_PM_SUBSTATE__LC_L1_SUBSTATES_OVERRIDE_EN_MASK	0x00000001L
 #define PCIE_LC_L1_PM_SUBSTATE__LC_PCI_PM_L1_2_OVERRIDE_MASK	0x00000002L
@@ -1138,24 +1134,13 @@ static void vi_enable_aspm(struct amdgpu
 		WREG32_PCIE(ixPCIE_LC_CNTL, data);
 }
 
-static bool aspm_support_quirk_check(void)
-{
-#if IS_ENABLED(CONFIG_X86)
-	struct cpuinfo_x86 *c = &cpu_data(0);
-
-	return !(c->x86 == 6 && c->x86_model == INTEL_FAM6_ALDERLAKE);
-#else
-	return true;
-#endif
-}
-
 static void vi_program_aspm(struct amdgpu_device *adev)
 {
 	u32 data, data1, orig;
 	bool bL1SS = false;
 	bool bClkReqSupport = true;
 
-	if (!amdgpu_device_should_use_aspm(adev) || !aspm_support_quirk_check())
+	if (!amdgpu_device_should_use_aspm(adev) || !amdgpu_device_aspm_support_quirk())
 		return;
 
 	if (adev->flags & AMD_IS_APU ||


