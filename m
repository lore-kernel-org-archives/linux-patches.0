Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAF11E570E;
	Thu, 30 Jan 2025 14:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245757; cv=none; b=XFWBQUfxmfTrJ/28RROE6zOaIcIHG4DdPpI/i0GyFZXYccAgSy/q0oZWWB7nNjqfDC+u1nqG4U0nbzsd0ydlValQMG5j9rQrprXouY6dHjddEwXlYSXzYxunfkIpG507yn0ZT2dQAyYaLirXwicgOxJc+b4Oh8UY9wdw5UKyW0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245757; c=relaxed/simple;
	bh=EdBeF9gMBIygE/o3mHK26wH5lR40J4fk1D537HfkYVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c3CLR1FqRD2t1+KvMTn8hwnYLCXmwq5odBVRPFaxIYWjc08kyCxmhcynQTP7aZkW7g/fXSzRjfwCEvB8XXgHuDjS3if8aKJUsrgEvAvGOT7MauOwXXqMGCJObI5bvds8vXeXsSS3mBR7FXby81YGcwuuSFne+4XYVvASAJblTDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZ7NlM4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZ7NlM4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC85C4CEE0;
	Thu, 30 Jan 2025 14:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245757;
	bh=EdBeF9gMBIygE/o3mHK26wH5lR40J4fk1D537HfkYVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZ7NlM4qQ1MoprCLJHjljcRblQRCHka7uGi2LMLCEoUNN+rSnPFXYacFB83ELowm7
	 nuVRcN+cNW0VrWSfVP1+COd7Bwh1um13L/BZM3UpEauqfbN7AfFSyDiH/3c5tMkI2C
	 NIh/C46e8WeJhOHFMW2lNdm2GimMOfJb2DYEmzts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	=?UTF-8?q?Christian=20K=C3=BChnke?= <christian@kuehnke.de>
Subject: [PATCH 6.6 10/43] ata: libata-core: Set ATA_QCFLAG_RTF_FILLED in fill_result_tf()
Date: Thu, 30 Jan 2025 14:59:17 +0100
Message-ID: <20250130133459.317360459@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Pylypiv <ipylypiv@google.com>

commit 18676c6aab0863618eb35443e7b8615eea3535a9 upstream.

ATA_QCFLAG_RTF_FILLED is not specific to ahci and can be used generally
to check if qc->result_tf contains valid data.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Link: https://lore.kernel.org/r/20240702024735.1152293-7-ipylypiv@google.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Cc: Christian Kühnke <christian@kuehnke.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libahci.c     |   12 ++----------
 drivers/ata/libata-core.c |    8 ++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2082,13 +2082,6 @@ static void ahci_qc_fill_rtf(struct ata_
 	struct ahci_port_priv *pp = qc->ap->private_data;
 	u8 *rx_fis = pp->rx_fis;
 
-	/*
-	 * rtf may already be filled (e.g. for successful NCQ commands).
-	 * If that is the case, we have nothing to do.
-	 */
-	if (qc->flags & ATA_QCFLAG_RTF_FILLED)
-		return;
-
 	if (pp->fbs_enabled)
 		rx_fis += qc->dev->link->pmp * AHCI_RX_FIS_SZ;
 
@@ -2102,7 +2095,6 @@ static void ahci_qc_fill_rtf(struct ata_
 	    !(qc->flags & ATA_QCFLAG_EH)) {
 		ata_tf_from_fis(rx_fis + RX_FIS_PIO_SETUP, &qc->result_tf);
 		qc->result_tf.status = (rx_fis + RX_FIS_PIO_SETUP)[15];
-		qc->flags |= ATA_QCFLAG_RTF_FILLED;
 		return;
 	}
 
@@ -2125,12 +2117,10 @@ static void ahci_qc_fill_rtf(struct ata_
 		 */
 		qc->result_tf.status = fis[2];
 		qc->result_tf.error = fis[3];
-		qc->flags |= ATA_QCFLAG_RTF_FILLED;
 		return;
 	}
 
 	ata_tf_from_fis(rx_fis + RX_FIS_D2H_REG, &qc->result_tf);
-	qc->flags |= ATA_QCFLAG_RTF_FILLED;
 }
 
 static void ahci_qc_ncq_fill_rtf(struct ata_port *ap, u64 done_mask)
@@ -2165,6 +2155,7 @@ static void ahci_qc_ncq_fill_rtf(struct
 			if (qc && ata_is_ncq(qc->tf.protocol)) {
 				qc->result_tf.status = status;
 				qc->result_tf.error = error;
+				qc->result_tf.flags = qc->tf.flags;
 				qc->flags |= ATA_QCFLAG_RTF_FILLED;
 			}
 			done_mask &= ~(1ULL << tag);
@@ -2189,6 +2180,7 @@ static void ahci_qc_ncq_fill_rtf(struct
 			fis += RX_FIS_SDB;
 			qc->result_tf.status = fis[2];
 			qc->result_tf.error = fis[3];
+			qc->result_tf.flags = qc->tf.flags;
 			qc->flags |= ATA_QCFLAG_RTF_FILLED;
 		}
 		done_mask &= ~(1ULL << tag);
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4792,8 +4792,16 @@ static void fill_result_tf(struct ata_qu
 {
 	struct ata_port *ap = qc->ap;
 
+	/*
+	 * rtf may already be filled (e.g. for successful NCQ commands).
+	 * If that is the case, we have nothing to do.
+	 */
+	if (qc->flags & ATA_QCFLAG_RTF_FILLED)
+		return;
+
 	qc->result_tf.flags = qc->tf.flags;
 	ap->ops->qc_fill_rtf(qc);
+	qc->flags |= ATA_QCFLAG_RTF_FILLED;
 }
 
 static void ata_verify_xfer(struct ata_queued_cmd *qc)


