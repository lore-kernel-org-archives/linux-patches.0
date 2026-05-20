Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAA63FB7D2;
	Wed, 20 May 2026 18:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301303; cv=none; b=t2RkstCDYImpLRrCVaYTzvDN7QNEEE0NUH+6R8JaJOmuHVn15UZ77cqpB6NepBMb8ZXoyL/EsMMjX4OJ3qPlLoLDI27yhXVDJS96bekvEGALVTuJvJN1iBzNB5DkfGe/4Gewtb3N8xHaaWwrxQJD1r0+ydfwqEaXTQLHphqAniM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301303; c=relaxed/simple;
	bh=4lUzNai36WJYtjOsU0ZEV8UPbjr7skMeOqO3ISeS0zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGJnrScO7osYDkORP98mwG6xS5cqUVcmoHlOrOgIb9UMxanOsr8kRT51PifEK8zJSg/i5Pt+f/0XZRWAvfyw0Cly7E9M5yHgr3+nwgobi9dYZffaESTpI8HnpqFTnDb/gMfbmHV0ufqO7EJkiCp3Eit/ZP7y112Bx+0Wa4aPJiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XkSPn19; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XkSPn19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF281F000E9;
	Wed, 20 May 2026 18:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301301;
	bh=5d8/WRLLwd0pCtXcKHVfKhKqHv0NCCzDUQ1FujhdUBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1XkSPn194WshtCPINTnxB0brPS1so6MHxk3PZ7NG6oHbF5+NgiZrx6Bv8589VxVRf
	 +FkDh3q48uC7jihQuifl8ahRXvf0jFssAHFiPhzZtkTu6d0gqxwepWV5Qm/AhYSfzT
	 FZq/6eEeT9QFkl8h5Q5wt6PsdoYBJn6wCAgMQq9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason-JH Lin <jason-jh.lin@mediatek.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 503/666] mailbox: mtk-cmdq: Fix CURR and END addr for task insert case
Date: Wed, 20 May 2026 18:21:54 +0200
Message-ID: <20260520162122.163295248@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index 80a10361492b0..f1159dabcd4e9 100644
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



