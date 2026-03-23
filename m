Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E540B23C4FF;
	Mon, 23 Mar 2026 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277235; cv=none; b=pM3ZA4aeWAqJQpO/Jfpv5BGmji8HVWawrHKyl4TJ0AT36z+P1kr3l/4cYO8GEjOtyWL/yLL3JqaoFPyBwcVL4VtlNyiyh7dAQtCB3/n/s3EkmomUw+/GQLsS3rd6UtBmsr6N7qXNdywYReZVYbFDKM/GOThEKkhkoZi45sx10ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277235; c=relaxed/simple;
	bh=rDav7JuOSKWn+GTSxcYsMaTvhE2ZmtTTMqsdf8V3mSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIKz4gFTzO+FMJKuMmVrjyHp0F/e7qPO89FI/NfJ0zazerGfungbUviKlrTYBfqxG1wrmkeaCt95ZJntjewnGAQvxipNvSWKjqRiDHsTggS0QqJayIqUbuurEGuTMX5SApJ0/Yy33KqHR3M6P6Yp609GZIO4Oqu9Wt/Jw0FeJbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjZ5kzf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjZ5kzf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE13C4CEF7;
	Mon, 23 Mar 2026 14:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277234;
	bh=rDav7JuOSKWn+GTSxcYsMaTvhE2ZmtTTMqsdf8V3mSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjZ5kzf5o+EUm7Q90dDBipDXVUug14QEnqrfLLtIRTWZ/S4oJ31WRdkKaOWJvIDgE
	 UbxV8C08UBWO/yUigWnsdAoyeFncDXV1dCGZgjy6HR53HUZX7mPKlK8fPDXhm+ksZT
	 oHAx/dez/RNPnkqdEaTh8kxaBENUkuQITj8Eigm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 364/460] ata: libata-scsi: Return residual for emulated SCSI commands
Date: Mon, 23 Mar 2026 14:46:00 +0100
Message-ID: <20260323134535.502692809@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

[ Upstream commit 5251ae224d8d3caa21b28d12408062b6e75cffad ]

The function ata_scsi_rbuf_fill() used to fill the reply buffer of
emulated SCSI commands always copies the ATA reply buffer
(ata_scsi_rbuf) up to the size of the SCSI command buffer (the transfer
length for the command), even if the reply is shorter than the SCSI
command buffer. This leads to issuers of the SCSI command to always get
a result without any residual (resid is always 0) despite the
potentially shorter reply for the command.

Modify all fill actors used by ata_scsi_rbuf_fill() to return the number
of bytes filled for the reply and 0 in case of error. Using this value,
add a call to scsi_set_resid() in ata_scsi_rbuf_fill() to set the
correct residual for the SCSI command when the reply length is shorter
than the command buffer.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20241022024537.251905-7-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: e6d7eba23b66 ("ata: libata-scsi: report correct sense field pointer in ata_scsiop_maint_in()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |   81 ++++++++++++++++++++++++++--------------------
 1 file changed, 47 insertions(+), 34 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1920,17 +1920,19 @@ static void ata_scsi_rbuf_fill(struct at
 		unsigned int (*actor)(struct ata_device *dev,
 				      struct scsi_cmnd *cmd, u8 *rbuf))
 {
-	unsigned int rc;
 	unsigned long flags;
+	unsigned int len;
 
 	spin_lock_irqsave(&ata_scsi_rbuf_lock, flags);
 
 	memset(ata_scsi_rbuf, 0, ATA_SCSI_RBUF_SIZE);
-	rc = actor(dev, cmd, ata_scsi_rbuf);
-	if (rc == 0) {
+	len = actor(dev, cmd, ata_scsi_rbuf);
+	if (len) {
 		sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
 				    ata_scsi_rbuf, ATA_SCSI_RBUF_SIZE);
 		cmd->result = SAM_STAT_GOOD;
+		if (scsi_bufflen(cmd) > len)
+			scsi_set_resid(cmd, scsi_bufflen(cmd) - len);
 	}
 
 	spin_unlock_irqrestore(&ata_scsi_rbuf_lock, flags);
@@ -2018,7 +2020,11 @@ static unsigned int ata_scsiop_inq_std(s
 	else
 		memcpy(rbuf + 58, versions, sizeof(versions));
 
-	return 0;
+	/*
+	 * Include all 8 possible version descriptors, even if not all of
+	 * them are popoulated.
+	 */
+	return 96;
 }
 
 /**
@@ -2055,7 +2061,8 @@ static unsigned int ata_scsiop_inq_00(st
 		num_pages++;
 	}
 	rbuf[3] = num_pages;	/* number of supported VPD pages */
-	return 0;
+
+	return get_unaligned_be16(&rbuf[2]) + 4;
 }
 
 /**
@@ -2082,7 +2089,8 @@ static unsigned int ata_scsiop_inq_80(st
 	memcpy(rbuf, hdr, sizeof(hdr));
 	ata_id_string(dev->id, (unsigned char *) &rbuf[4],
 		      ATA_ID_SERNO, ATA_ID_SERNO_LEN);
-	return 0;
+
+	return get_unaligned_be16(&rbuf[2]) + 4;
 }
 
 /**
@@ -2143,7 +2151,8 @@ static unsigned int ata_scsiop_inq_83(st
 		num += ATA_ID_WWN_LEN;
 	}
 	rbuf[3] = num - 4;    /* page len (assume less than 256 bytes) */
-	return 0;
+
+	return get_unaligned_be16(&rbuf[2]) + 4;
 }
 
 /**
@@ -2180,7 +2189,8 @@ static unsigned int ata_scsiop_inq_89(st
 	rbuf[56] = ATA_CMD_ID_ATA;
 
 	memcpy(&rbuf[60], &dev->id[0], 512);
-	return 0;
+
+	return get_unaligned_be16(&rbuf[2]) + 4;
 }
 
 /**
@@ -2231,7 +2241,7 @@ static unsigned int ata_scsiop_inq_b0(st
 		put_unaligned_be32(1, &rbuf[28]);
 	}
 
-	return 0;
+	return get_unaligned_be16(&rbuf[2]) + 4;
 }
 
 /**
@@ -2261,7 +2271,7 @@ static unsigned int ata_scsiop_inq_b1(st
 	if (zoned)
 		rbuf[8] = (zoned << 4);
 
-	return 0;
+	return get_unaligned_be16(&rbuf[2]) + 4;
 }
 
 /**
@@ -2284,7 +2294,7 @@ static unsigned int ata_scsiop_inq_b2(st
 	rbuf[3] = 0x4;
 	rbuf[5] = 1 << 6;	/* TPWS */
 
-	return 0;
+	return get_unaligned_be16(&rbuf[2]) + 4;
 }
 
 /**
@@ -2304,7 +2314,7 @@ static unsigned int ata_scsiop_inq_b6(st
 {
 	if (!ata_dev_is_zac(dev)) {
 		ata_scsi_set_invalid_field(dev, cmd, 2, 0xff);
-		return 1;
+		return 0;
 	}
 
 	/*
@@ -2322,7 +2332,7 @@ static unsigned int ata_scsiop_inq_b6(st
 	put_unaligned_be32(dev->zac_zones_optimal_nonseq, &rbuf[12]);
 	put_unaligned_be32(dev->zac_zones_max_open, &rbuf[16]);
 
-	return 0;
+	return get_unaligned_be16(&rbuf[2]) + 4;
 }
 
 /**
@@ -2346,7 +2356,7 @@ static unsigned int ata_scsiop_inq_b9(st
 
 	if (!cpr_log) {
 		ata_scsi_set_invalid_field(dev, cmd, 2, 0xff);
-		return 1;
+		return 0;
 	}
 
 	/* SCSI Concurrent Positioning Ranges VPD page: SBC-5 rev 1 or later */
@@ -2360,7 +2370,7 @@ static unsigned int ata_scsiop_inq_b9(st
 		put_unaligned_be64(cpr_log->cpr[i].num_lbas, &desc[16]);
 	}
 
-	return 0;
+	return get_unaligned_be16(&rbuf[2]) + 4;
 }
 
 /**
@@ -2382,7 +2392,7 @@ static unsigned int ata_scsiop_inquiry(s
 	/* is CmdDt set?  */
 	if (scsicmd[1] & 2) {
 		ata_scsi_set_invalid_field(dev, cmd, 1, 0xff);
-		return 1;
+		return 0;
 	}
 
 	/* Is EVPD clear? */
@@ -2410,7 +2420,7 @@ static unsigned int ata_scsiop_inquiry(s
 		return ata_scsiop_inq_b9(dev, cmd, rbuf);
 	default:
 		ata_scsi_set_invalid_field(dev, cmd, 2, 0xff);
-		return 1;
+		return 0;
 	}
 }
 
@@ -2741,24 +2751,27 @@ static unsigned int ata_scsiop_mode_sens
 			rbuf[3] = sizeof(sat_blk_desc);
 			memcpy(rbuf + 4, sat_blk_desc, sizeof(sat_blk_desc));
 		}
-	} else {
-		put_unaligned_be16(p - rbuf - 2, &rbuf[0]);
-		rbuf[3] |= dpofua;
-		if (ebd) {
-			rbuf[7] = sizeof(sat_blk_desc);
-			memcpy(rbuf + 8, sat_blk_desc, sizeof(sat_blk_desc));
-		}
+
+		return rbuf[0] + 1;
 	}
-	return 0;
+
+	put_unaligned_be16(p - rbuf - 2, &rbuf[0]);
+	rbuf[3] |= dpofua;
+	if (ebd) {
+		rbuf[7] = sizeof(sat_blk_desc);
+		memcpy(rbuf + 8, sat_blk_desc, sizeof(sat_blk_desc));
+	}
+
+	return get_unaligned_be16(&rbuf[0]) + 2;
 
 invalid_fld:
 	ata_scsi_set_invalid_field(dev, cmd, fp, bp);
-	return 1;
+	return 0;
 
 saving_not_supp:
 	ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST, 0x39, 0x0);
 	 /* "Saving parameters not supported" */
-	return 1;
+	return 0;
 }
 
 /**
@@ -2801,7 +2814,7 @@ static unsigned int ata_scsiop_read_cap(
 		rbuf[6] = sector_size >> (8 * 1);
 		rbuf[7] = sector_size;
 
-		return 0;
+		return 8;
 	}
 
 	/*
@@ -2811,7 +2824,7 @@ static unsigned int ata_scsiop_read_cap(
 	if (scsicmd[0] != SERVICE_ACTION_IN_16 ||
 	    (scsicmd[1] & 0x1f) != SAI_READ_CAPACITY_16) {
 		ata_scsi_set_invalid_field(dev, cmd, 1, 0xff);
-		return 1;
+		return 0;
 	}
 
 	/* sector count, 64-bit */
@@ -2846,7 +2859,7 @@ static unsigned int ata_scsiop_read_cap(
 		}
 	}
 
-	return 0;
+	return 16;
 }
 
 /**
@@ -2865,7 +2878,7 @@ static unsigned int ata_scsiop_report_lu
 {
 	rbuf[3] = 8;	/* just one lun, LUN 0, size 8 bytes */
 
-	return 0;
+	return 16;
 }
 
 /*
@@ -3593,13 +3606,13 @@ static unsigned int ata_scsiop_maint_in(
 
 	if ((cdb[1] & 0x1f) != MI_REPORT_SUPPORTED_OPERATION_CODES) {
 		ata_scsi_set_invalid_field(dev, cmd, 1, 0xff);
-		return 1;
+		return 0;
 	}
 
 	if (cdb[2] != 1 && cdb[2] != 3) {
 		ata_dev_warn(dev, "invalid command format %d\n", cdb[2]);
 		ata_scsi_set_invalid_field(dev, cmd, 1, 0xff);
-		return 1;
+		return 0;
 	}
 
 	switch (cdb[3]) {
@@ -3672,7 +3685,7 @@ static unsigned int ata_scsiop_maint_in(
 	rbuf[0] = rwcdlp;
 	rbuf[1] = cdlp | supported;
 
-	return 0;
+	return 4;
 }
 
 /**


