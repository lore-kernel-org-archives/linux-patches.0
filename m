Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3112F17BEAE;
	Tue, 10 Sep 2024 09:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962196; cv=none; b=FFU0pEHAn0qzsp0zf8DFtiaHbz4Ep3h0asERQ3uDk8p6hJ2S+QYUm7LxnrOxMRBCqySyJLBoduUmOURYkZmeGRtHxa6LXMl+sKhDBr6uBJxqaA6natt/uPahMbCTLyWlCFU++G0IjI1LZ4fg1IQogI6xPB54d0qxnHHTTxzw+nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962196; c=relaxed/simple;
	bh=p6TsU7Zv978WNvPrx1ZOh9wStUxKvn0CS1SMAxOjpDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRieQx+dF0aAjku1FIKsUbeXXM/W+WS13iJx7A6KeYA8qbDjcuLD8MmTxE60pYE+fKLOJ+uRDUFz6YFk4NGlLoNMr1f8U5gZyR/d40BXK86uMBXBZLPU4cKOOf3mlB9r1DkwFdlowhHm24pqlocu1JZOsdoGalLqdtmFTZIvGqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1q0AgcHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1q0AgcHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC98C4CEC6;
	Tue, 10 Sep 2024 09:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962196;
	bh=p6TsU7Zv978WNvPrx1ZOh9wStUxKvn0CS1SMAxOjpDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1q0AgcHe27ENaRxu+biqap1K5xj/1dsqVe13SBTkcfmfjBaj7cNL8tr2TYNQFFX4r
	 a0spwsWZZoh0ksbEyGUkwWkrG7PdyGqfdVr2H2rAtRoxAuasKzVsnUZGtW677MY94U
	 ned5NI6Aa5MSvvW066QCM+rW6nq02KINddtBbVQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 328/375] ata: libata-scsi: Check ATA_QCFLAG_RTF_FILLED before using result_tf
Date: Tue, 10 Sep 2024 11:32:05 +0200
Message-ID: <20240910092633.589862374@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit 816be86c7993d3c5832c3017c0056297e86f978c ]

qc->result_tf contents are only valid when the ATA_QCFLAG_RTF_FILLED flag
is set. The ATA_QCFLAG_RTF_FILLED flag should be always set for commands
that failed or for commands that have the ATA_QCFLAG_RESULT_TF flag set.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Link: https://lore.kernel.org/r/20240702024735.1152293-8-ipylypiv@google.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4deee71006ef..4116ae088719 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -242,10 +242,17 @@ void ata_scsi_set_sense_information(struct ata_device *dev,
  */
 static void ata_scsi_set_passthru_sense_fields(struct ata_queued_cmd *qc)
 {
+	struct ata_device *dev = qc->dev;
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_taskfile *tf = &qc->result_tf;
 	unsigned char *sb = cmd->sense_buffer;
 
+	if (!(qc->flags & ATA_QCFLAG_RTF_FILLED)) {
+		ata_dev_dbg(dev,
+			    "missing result TF: can't set ATA PT sense fields\n");
+		return;
+	}
+
 	if ((sb[0] & 0x7f) >= 0x72) {
 		unsigned char *desc;
 		u8 len;
@@ -924,10 +931,17 @@ static void ata_to_sense_error(unsigned id, u8 drv_stat, u8 drv_err, u8 *sk,
  */
 static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 {
+	struct ata_device *dev = qc->dev;
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_taskfile *tf = &qc->result_tf;
 	u8 sense_key, asc, ascq;
 
+	if (!(qc->flags & ATA_QCFLAG_RTF_FILLED)) {
+		ata_dev_dbg(dev,
+			    "missing result TF: can't generate ATA PT sense data\n");
+		return;
+	}
+
 	/*
 	 * Use ata_to_sense_error() to map status register bits
 	 * onto sense key, asc & ascq.
@@ -979,6 +993,13 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 		ata_scsi_set_sense(dev, cmd, NOT_READY, 0x04, 0x21);
 		return;
 	}
+
+	if (!(qc->flags & ATA_QCFLAG_RTF_FILLED)) {
+		ata_dev_dbg(dev,
+			    "missing result TF: can't generate sense data\n");
+		return;
+	}
+
 	/* Use ata_to_sense_error() to map status register bits
 	 * onto sense key, asc & ascq.
 	 */
-- 
2.43.0



