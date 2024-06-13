Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C16142E8E;
	Thu, 13 Jun 2024 11:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278684; cv=none; b=nvQ6H0DPMgVYa4Iiy8xFsbzNiUgoUcovZN5Z8sfWaT+n7uy3gw60zSc+iZu8eGwWJZxKjBBDuQKnI/c8o2zGDGoeB8J7Hj8ebkWUiTmdSBavlzh/dYVzajmgJ4WDl5igdH4m963u877IIHLLYyXrL86BM0EuAGalmFcd6G5A/JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278684; c=relaxed/simple;
	bh=5FpyacMCyO3F0wKsyKZh8XI6C9OFc+0blDbaAPVinEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JO0nMyPvZet7PRgSBrw89XA4Rh7CPz59u7qtS0NTLme2s3bXpXsUSOek35cKOZ23PHe9n9lS4tCL8C2gN2Ed29hSThGxJF+nLgi3Q+yY4xlGd0td9ylQgBHV7J33bP2jI0W4LgfoHTT6x5JQQSE43aMHhhOCF2zWL/7vBYclsNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3PTA4H8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3PTA4H8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71088C2BBFC;
	Thu, 13 Jun 2024 11:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278683;
	bh=5FpyacMCyO3F0wKsyKZh8XI6C9OFc+0blDbaAPVinEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3PTA4H8E7QEygaEPHZ6H430M4gm3LpMxk2imwVb8Pacq5TUdfdbox55wbWMPI3Xh
	 OYPlhNL+V4OUNg0Xcj4EQtVk7/ZUZCgaGL2nWmq+LkpunRz6Zp3PXGrWuyHFraofy6
	 w5Yb6LclJ4wydXEK/LdzmylCEF4kIQvCUZ7OHq1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 034/213] scsi: ufs: add a low-level __ufshcd_issue_tm_cmd helper
Date: Thu, 13 Jun 2024 13:31:22 +0200
Message-ID: <20240613113229.314914110@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit c6049cd98212dfe39f67fb411d18d53df0ad9436 ]

Add a helper that takes a utp_task_req_desc and issues it, which will
be useful for UFS bsg support.  Rewrite ufshcd_issue_tm_cmd0x to use
this new helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: e4a628877119 ("scsi: ufs: core: Perform read back after disabling interrupts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 141 +++++++++++++++++---------------------
 1 file changed, 61 insertions(+), 80 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2239dda35fd70..6e420aab18452 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -648,19 +648,6 @@ static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
 	return le32_to_cpu(lrbp->utr_descriptor_ptr->header.dword_2) & MASK_OCS;
 }
 
-/**
- * ufshcd_get_tmr_ocs - Get the UTMRD Overall Command Status
- * @task_req_descp: pointer to utp_task_req_desc structure
- *
- * This function is used to get the OCS field from UTMRD
- * Returns the OCS field in the UTMRD
- */
-static inline int
-ufshcd_get_tmr_ocs(struct utp_task_req_desc *task_req_descp)
-{
-	return le32_to_cpu(task_req_descp->header.dword_2) & MASK_OCS;
-}
-
 /**
  * ufshcd_get_tm_free_slot - get a free slot for task management request
  * @hba: per adapter instance
@@ -4658,37 +4645,6 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
 	}
 }
 
-/**
- * ufshcd_task_req_compl - handle task management request completion
- * @hba: per adapter instance
- * @index: index of the completed request
- * @resp: task management service response
- *
- * Returns non-zero value on error, zero on success
- */
-static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index, u8 *resp)
-{
-	struct utp_task_req_desc *treq = hba->utmrdl_base_addr + index;
-	unsigned long flags;
-	int ocs_value;
-
-	spin_lock_irqsave(hba->host->host_lock, flags);
-
-	/* Clear completed tasks from outstanding_tasks */
-	__clear_bit(index, &hba->outstanding_tasks);
-
-	ocs_value = ufshcd_get_tmr_ocs(treq);
-
-	if (ocs_value != OCS_SUCCESS)
-		dev_err(hba->dev, "%s: failed, ocs = 0x%x\n",
-				__func__, ocs_value);
-	else if (resp)
-		*resp = be32_to_cpu(treq->output_param1) & MASK_TM_SERVICE_RESP;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	return ocs_value;
-}
-
 /**
  * ufshcd_scsi_cmd_status - Update SCSI command result based on SCSI status
  * @lrbp: pointer to local reference block of completed command
@@ -5648,27 +5604,12 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 	return err;
 }
 
-/**
- * ufshcd_issue_tm_cmd - issues task management commands to controller
- * @hba: per adapter instance
- * @lun_id: LUN ID to which TM command is sent
- * @task_id: task ID to which the TM command is applicable
- * @tm_function: task management function opcode
- * @tm_response: task management service response return value
- *
- * Returns non-zero value on error, zero on success.
- */
-static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
-		u8 tm_function, u8 *tm_response)
+static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
+		struct utp_task_req_desc *treq, u8 tm_function)
 {
-	struct utp_task_req_desc *treq;
-	struct Scsi_Host *host;
+	struct Scsi_Host *host = hba->host;
 	unsigned long flags;
-	int free_slot;
-	int err;
-	int task_tag;
-
-	host = hba->host;
+	int free_slot, task_tag, err;
 
 	/*
 	 * Get free slot, sleep if slots are unavailable.
@@ -5679,24 +5620,11 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(host->host_lock, flags);
-	treq = hba->utmrdl_base_addr + free_slot;
-
-	/* Configure task request descriptor */
-	treq->header.dword_0 = cpu_to_le32(UTP_REQ_DESC_INT_CMD);
-	treq->header.dword_2 = cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
-
-	/* Configure task request UPIU */
 	task_tag = hba->nutrs + free_slot;
-	treq->req_header.dword_0 = UPIU_HEADER_DWORD(UPIU_TRANSACTION_TASK_REQ,
-			0, lun_id, task_tag);
-	treq->req_header.dword_1 = UPIU_HEADER_DWORD(0, tm_function, 0, 0);
-	/*
-	 * The host shall provide the same value for LUN field in the basic
-	 * header and for Input Parameter.
-	 */
-	treq->input_param1 = cpu_to_be32(lun_id);
-	treq->input_param2 = cpu_to_be32(task_id);
 
+	treq->req_header.dword_0 |= cpu_to_be32(task_tag);
+
+	memcpy(hba->utmrdl_base_addr + free_slot, treq, sizeof(*treq));
 	ufshcd_vops_setup_task_mgmt(hba, free_slot, tm_function);
 
 	/* send command to the controller */
@@ -5726,8 +5654,15 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 					__func__, free_slot);
 		err = -ETIMEDOUT;
 	} else {
-		err = ufshcd_task_req_compl(hba, free_slot, tm_response);
+		err = 0;
+		memcpy(treq, hba->utmrdl_base_addr + free_slot, sizeof(*treq));
+
 		ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_complete");
+
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		__clear_bit(free_slot, &hba->outstanding_tasks);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	}
 
 	clear_bit(free_slot, &hba->tm_condition);
@@ -5738,6 +5673,52 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	return err;
 }
 
+/**
+ * ufshcd_issue_tm_cmd - issues task management commands to controller
+ * @hba: per adapter instance
+ * @lun_id: LUN ID to which TM command is sent
+ * @task_id: task ID to which the TM command is applicable
+ * @tm_function: task management function opcode
+ * @tm_response: task management service response return value
+ *
+ * Returns non-zero value on error, zero on success.
+ */
+static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
+		u8 tm_function, u8 *tm_response)
+{
+	struct utp_task_req_desc treq = { { 0 }, };
+	int ocs_value, err;
+
+	/* Configure task request descriptor */
+	treq.header.dword_0 = cpu_to_le32(UTP_REQ_DESC_INT_CMD);
+	treq.header.dword_2 = cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
+
+	/* Configure task request UPIU */
+	treq.req_header.dword_0 = cpu_to_be32(lun_id << 8) |
+				  cpu_to_be32(UPIU_TRANSACTION_TASK_REQ << 24);
+	treq.req_header.dword_1 = cpu_to_be32(tm_function << 16);
+
+	/*
+	 * The host shall provide the same value for LUN field in the basic
+	 * header and for Input Parameter.
+	 */
+	treq.input_param1 = cpu_to_be32(lun_id);
+	treq.input_param2 = cpu_to_be32(task_id);
+
+	err = __ufshcd_issue_tm_cmd(hba, &treq, tm_function);
+	if (err == -ETIMEDOUT)
+		return err;
+
+	ocs_value = le32_to_cpu(treq.header.dword_2) & MASK_OCS;
+	if (ocs_value != OCS_SUCCESS)
+		dev_err(hba->dev, "%s: failed, ocs = 0x%x\n",
+				__func__, ocs_value);
+	else if (tm_response)
+		*tm_response = be32_to_cpu(treq.output_param1) &
+				MASK_TM_SERVICE_RESP;
+	return err;
+}
+
 /**
  * ufshcd_eh_device_reset_handler - device reset handler registered to
  *                                    scsi layer.
-- 
2.43.0



