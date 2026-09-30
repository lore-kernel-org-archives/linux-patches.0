Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3224248D9;
	Wed, 30 Sep 2026 19:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797002; cv=none; b=WcFO0eqBM7k5KyeOuG9owRJU7RfhQiksNFsT2MUpwENF4VSVt1057Zjra41p+d26MOWH0gjYcDmNDK2M/h1C7BGOpW5n1bcNlTBtdGW4sU5Cwr4HW4KUTKSCpMeVlQEefP6d43RXJZWQHiNbHm2gipIViJt8IychpKQeWwYqy40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797002; c=relaxed/simple;
	bh=hVA+hLN7xeBwGh4+kSJlUl+FENrRtidNBXoB558JiN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FauWMUPUZSHZWW6fU3Ae/gYJCIEnDUpQebQQhO+N669t2F8aAk8ncFfIGZ9ZVXX0742gWwp01Yk4nq6XG9UqYo1JUz5F7MJC7o+k8FVjqRB6G02zZ2uvPSBuW9tzs03ehzNBC+F9TleD1ENt54gfium2HmpcCM0ZAbvdF7X9wFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNCT3QmU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNCT3QmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9DE1F000FF;
	Wed, 30 Sep 2026 19:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797000;
	bh=1LMSwVUrgYWB3wY0AaDQY3Nfux+/QcXr1veYjn0xo0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CNCT3QmUxXNn1fUvpdi36WuFlyTHqV2J+CUeiKT8qKm8dQrQf1htrALzjoNFdjzLB
	 2ekrvfZS7REjugj4+6i2E1Vxr+PmAD6gf1B58i/+rfCrDSVDQVsAijs2HG1xODT2E4
	 juJ/dah9+ZkO3YxPxXdbe9Htq2RrjmaPYKaLzOmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.6 1095/1193] ata: libata-scsi: bound the ATA passthru sense descriptor writes
Date: Wed, 30 Sep 2026 17:29:39 +0200
Message-ID: <20260930152458.561859644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -257,12 +257,18 @@ static void ata_scsi_set_passthru_sense_
 
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


