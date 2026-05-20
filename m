Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E13836F901;
	Wed, 20 May 2026 17:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296644; cv=none; b=tSYyKEYB0JauSnvOE45e3VyytopTgzdl8UBl3Juq7DwS15dbWZhGb6zlt2S7AGi/umP/jnWgcnFU0zsjgJOs8FOec+/jO3XCpv9tGnc9LsETZQ/tTKoh4V8cie/la2tNcCCKVP2MSgl3/WimY5DgRBZ1AZpbh8zD7BTcdazubWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296644; c=relaxed/simple;
	bh=lTy69olK/+VwOWe2cl+mBjuKbDyqSncYUW9IzAntmSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5j1WPI/v+rhn5R8OGio2JKlOBjQEbNw1AjqasiKBrScyz5vr65h5xHWDfvls3svly6B9rpqkm03yxXxuh+56nVr2SA66KHvcR4p8ayAzAWs52yJVhD8FK/MSqFz70jHPUk5ZWrBFmfZqFY+uH/gWjh8b3XodNCW9k+Esoc7+ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZLBZBrK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZLBZBrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4101F000E9;
	Wed, 20 May 2026 17:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296643;
	bh=ezZ/JCvbDT+pJhBl7Hn+3uQ2BbzryO63/yVGWUtA8DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZLBZBrKzlL1mXTdzftc3yDrHGivgT9yaGKXZkNmm/L48gGgkypEnMWcLTERXkzkD
	 iKsIlRYVxtJBJMxw6Vfyq09yr6yIfIvTYQJnemvc2BCf8Ubta5owJJG33lua9Eja21
	 J/UHcLetImcT5p1CeF2+sGTw9pXLkKIPHzZd8qGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason-JH Lin <jason-jh.lin@mediatek.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0878/1146] mailbox: mtk-cmdq: Fix CURR and END addr for task insert case
Date: Wed, 20 May 2026 18:18:48 +0200
Message-ID: <20260520162208.108417335@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index d7c6b38888a37..547a10a8fad3a 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -493,14 +493,14 @@ static int cmdq_mbox_send_data(struct mbox_chan *chan, void *data)
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



