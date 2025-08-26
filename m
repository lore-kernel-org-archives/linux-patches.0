Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5044E33A015;
	Tue, 26 Aug 2025 13:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213762; cv=none; b=Xfv5eq/crXnonqNtYxIDtkFSJ/GiofT7b0H8qvQyrL+bd+IJQ0v/WN4HxDGas5STaSfWaPpL0htlwk9TwGhkc1MaMzYdPNDmRKeBy6jqavF0Wz87QTC3hXAUFosV6h5Q8TI8UnLwlvgpX7yP7CgH4ieCHHqbYQbw+3GyEd2T/o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213762; c=relaxed/simple;
	bh=3+tcUbr+tkZyO8ATvF/gguJkaycsrIYJw4YXvBLFqsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHy6YXTeow1a7pQ/fHpQVTFSW1TXEZYXOe+8JenXCjxrw/V2osITiVXQTqYkMWFZ7UzLfIc16GAyE66ax8pz3qA5rKvbGUehUfB/1DufHvX8NB+yr2/vQ2kUOYDiioPAYttIob9dYLfs5MgRt/gSPxCpWcfb5Jg9sl52rHceNpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2vM8Z74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2vM8Z74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF283C4CEF4;
	Tue, 26 Aug 2025 13:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213762;
	bh=3+tcUbr+tkZyO8ATvF/gguJkaycsrIYJw4YXvBLFqsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2vM8Z74i9XAaBFc3lGc754gEPdA+3R8/Pe+SanhIxais+GzOdfkJd8h3EaM+KiHq
	 ocKc8G9P0i+As+964lpqvWehcS1892udjWniDMZvwp/os9ZK5Z9cJ/vUsVXY0NXPX2
	 0svSUo8kLJJrkgc2+6qQGAn3iHSwIvFniYRn2+TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 469/587] ata: libata-scsi: Return aborted command when missing sense and result TF
Date: Tue, 26 Aug 2025 13:10:18 +0200
Message-ID: <20250826111004.906872639@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

Commit d2be9ea9a75550a35c5127a6c2633658bc38c76b upstream.

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
@@ -935,6 +935,8 @@ static void ata_gen_passthru_sense(struc
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
@@ -1004,19 +1006,20 @@ static void ata_gen_ata_sense(struct ata
 		ata_to_sense_error(qc->ap->print_id, tf->status, tf->error,
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


