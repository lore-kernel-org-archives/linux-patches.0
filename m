Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823C76FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D801DC433C9;
	Sun, 17 Sep 2023 19:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979812;
	bh=oSX4Ty6fo3MERBXNLFDKvRHBZCiCJENgzh0JLDl7G/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2VWUrxLxeqbI375Yc0OUm3NLHSyF37jroNcYuCPS1JnMsuMf+VXD4k34hbA2sJqS
	 2lFEhqDfWaZtobuwhFqFX3rQvpvprLqM0uG4BIrVwgIOB0cThzXXlmqG4eMT33VMR4
	 6owr/v0+0NcTeBITf2iGDaFKYXVhbqruHsGq7jv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <quinn.tran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.5 014/285] scsi: qla2xxx: Flush mailbox commands on chip reset
Date: Sun, 17 Sep 2023 21:10:14 +0200
Message-ID: <20230917191052.116453915@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quinn Tran <qutran@marvell.com>

commit 6d0b65569c0a10b27c49bacd8d25bcd406003533 upstream.

Fix race condition between Interrupt thread and Chip reset thread in trying
to flush the same mailbox. With the race condition, the "ha->mbx_intr_comp"
will get an extra complete() call. The extra complete call create erroneous
mailbox timeout condition when the next mailbox is sent where the mailbox
call does not wait for interrupt to arrive. Instead, it advances without
waiting.

Add lock protection around the check for mailbox completion.

Cc: stable@vger.kernel.org
Fixes: b2000805a975 ("scsi: qla2xxx: Flush mailbox commands on chip reset")
Signed-off-by: Quinn Tran <quinn.tran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230821130045.34850-3-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |    1 -
 drivers/scsi/qla2xxx/qla_init.c |    7 ++++---
 drivers/scsi/qla2xxx/qla_mbx.c  |    4 ----
 drivers/scsi/qla2xxx/qla_os.c   |    1 -
 4 files changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4384,7 +4384,6 @@ struct qla_hw_data {
 	uint8_t		aen_mbx_count;
 	atomic_t	num_pend_mbx_stage1;
 	atomic_t	num_pend_mbx_stage2;
-	atomic_t	num_pend_mbx_stage3;
 	uint16_t	frame_payload_size;
 
 	uint32_t	login_retry_count;
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7390,14 +7390,15 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_
 	}
 
 	/* purge MBox commands */
-	if (atomic_read(&ha->num_pend_mbx_stage3)) {
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags)) {
 		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 		complete(&ha->mbx_intr_comp);
 	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	i = 0;
-	while (atomic_read(&ha->num_pend_mbx_stage3) ||
-	    atomic_read(&ha->num_pend_mbx_stage2) ||
+	while (atomic_read(&ha->num_pend_mbx_stage2) ||
 	    atomic_read(&ha->num_pend_mbx_stage1)) {
 		msleep(20);
 		i++;
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -273,7 +273,6 @@ qla2x00_mailbox_command(scsi_qla_host_t
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 		wait_time = jiffies;
-		atomic_inc(&ha->num_pend_mbx_stage3);
 		if (!wait_for_completion_timeout(&ha->mbx_intr_comp,
 		    mcp->tov * HZ)) {
 			ql_dbg(ql_dbg_mbx, vha, 0x117a,
@@ -290,7 +289,6 @@ qla2x00_mailbox_command(scsi_qla_host_t
 				spin_unlock_irqrestore(&ha->hardware_lock,
 				    flags);
 				atomic_dec(&ha->num_pend_mbx_stage2);
-				atomic_dec(&ha->num_pend_mbx_stage3);
 				rval = QLA_ABORTED;
 				goto premature_exit;
 			}
@@ -302,11 +300,9 @@ qla2x00_mailbox_command(scsi_qla_host_t
 			ha->flags.mbox_busy = 0;
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 			atomic_dec(&ha->num_pend_mbx_stage2);
-			atomic_dec(&ha->num_pend_mbx_stage3);
 			rval = QLA_ABORTED;
 			goto premature_exit;
 		}
-		atomic_dec(&ha->num_pend_mbx_stage3);
 
 		if (time_after(jiffies, wait_time + 5 * HZ))
 			ql_log(ql_log_warn, vha, 0x1015, "cmd=0x%x, waited %d msecs\n",
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3007,7 +3007,6 @@ qla2x00_probe_one(struct pci_dev *pdev,
 	ha->max_exchg = FW_MAX_EXCHANGES_CNT;
 	atomic_set(&ha->num_pend_mbx_stage1, 0);
 	atomic_set(&ha->num_pend_mbx_stage2, 0);
-	atomic_set(&ha->num_pend_mbx_stage3, 0);
 	atomic_set(&ha->zio_threshold, DEFAULT_ZIO_THRESHOLD);
 	ha->last_zio_threshold = DEFAULT_ZIO_THRESHOLD;
 	INIT_LIST_HEAD(&ha->tmf_pending);


