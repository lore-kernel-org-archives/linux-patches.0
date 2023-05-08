Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8757168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D09C433D2;
	Mon,  8 May 2023 11:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544303;
	bh=Qida51R40wqvaaDDyBXNknlDK63bTZyHq7PMLRbvU0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TajAxY0DMNIiTUPAk9ozOgV4NpQ/yAt49fRTCbPCpP97Z+uEoqmKw5Aoa1lMV3gUj
	 CoSQG5VQyidpr00+arwF90oNfLR4oTtoMm7vMkAWP3B2+5A/4cG9EsG6IRv38zmg+i
	 QINns5/OfPJVmMT/fEbxrrNZrC1MLGATKXHV6ZJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 366/694] scsi: target: Fix multiple LUN_RESET handling
Date: Mon,  8 May 2023 11:43:21 +0200
Message-Id: <20230508094444.610646327@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 673db054d7a2b5a470d7a25baf65956d005ad729 ]

This fixes a bug where an initiator thinks a LUN_RESET has cleaned up
running commands when it hasn't. The bug was added in commit 51ec502a3266
("target: Delete tmr from list before processing").

The problem occurs when:

 1. We have N I/O cmds running in the target layer spread over 2 sessions.

 2. The initiator sends a LUN_RESET for each session.

 3. session1's LUN_RESET loops over all the running commands from both
    sessions and moves them to its local drain_task_list.

 4. session2's LUN_RESET does not see the LUN_RESET from session1 because
    the commit above has it remove itself. session2 also does not see any
    commands since the other reset moved them off the state lists.

 5. sessions2's LUN_RESET will then complete with a successful response.

 6. sessions2's inititor believes the running commands on its session are
    now cleaned up due to the successful response and cleans up the running
    commands from its side. It then restarts them.

 7. The commands do eventually complete on the backend and the target
    starts to return aborted task statuses for them. The initiator will
    either throw a invalid ITT error or might accidentally lookup a new
    task if the ITT has been reallocated already.

Fix the bug by reverting the patch, and serialize the execution of
LUN_RESETs and Preempt and Aborts.

Also prevent us from waiting on LUN_RESETs in core_tmr_drain_tmr_list,
because it turns out the original patch fixed a bug that was not
mentioned. For LUN_RESET1 core_tmr_drain_tmr_list can see a second
LUN_RESET and wait on it. Then the second reset will run
core_tmr_drain_tmr_list and see the first reset and wait on it resulting in
a deadlock.

Fixes: 51ec502a3266 ("target: Delete tmr from list before processing")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Link: https://lore.kernel.org/r/20230319015620.96006-8-michael.christie@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_device.c |  1 +
 drivers/target/target_core_tmr.c    | 26 +++++++++++++++++++++++---
 include/target/target_core_base.h   |  1 +
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index f6e58410ec3f9..aeb03136773d5 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -782,6 +782,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	spin_lock_init(&dev->t10_alua.lba_map_lock);
 
 	INIT_WORK(&dev->delayed_cmd_work, target_do_delayed_work);
+	mutex_init(&dev->lun_reset_mutex);
 
 	dev->t10_wwn.t10_dev = dev;
 	/*
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 2b95b4550a637..4718db628222b 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -188,14 +188,23 @@ static void core_tmr_drain_tmr_list(
 	 * LUN_RESET tmr..
 	 */
 	spin_lock_irqsave(&dev->se_tmr_lock, flags);
-	if (tmr)
-		list_del_init(&tmr->tmr_list);
 	list_for_each_entry_safe(tmr_p, tmr_pp, &dev->dev_tmr_list, tmr_list) {
+		if (tmr_p == tmr)
+			continue;
+
 		cmd = tmr_p->task_cmd;
 		if (!cmd) {
 			pr_err("Unable to locate struct se_cmd for TMR\n");
 			continue;
 		}
+
+		/*
+		 * We only execute one LUN_RESET at a time so we can't wait
+		 * on them below.
+		 */
+		if (tmr_p->function == TMR_LUN_RESET)
+			continue;
+
 		/*
 		 * If this function was called with a valid pr_res_key
 		 * parameter (eg: for PROUT PREEMPT_AND_ABORT service action
@@ -379,14 +388,25 @@ int core_tmr_lun_reset(
 				tmr_nacl->initiatorname);
 		}
 	}
+
+
+	/*
+	 * We only allow one reset or preempt and abort to execute at a time
+	 * to prevent one call from claiming all the cmds causing a second
+	 * call from returning while cmds it should have waited on are still
+	 * running.
+	 */
+	mutex_lock(&dev->lun_reset_mutex);
+
 	pr_debug("LUN_RESET: %s starting for [%s], tas: %d\n",
 		(preempt_and_abort_list) ? "Preempt" : "TMR",
 		dev->transport->name, tas);
-
 	core_tmr_drain_tmr_list(dev, tmr, preempt_and_abort_list);
 	core_tmr_drain_state_list(dev, prout_cmd, tmr_sess, tas,
 				preempt_and_abort_list);
 
+	mutex_unlock(&dev->lun_reset_mutex);
+
 	/*
 	 * Clear any legacy SPC-2 reservation when called during
 	 * LOGICAL UNIT RESET
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index bd299790e99c3..8cc42ad65c925 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -872,6 +872,7 @@ struct se_device {
 	struct rcu_head		rcu_head;
 	int			queue_cnt;
 	struct se_device_queue	*queues;
+	struct mutex		lun_reset_mutex;
 };
 
 struct target_opcode_descriptor {
-- 
2.39.2



