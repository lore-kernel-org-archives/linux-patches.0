Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36365B210;
	Tue, 23 Jan 2024 01:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974329; cv=none; b=aZAzcVZU/hf9BMcqol2469SBLlgpd1X+QwDSrLGyxfXa3+qw6AD1n9pH4Tz8WH44OqCKOcIsF2epttL1zSmlFz90qC4RhgnDaeJCzrV3lecS70ZEuHSLJpAWI3+KdBxD1sKV6lQJOQvvQ830YYYbgOBsL2QVoVRACv5ib7AxgcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974329; c=relaxed/simple;
	bh=kK7E6O/CMPpE3S1gvFd/OejrXRm2CNPZlmImnXqe8+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUSmDZA/bHAD6LPs8Y1fc/Qi3pHaa0S0kombj8JR2cJOuswnIPYTfz5Le7gAdCanA+2ENtRPf1XqXgp2rmULzZVxodJG1uXtRGTjtrlC5Bmdpe9oUnsW1pBQc6DgV2po1C3rapSnp6f4MEVOiBck9zLF3pw+YX2ygBSnKra39qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LqCYf7RS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LqCYf7RS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7FFC433C7;
	Tue, 23 Jan 2024 01:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974328;
	bh=kK7E6O/CMPpE3S1gvFd/OejrXRm2CNPZlmImnXqe8+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LqCYf7RSXQhZbIf7k2cxO51JjdDkbBG3BgG8VShR1HKEy+cB8wcsMwbFWxKTGFNXj
	 /TKWBFriVpiNYXmksoHS2HDqCCecH9mBwurv9krcXvnZCnBxQv0G1iP9//WAmDVsHh
	 g/J9arKYW6k398pnwfOwtKFtE/E2PlEO6trjyLzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Liu <liuqi115@huawei.com>,
	John Garry <john.garry@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/374] scsi: hisi_sas: Prevent parallel FLR and controller reset
Date: Mon, 22 Jan 2024 15:56:39 -0800
Message-ID: <20240122235749.603154552@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qi Liu <liuqi115@huawei.com>

[ Upstream commit 16775db613c2bdea09705dcb876942c0641a1098 ]

If we issue a controller reset command during executing a FLR a hung task
may be found:

 Call trace:
  __switch_to+0x158/0x1cc
  __schedule+0x2e8/0x85c
  schedule+0x7c/0x110
  schedule_timeout+0x190/0x1cc
  __down+0x7c/0xd4
  down+0x5c/0x7c
  hisi_sas_task_exec+0x510/0x680 [hisi_sas_main]
  hisi_sas_queue_command+0x24/0x30 [hisi_sas_main]
  smp_execute_task_sg+0xf4/0x23c [libsas]
  sas_smp_phy_control+0x110/0x1e0 [libsas]
  transport_sas_phy_reset+0xc8/0x190 [libsas]
  phy_reset_work+0x2c/0x40 [libsas]
  process_one_work+0x1dc/0x48c
  worker_thread+0x15c/0x464
  kthread+0x160/0x170
  ret_from_fork+0x10/0x18

This is a race condition which occurs when the FLR completes first.

Here the host HISI_SAS_RESETTING_BIT flag out gets of sync as
HISI_SAS_RESETTING_BIT is not always cleared with the hisi_hba.sem held, so
now only set/unset HISI_SAS_RESETTING_BIT under hisi_hba.sem .

Link: https://lore.kernel.org/r/1639579061-179473-7-git-send-email-john.garry@huawei.com
Signed-off-by: Qi Liu <liuqi115@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: d34ee535705e ("scsi: hisi_sas: Replace with standard error code return value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 8 +++++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 7744594cd3e3..19081790f011 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1548,7 +1548,6 @@ void hisi_sas_controller_reset_prepare(struct hisi_hba *hisi_hba)
 {
 	struct Scsi_Host *shost = hisi_hba->shost;
 
-	down(&hisi_hba->sem);
 	hisi_hba->phy_state = hisi_hba->hw->get_phys_state(hisi_hba);
 
 	scsi_block_requests(shost);
@@ -1574,9 +1573,9 @@ void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
 	if (hisi_hba->reject_stp_links_msk)
 		hisi_sas_terminate_stp_reject(hisi_hba);
 	hisi_sas_reset_init_all_devices(hisi_hba);
-	up(&hisi_hba->sem);
 	scsi_unblock_requests(shost);
 	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
+	up(&hisi_hba->sem);
 
 	hisi_sas_rescan_topology(hisi_hba, hisi_hba->phy_state);
 }
@@ -1587,8 +1586,11 @@ static int hisi_sas_controller_prereset(struct hisi_hba *hisi_hba)
 	if (!hisi_hba->hw->soft_reset)
 		return -1;
 
-	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags))
+	down(&hisi_hba->sem);
+	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags)) {
+		up(&hisi_hba->sem);
 		return -1;
+	}
 
 	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
 		hisi_hba->hw->debugfs_snapshot_regs(hisi_hba);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 2ed787956fa8..0e57381121d5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4935,6 +4935,7 @@ static void hisi_sas_reset_prepare_v3_hw(struct pci_dev *pdev)
 	int rc;
 
 	dev_info(dev, "FLR prepare\n");
+	down(&hisi_hba->sem);
 	set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
 	hisi_sas_controller_reset_prepare(hisi_hba);
 
-- 
2.43.0



