Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD0873451;
	Mon,  6 Jan 2025 15:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177804; cv=none; b=sJAQxfup6/pIYB7vKIr2RKEjkQUPTrxRMBWBLUvJB2aoilFIq3o9jwi7jmAe5vsKYqvS3RnemgO+/q2JaKA5mS+vsVUms7hyjJj+cv2GJICONcvwpPpxiIcd7/Vhr9okOg6iwFNSXrvB/s5HT2qywkCUt5w8nEts+ke+rkKYVX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177804; c=relaxed/simple;
	bh=OJUby5SnDISmp77lXSTrYqmJK3IOSoTVIsSfvzKUedY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yx4Yw4DVjeep6zwPn3zEVk8kT/IfVZqMoomDAF8dnuhkH4DeW4Ku3TzRj7p7WOqBLtcmKb8JXoEJMT/2zpvepyApm8gysv2FozA0IjllniVcm0ZJ0wss1m6PSjF/XNDBG2gPLPlCTU54Vg+HR1C5EUqJuaKiy/uFCZ8pIsGMbBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ae2na6Dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ae2na6Dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F448C4CEE2;
	Mon,  6 Jan 2025 15:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177804;
	bh=OJUby5SnDISmp77lXSTrYqmJK3IOSoTVIsSfvzKUedY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ae2na6Dn028Af41p9de8jTdDld6nVa+5PVml6sozUrG/32zA6bfz97d/nE6axCttE
	 eNQWpkfrCZfUXCmmQIZOBYf7V8SRilDR2srUhtj58XgNp1hlG9rqgfb2U/eW5473pZ
	 A1LrUnZLqdOdb1xGMBwfcHvcHas2DoFHZownId3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjian Song <jinjian.song@fibocom.com>,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/156] net: wwan: t7xx: Fix FSM command timeout issue
Date: Mon,  6 Jan 2025 16:15:49 +0100
Message-ID: <20250106151144.109339752@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Jinjian Song <jinjian.song@fibocom.com>

[ Upstream commit 4f619d518db9cd1a933c3a095a5f95d0c1584ae8 ]

When driver processes the internal state change command, it use an
asynchronous thread to process the command operation. If the main
thread detects that the task has timed out, the asynchronous thread
will panic when executing the completion notification because the
main thread completion object has been released.

BUG: unable to handle page fault for address: fffffffffffffff8
PGD 1f283a067 P4D 1f283a067 PUD 1f283c067 PMD 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
RIP: 0010:complete_all+0x3e/0xa0
[...]
Call Trace:
 <TASK>
 ? __die_body+0x68/0xb0
 ? page_fault_oops+0x379/0x3e0
 ? exc_page_fault+0x69/0xa0
 ? asm_exc_page_fault+0x22/0x30
 ? complete_all+0x3e/0xa0
 fsm_main_thread+0xa3/0x9c0 [mtk_t7xx (HASH:1400 5)]
 ? __pfx_autoremove_wake_function+0x10/0x10
 kthread+0xd8/0x110
 ? __pfx_fsm_main_thread+0x10/0x10 [mtk_t7xx (HASH:1400 5)]
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x38/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
 </TASK>
[...]
CR2: fffffffffffffff8
---[ end trace 0000000000000000 ]---

Use the reference counter to ensure safe release as Sergey suggests:
https://lore.kernel.org/all/da90f64c-260a-4329-87bf-1f9ff20a5951@gmail.com/

Fixes: 13e920d93e37 ("net: wwan: t7xx: Add core components")
Signed-off-by: Jinjian Song <jinjian.song@fibocom.com>
Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Link: https://patch.msgid.link/20241224041552.8711-1-jinjian.song@fibocom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_state_monitor.c | 26 ++++++++++++++--------
 drivers/net/wwan/t7xx/t7xx_state_monitor.h |  5 +++--
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
index 3931c7a13f5a..cbdbb91e8381 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
@@ -104,14 +104,21 @@ void t7xx_fsm_broadcast_state(struct t7xx_fsm_ctl *ctl, enum md_state state)
 	fsm_state_notify(ctl->md, state);
 }
 
+static void fsm_release_command(struct kref *ref)
+{
+	struct t7xx_fsm_command *cmd = container_of(ref, typeof(*cmd), refcnt);
+
+	kfree(cmd);
+}
+
 static void fsm_finish_command(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command *cmd, int result)
 {
 	if (cmd->flag & FSM_CMD_FLAG_WAIT_FOR_COMPLETION) {
-		*cmd->ret = result;
-		complete_all(cmd->done);
+		cmd->result = result;
+		complete_all(&cmd->done);
 	}
 
-	kfree(cmd);
+	kref_put(&cmd->refcnt, fsm_release_command);
 }
 
 static void fsm_del_kf_event(struct t7xx_fsm_event *event)
@@ -475,7 +482,6 @@ static int fsm_main_thread(void *data)
 
 int t7xx_fsm_append_cmd(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_cmd_state cmd_id, unsigned int flag)
 {
-	DECLARE_COMPLETION_ONSTACK(done);
 	struct t7xx_fsm_command *cmd;
 	unsigned long flags;
 	int ret;
@@ -487,11 +493,13 @@ int t7xx_fsm_append_cmd(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_cmd_state cmd_id
 	INIT_LIST_HEAD(&cmd->entry);
 	cmd->cmd_id = cmd_id;
 	cmd->flag = flag;
+	kref_init(&cmd->refcnt);
 	if (flag & FSM_CMD_FLAG_WAIT_FOR_COMPLETION) {
-		cmd->done = &done;
-		cmd->ret = &ret;
+		init_completion(&cmd->done);
+		kref_get(&cmd->refcnt);
 	}
 
+	kref_get(&cmd->refcnt);
 	spin_lock_irqsave(&ctl->command_lock, flags);
 	list_add_tail(&cmd->entry, &ctl->command_queue);
 	spin_unlock_irqrestore(&ctl->command_lock, flags);
@@ -501,11 +509,11 @@ int t7xx_fsm_append_cmd(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_cmd_state cmd_id
 	if (flag & FSM_CMD_FLAG_WAIT_FOR_COMPLETION) {
 		unsigned long wait_ret;
 
-		wait_ret = wait_for_completion_timeout(&done,
+		wait_ret = wait_for_completion_timeout(&cmd->done,
 						       msecs_to_jiffies(FSM_CMD_TIMEOUT_MS));
-		if (!wait_ret)
-			return -ETIMEDOUT;
 
+		ret = wait_ret ? cmd->result : -ETIMEDOUT;
+		kref_put(&cmd->refcnt, fsm_release_command);
 		return ret;
 	}
 
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.h b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
index 7b0a9baf488c..6e0601bb752e 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.h
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
@@ -110,8 +110,9 @@ struct t7xx_fsm_command {
 	struct list_head	entry;
 	enum t7xx_fsm_cmd_state	cmd_id;
 	unsigned int		flag;
-	struct completion	*done;
-	int			*ret;
+	struct completion	done;
+	int			result;
+	struct kref		refcnt;
 };
 
 struct t7xx_fsm_notifier {
-- 
2.39.5



