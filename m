Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A92E15D5B4;
	Mon, 29 Jan 2024 17:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548391; cv=none; b=DTZ+IaA4phenCLBX3uJD4BEkzLHyiYn5JGOJOG4SbZKtS/B+kl6ggjV2zOBq6LvndUNmKlfo0squ7eWWsbuUKo1uUdOa+UU0KRfPbU9Vrbb2/XVZSABD081EbU3UnlQPk6XlHjPDhNa66yjEhlsLb4ZGgNV295g9N2wb1MXkxWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548391; c=relaxed/simple;
	bh=anJgL6OnHNveA7A/EADRu6T8iw1+tyk/5P5jaNVswQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbXYfJFAavm6l3+kFJ9Y5CnCoySQd8RpQ1USN39skYuyE4pS6WxgO+8I/v7/CJyEC0W5gfH+wlUi0RHL3AaXbW+UK1XCarLD5TvLRxbLbmzwpDk2JAYcswT8uYs/gHKlwyN3hOVzv9gLKTTb9B2g6AJNgnG1NubbnUFP9A3xw+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWrpV088; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWrpV088"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE0CC433F1;
	Mon, 29 Jan 2024 17:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548391;
	bh=anJgL6OnHNveA7A/EADRu6T8iw1+tyk/5P5jaNVswQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWrpV088o58a1/xDrodPEFk+mcLyNw2gpyjzJNhUaN38BCfV/gff7Nllq3froF+TL
	 UEm2IakR22jMGiMNyy63veKGcGOoYTGs9VBv1zqgy+x1SpdepW0t1KDfw+eEJUuUny
	 mYv/6YY0c2Ln+vBH5HC7vWujXqmu8kKdNrGQizFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Yue Hu <huyue2@coolpad.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/185] erofs: get rid of the remaining kmap_atomic()
Date: Mon, 29 Jan 2024 09:05:41 -0800
Message-ID: <20240129170003.121279737@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 123ec246ebe323d468c5ca996700ea4739d20ddf ]

It's unnecessary to use kmap_atomic() compared with kmap_local_page().
In addition, kmap_atomic() is deprecated now.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20230627161240.331-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: 3c12466b6b7b ("erofs: fix lz4 inplace decompression")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 51b7ac7166d9..59294182e4cb 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -148,7 +148,7 @@ static void *z_erofs_lz4_handle_overlap(struct z_erofs_lz4_decompress_ctx *ctx,
 		*maptype = 0;
 		return inpage;
 	}
-	kunmap_atomic(inpage);
+	kunmap_local(inpage);
 	might_sleep();
 	src = erofs_vm_map_ram(rq->in, ctx->inpages);
 	if (!src)
@@ -162,7 +162,7 @@ static void *z_erofs_lz4_handle_overlap(struct z_erofs_lz4_decompress_ctx *ctx,
 	src = erofs_get_pcpubuf(ctx->inpages);
 	if (!src) {
 		DBG_BUGON(1);
-		kunmap_atomic(inpage);
+		kunmap_local(inpage);
 		return ERR_PTR(-EFAULT);
 	}
 
@@ -173,9 +173,9 @@ static void *z_erofs_lz4_handle_overlap(struct z_erofs_lz4_decompress_ctx *ctx,
 			min_t(unsigned int, total, PAGE_SIZE - *inputmargin);
 
 		if (!inpage)
-			inpage = kmap_atomic(*in);
+			inpage = kmap_local_page(*in);
 		memcpy(tmp, inpage + *inputmargin, page_copycnt);
-		kunmap_atomic(inpage);
+		kunmap_local(inpage);
 		inpage = NULL;
 		tmp += page_copycnt;
 		total -= page_copycnt;
@@ -214,7 +214,7 @@ static int z_erofs_lz4_decompress_mem(struct z_erofs_lz4_decompress_ctx *ctx,
 	int ret, maptype;
 
 	DBG_BUGON(*rq->in == NULL);
-	headpage = kmap_atomic(*rq->in);
+	headpage = kmap_local_page(*rq->in);
 
 	/* LZ4 decompression inplace is only safe if zero_padding is enabled */
 	if (erofs_sb_has_zero_padding(EROFS_SB(rq->sb))) {
@@ -223,7 +223,7 @@ static int z_erofs_lz4_decompress_mem(struct z_erofs_lz4_decompress_ctx *ctx,
 				min_t(unsigned int, rq->inputsize,
 				      EROFS_BLKSIZ - rq->pageofs_in));
 		if (ret) {
-			kunmap_atomic(headpage);
+			kunmap_local(headpage);
 			return ret;
 		}
 		may_inplace = !((rq->pageofs_in + rq->inputsize) &
@@ -261,7 +261,7 @@ static int z_erofs_lz4_decompress_mem(struct z_erofs_lz4_decompress_ctx *ctx,
 	}
 
 	if (maptype == 0) {
-		kunmap_atomic(headpage);
+		kunmap_local(headpage);
 	} else if (maptype == 1) {
 		vm_unmap_ram(src, ctx->inpages);
 	} else if (maptype == 2) {
@@ -289,7 +289,7 @@ static int z_erofs_lz4_decompress(struct z_erofs_decompress_req *rq,
 	/* one optimized fast path only for non bigpcluster cases yet */
 	if (ctx.inpages == 1 && ctx.outpages == 1 && !rq->inplace_io) {
 		DBG_BUGON(!*rq->out);
-		dst = kmap_atomic(*rq->out);
+		dst = kmap_local_page(*rq->out);
 		dst_maptype = 0;
 		goto dstmap_out;
 	}
@@ -311,7 +311,7 @@ static int z_erofs_lz4_decompress(struct z_erofs_decompress_req *rq,
 dstmap_out:
 	ret = z_erofs_lz4_decompress_mem(&ctx, dst + rq->pageofs_out);
 	if (!dst_maptype)
-		kunmap_atomic(dst);
+		kunmap_local(dst);
 	else if (dst_maptype == 2)
 		vm_unmap_ram(dst, ctx.outpages);
 	return ret;
-- 
2.43.0



