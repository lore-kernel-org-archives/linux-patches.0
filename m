Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C65148838;
	Mon,  6 Jan 2025 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177083; cv=none; b=Kg5wwNVJK02QOo8NjDJgbU08VcolfNVxcH8zEz3z+883qVrQe0hJrx1GLIHeoOEcKOfjzbCfNTcD34V/OhlIMgXxNut2GN0Iwz1wISngUrAfCA1Xx3naLY1fJYHCdlAj8qH7JgQapikTCTgWXIML+EfnfDIou1iirjA6kOMKIRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177083; c=relaxed/simple;
	bh=ArzBXgUkf/492ISu1Zo1h3SHOvWaEhkHDwZ8K0CacCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRDA02OsERg6UF/t8qlIhy9NNfAGswvLx7FX+lfe7KC+ED5xLdvWAqPl3QZ8pUH+gHGGarVcJE5iBgjCt9oooCwGXwsG5vEaUzOOi39aatRYwXa87+u1CqjrplXnKjeEGRcbMJkjDF6CiSJLkdvXUiTfrLF29xTb30HCjuQjGX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbDJ2edH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbDJ2edH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8F0C4CED2;
	Mon,  6 Jan 2025 15:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177083;
	bh=ArzBXgUkf/492ISu1Zo1h3SHOvWaEhkHDwZ8K0CacCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbDJ2edHfsN0P4f13rbDuV1z3a5i0vSvCar6l/0lZXVqUw390pkGd7I9KykF1t1zp
	 3A2s5uLnvvCLoBrPc0EcYENE3Baxso+YBw1gJyqToxciKAxvp6n5yNOLEqdeRKcG6A
	 gHSFepZXaKCOhYWJoyhNdYb0u47bGIbNSgzpd5Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/222] scsi: hisi_sas: Allocate DFX memory during dump trigger
Date: Mon,  6 Jan 2025 16:14:09 +0100
Message-ID: <20250106151152.308820155@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit 63f0733d07ce60252e885602b39571ade0441015 ]

Currently, if CONFIG_SCSI_HISI_SAS_DEBUGFS_DEFAULT_ENABLE is enabled, the
memory space used by DFX is allocated during device initialization, which
occupies a large number of memory resources. The memory usage before and
after the driver is loaded is as follows:

Memory usage before the driver is loaded:
$ free -m
         total        used        free      shared  buff/cache   available
Mem:     867352        2578      864037          11         735  861681
Swap:    4095           0        4095

Memory usage after the driver which include 4 HBAs is loaded:
$ insmod hisi_sas_v3_hw.ko
$ free -m
         total        used        free      shared  buff/cache	available
Mem:     867352        4760      861848          11	  743   859495
Swap:    4095           0        4095

The driver with 4 HBAs connected will allocate about 110 MB of memory
without enabling debugfs.

Therefore, to avoid wasting memory resources, DFX memory is allocated
during dump triggering. The dump may fail due to memory allocation
failure. After this change, each dump costs about 10 MB of memory, and each
dump lasts about 100 ms.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1694571327-78697-4-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 9f564f15f884 ("scsi: hisi_sas: Create all dump files during debugfs initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 93 +++++++++++++-------------
 2 files changed, 46 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 3d511c44c02d..1e4550156b73 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -343,7 +343,7 @@ struct hisi_sas_hw {
 				u8 reg_index, u8 reg_count, u8 *write_data);
 	void (*wait_cmds_complete_timeout)(struct hisi_hba *hisi_hba,
 					   int delay_ms, int timeout_ms);
-	void (*debugfs_snapshot_regs)(struct hisi_hba *hisi_hba);
+	int (*debugfs_snapshot_regs)(struct hisi_hba *hisi_hba);
 	int complete_hdr_size;
 	const struct scsi_host_template *sht;
 };
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 10f048b5a489..cea548655629 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -558,7 +558,7 @@ static int experimental_iopoll_q_cnt;
 module_param(experimental_iopoll_q_cnt, int, 0444);
 MODULE_PARM_DESC(experimental_iopoll_q_cnt, "number of queues to be used as poll mode, def=0");
 
-static void debugfs_snapshot_regs_v3_hw(struct hisi_hba *hisi_hba);
+static int debugfs_snapshot_regs_v3_hw(struct hisi_hba *hisi_hba);
 
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
 {
@@ -3867,37 +3867,6 @@ static void debugfs_create_files_v3_hw(struct hisi_hba *hisi_hba)
 			    &debugfs_ras_v3_hw_fops);
 }
 
-static void debugfs_snapshot_regs_v3_hw(struct hisi_hba *hisi_hba)
-{
-	int debugfs_dump_index = hisi_hba->debugfs_dump_index;
-	struct device *dev = hisi_hba->dev;
-	u64 timestamp = local_clock();
-
-	if (debugfs_dump_index >= hisi_sas_debugfs_dump_count) {
-		dev_warn(dev, "dump count exceeded!\n");
-		return;
-	}
-
-	do_div(timestamp, NSEC_PER_MSEC);
-	hisi_hba->debugfs_timestamp[debugfs_dump_index] = timestamp;
-
-	debugfs_snapshot_prepare_v3_hw(hisi_hba);
-
-	debugfs_snapshot_global_reg_v3_hw(hisi_hba);
-	debugfs_snapshot_port_reg_v3_hw(hisi_hba);
-	debugfs_snapshot_axi_reg_v3_hw(hisi_hba);
-	debugfs_snapshot_ras_reg_v3_hw(hisi_hba);
-	debugfs_snapshot_cq_reg_v3_hw(hisi_hba);
-	debugfs_snapshot_dq_reg_v3_hw(hisi_hba);
-	debugfs_snapshot_itct_reg_v3_hw(hisi_hba);
-	debugfs_snapshot_iost_reg_v3_hw(hisi_hba);
-
-	debugfs_create_files_v3_hw(hisi_hba);
-
-	debugfs_snapshot_restore_v3_hw(hisi_hba);
-	hisi_hba->debugfs_dump_index++;
-}
-
 static ssize_t debugfs_trigger_dump_v3_hw_write(struct file *file,
 						const char __user *user_buf,
 						size_t count, loff_t *ppos)
@@ -3905,9 +3874,6 @@ static ssize_t debugfs_trigger_dump_v3_hw_write(struct file *file,
 	struct hisi_hba *hisi_hba = file->f_inode->i_private;
 	char buf[8];
 
-	if (hisi_hba->debugfs_dump_index >= hisi_sas_debugfs_dump_count)
-		return -EFAULT;
-
 	if (count > 8)
 		return -EFAULT;
 
@@ -3918,7 +3884,10 @@ static ssize_t debugfs_trigger_dump_v3_hw_write(struct file *file,
 		return -EFAULT;
 
 	down(&hisi_hba->sem);
-	debugfs_snapshot_regs_v3_hw(hisi_hba);
+	if (debugfs_snapshot_regs_v3_hw(hisi_hba)) {
+		up(&hisi_hba->sem);
+		return -EFAULT;
+	}
 	up(&hisi_hba->sem);
 
 	return count;
@@ -4704,7 +4673,7 @@ static int debugfs_alloc_v3_hw(struct hisi_hba *hisi_hba, int dump_index)
 {
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	struct device *dev = hisi_hba->dev;
-	int p, c, d, r, i;
+	int p, c, d, r;
 	size_t sz;
 
 	for (r = 0; r < DEBUGFS_REGS_NUM; r++) {
@@ -4784,11 +4753,48 @@ static int debugfs_alloc_v3_hw(struct hisi_hba *hisi_hba, int dump_index)
 
 	return 0;
 fail:
-	for (i = 0; i < hisi_sas_debugfs_dump_count; i++)
-		debugfs_release_v3_hw(hisi_hba, i);
+	debugfs_release_v3_hw(hisi_hba, dump_index);
 	return -ENOMEM;
 }
 
+static int debugfs_snapshot_regs_v3_hw(struct hisi_hba *hisi_hba)
+{
+	int debugfs_dump_index = hisi_hba->debugfs_dump_index;
+	struct device *dev = hisi_hba->dev;
+	u64 timestamp = local_clock();
+
+	if (debugfs_dump_index >= hisi_sas_debugfs_dump_count) {
+		dev_warn(dev, "dump count exceeded!\n");
+		return -EINVAL;
+	}
+
+	if (debugfs_alloc_v3_hw(hisi_hba, debugfs_dump_index)) {
+		dev_warn(dev, "failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+	do_div(timestamp, NSEC_PER_MSEC);
+	hisi_hba->debugfs_timestamp[debugfs_dump_index] = timestamp;
+
+	debugfs_snapshot_prepare_v3_hw(hisi_hba);
+
+	debugfs_snapshot_global_reg_v3_hw(hisi_hba);
+	debugfs_snapshot_port_reg_v3_hw(hisi_hba);
+	debugfs_snapshot_axi_reg_v3_hw(hisi_hba);
+	debugfs_snapshot_ras_reg_v3_hw(hisi_hba);
+	debugfs_snapshot_cq_reg_v3_hw(hisi_hba);
+	debugfs_snapshot_dq_reg_v3_hw(hisi_hba);
+	debugfs_snapshot_itct_reg_v3_hw(hisi_hba);
+	debugfs_snapshot_iost_reg_v3_hw(hisi_hba);
+
+	debugfs_create_files_v3_hw(hisi_hba);
+
+	debugfs_snapshot_restore_v3_hw(hisi_hba);
+	hisi_hba->debugfs_dump_index++;
+
+	return 0;
+}
+
 static void debugfs_phy_down_cnt_init_v3_hw(struct hisi_hba *hisi_hba)
 {
 	struct dentry *dir = debugfs_create_dir("phy_down_cnt",
@@ -4875,7 +4881,6 @@ static void debugfs_exit_v3_hw(struct hisi_hba *hisi_hba)
 static void debugfs_init_v3_hw(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = hisi_hba->dev;
-	int i;
 
 	hisi_hba->debugfs_dir = debugfs_create_dir(dev_name(dev),
 						   hisi_sas_debugfs_dir);
@@ -4892,14 +4897,6 @@ static void debugfs_init_v3_hw(struct hisi_hba *hisi_hba)
 
 	debugfs_phy_down_cnt_init_v3_hw(hisi_hba);
 	debugfs_fifo_init_v3_hw(hisi_hba);
-
-	for (i = 0; i < hisi_sas_debugfs_dump_count; i++) {
-		if (debugfs_alloc_v3_hw(hisi_hba, i)) {
-			debugfs_exit_v3_hw(hisi_hba);
-			dev_dbg(dev, "failed to init debugfs!\n");
-			break;
-		}
-	}
 }
 
 static int
-- 
2.39.5



