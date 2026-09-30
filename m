Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBE451616F;
	Wed, 30 Sep 2026 18:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793332; cv=none; b=pgPmIFNKcMacI7UTEebOmB8410vGs0teS1nB8RlEvB4IGZ2lcc8pVdL1dQAOxks23JhIGUBPebZ21l9yhyMEF6UgeX4NNpRpUOQlNtQ5+x1O98zEtRH5Hz869Lyq2qaXxUbdlrgWaM1STv6C3+B2sYKCh1e+l4CQj8errKdfenA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793332; c=relaxed/simple;
	bh=O1usd3XwGfBaP+fqMzqHjFG27gZyFEO8rxJA5EpcJxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MM65vzEj0tO6XDZjWYVxyQNd/AaCCVZBRuO6NOAuriHtFn19nbicLRGequxbQMAQ6tx/fXQC9k4gEKCOIe0gLHgG04bS2TbOdbA2kQPwj/HcXb2+G9kqVT5KCMI46UQyAFruBAcHME1hTnod4PXXmRWw8zyb7Rq1bkawbTxnew8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTlh5KZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTlh5KZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12C91F000FF;
	Wed, 30 Sep 2026 18:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793330;
	bh=j172tXyso+SftwmFrNFcTDmgP/zsNsHe5E4HYdMS6xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTlh5KZt+D9yC47JEAGKZmT99f+1MrXQ4rK9s2a4rYGkMUNMR4Z+ZgcchDS7avxcH
	 pPsEi4khGknwaArp9VOnZk1tkyP7g5u4CI4Mpf9+MGiq6fAy8gTfcnpfNWgbbt23dh
	 7wfmFOanB9EwEMze5edb8Ye8ekxqFW4X4RZm/aeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.18 215/395] ata: libata-scsi: bound the ATA passthru sense descriptor writes
Date: Wed, 30 Sep 2026 17:27:57 +0200
Message-ID: <20260930152345.324561855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Goergens <matthias.goergens@gmail.com>

commit 80320b278fea07ffcda3f57b67b61658e0a4e1ca upstream.

When an ATA PASS-THROUGH command to an ATAPI device fails, the sense
buffer holds the device's REQUEST SENSE reply, and
ata_scsi_set_passthru_sense_fields() trusts its additional length
byte, sb[7], when adding the ATA Status Return descriptor.  A faulty
or malicious device can use that to make the kernel read and write
past the 96-byte buffer in three ways:

- scsi_sense_desc_find() is passed sb[7] + 8 as the buffer length, so
  its clamp against sb[7] does nothing and the walk runs off the end.
- A type-9 descriptor found near the end is filled in unchecked.
- A new descriptor at sb[8 + len] needs len + 22 bytes, not len + 14,
  so len 75..82 writes up to 8 bytes past the end.

Reproduced with KASAN under qemu, with the emulated ATAPI REQUEST SENSE
reply patched:

  BUG: KASAN: slab-out-of-bounds in scsi_sense_desc_find+0x1a5/0x210
  BUG: KASAN: slab-out-of-bounds in ata_scsi_qc_complete+0x1a15/0x1a50

Both are gone with this patch, and a valid descriptor is still filled
in.

Fixes: 97981926224a ("ata: libata-scsi: Do not overwrite valid sense data when CK_COND=1")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Link: https://lore.kernel.org/r/20260923175203.1576825-1-matthias.goergens@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -261,12 +261,18 @@ static void ata_scsi_set_passthru_sense_
 
 		/* descriptor format */
 		len = sb[7];
-		desc = (char *)scsi_sense_desc_find(sb, len + 8, 9);
+		desc = (char *)scsi_sense_desc_find(sb, SCSI_SENSE_BUFFERSIZE, 9);
 		if (!desc) {
-			if (SCSI_SENSE_BUFFERSIZE < len + 14)
+			/*
+			 * The descriptor is written at sb[8 + len] and is 14
+			 * bytes long, so it needs len + 22 bytes of buffer.
+			 */
+			if (len + 22 > SCSI_SENSE_BUFFERSIZE)
 				return;
 			sb[7] = len + 14;
 			desc = sb + 8 + len;
+		} else if (desc - sb > SCSI_SENSE_BUFFERSIZE - 14) {
+			return;
 		}
 		desc[0] = 9;
 		desc[1] = 12;


