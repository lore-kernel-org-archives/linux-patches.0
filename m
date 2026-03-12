Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E522B26F288;
	Thu, 12 Mar 2026 20:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346643; cv=none; b=MyrwLq408Ch9Qt5AuI0EXYVbvPDLE//UzOGb0mCRIci3r8x9+Z58YTkFMsbJL1p2ArvhgtbUGD+jv7IwUkjBIzS4DJaoUh19w2SuDh1FbswF7XcubjrAbde4TQlPoVXfanwcJfA+7hM/FxPj/DjaPiCMP8zu9mh01y0ccv9ehqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346643; c=relaxed/simple;
	bh=pQUHExJIZc4MbFkPMZLVCg4p/wUGdBelrzlJwOLO0EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/LyVzjZS3mpMOdaCgCoVg0uQoKD1ArMOR946yH6NGfucWz2F4/QXw2/S0pbREZT1BxYEgx89AUeba2NASrufE4BoIIktL9IzKsRc5FZA4FbfbcxPcR9eYkHl4DCVBQj3NIWDQrxepTMyYZlyMpBJ3HcoQzCzsh/aKmqc2UJ9RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okR3TwoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okR3TwoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5B8C4CEF7;
	Thu, 12 Mar 2026 20:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346642;
	bh=pQUHExJIZc4MbFkPMZLVCg4p/wUGdBelrzlJwOLO0EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okR3TwoZ4HyzFqxPlUERGe0WG6fjrwcJT/XIIt7dvviucyU3z0fifwoOQq3mfP0p1
	 xpEiP89js+xX5yk4UpkTEBld8yom/HPQ5BgX8Nw2gkEBfL3EU0LYoUIbdGuL1aBvSm
	 m4rel9uDHnID26a4FhURzkspIhZ53xSDfLJwYygQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/265] ata: libata-scsi: Refactor ata_scsiop_read_cap()
Date: Thu, 12 Mar 2026 21:07:23 +0100
Message-ID: <20260312201020.235071663@linuxfoundation.org>
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

[ Upstream commit 44bdde151a6f5b34993c570a8f6508e2e00b56e1 ]

Move the check for the scsi command service action being
SAI_READ_CAPACITY_16 from ata_scsi_simulate() into ata_scsiop_read_cap()
to simplify ata_scsi_simulate() for processing capacity reading commands
(READ_CAPACITY and SERVICE_ACTION_IN_16).

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20241022024537.251905-3-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 87 +++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 41 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 17fb055e48748..e5857229f0b7a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2613,6 +2613,7 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 {
 	struct ata_device *dev = args->dev;
+	u8 *scsicmd = args->cmd->cmnd;
 	u64 last_lba = dev->n_sectors - 1; /* LBA of the last block */
 	u32 sector_size; /* physical sector size in bytes */
 	u8 log2_per_phys;
@@ -2622,7 +2623,7 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 	log2_per_phys = ata_id_log2_per_physical_sector(dev->id);
 	lowest_aligned = ata_id_logical_sector_offset(dev->id, log2_per_phys);
 
-	if (args->cmd->cmnd[0] == READ_CAPACITY) {
+	if (scsicmd[0] == READ_CAPACITY) {
 		if (last_lba >= 0xffffffffULL)
 			last_lba = 0xffffffff;
 
@@ -2637,42 +2638,52 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 		rbuf[5] = sector_size >> (8 * 2);
 		rbuf[6] = sector_size >> (8 * 1);
 		rbuf[7] = sector_size;
-	} else {
-		/* sector count, 64-bit */
-		rbuf[0] = last_lba >> (8 * 7);
-		rbuf[1] = last_lba >> (8 * 6);
-		rbuf[2] = last_lba >> (8 * 5);
-		rbuf[3] = last_lba >> (8 * 4);
-		rbuf[4] = last_lba >> (8 * 3);
-		rbuf[5] = last_lba >> (8 * 2);
-		rbuf[6] = last_lba >> (8 * 1);
-		rbuf[7] = last_lba;
 
-		/* sector size */
-		rbuf[ 8] = sector_size >> (8 * 3);
-		rbuf[ 9] = sector_size >> (8 * 2);
-		rbuf[10] = sector_size >> (8 * 1);
-		rbuf[11] = sector_size;
-
-		rbuf[12] = 0;
-		rbuf[13] = log2_per_phys;
-		rbuf[14] = (lowest_aligned >> 8) & 0x3f;
-		rbuf[15] = lowest_aligned;
-
-		if (ata_id_has_trim(args->id) &&
-		    !(dev->quirks & ATA_QUIRK_NOTRIM)) {
-			rbuf[14] |= 0x80; /* LBPME */
-
-			if (ata_id_has_zero_after_trim(args->id) &&
-			    dev->quirks & ATA_QUIRK_ZERO_AFTER_TRIM) {
-				ata_dev_info(dev, "Enabling discard_zeroes_data\n");
-				rbuf[14] |= 0x40; /* LBPRZ */
-			}
+		return 0;
+	}
+
+	/*
+	 * READ CAPACITY 16 command is defined as a service action
+	 * (SERVICE_ACTION_IN_16 command).
+	 */
+	if (scsicmd[0] != SERVICE_ACTION_IN_16 ||
+	    (scsicmd[1] & 0x1f) != SAI_READ_CAPACITY_16) {
+		ata_scsi_set_invalid_field(dev, args->cmd, 1, 0xff);
+		return 1;
+	}
+
+	/* sector count, 64-bit */
+	rbuf[0] = last_lba >> (8 * 7);
+	rbuf[1] = last_lba >> (8 * 6);
+	rbuf[2] = last_lba >> (8 * 5);
+	rbuf[3] = last_lba >> (8 * 4);
+	rbuf[4] = last_lba >> (8 * 3);
+	rbuf[5] = last_lba >> (8 * 2);
+	rbuf[6] = last_lba >> (8 * 1);
+	rbuf[7] = last_lba;
+
+	/* sector size */
+	rbuf[ 8] = sector_size >> (8 * 3);
+	rbuf[ 9] = sector_size >> (8 * 2);
+	rbuf[10] = sector_size >> (8 * 1);
+	rbuf[11] = sector_size;
+
+	if (ata_id_zoned_cap(args->id) || args->dev->class == ATA_DEV_ZAC)
+		rbuf[12] = (1 << 4); /* RC_BASIS */
+	rbuf[13] = log2_per_phys;
+	rbuf[14] = (lowest_aligned >> 8) & 0x3f;
+	rbuf[15] = lowest_aligned;
+
+	if (ata_id_has_trim(args->id) && !(dev->quirks & ATA_QUIRK_NOTRIM)) {
+		rbuf[14] |= 0x80; /* LBPME */
+
+		if (ata_id_has_zero_after_trim(args->id) &&
+		    dev->quirks & ATA_QUIRK_ZERO_AFTER_TRIM) {
+			ata_dev_info(dev, "Enabling discard_zeroes_data\n");
+			rbuf[14] |= 0x40; /* LBPRZ */
 		}
-		if (ata_id_zoned_cap(args->id) ||
-		    args->dev->class == ATA_DEV_ZAC)
-			rbuf[12] = (1 << 4); /* RC_BASIS */
 	}
+
 	return 0;
 }
 
@@ -4374,14 +4385,8 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 		break;
 
 	case READ_CAPACITY:
-		ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
-		break;
-
 	case SERVICE_ACTION_IN_16:
-		if ((scsicmd[1] & 0x1f) == SAI_READ_CAPACITY_16)
-			ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
-		else
-			ata_scsi_set_invalid_field(dev, cmd, 1, 0xff);
+		ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
 		break;
 
 	case REPORT_LUNS:
-- 
2.51.0



