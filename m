Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DED08F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A78C433C8;
	Sun, 16 Jul 2023 20:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539456;
	bh=U8rygmy/NNzqIfjpdhgdIhQFmkO6da+uaLRhQr0fe1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xoiVo7GdgB1MBVTzDDP5vmDV73DLHmY1TWmVP0zgFQU9I67AUD0hkjboYP5mPxThs
	 7Cdwh2Z3Mdj2k37VOfqsdjsjmTIiNBIdLZwEk22w6IwYU5kPzREVJYsybo9omIaDCx
	 sdB5jSdJ0weqwJqVT6A9GLAEVBfNNVt7L5omQAQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@coolpad.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/591] erofs: clean up cached I/O strategies
Date: Sun, 16 Jul 2023 21:42:23 +0200
Message-ID: <20230716194923.980209437@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 1282dea37b09087b8aec59f0774572c16b52276a ]

After commit 4c7e42552b3a ("erofs: remove useless cache strategy of
DELAYEDALLOC"), only one cached I/O allocation strategy is supported:

  When cached I/O is preferred, page allocation is applied without
  direct reclaim.  If allocation fails, fall back to inplace I/O.

Let's get rid of z_erofs_cache_alloctype.  No logical changes.

Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Yue Hu <huyue2@coolpad.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20221206060352.152830-1-xiang@kernel.org
Stable-dep-of: 967c28b23f6c ("erofs: kill hooked chains to avoid loops on deduplicated compressed images")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 77 +++++++++++++++++++-----------------------------
 1 file changed, 31 insertions(+), 46 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index cf4871834ebb2..ccf7c55d477fe 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -175,16 +175,6 @@ static void z_erofs_free_pcluster(struct z_erofs_pcluster *pcl)
 	DBG_BUGON(1);
 }
 
-/* how to allocate cached pages for a pcluster */
-enum z_erofs_cache_alloctype {
-	DONTALLOC,	/* don't allocate any cached pages */
-	/*
-	 * try to use cached I/O if page allocation succeeds or fallback
-	 * to in-place I/O instead to avoid any direct reclaim.
-	 */
-	TRYALLOC,
-};
-
 /*
  * tagged pointer with 1-bit tag for all compressed pages
  * tag 0 - the page is just found with an extra page reference
@@ -292,12 +282,29 @@ struct z_erofs_decompress_frontend {
 	.inode = __i, .owned_head = Z_EROFS_PCLUSTER_TAIL, \
 	.mode = Z_EROFS_PCLUSTER_FOLLOWED, .backmost = true }
 
+static bool z_erofs_should_alloc_cache(struct z_erofs_decompress_frontend *fe)
+{
+	unsigned int cachestrategy = EROFS_I_SB(fe->inode)->opt.cache_strategy;
+
+	if (cachestrategy <= EROFS_ZIP_CACHE_DISABLED)
+		return false;
+
+	if (fe->backmost)
+		return true;
+
+	if (cachestrategy >= EROFS_ZIP_CACHE_READAROUND &&
+	    fe->map.m_la < fe->headoffset)
+		return true;
+
+	return false;
+}
+
 static void z_erofs_bind_cache(struct z_erofs_decompress_frontend *fe,
-			       enum z_erofs_cache_alloctype type,
 			       struct page **pagepool)
 {
 	struct address_space *mc = MNGD_MAPPING(EROFS_I_SB(fe->inode));
 	struct z_erofs_pcluster *pcl = fe->pcl;
+	bool shouldalloc = z_erofs_should_alloc_cache(fe);
 	bool standalone = true;
 	/*
 	 * optimistic allocation without direct reclaim since inplace I/O
@@ -326,18 +333,19 @@ static void z_erofs_bind_cache(struct z_erofs_decompress_frontend *fe,
 		} else {
 			/* I/O is needed, no possible to decompress directly */
 			standalone = false;
-			switch (type) {
-			case TRYALLOC:
-				newpage = erofs_allocpage(pagepool, gfp);
-				if (!newpage)
-					continue;
-				set_page_private(newpage,
-						 Z_EROFS_PREALLOCATED_PAGE);
-				t = tag_compressed_page_justfound(newpage);
-				break;
-			default:        /* DONTALLOC */
+			if (!shouldalloc)
 				continue;
-			}
+
+			/*
+			 * try to use cached I/O if page allocation
+			 * succeeds or fallback to in-place I/O instead
+			 * to avoid any direct reclaim.
+			 */
+			newpage = erofs_allocpage(pagepool, gfp);
+			if (!newpage)
+				continue;
+			set_page_private(newpage, Z_EROFS_PREALLOCATED_PAGE);
+			t = tag_compressed_page_justfound(newpage);
 		}
 
 		if (!cmpxchg_relaxed(&pcl->compressed_bvecs[i].page, NULL,
@@ -638,20 +646,6 @@ static bool z_erofs_collector_end(struct z_erofs_decompress_frontend *fe)
 	return true;
 }
 
-static bool should_alloc_managed_pages(struct z_erofs_decompress_frontend *fe,
-				       unsigned int cachestrategy,
-				       erofs_off_t la)
-{
-	if (cachestrategy <= EROFS_ZIP_CACHE_DISABLED)
-		return false;
-
-	if (fe->backmost)
-		return true;
-
-	return cachestrategy >= EROFS_ZIP_CACHE_READAROUND &&
-		la < fe->headoffset;
-}
-
 static int z_erofs_read_fragment(struct inode *inode, erofs_off_t pos,
 				 struct page *page, unsigned int pageofs,
 				 unsigned int len)
@@ -688,12 +682,9 @@ static int z_erofs_do_read_page(struct z_erofs_decompress_frontend *fe,
 				struct page *page, struct page **pagepool)
 {
 	struct inode *const inode = fe->inode;
-	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
 	struct erofs_map_blocks *const map = &fe->map;
 	const loff_t offset = page_offset(page);
 	bool tight = true, exclusive;
-
-	enum z_erofs_cache_alloctype cache_strategy;
 	unsigned int cur, end, spiltted;
 	int err = 0;
 
@@ -747,13 +738,7 @@ static int z_erofs_do_read_page(struct z_erofs_decompress_frontend *fe,
 		fe->mode = Z_EROFS_PCLUSTER_FOLLOWED_NOINPLACE;
 	} else {
 		/* bind cache first when cached decompression is preferred */
-		if (should_alloc_managed_pages(fe, sbi->opt.cache_strategy,
-					       map->m_la))
-			cache_strategy = TRYALLOC;
-		else
-			cache_strategy = DONTALLOC;
-
-		z_erofs_bind_cache(fe, cache_strategy, pagepool);
+		z_erofs_bind_cache(fe, pagepool);
 	}
 hitted:
 	/*
-- 
2.39.2



