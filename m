Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7EA1448C3;
	Tue, 27 Feb 2024 14:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044042; cv=none; b=D1iaBNRyCYHifG17ryxITOL/pfu+JBquGxwg2gcZn2FLuqvfblmtUUSKxZzH0WGaPbggQBzvyWg3f3i4Zffas1FP//7Ev83RaveqH36ilOtBqsjMUD5rAKfka7NVRQ58AExHy/1ORoM8Hrb0B9MLvkErJdbC7LOAhFTjBr3etUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044042; c=relaxed/simple;
	bh=/sQZlpq7rfzc6H/AquHN8d/C0JNaNbzQS9gdhcjPUWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwnvmGPEf/Q6BIzaZJUzxWxHmbggo00+g0zlo55ZrOvIhkaMP0az+GYVjnke93SM0SfnmM6nBMR9OTze8oPvCsW9z/GX9xvjXeX9977fPhFLnVi4jYEah6nFNwvL9vTwbazQvdwzVtBlNQPVa2OIIw09ayxdPk+j1kmoIB8C5Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hlyH1kAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlyH1kAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD361C433F1;
	Tue, 27 Feb 2024 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044042;
	bh=/sQZlpq7rfzc6H/AquHN8d/C0JNaNbzQS9gdhcjPUWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlyH1kAZGWcFEUWY+0myfiRz7RPqnZdT6niN3sQiz+35hI5aJOBNvzUX798ueQMre
	 pRfjsnXw7iMsMAK3I2QORzx2xb6Ib2f4xAjYTCW55nM37LxAj2i5ps686UVGYreF1p
	 BHv1o72rSuNFsqMHCmmrHyWPepV3O7srC5J47V0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/122] scsi: target: core: Add TMF to tmr_list handling
Date: Tue, 27 Feb 2024 14:26:13 +0100
Message-ID: <20240227131559.109002927@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

[ Upstream commit 83ab68168a3d990d5ff39ab030ad5754cbbccb25 ]

An abort that is responded to by iSCSI itself is added to tmr_list but does
not go to target core. A LUN_RESET that goes through tmr_list takes a
refcounter on the abort and waits for completion. However, the abort will
be never complete because it was not started in target core.

 Unable to locate ITT: 0x05000000 on CID: 0
 Unable to locate RefTaskTag: 0x05000000 on CID: 0.
 wait_for_tasks: Stopping tmf LUN_RESET with tag 0x0 ref_task_tag 0x0 i_state 34 t_state ISTATE_PROCESSING refcnt 2 transport_state active,stop,fabric_stop
 wait for tasks: tmf LUN_RESET with tag 0x0 ref_task_tag 0x0 i_state 34 t_state ISTATE_PROCESSING refcnt 2 transport_state active,stop,fabric_stop
...
 INFO: task kworker/0:2:49 blocked for more than 491 seconds.
 task:kworker/0:2     state:D stack:    0 pid:   49 ppid:     2 flags:0x00000800
 Workqueue: events target_tmr_work [target_core_mod]
Call Trace:
 __switch_to+0x2c4/0x470
 _schedule+0x314/0x1730
 schedule+0x64/0x130
 schedule_timeout+0x168/0x430
 wait_for_completion+0x140/0x270
 target_put_cmd_and_wait+0x64/0xb0 [target_core_mod]
 core_tmr_lun_reset+0x30/0xa0 [target_core_mod]
 target_tmr_work+0xc8/0x1b0 [target_core_mod]
 process_one_work+0x2d4/0x5d0
 worker_thread+0x78/0x6c0

To fix this, only add abort to tmr_list if it will be handled by target
core.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Link: https://lore.kernel.org/r/20240111125941.8688-1-d.bogdanov@yadro.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_device.c    | 5 -----
 drivers/target/target_core_transport.c | 4 ++++
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 9aeedcff7d02e..daa4d06ce2336 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -150,7 +150,6 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd)
 	struct se_session *se_sess = se_cmd->se_sess;
 	struct se_node_acl *nacl = se_sess->se_node_acl;
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
-	unsigned long flags;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, se_cmd->orig_fe_lun);
@@ -181,10 +180,6 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd)
 	se_cmd->se_dev = rcu_dereference_raw(se_lun->lun_se_dev);
 	se_tmr->tmr_dev = rcu_dereference_raw(se_lun->lun_se_dev);
 
-	spin_lock_irqsave(&se_tmr->tmr_dev->se_tmr_lock, flags);
-	list_add_tail(&se_tmr->tmr_list, &se_tmr->tmr_dev->dev_tmr_list);
-	spin_unlock_irqrestore(&se_tmr->tmr_dev->se_tmr_lock, flags);
-
 	return 0;
 }
 EXPORT_SYMBOL(transport_lookup_tmr_lun);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2e97937f005ff..8d294b658592c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3436,6 +3436,10 @@ int transport_generic_handle_tmr(
 	unsigned long flags;
 	bool aborted = false;
 
+	spin_lock_irqsave(&cmd->se_dev->se_tmr_lock, flags);
+	list_add_tail(&cmd->se_tmr_req->tmr_list, &cmd->se_dev->dev_tmr_list);
+	spin_unlock_irqrestore(&cmd->se_dev->se_tmr_lock, flags);
+
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (cmd->transport_state & CMD_T_ABORTED) {
 		aborted = true;
-- 
2.43.0



