Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A3228C2BF;
	Thu, 20 Aug 2026 17:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247214; cv=none; b=AvbR6Ks4htrlI7XLrPAADlD8cVXEMh2dP7xAK139mQXQfqSYt40qHYvEHWejxnU2IeK44cTGKYjF+uj8PPeGXXFNdeVXr//3T16+B5M/VMoss5rObOHS181qci/GIES0U9ELGLzh86FQUzb00wbRd6k2mloU73D0RVG28Kp3KJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247214; c=relaxed/simple;
	bh=UAqE3RZWWaFzGM3Wy7u1JHih/+8jGmIsK+YFAJcIeUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHB/IJ6L91aZ3Lfccbxm9a50T7A0/DlFImKfJS9Bw2PsckVwImsg+QKoz4zbRjn+KWO8zfUusREgw4oiOHWht5MVe+9bulhjz8Xpj/V0uMsNiLJzUUSToHn95OgZ1YbdtuP52evciVPIgodSnyHt5wIGU40Yi0jpE9DdJKy0GYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGg2A2oq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGg2A2oq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479E21F00A3A;
	Thu, 20 Aug 2026 17:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247212;
	bh=dGBaImZkl2b5YvtTIDDbWZU6z24sUDlOL5Z78KjP8ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGg2A2oqMspm2VOZSlbpnHUEFQ/3HAHj88eJDm2ALOHgufRYn7eOnh25ZeUkZLnKR
	 vVGszqzLwUBQ+XhgbW3URKQW42LH8YfKGZo81RWw1oJ8J/RCMP7IAGiRbOaLKNrdmi
	 ihT7BCt7c2GY/PNaRmE5WFfM84x2WkZITgxk450I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/220] ata: libata-scsi: terminate deferred commands on time out
Date: Thu, 20 Aug 2026 16:55:39 +0200
Message-ID: <20260820145227.950383103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 2e1d2e65e773d67dab163127f11a47dab0fbca9f ]

If a command times out while we have deferred non-NCQ commands waiting to
be issued, the SCSI EH task is not immediately woken up as the waiting
deferred commands are never issued nor completed, thus leaving the SCSI
host in a busy state (shost->host_failed != scsi_host_busy(shost)) which
prevents the SCSI EH task from being woken up. Eventually, when the
deferred commands also time out, the SCSI EH task is woken up and the
timeout processing occurs.

Avoid this unnecessary SCSI EH task wake-up additional time by scheduling
a retry of all waiting deferred QCs, using the eh_timed_out SCSI host
template operation. The function ata_scsi_eh_timed_out() is introduced to
implement this operation.

However, terminating deferred commands with DID_REQUEUE to force a retry
by calling the function ata_scsi_requeue_deferred_qc() may still keep the
SCSI host in a busy state because the block layer may immediately re-issue
these commands. The solution to this is to schedule libata EH for the
port which suffered the command timeout to prevent accepting any new
command. ata_scsi_requeue_deferred_qc() is modified to add a call to
ata_port_schedule_eh() for this purpose.

In addition to this change, ata_scsi_requeue_deferred_qc() is also
modified to take a new timedout_scmd scsi command argument which indicates
the SCSI command that timed out. With this additional argument,
ata_scsi_requeue_deferred_qc() can now also terminate with DID_TIME_OUT
any timed out deferred qc, which simplifies ata_scsi_cmd_error_handler().
In this case, ata_scsi_requeue_deferred_qc() returns SCSI_EH_DONE, with
this return value propagated back to the ata_scsi_eh_timed_out() operation
to indicate to scsi_timeout() that the timed out command was handled and
no further processing is needed.

For non-timed out deferred qc that need to be retried,
ata_scsi_requeue_deferred_qc() returns SCSI_EH_NOT_HANDLED, thus
indicating to scsi_timeout() that the timed out command needs to go
through the SCSI EH (and libata EH) processing by adding it to the EH work
queue with scsi_eh_scmd_add().

One side effect of these changes is that the function atapi_qc_complete()
needs to be modified to ensure that a deferred ATAPI command that needs
to be retried is completed with DID_REQUEUE instead of the default
SAM_STAT_GOOD status, and a command that timed out is completed with
DID_TIME_OUT instead of SAM_STAT_CHECK_CONDITION.

Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Tested-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-eh.c   |   29 ++---------
 drivers/ata/libata-scsi.c |  115 ++++++++++++++++++++++++++++++++++++++++------
 drivers/ata/libata.h      |    3 -
 include/linux/libata.h    |    2 
 4 files changed, 110 insertions(+), 39 deletions(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -650,29 +650,12 @@ void ata_scsi_cmd_error_handler(struct S
 		set_host_byte(scmd, DID_OK);
 
 		ata_qc_for_each_raw(ap, qc, i) {
-			if (qc->scsicmd != scmd)
-				continue;
-			if ((qc->flags & ATA_QCFLAG_ACTIVE) ||
-			    qc == qc->dev->link->deferred_qc)
+			if (qc->scsicmd == scmd &&
+			    qc->flags & ATA_QCFLAG_ACTIVE)
 				break;
 		}
 
-		if (i < ATA_MAX_QUEUE && qc == qc->dev->link->deferred_qc) {
-			/*
-			 * This is a deferred command that timed out while
-			 * waiting for the command queue to drain. Since the qc
-			 * is not active yet (deferred_qc is still set, so the
-			 * deferred qc work has not issued the command yet),
-			 * simply signal the timeout by finishing the SCSI
-			 * command and clear the deferred qc to prevent the
-			 * deferred qc work from issuing this qc.
-			 */
-			WARN_ON_ONCE(qc->flags & ATA_QCFLAG_ACTIVE);
-			qc->dev->link->deferred_qc = NULL;
-			cancel_work(&qc->dev->link->deferred_qc_work);
-			set_host_byte(scmd, DID_TIME_OUT);
-			scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
-		} else if (i < ATA_MAX_QUEUE) {
+		if (i < ATA_MAX_QUEUE) {
 			/* the scmd has an associated qc */
 			if (!(qc->flags & ATA_QCFLAG_EH)) {
 				/* which hasn't failed yet, timeout */
@@ -946,10 +929,10 @@ static void ata_eh_set_pending(struct at
 	ap->pflags |= ATA_PFLAG_EH_PENDING;
 
 	/*
-	 * If we have a deferred qc, requeue it so that it is retried once EH
-	 * completes.
+	 * If we have deferred QCs, requeue them so that the SCSI EH task can
+	 * run.
 	 */
-	ata_scsi_requeue_deferred_qc(ap);
+	ata_scsi_requeue_deferred_qc(ap, NULL);
 
 	if (!fastdrain)
 		return;
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1694,30 +1694,81 @@ void ata_scsi_deferred_qc_work(struct wo
 	spin_unlock_irqrestore(ap->lock, flags);
 }
 
-void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
+enum scsi_timeout_action ata_scsi_requeue_deferred_qc(struct ata_port *ap,
+					struct scsi_cmnd *timedout_scmd)
 {
+	enum scsi_timeout_action action = SCSI_EH_NOT_HANDLED;
+	struct ata_queued_cmd *qc;
 	struct ata_link *link;
+	u32 host_byte;
 
 	lockdep_assert_held(ap->lock);
 
 	/*
-	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
-	 * do not try to be smart about what to do with this deferred command
-	 * and simply requeue it by completing it with DID_REQUEUE.
+	 * If we have deferred QCs when a reset, a timeout or an NCQ command
+	 * fails, do not try to be smart about what to do with the deferred
+	 * commands and simply terminate them and let the SCSI layer decide
+	 * what to do.
 	 */
 	ata_for_each_link(link, ap, PMP_FIRST) {
-		struct ata_queued_cmd *qc = link->deferred_qc;
-		struct scsi_cmnd *scmd;
+		qc = link->deferred_qc;
+		if (!qc)
+			continue;
+
+		/*
+		 * Clear the deferred QC so that the deferred work does not try
+		 * to issue it.
+		 */
+		link->deferred_qc = NULL;
+		cancel_work(&link->deferred_qc_work);
 
-		if (qc) {
-			scmd = qc->scsicmd;
-			link->deferred_qc = NULL;
-			cancel_work(&link->deferred_qc_work);
-			ata_qc_free(qc);
-			scmd->result = (DID_REQUEUE << 16);
-			scsi_done(scmd);
+		/*
+		 * We are going to complete some scsi command, either with
+		 * DID_TIME_OUT if the command timed out while waiting for being
+		 * issued, or with DID_REQUEUE if another command timed out or
+		 * we had a failed command. However, the block layer may re-issue
+		 * these commands immediately, keeping the scsi host busy and
+		 * thus preventing the SCSI EH task from running.
+		 * So schedule EH on the port to prevent accepting new commands
+		 * until everything is sorted out with the error or timeout that
+		 * got us here in the first place. Note that we set EH pending
+		 * on the port before calling ata_port_schedule_eh() so that we
+		 * do not reenter this function from ata_eh_set_pending() with
+		 * timedout_scmd being NULL and erroneously retry deferred QCs
+		 * that have timed out on other links.
+		 */
+		if (!ata_port_eh_scheduled(ap)) {
+			ap->pflags |= ATA_PFLAG_EH_PENDING;
+			ata_port_schedule_eh(ap);
 		}
+
+		/*
+		 * If we are being called from scsi_timeout(), then we have a
+		 * non-NULL timedout_scmd. If the timed out command is for a
+		 * deferred QC, terminate that deferred QC with DID_TIME_OUT and
+		 * requeue all other deferred QCs. In this case we need to
+		 * return SCSI_EH_DONE, because the timed out command was
+		 * handled.
+		 * If the timed out command is not for a deferred QC, we need to
+		 * requeue all deferred QCs, and return SCSI_EH_NOT_HANDLED so
+		 * that the timed out command gets added to the EH work queue
+		 * with scsi_eh_scmd_add(), for later handling with libata EH
+		 * ata_scsi_cmd_error_handler().
+		 * If timedout_scmd is NULL, we simply need to requeue all
+		 * deferred QCs and the return value does not matter as we were
+		 * not called from scsi_timeout().
+		 */
+		if (timedout_scmd && qc->scsicmd == timedout_scmd) {
+			host_byte = DID_TIME_OUT;
+			action = SCSI_EH_DONE;
+		} else {
+			host_byte = DID_REQUEUE;
+		}
+		qc->scsicmd->result = host_byte << 16;
+		ata_qc_done(qc);
 	}
+
+	return action;
 }
 
 static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
@@ -1736,13 +1787,41 @@ static void ata_scsi_schedule_deferred_q
 		return;
 
 	if (ata_port_eh_scheduled(ap)) {
-		ata_scsi_requeue_deferred_qc(ap);
+		ata_scsi_requeue_deferred_qc(ap, NULL);
 		return;
 	}
 	if (!ap->ops->qc_defer(qc))
 		queue_work(system_highpri_wq, &link->deferred_qc_work);
 }
 
+static enum scsi_timeout_action
+ata_scsi_retry_deferred_qc(struct ata_port *ap, struct scsi_cmnd *scmd)
+{
+	enum scsi_timeout_action action;
+	unsigned long flags;
+
+	spin_lock_irqsave(ap->lock, flags);
+	action = ata_scsi_requeue_deferred_qc(ap, scmd);
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	return action;
+}
+
+enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *scmd)
+{
+	struct ata_port *ap = ata_shost_to_port(scmd->device->host);
+
+	/*
+	 * ata_scsi_cmd_error_handler() takes care of commands that timed out
+	 * while executing. However, if we have deferred QCs while a timeout
+	 * triggers, we must requeue these commands for retry so that we do not
+	 * unnecessarily delay starting the SCSI EH task until these deferred
+	 * commands also time out.
+	 */
+	return ata_scsi_retry_deferred_qc(ap, scmd);
+}
+EXPORT_SYMBOL_GPL(ata_scsi_eh_timed_out);
+
 static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 {
 	struct ata_link *link = qc->dev->link;
@@ -2945,7 +3024,13 @@ static void atapi_qc_complete(struct ata
 		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
 			qc->dev->sdev->locked = 0;
 
-		qc->scsicmd->result = SAM_STAT_CHECK_CONDITION;
+		if (!cmd->result)
+			cmd->result = SAM_STAT_CHECK_CONDITION;
+		ata_qc_done(qc);
+		return;
+	}
+
+	if (cmd->result) {
 		ata_qc_done(qc);
 		return;
 	}
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -176,7 +176,8 @@ int ata_scsi_dev_config(struct scsi_devi
 		struct ata_device *dev);
 int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev);
 void ata_scsi_deferred_qc_work(struct work_struct *work);
-void ata_scsi_requeue_deferred_qc(struct ata_port *ap);
+enum scsi_timeout_action ata_scsi_requeue_deferred_qc(struct ata_port *ap,
+						      struct scsi_cmnd *scmd);
 
 /* libata-eh.c */
 extern unsigned int ata_internal_cmd_timeout(struct ata_device *dev, u8 cmd);
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1148,6 +1148,7 @@ extern int ata_scsi_ioctl(struct scsi_de
 #define ATA_SCSI_COMPAT_IOCTL /* empty */
 #endif
 extern int ata_scsi_queuecmd(struct Scsi_Host *h, struct scsi_cmnd *cmd);
+enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *cmd);
 #if IS_REACHABLE(CONFIG_ATA)
 bool ata_scsi_dma_need_drain(struct request *rq);
 #else
@@ -1461,6 +1462,7 @@ extern const struct attribute_group *ata
 	.ioctl			= ata_scsi_ioctl,		\
 	ATA_SCSI_COMPAT_IOCTL					\
 	.queuecommand		= ata_scsi_queuecmd,		\
+	.eh_timed_out		= ata_scsi_eh_timed_out,	\
 	.dma_need_drain		= ata_scsi_dma_need_drain,	\
 	.this_id		= ATA_SHT_THIS_ID,		\
 	.emulated		= ATA_SHT_EMULATED,		\


