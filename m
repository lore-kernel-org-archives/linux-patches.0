Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F54253334;
	Tue, 29 Apr 2025 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947564; cv=none; b=tW/QMXU2caSCr0UsXvJx0PxlmOhxJvHQIMxlrQAsxX9x7seLVrLTGkINZQfvqD5E43mKXqmcXxzxTnRFSMPhwfaDTs0yTON6i8VezoXdVysQ35all0R6HWqDCEUSmPn4QNzx1yt6erTUJ5jq1K7URnTTMI8ATzNiYfYVXWAIMHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947564; c=relaxed/simple;
	bh=GqGgi9sBKQ7oD+pQbvio2ra7HszEm6pTtpQ3hGHyMYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfm2yotvWy0U1Onjx1iL5l6Jg3DTUg16V16/bGGTKnia8RKLnWnhD7QCcvC9YrxXlv6cXkmn0Kts7LBqUePT3akE0ogql4HgBYi3EZHGWJLVFvki/8Taxsc71zo95ObgwCSnbGV+AlR2lcQ5PmVRcw6wmy8hWnaMcHw83c+0QPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmJY2UMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmJY2UMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9BCC4CEEE;
	Tue, 29 Apr 2025 17:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947563;
	bh=GqGgi9sBKQ7oD+pQbvio2ra7HszEm6pTtpQ3hGHyMYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmJY2UMREyduZaexeuFCDPXKWtJc2jGJfafOPi8TLkeL2OqAwHiJxEkBJm8veXews
	 jL94lbMhtfGM/G6l8JM7/CGs1SEISpbPzPIv8Pj6HbGef0xAo7FBPo2bj0Mr3OBzYt
	 UBz6m6VE/dGdL6VCk4COcMxct8fZcJ2AhSrPfawE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/280] accel/ivpu: Add auto selection logic for job scheduler
Date: Tue, 29 Apr 2025 18:39:35 +0200
Message-ID: <20250429161116.516147067@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

[ Upstream commit 436b67d6936b5658426e40d0df8f147239bc532b ]

Add ivpu_fw_sched_mode_select() function that can select scheduling mode
based on HW and FW versions. This prepares for a switch to HWS on
selected platforms.

Reviewed-by: Karol Wachowski <karol.wachowski@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930195322.461209-17-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Stable-dep-of: 6c2b75404d33 ("accel/ivpu: Fix the NPU's DPU frequency calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_drv.c     |  6 +++---
 drivers/accel/ivpu/ivpu_drv.h     |  2 ++
 drivers/accel/ivpu/ivpu_fw.c      | 15 +++++++++++++--
 drivers/accel/ivpu/ivpu_fw.h      |  3 +++
 drivers/accel/ivpu/ivpu_hw.h      |  1 -
 drivers/accel/ivpu/ivpu_hw_btrs.c |  2 --
 drivers/accel/ivpu/ivpu_job.c     | 14 +++++++-------
 drivers/accel/ivpu/ivpu_sysfs.c   | 24 ++++++++++++++++++++++++
 8 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_drv.c b/drivers/accel/ivpu/ivpu_drv.c
index 38b4158f52784..c929be956280e 100644
--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -54,9 +54,9 @@ u8 ivpu_pll_max_ratio = U8_MAX;
 module_param_named(pll_max_ratio, ivpu_pll_max_ratio, byte, 0644);
 MODULE_PARM_DESC(pll_max_ratio, "Maximum PLL ratio used to set NPU frequency");
 
-int ivpu_sched_mode;
+int ivpu_sched_mode = IVPU_SCHED_MODE_AUTO;
 module_param_named(sched_mode, ivpu_sched_mode, int, 0444);
-MODULE_PARM_DESC(sched_mode, "Scheduler mode: 0 - Default scheduler, 1 - Force HW scheduler");
+MODULE_PARM_DESC(sched_mode, "Scheduler mode: -1 - Use default scheduler, 0 - Use OS scheduler, 1 - Use HW scheduler");
 
 bool ivpu_disable_mmu_cont_pages;
 module_param_named(disable_mmu_cont_pages, ivpu_disable_mmu_cont_pages, bool, 0444);
@@ -347,7 +347,7 @@ static int ivpu_hw_sched_init(struct ivpu_device *vdev)
 {
 	int ret = 0;
 
-	if (vdev->hw->sched_mode == VPU_SCHEDULING_MODE_HW) {
+	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW) {
 		ret = ivpu_jsm_hws_setup_priority_bands(vdev);
 		if (ret) {
 			ivpu_err(vdev, "Failed to enable hw scheduler: %d", ret);
diff --git a/drivers/accel/ivpu/ivpu_drv.h b/drivers/accel/ivpu/ivpu_drv.h
index 2b30cc2e9272e..9430a24994c32 100644
--- a/drivers/accel/ivpu/ivpu_drv.h
+++ b/drivers/accel/ivpu/ivpu_drv.h
@@ -57,6 +57,8 @@
 #define IVPU_PLATFORM_FPGA    3
 #define IVPU_PLATFORM_INVALID 8
 
+#define IVPU_SCHED_MODE_AUTO -1
+
 #define IVPU_DBG_REG	 BIT(0)
 #define IVPU_DBG_IRQ	 BIT(1)
 #define IVPU_DBG_MMU	 BIT(2)
diff --git a/drivers/accel/ivpu/ivpu_fw.c b/drivers/accel/ivpu/ivpu_fw.c
index b2b6d89f06537..153037dc62c07 100644
--- a/drivers/accel/ivpu/ivpu_fw.c
+++ b/drivers/accel/ivpu/ivpu_fw.c
@@ -134,6 +134,15 @@ static bool is_within_range(u64 addr, size_t size, u64 range_start, size_t range
 	return true;
 }
 
+static u32
+ivpu_fw_sched_mode_select(struct ivpu_device *vdev, const struct vpu_firmware_header *fw_hdr)
+{
+	if (ivpu_sched_mode != IVPU_SCHED_MODE_AUTO)
+		return ivpu_sched_mode;
+
+	return VPU_SCHEDULING_MODE_OS;
+}
+
 static int ivpu_fw_parse(struct ivpu_device *vdev)
 {
 	struct ivpu_fw_info *fw = vdev->fw;
@@ -215,8 +224,10 @@ static int ivpu_fw_parse(struct ivpu_device *vdev)
 
 	fw->dvfs_mode = 0;
 
+	fw->sched_mode = ivpu_fw_sched_mode_select(vdev, fw_hdr);
 	fw->primary_preempt_buf_size = fw_hdr->preemption_buffer_1_size;
 	fw->secondary_preempt_buf_size = fw_hdr->preemption_buffer_2_size;
+	ivpu_info(vdev, "Scheduler mode: %s\n", fw->sched_mode ? "HW" : "OS");
 
 	if (fw_hdr->ro_section_start_address && !is_within_range(fw_hdr->ro_section_start_address,
 								 fw_hdr->ro_section_size,
@@ -605,8 +616,8 @@ void ivpu_fw_boot_params_setup(struct ivpu_device *vdev, struct vpu_boot_params
 	boot_params->punit_telemetry_sram_base = ivpu_hw_telemetry_offset_get(vdev);
 	boot_params->punit_telemetry_sram_size = ivpu_hw_telemetry_size_get(vdev);
 	boot_params->vpu_telemetry_enable = ivpu_hw_telemetry_enable_get(vdev);
-	boot_params->vpu_scheduling_mode = vdev->hw->sched_mode;
-	if (vdev->hw->sched_mode == VPU_SCHEDULING_MODE_HW)
+	boot_params->vpu_scheduling_mode = vdev->fw->sched_mode;
+	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW)
 		boot_params->vpu_focus_present_timer_ms = IVPU_FOCUS_PRESENT_TIMER_MS;
 	boot_params->dvfs_mode = vdev->fw->dvfs_mode;
 	if (!IVPU_WA(disable_d0i3_msg))
diff --git a/drivers/accel/ivpu/ivpu_fw.h b/drivers/accel/ivpu/ivpu_fw.h
index 5e8eb608b70f1..1d0b2bd9d65cf 100644
--- a/drivers/accel/ivpu/ivpu_fw.h
+++ b/drivers/accel/ivpu/ivpu_fw.h
@@ -6,6 +6,8 @@
 #ifndef __IVPU_FW_H__
 #define __IVPU_FW_H__
 
+#include "vpu_jsm_api.h"
+
 #define FW_VERSION_HEADER_SIZE	SZ_4K
 #define FW_VERSION_STR_SIZE	SZ_256
 
@@ -36,6 +38,7 @@ struct ivpu_fw_info {
 	u32 secondary_preempt_buf_size;
 	u64 read_only_addr;
 	u32 read_only_size;
+	u32 sched_mode;
 };
 
 int ivpu_fw_init(struct ivpu_device *vdev);
diff --git a/drivers/accel/ivpu/ivpu_hw.h b/drivers/accel/ivpu/ivpu_hw.h
index a96a05b2acda9..fc4dbfc980c81 100644
--- a/drivers/accel/ivpu/ivpu_hw.h
+++ b/drivers/accel/ivpu/ivpu_hw.h
@@ -46,7 +46,6 @@ struct ivpu_hw_info {
 		u32 profiling_freq;
 	} pll;
 	u32 tile_fuse;
-	u32 sched_mode;
 	u32 sku;
 	u16 config;
 	int dma_bits;
diff --git a/drivers/accel/ivpu/ivpu_hw_btrs.c b/drivers/accel/ivpu/ivpu_hw_btrs.c
index 745e5248803da..39c8fd51be32c 100644
--- a/drivers/accel/ivpu/ivpu_hw_btrs.c
+++ b/drivers/accel/ivpu/ivpu_hw_btrs.c
@@ -163,7 +163,6 @@ static int info_init_mtl(struct ivpu_device *vdev)
 	hw->tile_fuse = BTRS_MTL_TILE_FUSE_ENABLE_BOTH;
 	hw->sku = BTRS_MTL_TILE_SKU_BOTH;
 	hw->config = BTRS_MTL_WP_CONFIG_2_TILE_4_3_RATIO;
-	hw->sched_mode = ivpu_sched_mode;
 
 	return 0;
 }
@@ -178,7 +177,6 @@ static int info_init_lnl(struct ivpu_device *vdev)
 	if (ret)
 		return ret;
 
-	hw->sched_mode = ivpu_sched_mode;
 	hw->tile_fuse = tile_fuse_config;
 	hw->pll.profiling_freq = PLL_PROFILING_FREQ_DEFAULT;
 
diff --git a/drivers/accel/ivpu/ivpu_job.c b/drivers/accel/ivpu/ivpu_job.c
index be2e2bf0f43f0..91f7f6f3ca675 100644
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -37,7 +37,7 @@ static int ivpu_preemption_buffers_create(struct ivpu_device *vdev,
 	u64 secondary_size = ALIGN(vdev->fw->secondary_preempt_buf_size, PAGE_SIZE);
 	struct ivpu_addr_range range;
 
-	if (vdev->hw->sched_mode != VPU_SCHEDULING_MODE_HW)
+	if (vdev->fw->sched_mode != VPU_SCHEDULING_MODE_HW)
 		return 0;
 
 	range.start = vdev->hw->ranges.user.end - (primary_size * IVPU_NUM_CMDQS_PER_CTX);
@@ -68,7 +68,7 @@ static int ivpu_preemption_buffers_create(struct ivpu_device *vdev,
 static void ivpu_preemption_buffers_free(struct ivpu_device *vdev,
 					 struct ivpu_file_priv *file_priv, struct ivpu_cmdq *cmdq)
 {
-	if (vdev->hw->sched_mode != VPU_SCHEDULING_MODE_HW)
+	if (vdev->fw->sched_mode != VPU_SCHEDULING_MODE_HW)
 		return;
 
 	drm_WARN_ON(&vdev->drm, !cmdq->primary_preempt_buf);
@@ -149,7 +149,7 @@ static int ivpu_register_db(struct ivpu_file_priv *file_priv, struct ivpu_cmdq *
 	struct ivpu_device *vdev = file_priv->vdev;
 	int ret;
 
-	if (vdev->hw->sched_mode == VPU_SCHEDULING_MODE_HW)
+	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW)
 		ret = ivpu_jsm_hws_register_db(vdev, file_priv->ctx.id, cmdq->db_id, cmdq->db_id,
 					       cmdq->mem->vpu_addr, ivpu_bo_size(cmdq->mem));
 	else
@@ -184,7 +184,7 @@ ivpu_cmdq_init(struct ivpu_file_priv *file_priv, struct ivpu_cmdq *cmdq, u16 eng
 	jobq_header->tail = 0;
 	wmb(); /* Flush WC buffer for jobq->header */
 
-	if (vdev->hw->sched_mode == VPU_SCHEDULING_MODE_HW) {
+	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW) {
 		ret = ivpu_hws_cmdq_init(file_priv, cmdq, engine, priority);
 		if (ret)
 			return ret;
@@ -211,7 +211,7 @@ static int ivpu_cmdq_fini(struct ivpu_file_priv *file_priv, struct ivpu_cmdq *cm
 
 	cmdq->db_registered = false;
 
-	if (vdev->hw->sched_mode == VPU_SCHEDULING_MODE_HW) {
+	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW) {
 		ret = ivpu_jsm_hws_destroy_cmdq(vdev, file_priv->ctx.id, cmdq->db_id);
 		if (!ret)
 			ivpu_dbg(vdev, JOB, "Command queue %d destroyed\n", cmdq->db_id);
@@ -335,7 +335,7 @@ void ivpu_context_abort_locked(struct ivpu_file_priv *file_priv)
 
 	ivpu_cmdq_fini_all(file_priv);
 
-	if (vdev->hw->sched_mode == VPU_SCHEDULING_MODE_OS)
+	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_OS)
 		ivpu_jsm_context_release(vdev, file_priv->ctx.id);
 }
 
@@ -361,7 +361,7 @@ static int ivpu_cmdq_push_job(struct ivpu_cmdq *cmdq, struct ivpu_job *job)
 	if (unlikely(ivpu_test_mode & IVPU_TEST_MODE_NULL_SUBMISSION))
 		entry->flags = VPU_JOB_FLAGS_NULL_SUBMISSION_MASK;
 
-	if (vdev->hw->sched_mode == VPU_SCHEDULING_MODE_HW &&
+	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW &&
 	    (unlikely(!(ivpu_test_mode & IVPU_TEST_MODE_PREEMPTION_DISABLE)))) {
 		entry->primary_preempt_buf_addr = cmdq->primary_preempt_buf->vpu_addr;
 		entry->primary_preempt_buf_size = ivpu_bo_size(cmdq->primary_preempt_buf);
diff --git a/drivers/accel/ivpu/ivpu_sysfs.c b/drivers/accel/ivpu/ivpu_sysfs.c
index 913669f1786e8..616477fc17fa0 100644
--- a/drivers/accel/ivpu/ivpu_sysfs.c
+++ b/drivers/accel/ivpu/ivpu_sysfs.c
@@ -6,6 +6,8 @@
 #include <linux/device.h>
 #include <linux/err.h>
 
+#include "ivpu_drv.h"
+#include "ivpu_fw.h"
 #include "ivpu_hw.h"
 #include "ivpu_sysfs.h"
 
@@ -39,8 +41,30 @@ npu_busy_time_us_show(struct device *dev, struct device_attribute *attr, char *b
 
 static DEVICE_ATTR_RO(npu_busy_time_us);
 
+/**
+ * DOC: sched_mode
+ *
+ * The sched_mode is used to report current NPU scheduling mode.
+ *
+ * It returns following strings:
+ * - "HW"		- Hardware Scheduler mode
+ * - "OS"		- Operating System Scheduler mode
+ *
+ */
+static ssize_t
+sched_mode_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct drm_device *drm = dev_get_drvdata(dev);
+	struct ivpu_device *vdev = to_ivpu_device(drm);
+
+	return sysfs_emit(buf, "%s\n", vdev->fw->sched_mode ? "HW" : "OS");
+}
+
+static DEVICE_ATTR_RO(sched_mode);
+
 static struct attribute *ivpu_dev_attrs[] = {
 	&dev_attr_npu_busy_time_us.attr,
+	&dev_attr_sched_mode.attr,
 	NULL,
 };
 
-- 
2.39.5



