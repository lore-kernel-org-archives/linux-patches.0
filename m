Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A3628DC3;
	Fri, 24 Nov 2023 18:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vAUxLg1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F545C433C7;
	Fri, 24 Nov 2023 18:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851511;
	bh=Yxo0KbyVVAmleAbj83+wSxrtEZIpsHXUeD8yoYX3smc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vAUxLg1AzcmjgzrHiSu84hgNAmGhgcvTuvv8vVrehcbwWEUEMlHCs3rvk5DQs+vIi
	 d9luC/fQWjIjK01sXNysK7+cKo5AN5hXyvvkKnprjBgIhY//wEuhvijJDuEia6ocPR
	 jHKxCmFrKZiqE8fElJapScfNllwKO5AobhZfjV6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.5 477/491] drm/amdgpu: dont use pci_is_thunderbolt_attached()
Date: Fri, 24 Nov 2023 17:51:53 +0000
Message-ID: <20231124172038.973822125@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7b1c6263eaf4fd64ffe1cafdc504a42ee4bfbb33 upstream.

It's only valid on Intel systems with the Intel VSEC.
Use dev_is_removable() instead.  This should do the right
thing regardless of the platform.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2925
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    8 ++++----
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c     |    5 +++--
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -43,6 +43,7 @@
 #include <drm/drm_fb_helper.h>
 #include <drm/drm_probe_helper.h>
 #include <drm/amdgpu_drm.h>
+#include <linux/device.h>
 #include <linux/vgaarb.h>
 #include <linux/vga_switcheroo.h>
 #include <linux/efi.h>
@@ -2233,7 +2234,6 @@ out:
  */
 static int amdgpu_device_ip_early_init(struct amdgpu_device *adev)
 {
-	struct drm_device *dev = adev_to_drm(adev);
 	struct pci_dev *parent;
 	int i, r;
 	bool total;
@@ -2304,7 +2304,7 @@ static int amdgpu_device_ip_early_init(s
 	    (amdgpu_is_atpx_hybrid() ||
 	     amdgpu_has_atpx_dgpu_power_cntl()) &&
 	    ((adev->flags & AMD_IS_APU) == 0) &&
-	    !pci_is_thunderbolt_attached(to_pci_dev(dev->dev)))
+	    !dev_is_removable(&adev->pdev->dev))
 		adev->flags |= AMD_IS_PX;
 
 	if (!(adev->flags & AMD_IS_APU)) {
@@ -4132,7 +4132,7 @@ fence_driver_init:
 
 	px = amdgpu_device_supports_px(ddev);
 
-	if (px || (!pci_is_thunderbolt_attached(adev->pdev) &&
+	if (px || (!dev_is_removable(&adev->pdev->dev) &&
 				apple_gmux_detect(NULL, NULL)))
 		vga_switcheroo_register_client(adev->pdev,
 					       &amdgpu_switcheroo_ops, px);
@@ -4278,7 +4278,7 @@ void amdgpu_device_fini_sw(struct amdgpu
 
 	px = amdgpu_device_supports_px(adev_to_drm(adev));
 
-	if (px || (!pci_is_thunderbolt_attached(adev->pdev) &&
+	if (px || (!dev_is_removable(&adev->pdev->dev) &&
 				apple_gmux_detect(NULL, NULL)))
 		vga_switcheroo_unregister_client(adev->pdev);
 
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
@@ -28,6 +28,7 @@
 #include "nbio/nbio_2_3_offset.h"
 #include "nbio/nbio_2_3_sh_mask.h"
 #include <uapi/linux/kfd_ioctl.h>
+#include <linux/device.h>
 #include <linux/pci.h>
 
 #define smnPCIE_CONFIG_CNTL	0x11180044
@@ -361,7 +362,7 @@ static void nbio_v2_3_enable_aspm(struct
 
 		data |= NAVI10_PCIE__LC_L0S_INACTIVITY_DEFAULT << PCIE_LC_CNTL__LC_L0S_INACTIVITY__SHIFT;
 
-		if (pci_is_thunderbolt_attached(adev->pdev))
+		if (dev_is_removable(&adev->pdev->dev))
 			data |= NAVI10_PCIE__LC_L1_INACTIVITY_TBT_DEFAULT  << PCIE_LC_CNTL__LC_L1_INACTIVITY__SHIFT;
 		else
 			data |= NAVI10_PCIE__LC_L1_INACTIVITY_DEFAULT << PCIE_LC_CNTL__LC_L1_INACTIVITY__SHIFT;
@@ -480,7 +481,7 @@ static void nbio_v2_3_program_aspm(struc
 
 	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
 	data |= NAVI10_PCIE__LC_L0S_INACTIVITY_DEFAULT << PCIE_LC_CNTL__LC_L0S_INACTIVITY__SHIFT;
-	if (pci_is_thunderbolt_attached(adev->pdev))
+	if (dev_is_removable(&adev->pdev->dev))
 		data |= NAVI10_PCIE__LC_L1_INACTIVITY_TBT_DEFAULT  << PCIE_LC_CNTL__LC_L1_INACTIVITY__SHIFT;
 	else
 		data |= NAVI10_PCIE__LC_L1_INACTIVITY_DEFAULT << PCIE_LC_CNTL__LC_L1_INACTIVITY__SHIFT;


