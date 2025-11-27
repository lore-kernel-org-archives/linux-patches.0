Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C86334C07;
	Thu, 27 Nov 2025 14:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255553; cv=none; b=aEnfoEN3jJYLl/QpTHzmX/ulB80Q8M12jo+nRyyNbpWWhzc9JTSyJTO73zmpQ5gollcFDAOdyOLS9Ijme+wdIQuXWwQ53ctwFldOmM0OZQK4oav5g/LzUW1vPsxVkmYn3Q6Socr0E+5xIkfddjbGzeAUwstOCm7Q1XcW9IOUlPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255553; c=relaxed/simple;
	bh=NAnneL8yCvNhuDvhXIWU49ZJtBvGj8v0YBzsWPaaHeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQ7aqKa52+Hux7idLTGpVzGiffcHQw2+JNx75ylPEeunuYrDWY20uOWvxv2qf96rVmGl9HTEM3FMKk0s8cB2o6TrLrcuXp4S1mNRF7gG/QQORSuo9MYnZW6OwHIkQTFfVvYsVkSDl7QR+CMcfr6gLueTpE1Uykatj/mPxcTjLck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hw5wOOcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hw5wOOcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0E3C113D0;
	Thu, 27 Nov 2025 14:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255552;
	bh=NAnneL8yCvNhuDvhXIWU49ZJtBvGj8v0YBzsWPaaHeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hw5wOOcw7HSexYn0jXdDLjHeg1+bGTqty5mv+8Z5743jgH5Xltu+zz4N08IigFRMP
	 lBwqlH4nOwQ8CfyxIFx8FJRhlzeqbqnClHJAlZhxNYOP0+uEDN0+erPqd2LqanHPF1
	 v+gSnIi7OEfMc4TjvsgKbYMTLvwG0IxoHfH5C7FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Baryshnikov <qwelias@gmail.com>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.17 025/175] ata: libata-scsi: Fix system suspend for a security locked drive
Date: Thu, 27 Nov 2025 15:44:38 +0100
Message-ID: <20251127144043.883736331@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit b11890683380a36b8488229f818d5e76e8204587 upstream.

Commit cf3fc037623c ("ata: libata-scsi: Fix ata_to_sense_error() status
handling") fixed ata_to_sense_error() to properly generate sense key
ABORTED COMMAND (without any additional sense code), instead of the
previous bogus sense key ILLEGAL REQUEST with the additional sense code
UNALIGNED WRITE COMMAND, for a failed command.

However, this broke suspend for Security locked drives (drives that have
Security enabled, and have not been Security unlocked by boot firmware).

The reason for this is that the SCSI disk driver, for the Synchronize
Cache command only, treats any sense data with sense key ILLEGAL REQUEST
as a successful command (regardless of ASC / ASCQ).

After commit cf3fc037623c ("ata: libata-scsi: Fix ata_to_sense_error()
status handling") the code that treats any sense data with sense key
ILLEGAL REQUEST as a successful command is no longer applicable, so the
command fails, which causes the system suspend to be aborted:

  sd 1:0:0:0: PM: dpm_run_callback(): scsi_bus_suspend returns -5
  sd 1:0:0:0: PM: failed to suspend async: error -5
  PM: Some devices failed to suspend, or early wake event detected

To make suspend work once again, for a Security locked device only,
return sense data LOGICAL UNIT ACCESS NOT AUTHORIZED, the actual sense
data which a real SCSI device would have returned if locked.
The SCSI disk driver treats this sense data as a successful command.

Cc: stable@vger.kernel.org
Reported-by: Ilia Baryshnikov <qwelias@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220704
Fixes: cf3fc037623c ("ata: libata-scsi: Fix ata_to_sense_error() status handling")
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    7 +++++++
 include/linux/ata.h       |    1 +
 2 files changed, 8 insertions(+)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -992,6 +992,13 @@ static void ata_gen_ata_sense(struct ata
 		return;
 	}
 
+	if (ata_id_is_locked(dev->id)) {
+		/* Security locked */
+		/* LOGICAL UNIT ACCESS NOT AUTHORIZED */
+		ata_scsi_set_sense(dev, cmd, DATA_PROTECT, 0x74, 0x71);
+		return;
+	}
+
 	if (!(qc->flags & ATA_QCFLAG_RTF_FILLED)) {
 		ata_dev_dbg(dev,
 			    "Missing result TF: reporting aborted command\n");
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -566,6 +566,7 @@ struct ata_bmdma_prd {
 #define ata_id_has_ncq(id)	((id)[ATA_ID_SATA_CAPABILITY] & (1 << 8))
 #define ata_id_queue_depth(id)	(((id)[ATA_ID_QUEUE_DEPTH] & 0x1f) + 1)
 #define ata_id_removable(id)	((id)[ATA_ID_CONFIG] & (1 << 7))
+#define ata_id_is_locked(id)	(((id)[ATA_ID_DLF] & 0x7) == 0x7)
 #define ata_id_has_atapi_AN(id)	\
 	((((id)[ATA_ID_SATA_CAPABILITY] != 0x0000) && \
 	  ((id)[ATA_ID_SATA_CAPABILITY] != 0xffff)) && \


