Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA1232D42B;
	Sat, 30 May 2026 16:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160117; cv=none; b=AgjgCrhRMn3fPlLIu6Qe96UX8Gt4HRZv1OiObdpRoADqFZ2/S97lPtehnAkRH3abSe6nIk6sKbEBkzucjoAjB7dQrwT9tegMnweCgAqOgd6B7RCsPUpAEwfTOxZ6CV/PYKkq5bVrYqnRmbvYJ7GsTv4GMID0ByukNwdOZcapRKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160117; c=relaxed/simple;
	bh=GESWl/z8+dt7v+nOK4u5ItRcWxubmh3IbpNbkomR8Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLy5OL1xg1QZrzfAYvd+txBb573owwHH5Sw920GCbCDhwNieLtAL7ZMjgbZNPuc0dtHIBMV2ApOx+njpKc8dbjOnHgvV8eb0H3V9uI4argPyfwc2NFgzh3tob/RNYM0FGJCQllVRvePGF+OG+po7j+6m87+2q+4GooE5zSMMdRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8DN5352; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8DN5352"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC3B1F00898;
	Sat, 30 May 2026 16:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160116;
	bh=5emSgzHkLOE3d/lE813nZ4efoPHSQXpP6QuS5w3acDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y8DN5352HWd8o4YP1mfp8OSuTTidNGKJEVXKGek61tRHVp2/hDIeN+D0FEnBAKEnV
	 skeoZC5jVuqknOyFzUVoZbJlSH/1iOWQ6OGffIMkDlpJL5AbUbwjiIsOpB5qvEkxcA
	 3GqyLKy9Dn2KP77zhNlX2VUxL/voLTiqEFhjK478=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 6.1 249/969] md/raid5: validate payload size before accessing journal metadata
Date: Sat, 30 May 2026 17:56:13 +0200
Message-ID: <20260530160307.344135035@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2012,15 +2012,27 @@ r5l_recovery_verify_data_checksum_for_mb
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
@@ -2033,22 +2045,18 @@ r5l_recovery_verify_data_checksum_for_mb
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
@@ -2099,6 +2107,7 @@ r5c_recovery_analyze_meta_block(struct r
 	log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
 
 	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+		sector_t payload_len;
 		int dd;
 
 		payload = (void *)mb + mb_offset;
@@ -2107,6 +2116,12 @@ r5c_recovery_analyze_meta_block(struct r
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
@@ -2120,12 +2135,17 @@ r5c_recovery_analyze_meta_block(struct r
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
@@ -2190,9 +2210,7 @@ r5c_recovery_analyze_meta_block(struct r
 		log_offset = r5l_ring_add(log, log_offset,
 					  le32_to_cpu(payload->size));
 
-		mb_offset += sizeof(struct r5l_payload_data_parity) +
-			sizeof(__le32) *
-			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+		mb_offset += payload_len;
 	}
 
 	return 0;


