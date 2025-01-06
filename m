Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F9C1DDC06;
	Mon,  6 Jan 2025 15:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177081; cv=none; b=Zwj+1+jjp/UGLeoItx59/BcwzLSwPM45O51JM6xPHywPQdH+YepBEjssmwtASxohNaMJ811HrtEC/V2tlad6C5qBE3YgZu0SIhtZSsKvnus4iNq3f9PTdS7RyMRqFmc/7TKdFjv4Og4oVbQLDTM9I8d0e9j6360Daa8+XZvnqjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177081; c=relaxed/simple;
	bh=tH0nMG00KQvBM1JMR07Iar4dSYlmPgQUt/Pv20MPQik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcK3kj0olZK9101U/lbTzC2t8RK9j955mvg1jI6USTtSpBvUtxL/rBBuH6cy1FdgU3mtKiCVU9wr4CzCa8w7iqdklIYjTUNtQ88TXaVQPLvWgBSpT4rYb6RZ5qHMNBDj8h34FXY+Elipc0hpD3KfSmT2iOWVyfubGxg2LTs9HZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcFzOBMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcFzOBMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF7BC4CED6;
	Mon,  6 Jan 2025 15:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177080;
	bh=tH0nMG00KQvBM1JMR07Iar4dSYlmPgQUt/Pv20MPQik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcFzOBMw4JgqAe2Xw/mG/DOglMQwrCU231EeazLMPf/2gjRRBLHdNYbfIX6Y4nHmY
	 B7t5KVEDZF58CrVrt0F9AH/biOxZl55vArcAZCiwH/31ERbxkrjv8/vWbRjdoKfFdm
	 p2cc6ft6QXjkh/NR0suG71EuS0vdCbSaeQgh+1ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/222] scsi: hisi_sas: Directly call register snapshot instead of using workqueue
Date: Mon,  6 Jan 2025 16:14:08 +0100
Message-ID: <20250106151152.270962225@linuxfoundation.org>
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

[ Upstream commit 2ff07b5c6fe9173e7a7de3b23f300d71ad4d8fde ]

Currently, register information dump is performed via workqueue, regardless
of the trigger mode (automatic or manual). There is a delay in dumping
register through workqueue, the exact register information at trigger time
cannot be obtained.

Call register snapshot directly instead of through a workqueue.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1694571327-78697-3-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 9f564f15f884 ("scsi: hisi_sas: Create all dump files during debugfs initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 -
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  7 +++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 14 +++-----------
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 9e73e9cbbcfc..3d511c44c02d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -451,7 +451,6 @@ struct hisi_hba {
 	const struct hisi_sas_hw *hw;	/* Low level hw interface */
 	unsigned long sata_dev_bitmap[BITS_TO_LONGS(HISI_SAS_MAX_DEVICES)];
 	struct work_struct rst_work;
-	struct work_struct debugfs_work;
 	u32 phy_state;
 	u32 intr_coal_ticks;	/* Time of interrupt coalesce in us */
 	u32 intr_coal_count;	/* Interrupt count to coalesce */
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index db9ae206974c..5fdba7b39a1b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1967,8 +1967,11 @@ static bool hisi_sas_internal_abort_timeout(struct sas_task *task,
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct hisi_sas_internal_abort_data *timeout = data;
 
-	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
-		queue_work(hisi_hba->wq, &hisi_hba->debugfs_work);
+	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct) {
+		down(&hisi_hba->sem);
+		hisi_hba->hw->debugfs_snapshot_regs(hisi_hba);
+		up(&hisi_hba->sem);
+	}
 
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		pr_err("Internal abort: timeout %016llx\n",
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 4054659d48f7..10f048b5a489 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -558,7 +558,6 @@ static int experimental_iopoll_q_cnt;
 module_param(experimental_iopoll_q_cnt, int, 0444);
 MODULE_PARM_DESC(experimental_iopoll_q_cnt, "number of queues to be used as poll mode, def=0");
 
-static void debugfs_work_handler_v3_hw(struct work_struct *work);
 static void debugfs_snapshot_regs_v3_hw(struct hisi_hba *hisi_hba);
 
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
@@ -3397,7 +3396,6 @@ hisi_sas_shost_alloc_pci(struct pci_dev *pdev)
 	hisi_hba = shost_priv(shost);
 
 	INIT_WORK(&hisi_hba->rst_work, hisi_sas_rst_work_handler);
-	INIT_WORK(&hisi_hba->debugfs_work, debugfs_work_handler_v3_hw);
 	hisi_hba->hw = &hisi_sas_v3_hw;
 	hisi_hba->pci_dev = pdev;
 	hisi_hba->dev = dev;
@@ -3919,7 +3917,9 @@ static ssize_t debugfs_trigger_dump_v3_hw_write(struct file *file,
 	if (buf[0] != '1')
 		return -EFAULT;
 
-	queue_work(hisi_hba->wq, &hisi_hba->debugfs_work);
+	down(&hisi_hba->sem);
+	debugfs_snapshot_regs_v3_hw(hisi_hba);
+	up(&hisi_hba->sem);
 
 	return count;
 }
@@ -4670,14 +4670,6 @@ static void debugfs_fifo_init_v3_hw(struct hisi_hba *hisi_hba)
 	}
 }
 
-static void debugfs_work_handler_v3_hw(struct work_struct *work)
-{
-	struct hisi_hba *hisi_hba =
-		container_of(work, struct hisi_hba, debugfs_work);
-
-	debugfs_snapshot_regs_v3_hw(hisi_hba);
-}
-
 static void debugfs_release_v3_hw(struct hisi_hba *hisi_hba, int dump_index)
 {
 	struct device *dev = hisi_hba->dev;
-- 
2.39.5



