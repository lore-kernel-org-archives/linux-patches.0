Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C7C3D3CE5;
	Wed, 30 Sep 2026 19:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795795; cv=none; b=hebEvaYUCZq7X3xNqrYzE6UiY3MqZ1HzIESyD33mEQSTn85zcbJMdGN1q9gc3rWa50UF0rRpNtykE013Tu3nK02+OGLrf1/R653PXNDha0r6S20Z+ZXlMmEbixsk5ks/XbdGB5/swFm6k9BcAJ9JCFEXUwifXr0pa//tYZcuP4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795795; c=relaxed/simple;
	bh=VDjRbqx1dfNHZWhXProNaSlho0dUT5hZEFkqDmnyVAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5uaKzJ8B+IEhaZ4B/ywCDqOAeDV4WpByzFSGhKnp7/wsajd4/c0IMlBy/j6yJjPsPad35T81drV7ytdZuGxF9VXP0G1ijP2Ee5hV5xW5TDeTtxWOHimSACCAl+XH2xRzHGY9R/A9wmdGCqGSXuAXKBbQcHa1oq/zH/SdGCOow4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVdH7GRp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVdH7GRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE2F1F000FF;
	Wed, 30 Sep 2026 19:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795793;
	bh=vt++iBG/J9W6uTdaI8vfyLb/15keLIZw52QqwY4TFbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVdH7GRphTWNOtyVPIRutdFUdEX5W6XGVMiVFtOHrSrEGM4hbPd/TNlMS3a5hqbh2
	 yCKxrec32juJuB1X4Xc0JN3CUdkFsxOYUxudIWUCtDYrroqUVF9ro/CyiYvNwey8EL
	 TFPzAdMBeZBjpa49kZu6YTqY6gXTHZacqyTl90h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0686/1193] Revert "nvme: apple: Add Apple A11 support"
Date: Wed, 30 Sep 2026 17:22:50 +0200
Message-ID: <20260930152449.490819230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 7256eed48ce7d78ab9689d84135b77a15454de55.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 197 ++++++++++++--------------------------
 1 file changed, 60 insertions(+), 137 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 90d85a1bf3679..68b4c3ea6c4b2 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -35,6 +35,7 @@
 #include "nvme.h"
 
 #define APPLE_ANS_BOOT_TIMEOUT	  USEC_PER_SEC
+#define APPLE_ANS_MAX_QUEUE_DEPTH 64
 
 #define APPLE_ANS_COPROC_CPU_CONTROL	 0x44
 #define APPLE_ANS_COPROC_CPU_CONTROL_RUN BIT(4)
@@ -74,8 +75,6 @@
 #define APPLE_NVME_AQ_DEPTH	   2
 #define APPLE_NVME_AQ_MQ_TAG_DEPTH (APPLE_NVME_AQ_DEPTH - 1)
 
-#define APPLE_NVME_IOSQES	7
-
 /*
  * These can be higher, but we need to ensure that any command doesn't
  * require an sg allocation that needs more than a page of data.
@@ -143,7 +142,6 @@ struct apple_nvme_queue {
 	u32 __iomem *sq_db;
 	u32 __iomem *cq_db;
 
-	u16 sq_tail;
 	u16 cq_head;
 	u8 cq_phase;
 
@@ -185,17 +183,11 @@ struct apple_nvme_iod {
 	struct scatterlist *sg;
 };
 
-struct apple_nvme_hw {
-	bool has_lsq_nvmmu;
-	u32 max_queue_depth;
-};
-
 struct apple_nvme {
 	struct device *dev;
 
 	void __iomem *mmio_coproc;
 	void __iomem *mmio_nvme;
-	const struct apple_nvme_hw *hw;
 
 	struct device **pd_dev;
 	struct device_link **pd_link;
@@ -240,12 +232,10 @@ static inline struct apple_nvme *queue_to_apple_nvme(struct apple_nvme_queue *q)
 
 static unsigned int apple_nvme_queue_depth(struct apple_nvme_queue *q)
 {
-	struct apple_nvme *anv = queue_to_apple_nvme(q);
-
-	if (q->is_adminq && anv->hw->has_lsq_nvmmu)
+	if (q->is_adminq)
 		return APPLE_NVME_AQ_DEPTH;
 
-	return anv->hw->max_queue_depth;
+	return APPLE_ANS_MAX_QUEUE_DEPTH;
 }
 
 static void apple_nvme_rtkit_crashed(void *cookie)
@@ -307,28 +297,7 @@ static void apple_nvmmu_inval(struct apple_nvme_queue *q, unsigned int tag)
 				     "NVMMU TCB invalidation failed\n");
 }
 
-static void apple_nvme_submit_cmd_t8015(struct apple_nvme_queue *q,
-				  struct nvme_command *cmd)
-{
-	struct apple_nvme *anv = queue_to_apple_nvme(q);
-
-	spin_lock_irq(&anv->lock);
-
-	if (q->is_adminq)
-		memcpy(&q->sqes[q->sq_tail], cmd, sizeof(*cmd));
-	else
-		memcpy((void *)q->sqes + (q->sq_tail << APPLE_NVME_IOSQES),
-			cmd, sizeof(*cmd));
-
-	if (++q->sq_tail == anv->hw->max_queue_depth)
-		q->sq_tail = 0;
-
-	writel(q->sq_tail, q->sq_db);
-	spin_unlock_irq(&anv->lock);
-}
-
-
-static void apple_nvme_submit_cmd_t8103(struct apple_nvme_queue *q,
+static void apple_nvme_submit_cmd(struct apple_nvme_queue *q,
 				  struct nvme_command *cmd)
 {
 	struct apple_nvme *anv = queue_to_apple_nvme(q);
@@ -640,8 +609,7 @@ static inline void apple_nvme_handle_cqe(struct apple_nvme_queue *q,
 	__u16 command_id = READ_ONCE(cqe->command_id);
 	struct request *req;
 
-	if (anv->hw->has_lsq_nvmmu)
-		apple_nvmmu_inval(q, command_id);
+	apple_nvmmu_inval(q, command_id);
 
 	req = nvme_find_rq(apple_nvme_queue_tagset(anv, q), command_id);
 	if (unlikely(!req)) {
@@ -735,7 +703,7 @@ static int apple_nvme_create_cq(struct apple_nvme *anv)
 	c.create_cq.opcode = nvme_admin_create_cq;
 	c.create_cq.prp1 = cpu_to_le64(anv->ioq.cq_dma_addr);
 	c.create_cq.cqid = cpu_to_le16(1);
-	c.create_cq.qsize = cpu_to_le16(anv->hw->max_queue_depth - 1);
+	c.create_cq.qsize = cpu_to_le16(APPLE_ANS_MAX_QUEUE_DEPTH - 1);
 	c.create_cq.cq_flags = cpu_to_le16(NVME_QUEUE_PHYS_CONTIG | NVME_CQ_IRQ_ENABLED);
 	c.create_cq.irq_vector = cpu_to_le16(0);
 
@@ -763,7 +731,7 @@ static int apple_nvme_create_sq(struct apple_nvme *anv)
 	c.create_sq.opcode = nvme_admin_create_sq;
 	c.create_sq.prp1 = cpu_to_le64(anv->ioq.sq_dma_addr);
 	c.create_sq.sqid = cpu_to_le16(1);
-	c.create_sq.qsize = cpu_to_le16(anv->hw->max_queue_depth - 1);
+	c.create_sq.qsize = cpu_to_le16(APPLE_ANS_MAX_QUEUE_DEPTH - 1);
 	c.create_sq.sq_flags = cpu_to_le16(NVME_QUEUE_PHYS_CONTIG);
 	c.create_sq.cqid = cpu_to_le16(1);
 
@@ -815,12 +783,7 @@ static blk_status_t apple_nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	}
 
 	nvme_start_request(req);
-
-	if (anv->hw->has_lsq_nvmmu)
-		apple_nvme_submit_cmd_t8103(q, cmnd);
-	else
-		apple_nvme_submit_cmd_t8015(q, cmnd);
-
+	apple_nvme_submit_cmd(q, cmnd);
 	return BLK_STS_OK;
 
 out_free_cmd:
@@ -1024,13 +987,11 @@ static const struct blk_mq_ops apple_nvme_mq_ops = {
 static void apple_nvme_init_queue(struct apple_nvme_queue *q)
 {
 	unsigned int depth = apple_nvme_queue_depth(q);
-	struct apple_nvme *anv = queue_to_apple_nvme(q);
 
 	q->cq_head = 0;
 	q->cq_phase = 1;
-	if (anv->hw->has_lsq_nvmmu)
-		memset(q->tcbs, 0, anv->hw->max_queue_depth
-			* sizeof(struct apple_nvmmu_tcb));
+	memset(q->tcbs, 0,
+	       APPLE_ANS_MAX_QUEUE_DEPTH * sizeof(struct apple_nvmmu_tcb));
 	memset(q->cqes, 0, depth * sizeof(struct nvme_completion));
 	apple_nvme_enable_queue(q);
 }
@@ -1112,55 +1073,49 @@ static void apple_nvme_reset_work(struct work_struct *work)
 
 	dma_set_max_seg_size(anv->dev, 0xffffffff);
 
-	if (anv->hw->has_lsq_nvmmu) {
-		/*
-		 * Enable NVMMU and linear submission queues which is required
-		 * since T6000.
-		 */
-		writel(APPLE_ANS_LINEAR_SQ_EN,
-			anv->mmio_nvme + APPLE_ANS_LINEAR_SQ_CTRL);
+	/*
+	 * Enable NVMMU and linear submission queues.
+	 * While we could keep those disabled and pretend this is slightly
+	 * more common NVMe controller we'd still need some quirks (e.g.
+	 * sq entries will be 128 bytes) and Apple might drop support for
+	 * that mode in the future.
+	 */
+	writel(APPLE_ANS_LINEAR_SQ_EN,
+	       anv->mmio_nvme + APPLE_ANS_LINEAR_SQ_CTRL);
 
-		/* Allow as many pending command as possible for both queues */
-		writel(anv->hw->max_queue_depth
-			| (anv->hw->max_queue_depth << 16), anv->mmio_nvme
-			+ APPLE_ANS_MAX_PEND_CMDS_CTRL);
+	/* Allow as many pending command as possible for both queues */
+	writel(APPLE_ANS_MAX_QUEUE_DEPTH | (APPLE_ANS_MAX_QUEUE_DEPTH << 16),
+	       anv->mmio_nvme + APPLE_ANS_MAX_PEND_CMDS_CTRL);
 
-		/* Setup the NVMMU for the maximum admin and IO queue depth */
-		writel(anv->hw->max_queue_depth - 1,
-			anv->mmio_nvme + APPLE_NVMMU_NUM_TCBS);
+	/* Setup the NVMMU for the maximum admin and IO queue depth */
+	writel(APPLE_ANS_MAX_QUEUE_DEPTH - 1,
+	       anv->mmio_nvme + APPLE_NVMMU_NUM_TCBS);
 
-		/*
-		 * This is probably a chicken bit: without it all commands
-		 * where any PRP is set to zero (including those that don't use
-		 * that field) fail and the co-processor complains about
-		 * "completed with err BAD_CMD-" or a "NULL_PRP_PTR_ERR" in the
-		 * syslog
-		 */
-		writel(readl(anv->mmio_nvme + APPLE_ANS_UNKNOWN_CTRL) &
-			~APPLE_ANS_PRP_NULL_CHECK,
-			anv->mmio_nvme + APPLE_ANS_UNKNOWN_CTRL);
-	}
+	/*
+	 * This is probably a chicken bit: without it all commands where any PRP
+	 * is set to zero (including those that don't use that field) fail and
+	 * the co-processor complains about "completed with err BAD_CMD-" or
+	 * a "NULL_PRP_PTR_ERR" in the syslog
+	 */
+	writel(readl(anv->mmio_nvme + APPLE_ANS_UNKNOWN_CTRL) &
+		       ~APPLE_ANS_PRP_NULL_CHECK,
+	       anv->mmio_nvme + APPLE_ANS_UNKNOWN_CTRL);
 
 	/* Setup the admin queue */
-	if (anv->hw->has_lsq_nvmmu)
-		aqa = APPLE_NVME_AQ_DEPTH - 1;
-	else
-		aqa = anv->hw->max_queue_depth - 1;
+	aqa = APPLE_NVME_AQ_DEPTH - 1;
 	aqa |= aqa << 16;
 	writel(aqa, anv->mmio_nvme + NVME_REG_AQA);
 	writeq(anv->adminq.sq_dma_addr, anv->mmio_nvme + NVME_REG_ASQ);
 	writeq(anv->adminq.cq_dma_addr, anv->mmio_nvme + NVME_REG_ACQ);
 
-	if (anv->hw->has_lsq_nvmmu) {
-		/* Setup NVMMU for both queues */
-		writeq(anv->adminq.tcb_dma_addr,
-			anv->mmio_nvme + APPLE_NVMMU_ASQ_TCB_BASE);
-		writeq(anv->ioq.tcb_dma_addr,
-			anv->mmio_nvme + APPLE_NVMMU_IOSQ_TCB_BASE);
-	}
+	/* Setup NVMMU for both queues */
+	writeq(anv->adminq.tcb_dma_addr,
+	       anv->mmio_nvme + APPLE_NVMMU_ASQ_TCB_BASE);
+	writeq(anv->ioq.tcb_dma_addr,
+	       anv->mmio_nvme + APPLE_NVMMU_IOSQ_TCB_BASE);
 
 	anv->ctrl.sqsize =
-		anv->hw->max_queue_depth - 1; /* 0's based queue depth */
+		APPLE_ANS_MAX_QUEUE_DEPTH - 1; /* 0's based queue depth */
 	anv->ctrl.cap = readq(anv->mmio_nvme + NVME_REG_CAP);
 
 	dev_dbg(anv->dev, "Enabling controller now");
@@ -1328,9 +1283,8 @@ static int apple_nvme_alloc_tagsets(struct apple_nvme *anv)
 	 * both queues. The admin queue gets the first APPLE_NVME_AQ_DEPTH which
 	 * must be marked as reserved in the IO queue.
 	 */
-	if (anv->hw->has_lsq_nvmmu)
-		anv->tagset.reserved_tags = APPLE_NVME_AQ_DEPTH;
-	anv->tagset.queue_depth = anv->hw->max_queue_depth - 1;
+	anv->tagset.reserved_tags = APPLE_NVME_AQ_DEPTH;
+	anv->tagset.queue_depth = APPLE_ANS_MAX_QUEUE_DEPTH - 1;
 	anv->tagset.timeout = NVME_IO_TIMEOUT;
 	anv->tagset.numa_node = NUMA_NO_NODE;
 	anv->tagset.cmd_size = sizeof(struct apple_nvme_iod);
@@ -1355,7 +1309,6 @@ static int apple_nvme_queue_alloc(struct apple_nvme *anv,
 				  struct apple_nvme_queue *q)
 {
 	unsigned int depth = apple_nvme_queue_depth(q);
-	size_t iosq_size;
 
 	q->cqes = dmam_alloc_coherent(anv->dev,
 				      depth * sizeof(struct nvme_completion),
@@ -1363,28 +1316,22 @@ static int apple_nvme_queue_alloc(struct apple_nvme *anv,
 	if (!q->cqes)
 		return -ENOMEM;
 
-	if (anv->hw->has_lsq_nvmmu)
-		iosq_size = depth * sizeof(struct nvme_command);
-	else
-		iosq_size = depth << APPLE_NVME_IOSQES;
-
-	q->sqes = dmam_alloc_coherent(anv->dev, iosq_size,
+	q->sqes = dmam_alloc_coherent(anv->dev,
+				      depth * sizeof(struct nvme_command),
 				      &q->sq_dma_addr, GFP_KERNEL);
 	if (!q->sqes)
 		return -ENOMEM;
 
-	if (anv->hw->has_lsq_nvmmu) {
-		/*
-		 * We need the maximum queue depth here because the NVMMU only
-		 * has a single depth configuration shared between both queues.
-		 */
-		q->tcbs = dmam_alloc_coherent(anv->dev,
-			anv->hw->max_queue_depth *
-				sizeof(struct apple_nvmmu_tcb),
-			&q->tcb_dma_addr, GFP_KERNEL);
-		if (!q->tcbs)
-			return -ENOMEM;
-	}
+	/*
+	 * We need the maximum queue depth here because the NVMMU only has a
+	 * single depth configuration shared between both queues.
+	 */
+	q->tcbs = dmam_alloc_coherent(anv->dev,
+				      APPLE_ANS_MAX_QUEUE_DEPTH *
+					      sizeof(struct apple_nvmmu_tcb),
+				      &q->tcb_dma_addr, GFP_KERNEL);
+	if (!q->tcbs)
+		return -ENOMEM;
 
 	/*
 	 * initialize phase to make sure the allocated and empty memory
@@ -1468,12 +1415,6 @@ static struct apple_nvme *apple_nvme_alloc(struct platform_device *pdev)
 	anv->adminq.is_adminq = true;
 	platform_set_drvdata(pdev, anv);
 
-	anv->hw = of_device_get_match_data(&pdev->dev);
-	if (!anv->hw) {
-		ret = -ENODEV;
-		goto put_dev;
-	}
-
 	ret = apple_nvme_attach_genpd(anv);
 	if (ret < 0) {
 		dev_err_probe(dev, ret, "Failed to attach power domains");
@@ -1505,17 +1446,10 @@ static struct apple_nvme *apple_nvme_alloc(struct platform_device *pdev)
 		goto put_dev;
 	}
 
-	if (anv->hw->has_lsq_nvmmu) {
-		anv->adminq.sq_db = anv->mmio_nvme + APPLE_ANS_LINEAR_ASQ_DB;
-		anv->adminq.cq_db = anv->mmio_nvme + APPLE_ANS_ACQ_DB;
-		anv->ioq.sq_db = anv->mmio_nvme + APPLE_ANS_LINEAR_IOSQ_DB;
-		anv->ioq.cq_db = anv->mmio_nvme + APPLE_ANS_IOCQ_DB;
-	} else {
-		anv->adminq.sq_db = anv->mmio_nvme + NVME_REG_DBS;
-		anv->adminq.cq_db = anv->mmio_nvme + APPLE_ANS_ACQ_DB;
-		anv->ioq.sq_db = anv->mmio_nvme + NVME_REG_DBS + 8;
-		anv->ioq.cq_db = anv->mmio_nvme + APPLE_ANS_IOCQ_DB;
-	}
+	anv->adminq.sq_db = anv->mmio_nvme + APPLE_ANS_LINEAR_ASQ_DB;
+	anv->adminq.cq_db = anv->mmio_nvme + APPLE_ANS_ACQ_DB;
+	anv->ioq.sq_db = anv->mmio_nvme + APPLE_ANS_LINEAR_IOSQ_DB;
+	anv->ioq.cq_db = anv->mmio_nvme + APPLE_ANS_IOCQ_DB;
 
 	anv->sart = devm_apple_sart_get(dev);
 	if (IS_ERR(anv->sart)) {
@@ -1692,19 +1626,8 @@ static int apple_nvme_suspend(struct device *dev)
 static DEFINE_SIMPLE_DEV_PM_OPS(apple_nvme_pm_ops, apple_nvme_suspend,
 				apple_nvme_resume);
 
-static const struct apple_nvme_hw apple_nvme_t8015_hw = {
-	.has_lsq_nvmmu = false,
-	.max_queue_depth = 16,
-};
-
-static const struct apple_nvme_hw apple_nvme_t8103_hw = {
-	.has_lsq_nvmmu = true,
-	.max_queue_depth = 64,
-};
-
 static const struct of_device_id apple_nvme_of_match[] = {
-	{ .compatible = "apple,t8015-nvme-ans2", .data = &apple_nvme_t8015_hw },
-	{ .compatible = "apple,nvme-ans2", .data = &apple_nvme_t8103_hw },
+	{ .compatible = "apple,nvme-ans2" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, apple_nvme_of_match);
-- 
2.53.0



