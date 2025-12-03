Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B44E3612F3;
	Wed,  3 Dec 2025 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780712; cv=none; b=Y7OrEUIOovu5EUT+UEfEAg1vDWLlhVao5KDYZSPSBZTsjpiaOEPa4ND96DWQYHhrRnOBZGtU5SLXLuh387CsuuaNSTublct9aS4/qdYJnml94n5CY7uZN1N9oRB1gjXahU94Dw1O7PzbFqqgevThfyPclQNsHC6RU80mmp3PtGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780712; c=relaxed/simple;
	bh=MdiKa1MEcwOt7AXO2wDl9dqxqj3kEE/CENsYj6lAOuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+gTA+/qTDKUz/EKzJDbxDyGKziAMAsd74FsBMtFdMjw8dAxDoLWncutpHJjMFdaFc5cDrbgcDYbQOpeEYmRmrkQoLhGWRlh3dUjNul8tr4JCNhT6zN8RgS6bHaQ07U3Ygw7pJqQbQOaSk3dDc/iec4Pfm8NMPSNtIFj8dU2h8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftQl69P4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftQl69P4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5984C4CEF5;
	Wed,  3 Dec 2025 16:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780712;
	bh=MdiKa1MEcwOt7AXO2wDl9dqxqj3kEE/CENsYj6lAOuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftQl69P42slmzfUxmV+0tkTBeuuaeg3gEM7dRrv98E5mnfMgyYbO4u2J8PMQh806P
	 tH+EXz6bjuX3r9obdxNmv7HPFJpYorDU37crHJD/nqpDEZMJ5U8vy90UTh+0i3XOpa
	 qjtUb1I5Idw/ForpWDCYYiuAFZAl0Ni++zG8996A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason-JH Lin <jason-jh.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/132] mailbox: mtk-cmdq: Refine DMA address handling for the command buffer
Date: Wed,  3 Dec 2025 16:28:34 +0100
Message-ID: <20251203152344.597854349@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

[ Upstream commit a195c7ccfb7a21b8118139835e25936ec8722596 ]

GCE can only fetch the command buffer address from a 32-bit register.
Some SoCs support a 35-bit command buffer address for GCE, which
requires a right shift of 3 bits before setting the address into
the 32-bit register. A comment has been added to the header of
cmdq_get_shift_pa() to explain this requirement.

To prevent the GCE command buffer address from being DMA mapped beyond
its supported bit range, the DMA bit mask for the device is set during
initialization.

Additionally, to ensure the correct shift is applied when setting or
reading the register that stores the GCE command buffer address,
new APIs, cmdq_convert_gce_addr() and cmdq_revert_gce_addr(), have
been introduced for consistent operations on this register.

The variable type for the command buffer address has been standardized
to dma_addr_t to prevent handling issues caused by type mismatches.

Fixes: 0858fde496f8 ("mailbox: cmdq: variablize address shift in platform")
Signed-off-by: Jason-JH Lin <jason-jh.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c       | 45 ++++++++++++++++--------
 include/linux/mailbox/mtk-cmdq-mailbox.h | 10 ++++++
 2 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index 38ab35157c85f..80a10361492b0 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -92,6 +92,18 @@ struct gce_plat {
 	u32 gce_num;
 };
 
+static inline u32 cmdq_convert_gce_addr(dma_addr_t addr, const struct gce_plat *pdata)
+{
+	/* Convert DMA addr (PA or IOVA) to GCE readable addr */
+	return addr >> pdata->shift;
+}
+
+static inline dma_addr_t cmdq_revert_gce_addr(u32 addr, const struct gce_plat *pdata)
+{
+	/* Revert GCE readable addr to DMA addr (PA or IOVA) */
+	return (dma_addr_t)addr << pdata->shift;
+}
+
 u8 cmdq_get_shift_pa(struct mbox_chan *chan)
 {
 	struct cmdq *cmdq = container_of(chan->mbox, struct cmdq, mbox);
@@ -188,13 +200,12 @@ static void cmdq_task_insert_into_thread(struct cmdq_task *task)
 	struct cmdq_task *prev_task = list_last_entry(
 			&thread->task_busy_list, typeof(*task), list_entry);
 	u64 *prev_task_base = prev_task->pkt->va_base;
+	u32 gce_addr = cmdq_convert_gce_addr(task->pa_base, task->cmdq->pdata);
 
 	/* let previous task jump to this task */
 	dma_sync_single_for_cpu(dev, prev_task->pa_base,
 				prev_task->pkt->cmd_buf_size, DMA_TO_DEVICE);
-	prev_task_base[CMDQ_NUM_CMD(prev_task->pkt) - 1] =
-		(u64)CMDQ_JUMP_BY_PA << 32 |
-		(task->pa_base >> task->cmdq->pdata->shift);
+	prev_task_base[CMDQ_NUM_CMD(prev_task->pkt) - 1] = (u64)CMDQ_JUMP_BY_PA << 32 | gce_addr;
 	dma_sync_single_for_device(dev, prev_task->pa_base,
 				   prev_task->pkt->cmd_buf_size, DMA_TO_DEVICE);
 
@@ -237,7 +248,8 @@ static void cmdq_thread_irq_handler(struct cmdq *cmdq,
 				    struct cmdq_thread *thread)
 {
 	struct cmdq_task *task, *tmp, *curr_task = NULL;
-	u32 curr_pa, irq_flag, task_end_pa;
+	u32 irq_flag, gce_addr;
+	dma_addr_t curr_pa, task_end_pa;
 	bool err;
 
 	irq_flag = readl(thread->base + CMDQ_THR_IRQ_STATUS);
@@ -259,7 +271,8 @@ static void cmdq_thread_irq_handler(struct cmdq *cmdq,
 	else
 		return;
 
-	curr_pa = readl(thread->base + CMDQ_THR_CURR_ADDR) << cmdq->pdata->shift;
+	gce_addr = readl(thread->base + CMDQ_THR_CURR_ADDR);
+	curr_pa = cmdq_revert_gce_addr(gce_addr, cmdq->pdata);
 
 	list_for_each_entry_safe(task, tmp, &thread->task_busy_list,
 				 list_entry) {
@@ -378,7 +391,8 @@ static int cmdq_mbox_send_data(struct mbox_chan *chan, void *data)
 	struct cmdq_thread *thread = (struct cmdq_thread *)chan->con_priv;
 	struct cmdq *cmdq = dev_get_drvdata(chan->mbox->dev);
 	struct cmdq_task *task;
-	unsigned long curr_pa, end_pa;
+	u32 gce_addr;
+	dma_addr_t curr_pa, end_pa;
 
 	/* Client should not flush new tasks if suspended. */
 	WARN_ON(cmdq->suspended);
@@ -402,20 +416,20 @@ static int cmdq_mbox_send_data(struct mbox_chan *chan, void *data)
 		 */
 		WARN_ON(cmdq_thread_reset(cmdq, thread) < 0);
 
-		writel(task->pa_base >> cmdq->pdata->shift,
-		       thread->base + CMDQ_THR_CURR_ADDR);
-		writel((task->pa_base + pkt->cmd_buf_size) >> cmdq->pdata->shift,
-		       thread->base + CMDQ_THR_END_ADDR);
+		gce_addr = cmdq_convert_gce_addr(task->pa_base, cmdq->pdata);
+		writel(gce_addr, thread->base + CMDQ_THR_CURR_ADDR);
+		gce_addr = cmdq_convert_gce_addr(task->pa_base + pkt->cmd_buf_size, cmdq->pdata);
+		writel(gce_addr, thread->base + CMDQ_THR_END_ADDR);
 
 		writel(thread->priority, thread->base + CMDQ_THR_PRIORITY);
 		writel(CMDQ_THR_IRQ_EN, thread->base + CMDQ_THR_IRQ_ENABLE);
 		writel(CMDQ_THR_ENABLED, thread->base + CMDQ_THR_ENABLE_TASK);
 	} else {
 		WARN_ON(cmdq_thread_suspend(cmdq, thread) < 0);
-		curr_pa = readl(thread->base + CMDQ_THR_CURR_ADDR) <<
-			cmdq->pdata->shift;
-		end_pa = readl(thread->base + CMDQ_THR_END_ADDR) <<
-			cmdq->pdata->shift;
+		gce_addr = readl(thread->base + CMDQ_THR_CURR_ADDR);
+		curr_pa = cmdq_revert_gce_addr(gce_addr, cmdq->pdata);
+		gce_addr = readl(thread->base + CMDQ_THR_END_ADDR);
+		end_pa = cmdq_revert_gce_addr(gce_addr, cmdq->pdata);
 		/* check boundary */
 		if (curr_pa == end_pa - CMDQ_INST_SIZE ||
 		    curr_pa == end_pa) {
@@ -646,6 +660,9 @@ static int cmdq_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	dma_set_coherent_mask(dev,
+			      DMA_BIT_MASK(sizeof(u32) * BITS_PER_BYTE + cmdq->pdata->shift));
+
 	cmdq->mbox.dev = dev;
 	cmdq->mbox.chans = devm_kcalloc(dev, cmdq->pdata->thread_nr,
 					sizeof(*cmdq->mbox.chans), GFP_KERNEL);
diff --git a/include/linux/mailbox/mtk-cmdq-mailbox.h b/include/linux/mailbox/mtk-cmdq-mailbox.h
index a8f0070c7aa98..9914dcd33e2d9 100644
--- a/include/linux/mailbox/mtk-cmdq-mailbox.h
+++ b/include/linux/mailbox/mtk-cmdq-mailbox.h
@@ -78,6 +78,16 @@ struct cmdq_pkt {
 	void			*cl;
 };
 
+/**
+ * cmdq_get_shift_pa() - get the shift bits of physical address
+ * @chan: mailbox channel
+ *
+ * GCE can only fetch the command buffer address from a 32-bit register.
+ * Some SOCs support more than 32-bit command buffer address for GCE, which
+ * requires some shift bits to make the address fit into the 32-bit register.
+ *
+ * Return: the shift bits of physical address
+ */
 u8 cmdq_get_shift_pa(struct mbox_chan *chan);
 
 #endif /* __MTK_CMDQ_MAILBOX_H__ */
-- 
2.51.0



