Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616EC19D071;
	Thu, 12 Mar 2026 20:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346514; cv=none; b=iM8GBCU+ckiYowRhBFvM6M5mwEX4bSvVgvt630GuxfQbgll0omR3cu90zOi//6H606vSOKld2dksZ6CbIGCOuhZwoxBrmLWA3EPywMmgiXRBRM1zm0Q67wLOEQUNQeFzejX6jB4nEXmOXfoGcrorRsSDS5k8RkZwAJBFEm82+UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346514; c=relaxed/simple;
	bh=zZPuxveP2xWdjeJwC31mh+FpA/StiS5PzWNe7MKA2Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4kUAO/dL1TcmsuLAVte2SPFjo3bkrSNIq3VPxS1kDMbYIfur8C2k/Oaw+CDNtJJnm8h/hdeZLmcHglVc9Nl87KpnRJ+DD6KpmdHmOr6cuTUHOCjgQU9lrI36+cPh4DgtnIeH/w/Sv3u1qWuCqJ+PjSCMiWCktH9hD8lZb44rAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rk/fhZSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rk/fhZSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0488C4CEF7;
	Thu, 12 Mar 2026 20:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346514;
	bh=zZPuxveP2xWdjeJwC31mh+FpA/StiS5PzWNe7MKA2Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rk/fhZSZ1iwrGuR8uiJeEc/c2mHoKpUvxW2X03SLuLGUCwF6XMvspbPJgjn8cu+Pw
	 bQNqfGRHGroknCwqQGyI4AnCY/JWBgsZNX6YF9lOXqKK76OnUu/3jZNeD7TMq+zmXZ
	 k/Ox6AhBuJKbmnU1G9v6GCpMpTzzbNTwhg9pdFac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/265] ata: libata-scsi: avoid Non-NCQ command starvation
Date: Thu, 12 Mar 2026 21:07:29 +0100
Message-ID: <20260312201020.452491807@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

[ Upstream commit 0ea84089dbf62a92dc7889c79e6b18fc89260808 ]

When a non-NCQ command is issued while NCQ commands are being executed,
ata_scsi_qc_issue() indicates to the SCSI layer that the command issuing
should be deferred by returning SCSI_MLQUEUE_XXX_BUSY.  This command
deferring is correct and as mandated by the ACS specifications since
NCQ and non-NCQ commands cannot be mixed.

However, in the case of a host adapter using multiple submission queues,
when the target device is under a constant load of NCQ commands, there
are no guarantees that requeueing the non-NCQ command will be executed
later and it may be deferred again repeatedly as other submission queues
can constantly issue NCQ commands from different CPUs ahead of the
non-NCQ command. This can lead to very long delays for the execution of
non-NCQ commands, and even complete starvation for these commands in the
worst case scenario.

Since the block layer and the SCSI layer do not distinguish between
queueable (NCQ) and non queueable (non-NCQ) commands, libata-scsi SAT
implementation must ensure forward progress for non-NCQ commands in the
presence of NCQ command traffic. This is similar to what SAS HBAs with a
hardware/firmware based SAT implementation do.

Implement such forward progress guarantee by limiting requeueing of
non-NCQ commands from ata_scsi_qc_issue(): when a non-NCQ command is
received and NCQ commands are in-flight, do not force a requeue of the
non-NCQ command by returning SCSI_MLQUEUE_XXX_BUSY and instead return 0
to indicate that the command was accepted but hold on to the qc using
the new deferred_qc field of struct ata_port.

This deferred qc will be issued using the work item deferred_qc_work
running the function ata_scsi_deferred_qc_work() once all in-flight
commands complete, which is checked with the port qc_defer() callback
return value indicating that no further delay is necessary. This check
is done using the helper function ata_scsi_schedule_deferred_qc() which
is called from ata_scsi_qc_complete(). This thus excludes this mechanism
from all internal non-NCQ commands issued by ATA EH.

When a port deferred_qc is non NULL, that is, the port has a command
waiting for the device queue to drain, the issuing of all incoming
commands (both NCQ and non-NCQ) is deferred using the regular busy
mechanism. This simplifies the code and also avoids potential denial of
service problems if a user issues too many non-NCQ commands.

Finally, whenever ata EH is scheduled, regardless of the reason, a
deferred qc is always requeued so that it can be retried once EH
completes. This is done by calling the function
ata_scsi_requeue_deferred_qc() from ata_eh_set_pending(). This avoids
the need for any special processing for the deferred qc in case of NCQ
error, link or device reset, or device timeout.

Reported-by: Xingui Yang <yangxingui@huawei.com>
Reported-by: Igor Pylypiv <ipylypiv@google.com>
Fixes: bdb01301f3ea ("scsi: Add host and host template flag 'host_tagset'")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Tested-by: Igor Pylypiv <ipylypiv@google.com>
Tested-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c |  5 +++
 drivers/ata/libata-eh.c   |  6 +++
 drivers/ata/libata-scsi.c | 93 +++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata.h      |  2 +
 include/linux/libata.h    |  3 ++
 5 files changed, 109 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2b1cb2998331d..42fbacd94a8a1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5521,6 +5521,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	mutex_init(&ap->scsi_scan_mutex);
 	INIT_DELAYED_WORK(&ap->hotplug_task, ata_scsi_hotplug);
 	INIT_DELAYED_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
+	INIT_WORK(&ap->deferred_qc_work, ata_scsi_deferred_qc_work);
 	INIT_LIST_HEAD(&ap->eh_done_q);
 	init_waitqueue_head(&ap->eh_wait_q);
 	init_completion(&ap->park_req_pending);
@@ -6131,6 +6132,10 @@ static void ata_port_detach(struct ata_port *ap)
 		}
 	}
 
+	/* Make sure the deferred qc work finished. */
+	cancel_work_sync(&ap->deferred_qc_work);
+	WARN_ON(ap->deferred_qc);
+
 	/* Tell EH to disable all devices */
 	ap->pflags |= ATA_PFLAG_UNLOADING;
 	ata_port_schedule_eh(ap);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index bd910dda8c0b1..2417bba84cf50 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -920,6 +920,12 @@ static void ata_eh_set_pending(struct ata_port *ap, int fastdrain)
 
 	ap->pflags |= ATA_PFLAG_EH_PENDING;
 
+	/*
+	 * If we have a deferred qc, requeue it so that it is retried once EH
+	 * completes.
+	 */
+	ata_scsi_requeue_deferred_qc(ap);
+
 	if (!fastdrain)
 		return;
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d27bf8e2b69cc..37fb635f553ef 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1671,8 +1671,77 @@ static void ata_qc_done(struct ata_queued_cmd *qc)
 	done(cmd);
 }
 
+void ata_scsi_deferred_qc_work(struct work_struct *work)
+{
+	struct ata_port *ap =
+		container_of(work, struct ata_port, deferred_qc_work);
+	struct ata_queued_cmd *qc;
+	unsigned long flags;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	/*
+	 * If we still have a deferred qc and we are not in EH, issue it. In
+	 * such case, we should not need any more deferring the qc, so warn if
+	 * qc_defer() says otherwise.
+	 */
+	qc = ap->deferred_qc;
+	if (qc && !ata_port_eh_scheduled(ap)) {
+		WARN_ON_ONCE(ap->ops->qc_defer(qc));
+		ap->deferred_qc = NULL;
+		ata_qc_issue(qc);
+	}
+
+	spin_unlock_irqrestore(ap->lock, flags);
+}
+
+void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc = ap->deferred_qc;
+	struct scsi_cmnd *scmd;
+
+	lockdep_assert_held(ap->lock);
+
+	/*
+	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
+	 * do not try to be smart about what to do with this deferred command
+	 * and simply retry it by completing it with DID_SOFT_ERROR.
+	 */
+	if (!qc)
+		return;
+
+	scmd = qc->scsicmd;
+	ap->deferred_qc = NULL;
+	ata_qc_free(qc);
+	scmd->result = (DID_SOFT_ERROR << 16);
+	scsi_done(scmd);
+}
+
+static void ata_scsi_schedule_deferred_qc(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc = ap->deferred_qc;
+
+	lockdep_assert_held(ap->lock);
+
+	/*
+	 * If we have a deferred qc, then qc_defer() is defined and we can use
+	 * this callback to determine if this qc is good to go, unless EH has
+	 * been scheduled.
+	 */
+	if (!qc)
+		return;
+
+	if (ata_port_eh_scheduled(ap)) {
+		ata_scsi_requeue_deferred_qc(ap);
+		return;
+	}
+	if (!ap->ops->qc_defer(qc))
+		queue_work(system_highpri_wq, &ap->deferred_qc_work);
+}
+
 static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 {
+	struct ata_port *ap = qc->ap;
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	u8 *cdb = cmd->cmnd;
 	bool have_sense = qc->flags & ATA_QCFLAG_SENSE_VALID;
@@ -1700,6 +1769,8 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 	}
 
 	ata_qc_done(qc);
+
+	ata_scsi_schedule_deferred_qc(ap);
 }
 
 static int ata_scsi_qc_issue(struct ata_port *ap, struct ata_queued_cmd *qc)
@@ -1709,6 +1780,16 @@ static int ata_scsi_qc_issue(struct ata_port *ap, struct ata_queued_cmd *qc)
 	if (!ap->ops->qc_defer)
 		goto issue;
 
+	/*
+	 * If we already have a deferred qc, then rely on the SCSI layer to
+	 * requeue and defer all incoming commands until the deferred qc is
+	 * processed, once all on-going commands complete.
+	 */
+	if (ap->deferred_qc) {
+		ata_qc_free(qc);
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+	}
+
 	/* Check if the command needs to be deferred. */
 	ret = ap->ops->qc_defer(qc);
 	switch (ret) {
@@ -1727,6 +1808,18 @@ static int ata_scsi_qc_issue(struct ata_port *ap, struct ata_queued_cmd *qc)
 	}
 
 	if (ret) {
+		/*
+		 * We must defer this qc: if this is not an NCQ command, keep
+		 * this qc as a deferred one and report to the SCSI layer that
+		 * we issued it so that it is not requeued. The deferred qc will
+		 * be issued with the port deferred_qc_work once all on-going
+		 * commands complete.
+		 */
+		if (!ata_is_ncq(qc->tf.protocol)) {
+			ap->deferred_qc = qc;
+			return 0;
+		}
+
 		/* Force a requeue of the command to defer its execution. */
 		ata_qc_free(qc);
 		return ret;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 2d6f7231dcba5..1a2d0f7115b5f 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -166,6 +166,8 @@ void ata_scsi_sdev_config(struct scsi_device *sdev);
 int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
 		struct ata_device *dev);
 int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev);
+void ata_scsi_deferred_qc_work(struct work_struct *work);
+void ata_scsi_requeue_deferred_qc(struct ata_port *ap);
 
 /* libata-eh.c */
 extern unsigned int ata_internal_cmd_timeout(struct ata_device *dev, u8 cmd);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 50cb59402cb17..14c835f5d661e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -897,6 +897,9 @@ struct ata_port {
 	u64			qc_active;
 	int			nr_active_links; /* #links with active qcs */
 
+	struct work_struct	deferred_qc_work;
+	struct ata_queued_cmd	*deferred_qc;
+
 	struct ata_link		link;		/* host default link */
 	struct ata_link		*slave_link;	/* see ata_slave_link_init() */
 
-- 
2.51.0



