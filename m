Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45E52459D1;
	Mon, 13 Apr 2026 16:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097174; cv=none; b=Frb2ia9CYAqlcGXHVNxaTc4JjrR2gmVkSrMiCmlXYJhl8fsXPvVv3BZQKTWlU1E7xy/OQ8zgBTUPUyGczbT01AoSiMia4k13Ffycn7Ys/usLVAuNsaa2309g8+BS0O3cIe/zwCWYBfOImPvL85ml/42nMdSZnoEllhCrzLx0YPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097174; c=relaxed/simple;
	bh=+DQsllYrQ/2Tl7NAUofSJvk13Xm/Z+A1CG+mJ6bcIXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNQqdsG1nRQh3roso9zMr0kUuXyit3gauEEDaoMIV9WUdh6D3tnGoz12dYyfUksraJpLneAwsfmmYNZkIuGy6/c5fFVmsxJJor6PxHhCGST8wQVs070lbBBC/SsiZ3IYvg06lCdKd4M4Nhlvt0P5uhmQBaieit+omJkhO1yVKkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHdx61lI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHdx61lI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2F3C2BCAF;
	Mon, 13 Apr 2026 16:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097174;
	bh=+DQsllYrQ/2Tl7NAUofSJvk13Xm/Z+A1CG+mJ6bcIXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHdx61lIE+s9tsFzIUGOkUpYliDGc5rVsWkKdfVj/ESSwWjVxpomVgVh4+O7vkQuZ
	 4bIeV8Jdcewms0InLq3eouLAEF7a9IS2+nhaOBmJQ2NzjGXM2mSueMk9yCuTnydxJU
	 FDql1RNy8JK30RfWSzhnbL2iUh8NjcJ4S37z/IKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/570] ata: libata-scsi: drop DPRINTK calls for cdb translation
Date: Mon, 13 Apr 2026 17:52:28 +0200
Message-ID: <20260413155831.062052236@linuxfoundation.org>
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

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 1fe9fb71b2ffcedd794daacf4db2056a6cb5199e ]

Drop DPRINTK calls for cdb translation as they are already covered
by other traces, and also drop the DPRINTK calls in ata_scsi_hotplug().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Stable-dep-of: bb3a8154b1a1 ("ata: libata-scsi: refactor ata_scsi_translate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b57027206ae1e..22c45bc64a95e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1472,9 +1472,6 @@ static unsigned int ata_scsi_verify_xlat(struct ata_queued_cmd *qc)
 		head  = track % dev->heads;
 		sect  = (u32)block % dev->sectors + 1;
 
-		DPRINTK("block %u track %u cyl %u head %u sect %u\n",
-			(u32)block, track, cyl, head, sect);
-
 		/* Check whether the converted CHS can fit.
 		   Cylinder: 0-65535
 		   Head: 0-15
@@ -1597,7 +1594,6 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 			goto invalid_fld;
 		break;
 	default:
-		DPRINTK("no-byte command\n");
 		fp = 0;
 		goto invalid_fld;
 	}
@@ -1751,7 +1747,6 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 early_finish:
 	ata_qc_free(qc);
 	scsi_done(cmd);
-	DPRINTK("EXIT - early finish (good or error)\n");
 	return 0;
 
 err_did:
@@ -1759,12 +1754,10 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	cmd->result = (DID_ERROR << 16);
 	scsi_done(cmd);
 err_mem:
-	DPRINTK("EXIT - internal\n");
 	return 0;
 
 defer:
 	ata_qc_free(qc);
-	DPRINTK("EXIT - defer\n");
 	if (rc == ATA_DEFER_LINK)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	else
@@ -2491,8 +2484,6 @@ static void atapi_request_sense(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	struct scsi_cmnd *cmd = qc->scsicmd;
 
-	DPRINTK("ATAPI request sense\n");
-
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 
 #ifdef CONFIG_ATA_SFF
@@ -2531,8 +2522,6 @@ static void atapi_request_sense(struct ata_queued_cmd *qc)
 	qc->complete_fn = atapi_sense_complete;
 
 	ata_qc_issue(qc);
-
-	DPRINTK("EXIT\n");
 }
 
 /*
@@ -2642,7 +2631,6 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	if (scmd->sc_data_direction == DMA_TO_DEVICE) {
 		qc->tf.flags |= ATA_TFLAG_WRITE;
-		DPRINTK("direction: write\n");
 	}
 
 	qc->tf.command = ATA_CMD_PACKET;
@@ -4065,8 +4053,6 @@ int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev)
 	return 0;
 
  bad_cdb_len:
-	DPRINTK("bad CDB len=%u, scsi_op=0x%02x, max=%u\n",
-		scmd->cmd_len, scsi_op, dev->cdb_len);
 	scmd->result = DID_ERROR << 16;
 	scsi_done(scmd);
 	return 0;
@@ -4532,12 +4518,9 @@ void ata_scsi_hotplug(struct work_struct *work)
 		container_of(work, struct ata_port, hotplug_task.work);
 	int i;
 
-	if (ap->pflags & ATA_PFLAG_UNLOADING) {
-		DPRINTK("ENTER/EXIT - unloading\n");
+	if (ap->pflags & ATA_PFLAG_UNLOADING)
 		return;
-	}
 
-	DPRINTK("ENTER\n");
 	mutex_lock(&ap->scsi_scan_mutex);
 
 	/* Unplug detached devices.  We cannot use link iterator here
@@ -4553,7 +4536,6 @@ void ata_scsi_hotplug(struct work_struct *work)
 	ata_scsi_scan_host(ap, 0);
 
 	mutex_unlock(&ap->scsi_scan_mutex);
-	DPRINTK("EXIT\n");
 }
 
 /**
-- 
2.51.0



