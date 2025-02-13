Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8105B26B08F;
	Thu, 13 Feb 2025 15:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459421; cv=none; b=KmaZo8ZZk53RI2nVrtUT/3Fsvy6XlooXhMnN+4bhjiOWYx5ZJIjT/dnvAwSdMm6HU3a0ToDpazyRh2NVR15gBstUStMYdtOQly00sLcANEVIChspHW2j/AEyPYezEYurNVSZE0oc5qsUerKA2QYZB7AToRBHzMVSqSDIbQdwFtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459421; c=relaxed/simple;
	bh=JE+ifE7Vl1vUxXm4LDSL0b5pEfoDqosRiXjOGBwJrI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKOrdlfFuYg/2ovfSj7vnPgagjomYKIo2zKcIbIH34YURJpW1mp0p+Bd+sORVlaPGTYrj/w+AN5otZw5onnLrXu7nJhqecGymEKwjPvDuAI/4usk2ieXTQrZrVVcoJtYvIc9ittl+UUYUecgf9TOKsgPjhPlqYRbjxphDYbvJDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUHX0QwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUHX0QwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76D8C4CEEA;
	Thu, 13 Feb 2025 15:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459421;
	bh=JE+ifE7Vl1vUxXm4LDSL0b5pEfoDqosRiXjOGBwJrI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUHX0QwOZnW4CFLjPW/zlo+rLI2Ok5qDYnOnoK1ILRCXR99bwPjCIckaqFFjaniW8
	 6RCN0da9EqtztPKH0n9eH6DByFBnS7znzW4W6tlHlXq7un2misJKqs4n7SZL984WQK
	 LhaSP5pi5AB2pMRITirPLO1gS2uGuYTcYWv1EMCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.13 259/443] dm-crypt: track tag_offset in convert_context
Date: Thu, 13 Feb 2025 15:27:04 +0100
Message-ID: <20250213142450.610584873@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -59,6 +59,7 @@ struct convert_context {
 	struct bio *bio_out;
 	struct bvec_iter iter_out;
 	atomic_t cc_pending;
+	unsigned int tag_offset;
 	u64 cc_sector;
 	union {
 		struct skcipher_request *req;
@@ -1256,6 +1257,7 @@ static void crypt_convert_init(struct cr
 	if (bio_out)
 		ctx->iter_out = bio_out->bi_iter;
 	ctx->cc_sector = sector + cc->iv_offset;
+	ctx->tag_offset = 0;
 	init_completion(&ctx->restart);
 }
 
@@ -1588,7 +1590,6 @@ static void crypt_free_req(struct crypt_
 static blk_status_t crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx, bool atomic, bool reset_pending)
 {
-	unsigned int tag_offset = 0;
 	unsigned int sector_step = cc->sector_size >> SECTOR_SHIFT;
 	int r;
 
@@ -1611,9 +1612,9 @@ static blk_status_t crypt_convert(struct
 		atomic_inc(&ctx->cc_pending);
 
 		if (crypt_integrity_aead(cc))
-			r = crypt_convert_block_aead(cc, ctx, ctx->r.req_aead, tag_offset);
+			r = crypt_convert_block_aead(cc, ctx, ctx->r.req_aead, ctx->tag_offset);
 		else
-			r = crypt_convert_block_skcipher(cc, ctx, ctx->r.req, tag_offset);
+			r = crypt_convert_block_skcipher(cc, ctx, ctx->r.req, ctx->tag_offset);
 
 		switch (r) {
 		/*
@@ -1633,8 +1634,8 @@ static blk_status_t crypt_convert(struct
 					 * exit and continue processing in a workqueue
 					 */
 					ctx->r.req = NULL;
+					ctx->tag_offset++;
 					ctx->cc_sector += sector_step;
-					tag_offset++;
 					return BLK_STS_DEV_RESOURCE;
 				}
 			} else {
@@ -1648,8 +1649,8 @@ static blk_status_t crypt_convert(struct
 		 */
 		case -EINPROGRESS:
 			ctx->r.req = NULL;
+			ctx->tag_offset++;
 			ctx->cc_sector += sector_step;
-			tag_offset++;
 			continue;
 		/*
 		 * The request was already processed (synchronously).
@@ -1657,7 +1658,7 @@ static blk_status_t crypt_convert(struct
 		case 0:
 			atomic_dec(&ctx->cc_pending);
 			ctx->cc_sector += sector_step;
-			tag_offset++;
+			ctx->tag_offset++;
 			if (!atomic)
 				cond_resched();
 			continue;


