Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB0E4E534C;
	Thu, 17 Sep 2026 17:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665570; cv=none; b=ot5yq1F1E5x5IWEGYRFfQtmelUDKP8updOniDTTwZFaZHzUHNTr2iArngq4MPFxEwcPPeS5+lClUg8RTcSGEh0VwFibAPZ/RUeDe96fBeYpReB2osfOR+izljWyb6WI3Csgk5+NcYzMLUdSQsfbp+e8SYCOdXKh4vg7q6VnXU/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665570; c=relaxed/simple;
	bh=WHv6JaljYf/7PCsKUAiAsBMtaC8sxbrL+LSjgEAXO78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OxiBxTwh7VgvnXHwIYRbyTOLfsa7aullx31EI67NE4rkWpkDVHIc7X1RaU/Qpus4LEnLs8wqe1KF4mxuY+iMVgnPJrGLSspw+vE4qVDnPnCKOl4hkgwCtEeTOGOcHuzdKGyOEVnPmgFCuXWaENR81qNKXhHKBWI73MMqnND8rDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afj5k0hQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afj5k0hQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5431F00893;
	Thu, 17 Sep 2026 17:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665569;
	bh=FkeYmyzPeTNc6dGLfrAgc6jk+oixpFjQ1wqWD4aH1hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afj5k0hQRoXztB3khZk6MFl4u0+pcAkkWj+jtkqXEFTVc/E8jI/0tOrvAkhFDevdK
	 n0QkGYVfXngXaoLfmfbVVVZ0gFR7Yl/NEuJ79gTw977o3l2c1REow2zC3eU86inhPm
	 KmBb2qWHpHkhyF8vdXzg6SMC91WsyNn/nWtwb404=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Walther, Jens-Uwe" <waltju@amazon.de>,
	Yann Collet <yann.collet.73@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0749/1250] erofs: disable LZ4 rolling decompression for now
Date: Thu, 17 Sep 2026 16:09:04 +0100
Message-ID: <20260917151612.183075732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <xiang@kernel.org>

[ Upstream commit 82e664cf1219c459c33aae931b222cf951af9cb7 ]

LZ4 rolling decompression [1] was introduced to reduce the memory
footprint of temporary pages:

 For many cases, it is needed for users to read small data within
 a compressed extent (pcluster), either due to random small read, or
 since uptodate folios (typically order-0) cannot be reused for
 decompression again since decompression algorithm refills
 already-uptodate folios.

Rolling decompression works because LZ4 is LZ77-based and only refers
to the most recent 64 KiB of decompressed data, so in theory only a
bounded rolling window of temporary pages is needed when decompressing.

It can save a lot of temporary memory, e.g.
 601,960-byte data can be compressed into a 256k LZ4 compressed extent,
 which means it needs 146 extra pages per request in the worst case if
 rolling decompression is disabled.

However, the upstream LZ4 implementation is not under EROFS' control:
For example, the literal copy memmove() may still **copy long literals
backward** on x86 based on the address comparison even when the source
and destination ranges do not overlap (IOWs, inline decompression
doesn't need to be considered here). That breaks the rolling assumption
and makes the optimization broken.

Disable it for now to make sure the data correctness first since EROFS
is used everywhere now: The rolling window approach can be revived once
we either ensure that the official LZ4 code always copies forward for
non-overlapping ranges or maintain our own LZ4 implementation in EROFS.

The main impact is a higher runtime memory footprint; However, recent
commit 0f6273ab4637 ("erofs: add a reserved buffer pool for lz4
decompression") helps mitigate this when enabled but it's still not
perfect.

[1] https://www.usenix.org/conference/atc19/presentation/gao
    § 3.3 Decompression

Reported-by: "Walther, Jens-Uwe" <waltju@amazon.de>
Closes: https://lore.kernel.org/r/BEZP281MB2102E57CD31862B8D958B33DD2AC2@BEZP281MB2102.DEUP281.PROD.OUTLOOK.COM
Fixes: 8e6c8fa9f2e9 ("erofs: enable big pcluster feature")
Cc: Yann Collet <yann.collet.73@gmail.com>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor.c | 55 +++++++++--------------------------------
 fs/erofs/internal.h     |  6 +----
 fs/erofs/zdata.c        | 18 +++-----------
 3 files changed, 16 insertions(+), 63 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index fbd59109f46c3..48a0c84cec755 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -7,8 +7,6 @@
 #include "compress.h"
 #include <linux/lz4.h>
 
-#define LZ4_MAX_DISTANCE_PAGES	(DIV_ROUND_UP(LZ4_DISTANCE_MAX, PAGE_SIZE) + 1)
-
 static int z_erofs_load_lz4_config(struct super_block *sb,
 			    struct erofs_super_block *dsb, void *data, int size)
 {
@@ -21,8 +19,6 @@ static int z_erofs_load_lz4_config(struct super_block *sb,
 			erofs_err(sb, "invalid lz4 cfgs, size=%u", size);
 			return -EINVAL;
 		}
-		distance = le16_to_cpu(lz4->max_distance);
-
 		sbi->lz4.max_pclusterblks = le16_to_cpu(lz4->max_pclusterblks);
 		if (!sbi->lz4.max_pclusterblks) {
 			sbi->lz4.max_pclusterblks = 1;	/* reserved case */
@@ -36,45 +32,25 @@ static int z_erofs_load_lz4_config(struct super_block *sb,
 		distance = le16_to_cpu(dsb->u1.lz4_max_distance);
 		sbi->lz4.max_pclusterblks = 1;
 	}
-
-	sbi->lz4.max_distance_pages = distance ?
-					DIV_ROUND_UP(distance, PAGE_SIZE) + 1 :
-					LZ4_MAX_DISTANCE_PAGES;
 	return z_erofs_gbuf_growsize(sbi->lz4.max_pclusterblks);
 }
 
 /*
- * Fill all gaps with bounce pages if it's a sparse page list. Also check if
- * all physical pages are consecutive, which can be seen for moderate CR.
+ * Fill all gaps with bounce pages if it's a sparse page list (for example some
+ * folios are already uptodate and thus can be mapped into userspace). Also
+ * check if pages are physically consecutive, which can be seen for moderate CR.
  */
-static int z_erofs_lz4_prepare_dstpages(struct z_erofs_decompress_req *rq,
-					struct page **pagepool)
+static int z_erofs_oneshot_prepare_dstpages(struct z_erofs_decompress_req *rq,
+					    struct page **pagepool)
 {
-	struct page *availables[LZ4_MAX_DISTANCE_PAGES] = { NULL };
-	unsigned long bounced[DIV_ROUND_UP(LZ4_MAX_DISTANCE_PAGES,
-					   BITS_PER_LONG)] = { 0 };
-	unsigned int lz4_max_distance_pages =
-				EROFS_SB(rq->sb)->lz4.max_distance_pages;
 	void *kaddr = NULL;
-	unsigned int i, j, top;
+	unsigned int i;
 
-	top = 0;
-	for (i = j = 0; i < rq->outpages; ++i, ++j) {
-		struct page *const page = rq->out[i];
-		struct page *victim;
-
-		if (j >= lz4_max_distance_pages)
-			j = 0;
-
-		/* 'valid' bounced can only be tested after a complete round */
-		if (!rq->fillgaps && test_bit(j, bounced)) {
-			DBG_BUGON(i < lz4_max_distance_pages);
-			DBG_BUGON(top >= lz4_max_distance_pages);
-			availables[top++] = rq->out[i - lz4_max_distance_pages];
-		}
+	for (i = 0; i < rq->outpages; ++i) {
+		struct page *page, *victim;
 
+		page = rq->out[i];
 		if (page) {
-			__clear_bit(j, bounced);
 			if (!PageHighMem(page)) {
 				if (!i) {
 					kaddr = page_address(page);
@@ -86,21 +62,14 @@ static int z_erofs_lz4_prepare_dstpages(struct z_erofs_decompress_req *rq,
 					continue;
 				}
 			}
-			kaddr = NULL;
-			continue;
-		}
-		kaddr = NULL;
-		__set_bit(j, bounced);
-
-		if (top) {
-			victim = availables[--top];
 		} else {
 			victim = __erofs_allocpage(pagepool, rq->gfp, true);
 			if (!victim)
 				return -ENOMEM;
 			set_page_private(victim, Z_EROFS_SHORTLIVED_PAGE);
+			rq->out[i] = victim;
 		}
-		rq->out[i] = victim;
+		kaddr = NULL;
 	}
 	return kaddr ? 1 : 0;
 }
@@ -271,7 +240,7 @@ static int z_erofs_lz4_decompress(struct z_erofs_decompress_req *rq,
 		dst_maptype = 0;
 	} else {
 		/* general decoding path which can be used for all cases */
-		ret = z_erofs_lz4_prepare_dstpages(rq, pagepool);
+		ret = z_erofs_oneshot_prepare_dstpages(rq, pagepool);
 		if (ret < 0)
 			return ret;
 		if (ret > 0) {
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index e1f0174d468df..845c71afb58d5 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -70,12 +70,8 @@ struct erofs_dev_context {
 	bool flatdev;
 };
 
-/* all filesystem-wide lz4 configurations */
 struct erofs_sb_lz4_info {
-	/* # of pages needed for EROFS lz4 rolling decompression */
-	u16 max_distance_pages;
-	/* maximum possible blocks for pclusters in the filesystem */
-	u16 max_pclusterblks;
+	u16 max_pclusterblks;	/* maximum physical blocks for LZ4 pclusters */
 };
 
 struct erofs_domain {
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index e07c0253893eb..0af259e22026f 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1267,7 +1267,7 @@ static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, bool eio)
 	const struct z_erofs_decompressor *decomp =
 				z_erofs_decomp[pcl->algorithmformat];
 	bool try_free = true;
-	int i, j, jtop, err2, err = eio ? -EIO : 0;
+	int i, err2, err = eio ? -EIO : 0;
 	struct page *page;
 	bool overlapped;
 
@@ -1342,7 +1342,6 @@ static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, bool eio)
 	    be->compressed_pages >= be->onstack_pages + Z_EROFS_ONSTACK_PAGES)
 		kvfree(be->compressed_pages);
 
-	jtop = 0;
 	z_erofs_fill_other_copies(be, err);
 	for (i = 0; i < be->nr_pages; ++i) {
 		page = be->decompressed_pages[i];
@@ -1350,22 +1349,11 @@ static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, bool eio)
 			continue;
 
 		DBG_BUGON(z_erofs_page_is_invalidated(page));
-		if (!z_erofs_is_shortlived_page(page)) {
+		if (!z_erofs_is_shortlived_page(page))
 			erofs_onlinefolio_end(page_folio(page), err, true);
-			continue;
-		}
-		if (pcl->algorithmformat != Z_EROFS_COMPRESSION_LZ4) {
+		else
 			erofs_pagepool_add(be->pagepool, page);
-			continue;
-		}
-		for (j = 0; j < jtop && be->decompressed_pages[j] != page; ++j)
-			;
-		if (j >= jtop)	/* this bounce page is newly detected */
-			be->decompressed_pages[jtop++] = page;
 	}
-	while (jtop)
-		erofs_pagepool_add(be->pagepool,
-				   be->decompressed_pages[--jtop]);
 	if (be->decompressed_pages != be->onstack_pages)
 		kvfree(be->decompressed_pages);
 
-- 
2.53.0



