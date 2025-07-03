Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDC113A258;
	Thu,  3 Jul 2025 14:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554077; cv=none; b=eG59SkZEiuVisnW1NHDyk6Er2lu3TcxChh7KMstn8QVY5ekP5i8LVRXE5jp31Y+WypDQV0ZHEkg4naN1HuQV0oi3q487q0JQPo0fI1YvfxWTix5vRLVa/B/oNkhoPeyBF1vJ4Bb2lYSrGHwI3p8fkwfrCREXXvWA+dgxZjBCE8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554077; c=relaxed/simple;
	bh=Jd4fbu9rnGzv4aPiTmdl7ygmqs5a2R3PM4/JZsQjyds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdbtUmJVHTgHSI4LnS5uGkvDM3igYCK0OZGPcFlJ0Z/y1+N/46hg85EB4KCQPl8mH8OplAdrz4sDxDgnJINAISulcezgVqzRKQKF+sVAtEGPo3Jho0Zg/ahb6rblwXyHDCoK7SLsA1y4ZwAomnvkUiEKeUetid0YBXY2cFSnw1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSV/3xHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSV/3xHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D31C4CEE3;
	Thu,  3 Jul 2025 14:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554077;
	bh=Jd4fbu9rnGzv4aPiTmdl7ygmqs5a2R3PM4/JZsQjyds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSV/3xHivLrRnTIn7zx43n6QX2Eh5OIMyX7bTv3nfksK9KpblaW1jI63IuC6N7A07
	 nbjBP90Cx4vVigJ5GTbFy+XIXrREk7QS0NIvt+pNpjFGhSeWW7XSgL1kwmkIZwt1Gf
	 VhIIHlEElTZUN6xjsy6O6omL3dfSEzABIpv1fZPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Karol Wachowski <karol.wachowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/218] accel/ivpu: Add debugfs interface for setting HWS priority bands
Date: Thu,  3 Jul 2025 16:40:22 +0200
Message-ID: <20250703143958.898455216@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Karol Wachowski <karol.wachowski@intel.com>

[ Upstream commit 320323d2e5456df9d6236ac1ce9c030b1a74aa5b ]

Add debugfs interface to modify following priority bands properties:
 * grace period
 * process grace period
 * process quantum

This allows for the adjustment of hardware scheduling algorithm parameters
for each existing priority band, facilitating validation and fine-tuning.

Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250204084622.2422544-4-jacek.lawrynowicz@linux.intel.com
Stable-dep-of: a47e36dc5d90 ("accel/ivpu: Trigger device recovery on engine reset/resume failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_debugfs.c | 84 +++++++++++++++++++++++++++++++
 drivers/accel/ivpu/ivpu_hw.c      | 21 ++++++++
 drivers/accel/ivpu/ivpu_hw.h      |  5 ++
 drivers/accel/ivpu/ivpu_jsm_msg.c | 29 ++++-------
 4 files changed, 121 insertions(+), 18 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_debugfs.c b/drivers/accel/ivpu/ivpu_debugfs.c
index 05a0d99ce95c4..1edf6e5644026 100644
--- a/drivers/accel/ivpu/ivpu_debugfs.c
+++ b/drivers/accel/ivpu/ivpu_debugfs.c
@@ -423,6 +423,88 @@ static int dct_active_set(void *data, u64 active_percent)
 
 DEFINE_DEBUGFS_ATTRIBUTE(ivpu_dct_fops, dct_active_get, dct_active_set, "%llu\n");
 
+static int priority_bands_show(struct seq_file *s, void *v)
+{
+	struct ivpu_device *vdev = s->private;
+	struct ivpu_hw_info *hw = vdev->hw;
+
+	for (int band = VPU_JOB_SCHEDULING_PRIORITY_BAND_IDLE;
+	     band < VPU_JOB_SCHEDULING_PRIORITY_BAND_COUNT; band++) {
+		switch (band) {
+		case VPU_JOB_SCHEDULING_PRIORITY_BAND_IDLE:
+			seq_puts(s, "Idle:     ");
+			break;
+
+		case VPU_JOB_SCHEDULING_PRIORITY_BAND_NORMAL:
+			seq_puts(s, "Normal:   ");
+			break;
+
+		case VPU_JOB_SCHEDULING_PRIORITY_BAND_FOCUS:
+			seq_puts(s, "Focus:    ");
+			break;
+
+		case VPU_JOB_SCHEDULING_PRIORITY_BAND_REALTIME:
+			seq_puts(s, "Realtime: ");
+			break;
+		}
+
+		seq_printf(s, "grace_period %9u process_grace_period %9u process_quantum %9u\n",
+			   hw->hws.grace_period[band], hw->hws.process_grace_period[band],
+			   hw->hws.process_quantum[band]);
+	}
+
+	return 0;
+}
+
+static int priority_bands_fops_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, priority_bands_show, inode->i_private);
+}
+
+static ssize_t
+priority_bands_fops_write(struct file *file, const char __user *user_buf, size_t size, loff_t *pos)
+{
+	struct seq_file *s = file->private_data;
+	struct ivpu_device *vdev = s->private;
+	char buf[64];
+	u32 grace_period;
+	u32 process_grace_period;
+	u32 process_quantum;
+	u32 band;
+	int ret;
+
+	if (size >= sizeof(buf))
+		return -EINVAL;
+
+	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, pos, user_buf, size);
+	if (ret < 0)
+		return ret;
+
+	buf[size] = '\0';
+	ret = sscanf(buf, "%u %u %u %u", &band, &grace_period, &process_grace_period,
+		     &process_quantum);
+	if (ret != 4)
+		return -EINVAL;
+
+	if (band >= VPU_JOB_SCHEDULING_PRIORITY_BAND_COUNT)
+		return -EINVAL;
+
+	vdev->hw->hws.grace_period[band] = grace_period;
+	vdev->hw->hws.process_grace_period[band] = process_grace_period;
+	vdev->hw->hws.process_quantum[band] = process_quantum;
+
+	return size;
+}
+
+static const struct file_operations ivpu_hws_priority_bands_fops = {
+	.owner = THIS_MODULE,
+	.open = priority_bands_fops_open,
+	.write = priority_bands_fops_write,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
 void ivpu_debugfs_init(struct ivpu_device *vdev)
 {
 	struct dentry *debugfs_root = vdev->drm.debugfs_root;
@@ -445,6 +527,8 @@ void ivpu_debugfs_init(struct ivpu_device *vdev)
 			    &fw_trace_hw_comp_mask_fops);
 	debugfs_create_file("fw_trace_level", 0200, debugfs_root, vdev,
 			    &fw_trace_level_fops);
+	debugfs_create_file("hws_priority_bands", 0200, debugfs_root, vdev,
+			    &ivpu_hws_priority_bands_fops);
 
 	debugfs_create_file("reset_engine", 0200, debugfs_root, vdev,
 			    &ivpu_reset_engine_fops);
diff --git a/drivers/accel/ivpu/ivpu_hw.c b/drivers/accel/ivpu/ivpu_hw.c
index 1214f155afa11..37ef8ce642109 100644
--- a/drivers/accel/ivpu/ivpu_hw.c
+++ b/drivers/accel/ivpu/ivpu_hw.c
@@ -110,6 +110,26 @@ static void timeouts_init(struct ivpu_device *vdev)
 	}
 }
 
+static void priority_bands_init(struct ivpu_device *vdev)
+{
+	/* Idle */
+	vdev->hw->hws.grace_period[VPU_JOB_SCHEDULING_PRIORITY_BAND_IDLE] = 0;
+	vdev->hw->hws.process_grace_period[VPU_JOB_SCHEDULING_PRIORITY_BAND_IDLE] = 50000;
+	vdev->hw->hws.process_quantum[VPU_JOB_SCHEDULING_PRIORITY_BAND_IDLE] = 160000;
+	/* Normal */
+	vdev->hw->hws.grace_period[VPU_JOB_SCHEDULING_PRIORITY_BAND_NORMAL] = 50000;
+	vdev->hw->hws.process_grace_period[VPU_JOB_SCHEDULING_PRIORITY_BAND_NORMAL] = 50000;
+	vdev->hw->hws.process_quantum[VPU_JOB_SCHEDULING_PRIORITY_BAND_NORMAL] = 300000;
+	/* Focus */
+	vdev->hw->hws.grace_period[VPU_JOB_SCHEDULING_PRIORITY_BAND_FOCUS] = 50000;
+	vdev->hw->hws.process_grace_period[VPU_JOB_SCHEDULING_PRIORITY_BAND_FOCUS] = 50000;
+	vdev->hw->hws.process_quantum[VPU_JOB_SCHEDULING_PRIORITY_BAND_FOCUS] = 200000;
+	/* Realtime */
+	vdev->hw->hws.grace_period[VPU_JOB_SCHEDULING_PRIORITY_BAND_REALTIME] = 0;
+	vdev->hw->hws.process_grace_period[VPU_JOB_SCHEDULING_PRIORITY_BAND_REALTIME] = 50000;
+	vdev->hw->hws.process_quantum[VPU_JOB_SCHEDULING_PRIORITY_BAND_REALTIME] = 200000;
+}
+
 static void memory_ranges_init(struct ivpu_device *vdev)
 {
 	if (ivpu_hw_ip_gen(vdev) == IVPU_HW_IP_37XX) {
@@ -248,6 +268,7 @@ int ivpu_hw_init(struct ivpu_device *vdev)
 {
 	ivpu_hw_btrs_info_init(vdev);
 	ivpu_hw_btrs_freq_ratios_init(vdev);
+	priority_bands_init(vdev);
 	memory_ranges_init(vdev);
 	platform_init(vdev);
 	wa_init(vdev);
diff --git a/drivers/accel/ivpu/ivpu_hw.h b/drivers/accel/ivpu/ivpu_hw.h
index 1e85306bcd065..1c016b99a0fdd 100644
--- a/drivers/accel/ivpu/ivpu_hw.h
+++ b/drivers/accel/ivpu/ivpu_hw.h
@@ -45,6 +45,11 @@ struct ivpu_hw_info {
 		u8 pn_ratio;
 		u32 profiling_freq;
 	} pll;
+	struct {
+		u32 grace_period[VPU_HWS_NUM_PRIORITY_BANDS];
+		u32 process_quantum[VPU_HWS_NUM_PRIORITY_BANDS];
+		u32 process_grace_period[VPU_HWS_NUM_PRIORITY_BANDS];
+	} hws;
 	u32 tile_fuse;
 	u32 sku;
 	u16 config;
diff --git a/drivers/accel/ivpu/ivpu_jsm_msg.c b/drivers/accel/ivpu/ivpu_jsm_msg.c
index 33d597b2a7f53..21018feb45978 100644
--- a/drivers/accel/ivpu/ivpu_jsm_msg.c
+++ b/drivers/accel/ivpu/ivpu_jsm_msg.c
@@ -7,6 +7,7 @@
 #include "ivpu_hw.h"
 #include "ivpu_ipc.h"
 #include "ivpu_jsm_msg.h"
+#include "vpu_jsm_api.h"
 
 const char *ivpu_jsm_msg_type_to_str(enum vpu_ipc_msg_type type)
 {
@@ -409,26 +410,18 @@ int ivpu_jsm_hws_setup_priority_bands(struct ivpu_device *vdev)
 {
 	struct vpu_jsm_msg req = { .type = VPU_JSM_MSG_SET_PRIORITY_BAND_SETUP };
 	struct vpu_jsm_msg resp;
+	struct ivpu_hw_info *hw = vdev->hw;
+	struct vpu_ipc_msg_payload_hws_priority_band_setup *setup =
+		&req.payload.hws_priority_band_setup;
 	int ret;
 
-	/* Idle */
-	req.payload.hws_priority_band_setup.grace_period[0] = 0;
-	req.payload.hws_priority_band_setup.process_grace_period[0] = 50000;
-	req.payload.hws_priority_band_setup.process_quantum[0] = 160000;
-	/* Normal */
-	req.payload.hws_priority_band_setup.grace_period[1] = 50000;
-	req.payload.hws_priority_band_setup.process_grace_period[1] = 50000;
-	req.payload.hws_priority_band_setup.process_quantum[1] = 300000;
-	/* Focus */
-	req.payload.hws_priority_band_setup.grace_period[2] = 50000;
-	req.payload.hws_priority_band_setup.process_grace_period[2] = 50000;
-	req.payload.hws_priority_band_setup.process_quantum[2] = 200000;
-	/* Realtime */
-	req.payload.hws_priority_band_setup.grace_period[3] = 0;
-	req.payload.hws_priority_band_setup.process_grace_period[3] = 50000;
-	req.payload.hws_priority_band_setup.process_quantum[3] = 200000;
-
-	req.payload.hws_priority_band_setup.normal_band_percentage = 10;
+	for (int band = VPU_JOB_SCHEDULING_PRIORITY_BAND_IDLE;
+	     band < VPU_JOB_SCHEDULING_PRIORITY_BAND_COUNT; band++) {
+		setup->grace_period[band] = hw->hws.grace_period[band];
+		setup->process_grace_period[band] = hw->hws.process_grace_period[band];
+		setup->process_quantum[band] = hw->hws.process_quantum[band];
+	}
+	setup->normal_band_percentage = 10;
 
 	ret = ivpu_ipc_send_receive_internal(vdev, &req, VPU_JSM_MSG_SET_PRIORITY_BAND_SETUP_RSP,
 					     &resp, VPU_IPC_CHAN_ASYNC_CMD, vdev->timeout.jsm);
-- 
2.39.5



