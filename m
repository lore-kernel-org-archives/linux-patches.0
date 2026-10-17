Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A75D3B531D;
	Sat, 17 Oct 2026 17:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257991; cv=none; b=NOKxqHLSmiQAzt2Fvwq+hptEEXTrCgjrQGVz3uByNCQVf67pViUCXQLLX3YpUpi/t/8HrMfu5+Q5FDL32ZlQ/vELeiub0erv2U0YAes5DmDPDZCkCMjX7vOsbf/1JOPOuSH+zor4c4Zw8T/pUzFpDSSngKFCrzgfUgJFMnHsUoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257991; c=relaxed/simple;
	bh=+MXdnjgGySv9pLOnNlsgfC3UZsRZxGCclccMmQs+GUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1pIN1nIgdhBCx0rXhNwCMRBYB+9hdjlKhmJ19ZTgzqBi/J9yVUTm1KCHVvFXERXFbYPqxjR1ELzvN8GfIXFhM6Keiy08eYgzTOqdyl9VUgrqf/RBeIGw44yFmVK2BNsdMmXpvsusRHfxomjt+AzwzVvy5ycOKhKlVSxUQBvqnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eh+6d8p/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eh+6d8p/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED1F1F000C4;
	Sat, 17 Oct 2026 17:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257990;
	bh=Py0pqjGSEvnHQKb0Zsh/cqdxELQEikFF6kv5mYmUaRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eh+6d8p/njUTWytLAI08ir7cNuKV5GfQ9/AupEP9biqjguV6fGr0OvJcboY5E0pdd
	 K57VJcD22yLfiRd86Uogf2uX2tFBR0L4TmBfD+FmhSjJaenm9rjI7Q4Z1ZtcAmQG74
	 z/oKb9mg7Gp+xW9UWXqOrHWQBq/YPzDBLBPSXdik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0735/1674] scsi: mpi3mr: Split off bus_reset function from host_reset
Date: Sat, 17 Oct 2026 17:50:07 +0200
Message-ID: <20261017160449.969501341@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 82b2fb52d6ecc3c902b46b3f9bb4325ab3f6d50d ]

SCSI EH host reset is the final callback in the escalation chain; once we
reach this we need to reset the controller.  As such it defeats the purpose
to skip controller reset if no I/Os are pending and the RAID device is to
be reset; especially after kexec there might be stale commands pending in
firmware for which we have no reference whatsoever.  So this patch splits
off the check for pending I/O into a 'bus_reset' function, and leaves the
actual controller reset to the host reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20231002154328.43718-19-hare@suse.de
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: f195fc060c73 ("scsi: mpi3mr: Synchronous access b/w reset and tm thread for reply queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 57 +++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 1bf3572c7aac4..f257721033841 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4053,20 +4053,45 @@ static inline void mpi3mr_setup_divert_ws(struct mpi3mr_ioc *mrioc,
  * mpi3mr_eh_host_reset - Host reset error handling callback
  * @scmd: SCSI command reference
  *
- * Issue controller reset if the scmd is for a Physical Device,
- * if the scmd is for RAID volume, then wait for
- * MPI3MR_RAID_ERRREC_RESET_TIMEOUT and checke whether any
- * pending I/Os prior to issuing reset to the controller.
+ * Issue controller reset
  *
  * Return: SUCCESS of successful reset else FAILED
  */
 static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
+{
+	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
+	int retval = FAILED, ret;
+
+	ret = mpi3mr_soft_reset_handler(mrioc,
+	    MPI3MR_RESET_FROM_EH_HOS, 1);
+	if (ret)
+		goto out;
+
+	retval = SUCCESS;
+out:
+	sdev_printk(KERN_INFO, scmd->device,
+	    "Host reset is %s for scmd(%p)\n",
+	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+
+	return retval;
+}
+
+/**
+ * mpi3mr_eh_bus_reset - Bus reset error handling callback
+ * @scmd: SCSI command reference
+ *
+ * Checks whether pending I/Os are present for the RAID volume;
+ * if not there's no need to reset the adapter.
+ *
+ * Return: SUCCESS of successful reset else FAILED
+ */
+static int mpi3mr_eh_bus_reset(struct scsi_cmnd *scmd)
 {
 	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
 	struct mpi3mr_stgt_priv_data *stgt_priv_data;
 	struct mpi3mr_sdev_priv_data *sdev_priv_data;
 	u8 dev_type = MPI3_DEVICE_DEVFORM_VD;
-	int retval = FAILED, ret;
+	int retval = FAILED;
 
 	sdev_priv_data = scmd->device->hostdata;
 	if (sdev_priv_data && sdev_priv_data->tgt_priv_data) {
@@ -4076,25 +4101,16 @@ static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
 
 	if (dev_type == MPI3_DEVICE_DEVFORM_VD) {
 		mpi3mr_wait_for_host_io(mrioc,
-		    MPI3MR_RAID_ERRREC_RESET_TIMEOUT);
-		if (!mpi3mr_get_fw_pending_ios(mrioc)) {
+			MPI3MR_RAID_ERRREC_RESET_TIMEOUT);
+		if (!mpi3mr_get_fw_pending_ios(mrioc))
 			retval = SUCCESS;
-			goto out;
-		}
 	}
+	if (retval == FAILED)
+		mpi3mr_print_pending_host_io(mrioc);
 
-	mpi3mr_print_pending_host_io(mrioc);
-	ret = mpi3mr_soft_reset_handler(mrioc,
-	    MPI3MR_RESET_FROM_EH_HOS, 1);
-	if (ret)
-		goto out;
-
-	retval = SUCCESS;
-out:
 	sdev_printk(KERN_INFO, scmd->device,
-	    "Host reset is %s for scmd(%p)\n",
-	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
-
+		"Bus reset is %s for scmd(%p)\n",
+		((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
 	return retval;
 }
 
@@ -4941,6 +4957,7 @@ static const struct scsi_host_template mpi3mr_driver_template = {
 	.change_queue_depth		= mpi3mr_change_queue_depth,
 	.eh_device_reset_handler	= mpi3mr_eh_dev_reset,
 	.eh_target_reset_handler	= mpi3mr_eh_target_reset,
+	.eh_bus_reset_handler		= mpi3mr_eh_bus_reset,
 	.eh_host_reset_handler		= mpi3mr_eh_host_reset,
 	.bios_param			= mpi3mr_bios_param,
 	.map_queues			= mpi3mr_map_queues,
-- 
2.53.0



