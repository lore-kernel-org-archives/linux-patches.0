Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291734F218;
	Thu, 13 Feb 2025 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457981; cv=none; b=aEtrGCYsgok5ldZDsTyPkcFInM7ehhF/zC1U5XHqy00jSI21T2JgyQ1n07kHo978hsBWk0FBGRFE8nPVl3TbJJy0S3hTZFv0A5VK2f4csNjDtPacN56sWjAXGP7Zfc5WBdlsq5MYKv1MZ0pR3j9oiqrCwUJKNq1j/sDyHMlOxzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457981; c=relaxed/simple;
	bh=lEsFuxgGMscG+Bw86AjwNhQ61gFkQ/m1YGTY2/oTsZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHHGJeEZoDqCgD2QCiAFcOmJ5rdkD5rhWOeTuPszOKIEFaIPgOe/r8EzMNV+0nsYp8N/74TiAQ6hVpnoWnLRi9k/W0NhYUkYdgJ28Fsmo7nsEsOLLMJZNKDvotaJPrg+3bXhDhj2gZGA4KzZy7g0Ul5IpHOEapXsj7rDOH5EzhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtnCTBBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtnCTBBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23269C4CED1;
	Thu, 13 Feb 2025 14:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457980;
	bh=lEsFuxgGMscG+Bw86AjwNhQ61gFkQ/m1YGTY2/oTsZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtnCTBBLjJfLbJfLhczxwiTKhACH8IERH86mpygjWc8/nT8hjzNlTyo5CQN5KwdS5
	 TzSkGKVZ28sIk7PK8PsnBQl3fdDilBOf2LVpHSuFNPr+5rUF0jmZR1YRBd6cek1Clf
	 rstcVrWZFKPxRR6wDYc2N1LLXgExPJ7L5dV9jCMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 234/422] dm-crypt: track tag_offset in convert_context
Date: Thu, 13 Feb 2025 15:26:23 +0100
Message-ID: <20250213142445.565315544@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


