Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A632E11722;
	Thu, 11 Jan 2024 09:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZHpvOXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3F4C433C7;
	Thu, 11 Jan 2024 09:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704966797;
	bh=CkYjMVcKvI/65NQDbeHkm7OON4jB8VtP5R3ZshpJehQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZHpvOXgOjA9NXLAtfAi4Bw8deFVi8EAYNHS3P9V8K5KxHcvyNYqB+mXSvq5R/ElH
	 XXEywwbZVSZscC1V+2etBhVv4lODu8om1eUIBasUdtbANLFvLzcYF8mBCnCJf88eQx
	 UuKmEnm/dQ9XLDIfIEfpIGZMEeyLwa1szdcrUZn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@ucw.cz>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.com>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Benjamin Block <bblock@linux.ibm.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 2/7] Revert "scsi: core: Use a structure member to track the SCSI command submitter"
Date: Thu, 11 Jan 2024 10:52:51 +0100
Message-ID: <20240111094700.338657759@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240111094700.222742213@linuxfoundation.org>
References: <20240111094700.222742213@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit f2d30198c0530b8da155697d8723e19ac72c15fe which is
commit bf23e619039d360d503b7282d030daf2277a5d47 upstream.

As reported, a lot of scsi changes were made just to resolve a 2 line
patch, so let's revert them all and then manually fix up the 2 line
fixup so that things are simpler and potential abi changes are not an
issue.

Link: https://lore.kernel.org/r/ZZ042FejzwMM5vDW@duo.ucw.cz
Reported-by: Pavel Machek <pavel@ucw.cz>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Benjamin Block <bblock@linux.ibm.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_error.c |   17 +++++++++++------
 drivers/scsi/scsi_lib.c   |   10 ----------
 drivers/scsi/scsi_priv.h  |    1 -
 include/scsi/scsi_cmnd.h  |    7 -------
 4 files changed, 11 insertions(+), 24 deletions(-)

--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -50,6 +50,8 @@
 
 #include <asm/unaligned.h>
 
+static void scsi_eh_done(struct scsi_cmnd *scmd);
+
 /*
  * These should *probably* be handled by the host itself.
  * Since it is allowed to sleep, it probably should.
@@ -498,8 +500,7 @@ int scsi_check_sense(struct scsi_cmnd *s
 		/* handler does not care. Drop down to default handling */
 	}
 
-	if (scmd->cmnd[0] == TEST_UNIT_READY &&
-	    scmd->submitter != SUBMITTED_BY_SCSI_ERROR_HANDLER)
+	if (scmd->cmnd[0] == TEST_UNIT_READY && scmd->scsi_done != scsi_eh_done)
 		/*
 		 * nasty: for mid-layer issued TURs, we need to return the
 		 * actual sense data without any recovery attempt.  For eh
@@ -767,7 +768,7 @@ static int scsi_eh_completed_normally(st
  * scsi_eh_done - Completion function for error handling.
  * @scmd:	Cmd that is done.
  */
-void scsi_eh_done(struct scsi_cmnd *scmd)
+static void scsi_eh_done(struct scsi_cmnd *scmd)
 {
 	struct completion *eh_action;
 
@@ -1067,7 +1068,7 @@ retry:
 	shost->eh_action = &done;
 
 	scsi_log_send(scmd);
-	scmd->submitter = SUBMITTED_BY_SCSI_ERROR_HANDLER;
+	scmd->scsi_done = scsi_eh_done;
 
 	/*
 	 * Lock sdev->state_mutex to avoid that scsi_device_quiesce() can
@@ -1094,7 +1095,6 @@ retry:
 	if (rtn) {
 		if (timeleft > stall_for) {
 			scsi_eh_restore_cmnd(scmd, &ses);
-
 			timeleft -= stall_for;
 			msleep(jiffies_to_msecs(stall_for));
 			goto retry;
@@ -2322,6 +2322,11 @@ void scsi_report_device_reset(struct Scs
 }
 EXPORT_SYMBOL(scsi_report_device_reset);
 
+static void
+scsi_reset_provider_done_command(struct scsi_cmnd *scmd)
+{
+}
+
 /**
  * scsi_ioctl_reset: explicitly reset a host/bus/target/device
  * @dev:	scsi_device to operate on
@@ -2358,7 +2363,7 @@ scsi_ioctl_reset(struct scsi_device *dev
 	scmd->request = rq;
 	scmd->cmnd = scsi_req(rq)->cmd;
 
-	scmd->submitter = SUBMITTED_BY_SCSI_RESET_IOCTL;
+	scmd->scsi_done		= scsi_reset_provider_done_command;
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 
 	scmd->cmd_len			= 0;
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1596,15 +1596,6 @@ static blk_status_t scsi_prepare_cmd(str
 
 static void scsi_mq_done(struct scsi_cmnd *cmd)
 {
-	switch (cmd->submitter) {
-	case SUBMITTED_BY_BLOCK_LAYER:
-		break;
-	case SUBMITTED_BY_SCSI_ERROR_HANDLER:
-		return scsi_eh_done(cmd);
-	case SUBMITTED_BY_SCSI_RESET_IOCTL:
-		return;
-	}
-
 	if (unlikely(blk_should_fake_timeout(scsi_cmd_to_rq(cmd)->q)))
 		return;
 	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))
@@ -1694,7 +1685,6 @@ static blk_status_t scsi_queue_rq(struct
 
 	scsi_set_resid(cmd, 0);
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
 	cmd->scsi_done = scsi_mq_done;
 
 	blk_mq_start_request(req);
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -82,7 +82,6 @@ void scsi_eh_ready_devs(struct Scsi_Host
 int scsi_eh_get_sense(struct list_head *work_q,
 		      struct list_head *done_q);
 int scsi_noretry_cmd(struct scsi_cmnd *scmd);
-void scsi_eh_done(struct scsi_cmnd *scmd);
 
 /* scsi_lib.c */
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -65,12 +65,6 @@ struct scsi_pointer {
 #define SCMD_STATE_COMPLETE	0
 #define SCMD_STATE_INFLIGHT	1
 
-enum scsi_cmnd_submitter {
-	SUBMITTED_BY_BLOCK_LAYER = 0,
-	SUBMITTED_BY_SCSI_ERROR_HANDLER = 1,
-	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
-} __packed;
-
 struct scsi_cmnd {
 	struct scsi_request req;
 	struct scsi_device *device;
@@ -94,7 +88,6 @@ struct scsi_cmnd {
 	unsigned char prot_op;
 	unsigned char prot_type;
 	unsigned char prot_flags;
-	enum scsi_cmnd_submitter submitter;
 
 	unsigned short cmd_len;
 	enum dma_data_direction sc_data_direction;


