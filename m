Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EFC31B80E;
	Mon, 27 Oct 2025 18:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590553; cv=none; b=HGiebNEx1/bdFoSnj3bJibHtRRNq8cyFjG30pXGAhbfUjXM0kKvOKHvT1KZQzYjniFLKCfX2WhtPehOWr+z5T0bEPbRmBmKctxxCNt8dFeyW8ZIE7eK2fBzNsUnbUPFCHvA3hZZ4qir2XnfXGAiP4LPijZg5IYziTv1PmbFjJPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590553; c=relaxed/simple;
	bh=rd2qqqfRi8i0198M/lf2g5lS5RhN9H//SDoqPV/ruRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJWrnfv7r8iXrI6I7AClBZgHJaPA5rBCwO/gQRf/oFww9Weqv1+JN78FghygZ4pvejC5oan6KzW6cktwJapqo4L3Yd/jP/aPlxzYtxMb6wFNTuSyjDyVN5wPk0FUdpcdvQVxAVAVHnFI6P6ddqCqaEHYfyTn9gVF2THmr1cyzfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vL/TtsJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vL/TtsJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E7CC4CEFD;
	Mon, 27 Oct 2025 18:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590553;
	bh=rd2qqqfRi8i0198M/lf2g5lS5RhN9H//SDoqPV/ruRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vL/TtsJcflcJU/W8dZ0DTeTLotG9tZBVzks6cNELCv8jXPL1C1UfTH4WbqfaWmP3L
	 tFacKsNBP+ivcB0oH5bsYzI7fHxofbej8lNwC3gg7yGKT3zytvwl5DbdPC/Hif5DeY
	 BtR/Fg88okHOsQ5oLt0MpO6OxW2CR3zAfTsHJQK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.garry@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/224] scsi: mvsas: Use sas_task_find_rq() for tagging
Date: Mon, 27 Oct 2025 19:33:53 +0100
Message-ID: <20251027183511.321753082@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.garry@huawei.com>

[ Upstream commit 2acf97f199f9eba8321390325519e9b6bff60108 ]

The request associated with a SCSI command coming from the block layer has
a unique tag, so use that when possible for getting a slot.

Unfortunately we don't support reserved commands in the SCSI midlayer yet.
As such, SMP tasks - as an example - will not have a request associated, so
in the interim continue to manage those tags for that type of sas_task
internally.

We reserve an arbitrary 4 tags for these internal tags. Indeed, we already
decrement MVS_RSVD_SLOTS by 2 for the shost can_queue when flag
MVF_FLAG_SOC is set. This change was made in commit 20b09c2992fe ("[SCSI]
mvsas: add support for 94xx; layout change; bug fixes"), but what those 2
slots are used for is not obvious.

Also make the tag management functions static, where possible.

Signed-off-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/1666091763-11023-8-git-send-email-john.garry@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 60cd16a3b743 ("scsi: mvsas: Fix use-after-free bugs in mvs_work_queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mvsas/mv_defs.h |  1 +
 drivers/scsi/mvsas/mv_init.c |  9 +++++----
 drivers/scsi/mvsas/mv_sas.c  | 35 ++++++++++++++++++++++-------------
 drivers/scsi/mvsas/mv_sas.h  |  7 +------
 4 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
index 199ab49aa047f..3ec1c7546cdb4 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -40,6 +40,7 @@ enum driver_configuration {
 	MVS_ATA_CMD_SZ		= 96,	/* SATA command table buffer size */
 	MVS_OAF_SZ		= 64,	/* Open address frame buffer size */
 	MVS_QUEUE_SIZE		= 64,	/* Support Queue depth */
+	MVS_RSVD_SLOTS		= 4,
 	MVS_SOC_CAN_QUEUE	= MVS_SOC_SLOTS - 2,
 };
 
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 7622de9d7d8ba..264f32065ea7a 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -139,7 +139,7 @@ static void mvs_free(struct mvs_info *mvi)
 		scsi_host_put(mvi->shost);
 	list_for_each_entry(mwq, &mvi->wq_list, entry)
 		cancel_delayed_work(&mwq->work_q);
-	kfree(mvi->tags);
+	kfree(mvi->rsvd_tags);
 	kfree(mvi);
 }
 
@@ -284,7 +284,6 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 			printk(KERN_DEBUG "failed to create dma pool %s.\n", pool_name);
 			goto err_out;
 	}
-	mvi->tags_num = slot_nr;
 
 	return 0;
 err_out:
@@ -368,8 +367,8 @@ static struct mvs_info *mvs_pci_alloc(struct pci_dev *pdev,
 	mvi->sas = sha;
 	mvi->shost = shost;
 
-	mvi->tags = kzalloc(MVS_CHIP_SLOT_SZ>>3, GFP_KERNEL);
-	if (!mvi->tags)
+	mvi->rsvd_tags = bitmap_zalloc(MVS_RSVD_SLOTS, GFP_KERNEL);
+	if (!mvi->rsvd_tags)
 		goto err_out;
 
 	if (MVS_CHIP_DISP->chip_ioremap(mvi))
@@ -470,6 +469,8 @@ static void  mvs_post_sas_ha_init(struct Scsi_Host *shost,
 	else
 		can_queue = MVS_CHIP_SLOT_SZ;
 
+	can_queue -= MVS_RSVD_SLOTS;
+
 	shost->sg_tablesize = min_t(u16, SG_ALL, MVS_MAX_SG);
 	shost->can_queue = can_queue;
 	mvi->shost->cmd_per_lun = MVS_QUEUE_SIZE;
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 377b931f46dcf..393a8ee551e4d 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -20,31 +20,34 @@ static int mvs_find_tag(struct mvs_info *mvi, struct sas_task *task, u32 *tag)
 	return 0;
 }
 
-void mvs_tag_clear(struct mvs_info *mvi, u32 tag)
+static void mvs_tag_clear(struct mvs_info *mvi, u32 tag)
 {
-	void *bitmap = mvi->tags;
+	void *bitmap = mvi->rsvd_tags;
 	clear_bit(tag, bitmap);
 }
 
-void mvs_tag_free(struct mvs_info *mvi, u32 tag)
+static void mvs_tag_free(struct mvs_info *mvi, u32 tag)
 {
+	if (tag >= MVS_RSVD_SLOTS)
+		return;
+
 	mvs_tag_clear(mvi, tag);
 }
 
-void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
+static void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
 {
-	void *bitmap = mvi->tags;
+	void *bitmap = mvi->rsvd_tags;
 	set_bit(tag, bitmap);
 }
 
-inline int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
+static int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
 {
 	unsigned int index, tag;
-	void *bitmap = mvi->tags;
+	void *bitmap = mvi->rsvd_tags;
 
-	index = find_first_zero_bit(bitmap, mvi->tags_num);
+	index = find_first_zero_bit(bitmap, MVS_RSVD_SLOTS);
 	tag = index;
-	if (tag >= mvi->tags_num)
+	if (tag >= MVS_RSVD_SLOTS)
 		return -SAS_QUEUE_FULL;
 	mvs_tag_set(mvi, tag);
 	*tag_out = tag;
@@ -693,6 +696,7 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 	struct mvs_task_exec_info tei;
 	struct mvs_slot_info *slot;
 	u32 tag = 0xdeadbeef, n_elem = 0;
+	struct request *rq;
 	int rc = 0;
 
 	if (!dev->port) {
@@ -757,9 +761,14 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 		n_elem = task->num_scatter;
 	}
 
-	rc = mvs_tag_alloc(mvi, &tag);
-	if (rc)
-		goto err_out;
+	rq = sas_task_find_rq(task);
+	if (rq) {
+		tag = rq->tag + MVS_RSVD_SLOTS;
+	} else {
+		rc = mvs_tag_alloc(mvi, &tag);
+		if (rc)
+			goto err_out;
+	}
 
 	slot = &mvi->slot_info[tag];
 
@@ -862,7 +871,7 @@ int mvs_queue_command(struct sas_task *task, gfp_t gfp_flags)
 static void mvs_slot_free(struct mvs_info *mvi, u32 rx_desc)
 {
 	u32 slot_idx = rx_desc & RXQ_SLOT_MASK;
-	mvs_tag_clear(mvi, slot_idx);
+	mvs_tag_free(mvi, slot_idx);
 }
 
 static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 6689481779343..42caca5bb874a 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -370,8 +370,7 @@ struct mvs_info {
 	u32 chip_id;
 	const struct mvs_chip_info *chip;
 
-	int tags_num;
-	unsigned long *tags;
+	unsigned long *rsvd_tags;
 	/* further per-slot information */
 	struct mvs_phy phy[MVS_MAX_PHYS];
 	struct mvs_port port[MVS_MAX_PHYS];
@@ -424,10 +423,6 @@ struct mvs_task_exec_info {
 
 /******************** function prototype *********************/
 void mvs_get_sas_addr(void *buf, u32 buflen);
-void mvs_tag_clear(struct mvs_info *mvi, u32 tag);
-void mvs_tag_free(struct mvs_info *mvi, u32 tag);
-void mvs_tag_set(struct mvs_info *mvi, unsigned int tag);
-int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out);
 void mvs_iounmap(void __iomem *regs);
 int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex);
 void mvs_phys_reset(struct mvs_info *mvi, u32 phy_mask, int hard);
-- 
2.51.0



