Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6C827CB12;
	Wed, 23 Apr 2025 14:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419745; cv=none; b=d53vzUluQXb+0KCzMfzO+ak7qhcKcyLR6VyJaxrbayQQVZSNGxnTlM4U9wHO2/gkYgJo+w8F1Jy9esANImKWtXsBsaKELYYcuihWQkm8TEBoJv6uq+OP9XiFAStq2o/VzC3c8C1gw9XI03+UKzanbr46zNFilfn3zPTPVa5ovlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419745; c=relaxed/simple;
	bh=6ZYvM6pZUxwSylLvbmuHv7ypQMntLUJpNWpi/uO72Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtBffNZlLwtwas0UTJ018nhrjVLEipk8PlApVoJDgGtHitjJhX4FN/WbcXtouYRCemkzQqd6KlXDMhhwAZ6yTLIHLHS9ghBvsEdISGn+uF6KVLNMna0ElD4mWdwBUGqlv6zDIdgVZw6PfXkIIJ2WkJ08vs8YgbZIACHyoKWwgdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPwe/i1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPwe/i1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AE5C4CEEB;
	Wed, 23 Apr 2025 14:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419744;
	bh=6ZYvM6pZUxwSylLvbmuHv7ypQMntLUJpNWpi/uO72Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yPwe/i1RgY2I1+eS86zJDN1Hu+46JLmAQ/6/2T2ijM3dI+Jktm7mpF1p9fkkcI7QM
	 ONqvq4zLweLdJ6G0mssoY1WeSqAValKMkKGgr1yYdWv6+WRWLJlA564VT9/+foV7VF
	 rcWwvn89tkQ9GwEnPyON1ZQrTQ4NSr3P/RKARjPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/223] ata: libata-sata: Save all fields from sense data descriptor
Date: Wed, 23 Apr 2025 16:42:06 +0200
Message-ID: <20250423142619.329833677@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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
index 9c76fb1ad2ec5..a7442dc0bd8e1 100644
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



