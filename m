Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5654CF477;
	Sat, 17 Oct 2026 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252566; cv=none; b=B9jAlKt84Z/S2rLTtFzf0GblcrpkAo5m+DjdKuKCKvVOLtoQzL9ajvtxXINMXE8cMO1A46+nsyNbObftU3XjvtKVbgs9MGBFIYyqsfbBC0TSgXSCCJ3QNph/76IGkCVg7zo8ZZVHZnwr0wKOz71EQawS0nIcdri4Kek5GH7NiPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252566; c=relaxed/simple;
	bh=1YrTYAeQ7cXIiKBJdHHvoj0XHTazIzvROBzvxQ4i5I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8jkmnT0WyO8RjP75Dr7JPeKxCE2so3rCbUWQME3Ep4RXv9TK5O2SJrg4gP8PiH3Kynnh8wPzc8y2RaaFaX/3+1+cjrXiBS/M4bj0xDF8e4bLmrr+xZzIcnKRhbWrnp5k4rVsNnvD0BzTYENUU2dSpMIguaCseygIMWn1UQ9L6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtTQD6Qa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtTQD6Qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D5D1F000C4;
	Sat, 17 Oct 2026 15:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252565;
	bh=6P/EecoTGpAXY/+Nf42fKLUNuOQJ3IjD1u35aDpffko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wtTQD6Qa8rQDfEgDDeeFc+8zq5+GYEeGU4B9MrMsiP248a9Pc+ZBzrcIeq/s+AIZP
	 OcwltXauXc3mWYj70+T5fbK08JqkZ5Ej85GSEVCsbprsF6N4tKlddAErqF9k60J0xp
	 oxbdoV8L7ahfjh//BBF4j1Ct91+F7+4Lh6+rvREE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	mrh@frame.work,
	Alex Deucher <alexander.deucher@amd.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Alexander F <superveridical@gmail.com>,
	Francis DB <francisdb@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 07/52] drm/amd: Create a device link between APU display and XHCI devices
Date: Sat, 17 Oct 2026 17:54:08 +0200
Message-ID: <20261017155105.087273266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 75c8746b9d0a0317d8a58aa0efa2ff2f7359908b ]

Some AMD APU multi-function devices expose an integrated USB xHCI
controller. In some circumstances (such as larger VRAM), the PM core
can resume can fail when the xHCI controller is resuming in parallel
with the GPU/display function.

On affected systems, the xHCI controller can complete pci_pm_resume
and start resuming USB devices while the GPU is still in its much
longer resume path. This race condition leads to USB device resume
failures followed by:

  xhci_hcd ...: xHCI host not responding to stop endpoint command
  xhci_hcd ...: HC died; cleaning up

Create a device link from any xHCI controller sharing the same PCIe
root port as the APU display function. The link uses DL_FLAG_STATELESS
and DL_FLAG_PM_RUNTIME to ensure the GPU completes its resume before
the xHCI controller begins resuming USB devices.

This device link is done specifically in amdgpu so that if the
platform firmware has been modified such that this issue doesn't happen
the version can be detected and the workaround skipped.

Suggested-by: Aaron Ma <aaron.ma@canonical.com>
Reported-by: mrh@frame.work
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221073
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Tested-by: Alexander F <superveridical@gmail.com>
Tested-by: Francis DB <francisdb@gmail.com>
Link: https://patch.msgid.link/20260713195313.1739762-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 07c93d7eeb0d990bc1b8e3b1eafa464bc9feee97)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c     | 12 +++++
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h | 10 +++++
 .../drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c  | 45 +++++++++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index 8473eaac1e7fc..31f194142bd3f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1342,6 +1342,14 @@ static void smu_feature_cap_init(struct smu_context *smu)
 	bitmap_zero(fea_cap->cap_map, SMU_FEATURE_CAP_ID__COUNT);
 }
 
+static int smu_set_power_dep(struct smu_context *smu, bool enable)
+{
+	if (!smu->ppt_funcs->set_power_dep)
+		return 0;
+
+	return smu->ppt_funcs->set_power_dep(smu, enable);
+}
+
 static int smu_sw_init(struct amdgpu_ip_block *ip_block)
 {
 	struct amdgpu_device *adev = ip_block->adev;
@@ -1405,6 +1413,8 @@ static int smu_sw_init(struct amdgpu_ip_block *ip_block)
 	if (!smu->ppt_funcs->get_fan_control_mode)
 		smu->adev->pm.no_fan = true;
 
+	smu_set_power_dep(smu, true);
+
 	return 0;
 }
 
@@ -1427,6 +1437,8 @@ static int smu_sw_fini(struct amdgpu_ip_block *ip_block)
 
 	smu_fini_microcode(smu);
 
+	smu_set_power_dep(smu, false);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
index 582c186d8b623..e00beb901d906 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
@@ -599,6 +599,9 @@ struct smu_context {
 	bool pm_enabled;
 	bool is_apu;
 
+	/* Power dependency link from an integrated xHCI controller to the GPU */
+	struct device_link		*usb_power_link;
+
 	uint32_t smc_driver_if_version;
 	uint32_t smc_fw_if_version;
 	uint32_t smc_fw_version;
@@ -1521,6 +1524,13 @@ struct pptable_funcs {
 	 */
 	ssize_t (*get_xcp_metrics)(struct smu_context *smu, int xcp_id,
 				   void *table);
+	/**
+	 * @set_power_dep: Create or destroy a power dependency link
+	 * from an integrated xHCI controller to the GPU so that the GPU is
+	 * resumed before the USB controller during PM resume. @enable is true
+	 * to create the link and false to tear it down.
+	 */
+	int (*set_power_dep)(struct smu_context *smu, bool enable);
 };
 
 typedef enum {
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c
index 44cce9b636ca8..3a2b16a9998c6 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c
@@ -1665,6 +1665,50 @@ static int smu_v14_0_common_set_mall_enable(struct smu_context *smu)
 	return ret;
 }
 
+/*
+ * Link any xHCI controller sharing the GPU's PCIe root port as a consumer
+ * of the GPU so the GPU resumes first, avoiding an xHCI resume race.
+ */
+static int smu_v14_0_0_set_power_dep(struct smu_context *smu, bool enable)
+{
+	struct amdgpu_device *adev = smu->adev;
+	struct pci_dev *gpu_pdev = adev->pdev;
+	struct pci_dev *root_port, *usb_pdev = NULL;
+	struct device_link *link;
+
+	if (!enable) {
+		if (smu->usb_power_link) {
+			device_link_del(smu->usb_power_link);
+			smu->usb_power_link = NULL;
+		}
+		return 0;
+	}
+
+	root_port = pcie_find_root_port(gpu_pdev);
+	while ((usb_pdev = pci_get_class(PCI_CLASS_SERIAL_USB_XHCI, usb_pdev))) {
+		struct pci_dev *usb_root;
+
+		usb_root = pcie_find_root_port(usb_pdev);
+		if (usb_root != root_port)
+			continue;
+
+		/* Create device link: USB (consumer) depends on GPU (supplier) */
+		link = device_link_add(&usb_pdev->dev, &gpu_pdev->dev,
+				       DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME);
+		if (link) {
+			smu->usb_power_link = link;
+			drm_info(adev_to_drm(adev), "USB controller %s D0 power state depends on %s\n",
+				 pci_name(usb_pdev), pci_name(gpu_pdev));
+			/* Only create one link for the first USB controller found */
+			break;
+		}
+	}
+
+	pci_dev_put(usb_pdev);
+
+	return 0;
+}
+
 static const struct pptable_funcs smu_v14_0_0_ppt_funcs = {
 	.check_fw_status = smu_v14_0_check_fw_status,
 	.check_fw_version = smu_v14_0_check_fw_version,
@@ -1699,6 +1743,7 @@ static const struct pptable_funcs smu_v14_0_0_ppt_funcs = {
 	.dpm_set_umsch_mm_enable = smu_v14_0_0_set_umsch_mm_enable,
 	.get_dpm_clock_table = smu_v14_0_common_get_dpm_table,
 	.set_mall_enable = smu_v14_0_common_set_mall_enable,
+	.set_power_dep = smu_v14_0_0_set_power_dep,
 };
 
 static void smu_v14_0_0_set_smu_mailbox_registers(struct smu_context *smu)
-- 
2.53.0



