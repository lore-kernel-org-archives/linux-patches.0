Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DB141CB50;
	Fri,  4 Sep 2026 06:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502298; cv=none; b=X+vV/hA9l320K/0JgDDQxBigIN/FEf4XXJ+tjcNT262BOUFMoYE7SnWUwJMtdnJVcll35IYl4MPzRfNUB4e6+7iMTW8feyL/r1bLyRTPgCIn0b/e3tVLKwtM/kpHOiCS5SAPxZgpjPWUtjKg7Hmz3HJYK1x44pbZ7zWeG5zjCmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502298; c=relaxed/simple;
	bh=PvljkCi2yq6brQ+/BU0xU/hsK+ocGTh2u5PhcIUj3BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIcRAMy4WvgcWSreo8162OSVViO+VngdjbH2/4s0QPoDdtCCZTRma0CiWTgUYNuY+wvf6j4ZT5Q2Du4+JiND/jtzzDioh+pFcLziOJgmIc9g/XpGw+2Ez90U7i9v7ew/yF6+vM0BZ3xQYDTJPGAD6dpytHNj/mK2G6eg9jTxZ4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGeYAMgV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGeYAMgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447221F00A3D;
	Fri,  4 Sep 2026 06:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502296;
	bh=umku5+DFz9T7N3odtlGQrzu6HiHAD2+qPA6bImdlGXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGeYAMgVcb4uvFuJJVWOphjJSIpls2qPkvlAQMSRF6ggXLbZsDJFAtv0gsiDFDGYF
	 r9znoMCzRf1jodtUytjUAVSbpWU9Ca3NDGw5nSBTDCP6Hq4dx5LXpxaNtLv0Izd8Z8
	 VEdQ681Ydhf4cXxSdaY+5J6xDyyv94QDLY3Qj7xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.12 158/403] ata: libata-scsi: fix DSM TRIM for sector sizes larger than 2048 bytes
Date: Fri,  4 Sep 2026 06:59:21 +0200
Message-ID: <20260904045738.444800115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

commit 79cce911e623c0baa0fde307ce3a434e084b881a upstream.

ata_scsi_write_same_xlat() translates a SCSI WRITE SAME command with the
UNMAP bit set into an ATA DATA SET MANAGEMENT TRIM command.  The TRIM
descriptor is built by ata_format_dsm_trim_descr() into the 2048-byte
ata_scsi_rbuf staging buffer, and the number of bytes copied is compared
against the logical sector size by the caller:

	size = ata_format_dsm_trim_descr(scmd, trmax, block, n_block);
	if (size != len)		/* len == sdp->sector_size */
		goto invalid_param_len;

ata_format_dsm_trim_descr() clamps the copy length to ATA_SCSI_RBUF_SIZE
(2048).  On a device whose logical sector size exceeds that (e.g. a 4Kn
device, where sector_size == 4096) the function can never return more than
2048, while the caller expects it to return sector_size.  The comparison
therefore always fails, so every TRIM is rejected with "Parameter list
length error" and WARN_ON() splats on each attempt.  TRIM / discard is
thus completely broken on such devices.

The descriptor was incorrectly sized from the logical sector size.  A DSM
TRIM payload is a list of 512-byte pages, each holding up to
ATA_MAX_TRIM_RNUM (64) LBA Range Entries, and is independent of the logical
sector size.  The Block Limits VPD page already advertises a single such
page as the maximum WRITE SAME length (65535 * ATA_MAX_TRIM_RNUM logical
blocks), so the block layer never sends a request that needs more than one
page.

Emit exactly one 512-byte page, independent of the logical sector size,
and transfer only that page (COUNT == 1).  For a 512-byte-sector device
this is unchanged; devices with larger logical sectors now work instead of
failing every TRIM.

Reviewed-by: Hannes Reinecke <hare@kernel.org>
Fixes: ef2d7392c4ec ("libata: SCT Write Same / DSM Trim")
Cc: stable@vger.kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3546,17 +3546,13 @@ static unsigned int ata_scsi_pass_thru(s
 static size_t ata_format_dsm_trim_descr(struct scsi_cmnd *cmd, u32 trmax,
 					u64 sector, u32 count)
 {
-	struct scsi_device *sdp = cmd->device;
-	size_t len = sdp->sector_size;
+	size_t len = ATA_SECT_SIZE;
 	size_t r;
 	__le64 *buf;
 	u32 i = 0;
 	unsigned long flags;
 
-	WARN_ON(len > ATA_SCSI_RBUF_SIZE);
-
-	if (len > ATA_SCSI_RBUF_SIZE)
-		len = ATA_SCSI_RBUF_SIZE;
+	BUILD_BUG_ON(ATA_SECT_SIZE > ATA_SCSI_RBUF_SIZE);
 
 	spin_lock_irqsave(&ata_scsi_rbuf_lock, flags);
 	buf = ((void *)ata_scsi_rbuf);
@@ -3591,13 +3587,11 @@ static unsigned int ata_scsi_write_same_
 {
 	struct ata_taskfile *tf = &qc->tf;
 	struct scsi_cmnd *scmd = qc->scsicmd;
-	struct scsi_device *sdp = scmd->device;
-	size_t len = sdp->sector_size;
 	struct ata_device *dev = qc->dev;
 	const u8 *cdb = scmd->cmnd;
 	u64 block;
 	u32 n_block;
-	const u32 trmax = len >> 3;
+	const u32 trmax = ATA_MAX_TRIM_RNUM;
 	u32 size;
 	u16 fp;
 	u8 bp = 0xff;
@@ -3641,13 +3635,13 @@ static unsigned int ata_scsi_write_same_
 		goto invalid_param_len;
 
 	/*
-	 * size must match sector size in bytes
-	 * For DATA SET MANAGEMENT TRIM in ACS-2 nsect (aka count)
-	 * is defined as number of 512 byte blocks to be transferred.
+	 * The TRIM descriptor is a single 512-byte page, which is the maximum
+	 * WRITE SAME length advertised in the Block Limits VPD page. For DATA
+	 * SET MANAGEMENT TRIM the COUNT field (aka nsect) is the number of
+	 * 512-byte blocks to be transferred.
 	 */
-
 	size = ata_format_dsm_trim_descr(scmd, trmax, block, n_block);
-	if (size != len)
+	if (size != ATA_SECT_SIZE)
 		goto invalid_param_len;
 
 	if (ata_ncq_enabled(dev) && ata_fpdma_dsm_supported(dev)) {
@@ -3673,6 +3667,12 @@ static unsigned int ata_scsi_write_same_
 		     ATA_TFLAG_WRITE;
 
 	ata_qc_set_pc_nbytes(qc);
+	/*
+	 * The DSM TRIM payload is a single 512-byte page, which may be smaller
+	 * than the WRITE SAME data-out buffer (one logical block); only
+	 * transfer that page so the length matches the COUNT field.
+	 */
+	qc->nbytes = size;
 
 	return 0;
 


