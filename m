Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9EE1C68A6;
	Wed, 19 Feb 2025 09:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957049; cv=none; b=VBMs0+LzB1patKPXiINDVxiD0nNsVo/DnQq0gH16MBWWwV6aL1s0ysQJAW9p7tK5m7ak1PuiWqfSboY2Yu3Z/bAK1dIUZO5VA0//amefGSBaeLIhhm2RYkwLXPLqgqM7bFUpRBT5OcBbhGpMATGOwTPIND9iJ0gzLzjNgq+ZyGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957049; c=relaxed/simple;
	bh=HDKr0BDy+0Zu8JU8h02LnK3JazIuo2NTBfLfW3Bhy1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qtt/wGkmpUbcdIP9iLX7XHVEWyHgxGwTkCZC2mjLTdms2gKbkx21R2xa+oYwnWPYAkF0fMIhS2oPllfFT4yuJDkFejHVvJ2TTvmXodCQbfm6kvRBq982d+k+yyVldgAgH6rXxOoN/8XBTJok90mK8+X7eKpHS1cXIXxayk5KkA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqBDbDjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqBDbDjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55719C4CEE6;
	Wed, 19 Feb 2025 09:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957049;
	bh=HDKr0BDy+0Zu8JU8h02LnK3JazIuo2NTBfLfW3Bhy1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqBDbDjWYzO02ZxXsd5YxPionl6g6RflQk3QsvpTzO031hhd0XUEt+2w2KLMZrg5/
	 ugrIP6OFH+UaNHaJhg1Plmw25vLTALd5eWC7G2/pl5e0Uy67s4+4EuUkbsXkU1Xkvm
	 fJr09k5OB2gPNWTrxGpRnQN1HIMGcTl59x5wYItU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 383/578] dm-crypt: track tag_offset in convert_context
Date: Wed, 19 Feb 2025 09:26:27 +0100
Message-ID: <20250219082708.090809664@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

commit 8b8f8037765757861f899ed3a2bfb34525b5c065 upstream.

dm-crypt uses tag_offset to index the integrity metadata for each crypt
sector. When the initial crypt_convert() returns BLK_STS_DEV_RESOURCE,
dm-crypt will try to continue the crypt/decrypt procedure in a kworker.
However, it resets tag_offset as zero instead of using the tag_offset
related with current sector. It may return unexpected data when using
random IV or return unexpected integrity related error.

Fix the problem by tracking tag_offset in per-IO convert_context.
Therefore, when the crypt/decrypt procedure continues in a kworker, it
could use the next tag_offset saved in convert_context.

Fixes: 8abec36d1274 ("dm crypt: do not wait for backlogged crypto request completion in softirq")
Cc: stable@vger.kernel.org
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -56,6 +56,7 @@ struct convert_context {
 	struct bio *bio_out;
 	struct bvec_iter iter_out;
 	atomic_t cc_pending;
+	unsigned int tag_offset;
 	u64 cc_sector;
 	union {
 		struct skcipher_request *req;
@@ -1223,6 +1224,7 @@ static void crypt_convert_init(struct cr
 	if (bio_out)
 		ctx->iter_out = bio_out->bi_iter;
 	ctx->cc_sector = sector + cc->iv_offset;
+	ctx->tag_offset = 0;
 	init_completion(&ctx->restart);
 }
 
@@ -1554,7 +1556,6 @@ static void crypt_free_req(struct crypt_
 static blk_status_t crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx, bool atomic, bool reset_pending)
 {
-	unsigned int tag_offset = 0;
 	unsigned int sector_step = cc->sector_size >> SECTOR_SHIFT;
 	int r;
 
@@ -1577,9 +1578,9 @@ static blk_status_t crypt_convert(struct
 		atomic_inc(&ctx->cc_pending);
 
 		if (crypt_integrity_aead(cc))
-			r = crypt_convert_block_aead(cc, ctx, ctx->r.req_aead, tag_offset);
+			r = crypt_convert_block_aead(cc, ctx, ctx->r.req_aead, ctx->tag_offset);
 		else
-			r = crypt_convert_block_skcipher(cc, ctx, ctx->r.req, tag_offset);
+			r = crypt_convert_block_skcipher(cc, ctx, ctx->r.req, ctx->tag_offset);
 
 		switch (r) {
 		/*
@@ -1599,8 +1600,8 @@ static blk_status_t crypt_convert(struct
 					 * exit and continue processing in a workqueue
 					 */
 					ctx->r.req = NULL;
+					ctx->tag_offset++;
 					ctx->cc_sector += sector_step;
-					tag_offset++;
 					return BLK_STS_DEV_RESOURCE;
 				}
 			} else {
@@ -1614,8 +1615,8 @@ static blk_status_t crypt_convert(struct
 		 */
 		case -EINPROGRESS:
 			ctx->r.req = NULL;
+			ctx->tag_offset++;
 			ctx->cc_sector += sector_step;
-			tag_offset++;
 			continue;
 		/*
 		 * The request was already processed (synchronously).
@@ -1623,7 +1624,7 @@ static blk_status_t crypt_convert(struct
 		case 0:
 			atomic_dec(&ctx->cc_pending);
 			ctx->cc_sector += sector_step;
-			tag_offset++;
+			ctx->tag_offset++;
 			if (!atomic)
 				cond_resched();
 			continue;


