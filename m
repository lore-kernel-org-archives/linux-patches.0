Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992B927FD56;
	Wed, 23 Apr 2025 14:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420147; cv=none; b=VIlE5d6IwmdDNqsdjOgGnhT+Y7ZYP2UDgoO67BUifdyj5KUrtxSG6jVY/XMeKdKE1DB++AkhfBnolKyYI2/q4r1z3dv7Bejx4/qN2u0/Rd7h92ApXdNGpM9f8xXdXYF08y4RYdVpnjSprSdI7nN23XlT5IWEShz3pXqaBQOsDBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420147; c=relaxed/simple;
	bh=TVrbWaFI4LS5KgmEj4NeQur9EhjFjQo3gPVFGjQAVAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nspcmdn2Rhyjja2qPgtyBst9l1h3crv64stAIXR7AKW9k3yv6wzw97V+2xFdKaORNxjZezTR7BhbI0rE2nQ+I+M2zQsmbPPoll1IL9VE5NOGiLk8HSsXEIyDQFb2q8PhorRtn3VT2D8rV1YZTbaQehBKaPFL+Omiun5X6ojzhZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpPVv/gn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpPVv/gn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2DAC4CEE2;
	Wed, 23 Apr 2025 14:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420147;
	bh=TVrbWaFI4LS5KgmEj4NeQur9EhjFjQo3gPVFGjQAVAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpPVv/gnyDwydsh990RBfogR2PKlyiT8QncgntCIIv1ACLzGK0r6WQmoilXM+t/r/
	 pIGcL2KB4GLtvozQqBjj4sIZMjrrDGOvyVTk++gZQ3YQQqFRH+36zVxCLJXAQBaeyf
	 dxu5KUuFFOxQe+suRrIFK4bfCJxZp91pg2NKOPDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 063/241] ata: libata-sata: Save all fields from sense data descriptor
Date: Wed, 23 Apr 2025 16:42:07 +0200
Message-ID: <20250423142623.176292859@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index ba300cc0a3a32..2e4463d3a3561 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1510,6 +1510,8 @@ int ata_eh_get_ncq_success_sense(struct ata_link *link)
 	unsigned int err_mask, tag;
 	u8 *sense, sk = 0, asc = 0, ascq = 0;
 	u64 sense_valid, val;
+	u16 extended_sense;
+	bool aux_icc_valid;
 	int ret = 0;
 
 	err_mask = ata_read_log_page(dev, ATA_LOG_SENSE_NCQ, 0, buf, 2);
@@ -1529,6 +1531,8 @@ int ata_eh_get_ncq_success_sense(struct ata_link *link)
 
 	sense_valid = (u64)buf[8] | ((u64)buf[9] << 8) |
 		((u64)buf[10] << 16) | ((u64)buf[11] << 24);
+	extended_sense = get_unaligned_le16(&buf[14]);
+	aux_icc_valid = extended_sense & BIT(15);
 
 	ata_qc_for_each_raw(ap, qc, tag) {
 		if (!(qc->flags & ATA_QCFLAG_EH) ||
@@ -1556,6 +1560,17 @@ int ata_eh_get_ncq_success_sense(struct ata_link *link)
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



