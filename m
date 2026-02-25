Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5962FF669;
	Wed, 25 Feb 2026 06:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002783; cv=none; b=H4AHdmbIFLWSrK6NbadRW/RT0/M6EUgzbxIYhi/ADzIfEWDbs6+do8i2SKKfxooqnUaDlJ/0eXA3FDE3WWvzEigHF8POvZR+Ds3QO942qDJQqTGq3pakVb4LKhNlKwoMhInptpl2m5imtbX6rP6mR1WelVgKMaosuHJPf/4XUco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002783; c=relaxed/simple;
	bh=LCfBlUP5QW7hjRWUUnaHFxRwIDzmq56IVbL0nDYEt7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Snvn0Vt2BN83tMBkAGKOlZfK7oMEDGhZU3pw8SVJOltq/Fx01M/vvkDv21pPTWgjLlxtE/HjTCFXbec6FCoonslyt3nwU+WvFFReWa48FJgzTNpqcYYK+BACsnP1igyDoDEG5h0eanIZptbh2Ye+80PZiY+bLXGPVUHAmzISxiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZcSSU9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZcSSU9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77421C116D0;
	Wed, 25 Feb 2026 06:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002783;
	bh=LCfBlUP5QW7hjRWUUnaHFxRwIDzmq56IVbL0nDYEt7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZcSSU9JW8l6FbieniQVWo6EKsMoq34/3kCwD20DTVx8xT/D9dGRLOI81GZv6Yt0/
	 9kfQKE1q7rJtIE4HKUZ5hzQtFr3JU2jSrXxhua7jDlt6VanockjWJI1uqSqyvysp4b
	 RKUuKgozPR/ViQqI1sAQ/TIHB5jf1EvvpfYJ8EX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH 6.18 624/641] ata: libata-scsi: avoid Non-NCQ command starvation
Date: Tue, 24 Feb 2026 17:25:50 -0800
Message-ID: <20260225012403.626504292@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 0ea84089dbf62a92dc7889c79e6b18fc89260808 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    5 ++
 drivers/ata/libata-eh.c   |    6 ++
 drivers/ata/libata-scsi.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata.h      |    2 
 include/linux/libata.h    |    3 +
 5 files changed, 109 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5552,6 +5552,7 @@ struct ata_port *ata_port_alloc(struct a
 	mutex_init(&ap->scsi_scan_mutex);
 	INIT_DELAYED_WORK(&ap->hotplug_task, ata_scsi_hotplug);
 	INIT_DELAYED_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
+	INIT_WORK(&ap->deferred_qc_work, ata_scsi_deferred_qc_work);
 	INIT_LIST_HEAD(&ap->eh_done_q);
 	init_waitqueue_head(&ap->eh_wait_q);
 	init_completion(&ap->park_req_pending);
@@ -6162,6 +6163,10 @@ static void ata_port_detach(struct ata_p
 		}
 	}
 
+	/* Make sure the deferred qc work finished. */
+	cancel_work_sync(&ap->deferred_qc_work);
+	WARN_ON(ap->deferred_qc);
+
 	/* Tell EH to disable all devices */
 	ap->pflags |= ATA_PFLAG_UNLOADING;
 	ata_port_schedule_eh(ap);
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -917,6 +917,12 @@ static void ata_eh_set_pending(struct at
 
 	ap->pflags |= ATA_PFLAG_EH_PENDING;
 
+	/*
+	 * If we have a deferred qc, requeue it so that it is retried once EH
+	 * completes.
+	 */
+	ata_scsi_requeue_deferred_qc(ap);
+
 	if (!fastdrain)
 		return;
 
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1657,8 +1657,77 @@ static void ata_qc_done(struct ata_queue
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
@@ -1688,6 +1757,8 @@ static void ata_scsi_qc_complete(struct
 	}
 
 	ata_qc_done(qc);
+
+	ata_scsi_schedule_deferred_qc(ap);
 }
 
 static int ata_scsi_qc_issue(struct ata_port *ap, struct ata_queued_cmd *qc)
@@ -1697,6 +1768,16 @@ static int ata_scsi_qc_issue(struct ata_
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
@@ -1715,6 +1796,18 @@ static int ata_scsi_qc_issue(struct ata_
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
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -161,6 +161,8 @@ void ata_scsi_sdev_config(struct scsi_de
 int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
 		struct ata_device *dev);
 int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev);
+void ata_scsi_deferred_qc_work(struct work_struct *work);
+void ata_scsi_requeue_deferred_qc(struct ata_port *ap);
 
 /* libata-eh.c */
 extern unsigned int ata_internal_cmd_timeout(struct ata_device *dev, u8 cmd);
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -899,6 +899,9 @@ struct ata_port {
 	u64			qc_active;
 	int			nr_active_links; /* #links with active qcs */
 
+	struct work_struct	deferred_qc_work;
+	struct ata_queued_cmd	*deferred_qc;
+
 	struct ata_link		link;		/* host default link */
 	struct ata_link		*slave_link;	/* see ata_slave_link_init() */
 


