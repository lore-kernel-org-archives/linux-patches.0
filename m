Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8043A542B;
	Sat, 17 Oct 2026 18:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260721; cv=none; b=S8EML1dy6b8wpj5RXA4KHTOBaxpGo0Mcim0IZSfVqRdpbBcTE3GJIlyJvBMRvojoDQ1SoruKRjtk3w7XzOMd4IQAe6rI3r4546Hsn1JDjqLrrUx1E192Xn+fsAxxb92G8WPaVDc3tzscGnYAQDHFQ2XIEPLDMc9WPBBaEC50PfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260721; c=relaxed/simple;
	bh=aqhdRJl38ufNLPPRq9nH5QKpPDwrYkD+MBeoeD1tIN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X458/KtKUgBBRiWtu2ral8m0KjD8/P+M4rXC5+fqkMZ95L/DySCvdI6JISB6n2qkzl5UYmJbhcOEg4l/s1HVXbp5VvQqprJ9rkWMMptybAli7pw7VqmH1T1MwVWBJNy3rZoqcz959p6E3Khbretx+CL8o06mfhofPphpSSwvRP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOnSUtJf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOnSUtJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2540A1F000C4;
	Sat, 17 Oct 2026 18:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260719;
	bh=UsVwrOkqOo6nAV+QZiZR+AeutR71uccOmkTeu/0IgC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qOnSUtJf8HngEF0RM188BHlYivJCAzwXeagzm3xDNyiX6qZyJEv9UqQK1EhYnY2eY
	 Ki6oXvMSF9zDa5KZogQIvrhifpK9lPuYdi/M3F5wjKn9Av6s1eNC5DtgbRn5oB8SmN
	 YYSkbjwksYbIUp7VxiMCj11ny5ZG9epsxDdYF2Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Walther, Jens-Uwe" <waltju@amazon.de>,
	Yann Collet <yann.collet.73@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1639/1674] erofs: disable LZ4 rolling decompression for now
Date: Sat, 17 Oct 2026 18:05:11 +0200
Message-ID: <20261017160513.148339672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 fs/erofs/decompressor.c | 55 +++++++----------------------------------
 fs/erofs/internal.h     |  6 +----
 2 files changed, 10 insertions(+), 51 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 18e4da98309d5..c4a6391eb1fa9 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -7,11 +7,6 @@
 #include <linux/module.h>
 #include <linux/lz4.h>
 
-#ifndef LZ4_DISTANCE_MAX	/* history window size */
-#define LZ4_DISTANCE_MAX 65535	/* set to maximum value by default */
-#endif
-
-#define LZ4_MAX_DISTANCE_PAGES	(DIV_ROUND_UP(LZ4_DISTANCE_MAX, PAGE_SIZE) + 1)
 #ifndef LZ4_DECOMPRESS_INPLACE_MARGIN
 #define LZ4_DECOMPRESS_INPLACE_MARGIN(srcsize)  (((srcsize) >> 8) + 32)
 #endif
@@ -29,15 +24,12 @@ static int z_erofs_load_lz4_config(struct super_block *sb,
 {
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
 	struct z_erofs_lz4_cfgs *lz4 = data;
-	u16 distance;
 
 	if (lz4) {
 		if (size < sizeof(struct z_erofs_lz4_cfgs)) {
 			erofs_err(sb, "invalid lz4 cfgs, size=%u", size);
 			return -EINVAL;
 		}
-		distance = le16_to_cpu(lz4->max_distance);
-
 		sbi->lz4.max_pclusterblks = le16_to_cpu(lz4->max_pclusterblks);
 		if (!sbi->lz4.max_pclusterblks) {
 			sbi->lz4.max_pclusterblks = 1;	/* reserved case */
@@ -48,49 +40,28 @@ static int z_erofs_load_lz4_config(struct super_block *sb,
 			return -EINVAL;
 		}
 	} else {
-		distance = le16_to_cpu(dsb->u1.lz4_max_distance);
 		sbi->lz4.max_pclusterblks = 1;
 	}
-
-	sbi->lz4.max_distance_pages = distance ?
-					DIV_ROUND_UP(distance, PAGE_SIZE) + 1 :
-					LZ4_MAX_DISTANCE_PAGES;
 	return erofs_pcpubuf_growsize(sbi->lz4.max_pclusterblks);
 }
 
 /*
- * Fill all gaps with bounce pages if it's a sparse page list. Also check if
- * all physical pages are consecutive, which can be seen for moderate CR.
+ * Fill all gaps with bounce pages if it's a sparse page list (for example some
+ * folios are already uptodate and thus can be mapped into userspace). Also
+ * check if pages are physically consecutive, which can be seen for moderate CR.
  */
 static int z_erofs_lz4_prepare_dstpages(struct z_erofs_lz4_decompress_ctx *ctx,
 					struct page **pagepool)
 {
 	struct z_erofs_decompress_req *rq = ctx->rq;
-	struct page *availables[LZ4_MAX_DISTANCE_PAGES] = { NULL };
-	unsigned long bounced[DIV_ROUND_UP(LZ4_MAX_DISTANCE_PAGES,
-					   BITS_PER_LONG)] = { 0 };
-	unsigned int lz4_max_distance_pages =
-				EROFS_SB(rq->sb)->lz4.max_distance_pages;
 	void *kaddr = NULL;
-	unsigned int i, j, top;
-
-	top = 0;
-	for (i = j = 0; i < ctx->outpages; ++i, ++j) {
-		struct page *const page = rq->out[i];
-		struct page *victim;
-
-		if (j >= lz4_max_distance_pages)
-			j = 0;
+	unsigned int i;
 
-		/* 'valid' bounced can only be tested after a complete round */
-		if (!rq->fillgaps && test_bit(j, bounced)) {
-			DBG_BUGON(i < lz4_max_distance_pages);
-			DBG_BUGON(top >= lz4_max_distance_pages);
-			availables[top++] = rq->out[i - lz4_max_distance_pages];
-		}
+	for (i = 0; i < ctx->outpages; ++i) {
+		struct page *page, *victim;
 
+		page = rq->out[i];
 		if (page) {
-			__clear_bit(j, bounced);
 			if (!PageHighMem(page)) {
 				if (!i) {
 					kaddr = page_address(page);
@@ -102,21 +73,13 @@ static int z_erofs_lz4_prepare_dstpages(struct z_erofs_lz4_decompress_ctx *ctx,
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
-			get_page(victim);
 		} else {
 			victim = erofs_allocpage(pagepool,
 						 GFP_KERNEL | __GFP_NOFAIL);
 			set_page_private(victim, Z_EROFS_SHORTLIVED_PAGE);
+			rq->out[i] = victim;
 		}
-		rq->out[i] = victim;
+		kaddr = NULL;
 	}
 	return kaddr ? 1 : 0;
 }
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 787cc9ff90294..7c439addf102c 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -82,12 +82,8 @@ struct erofs_dev_context {
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
-- 
2.53.0



