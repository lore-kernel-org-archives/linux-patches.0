Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458A63F20FA;
	Wed, 20 May 2026 17:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299333; cv=none; b=JQeQpwQkg72s6v2x+7naZcact4WWnouYCpyA4Z7CaCpakEgL0Ac3l/YcmakMWijlMU472h/atasTqSpBrwtZzKPkDMKVtO0g4YDgpdVmQObQyy6MOZMExvwbFvqnDkj9J/rppjEb/Z638YOjqK/nv5DHlOctwgKPnp3YWJK7YUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299333; c=relaxed/simple;
	bh=/uVcYS2EpD2Ih7kACWk3NsJTxsTWGpLg9Mgw/zzIYuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZPfciOwkXIlB0xdNaPq3s7HOB/zTQ7rop+PI9OA5tqdnK6IlaRRPawftllIXczB+AjYNQ0KowI8R3rRlUNCzgzQdrLbBA69kHGbiMG+DqoYRfogftKGBdCf9yUIYb2ZImezhn4MOSAa3QdjbOWH91JXdjEiiXi4iC5DDWiEmR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yC6gsS/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yC6gsS/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A881F000E9;
	Wed, 20 May 2026 17:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299332;
	bh=bz1I+4Tpip2BqS99p7nn7VmFa86ecsspVL9hqwWH8bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yC6gsS/qTk/0KZ1pYd4ZbHkR29ZjQgMXslyz9AMaovvTul1yGEwSNCJz5L1xEE5bU
	 /KFBuS+8o0pSvDit8+Fwl1c8QY03/wPpRIkaFtN/uMjwERuDI/AWZ4//Kjc+PFe+AV
	 U4h2jj6cOlAR7RTb5SzxVc7CA8LfENWOGn2e7c2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason-JH Lin <jason-jh.lin@mediatek.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 732/957] mailbox: mtk-cmdq: Fix CURR and END addr for task insert case
Date: Wed, 20 May 2026 18:20:15 +0200
Message-ID: <20260520162150.431328227@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason-JH Lin <jason-jh.lin@mediatek.com>

[ Upstream commit d2591db9c8ef19fbb4d24ed15e0c6edfa6bc7917 ]

Fix CURR and END address calculation for inserting a cmdq task into the
task list by using cmdq_reg_shift_addr() for proper address converting.
This ensures both CURR and END addresses are set correctly when
enabling the thread.

Fixes: a195c7ccfb7a ("mailbox: mtk-cmdq: Refine DMA address handling for the command buffer")
Signed-off-by: Jason-JH Lin <jason-jh.lin@mediatek.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index 5791f80f995ab..a1360b70b83fb 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -434,14 +434,14 @@ static int cmdq_mbox_send_data(struct mbox_chan *chan, void *data)
 		if (curr_pa == end_pa - CMDQ_INST_SIZE ||
 		    curr_pa == end_pa) {
 			/* set to this task directly */
-			writel(task->pa_base >> cmdq->pdata->shift,
-			       thread->base + CMDQ_THR_CURR_ADDR);
+			gce_addr = cmdq_convert_gce_addr(task->pa_base, cmdq->pdata);
+			writel(gce_addr, thread->base + CMDQ_THR_CURR_ADDR);
 		} else {
 			cmdq_task_insert_into_thread(task);
 			smp_mb(); /* modify jump before enable thread */
 		}
-		writel((task->pa_base + pkt->cmd_buf_size) >> cmdq->pdata->shift,
-		       thread->base + CMDQ_THR_END_ADDR);
+		gce_addr = cmdq_convert_gce_addr(task->pa_base + pkt->cmd_buf_size, cmdq->pdata);
+		writel(gce_addr, thread->base + CMDQ_THR_END_ADDR);
 		cmdq_thread_resume(thread);
 	}
 	list_move_tail(&task->list_entry, &thread->task_busy_list);
-- 
2.53.0



