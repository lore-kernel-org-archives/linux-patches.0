Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DBB25A64B;
	Thu, 17 Apr 2025 18:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914049; cv=none; b=c0b5yvz4OP2MVisGT8CrZVaodAJQI87Lir+aKSqRrsriFHqp9/aPKwz+lWGb7dZBVxOEE5NXpQIA3Ano2uR3a0/+E1tt8rC+/bvHe7KzjlXTsFIs5L6rU2A3Sa/2KxR2uODQC7e2paHZ4zN4I8hj+191re7zCIk1HSpx6amKb04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914049; c=relaxed/simple;
	bh=FuJNGEcgQtBE7hEzttQQAd6LliMJXxmFGJIbjTwURjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqPJWn455EuuF/cgETZ1FJsBhDeLLHk89jKTo4rxUAzyQEKgBiglaCZp9lpxSeDV4nnNdpVZcdRA/JX49vm08M6B60bvoDM11Zts6b1YYc8IXwMP7Zgf5yQ7AThmyJy3YD381YHBq0xHqPhTXD15Sp9UFAHi19aZLjWfHwIoqJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbFshF1I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbFshF1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5802C4CEEE;
	Thu, 17 Apr 2025 18:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914049;
	bh=FuJNGEcgQtBE7hEzttQQAd6LliMJXxmFGJIbjTwURjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zbFshF1IRyy6/7tPDq/xvOMD/hypj1ENBmEmsfDhC6DF93W3NZytBzBvmGL0GoEJw
	 /FpDTB7HZRPb3cjerFvcc6Q8cfmdicX5hkZPHV1dS6foUuxEH7vKv5SYC5My9QD0QA
	 Sa777AczAlvzrYenWmZYtXsA5hyKmQMS3iZWd4m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 089/414] scsi: mpi3mr: Synchronous access b/w reset and tm thread for reply queue
Date: Thu, 17 Apr 2025 19:47:27 +0200
Message-ID: <20250417175115.021403847@linuxfoundation.org>
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

[ Upstream commit f195fc060c738d303a21fae146dbf85e1595fb4c ]

When the task management thread processes reply queues while the reset
thread resets them, the task management thread accesses an invalid queue ID
(0xFFFF), set by the reset thread, which points to unallocated memory,
causing a crash.

Add flag 'io_admin_reset_sync' to synchronize access between the reset,
I/O, and admin threads. Before a reset, the reset handler sets this flag to
block I/O and admin processing threads. If any thread bypasses the initial
check, the reset thread waits up to 10 seconds for processing to finish. If
the wait exceeds 10 seconds, the controller is marked as unrecoverable.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250129100850.25430-4-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  2 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 67 +++++++++++++++++++++++++++++++--
 2 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 3c7fd4582c0d6..4f8fe2c4c33ed 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1097,6 +1097,7 @@ struct scmd_priv {
  * @ts_update_interval: Timestamp update interval
  * @reset_in_progress: Reset in progress flag
  * @unrecoverable: Controller unrecoverable flag
+ * @io_admin_reset_sync: Manage state of I/O ops during an admin reset process
  * @prev_reset_result: Result of previous reset
  * @reset_mutex: Controller reset mutex
  * @reset_waitq: Controller reset  wait queue
@@ -1285,6 +1286,7 @@ struct mpi3mr_ioc {
 	u16 ts_update_interval;
 	u8 reset_in_progress;
 	u8 unrecoverable;
+	u8 io_admin_reset_sync;
 	int prev_reset_result;
 	struct mutex reset_mutex;
 	wait_queue_head_t reset_waitq;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 656108dd2ee30..ec5b1ab287177 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -17,7 +17,7 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	struct mpi3_ioc_facts_data *facts_data);
 static void mpi3mr_pel_wait_complete(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd);
-
+static int mpi3mr_check_op_admin_proc(struct mpi3mr_ioc *mrioc);
 static int poll_queues;
 module_param(poll_queues, int, 0444);
 MODULE_PARM_DESC(poll_queues, "Number of queues for io_uring poll mode. (Range 1 - 126)");
@@ -459,7 +459,7 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 	}
 
 	do {
-		if (mrioc->unrecoverable)
+		if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
 			break;
 
 		mrioc->admin_req_ci = le16_to_cpu(reply_desc->request_queue_ci);
@@ -554,7 +554,7 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 	}
 
 	do {
-		if (mrioc->unrecoverable)
+		if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
 			break;
 
 		req_q_idx = le16_to_cpu(reply_desc->request_queue_id) - 1;
@@ -4394,6 +4394,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		goto out_failed_noretry;
 	}
 
+	mrioc->io_admin_reset_sync = 0;
 	if (is_resume || mrioc->block_on_pci_err) {
 		dprint_reset(mrioc, "setting up single ISR\n");
 		retval = mpi3mr_setup_isr(mrioc, 1);
@@ -5252,6 +5253,55 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
 	drv_cmd->retry_count = 0;
 }
 
+/**
+ * mpi3mr_check_op_admin_proc -
+ * @mrioc: Adapter instance reference
+ *
+ * Check if any of the operation reply queues
+ * or the admin reply queue are currently in use.
+ * If any queue is in use, this function waits for
+ * a maximum of 10 seconds for them to become available.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+static int mpi3mr_check_op_admin_proc(struct mpi3mr_ioc *mrioc)
+{
+
+	u16 timeout = 10 * 10;
+	u16 elapsed_time = 0;
+	bool op_admin_in_use = false;
+
+	do {
+		op_admin_in_use = false;
+
+		/* Check admin_reply queue first to exit early */
+		if (atomic_read(&mrioc->admin_reply_q_in_use) == 1)
+			op_admin_in_use = true;
+		else {
+			/* Check op_reply queues */
+			int i;
+
+			for (i = 0; i < mrioc->num_queues; i++) {
+				if (atomic_read(&mrioc->op_reply_qinfo[i].in_use) == 1) {
+					op_admin_in_use = true;
+					break;
+				}
+			}
+		}
+
+		if (!op_admin_in_use)
+			break;
+
+		msleep(100);
+
+	} while (++elapsed_time < timeout);
+
+	if (op_admin_in_use)
+		return 1;
+
+	return 0;
+}
+
 /**
  * mpi3mr_soft_reset_handler - Reset the controller
  * @mrioc: Adapter instance reference
@@ -5332,6 +5382,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	mpi3mr_wait_for_host_io(mrioc, MPI3MR_RESET_HOST_IOWAIT_TIMEOUT);
 
 	mpi3mr_ioc_disable_intr(mrioc);
+	mrioc->io_admin_reset_sync = 1;
 
 	if (snapdump) {
 		mpi3mr_set_diagsave(mrioc);
@@ -5359,6 +5410,16 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		ioc_err(mrioc, "Failed to issue soft reset to the ioc\n");
 		goto out;
 	}
+
+	retval = mpi3mr_check_op_admin_proc(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "Soft reset failed due to an Admin or I/O queue polling\n"
+				"thread still processing replies even after a 10 second\n"
+				"timeout. Marking the controller as unrecoverable!\n");
+
+		goto out;
+	}
+
 	if (mrioc->num_io_throttle_group !=
 	    mrioc->facts.max_io_throttle_group) {
 		ioc_err(mrioc,
-- 
2.39.5



