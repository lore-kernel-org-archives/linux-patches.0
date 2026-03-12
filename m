Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B05626F288;
	Thu, 12 Mar 2026 20:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346639; cv=none; b=V9ZPQB3tlziO8p9fPKBccyUrZ/76RJzETrmoO1HoYCb1Lb+t7+BoqE9aDvfvRbxXLZ8Gj9B6UISPOabhNVXIhcMuy5AxMNUA0aW7e/ghSu3pAWrrgrtDqZgSn/DDUqly50TQ45GVONSUtYs92oD7AAHRix8/pQqm+CsI1R5cdb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346639; c=relaxed/simple;
	bh=x+5D5HsmcC0y05Xf8DrGSuD9IATHs/v1yQ/d/4q88V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aru+noe6dlIL4FVEzJTsn5Ie8oHUweuAAbJdBYEFWrmWLsEulkEnzTJFnd/OzrGZRyDHyUoDPb4V2l9HjqeoswqC+wfRGrtfTTZk3x4NdKMSHgwRxNcLRTo9XwOU4FH668OgTTcIGC5mBbrHdiTmJJtVvsxlyyzfRhQsErxHYK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yR+usM86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yR+usM86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F21CC4CEF7;
	Thu, 12 Mar 2026 20:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346638;
	bh=x+5D5HsmcC0y05Xf8DrGSuD9IATHs/v1yQ/d/4q88V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yR+usM86ea1OEyFYNfgYy+kCROBquNLbsnFPJd35IkDsIB+E9N6HYVvioaTagxlHH
	 6Bv59mxtarDxxsISm910J/hGSrKg37jc+oISHeCy1iWTQp9/4YfeAmKd5s+7qd/X6j
	 M4SGq3rn/h77DOz+j7/WcXU9w61Bcfi34pH4GMz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/265] ata: libata-scsi: Refactor ata_scsi_simulate()
Date: Thu, 12 Mar 2026 21:07:22 +0100
Message-ID: <20260312201020.198378192@linuxfoundation.org>
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

[ Upstream commit b055e3be63bebc3c50d0fb1830de9bf4f2be388d ]

Factor out the code handling the INQUIRY command in ata_scsi_simulate()
using the function ata_scsi_rbuf_fill() with the new actor
ata_scsiop_inquiry(). This new actor function calls the existing actors
to handle the standard inquiry as well as extended inquiry (VPD page
access).

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20241022024537.251905-2-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 106 ++++++++++++++++++++++----------------
 1 file changed, 63 insertions(+), 43 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 097080c8b82df..17fb055e48748 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1849,7 +1849,7 @@ static void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
 }
 
 /**
- *	ata_scsiop_inq_std - Simulate INQUIRY command
+ *	ata_scsiop_inq_std - Simulate standard INQUIRY command
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
  *
@@ -2155,6 +2155,11 @@ static unsigned int ata_scsiop_inq_b2(struct ata_scsi_args *args, u8 *rbuf)
 
 static unsigned int ata_scsiop_inq_b6(struct ata_scsi_args *args, u8 *rbuf)
 {
+	if (!(args->dev->flags & ATA_DFLAG_ZAC)) {
+		ata_scsi_set_invalid_field(args->dev, args->cmd, 2, 0xff);
+		return 1;
+	}
+
 	/*
 	 * zbc-r05 SCSI Zoned Block device characteristics VPD page
 	 */
@@ -2179,6 +2184,11 @@ static unsigned int ata_scsiop_inq_b9(struct ata_scsi_args *args, u8 *rbuf)
 	u8 *desc = &rbuf[64];
 	int i;
 
+	if (!cpr_log) {
+		ata_scsi_set_invalid_field(args->dev, args->cmd, 2, 0xff);
+		return 1;
+	}
+
 	/* SCSI Concurrent Positioning Ranges VPD page: SBC-5 rev 1 or later */
 	rbuf[1] = 0xb9;
 	put_unaligned_be16(64 + (int)cpr_log->nr_cpr * 32 - 4, &rbuf[2]);
@@ -2193,6 +2203,57 @@ static unsigned int ata_scsiop_inq_b9(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+/**
+ *	ata_scsiop_inquiry - Simulate INQUIRY command
+ *	@args: device IDENTIFY data / SCSI command of interest.
+ *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
+ *
+ *	Returns data associated with an INQUIRY command output.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+static unsigned int ata_scsiop_inquiry(struct ata_scsi_args *args, u8 *rbuf)
+{
+	struct ata_device *dev = args->dev;
+	struct scsi_cmnd *cmd = args->cmd;
+	const u8 *scsicmd = cmd->cmnd;
+
+	/* is CmdDt set?  */
+	if (scsicmd[1] & 2) {
+		ata_scsi_set_invalid_field(dev, cmd, 1, 0xff);
+		return 1;
+	}
+
+	/* Is EVPD clear? */
+	if ((scsicmd[1] & 1) == 0)
+		return ata_scsiop_inq_std(args, rbuf);
+
+	switch (scsicmd[2]) {
+	case 0x00:
+		return ata_scsiop_inq_00(args, rbuf);
+	case 0x80:
+		return ata_scsiop_inq_80(args, rbuf);
+	case 0x83:
+		return ata_scsiop_inq_83(args, rbuf);
+	case 0x89:
+		return ata_scsiop_inq_89(args, rbuf);
+	case 0xb0:
+		return ata_scsiop_inq_b0(args, rbuf);
+	case 0xb1:
+		return ata_scsiop_inq_b1(args, rbuf);
+	case 0xb2:
+		return ata_scsiop_inq_b2(args, rbuf);
+	case 0xb6:
+		return ata_scsiop_inq_b6(args, rbuf);
+	case 0xb9:
+		return ata_scsiop_inq_b9(args, rbuf);
+	default:
+		ata_scsi_set_invalid_field(dev, cmd, 2, 0xff);
+		return 1;
+	}
+}
+
 /**
  *	modecpy - Prepare response for MODE SENSE
  *	@dest: output buffer
@@ -4304,48 +4365,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 
 	switch(scsicmd[0]) {
 	case INQUIRY:
-		if (scsicmd[1] & 2)		   /* is CmdDt set?  */
-			ata_scsi_set_invalid_field(dev, cmd, 1, 0xff);
-		else if ((scsicmd[1] & 1) == 0)    /* is EVPD clear? */
-			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_std);
-		else switch (scsicmd[2]) {
-		case 0x00:
-			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_00);
-			break;
-		case 0x80:
-			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_80);
-			break;
-		case 0x83:
-			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_83);
-			break;
-		case 0x89:
-			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_89);
-			break;
-		case 0xb0:
-			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b0);
-			break;
-		case 0xb1:
-			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b1);
-			break;
-		case 0xb2:
-			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b2);
-			break;
-		case 0xb6:
-			if (dev->flags & ATA_DFLAG_ZAC)
-				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b6);
-			else
-				ata_scsi_set_invalid_field(dev, cmd, 2, 0xff);
-			break;
-		case 0xb9:
-			if (dev->cpr_log)
-				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b9);
-			else
-				ata_scsi_set_invalid_field(dev, cmd, 2, 0xff);
-			break;
-		default:
-			ata_scsi_set_invalid_field(dev, cmd, 2, 0xff);
-			break;
-		}
+		ata_scsi_rbuf_fill(&args, ata_scsiop_inquiry);
 		break;
 
 	case MODE_SENSE:
-- 
2.51.0



