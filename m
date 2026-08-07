Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925B1280331;
	Fri,  7 Aug 2026 15:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117433; cv=none; b=uSh1JejOmCBbnxirKqeCFE2gmbuGbNJNt9CQoacrPSnyAChonpJFRqw4yMTZYIIXoZNmvHBbKB/2NBmCVC3HBfr2Nqkei1ACXZIk6iYssnWNbh+q7f4V23aj1L+P/x4jbAhfJf5mGu/zFo3K59lYYvgzY3cv40y0bCgpHI6WzTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117433; c=relaxed/simple;
	bh=KFvJ9Qp8yoCkathvD1SDZn0FP7G5emTpMZvFUE3S/V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdkAdRqqr+2BQl4e/RADhC1njk3/3P/SG6WaodhQUeykN/hZrvaYQ/EnXdAkoG4kr640igODjsldEf+DmwK/APkcEK/M6rmEOS+DRo1cjy20j4imI92C4XOZagd/w7WQp1X7+9P1KtrDt821B6Z8kAXwovziltdcRxePFgG05j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySbU0Vo4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySbU0Vo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19FE1F000E9;
	Fri,  7 Aug 2026 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117432;
	bh=jhR0K+IZv/DLm1nRvNJiw79NyMU7vySb892H3xzq0wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ySbU0Vo4cT86SB83TeZJUx4/4ScdFHcbIvTqsheNb4gm5YITc8Ug3XJTzlcQK34H8
	 iYlGys5firlrzuLdGdnochh1U6xarortl0qP9ptaR1IPqM1c49MyxOVIW/OxPefd7d
	 +bQJfz+CWg784uaEKjE2RLiWA6FsS7jB5YCs7tdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7.1 318/438] scsi: libsas: terminate deferred commands on time out
Date: Fri,  7 Aug 2026 16:38:34 +0200
Message-ID: <20260807143434.749063396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit de202d2251bc181c6019b1ad3c0ba8133e5ec68d upstream.

If a command times out while we have deferred non-NCQ commands waiting to
be issued, the SCSI EH task is not immediately woken up as the waiting
deferred commands are never issued nor completed, thus leaving the SCSI
host in a busy state (shost->host_failed != scsi_host_busy(shost)) which
prevents the SCSI EH task from being woken up. Eventually, when the
deferred commands also time out, the SCSI EH task is woken up and the
timeout processing occurs.

Avoid this unnecessary additional SCSI EH wake up time with the same
method as implemented in libata-scsi, using the eh_timed_out SCSI host
template operation. The function sas_eh_timed_out() implements this
operation and executes the function ata_scsi_retry_deferred_qc()
for SATA devices.

Co-developed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c           |    5 +++--
 drivers/scsi/libsas/sas_scsi_host.c |   15 +++++++++++++++
 include/linux/libata.h              |    2 ++
 include/scsi/libsas.h               |    2 ++
 4 files changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1784,8 +1784,8 @@ static void ata_scsi_schedule_deferred_q
 		queue_work(system_highpri_wq, &link->deferred_qc_work);
 }
 
-static enum scsi_timeout_action
-ata_scsi_retry_deferred_qc(struct ata_port *ap, struct scsi_cmnd *scmd)
+enum scsi_timeout_action ata_scsi_retry_deferred_qc(struct ata_port *ap,
+						    struct scsi_cmnd *scmd)
 {
 	enum scsi_timeout_action action;
 	unsigned long flags;
@@ -1796,6 +1796,7 @@ ata_scsi_retry_deferred_qc(struct ata_po
 
 	return action;
 }
+EXPORT_SYMBOL_GPL(ata_scsi_retry_deferred_qc);
 
 enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *scmd)
 {
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -502,6 +502,21 @@ int sas_eh_target_reset_handler(struct s
 }
 EXPORT_SYMBOL_GPL(sas_eh_target_reset_handler);
 
+/*
+ * Handle deferred QCs in case of a command timeout.
+ * See ata_scsi_eh_timed_out() for details.
+ */
+enum scsi_timeout_action sas_eh_timed_out(struct scsi_cmnd *cmd)
+{
+	struct domain_device *dev = cmd_to_domain_dev(cmd);
+
+	if (dev_is_sata(dev))
+		return ata_scsi_retry_deferred_qc(dev->sata_dev.ap, cmd);
+
+	return SCSI_EH_NOT_HANDLED;
+}
+EXPORT_SYMBOL_GPL(sas_eh_timed_out);
+
 /* Try to reset a device */
 static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
 {
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1152,6 +1152,8 @@ extern int ata_scsi_ioctl(struct scsi_de
 #endif
 extern enum scsi_qc_status ata_scsi_queuecmd(struct Scsi_Host *h,
 					     struct scsi_cmnd *cmd);
+enum scsi_timeout_action ata_scsi_retry_deferred_qc(struct ata_port *ap,
+						    struct scsi_cmnd *scmd);
 enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *cmd);
 #if IS_REACHABLE(CONFIG_ATA)
 bool ata_scsi_dma_need_drain(struct request *rq);
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -704,6 +704,7 @@ void sas_task_abort(struct sas_task *);
 int sas_eh_abort_handler(struct scsi_cmnd *cmd);
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
 int sas_eh_target_reset_handler(struct scsi_cmnd *cmd);
+enum scsi_timeout_action sas_eh_timed_out(struct scsi_cmnd *cmd);
 
 extern void sas_target_destroy(struct scsi_target *);
 extern int sas_sdev_init(struct scsi_device *);
@@ -742,6 +743,7 @@ void sas_notify_phy_event(struct asd_sas
 	.this_id			= -1,				\
 	.eh_device_reset_handler	= sas_eh_device_reset_handler,	\
 	.eh_target_reset_handler	= sas_eh_target_reset_handler,	\
+	.eh_timed_out			= sas_eh_timed_out,		\
 	.target_destroy			= sas_target_destroy,		\
 	.ioctl				= sas_ioctl,			\
 


