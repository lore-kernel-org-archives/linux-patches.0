Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8444E8E08;
	Tue, 13 Oct 2026 11:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892148; cv=none; b=bb4AMQWRT1/Kz9tC75F3PwX75apiKvlAlb0wu0aCydhwbu4y/qwDfrFt+rDgJWW2N5xVBykRF+R2LT4YPmJ+XzvgBZlF9H6v+C2uezRvcUZynpV7aBEUmfUmxUM+gY1HJeyE7Ybvf4lWB49nS5snf0HaM0bUEMSJKFQ/yEt0jWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892148; c=relaxed/simple;
	bh=XksS9KcYAhwJw+bQlF2nmb45n0Vz0tSzZB5t0UCTXJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnl46YmLmN8DbZpOW9d5M1GzZObvnHq2obMul4+FpI52IKAhzEArgdBLGlF9Z3dvKha3oYTbSLXqEidGC8Whiebs9Pjg5A5X7yozsh/hvgjn7dOh6FqYAek/hTmIXASZTdCMxZkdEx8w9jCszcrR5jhFvTOyTd9qQXvo8ARcNhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtWUJ/CH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtWUJ/CH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7141E1F000FF;
	Tue, 13 Oct 2026 11:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892147;
	bh=lut8UZt2mkwTmaH2VEB03wetKqozEKGgd9A2ODV7FO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CtWUJ/CHkt1GucCisEZPDFFS02qAyBmawZZ9b3O4uOhrYnK2EIdO1lhlWpsLD+SeA
	 FjZo9QwwEPyjsIcc1N+xZBwv8uELlHEKsGoBZzEZqmIzagx/VqC/W0gxCMFH2PQJa8
	 xE7B8G84CIVbBrcNfYZRulOD8UtADuG4giVDaSag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 074/281] dm-integrity: fix buffer overflow in inline mode with large tag size
Date: Tue, 13 Oct 2026 13:36:30 +0200
Message-ID: <20261013112856.924134129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Cressey <ben@cressey.dev>

commit 764b683a6180fd72c931c13fea98d383506a3475 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2721,7 +2721,7 @@ static void dm_integrity_inline_recheck(
 	outgoing_data = dio->integrity_payload + PAGE_SIZE;
 
 	while (dio->bio_details.bi_iter.bi_size) {
-		char digest[HASH_MAX_DIGESTSIZE];
+		char digest[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 		int r;
 		struct bio_integrity_payload *bip;
 		struct bio_vec bv;
@@ -2788,7 +2788,7 @@ static inline bool dm_integrity_check(st
 	unsigned pos = 0;
 
 	while (dio->bio_details.bi_iter.bi_size) {
-		char digest[HASH_MAX_DIGESTSIZE];
+		char digest[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 		struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
 		char *mem = integrity_kmap(ic, bv.bv_page);
 		integrity_sector_checksum(ic, &dio->ahash_req, dio->bio_details.bi_iter.bi_sector, mem, bv.bv_offset, digest);


