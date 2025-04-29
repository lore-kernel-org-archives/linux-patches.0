Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1ECEC148;
	Tue, 29 Apr 2025 17:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948883; cv=none; b=COBeCrv0OMKv3tdNrxrW9O3puIYXfFfD4+G3piHqKqBLPIu2IX7Mf5OcF5iU+cZeo6Pp/Q8+w5U7WXT/z+b1/udXPVoZzk+48LO+55Bj7mIbGtFsOQe/b82GTQQjWg/KgssbEnsux9LJAlZlPTfbNOuKWngx2sv8lS24k/Eg/hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948883; c=relaxed/simple;
	bh=nGOqKGOve3ZvFlm5MMFfTzgqADYme3T6zYsSwKmutG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDPbsrgBUtzdp1gDVXWsdJ0yJWudHxHSe8q6RwfYqtGiZSwS3b+tlDLa3pXnrL3e4wSt6u37/AOq6QAFG27Chrt8JKXS7AiL+IgL6iwe+pahlgp5DikD8cC13jLDZp//Hsdkq9sf1k+k069g8JX7ghnvFAR7NT7iwqkLfI/Y13I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pc5YH9DS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pc5YH9DS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E4FC4CEE3;
	Tue, 29 Apr 2025 17:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948882;
	bh=nGOqKGOve3ZvFlm5MMFfTzgqADYme3T6zYsSwKmutG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pc5YH9DSdS7JhSWpJ9e1fyRjzKXA/HDTAx7aq6OD+y16HVZJP6sjVQ2bmvrNZKoLh
	 9BlexhAqt2kGSdERaAJGbnhDQCVoyQsn4mLRmX8ruW3ePfeI+XEc6KXXijl0DrZasn
	 J61771IMMLLqXAYBLK57MKMTTOydvftYps1mO7Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.garry@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/373] scsi: hisi_sas: Factor out task prep and delivery code
Date: Tue, 29 Apr 2025 18:39:59 +0200
Message-ID: <20250429161128.199709569@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.garry@huawei.com>

[ Upstream commit dc313f6b125b095d3d2683d94d5f69c8dc9bdc36 ]

The task prep code is the same between the normal path (in
hisi_sas_task_prep()) and the internal abort path, so factor is out into a
common function.

Link: https://lore.kernel.org/r/1639579061-179473-5-git-send-email-john.garry@huawei.com
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 8aa580cd9284 ("scsi: hisi_sas: Enable force phy when SATA disk directly connected")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 281 ++++++++++++--------------
 1 file changed, 124 insertions(+), 157 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 321e6fae03adc..b9f4f7fadfd40 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -403,94 +403,20 @@ static int hisi_sas_dif_dma_map(struct hisi_hba *hisi_hba,
 	return rc;
 }
 
-static int hisi_sas_task_prep(struct sas_task *task,
-			      struct hisi_sas_dq **dq_pointer,
-			      bool is_tmf, struct hisi_sas_tmf_task *tmf)
+static
+void hisi_sas_task_deliver(struct hisi_hba *hisi_hba,
+			   struct hisi_sas_slot *slot,
+			   struct hisi_sas_dq *dq,
+			   struct hisi_sas_device *sas_dev,
+			   struct hisi_sas_internal_abort *abort,
+			   struct hisi_sas_tmf_task *tmf)
 {
-	struct domain_device *device = task->dev;
-	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
-	struct hisi_sas_device *sas_dev = device->lldd_dev;
-	struct hisi_sas_port *port;
-	struct hisi_sas_slot *slot;
-	struct hisi_sas_cmd_hdr	*cmd_hdr_base;
-	struct asd_sas_port *sas_port = device->port;
-	struct device *dev = hisi_hba->dev;
-	int dlvry_queue_slot, dlvry_queue, rc, slot_idx;
-	int n_elem = 0, n_elem_dif = 0, n_elem_req = 0;
-	struct scsi_cmnd *scmd = NULL;
-	struct hisi_sas_dq *dq;
+	struct hisi_sas_cmd_hdr *cmd_hdr_base;
+	int dlvry_queue_slot, dlvry_queue;
+	struct sas_task *task = slot->task;
 	unsigned long flags;
 	int wr_q_index;
 
-	if (DEV_IS_GONE(sas_dev)) {
-		if (sas_dev)
-			dev_info(dev, "task prep: device %d not ready\n",
-				 sas_dev->device_id);
-		else
-			dev_info(dev, "task prep: device %016llx not ready\n",
-				 SAS_ADDR(device->sas_addr));
-
-		return -ECOMM;
-	}
-
-	if (task->uldd_task) {
-		struct ata_queued_cmd *qc;
-
-		if (dev_is_sata(device)) {
-			qc = task->uldd_task;
-			scmd = qc->scsicmd;
-		} else {
-			scmd = task->uldd_task;
-		}
-	}
-
-	if (scmd) {
-		unsigned int dq_index;
-		u32 blk_tag;
-
-		blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
-		dq_index = blk_mq_unique_tag_to_hwq(blk_tag);
-		*dq_pointer = dq = &hisi_hba->dq[dq_index];
-	} else {
-		struct Scsi_Host *shost = hisi_hba->shost;
-		struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
-		int queue = qmap->mq_map[raw_smp_processor_id()];
-
-		*dq_pointer = dq = &hisi_hba->dq[queue];
-	}
-
-	port = to_hisi_sas_port(sas_port);
-	if (port && !port->port_attached) {
-		dev_info(dev, "task prep: %s port%d not attach device\n",
-			 (dev_is_sata(device)) ?
-			 "SATA/STP" : "SAS",
-			 device->port->id);
-
-		return -ECOMM;
-	}
-
-	rc = hisi_sas_dma_map(hisi_hba, task, &n_elem,
-			      &n_elem_req);
-	if (rc < 0)
-		goto prep_out;
-
-	if (!sas_protocol_ata(task->task_proto)) {
-		rc = hisi_sas_dif_dma_map(hisi_hba, &n_elem_dif, task);
-		if (rc < 0)
-			goto err_out_dma_unmap;
-	}
-
-	if (hisi_hba->hw->slot_index_alloc)
-		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device);
-	else
-		rc = hisi_sas_slot_index_alloc(hisi_hba, scmd);
-
-	if (rc < 0)
-		goto err_out_dif_dma_unmap;
-
-	slot_idx = rc;
-	slot = &hisi_hba->slot_info[slot_idx];
-
 	spin_lock(&dq->lock);
 	wr_q_index = dq->wr_point;
 	dq->wr_point = (dq->wr_point + 1) % HISI_SAS_QUEUE_SLOTS;
@@ -504,16 +430,13 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	dlvry_queue_slot = wr_q_index;
 
 	slot->device_id = sas_dev->device_id;
-	slot->n_elem = n_elem;
-	slot->n_elem_dif = n_elem_dif;
 	slot->dlvry_queue = dlvry_queue;
 	slot->dlvry_queue_slot = dlvry_queue_slot;
 	cmd_hdr_base = hisi_hba->cmd_hdr[dlvry_queue];
 	slot->cmd_hdr = &cmd_hdr_base[dlvry_queue_slot];
-	slot->task = task;
-	slot->port = port;
+
 	slot->tmf = tmf;
-	slot->is_internal = is_tmf;
+	slot->is_internal = tmf;
 	task->lldd_task = slot;
 
 	memset(slot->cmd_hdr, 0, sizeof(struct hisi_sas_cmd_hdr));
@@ -533,8 +456,14 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
 		hisi_sas_task_prep_ata(hisi_hba, slot);
 		break;
+	case SAS_PROTOCOL_NONE:
+		if (abort) {
+			hisi_sas_task_prep_abort(hisi_hba, abort, slot, sas_dev->device_id);
+			break;
+		}
+	fallthrough;
 	default:
-		dev_err(dev, "task prep: unknown/unsupported proto (0x%x)\n",
+		dev_err(hisi_hba->dev, "task prep: unknown/unsupported proto (0x%x)\n",
 			task->task_proto);
 		break;
 	}
@@ -548,29 +477,22 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	spin_lock(&dq->lock);
 	hisi_hba->hw->start_delivery(dq);
 	spin_unlock(&dq->lock);
-
-	return 0;
-
-err_out_dif_dma_unmap:
-	if (!sas_protocol_ata(task->task_proto))
-		hisi_sas_dif_dma_unmap(hisi_hba, task, n_elem_dif);
-err_out_dma_unmap:
-	hisi_sas_dma_unmap(hisi_hba, task, n_elem,
-			   n_elem_req);
-prep_out:
-	dev_err(dev, "task prep: failed[%d]!\n", rc);
-	return rc;
 }
 
 static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
-			      bool is_tmf, struct hisi_sas_tmf_task *tmf)
+			      struct hisi_sas_tmf_task *tmf)
 {
-	u32 rc;
-	struct hisi_hba *hisi_hba;
-	struct device *dev;
+	int n_elem = 0, n_elem_dif = 0, n_elem_req = 0;
 	struct domain_device *device = task->dev;
 	struct asd_sas_port *sas_port = device->port;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct scsi_cmnd *scmd = NULL;
 	struct hisi_sas_dq *dq = NULL;
+	struct hisi_sas_port *port;
+	struct hisi_hba *hisi_hba;
+	struct hisi_sas_slot *slot;
+	struct device *dev;
+	int rc;
 
 	if (!sas_port) {
 		struct task_status_struct *ts = &task->task_status;
@@ -597,11 +519,94 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 		up(&hisi_hba->sem);
 	}
 
+	if (DEV_IS_GONE(sas_dev)) {
+		if (sas_dev)
+			dev_info(dev, "task prep: device %d not ready\n",
+				 sas_dev->device_id);
+		else
+			dev_info(dev, "task prep: device %016llx not ready\n",
+				 SAS_ADDR(device->sas_addr));
+
+		return -ECOMM;
+	}
+
+	if (task->uldd_task) {
+		struct ata_queued_cmd *qc;
+
+		if (dev_is_sata(device)) {
+			qc = task->uldd_task;
+			scmd = qc->scsicmd;
+		} else {
+			scmd = task->uldd_task;
+		}
+	}
+
+	if (scmd) {
+		unsigned int dq_index;
+		u32 blk_tag;
+
+		blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+		dq_index = blk_mq_unique_tag_to_hwq(blk_tag);
+		dq = &hisi_hba->dq[dq_index];
+	} else {
+		struct Scsi_Host *shost = hisi_hba->shost;
+		struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+		int queue = qmap->mq_map[raw_smp_processor_id()];
+
+		dq = &hisi_hba->dq[queue];
+	}
+
+	port = to_hisi_sas_port(sas_port);
+	if (port && !port->port_attached) {
+		dev_info(dev, "task prep: %s port%d not attach device\n",
+			 (dev_is_sata(device)) ?
+			 "SATA/STP" : "SAS",
+			 device->port->id);
+
+		return -ECOMM;
+	}
+
+	rc = hisi_sas_dma_map(hisi_hba, task, &n_elem,
+			      &n_elem_req);
+	if (rc < 0)
+		goto prep_out;
+
+	if (!sas_protocol_ata(task->task_proto)) {
+		rc = hisi_sas_dif_dma_map(hisi_hba, &n_elem_dif, task);
+		if (rc < 0)
+			goto err_out_dma_unmap;
+	}
+
+	if (hisi_hba->hw->slot_index_alloc)
+		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device);
+	else
+		rc = hisi_sas_slot_index_alloc(hisi_hba, scmd);
+
+	if (rc < 0)
+		goto err_out_dif_dma_unmap;
+
+	slot = &hisi_hba->slot_info[rc];
+	slot->n_elem = n_elem;
+	slot->n_elem_dif = n_elem_dif;
+	slot->task = task;
+	slot->port = port;
+
+	slot->tmf = tmf;
+	slot->is_internal = tmf;
+
 	/* protect task_prep and start_delivery sequence */
-	rc = hisi_sas_task_prep(task, &dq, is_tmf, tmf);
-	if (rc)
-		dev_err(dev, "task exec: failed[%d]!\n", rc);
+	hisi_sas_task_deliver(hisi_hba, slot, dq, sas_dev, NULL, tmf);
 
+	return 0;
+
+err_out_dif_dma_unmap:
+	if (!sas_protocol_ata(task->task_proto))
+		hisi_sas_dif_dma_unmap(hisi_hba, task, n_elem_dif);
+err_out_dma_unmap:
+	hisi_sas_dma_unmap(hisi_hba, task, n_elem,
+				   n_elem_req);
+prep_out:
+	dev_err(dev, "task exec: failed[%d]!\n", rc);
 	return rc;
 }
 
@@ -1089,7 +1094,7 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 
 static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 {
-	return hisi_sas_task_exec(task, gfp_flags, 0, NULL);
+	return hisi_sas_task_exec(task, gfp_flags, NULL);
 }
 
 static int hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
@@ -1221,8 +1226,7 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 		task->slow_task->timer.expires = jiffies + TASK_TIMEOUT;
 		add_timer(&task->slow_task->timer);
 
-		res = hisi_sas_task_exec(task, GFP_KERNEL, 1, tmf);
-
+		res = hisi_sas_task_exec(task, GFP_KERNEL, tmf);
 		if (res) {
 			del_timer(&task->slow_task->timer);
 			dev_err(dev, "abort tmf: executing internal task failed: %d\n",
@@ -1976,12 +1980,9 @@ hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct device *dev = hisi_hba->dev;
 	struct hisi_sas_port *port;
-	struct hisi_sas_slot *slot;
 	struct asd_sas_port *sas_port = device->port;
-	struct hisi_sas_cmd_hdr *cmd_hdr_base;
-	int dlvry_queue_slot, dlvry_queue, n_elem = 0, rc, slot_idx;
-	unsigned long flags;
-	int wr_q_index;
+	struct hisi_sas_slot *slot;
+	int slot_idx;
 
 	if (unlikely(test_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags)))
 		return -EINVAL;
@@ -1992,58 +1993,24 @@ hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
 	port = to_hisi_sas_port(sas_port);
 
 	/* simply get a slot and send abort command */
-	rc = hisi_sas_slot_index_alloc(hisi_hba, NULL);
-	if (rc < 0)
+	slot_idx = hisi_sas_slot_index_alloc(hisi_hba, NULL);
+	if (slot_idx < 0)
 		goto err_out;
 
-	slot_idx = rc;
 	slot = &hisi_hba->slot_info[slot_idx];
-
-	spin_lock(&dq->lock);
-	wr_q_index = dq->wr_point;
-	dq->wr_point = (dq->wr_point + 1) % HISI_SAS_QUEUE_SLOTS;
-	list_add_tail(&slot->delivery, &dq->list);
-	spin_unlock(&dq->lock);
-	spin_lock(&sas_dev->lock);
-	list_add_tail(&slot->entry, &sas_dev->list);
-	spin_unlock(&sas_dev->lock);
-
-	dlvry_queue = dq->id;
-	dlvry_queue_slot = wr_q_index;
-
-	slot->device_id = sas_dev->device_id;
-	slot->n_elem = n_elem;
-	slot->dlvry_queue = dlvry_queue;
-	slot->dlvry_queue_slot = dlvry_queue_slot;
-	cmd_hdr_base = hisi_hba->cmd_hdr[dlvry_queue];
-	slot->cmd_hdr = &cmd_hdr_base[dlvry_queue_slot];
+	slot->n_elem = 0;
 	slot->task = task;
 	slot->port = port;
 	slot->is_internal = true;
-	task->lldd_task = slot;
 
-	memset(slot->cmd_hdr, 0, sizeof(struct hisi_sas_cmd_hdr));
-	memset(hisi_sas_cmd_hdr_addr_mem(slot), 0, HISI_SAS_COMMAND_TABLE_SZ);
-	memset(hisi_sas_status_buf_addr_mem(slot), 0,
-	       sizeof(struct hisi_sas_err_record));
-
-	hisi_sas_task_prep_abort(hisi_hba, abort, slot, device_id);
-
-	spin_lock_irqsave(&task->task_state_lock, flags);
-	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
-	spin_unlock_irqrestore(&task->task_state_lock, flags);
-	WRITE_ONCE(slot->ready, 1);
-	/* send abort command to the chip */
-	spin_lock(&dq->lock);
-	hisi_hba->hw->start_delivery(dq);
-	spin_unlock(&dq->lock);
+	hisi_sas_task_deliver(hisi_hba, slot, dq, sas_dev, abort, NULL);
 
 	return 0;
 
 err_out:
-	dev_err(dev, "internal abort task prep: failed[%d]!\n", rc);
+	dev_err(dev, "internal abort task prep: failed[%d]!\n", slot_idx);
 
-	return rc;
+	return slot_idx;
 }
 
 /**
-- 
2.39.5



