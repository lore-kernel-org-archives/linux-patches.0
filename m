Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A632228D83D;
	Wed, 23 Apr 2025 15:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422073; cv=none; b=KFclD94D38eCKU7JLL7LE/HZqe5V2sr2lBSteHw6lNrUImOFJP/Nc6eDZCQ+5L48MjEXL1ypNSzYz8Tt7QHGKaPjsoS+PJ8fNfZ/UQqQhqW6QFEt/h9JXYK69Gc/5cBA0fL2GhltqH6KT96nTKFawzL8zgkAxBi2bvUCqjq+WQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422073; c=relaxed/simple;
	bh=sSZFYT9KDWJeETVC3axn7hQ142uyp3NE9bR0ZGAP3io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6oCvXjJrbkVPaq2P8DgRq4QcqayBhE08aMnjaB71vjhKHa4o55gEgBNxDRCsf4pXrpa0d4bj9Hg3UXhMQKsPhzh/yUJxLB+dYjW3Zeg2vEwW1Dd9XgF1He2qVhKt9vRbnFG/QlSczRVjTmRXSVk44Oc0gyeI00dqgJMi+WiEBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htB971Cj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htB971Cj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4579C4CEE2;
	Wed, 23 Apr 2025 15:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422073;
	bh=sSZFYT9KDWJeETVC3axn7hQ142uyp3NE9bR0ZGAP3io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htB971Cj9eNXE+I0jRjQbJj+1j8skC69BsZwI02A7m6tvho/HbeamhppMhDNtGAvP
	 qx3f+Ep9FwOAmmLnc9h1OAY8dTL6FE9AuNzMMjlL6r+h0uU6LwDHgiui2E5OvrG+X/
	 fTnrvO0CAVXs4Vgw060bnB76yLANo10PR1/39xzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 273/393] ata: libata-sata: Save all fields from sense data descriptor
Date: Wed, 23 Apr 2025 16:42:49 +0200
Message-ID: <20250423142654.631465847@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 399eab7f92fb73ffe621294a2d6bec8fc9f3b36b ]

When filling the taskfile result for a successful NCQ command, we use
the SDB FIS from the FIS Receive Area, see e.g. ahci_qc_ncq_fill_rtf().

However, the SDB FIS only has fields STATUS and ERROR.

For a successful NCQ command that has sense data, we will have a
successful sense data descriptor, in the Sense Data for Successful NCQ
Commands log.

Since we have access to additional taskfile result fields, fill in these
additional fields in qc->result_tf.

This matches how for failing/aborted NCQ commands, we will use e.g.
ahci_qc_fill_rtf() to fill in some fields, but then for the command that
actually caused the NCQ error, we will use ata_eh_read_log_10h(), which
provides additional fields, saving additional fields/overriding the
qc->result_tf that was fetched using ahci_qc_fill_rtf().

Fixes: 18bd7718b5c4 ("scsi: ata: libata: Handle completion of CDL commands using policy 0xD")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-sata.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index a701e1538482f..be72030a500d4 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1365,6 +1365,8 @@ int ata_eh_read_sense_success_ncq_log(struct ata_link *link)
 	unsigned int err_mask, tag;
 	u8 *sense, sk = 0, asc = 0, ascq = 0;
 	u64 sense_valid, val;
+	u16 extended_sense;
+	bool aux_icc_valid;
 	int ret = 0;
 
 	err_mask = ata_read_log_page(dev, ATA_LOG_SENSE_NCQ, 0, buf, 2);
@@ -1384,6 +1386,8 @@ int ata_eh_read_sense_success_ncq_log(struct ata_link *link)
 
 	sense_valid = (u64)buf[8] | ((u64)buf[9] << 8) |
 		((u64)buf[10] << 16) | ((u64)buf[11] << 24);
+	extended_sense = get_unaligned_le16(&buf[14]);
+	aux_icc_valid = extended_sense & BIT(15);
 
 	ata_qc_for_each_raw(ap, qc, tag) {
 		if (!(qc->flags & ATA_QCFLAG_EH) ||
@@ -1411,6 +1415,17 @@ int ata_eh_read_sense_success_ncq_log(struct ata_link *link)
 			continue;
 		}
 
+		qc->result_tf.nsect = sense[6];
+		qc->result_tf.hob_nsect = sense[7];
+		qc->result_tf.lbal = sense[8];
+		qc->result_tf.lbam = sense[9];
+		qc->result_tf.lbah = sense[10];
+		qc->result_tf.hob_lbal = sense[11];
+		qc->result_tf.hob_lbam = sense[12];
+		qc->result_tf.hob_lbah = sense[13];
+		if (aux_icc_valid)
+			qc->result_tf.auxiliary = get_unaligned_le32(&sense[16]);
+
 		/* Set sense without also setting scsicmd->result */
 		scsi_build_sense_buffer(dev->flags & ATA_DFLAG_D_SENSE,
 					qc->scsicmd->sense_buffer, sk,
-- 
2.39.5



