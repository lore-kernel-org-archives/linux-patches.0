Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF01393DD1;
	Tue, 26 Aug 2025 11:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208567; cv=none; b=lcnQV0C9l1t8VdBa226iIJsRTLK86EET74ON9dATaSP0Y6vkOeO4J1Bzj5vG9T3wPftyjRpW+pTqTo76p8E6ibyTm0VClJ0a1KFBiJKTWAAxIhIT0wvoBPtL55++hhd4W3M6I2y2IkSNF4MtM9vY+/NLTIf3UuC3eG/ftqlD5bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208567; c=relaxed/simple;
	bh=6UMVWvmxOP5e+qYLz3EIOqScWQuKYYwiq+Ra+HG+ZV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gb3t9BLAfON6sfP19Aeb7dPljCPxdpOH9e+1A5kxrima/tKPTt89MkWbfH54uZhRNKsL+4wncOZZMgfXjBT4Ut02iY2DuG6rdyjIzWawXSaR070I9LyQfnf9x8jKEQNx+SgqeCNhsgIPs7Fi5dYGM7U31B2nGLbIHudVeJoEeK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIzCl93S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIzCl93S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75147C4CEF1;
	Tue, 26 Aug 2025 11:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208566;
	bh=6UMVWvmxOP5e+qYLz3EIOqScWQuKYYwiq+Ra+HG+ZV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIzCl93SDPd4janP+GmM6+bmRix8ar7GYJQDG8D596VQcq4yV7C4krf7W6CfBb3+y
	 x4T/kSwy6IP1nNjpy9MQGFxDiJYYxnxQmPM3WO5ixjxS6uLJw/vxSBrorqKWYH1Pew
	 +nb7PyXKS7ikogMmhXB+rdJ/q5Al4UBMSJxHycSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 160/322] ata: libata-scsi: Return aborted command when missing sense and result TF
Date: Tue, 26 Aug 2025 13:09:35 +0200
Message-ID: <20250826110919.773177603@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit d2be9ea9a75550a35c5127a6c2633658bc38c76b upstream.

ata_gen_ata_sense() is always called for a failed qc missing sense data
so that a sense key, code and code qualifier can be generated using
ata_to_sense_error() from the qc status and error fields of its result
task file. However, if the qc does not have its result task file filled,
ata_gen_ata_sense() returns early without setting a sense key.

Improve this by defaulting to returning ABORTED COMMAND without any
additional sense code, since we do not know the reason for the failure.
The same fix is also applied in ata_gen_passthru_sense() with the
additional check that the qc failed (qc->err_mask is set).

Fixes: 816be86c7993 ("ata: libata-scsi: Check ATA_QCFLAG_RTF_FILLED before using result_tf")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -934,6 +934,8 @@ static void ata_gen_passthru_sense(struc
 	if (!(qc->flags & ATA_QCFLAG_RTF_FILLED)) {
 		ata_dev_dbg(dev,
 			    "missing result TF: can't generate ATA PT sense data\n");
+		if (qc->err_mask)
+			ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND, 0, 0);
 		return;
 	}
 
@@ -991,8 +993,8 @@ static void ata_gen_ata_sense(struct ata
 
 	if (!(qc->flags & ATA_QCFLAG_RTF_FILLED)) {
 		ata_dev_dbg(dev,
-			    "missing result TF: can't generate sense data\n");
-		return;
+			    "Missing result TF: reporting aborted command\n");
+		goto aborted;
 	}
 
 	/* Use ata_to_sense_error() to map status register bits
@@ -1003,19 +1005,20 @@ static void ata_gen_ata_sense(struct ata
 		ata_to_sense_error(tf->status, tf->error,
 				   &sense_key, &asc, &ascq);
 		ata_scsi_set_sense(dev, cmd, sense_key, asc, ascq);
-	} else {
-		/* Could not decode error */
-		ata_dev_warn(dev, "could not decode error status 0x%x err_mask 0x%x\n",
-			     tf->status, qc->err_mask);
-		ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND, 0, 0);
-		return;
-	}
 
-	block = ata_tf_read_block(&qc->result_tf, dev);
-	if (block == U64_MAX)
+		block = ata_tf_read_block(&qc->result_tf, dev);
+		if (block != U64_MAX)
+			scsi_set_sense_information(sb, SCSI_SENSE_BUFFERSIZE,
+						   block);
 		return;
+	}
 
-	scsi_set_sense_information(sb, SCSI_SENSE_BUFFERSIZE, block);
+	/* Could not decode error */
+	ata_dev_warn(dev,
+		"Could not decode error 0x%x, status 0x%x (err_mask=0x%x)\n",
+		tf->error, tf->status, qc->err_mask);
+aborted:
+	ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND, 0, 0);
 }
 
 void ata_scsi_sdev_config(struct scsi_device *sdev)


