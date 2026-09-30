Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3661E51B167;
	Wed, 30 Sep 2026 17:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789395; cv=none; b=u/071JHIvTSe0Vmh/FExzfwGPArKDkBaD8us8PBDrKMLB5YWs4CrEff10QrwJ2xwIWy5lDLpJgevlCd4Vd2dSz3vISsNm21es8quxUlC6C+VlDNLXJJB1ghkpinfJLqgMZk/Fu9Su85qFp66OkqYEo/I6kr+xvFqW4ZykyrGLDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789395; c=relaxed/simple;
	bh=gSD6hLaZpSZMbqF+slFuvx45zeLDRZEXgvAsFj851sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6ROCiBbUIdEGvGfbnqkEpndc59+A7ZHZWCF+xubjNTlYGiRPLdWEYjoj6epYtDNn/pDqMgKpy8LDQYT/z2dp9aQb5bGglLMt1+RP4h8V26KbQ9QiFIXEKPNBcNLwa1H93IC6f2bFfL0gN29qtKMy3jVfp8jTLqIoGs5iWVvT5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6BnNm/F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6BnNm/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC1D1F000FF;
	Wed, 30 Sep 2026 17:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789394;
	bh=YwUR0oGb2bFf+THOLTJzw4EDR3Pn6KXzc1wQuao+xC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i6BnNm/Fevw0WrbR3PUscmgkNVYlnAB9OwIKDaOhqQLlGUKwVKMaCVG6XvGgN49eG
	 QLVO2LI3w0RzEvp87Qs4+pss3fPqjDWknY+D0sMI2/ySrGaox7j1oBhDevoVBFyV/f
	 uoR5y7Yl2sIEV0NpXI1SttdR5KGTSOGlnwzAA0g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 463/877] ata: libata-scsi: bound the ATA passthru sense descriptor writes
Date: Wed, 30 Sep 2026 17:22:54 +0200
Message-ID: <20260930152424.667378010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


