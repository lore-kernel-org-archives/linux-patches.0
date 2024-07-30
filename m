Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C58218801A;
	Tue, 30 Jul 2024 16:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358624; cv=none; b=jhF/aI2aeLg4lUtUw8U3c9NlfLMqmfKtzmxvJC3/TkBLaYS3tUa0a/Bt2Mm8nrXCzdtvv7yuHx5I2gLW4l4HbY/5OyhgNFzKNW2g0MM0cY37JcPUUguseUzY7ILTWXrSWACvVqRDntYTaRL3lldOLcYF39EPB+dGlrnzaP8hnLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358624; c=relaxed/simple;
	bh=CaMx12kZ67kPQDcM3rPF3rSFblePkq05yfCziRXQ4uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RO42wN0PhRN0z+qF/IIPVmaJeRUHm7YD7DJQaSrDi1HVXaGilzUwNN2r/LcWgKryO1gd+/wVhssipyVBGViibIFMgtXE14ABl/H/fo6RGOtyOj+4SuN2kO3dhb4/kuPgjhDbAhv5JFoSC2mmNqXHWXYgjbrRo8hVN4rKFkVKuqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqY1FH5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqY1FH5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F011CC4AF0E;
	Tue, 30 Jul 2024 16:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358624;
	bh=CaMx12kZ67kPQDcM3rPF3rSFblePkq05yfCziRXQ4uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqY1FH5vGMkKHdVcK3DY4TjpT9eyqBgxGlUJTLIPEUJy80Gnb+T4PuKzYS3Duzeq+
	 nv0XCLrsJLj7iX0m5ou0fwvo2n6f9N9T9fmrjbzyzBH6rbov+PzQVMgG01au6rR2ar
	 N6VysQW0TF+14dPLJpyRE6O1R/rODKZTLI+iMwps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>
Subject: [PATCH 6.6 380/568] ata: libata-scsi: Do not overwrite valid sense data when CK_COND=1
Date: Tue, 30 Jul 2024 17:48:07 +0200
Message-ID: <20240730151654.718522275@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Pylypiv <ipylypiv@google.com>

commit 97981926224afe17ba3e22e0c2b7dd8b516ee574 upstream.

Current ata_gen_passthru_sense() code performs two actions:
1. Generates sense data based on the ATA 'status' and ATA 'error' fields.
2. Populates "ATA Status Return sense data descriptor" / "Fixed format
   sense data" with ATA taskfile fields.

The problem is that #1 generates sense data even when a valid sense data
is already present (ATA_QCFLAG_SENSE_VALID is set). Factoring out #2 into
a separate function allows us to generate sense data only when there is
no valid sense data (ATA_QCFLAG_SENSE_VALID is not set).

As a bonus, we can now delete a FIXME comment in atapi_qc_complete()
which states that we don't want to translate taskfile registers into
sense descriptors for ATAPI.

Additionally, always set SAM_STAT_CHECK_CONDITION when CK_COND=1 because
SAT specification mandates that SATL shall return CHECK CONDITION if
the CK_COND bit is set.

The ATA PASS-THROUGH handling logic in ata_scsi_qc_complete() is hard
to read/understand. Improve the readability of the code by moving checks
into self-explanatory boolean variables.

Cc: stable@vger.kernel.org # 4.19+
Co-developed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Link: https://lore.kernel.org/r/20240702024735.1152293-3-ipylypiv@google.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |  169 +++++++++++++++++++++++++---------------------
 1 file changed, 92 insertions(+), 77 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -230,6 +230,80 @@ void ata_scsi_set_sense_information(stru
 				   SCSI_SENSE_BUFFERSIZE, information);
 }
 
+/**
+ *	ata_scsi_set_passthru_sense_fields - Set ATA fields in sense buffer
+ *	@qc: ATA PASS-THROUGH command.
+ *
+ *	Populates "ATA Status Return sense data descriptor" / "Fixed format
+ *	sense data" with ATA taskfile fields.
+ *
+ *	LOCKING:
+ *	None.
+ */
+static void ata_scsi_set_passthru_sense_fields(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *cmd = qc->scsicmd;
+	struct ata_taskfile *tf = &qc->result_tf;
+	unsigned char *sb = cmd->sense_buffer;
+
+	if ((sb[0] & 0x7f) >= 0x72) {
+		unsigned char *desc;
+		u8 len;
+
+		/* descriptor format */
+		len = sb[7];
+		desc = (char *)scsi_sense_desc_find(sb, len + 8, 9);
+		if (!desc) {
+			if (SCSI_SENSE_BUFFERSIZE < len + 14)
+				return;
+			sb[7] = len + 14;
+			desc = sb + 8 + len;
+		}
+		desc[0] = 9;
+		desc[1] = 12;
+		/*
+		 * Copy registers into sense buffer.
+		 */
+		desc[2] = 0x00;
+		desc[3] = tf->error;
+		desc[5] = tf->nsect;
+		desc[7] = tf->lbal;
+		desc[9] = tf->lbam;
+		desc[11] = tf->lbah;
+		desc[12] = tf->device;
+		desc[13] = tf->status;
+
+		/*
+		 * Fill in Extend bit, and the high order bytes
+		 * if applicable.
+		 */
+		if (tf->flags & ATA_TFLAG_LBA48) {
+			desc[2] |= 0x01;
+			desc[4] = tf->hob_nsect;
+			desc[6] = tf->hob_lbal;
+			desc[8] = tf->hob_lbam;
+			desc[10] = tf->hob_lbah;
+		}
+	} else {
+		/* Fixed sense format */
+		sb[0] |= 0x80;
+		sb[3] = tf->error;
+		sb[4] = tf->status;
+		sb[5] = tf->device;
+		sb[6] = tf->nsect;
+		if (tf->flags & ATA_TFLAG_LBA48)  {
+			sb[8] |= 0x80;
+			if (tf->hob_nsect)
+				sb[8] |= 0x40;
+			if (tf->hob_lbal || tf->hob_lbam || tf->hob_lbah)
+				sb[8] |= 0x20;
+		}
+		sb[9] = tf->lbal;
+		sb[10] = tf->lbam;
+		sb[11] = tf->lbah;
+	}
+}
+
 static void ata_scsi_set_invalid_field(struct ata_device *dev,
 				       struct scsi_cmnd *cmd, u16 field, u8 bit)
 {
@@ -837,10 +911,8 @@ static void ata_to_sense_error(unsigned
  *	ata_gen_passthru_sense - Generate check condition sense block.
  *	@qc: Command that completed.
  *
- *	This function is specific to the ATA descriptor format sense
- *	block specified for the ATA pass through commands.  Regardless
- *	of whether the command errored or not, return a sense
- *	block. Copy all controller registers into the sense
+ *	This function is specific to the ATA pass through commands.
+ *	Regardless of whether the command errored or not, return a sense
  *	block. If there was no error, we get the request from an ATA
  *	passthrough command, so we use the following sense data:
  *	sk = RECOVERED ERROR
@@ -875,63 +947,6 @@ static void ata_gen_passthru_sense(struc
 		 */
 		scsi_build_sense(cmd, 1, RECOVERED_ERROR, 0, 0x1D);
 	}
-
-	if ((sb[0] & 0x7f) >= 0x72) {
-		unsigned char *desc;
-		u8 len;
-
-		/* descriptor format */
-		len = sb[7];
-		desc = (char *)scsi_sense_desc_find(sb, len + 8, 9);
-		if (!desc) {
-			if (SCSI_SENSE_BUFFERSIZE < len + 14)
-				return;
-			sb[7] = len + 14;
-			desc = sb + 8 + len;
-		}
-		desc[0] = 9;
-		desc[1] = 12;
-		/*
-		 * Copy registers into sense buffer.
-		 */
-		desc[2] = 0x00;
-		desc[3] = tf->error;
-		desc[5] = tf->nsect;
-		desc[7] = tf->lbal;
-		desc[9] = tf->lbam;
-		desc[11] = tf->lbah;
-		desc[12] = tf->device;
-		desc[13] = tf->status;
-
-		/*
-		 * Fill in Extend bit, and the high order bytes
-		 * if applicable.
-		 */
-		if (tf->flags & ATA_TFLAG_LBA48) {
-			desc[2] |= 0x01;
-			desc[4] = tf->hob_nsect;
-			desc[6] = tf->hob_lbal;
-			desc[8] = tf->hob_lbam;
-			desc[10] = tf->hob_lbah;
-		}
-	} else {
-		/* Fixed sense format */
-		sb[0] |= 0x80;
-		sb[3] = tf->error;
-		sb[4] = tf->status;
-		sb[5] = tf->device;
-		sb[6] = tf->nsect;
-		if (tf->flags & ATA_TFLAG_LBA48)  {
-			sb[8] |= 0x80;
-			if (tf->hob_nsect)
-				sb[8] |= 0x40;
-			if (tf->hob_lbal || tf->hob_lbam || tf->hob_lbah)
-				sb[8] |= 0x20;
-		}
-		sb[9] = tf->lbal;
-		sb[10] = tf->lbam;
-		sb[11] = tf->lbah;
-	}
 }
 
 /**
@@ -1664,26 +1679,32 @@ static void ata_scsi_qc_complete(struct
 {
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	u8 *cdb = cmd->cmnd;
-	int need_sense = (qc->err_mask != 0) &&
-		!(qc->flags & ATA_QCFLAG_SENSE_VALID);
+	bool have_sense = qc->flags & ATA_QCFLAG_SENSE_VALID;
+	bool is_ata_passthru = cdb[0] == ATA_16 || cdb[0] == ATA_12;
+	bool is_ck_cond_request = cdb[2] & 0x20;
+	bool is_error = qc->err_mask != 0;
 
 	/* For ATA pass thru (SAT) commands, generate a sense block if
 	 * user mandated it or if there's an error.  Note that if we
-	 * generate because the user forced us to [CK_COND =1], a check
+	 * generate because the user forced us to [CK_COND=1], a check
 	 * condition is generated and the ATA register values are returned
 	 * whether the command completed successfully or not. If there
-	 * was no error, we use the following sense data:
+	 * was no error, and CK_COND=1, we use the following sense data:
 	 * sk = RECOVERED ERROR
 	 * asc,ascq = ATA PASS-THROUGH INFORMATION AVAILABLE
 	 */
-	if (((cdb[0] == ATA_16) || (cdb[0] == ATA_12)) &&
-	    ((cdb[2] & 0x20) || need_sense))
-		ata_gen_passthru_sense(qc);
-	else if (need_sense)
+	if (is_ata_passthru && (is_ck_cond_request || is_error || have_sense)) {
+		if (!have_sense)
+			ata_gen_passthru_sense(qc);
+		ata_scsi_set_passthru_sense_fields(qc);
+		if (is_ck_cond_request)
+			set_status_byte(qc->scsicmd, SAM_STAT_CHECK_CONDITION);
+	} else if (is_error && !have_sense) {
 		ata_gen_ata_sense(qc);
-	else
+	} else {
 		/* Keep the SCSI ML and status byte, clear host byte. */
 		cmd->result &= 0x0000ffff;
+	}
 
 	ata_qc_done(qc);
 }
@@ -2622,14 +2643,8 @@ static void atapi_qc_complete(struct ata
 	/* handle completion from EH */
 	if (unlikely(err_mask || qc->flags & ATA_QCFLAG_SENSE_VALID)) {
 
-		if (!(qc->flags & ATA_QCFLAG_SENSE_VALID)) {
-			/* FIXME: not quite right; we don't want the
-			 * translation of taskfile registers into a
-			 * sense descriptors, since that's only
-			 * correct for ATA, not ATAPI
-			 */
+		if (!(qc->flags & ATA_QCFLAG_SENSE_VALID))
 			ata_gen_passthru_sense(qc);
-		}
 
 		/* SCSI EH automatically locks door if sdev->locked is
 		 * set.  Sometimes door lock request continues to


