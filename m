Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3147C25A2BF;
	Mon, 12 May 2025 17:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071899; cv=none; b=dvfK6/Cn/sKNTTbwz8ojlGA+JgA90f/OHWT0sGS9nDdpOKua8wvKFCVVk/gZrpUorDV0bmc2rdWI/daJljUzB5oDRaMGLXldlW4KbrdgVuhH4DKo0wBb+7w5thYykrJIdEOhBdrcutC1HLs9SpJ4pGxgKZ4ZE10OzYtUwqmQDb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071899; c=relaxed/simple;
	bh=UVWqM8IuC0qJIi7tVEWQXDdON6DmBhRSP4gPIEZ3IPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcPaWE+8SI9w5uH5zUZ4rGvrMP7lmGI0L5O95XcEbPZo/fRq3k2QlPoKmLbReZRRP7O0gl+jeCrBg/sybXYJ7rKFvM//afBT6ccjUFuGKiCOWHbv6zt4RI8amAMGieryIxFqR3vQDUPOkQnfc05ZGgeGHf4JZtLmSVndPU3wFtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/7e0TiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/7e0TiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5891C4CEE7;
	Mon, 12 May 2025 17:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071899;
	bh=UVWqM8IuC0qJIi7tVEWQXDdON6DmBhRSP4gPIEZ3IPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/7e0TiUB4Y/YeZXLU/qz1N/HjGDTP7npwnXpBGWxTkiYRsGQR2h3V54eYx9vW40h
	 wFAJp53F+5sg+2iIt/43dl5g4fTx2M9YPqZmYw9aIOTWJtBY5sNDd6X+WAY9KkO5xp
	 egW8DGeLsTcrPD5IZKd5FHqEy7jWqskq1uHkA3U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 030/197] erofs: ensure the extra temporary copy is valid for shortened bvecs
Date: Mon, 12 May 2025 19:38:00 +0200
Message-ID: <20250512172045.591821631@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 35076d2223c731f7be75af61e67f90807384d030 ]

When compressed data deduplication is enabled, multiple logical extents
may reference the same compressed physical cluster.

The previous commit 94c43de73521 ("erofs: fix wrong primary bvec
selection on deduplicated extents") already avoids using shortened
bvecs.  However, in such cases, the extra temporary buffers also
need to be preserved for later use in z_erofs_fill_other_copies() to
to prevent data corruption.

IOWs, extra temporary buffers have to be retained not only due to
varying start relative offsets (`pageofs_out`, as indicated by
`pcl->multibases`) but also because of shortened bvecs.

android.hardware.graphics.composer@2.1.so : 270696 bytes
   0:        0..  204185 |  204185 :  628019200.. 628084736 |   65536
-> 1:   204185..  225536 |   21351 :  544063488.. 544129024 |   65536
   2:   225536..  270696 |   45160 :          0..         0 |       0

com.android.vndk.v28.apex : 93814897 bytes
...
   364: 53869896..54095257 |  225361 :  543997952.. 544063488 |   65536
-> 365: 54095257..54309344 |  214087 :  544063488.. 544129024 |   65536
   366: 54309344..54514557 |  205213 :  544129024.. 544194560 |   65536
...

Both 204185 and 54095257 have the same start relative offset of 3481,
but the logical page 55 of `android.hardware.graphics.composer@2.1.so`
ranges from 225280 to 229632, forming a shortened bvec [225280, 225536)
that cannot be used for decompressing the range from 54095257 to
54309344 of `com.android.vndk.v28.apex`.

Since `pcl->multibases` is already meaningless, just mark `be->keepxcpy`
on demand for simplicity.

Again, this issue can only lead to data corruption if `-Ededupe` is on.

Fixes: 94c43de73521 ("erofs: fix wrong primary bvec selection on deduplicated extents")
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250506101850.191506-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index d771e06db7386..67acef591646c 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -76,9 +76,6 @@ struct z_erofs_pcluster {
 	/* L: whether partial decompression or not */
 	bool partial;
 
-	/* L: indicate several pageofs_outs or not */
-	bool multibases;
-
 	/* L: whether extra buffer allocations are best-effort */
 	bool besteffort;
 
@@ -1050,8 +1047,6 @@ static int z_erofs_scan_folio(struct z_erofs_frontend *f,
 				break;
 
 			erofs_onlinefolio_split(folio);
-			if (f->pcl->pageofs_out != (map->m_la & ~PAGE_MASK))
-				f->pcl->multibases = true;
 			if (f->pcl->length < offset + end - map->m_la) {
 				f->pcl->length = offset + end - map->m_la;
 				f->pcl->pageofs_out = map->m_la & ~PAGE_MASK;
@@ -1097,7 +1092,6 @@ struct z_erofs_backend {
 	struct page *onstack_pages[Z_EROFS_ONSTACK_PAGES];
 	struct super_block *sb;
 	struct z_erofs_pcluster *pcl;
-
 	/* pages with the longest decompressed length for deduplication */
 	struct page **decompressed_pages;
 	/* pages to keep the compressed data */
@@ -1106,6 +1100,8 @@ struct z_erofs_backend {
 	struct list_head decompressed_secondary_bvecs;
 	struct page **pagepool;
 	unsigned int onstack_used, nr_pages;
+	/* indicate if temporary copies should be preserved for later use */
+	bool keepxcpy;
 };
 
 struct z_erofs_bvec_item {
@@ -1116,18 +1112,20 @@ struct z_erofs_bvec_item {
 static void z_erofs_do_decompressed_bvec(struct z_erofs_backend *be,
 					 struct z_erofs_bvec *bvec)
 {
+	int poff = bvec->offset + be->pcl->pageofs_out;
 	struct z_erofs_bvec_item *item;
-	unsigned int pgnr;
-
-	if (!((bvec->offset + be->pcl->pageofs_out) & ~PAGE_MASK) &&
-	    (bvec->end == PAGE_SIZE ||
-	     bvec->offset + bvec->end == be->pcl->length)) {
-		pgnr = (bvec->offset + be->pcl->pageofs_out) >> PAGE_SHIFT;
-		DBG_BUGON(pgnr >= be->nr_pages);
-		if (!be->decompressed_pages[pgnr]) {
-			be->decompressed_pages[pgnr] = bvec->page;
+	struct page **page;
+
+	if (!(poff & ~PAGE_MASK) && (bvec->end == PAGE_SIZE ||
+			bvec->offset + bvec->end == be->pcl->length)) {
+		DBG_BUGON((poff >> PAGE_SHIFT) >= be->nr_pages);
+		page = be->decompressed_pages + (poff >> PAGE_SHIFT);
+		if (!*page) {
+			*page = bvec->page;
 			return;
 		}
+	} else {
+		be->keepxcpy = true;
 	}
 
 	/* (cold path) one pcluster is requested multiple times */
@@ -1291,7 +1289,7 @@ static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, int err)
 					.alg = pcl->algorithmformat,
 					.inplace_io = overlapped,
 					.partial_decoding = pcl->partial,
-					.fillgaps = pcl->multibases,
+					.fillgaps = be->keepxcpy,
 					.gfp = pcl->besteffort ? GFP_KERNEL :
 						GFP_NOWAIT | __GFP_NORETRY
 				 }, be->pagepool);
@@ -1348,7 +1346,6 @@ static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, int err)
 
 	pcl->length = 0;
 	pcl->partial = true;
-	pcl->multibases = false;
 	pcl->besteffort = false;
 	pcl->bvset.nextpage = NULL;
 	pcl->vcnt = 0;
-- 
2.39.5



