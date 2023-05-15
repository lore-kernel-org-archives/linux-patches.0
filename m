Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB95FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86324C433EF;
	Mon, 15 May 2023 17:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172421;
	bh=U+BrwEPcRH2ilczDcd0xaFu8p/NID5/+d5TQ+rq6+Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6QCVNPGhHTPTOD0k3d9UN335A9963JyZsvLxH1RJRHmQYm0Pwq5Mu/J86sztdBLe
	 eAOutb8/K+KpcAsxY8R0OSnFMbEn0YBV9z9tPF8pMjERJdb+CpI9qlO0PojjkSP4rH
	 CggNjMfdPBvUBnu0M61PRKd4FIyUCo8LB98WoB84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/381] scsi: target: Fix multiple LUN_RESET handling
Date: Mon, 15 May 2023 18:26:39 +0200
Message-Id: <20230515161743.535560327@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
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
index bd3f1192c75a1..4664330fb55dd 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -770,6 +770,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	spin_lock_init(&dev->t10_alua.lba_map_lock);
 
 	INIT_WORK(&dev->delayed_cmd_work, target_do_delayed_work);
+	mutex_init(&dev->lun_reset_mutex);
 
 	dev->t10_wwn.t10_dev = dev;
 	dev->t10_alua.t10_dev = dev;
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 5da384bb88c82..a2b18a98d6718 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -202,14 +202,23 @@ static void core_tmr_drain_tmr_list(
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
@@ -390,14 +399,25 @@ int core_tmr_lun_reset(
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
index 0109adcdfa0b4..e681c712fcca2 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -850,6 +850,7 @@ struct se_device {
 	struct rcu_head		rcu_head;
 	int			queue_cnt;
 	struct se_device_queue	*queues;
+	struct mutex		lun_reset_mutex;
 };
 
 struct se_hba {
-- 
2.39.2



