Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E927530569C;
	Fri, 15 May 2026 16:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860976; cv=none; b=eyGiUJubI+2d+O2Gp5XCxpqZOJUHTkDMRR18ztbzIaSZccDqa8fAlXacUuSpfoBE17K9Y5z22DzSHSXXwq6VFxaHdxBE24McFFWTg3sXX4ZorjTbeC9Tbqh38Hrp0wQU3JfKT85Ak2x8NROYIzr41JtNPRt7frSY+5tnoHQJ/0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860976; c=relaxed/simple;
	bh=cNV0LpT4J5aeiH/IWYGvVYisqfyxmCIcLKP2m4IgXn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTBzCUNnjDNhBTw+Y4CIRQtAHOZxt94O6R/fIRtCo9EonD2sI46S2+uYK2qQl00CZnubIctgpnm6LKRx1X2wwXFRnqiNo5biBY2tXpChbFMOIEMsjU37tB09Veh00FKz4OIrmfeFquNN4oUZf7iPPChNe1VadJTHP32EVtfdwWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPhaztnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPhaztnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5647FC2BCB0;
	Fri, 15 May 2026 16:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860975;
	bh=cNV0LpT4J5aeiH/IWYGvVYisqfyxmCIcLKP2m4IgXn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPhaztnUW6cwZVUlgpxiQcum9cYYoZ0wYLosUElvRVVqua1piayJ1AwANa5j6SHyM
	 csVFHIq0cnU3hIBRBt8Cz40rpVm/p+LaSO/nXvw7pn1HuqEqJxhBRhgA27d3Mr4Qpw
	 4//OmdapWqPYbPbZBuH3rXBKl0Y3PRamLEUHpIio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 6.6 114/474] md/raid5: validate payload size before accessing journal metadata
Date: Fri, 15 May 2026 17:43:43 +0200
Message-ID: <20260515154717.503151934@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -2010,15 +2010,27 @@ r5l_recovery_verify_data_checksum_for_mb
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
@@ -2031,22 +2043,18 @@ r5l_recovery_verify_data_checksum_for_mb
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
@@ -2097,6 +2105,7 @@ r5c_recovery_analyze_meta_block(struct r
 	log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
 
 	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+		sector_t payload_len;
 		int dd;
 
 		payload = (void *)mb + mb_offset;
@@ -2105,6 +2114,12 @@ r5c_recovery_analyze_meta_block(struct r
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
@@ -2118,12 +2133,17 @@ r5c_recovery_analyze_meta_block(struct r
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
@@ -2188,9 +2208,7 @@ r5c_recovery_analyze_meta_block(struct r
 		log_offset = r5l_ring_add(log, log_offset,
 					  le32_to_cpu(payload->size));
 
-		mb_offset += sizeof(struct r5l_payload_data_parity) +
-			sizeof(__le32) *
-			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+		mb_offset += payload_len;
 	}
 
 	return 0;


