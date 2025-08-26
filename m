Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DAA29BDB8;
	Tue, 26 Aug 2025 11:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208277; cv=none; b=kPS2nV0y+Y3MtPhaSKPou7WuwgFtpXtV3LCEi+heQFHk0+wAIUnzmBL9JDewEOjLghDL+VrVEsKoLF1Y+kQG+gNesdRpuhdDh+MNM8j/L0l5cWVl7DWwWoJbCKzllvOB74CCWz4HwZvUNeiNWfWnie6CSgwH5Wz8/e/desxcOtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208277; c=relaxed/simple;
	bh=YgxSQyT9acoMV0N66+mkdvIKiOofv+OnKV5TsJJCbuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVv7uURDKA+odI2uc5j1zrXuoNoAOI5J9PV6rZdGVWSsz4LbN+xtPJmCCAOIhLzwuS9mkWRKWXhmGZuGfpWoX02FFm+tAZR2dM95kCwfw4uF400UsLmJUqQtUGecQjcHM7fFDtUjtowjdyMQnQT+X4Bo70U+3HwH+DF+xfERvis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqUY7/56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqUY7/56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8867FC4CEF1;
	Tue, 26 Aug 2025 11:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208276;
	bh=YgxSQyT9acoMV0N66+mkdvIKiOofv+OnKV5TsJJCbuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqUY7/56VPF6wcE1OxpG+62WCwEKBBaSx3gEW930QSKMyh6myoN5e5yKMrtqshTJX
	 8OT6+aeQgTeblJGF3cfBGpd/LDd2AbMLHgAAOYuZ6zCR2EH+j/lIt0rCAjCEAEcD5p
	 kUVZ0DKlYN2Mar41B82G6x0Bq2DKPrqCp/wsGai8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenz Brun <lorenz@brun.one>,
	Brandon Schwartz <Brandon.Schwartz@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 050/322] ata: libata-scsi: Fix ata_to_sense_error() status handling
Date: Tue, 26 Aug 2025 13:07:45 +0200
Message-ID: <20250826110916.634391561@linuxfoundation.org>
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

commit cf3fc037623c54de48d2ec1a1ee686e2d1de2d45 upstream.

Commit 8ae720449fca ("libata: whitespace fixes in ata_to_sense_error()")
inadvertantly added the entry 0x40 (ATA_DRDY) to the stat_table array in
the function ata_to_sense_error(). This entry ties a failed qc which has
a status filed equal to ATA_DRDY to the sense key ILLEGAL REQUEST with
the additional sense code UNALIGNED WRITE COMMAND. This entry will be
used to generate a failed qc sense key and sense code when the qc is
missing sense data and there is no match for the qc error field in the
sense_table array of ata_to_sense_error().

As a result, for a failed qc for which we failed to get sense data (e.g.
read log 10h failed if qc is an NCQ command, or REQUEST SENSE EXT
command failed for the non-ncq case, the user very often end up seeing
the completely misleading "unaligned write command" error, even if qc
was not a write command. E.g.:

sd 0:0:0:0: [sda] tag#12 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:0:0: [sda] tag#12 Sense Key : Illegal Request [current]
sd 0:0:0:0: [sda] tag#12 Add. Sense: Unaligned write command
sd 0:0:0:0: [sda] tag#12 CDB: Read(10) 28 00 00 00 10 00 00 00 08 00
I/O error, dev sda, sector 4096 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0

Fix this by removing the ATA_DRDY entry from the stat_table array so
that we default to always returning ABORTED COMMAND without any
additional sense code, since we do not know any better. The entry 0x08
(ATA_DRQ) is also removed since signaling ABORTED COMMAND with a parity
error is also misleading (as a parity error would likely be signaled
through a bus error). So for this case, also default to returning
ABORTED COMMAND without any additional sense code. With this, the
previous example error case becomes:

sd 0:0:0:0: [sda] tag#17 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:0:0: [sda] tag#17 Sense Key : Aborted Command [current]
sd 0:0:0:0: [sda] tag#17 Add. Sense: No additional sense information
sd 0:0:0:0: [sda] tag#17 CDB: Read(10) 28 00 00 00 10 00 00 00 08 00
I/O error, dev sda, sector 4096 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0

Together with these fixes, refactor stat_table to make it more readable
by putting the entries comments in front of the entries and using the
defined status bits macros instead of hardcoded values.

Reported-by: Lorenz Brun <lorenz@brun.one>
Reported-by: Brandon Schwartz <Brandon.Schwartz@wdc.com>
Fixes: 8ae720449fca ("libata: whitespace fixes in ata_to_sense_error()")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -855,18 +855,14 @@ static void ata_to_sense_error(u8 drv_st
 		{0xFF, 0xFF, 0xFF, 0xFF}, // END mark
 	};
 	static const unsigned char stat_table[][4] = {
-		/* Must be first because BUSY means no other bits valid */
-		{0x80,		ABORTED_COMMAND, 0x47, 0x00},
-		// Busy, fake parity for now
-		{0x40,		ILLEGAL_REQUEST, 0x21, 0x04},
-		// Device ready, unaligned write command
-		{0x20,		HARDWARE_ERROR,  0x44, 0x00},
-		// Device fault, internal target failure
-		{0x08,		ABORTED_COMMAND, 0x47, 0x00},
-		// Timed out in xfer, fake parity for now
-		{0x04,		RECOVERED_ERROR, 0x11, 0x00},
-		// Recovered ECC error	  Medium error, recovered
-		{0xFF, 0xFF, 0xFF, 0xFF}, // END mark
+		/* Busy: must be first because BUSY means no other bits valid */
+		{ ATA_BUSY,	ABORTED_COMMAND, 0x00, 0x00 },
+		/* Device fault: INTERNAL TARGET FAILURE */
+		{ ATA_DF,	HARDWARE_ERROR,  0x44, 0x00 },
+		/* Corrected data error */
+		{ ATA_CORR,	RECOVERED_ERROR, 0x00, 0x00 },
+
+		{ 0xFF, 0xFF, 0xFF, 0xFF }, /* END mark */
 	};
 
 	/*


