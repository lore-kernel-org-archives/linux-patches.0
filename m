Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D30279DC9;
	Sat, 30 May 2026 18:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165800; cv=none; b=fwZZaKxsu6ZOGVBysPTMzCxxQK1kkI+E/MfzLNrdvW2KGwZAPbBJeOc/tu9sPdru1UkBg7HTKR815WqycyvSzFobmh01C2TEtlHTenFFgxTLL96iCNN4feRWj76hV/sxxjdxXTkaVzJB2Kt/2luDRMpmlaFVvzallcHJ61/zJXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165800; c=relaxed/simple;
	bh=Uj5HHqhHF5KkFt4yzJWJe/l6FquwR6LJ2z1zgHROk50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEzuftvcozvkC4F//t+W0k3NSwj2YFC5WE7DJu8xiY1wtK5AaLiOIL0eBNWFxiPBpBvv5FbyRjMGgPV/1XIly+T0IscHTki0BzUEMnigv9c6Mrd9TCDxfSh6/BVYO5NF7qnxWGoShUNYxmiSMHF046jv7RYqvvQ//q53SrzX1Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbefJxM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbefJxM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D371F00893;
	Sat, 30 May 2026 18:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165799;
	bh=daBXnxbW3l+Y7Fou4EZJ8m9bUfLy+zdeSMK2RbERHuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbefJxM1fu0ZxRnA5r2PbWpEfAGOSRohC+70lHiiBEHPNngeoM3qDrgXoAHvVP8ds
	 NETR5RU02rfkwJtguEDql49fc4YoSIzwQHayYYLnQ97UV2G4zjWyK9rrFQI3Sb56FS
	 CAnisrYBZcLdIDIhgDM56ihjVvZjZj8hksWk/Xn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 5.10 186/589] md/raid5: validate payload size before accessing journal metadata
Date: Sat, 30 May 2026 18:01:07 +0200
Message-ID: <20260530160229.777578970@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit b0cc3ae97e893bf54bbce447f4e9fd2e0b88bff9 upstream.

r5c_recovery_analyze_meta_block() and
r5l_recovery_verify_data_checksum_for_mb() iterate over payloads in a
journal metadata block using on-disk payload size fields without
validating them against the remaining space in the metadata block.

A corrupted journal contains payload sizes extending beyond the PAGE_SIZE
boundary can cause out-of-bounds reads when accessing payload fields or
computing offsets.

Add bounds validation for each payload type to ensure the full payload
fits within meta_size before processing.

Fixes: b4c625c67362 ("md/r5cache: r5cache recovery: part 1")
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://lore.kernel.org/linux-raid/SYBPR01MB78815E78D829BB86CD7C8015AF5FA@SYBPR01MB7881.ausprd01.prod.outlook.com/
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5-cache.c |   48 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2017,15 +2017,27 @@ r5l_recovery_verify_data_checksum_for_mb
 		return -ENOMEM;
 
 	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+		sector_t payload_len;
+
 		payload = (void *)mb + mb_offset;
 		payload_flush = (void *)mb + mb_offset;
 
 		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) {
+			payload_len = sizeof(struct r5l_payload_data_parity) +
+				(sector_t)sizeof(__le32) *
+				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+				goto mismatch;
 			if (r5l_recovery_verify_data_checksum(
 				    log, ctx, page, log_offset,
 				    payload->checksum[0]) < 0)
 				goto mismatch;
 		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_PARITY) {
+			payload_len = sizeof(struct r5l_payload_data_parity) +
+				(sector_t)sizeof(__le32) *
+				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+				goto mismatch;
 			if (r5l_recovery_verify_data_checksum(
 				    log, ctx, page, log_offset,
 				    payload->checksum[0]) < 0)
@@ -2038,22 +2050,18 @@ r5l_recovery_verify_data_checksum_for_mb
 				    payload->checksum[1]) < 0)
 				goto mismatch;
 		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
-			/* nothing to do for R5LOG_PAYLOAD_FLUSH here */
+			payload_len = sizeof(struct r5l_payload_flush) +
+				(sector_t)le32_to_cpu(payload_flush->size);
+			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+				goto mismatch;
 		} else /* not R5LOG_PAYLOAD_DATA/PARITY/FLUSH */
 			goto mismatch;
 
-		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
-			mb_offset += sizeof(struct r5l_payload_flush) +
-				le32_to_cpu(payload_flush->size);
-		} else {
-			/* DATA or PARITY payload */
+		if (le16_to_cpu(payload->header.type) != R5LOG_PAYLOAD_FLUSH) {
 			log_offset = r5l_ring_add(log, log_offset,
 						  le32_to_cpu(payload->size));
-			mb_offset += sizeof(struct r5l_payload_data_parity) +
-				sizeof(__le32) *
-				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
 		}
-
+		mb_offset += payload_len;
 	}
 
 	put_page(page);
@@ -2104,6 +2112,7 @@ r5c_recovery_analyze_meta_block(struct r
 	log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
 
 	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+		sector_t payload_len;
 		int dd;
 
 		payload = (void *)mb + mb_offset;
@@ -2112,6 +2121,12 @@ r5c_recovery_analyze_meta_block(struct r
 		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
 			int i, count;
 
+			payload_len = sizeof(struct r5l_payload_flush) +
+				(sector_t)le32_to_cpu(payload_flush->size);
+			if (mb_offset + payload_len >
+			    le32_to_cpu(mb->meta_size))
+				return -EINVAL;
+
 			count = le32_to_cpu(payload_flush->size) / sizeof(__le64);
 			for (i = 0; i < count; ++i) {
 				stripe_sect = le64_to_cpu(payload_flush->flush_stripes[i]);
@@ -2125,12 +2140,17 @@ r5c_recovery_analyze_meta_block(struct r
 				}
 			}
 
-			mb_offset += sizeof(struct r5l_payload_flush) +
-				le32_to_cpu(payload_flush->size);
+			mb_offset += payload_len;
 			continue;
 		}
 
 		/* DATA or PARITY payload */
+		payload_len = sizeof(struct r5l_payload_data_parity) +
+			(sector_t)sizeof(__le32) *
+			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+		if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+			return -EINVAL;
+
 		stripe_sect = (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) ?
 			raid5_compute_sector(
 				conf, le64_to_cpu(payload->location), 0, &dd,
@@ -2195,9 +2215,7 @@ r5c_recovery_analyze_meta_block(struct r
 		log_offset = r5l_ring_add(log, log_offset,
 					  le32_to_cpu(payload->size));
 
-		mb_offset += sizeof(struct r5l_payload_data_parity) +
-			sizeof(__le32) *
-			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+		mb_offset += payload_len;
 	}
 
 	return 0;


