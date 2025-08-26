Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3067E267386;
	Tue, 26 Aug 2025 11:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207150; cv=none; b=eYiL7ZbrvbBtiIDM9E13kCmHiO1I6tl/rWj4LJJ8o84LPOeK2c2Fo7fNkguikmKIhunqmIgWKYm3eGEn75qOJ6jsDcrD42U7Q3h0ZrRYFgV/oP5BCPGw43YRu576LSdDdOvhV28VLRKnI32x7akT1h2AJy6/q44IPLWWRlmiQrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207150; c=relaxed/simple;
	bh=ZvlfWnQaMIHfqW8kkIePGCtSCpeNyYtGWVq2GPUk8ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOiuUKFmg2O15I2fJU2JTZJcjs78dTTFwEhrdCkVbqiIeZROjIoylGtJCMXvzB3ZOIl+YzSwa6ls4EdBtug+10BvjZp4En9JcfnEod9Yh5ElJmQJVHthBxRQsTCMbjpb22brmnCREoeHmZ6KCfPPYX/PFJEN40zxMRzl5ScjSRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KG9y2sBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KG9y2sBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5773EC4CEF1;
	Tue, 26 Aug 2025 11:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207149;
	bh=ZvlfWnQaMIHfqW8kkIePGCtSCpeNyYtGWVq2GPUk8ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KG9y2sBcc87q22RXSta8zh+8srgWLKQKdSN6tXHZs3VoY9qGLr4pjtAN3sXTppkMw
	 4VZugdaRHK3E/rGSJ4VytrSpZcebfj2OfCtjuqahxd4JBfGhA2S4och/clqRdt8QSE
	 dFq/mkoQxwrysCarWM0bznvLuJQlsD4mKnwV+CVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.16 069/457] ata: libata-scsi: Return aborted command when missing sense and result TF
Date: Tue, 26 Aug 2025 13:05:53 +0200
Message-ID: <20250826110939.073272858@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/ata/libata-scsi.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -938,6 +938,8 @@ static void ata_gen_passthru_sense(struc
 	if (!(qc->flags & ATA_QCFLAG_RTF_FILLED)) {
 		ata_dev_dbg(dev,
 			    "missing result TF: can't generate ATA PT sense data\n");
+		if (qc->err_mask)
+			ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND, 0, 0);
 		return;
 	}
 
@@ -992,8 +994,8 @@ static void ata_gen_ata_sense(struct ata
 
 	if (!(qc->flags & ATA_QCFLAG_RTF_FILLED)) {
 		ata_dev_dbg(dev,
-			    "missing result TF: can't generate sense data\n");
-		return;
+			    "Missing result TF: reporting aborted command\n");
+		goto aborted;
 	}
 
 	/* Use ata_to_sense_error() to map status register bits
@@ -1004,13 +1006,15 @@ static void ata_gen_ata_sense(struct ata
 		ata_to_sense_error(tf->status, tf->error,
 				   &sense_key, &asc, &ascq);
 		ata_scsi_set_sense(dev, cmd, sense_key, asc, ascq);
-	} else {
-		/* Could not decode error */
-		ata_dev_warn(dev, "could not decode error status 0x%x err_mask 0x%x\n",
-			     tf->status, qc->err_mask);
-		ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND, 0, 0);
 		return;
 	}
+
+	/* Could not decode error */
+	ata_dev_warn(dev,
+		"Could not decode error 0x%x, status 0x%x (err_mask=0x%x)\n",
+		tf->error, tf->status, qc->err_mask);
+aborted:
+	ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND, 0, 0);
 }
 
 void ata_scsi_sdev_config(struct scsi_device *sdev)


