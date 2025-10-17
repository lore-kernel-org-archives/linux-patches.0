Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FE43370F7;
	Fri, 17 Oct 2025 15:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714313; cv=none; b=gO2jyiUqCumiXhQdb2u8/xufcQHZgefAp6+xHAhA0k+uiFcN4e/72kOgN33wDRYaRxk2ZeeI+MMqd7zI+fOAQEId91dDzCZ5mg75+KGixAujX68uJBGjhS777bzZlN0kkXUfd4PnJBl2UM3p4ETk0X/w1J02YDCtYZZpAeK0/1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714313; c=relaxed/simple;
	bh=QGhSPo5hOuxC+bojMT8/VhoIP2zeC4W7qb27xEZXBxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qh/iQUG9iYnoZhQezYDNH4SVVaxGDkb5itfvnzU/QKrS82nC4cRjbTFOOx0yNQwYURZv/iXbe+2Xh5UMY97TenmC4+jMmybVBP/5gQlVy1zgXG9FYD5Q6lN+t1ColAyuFlV8CSwC80MHa2CajMqCU4apszDyct7eH+WOJn8TLpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txKN3DIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txKN3DIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F12DC4CEE7;
	Fri, 17 Oct 2025 15:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714313;
	bh=QGhSPo5hOuxC+bojMT8/VhoIP2zeC4W7qb27xEZXBxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txKN3DIrwhAdgurmJp2mNpK9hqp2mHo2FjlMoCHL/cTYT5Pc56R4qtlAM1Dswluxx
	 +W2IDOoGjmTUqA224p96tlDm0prRK+xKDeinOE1qWOIFtT4Gq82r+rBbWd8q9kpCaB
	 XSCFSLhCmx2NtNBCMvGKqPZBriWQ5bNZ/KX6hDbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason-JH Lin <jason-jh.lin@mediatek.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/277] mailbox: mtk-cmdq: Remove pm_runtime APIs from cmdq_mbox_send_data()
Date: Fri, 17 Oct 2025 16:51:15 +0200
Message-ID: <20251017145149.626363180@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jason-JH Lin <jason-jh.lin@mediatek.com>

[ Upstream commit 3f39f56520374cf56872644acf9afcc618a4b674 ]

pm_runtime_get_sync() and pm_runtime_put_autosuspend() were previously
called in cmdq_mbox_send_data(), which is under a spinlock in msg_submit()
(mailbox.c). This caused lockdep warnings such as "sleeping function
called from invalid context" when running with lockdebug enabled.

The BUG report:
  BUG: sleeping function called from invalid context at drivers/base/power/runtime.c:1164
  in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 3616, name: kworker/u17:3
    preempt_count: 1, expected: 0
    RCU nest depth: 0, expected: 0
    INFO: lockdep is turned off.
    irq event stamp: 0
    CPU: 1 PID: 3616 Comm: kworker/u17:3 Not tainted 6.1.87-lockdep-14133-g26e933aca785 #1
    Hardware name: Google Ciri sku0/unprovisioned board (DT)
    Workqueue: imgsys_runner imgsys_runner_func
    Call trace:
     dump_backtrace+0x100/0x120
     show_stack+0x20/0x2c
     dump_stack_lvl+0x84/0xb4
     dump_stack+0x18/0x48
     __might_resched+0x354/0x4c0
     __might_sleep+0x98/0xe4
     __pm_runtime_resume+0x70/0x124
     cmdq_mbox_send_data+0xe4/0xb1c
     msg_submit+0x194/0x2dc
     mbox_send_message+0x190/0x330
     imgsys_cmdq_sendtask+0x1618/0x2224
     imgsys_runner_func+0xac/0x11c
     process_one_work+0x638/0xf84
     worker_thread+0x808/0xcd0
     kthread+0x24c/0x324
     ret_from_fork+0x10/0x20

Additionally, pm_runtime_put_autosuspend() should be invoked from the
GCE IRQ handler to ensure the hardware has actually completed its work.

To resolve these issues, remove the pm_runtime calls from
cmdq_mbox_send_data() and delegate power management responsibilities
to the client driver.

Fixes: 8afe816b0c99 ("mailbox: mtk-cmdq-mailbox: Implement Runtime PM with autosuspend")
Signed-off-by: Jason-JH Lin <jason-jh.lin@mediatek.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index d24f71819c3d6..38ab35157c85f 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -379,20 +379,13 @@ static int cmdq_mbox_send_data(struct mbox_chan *chan, void *data)
 	struct cmdq *cmdq = dev_get_drvdata(chan->mbox->dev);
 	struct cmdq_task *task;
 	unsigned long curr_pa, end_pa;
-	int ret;
 
 	/* Client should not flush new tasks if suspended. */
 	WARN_ON(cmdq->suspended);
 
-	ret = pm_runtime_get_sync(cmdq->mbox.dev);
-	if (ret < 0)
-		return ret;
-
 	task = kzalloc(sizeof(*task), GFP_ATOMIC);
-	if (!task) {
-		pm_runtime_put_autosuspend(cmdq->mbox.dev);
+	if (!task)
 		return -ENOMEM;
-	}
 
 	task->cmdq = cmdq;
 	INIT_LIST_HEAD(&task->list_entry);
@@ -439,9 +432,6 @@ static int cmdq_mbox_send_data(struct mbox_chan *chan, void *data)
 	}
 	list_move_tail(&task->list_entry, &thread->task_busy_list);
 
-	pm_runtime_mark_last_busy(cmdq->mbox.dev);
-	pm_runtime_put_autosuspend(cmdq->mbox.dev);
-
 	return 0;
 }
 
-- 
2.51.0



