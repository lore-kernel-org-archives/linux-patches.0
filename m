Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5FC256C99;
	Thu, 17 Apr 2025 18:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914046; cv=none; b=ECh/xh6ZIZIew4K5y9VSTgopcas4qzT0R2J7+5UAA3ZjBmpn1NctHBJCjnmLa2rF2OMkl2LCJ7ubytRnvP14O9bqYF4DijXtrsfA3tCc/wdUOJfLOGmSScij1zy6MyW69QNaLIntGbWzURwPKXHSUk+zUAHePPiIX5DnNbpLlcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914046; c=relaxed/simple;
	bh=wGf2KDlYF5GDV+J2OFU/QpmXM5A3FaSPzlhKZk1irXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvo0RGSvN1GoZ/wg4bm0DQxkJsSwLl206y3zg5nIsNEAVyioKcrh+O0A9stlihDxFGk9ZdoAvcoi0MYMUFFaP/e3EXEoKvis+gMLnqDk7tkKdyC3r4kfGHmgNEgIr3irl8hQq+9T3Ty+CswhGof6iXhEoR4LPI9FLR5JdGk8Dkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQYVC1Q6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQYVC1Q6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9451C4CEE7;
	Thu, 17 Apr 2025 18:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914046;
	bh=wGf2KDlYF5GDV+J2OFU/QpmXM5A3FaSPzlhKZk1irXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQYVC1Q6dxJ/wrKA48QBZ8xfdOaVz7uVifHmHMnqjXJxg3VGwdL4Kf+GvKFOJ/5kM
	 FZ9BUuSmm2Sm2MeEVRXR7Q+jifPAjWXQMd6f97173lGXEHPiNodCppuDYsnCa9VaSM
	 TWlAiMp3Br70m+RFV+nJQwmDO8rU2J0AbwGVSzDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 088/414] scsi: mpi3mr: Avoid reply queue full condition
Date: Thu, 17 Apr 2025 19:47:26 +0200
Message-ID: <20250417175114.980877506@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit f08b24d82749117ce779cc66689e8594341130d3 ]

To avoid reply queue full condition, update the driver to check IOCFacts
capabilities for qfull.

Update the operational reply queue's Consumer Index after processing 100
replies. If pending I/Os on a reply queue exceeds a threshold
(reply_queue_depth - 200), then return I/O back to OS to retry.

Also increase default admin reply queue size to 2K.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250129100850.25430-2-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h     | 12 +++++++++++-
 drivers/scsi/mpi3mr/mpi3mr_app.c | 24 ++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 32 ++++++++++++++++++++++++++++----
 3 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 0c3e1ac076b5f..3c7fd4582c0d6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -81,13 +81,14 @@ extern atomic64_t event_counter;
 
 /* Admin queue management definitions */
 #define MPI3MR_ADMIN_REQ_Q_SIZE		(2 * MPI3MR_PAGE_SIZE_4K)
-#define MPI3MR_ADMIN_REPLY_Q_SIZE	(4 * MPI3MR_PAGE_SIZE_4K)
+#define MPI3MR_ADMIN_REPLY_Q_SIZE	(8 * MPI3MR_PAGE_SIZE_4K)
 #define MPI3MR_ADMIN_REQ_FRAME_SZ	128
 #define MPI3MR_ADMIN_REPLY_FRAME_SZ	16
 
 /* Operational queue management definitions */
 #define MPI3MR_OP_REQ_Q_QD		512
 #define MPI3MR_OP_REP_Q_QD		1024
+#define MPI3MR_OP_REP_Q_QD2K		2048
 #define MPI3MR_OP_REP_Q_QD4K		4096
 #define MPI3MR_OP_REQ_Q_SEG_SIZE	4096
 #define MPI3MR_OP_REP_Q_SEG_SIZE	4096
@@ -329,6 +330,7 @@ enum mpi3mr_reset_reason {
 #define MPI3MR_RESET_REASON_OSTYPE_SHIFT	28
 #define MPI3MR_RESET_REASON_IOCNUM_SHIFT	20
 
+
 /* Queue type definitions */
 enum queue_type {
 	MPI3MR_DEFAULT_QUEUE = 0,
@@ -388,6 +390,7 @@ struct mpi3mr_ioc_facts {
 	u16 max_msix_vectors;
 	u8 personality;
 	u8 dma_mask;
+	bool max_req_limit;
 	u8 protocol_flags;
 	u8 sge_mod_mask;
 	u8 sge_mod_value;
@@ -457,6 +460,8 @@ struct op_req_qinfo {
  * @enable_irq_poll: Flag to indicate polling is enabled
  * @in_use: Queue is handled by poll/ISR
  * @qtype: Type of queue (types defined in enum queue_type)
+ * @qfull_watermark: Watermark defined in reply queue to avoid
+ *                    reply queue full
  */
 struct op_reply_qinfo {
 	u16 ci;
@@ -472,6 +477,7 @@ struct op_reply_qinfo {
 	bool enable_irq_poll;
 	atomic_t in_use;
 	enum queue_type qtype;
+	u16 qfull_watermark;
 };
 
 /**
@@ -1154,6 +1160,8 @@ struct scmd_priv {
  * @snapdump_trigger_active: Snapdump trigger active flag
  * @pci_err_recovery: PCI error recovery in progress
  * @block_on_pci_err: Block IO during PCI error recovery
+ * @reply_qfull_count: Occurences of reply queue full avoidance kicking-in
+ * @prevent_reply_qfull: Enable reply queue prevention
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -1352,6 +1360,8 @@ struct mpi3mr_ioc {
 	bool fw_release_trigger_active;
 	bool pci_err_recovery;
 	bool block_on_pci_err;
+	atomic_t reply_qfull_count;
+	bool prevent_reply_qfull;
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 7589f48aebc80..1532436f0f3af 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -3060,6 +3060,29 @@ reply_queue_count_show(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR_RO(reply_queue_count);
 
+/**
+ * reply_qfull_count_show - Show reply qfull count
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * Retrieves the current value of the reply_qfull_count from the mrioc structure and
+ * formats it as a string for display.
+ *
+ * Return: sysfs_emit() return
+ */
+static ssize_t
+reply_qfull_count_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+
+	return sysfs_emit(buf, "%u\n", atomic_read(&mrioc->reply_qfull_count));
+}
+
+static DEVICE_ATTR_RO(reply_qfull_count);
+
 /**
  * logging_level_show - Show controller debug level
  * @dev: class device
@@ -3152,6 +3175,7 @@ static struct attribute *mpi3mr_host_attrs[] = {
 	&dev_attr_fw_queue_depth.attr,
 	&dev_attr_op_req_q_count.attr,
 	&dev_attr_reply_queue_count.attr,
+	&dev_attr_reply_qfull_count.attr,
 	&dev_attr_logging_level.attr,
 	&dev_attr_adp_state.attr,
 	NULL,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 5ed31fe57474a..656108dd2ee30 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2104,15 +2104,22 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 	}
 
 	reply_qid = qidx + 1;
-	op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD;
-	if ((mrioc->pdev->device == MPI3_MFGPAGE_DEVID_SAS4116) &&
-		!mrioc->pdev->revision)
-		op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD4K;
+
+	if (mrioc->pdev->device == MPI3_MFGPAGE_DEVID_SAS4116) {
+		if (mrioc->pdev->revision)
+			op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD;
+		else
+			op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD4K;
+	} else
+		op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD2K;
+
 	op_reply_q->ci = 0;
 	op_reply_q->ephase = 1;
 	atomic_set(&op_reply_q->pend_ios, 0);
 	atomic_set(&op_reply_q->in_use, 0);
 	op_reply_q->enable_irq_poll = false;
+	op_reply_q->qfull_watermark =
+		op_reply_q->num_replies - (MPI3MR_THRESHOLD_REPLY_COUNT * 2);
 
 	if (!op_reply_q->q_segments) {
 		retval = mpi3mr_alloc_op_reply_q_segments(mrioc, qidx);
@@ -2416,8 +2423,10 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 	void *segment_base_addr;
 	u16 req_sz = mrioc->facts.op_req_sz;
 	struct segments *segments = op_req_q->q_segments;
+	struct op_reply_qinfo *op_reply_q = NULL;
 
 	reply_qidx = op_req_q->reply_qid - 1;
+	op_reply_q = mrioc->op_reply_qinfo + reply_qidx;
 
 	if (mrioc->unrecoverable)
 		return -EFAULT;
@@ -2448,6 +2457,15 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 		goto out;
 	}
 
+	/* Reply queue is nearing to get full, push back IOs to SML */
+	if ((mrioc->prevent_reply_qfull == true) &&
+		(atomic_read(&op_reply_q->pend_ios) >
+	     (op_reply_q->qfull_watermark))) {
+		atomic_inc(&mrioc->reply_qfull_count);
+		retval = -EAGAIN;
+		goto out;
+	}
+
 	segment_base_addr = segments[pi / op_req_q->segment_qd].segment;
 	req_entry = (u8 *)segment_base_addr +
 	    ((pi % op_req_q->segment_qd) * req_sz);
@@ -3091,6 +3109,9 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	mrioc->facts.dma_mask = (facts_flags &
 	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK) >>
 	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT;
+	mrioc->facts.dma_mask = (facts_flags &
+	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK) >>
+	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT;
 	mrioc->facts.protocol_flags = facts_data->protocol_flags;
 	mrioc->facts.mpi_version = le32_to_cpu(facts_data->mpi_version.word);
 	mrioc->facts.max_reqs = le16_to_cpu(facts_data->max_outstanding_requests);
@@ -4214,6 +4235,9 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		mrioc->shost->transportt = mpi3mr_transport_template;
 	}
 
+	if (mrioc->facts.max_req_limit)
+		mrioc->prevent_reply_qfull = true;
+
 	mrioc->reply_sz = mrioc->facts.reply_sz;
 
 	retval = mpi3mr_check_reset_dma_mask(mrioc);
-- 
2.39.5



