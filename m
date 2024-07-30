Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76431A76BD;
	Tue, 30 Jul 2024 17:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360099; cv=none; b=VaBfK2BqjtTd5q4u/uyC0kxaAsC93DsX5/i4zhxbA2BUfjbsq2a6jUMjKnDTd1lznbw0vM0qdg//i60LNjV1jxnaR6tG6pBUfnUHVrzBpz79gb9uhXq8uKBVQpc16S6PT8M7zjPJfow3UsHayOHDXmYepI7M418654T17URhSJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360099; c=relaxed/simple;
	bh=Vvhkqryfytxq+75kPq5UQUKSI5fckhvHD0016/jJ81c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Df3o5N50JlZNaWVgRKtYlWk8XSDy/+lpR05+3mEe/pnzMKBgrWtYKBIRI9tqmi44vTh4N/XgOpoJN7PAKWLTDEVjt3wIj7XbtX7T8HylUsxQvFBQMIvPp2mNdrOUEEnaoaYhr1lKzqYPfeEECaafU3kqAUkUwOtF3j7oSRfy9FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jt7k/HTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jt7k/HTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12025C32782;
	Tue, 30 Jul 2024 17:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360099;
	bh=Vvhkqryfytxq+75kPq5UQUKSI5fckhvHD0016/jJ81c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jt7k/HTd0W/T2nnE3ezLYusX/NmW56cOefnKHHJyufcEkFwKGpHK+yQjJIGSpV3yt
	 1JIsGbwf5HkB72z7xgEyfnTUe7eKSIvP2gtvjCkjp7VtsNu2ggEeLNAOFAEtpcKM/K
	 N1GVs5zaSFabQxvjQ0ofL48kefXxxZPhPFXcW9Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akshat Jain <akshatzen@google.com>,
	Hannes Reinecke <hare@suse.de>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>
Subject: [PATCH 6.10 565/809] ata: libata-scsi: Fix offsets for the fixed format sense data
Date: Tue, 30 Jul 2024 17:47:21 +0200
Message-ID: <20240730151747.084906011@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Pylypiv <ipylypiv@google.com>

commit 38dab832c3f4154968f95b267a3bb789e87554b0 upstream.

Correct the ATA PASS-THROUGH fixed format sense data offsets to conform
to SPC-6 and SAT-5 specifications. Additionally, set the VALID bit to
indicate that the INFORMATION field contains valid information.

INFORMATION
===========

SAT-5 Table 212 — "Fixed format sense data INFORMATION field for the ATA
PASS-THROUGH commands" defines the following format:

+------+------------+
| Byte |   Field    |
+------+------------+
|    0 | ERROR      |
|    1 | STATUS     |
|    2 | DEVICE     |
|    3 | COUNT(7:0) |
+------+------------+

SPC-6 Table 48 - "Fixed format sense data" specifies that the INFORMATION
field starts at byte 3 in sense buffer resulting in the following offsets
for the ATA PASS-THROUGH commands:

+------------+-------------------------+
|   Field    |  Offset in sense buffer |
+------------+-------------------------+
| ERROR      |  3                      |
| STATUS     |  4                      |
| DEVICE     |  5                      |
| COUNT(7:0) |  6                      |
+------------+-------------------------+

COMMAND-SPECIFIC INFORMATION
============================

SAT-5 Table 213 - "Fixed format sense data COMMAND-SPECIFIC INFORMATION
field for ATA PASS-THROUGH" defines the following format:

+------+-------------------+
| Byte |        Field      |
+------+-------------------+
|    0 | FLAGS | LOG INDEX |
|    1 | LBA (7:0)         |
|    2 | LBA (15:8)        |
|    3 | LBA (23:16)       |
+------+-------------------+

SPC-6 Table 48 - "Fixed format sense data" specifies that
the COMMAND-SPECIFIC-INFORMATION field starts at byte 8
in sense buffer resulting in the following offsets for
the ATA PASS-THROUGH commands:

Offsets of these fields in the fixed sense format are as follows:

+-------------------+-------------------------+
|       Field       |  Offset in sense buffer |
+-------------------+-------------------------+
| FLAGS | LOG INDEX |  8                      |
| LBA (7:0)         |  9                      |
| LBA (15:8)        |  10                     |
| LBA (23:16)       |  11                     |
+-------------------+-------------------------+

Reported-by: Akshat Jain <akshatzen@google.com>
Fixes: 11093cb1ef56 ("libata-scsi: generate correct ATA pass-through sense")
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Link: https://lore.kernel.org/r/20240702024735.1152293-2-ipylypiv@google.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -855,7 +855,6 @@ static void ata_gen_passthru_sense(struc
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_taskfile *tf = &qc->result_tf;
 	unsigned char *sb = cmd->sense_buffer;
-	unsigned char *desc = sb + 8;
 	u8 sense_key, asc, ascq;
 
 	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
@@ -877,7 +876,8 @@ static void ata_gen_passthru_sense(struc
 		scsi_build_sense(cmd, 1, RECOVERED_ERROR, 0, 0x1D);
 	}
 
-	if ((cmd->sense_buffer[0] & 0x7f) >= 0x72) {
+	if ((sb[0] & 0x7f) >= 0x72) {
+		unsigned char *desc;
 		u8 len;
 
 		/* descriptor format */
@@ -916,21 +916,21 @@ static void ata_gen_passthru_sense(struc
 		}
 	} else {
 		/* Fixed sense format */
-		desc[0] = tf->error;
-		desc[1] = tf->status;
-		desc[2] = tf->device;
-		desc[3] = tf->nsect;
-		desc[7] = 0;
+		sb[0] |= 0x80;
+		sb[3] = tf->error;
+		sb[4] = tf->status;
+		sb[5] = tf->device;
+		sb[6] = tf->nsect;
 		if (tf->flags & ATA_TFLAG_LBA48)  {
-			desc[8] |= 0x80;
+			sb[8] |= 0x80;
 			if (tf->hob_nsect)
-				desc[8] |= 0x40;
+				sb[8] |= 0x40;
 			if (tf->hob_lbal || tf->hob_lbam || tf->hob_lbah)
-				desc[8] |= 0x20;
+				sb[8] |= 0x20;
 		}
-		desc[9] = tf->lbal;
-		desc[10] = tf->lbam;
-		desc[11] = tf->lbah;
+		sb[9] = tf->lbal;
+		sb[10] = tf->lbam;
+		sb[11] = tf->lbah;
 	}
 }
 


