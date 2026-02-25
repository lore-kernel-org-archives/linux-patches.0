Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0345B3128BE;
	Wed, 25 Feb 2026 06:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002783; cv=none; b=gkKdW1gOwu7LiFUav8ZT4CAekfHgdROYVOvzwhviFG9O07gGBxDF5GNr3OId4pWCY+9ANC5kVtTUSzCIKMub7J1lRwHBZVhrgW4E/qEdNJmULGvTza41kmuTsayoGOyIrYpxfgIj/DA47TwP9bSNrqQewyY5dyuio6Doy+07s8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002783; c=relaxed/simple;
	bh=lgmCM39FXQWq4E+xaXcZDixXYeZRXBhVzFDgVzuP7pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgrCd/We6DrAGJUiXU3acR5XoxREQrXt32JNW5JyA1AEwcJX4fRY/11PH56o5q/FujhJQ1nW7KqFvQ33fL7ShDccgcW/2NPBCF2BBlkUNpQkjxxETnaNaa4I/63/aG354SJMh4J2d3RbqNNHNvF8PorWtpeINlPU+sERpTVNUgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJ/F7nV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJ/F7nV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E4EC116D0;
	Wed, 25 Feb 2026 06:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002782;
	bh=lgmCM39FXQWq4E+xaXcZDixXYeZRXBhVzFDgVzuP7pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJ/F7nV5Np1dKtxzkmOlVl2FBQeqNMorTFQvTGMxGxOIxmeAA50N/Oq16+Q1jEggt
	 KeNT9LJmPJ30jssINXVS6eDKZTfQ60pI4fiqVtSoxoiafvFS3AXZZJkWfCZwQYV0WR
	 UlhfqXhtSmOOnWAJSE68UgmsqtwykMVcheIVeP8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Igor Pylypiv <ipylypiv@google.com>
Subject: [PATCH 6.18 623/641] ata: libata-scsi: refactor ata_scsi_translate()
Date: Tue, 24 Feb 2026 17:25:49 -0800
Message-ID: <20260225012403.601677794@linuxfoundation.org>
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
 drivers/ata/libata-scsi.c |   81 ++++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 31 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1690,6 +1690,42 @@ static void ata_scsi_qc_complete(struct
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
@@ -1713,66 +1749,49 @@ static void ata_scsi_qc_complete(struct
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
-
-	return 0;
+		goto done;
 
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
 
 /**


