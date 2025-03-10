Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0B61C4A24;
	Mon, 10 Mar 2025 17:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629516; cv=none; b=Hyok7Wftsa60Ri/KZE8modq8dMS9lKjN0dZl1ot4TRu+boGtsmnZBDEShXJugegiaxD5sAr4UF0/CfPyNAGQLatgeZUKW/mtxDIaptDf1sDiGYbg9jvYH6MvQxw6eqo1kh78pl37NQKShxiQHqrPGoB4+cRZYnJ+gYXIo5KwrO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629516; c=relaxed/simple;
	bh=V7d54BTjqfJ+dlJRFg6WaAFkhccH8bF4oj7r9ZLyNSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p76nGoOJqT/BeuZOOu3Xq+bR+tN6GzRo6QGGPi1C1IHMEXbFxZT6ScMlGCEMuz5X4AjzxbVmXO94QtsBUprLmjJZZFGaZTMl/w0szUIf8eFRo9HdrvjGmv7iuuiYYy8jIGfIS1DylNwZkaGKBbrLemTFPQffrg5W2gZa0JtLw2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFF5jqIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFF5jqIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3D6C4CEE5;
	Mon, 10 Mar 2025 17:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629516;
	bh=V7d54BTjqfJ+dlJRFg6WaAFkhccH8bF4oj7r9ZLyNSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFF5jqISyRa5sHwIcZkO69guY/ao2JQ1ACmXWauDpgYBNf4j45xjkOzz2egOjiE9N
	 z8jjUQphgu0oClPtJobODTJEzVLXqawlo5avQtOpSQ0wVuOWjljzQ/7ZBMiOjaWxRI
	 BPJ5QNYv5rGWjH37LXfLkG4WR6x3I+guQ6rAFhXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 290/620] dm-crypt: track tag_offset in convert_context
Date: Mon, 10 Mar 2025 18:02:16 +0100
Message-ID: <20250310170557.067548052@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -53,6 +53,7 @@ struct convert_context {
 	struct bio *bio_out;
 	struct bvec_iter iter_out;
 	atomic_t cc_pending;
+	unsigned int tag_offset;
 	u64 cc_sector;
 	union {
 		struct skcipher_request *req;
@@ -1217,6 +1218,7 @@ static void crypt_convert_init(struct cr
 	if (bio_out)
 		ctx->iter_out = bio_out->bi_iter;
 	ctx->cc_sector = sector + cc->iv_offset;
+	ctx->tag_offset = 0;
 	init_completion(&ctx->restart);
 }
 
@@ -1542,7 +1544,6 @@ static void crypt_free_req(struct crypt_
 static blk_status_t crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx, bool atomic, bool reset_pending)
 {
-	unsigned int tag_offset = 0;
 	unsigned int sector_step = cc->sector_size >> SECTOR_SHIFT;
 	int r;
 
@@ -1565,9 +1566,9 @@ static blk_status_t crypt_convert(struct
 		atomic_inc(&ctx->cc_pending);
 
 		if (crypt_integrity_aead(cc))
-			r = crypt_convert_block_aead(cc, ctx, ctx->r.req_aead, tag_offset);
+			r = crypt_convert_block_aead(cc, ctx, ctx->r.req_aead, ctx->tag_offset);
 		else
-			r = crypt_convert_block_skcipher(cc, ctx, ctx->r.req, tag_offset);
+			r = crypt_convert_block_skcipher(cc, ctx, ctx->r.req, ctx->tag_offset);
 
 		switch (r) {
 		/*
@@ -1587,8 +1588,8 @@ static blk_status_t crypt_convert(struct
 					 * exit and continue processing in a workqueue
 					 */
 					ctx->r.req = NULL;
+					ctx->tag_offset++;
 					ctx->cc_sector += sector_step;
-					tag_offset++;
 					return BLK_STS_DEV_RESOURCE;
 				}
 			} else {
@@ -1602,8 +1603,8 @@ static blk_status_t crypt_convert(struct
 		 */
 		case -EINPROGRESS:
 			ctx->r.req = NULL;
+			ctx->tag_offset++;
 			ctx->cc_sector += sector_step;
-			tag_offset++;
 			continue;
 		/*
 		 * The request was already processed (synchronously).
@@ -1611,7 +1612,7 @@ static blk_status_t crypt_convert(struct
 		case 0:
 			atomic_dec(&ctx->cc_pending);
 			ctx->cc_sector += sector_step;
-			tag_offset++;
+			ctx->tag_offset++;
 			if (!atomic)
 				cond_resched();
 			continue;


