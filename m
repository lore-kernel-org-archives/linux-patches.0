Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055BF168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBA9C433EF;
	Mon,  8 May 2023 09:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539786;
	bh=7WdwPKP2ajb40UYQ6VCpsCcIORTnkiIEZtDtJGKOAAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjv3IR8Cze/wRKX2B0fvO3cNMLnR9qX9HEaP4I5jsdqpsdNCtBDhpio/ke3O5efw/
	 WMsW6Vrzb4aO0ZU85nyRteiDmYKjgLA20Ek6P2y5YCXTJNt9aV1eDRduyuhn+yG2h8
	 7THuic6AxfCxsLRtBtjHw1wj611isc7urJoL7HIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orlando Chamberlain <orlandoch.dev@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/611] drm/amdgpu: register a vga_switcheroo client for MacBooks with apple-gmux
Date: Mon,  8 May 2023 11:39:37 +0200
Message-Id: <20230508094426.638403210@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Orlando Chamberlain <orlandoch.dev@gmail.com>

[ Upstream commit d37a3929ca0363ed1dce02b2772cd5bc547ca66d ]

Commit 3840c5bcc245 ("drm/amdgpu: disentangle runtime pm and
vga_switcheroo") made amdgpu only register a vga_switcheroo client for
GPU's with PX, however AMD GPUs in dual gpu Apple Macbooks do need to
register, but don't have PX. Instead of AMD's PX, they use apple-gmux.

Use apple_gmux_detect() to identify these gpus, and
pci_is_thunderbolt_attached() to ensure eGPUs connected to Dual GPU
Macbooks don't register with vga_switcheroo.

Fixes: 3840c5bcc245 ("drm/amdgpu: disentangle runtime pm and vga_switcheroo")
Link: https://lore.kernel.org/amd-gfx/20230210044826.9834-10-orlandoch.dev@gmail.com/
Signed-off-by: Orlando Chamberlain <orlandoch.dev@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 9df5dcedaf3e2..9776e0b488cf6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -35,6 +35,7 @@
 #include <linux/devcoredump.h>
 #include <generated/utsrelease.h>
 #include <linux/pci-p2pdma.h>
+#include <linux/apple-gmux.h>
 
 #include <drm/drm_aperture.h>
 #include <drm/drm_atomic_helper.h>
@@ -3942,12 +3943,15 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	if ((adev->pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
 		vga_client_register(adev->pdev, amdgpu_device_vga_set_decode);
 
-	if (amdgpu_device_supports_px(ddev)) {
-		px = true;
+	px = amdgpu_device_supports_px(ddev);
+
+	if (px || (!pci_is_thunderbolt_attached(adev->pdev) &&
+				apple_gmux_detect(NULL, NULL)))
 		vga_switcheroo_register_client(adev->pdev,
 					       &amdgpu_switcheroo_ops, px);
+
+	if (px)
 		vga_switcheroo_init_domain_pm_ops(adev->dev, &adev->vga_pm_domain);
-	}
 
 	if (adev->gmc.xgmi.pending_reset)
 		queue_delayed_work(system_wq, &mgpu_info.delayed_reset_work,
@@ -4053,6 +4057,7 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 {
 	int idx;
+	bool px;
 
 	amdgpu_fence_driver_sw_fini(adev);
 	amdgpu_device_ip_fini(adev);
@@ -4072,10 +4077,16 @@ void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 
 	kfree(adev->bios);
 	adev->bios = NULL;
-	if (amdgpu_device_supports_px(adev_to_drm(adev))) {
+
+	px = amdgpu_device_supports_px(adev_to_drm(adev));
+
+	if (px || (!pci_is_thunderbolt_attached(adev->pdev) &&
+				apple_gmux_detect(NULL, NULL)))
 		vga_switcheroo_unregister_client(adev->pdev);
+
+	if (px)
 		vga_switcheroo_fini_domain_pm_ops(adev->dev);
-	}
+
 	if ((adev->pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
 		vga_client_unregister(adev->pdev);
 
-- 
2.39.2



