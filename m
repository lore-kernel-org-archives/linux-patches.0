Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B4238FB9;
	Mon,  6 Jan 2025 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177265; cv=none; b=jttd5hXICzlwfc/9VBPbUGve6iVMOpX216xV+EjyQQ8pxx8pF2/qLbRLqrOPbhc15W0kapwP6ImBfym28JST4fNLQZsCKRgyhNIRh3g/paE5gJ+eO0RaNb/8IvtPjdmS7avfIrFinIHCm0uwhqDQv7O/Z1mBCrGNyctj958PBa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177265; c=relaxed/simple;
	bh=aag+9XnZAMMfaPNTOlJFuezrsJgCTDr/625PUaBbxzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zf6SLCQW95N0sxKLu8pxCJCh85oNsWw5jeiXIPG8ATOE7tgaQsa2dCMAvestic4Vx9nuHYq36VQZNaIQn1PBRe3FD95AtdzLlfz8ConZKoFxWJ00waw8Lr4xTLq5S5gmmh4xKAIW5QUBPCW03/jK3aoG/xX17l64vmnjgSxSRiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDtcwXJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDtcwXJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99359C4CEDF;
	Mon,  6 Jan 2025 15:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177265;
	bh=aag+9XnZAMMfaPNTOlJFuezrsJgCTDr/625PUaBbxzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDtcwXJ+5fTTGTLI1DMSV24CUj54i/fnt/EhfoMHycza0IrspRL4TSnX6P4LshlMD
	 arYZ4T/4VN2ikkFNZuunrpuEizGZLctcZzsrukZzHmVENMizVGoYBsnGLkxgKUgO8j
	 B+DMoNR8fQRlgH3lUeH3gxaMP2+/B1nJxzAGldVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/222] scsi: hisi_sas: Fix a deadlock issue related to automatic dump
Date: Mon,  6 Jan 2025 16:15:11 +0100
Message-ID: <20250106151154.647327871@linuxfoundation.org>
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

[ Upstream commit 3c4f53b2c341ec6428b98cb51a89a09b025d0953 ]

If we issue a disabling PHY command, the device attached with it will go
offline, if a 2 bit ECC error occurs at the same time, a hung task may be
found:

[ 4613.652388] INFO: task kworker/u256:0:165233 blocked for more than 120 seconds.
[ 4613.666297] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4613.674809] task:kworker/u256:0  state:D stack:    0 pid:165233 ppid:     2 flags:0x00000208
[ 4613.683959] Workqueue: 0000:74:02.0_disco_q sas_revalidate_domain [libsas]
[ 4613.691518] Call trace:
[ 4613.694678]  __switch_to+0xf8/0x17c
[ 4613.698872]  __schedule+0x660/0xee0
[ 4613.703063]  schedule+0xac/0x240
[ 4613.706994]  schedule_timeout+0x500/0x610
[ 4613.711705]  __down+0x128/0x36c
[ 4613.715548]  down+0x240/0x2d0
[ 4613.719221]  hisi_sas_internal_abort_timeout+0x1bc/0x260 [hisi_sas_main]
[ 4613.726618]  sas_execute_internal_abort+0x144/0x310 [libsas]
[ 4613.732976]  sas_execute_internal_abort_dev+0x44/0x60 [libsas]
[ 4613.739504]  hisi_sas_internal_task_abort_dev.isra.0+0xbc/0x1b0 [hisi_sas_main]
[ 4613.747499]  hisi_sas_dev_gone+0x174/0x250 [hisi_sas_main]
[ 4613.753682]  sas_notify_lldd_dev_gone+0xec/0x2e0 [libsas]
[ 4613.759781]  sas_unregister_common_dev+0x4c/0x7a0 [libsas]
[ 4613.765962]  sas_destruct_devices+0xb8/0x120 [libsas]
[ 4613.771709]  sas_do_revalidate_domain.constprop.0+0x1b8/0x31c [libsas]
[ 4613.778930]  sas_revalidate_domain+0x60/0xa4 [libsas]
[ 4613.784716]  process_one_work+0x248/0x950
[ 4613.789424]  worker_thread+0x318/0x934
[ 4613.793878]  kthread+0x190/0x200
[ 4613.797810]  ret_from_fork+0x10/0x18
[ 4613.802121] INFO: task kworker/u256:4:316722 blocked for more than 120 seconds.
[ 4613.816026] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4613.824538] task:kworker/u256:4  state:D stack:    0 pid:316722 ppid:     2 flags:0x00000208
[ 4613.833670] Workqueue: 0000:74:02.0 hisi_sas_rst_work_handler [hisi_sas_main]
[ 4613.841491] Call trace:
[ 4613.844647]  __switch_to+0xf8/0x17c
[ 4613.848852]  __schedule+0x660/0xee0
[ 4613.853052]  schedule+0xac/0x240
[ 4613.856984]  schedule_timeout+0x500/0x610
[ 4613.861695]  __down+0x128/0x36c
[ 4613.865542]  down+0x240/0x2d0
[ 4613.869216]  hisi_sas_controller_prereset+0x58/0x1fc [hisi_sas_main]
[ 4613.876324]  hisi_sas_rst_work_handler+0x40/0x8c [hisi_sas_main]
[ 4613.883019]  process_one_work+0x248/0x950
[ 4613.887732]  worker_thread+0x318/0x934
[ 4613.892204]  kthread+0x190/0x200
[ 4613.896118]  ret_from_fork+0x10/0x18
[ 4613.900423] INFO: task kworker/u256:1:348985 blocked for more than 121 seconds.
[ 4613.914341] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4613.922852] task:kworker/u256:1  state:D stack:    0 pid:348985 ppid:     2 flags:0x00000208
[ 4613.931984] Workqueue: 0000:74:02.0_event_q sas_port_event_worker [libsas]
[ 4613.939549] Call trace:
[ 4613.942702]  __switch_to+0xf8/0x17c
[ 4613.946892]  __schedule+0x660/0xee0
[ 4613.951083]  schedule+0xac/0x240
[ 4613.955015]  schedule_timeout+0x500/0x610
[ 4613.959725]  wait_for_common+0x200/0x610
[ 4613.964349]  wait_for_completion+0x3c/0x5c
[ 4613.969146]  flush_workqueue+0x198/0x790
[ 4613.973776]  sas_porte_broadcast_rcvd+0x1e8/0x320 [libsas]
[ 4613.979960]  sas_port_event_worker+0x54/0xa0 [libsas]
[ 4613.985708]  process_one_work+0x248/0x950
[ 4613.990420]  worker_thread+0x318/0x934
[ 4613.994868]  kthread+0x190/0x200
[ 4613.998800]  ret_from_fork+0x10/0x18

This is because when the device goes offline, we obtain the hisi_hba
semaphore and send the ABORT_DEV command to the device. However, the
internal abort timed out due to the 2 bit ECC error and triggers automatic
dump. In addition, since the hisi_hba semaphore has been obtained, the dump
cannot be executed and the controller cannot be reset.

Therefore, the deadlocks occur on the following circular dependencies:
hisi_sas_dev_gone() -> down() -> hisi_sas_internal_task_abort_dev() -> ...
-> hisi_sas_internal_abort_timeout() -> down().

The deadlock is triggered only when the timeout occurs during device goes
offline. To fix this issue, use .rst_ha_timeout to distinguish the scenario
where a device goes offline from other scenarios.

Fixes: 2ff07b5c6fe9 ("scsi: hisi_sas: Directly call register snapshot instead of using workqueue")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1705904747-62186-2-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 5fdba7b39a1b..4ce737ddb058 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1968,9 +1968,17 @@ static bool hisi_sas_internal_abort_timeout(struct sas_task *task,
 	struct hisi_sas_internal_abort_data *timeout = data;
 
 	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct) {
-		down(&hisi_hba->sem);
+		/*
+		 * If timeout occurs in device gone scenario, to avoid
+		 * circular dependency like:
+		 * hisi_sas_dev_gone() -> down() -> ... ->
+		 * hisi_sas_internal_abort_timeout() -> down().
+		 */
+		if (!timeout->rst_ha_timeout)
+			down(&hisi_hba->sem);
 		hisi_hba->hw->debugfs_snapshot_regs(hisi_hba);
-		up(&hisi_hba->sem);
+		if (!timeout->rst_ha_timeout)
+			up(&hisi_hba->sem);
 	}
 
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
-- 
2.39.5



