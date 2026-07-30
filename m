Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3296943B3F8;
	Thu, 30 Jul 2026 14:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422483; cv=none; b=LNzaZAqirep7NVKgmj7mDltcaCxZRrh17qmcQt4ZzFGUlC7Sqjug4yH1pVDQ3Ky2lPLc0bp2B04bUJia8CiyOs0n5IaNEqK4+nZH1U5obtinw/YngZx2b50BtZqReFVO7FnVno55lRlEipVvakQ2ercDoCyQZ+sBZ9qIdWOKUrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422483; c=relaxed/simple;
	bh=bCt0cQaJ1zIzB59fbhm3KO4XP5gVUgSLgXj1HBMcLBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HK8DuwrIJFXm8z13fDd4oaR2oU6M3aiYgLCBTL7djqeMx4RboiaoZN+DKRHqNauuqBH0CdhXIrub4+Kw4KxZOokYqgrO4HHEAHNNfIfBrjMH0/ICbEPu/yqMF95gIGiI2vET+cVQkEnAWWDRWrCj/VexUFzH/bTGyMBLCs1ahUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXJx4ne5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXJx4ne5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9035F1F000E9;
	Thu, 30 Jul 2026 14:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422482;
	bh=WnRc6rk+olbdo48FWViJ28Uw5HPKUUbNh2W6vbUAjy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXJx4ne53uT9ilIG42o9FI+4JfvlyAVPdXoQAtg9C0w0I2B1DnB1v6CJLqVVhY2rz
	 tvVUHLmWDFgv7vel8/1NS0tbOFCaHJ+zCf9DZcBXtZ8q26sg3ULeCkxbAfQZglVKZY
	 hLtBdKfLzgbAzZjuxDdDWrLnbHIxyPFVAdm5iik0=
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
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 7.1 452/744] drm/amd: Create a device link between APU display and XHCI devices
Date: Thu, 30 Jul 2026 16:12:05 +0200
Message-ID: <20260730141453.904540424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 75c8746b9d0a0317d8a58aa0efa2ff2f7359908b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c            |   12 +++++
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h        |   12 ++++-
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c |   45 +++++++++++++++++++
 3 files changed, 68 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1365,6 +1365,14 @@ static void smu_feature_cap_init(struct
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
@@ -1426,6 +1434,8 @@ static int smu_sw_init(struct amdgpu_ip_
 	if (!smu->ppt_funcs->get_fan_control_mode)
 		smu->adev->pm.no_fan = true;
 
+	smu_set_power_dep(smu, true);
+
 	return 0;
 }
 
@@ -1448,6 +1458,8 @@ static int smu_sw_fini(struct amdgpu_ip_
 
 	smu_fini_microcode(smu);
 
+	smu_set_power_dep(smu, false);
+
 	return 0;
 }
 
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
@@ -749,6 +749,9 @@ struct smu_context {
 	bool pm_enabled;
 	bool is_apu;
 
+	/* Power dependency link from an integrated xHCI controller to the GPU */
+	struct device_link		*usb_power_link;
+
 	uint32_t smc_driver_if_version;
 	uint32_t smc_fw_if_version;
 	uint32_t smc_fw_version;
@@ -1648,12 +1651,19 @@ struct pptable_funcs {
 	int (*ras_send_msg)(struct smu_context *smu,
 			    enum smu_message_type msg, uint32_t param, uint32_t *read_arg);
 
-
 	/**
 	 * @get_ras_smu_drv: Get RAS smu driver interface
 	 * Return: ras_smu_drv *
 	 */
 	int (*get_ras_smu_drv)(struct smu_context *smu, const struct ras_smu_drv **ras_smu_drv);
+
+	/**
+	 * @set_power_dep: Create or destroy a power dependency link
+	 * from an integrated xHCI controller to the GPU so that the GPU is
+	 * resumed before the USB controller during PM resume. @enable is true
+	 * to create the link and false to tear it down.
+	 */
+	int (*set_power_dep)(struct smu_context *smu, bool enable);
 };
 
 typedef enum {
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c
@@ -1701,6 +1701,50 @@ static int smu_v14_0_0_restore_user_od_s
 	return 0;
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
 	.check_fw_version = smu_cmn_check_fw_version,
@@ -1734,6 +1778,7 @@ static const struct pptable_funcs smu_v1
 	.dpm_set_umsch_mm_enable = smu_v14_0_0_set_umsch_mm_enable,
 	.get_dpm_clock_table = smu_v14_0_common_get_dpm_table,
 	.set_mall_enable = smu_v14_0_common_set_mall_enable,
+	.set_power_dep = smu_v14_0_0_set_power_dep,
 };
 
 static void smu_v14_0_0_init_msg_ctl(struct smu_context *smu)


