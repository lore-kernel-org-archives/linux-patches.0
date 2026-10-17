Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75963D994;
	Sat, 17 Oct 2026 16:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253170; cv=none; b=ZFTLupPKP3RTwHVmlkCkv9Z99P80XEtck+2huqXAH132sshrr1RIzTdeNhjAmPO6e6nQKdE0UAvG1v7J4wtXHur2ED3ffEZwYfojoW/90fI1kVmVTc1U8OzzQ6KeY6+5tZSY1aXVGHXSFzkxG9LCJTH5m+8CVnbsEI/cxJFcjvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253170; c=relaxed/simple;
	bh=jW1h61EBLfIknY0M2xVayrb/aLUfTQ2EY8oc5NDYxD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZGVJ5EJ2k67+WNjOyWiIi4AoSkMT0x3G+qzIhfvwVC6NIz6ivUTOf6SweAkutT1sb4Apq/2GikKWRx74rXhXS59cy7cBkSxzNrSV8GOhB8j0cTFo6QOgpebouuJyqembEGwiuqZ+dszxOkhIg4lXQoYSZPQmw7IZy6GtpKfT6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkw3NAgG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkw3NAgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D5D1F000C4;
	Sat, 17 Oct 2026 16:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253169;
	bh=Zxf+77ndVuLF5swpWMsFbVGeadB6sZ3EtwMKJ3yaUto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mkw3NAgGDEDvRi7pZPByoaILZu5ZcIzEZwyQ54UrPIWgUZvij8PQc4a4jJCctn+zR
	 9Wo3B/piRZPnhQ9ZjBgaNpRFCKg3ZBUD//dtmOKQIHqEjJBM2elN0+jV4zGb2sAvYV
	 B4JCUujzQ/hXdvPnsLrkqCQs72vO1tZXFTs6ZtZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/869] dm-integrity: fix buffer overflow in inline mode with large tag size
Date: Sat, 17 Oct 2026 17:47:54 +0200
Message-ID: <20261017160037.863771077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Ben Cressey <ben@cressey.dev>

[ Upstream commit 764b683a6180fd72c931c13fea98d383506a3475 ]

In inline mode, dm_integrity_check and dm_integrity_inline_recheck
compute the checksum of each block into an on-stack buffer of
HASH_MAX_DIGESTSIZE bytes. integrity_sector_checksum pads its result
with zeroes up to the tag size, so if the tag size is larger than
HASH_MAX_DIGESTSIZE, the padding runs past the end of the buffer. With
CONFIG_STACKPROTECTOR the kernel panics in dm_integrity_check on the
first read.

Enlarge both buffers to hold MAX_TAG_SIZE bytes, as commit b93b6643e9b5
("dm integrity: fix a crash with unusually large tag size") did for
integrity_metadata.

Note that this is not a security bug because the buffer overflow can only
be triggered by root.

Fixes: fb0987682c62 ("dm-integrity: introduce the Inline mode")
Cc: stable@vger.kernel.org
Signed-off-by: Ben Cressey <ben@cressey.dev>
Assisted-by: LLM
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
[ sashal: Adapted the dm_integrity_check() hunk to the existing verification loop in dm_integrity_end_io(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index bdc83a5f583b9..e43892d1619db 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2548,7 +2548,7 @@ static void dm_integrity_inline_recheck(struct work_struct *w)
 	outgoing_data = dio->integrity_payload + PAGE_SIZE;
 
 	while (dio->bio_details.bi_iter.bi_size) {
-		char digest[HASH_MAX_DIGESTSIZE];
+		char digest[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 		int r;
 		struct bio_integrity_payload *bip;
 		struct bio_vec bv;
@@ -2626,7 +2626,7 @@ static int dm_integrity_end_io(struct dm_target *ti, struct bio *bio, blk_status
 			    unlikely(dio->integrity_range_locked))
 				goto skip_check;
 			while (dio->bio_details.bi_iter.bi_size) {
-				char digest[HASH_MAX_DIGESTSIZE];
+				char digest[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 				struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
 				char *mem = bvec_kmap_local(&bv);
 				//memset(mem, 0xff, ic->sectors_per_block << SECTOR_SHIFT);
-- 
2.53.0



