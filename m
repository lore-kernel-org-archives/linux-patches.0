Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1281B26CE32;
	Mon, 13 Apr 2026 16:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097219; cv=none; b=HLKnbfdMdDUyZCH8ZhYG234Awdaa0+9E1HD/htjY1lVjqslsysstHnh8V2ypIBPvjYBaNedWhB7T1PbUMoCtYHz4M9VKY9C2gPGJnPjCpDn79pT/5SHpgl2OWUyw5u3D1ZVLFVNVmUIIoauoA92JIr/b+j00KfpFbuv0mqtRpIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097219; c=relaxed/simple;
	bh=AOVSyFeekBh5NgHhGYO5ko1EWy0N7p/sm3W6vdGdv6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwLrmj/lQWRnFmGOGcFBlcSxapCSc4cto2KBK3VRjV2F+bka2TkgcvijRpwqvpmeLYhAm2IhrH8ni+mfVlxn43JCDX1ivWEdurVglsSi2GwpsF7unx6aAi0DcUYZyZFILIVHT0WAzck5KE5lE7zuJUGdIZo9fkbe8gFSeHlgMSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKBy29uy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKBy29uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761C0C2BCB0;
	Mon, 13 Apr 2026 16:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097218;
	bh=AOVSyFeekBh5NgHhGYO5ko1EWy0N7p/sm3W6vdGdv6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKBy29uytVCpzVA7RtD2dp2XGn+2y5YjBaKNP+0rDcJxzrW5aVyI4AXHalK7UT/rH
	 inSr1r8bpMqK6w9nUziy7XryGlPJxh2qLD5JcyPfWYuNnUQiViEZas4IqBug2tFziN
	 RSOYGpmFeKY7U9uYi3u9gJnw4t//jYFchkkUWx2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/570] ata: libata-scsi: refactor ata_scsi_translate()
Date: Mon, 13 Apr 2026 17:52:30 +0200
Message-ID: <20260413155831.137260109@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit bb3a8154b1a1dc2c86d037482c0a2cf9186829ed ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 81 ++++++++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 31 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4fd8fcab5f972..59843188966e7 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1670,6 +1670,42 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
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
@@ -1693,66 +1729,49 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
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



