Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3904D347FCC;
	Sat, 28 Feb 2026 18:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302437; cv=none; b=s42+owaW0O/4wmzPGvFOMvycQPLrXaSc2RKxNksmGyc6LcDp4sFD37uIeVV9p7QFfgFyQKs2128xesSV+citN+2Wy3c+8Cy9JA7rDgWFY7fXMyHQMY1gqbDlf74JqgmjePsDCLJhRvRGINmryt4ViMEmbXGkFBl7Ds0/nG2VA3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302437; c=relaxed/simple;
	bh=V843j5zIMt2bMiQD8atPRuwhRTpnan1j3Hm2pELodVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcS0A8Zw9uvpcDub7jWxR4+K3RNVHwbOamkdTNlAwW9dZ+MfHf5jSWYR+JVrJN1YWBFKEk8uDaGwBWEtvXk4L0VpHtrUroHzJlfAV6j13jRHpGTSkbS086ZVaKoiWZZIj05lLWgSqpF8nsVB7G2QwLsw0dqQSG9nWdcm71OBHEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0YF105C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0YF105C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08601C19423;
	Sat, 28 Feb 2026 18:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302436;
	bh=V843j5zIMt2bMiQD8atPRuwhRTpnan1j3Hm2pELodVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0YF105Ct1NeJ9/6EBnyIdE4vTvXUKV3NuqYN+XqbhqRpVW9fcms45fI8LBRQ2jJd
	 yFNawxdxtggIrlvzxF5mR+YcQkAdL9eeR8/+S10VdnsK1LVC6miFqN6pbDBdaZu4QI
	 JXvhJP5Qksj64uNPOC1rQ2qDyYivjsMtvifdvJNMrh/2Kef1AZaIzmzgNbs0TPFMFd
	 +cMVStUH2M4Oc6Krmnlg7dFl/jjMekyJ1gLO3sxcns86lwErXgRu5aeD+aPcG7U36E
	 xLWkQhpZcBPjFNVjGfhK4xxWF28lvWNU99SCrZ1Wxl8fYvR08XWFDublJSxSd3Fgga
	 z7gEH3x9yY+bA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Damien Le Moal <dlemoal@kernel.org>,
	stable@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.1 174/232] ata: libata-scsi: refactor ata_scsi_translate()
Date: Sat, 28 Feb 2026 13:10:27 -0500
Message-ID: <20260228181127.1592657-174-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <dlemoal@kernel.org>

commit bb3a8154b1a1dc2c86d037482c0a2cf9186829ed upstream.

Factor out of ata_scsi_translate() the code handling queued command
deferral using the port qc_defer callback and issuing the queued
command with ata_qc_issue() into the new function ata_scsi_qc_issue(),
and simplify the goto used in ata_scsi_translate().
While at it, also add a lockdep annotation to check that the port lock
is held when ata_scsi_translate() is called.

No functional changes.

Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c | 81 ++++++++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 31 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 430970db482a8..5e49265523084 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1724,6 +1724,42 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 	ata_qc_done(qc);
 }
 
+static int ata_scsi_qc_issue(struct ata_port *ap, struct ata_queued_cmd *qc)
+{
+	int ret;
+
+	if (!ap->ops->qc_defer)
+		goto issue;
+
+	/* Check if the command needs to be deferred. */
+	ret = ap->ops->qc_defer(qc);
+	switch (ret) {
+	case 0:
+		break;
+	case ATA_DEFER_LINK:
+		ret = SCSI_MLQUEUE_DEVICE_BUSY;
+		break;
+	case ATA_DEFER_PORT:
+		ret = SCSI_MLQUEUE_HOST_BUSY;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		ret = SCSI_MLQUEUE_HOST_BUSY;
+		break;
+	}
+
+	if (ret) {
+		/* Force a requeue of the command to defer its execution. */
+		ata_qc_free(qc);
+		return ret;
+	}
+
+issue:
+	ata_qc_issue(qc);
+
+	return 0;
+}
+
 /**
  *	ata_scsi_translate - Translate then issue SCSI command to ATA device
  *	@dev: ATA device to which the command is addressed
@@ -1747,66 +1783,49 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
  *	spin_lock_irqsave(host lock)
  *
  *	RETURNS:
- *	0 on success, SCSI_ML_QUEUE_DEVICE_BUSY if the command
- *	needs to be deferred.
+ *	0 on success, SCSI_ML_QUEUE_DEVICE_BUSY or SCSI_MLQUEUE_HOST_BUSY if the
+ *	command needs to be deferred.
  */
 static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 			      ata_xlat_func_t xlat_func)
 {
 	struct ata_port *ap = dev->link->ap;
 	struct ata_queued_cmd *qc;
-	int rc;
 
+	lockdep_assert_held(ap->lock);
+
+	/*
+	 * ata_scsi_qc_new() calls scsi_done(cmd) in case of failure. So we
+	 * have nothing further to do when allocating a qc fails.
+	 */
 	qc = ata_scsi_qc_new(dev, cmd);
 	if (!qc)
-		goto err_mem;
+		return 0;
 
 	/* data is present; dma-map it */
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE ||
 	    cmd->sc_data_direction == DMA_TO_DEVICE) {
 		if (unlikely(scsi_bufflen(cmd) < 1)) {
 			ata_dev_warn(dev, "WARNING: zero len r/w req\n");
-			goto err_did;
+			cmd->result = (DID_ERROR << 16);
+			goto done;
 		}
 
 		ata_sg_init(qc, scsi_sglist(cmd), scsi_sg_count(cmd));
-
 		qc->dma_dir = cmd->sc_data_direction;
 	}
 
 	qc->complete_fn = ata_scsi_qc_complete;
 
 	if (xlat_func(qc))
-		goto early_finish;
-
-	if (ap->ops->qc_defer) {
-		if ((rc = ap->ops->qc_defer(qc)))
-			goto defer;
-	}
-
-	/* select device, send command to hardware */
-	ata_qc_issue(qc);
+		goto done;
 
-	return 0;
-
-early_finish:
-	ata_qc_free(qc);
-	scsi_done(cmd);
-	return 0;
+	return ata_scsi_qc_issue(ap, qc);
 
-err_did:
+done:
 	ata_qc_free(qc);
-	cmd->result = (DID_ERROR << 16);
 	scsi_done(cmd);
-err_mem:
 	return 0;
-
-defer:
-	ata_qc_free(qc);
-	if (rc == ATA_DEFER_LINK)
-		return SCSI_MLQUEUE_DEVICE_BUSY;
-	else
-		return SCSI_MLQUEUE_HOST_BUSY;
 }
 
 struct ata_scsi_args {
-- 
2.51.0

