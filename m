Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF992FA621;
	Tue, 17 Jun 2025 16:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178475; cv=none; b=mh/dvC+5hidnJd5qfuWU4W42EO3q2GFvdOr+Vl/fDi7A7UlcBOEvPfvzOm9maG3u3kHJMn3/Oc7ZSH6ZoOPtU80FChS4G79OUzCiLzSmFpPtBZA4WrtjzcVP691LKHCPM/v/vVbEuWJi18dOATHS9AVlhoDDSx6DfRYwWWTRX2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178475; c=relaxed/simple;
	bh=w5HdXiLLYzQX56g0eD6i3Y8KKhlk36X/aGU3JPUiT1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtxTpXBmQdtu18X3qB5VSFOJzTynKVp7ehXH0aMxwS1CvDlexsni/pf48G1y7n96LrunuF5/YBx1NfbCAY5qbzypc3LSUwu+3/DzwALuf9GZQr/7y3HchIlL4QxltV4decr7ALte9/wZefkcIIsGSt+3JfrIxvm/XsggyMj5Zsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1ZmuT+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1ZmuT+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9B5C4CEE3;
	Tue, 17 Jun 2025 16:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178474;
	bh=w5HdXiLLYzQX56g0eD6i3Y8KKhlk36X/aGU3JPUiT1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1ZmuT+mEpj78A55QRxIoxHDDZFjGn3lOP52aYl7R5gAgE0JfQy272ayPKZ9k4XzP
	 PHMZB1l6PPo/eIUXou0vKn7fGYU7VFKjM36zQYLR0Kbno9diZzd3BHN2YUGirQeYpC
	 JrQFVHhqxojt9uFCNiz+07jC4l1DRNxFGaInF5kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason-JH Lin <jason-jh.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 465/780] mailbox: mtk-cmdq: Refine GCE_GCTL_VALUE setting
Date: Tue, 17 Jun 2025 17:22:53 +0200
Message-ID: <20250617152510.428420255@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason-JH Lin <jason-jh.lin@mediatek.com>

[ Upstream commit 9fcebcb37c3e0a4b6eb40768cc5a5faebf166fbe ]

Add cmdq_gctl_value_toggle() to configure GCE_CTRL_BY_SW and GCE_DDR_EN
together in the same GCE_GCTL_VALUE register.

For the SoCs whose GCE is located in MMINFRA and uses MMINFRA_AO power,
this allows it to be written without enabling the clocks. Otherwise, all
GCE registers should be written after the GCE clocks are enabled.
Move this function into cmdq_runtime_resume() and cmdq_runtime_suspend()
to ensure it is called when the GCE clock is enabled.

Fixes: 7abd037aa581 ("mailbox: mtk-cmdq: add gce ddr enable support flow")
Signed-off-by: Jason-JH Lin <jason-jh.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 51 +++++++++++++-----------------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index d186865b8dce6..ab4e8d1954a16 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -92,18 +92,6 @@ struct gce_plat {
 	u32 gce_num;
 };
 
-static void cmdq_sw_ddr_enable(struct cmdq *cmdq, bool enable)
-{
-	WARN_ON(clk_bulk_enable(cmdq->pdata->gce_num, cmdq->clocks));
-
-	if (enable)
-		writel(GCE_DDR_EN | GCE_CTRL_BY_SW, cmdq->base + GCE_GCTL_VALUE);
-	else
-		writel(GCE_CTRL_BY_SW, cmdq->base + GCE_GCTL_VALUE);
-
-	clk_bulk_disable(cmdq->pdata->gce_num, cmdq->clocks);
-}
-
 u8 cmdq_get_shift_pa(struct mbox_chan *chan)
 {
 	struct cmdq *cmdq = container_of(chan->mbox, struct cmdq, mbox);
@@ -112,6 +100,19 @@ u8 cmdq_get_shift_pa(struct mbox_chan *chan)
 }
 EXPORT_SYMBOL(cmdq_get_shift_pa);
 
+static void cmdq_gctl_value_toggle(struct cmdq *cmdq, bool ddr_enable)
+{
+	u32 val = cmdq->pdata->control_by_sw ? GCE_CTRL_BY_SW : 0;
+
+	if (!cmdq->pdata->control_by_sw && !cmdq->pdata->sw_ddr_en)
+		return;
+
+	if (cmdq->pdata->sw_ddr_en && ddr_enable)
+		val |= GCE_DDR_EN;
+
+	writel(val, cmdq->base + GCE_GCTL_VALUE);
+}
+
 static int cmdq_thread_suspend(struct cmdq *cmdq, struct cmdq_thread *thread)
 {
 	u32 status;
@@ -140,16 +141,10 @@ static void cmdq_thread_resume(struct cmdq_thread *thread)
 static void cmdq_init(struct cmdq *cmdq)
 {
 	int i;
-	u32 gctl_regval = 0;
 
 	WARN_ON(clk_bulk_enable(cmdq->pdata->gce_num, cmdq->clocks));
-	if (cmdq->pdata->control_by_sw)
-		gctl_regval = GCE_CTRL_BY_SW;
-	if (cmdq->pdata->sw_ddr_en)
-		gctl_regval |= GCE_DDR_EN;
 
-	if (gctl_regval)
-		writel(gctl_regval, cmdq->base + GCE_GCTL_VALUE);
+	cmdq_gctl_value_toggle(cmdq, true);
 
 	writel(CMDQ_THR_ACTIVE_SLOT_CYCLES, cmdq->base + CMDQ_THR_SLOT_CYCLES);
 	for (i = 0; i <= CMDQ_MAX_EVENT; i++)
@@ -315,14 +310,21 @@ static irqreturn_t cmdq_irq_handler(int irq, void *dev)
 static int cmdq_runtime_resume(struct device *dev)
 {
 	struct cmdq *cmdq = dev_get_drvdata(dev);
+	int ret;
 
-	return clk_bulk_enable(cmdq->pdata->gce_num, cmdq->clocks);
+	ret = clk_bulk_enable(cmdq->pdata->gce_num, cmdq->clocks);
+	if (ret)
+		return ret;
+
+	cmdq_gctl_value_toggle(cmdq, true);
+	return 0;
 }
 
 static int cmdq_runtime_suspend(struct device *dev)
 {
 	struct cmdq *cmdq = dev_get_drvdata(dev);
 
+	cmdq_gctl_value_toggle(cmdq, false);
 	clk_bulk_disable(cmdq->pdata->gce_num, cmdq->clocks);
 	return 0;
 }
@@ -347,9 +349,6 @@ static int cmdq_suspend(struct device *dev)
 	if (task_running)
 		dev_warn(dev, "exist running task(s) in suspend\n");
 
-	if (cmdq->pdata->sw_ddr_en)
-		cmdq_sw_ddr_enable(cmdq, false);
-
 	return pm_runtime_force_suspend(dev);
 }
 
@@ -360,9 +359,6 @@ static int cmdq_resume(struct device *dev)
 	WARN_ON(pm_runtime_force_resume(dev));
 	cmdq->suspended = false;
 
-	if (cmdq->pdata->sw_ddr_en)
-		cmdq_sw_ddr_enable(cmdq, true);
-
 	return 0;
 }
 
@@ -370,9 +366,6 @@ static void cmdq_remove(struct platform_device *pdev)
 {
 	struct cmdq *cmdq = platform_get_drvdata(pdev);
 
-	if (cmdq->pdata->sw_ddr_en)
-		cmdq_sw_ddr_enable(cmdq, false);
-
 	if (!IS_ENABLED(CONFIG_PM))
 		cmdq_runtime_suspend(&pdev->dev);
 
-- 
2.39.5



