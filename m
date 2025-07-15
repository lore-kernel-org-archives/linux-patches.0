Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82B52D8778;
	Tue, 15 Jul 2025 13:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587331; cv=none; b=l65SPVhNbq/xMrm/Lvk9AY00TvM3NeVAe799pUwRNhrxGTEHWe6vCTq8NpAMgZSu5/Xj37xJqUHGotuW95q5yePqZQGtsX7axafuRunfjCN9IWXee+viUniZV4aQMemMZPEI1+4s75YF4AqPGrNJB1aGLtCs7HQEoPYK/5z3QGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587331; c=relaxed/simple;
	bh=SGZD6oWQHjkkVGsnY4VEud5XPQNx+CuZUDlVlMOlMKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVXhSYvs4jABeYlcrwQ1xEAE5iB5HptFLcOWEZ5QllS/ah7461PSpsJplpxIzUt5MinmJO5bqcTJLW7xOyE2LOPsOFg5tONd5SuTjj3FSYxQHP2yvkmpqCCRetwdaB4Sm56tw4vgU3OGOsmxtRVphheDPhKNxrzXEEzdbYT5BgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9STAHJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9STAHJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0B1C4CEE3;
	Tue, 15 Jul 2025 13:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587331;
	bh=SGZD6oWQHjkkVGsnY4VEud5XPQNx+CuZUDlVlMOlMKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9STAHJ33RWy0JXKWRaoBbpGerzQV8XkgOURFlIFoP4WqP6vscpbs/7m74M4WJTbd
	 J58TRlOdnQ38mpj26/AxnI5yJVhLyzkPVYngMKh11g2a5fOGO1huVNZg3cgnVgnn74
	 wTOsasy9AZeHcR0KfWhEkm2Uc7aLCQnBXHqNEbyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@coolpad.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 60/88] erofs: clean up z_erofs_pcluster_readmore()
Date: Tue, 15 Jul 2025 15:14:36 +0200
Message-ID: <20250715130756.976195288@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

From: Yue Hu <huyue2@coolpad.com>

[ Upstream commit 796e9149a2fcdba5543e247abd8d911a399bb9a6 ]

`end` parameter is no needed since it's pointless for !backmost, we can
handle it with backmost internally.  And we only expand the trailing
edge, so the newstart can be replaced with ->headoffset.

Also, remove linux/prefetch.h inclusion since that is not used anymore
after commit 386292919c25 ("erofs: introduce readmore decompression
strategy").

Signed-off-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230525072605.17857-1-zbestahu@gmail.com
[ Gao Xiang: update commit description. ]
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: 99f7619a77a0 ("erofs: fix to add missing tracepoint in erofs_read_folio()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 8018f31d2dbca..50dd104dbaabf 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -5,7 +5,6 @@
  * Copyright (C) 2022 Alibaba Cloud
  */
 #include "compress.h"
-#include <linux/prefetch.h>
 #include <linux/psi.h>
 
 #include <trace/events/erofs.h>
@@ -1630,28 +1629,28 @@ static void z_erofs_runqueue(struct z_erofs_decompress_frontend *f,
  */
 static void z_erofs_pcluster_readmore(struct z_erofs_decompress_frontend *f,
 				      struct readahead_control *rac,
-				      erofs_off_t end,
-				      struct page **pagepool,
-				      bool backmost)
+				      struct page **pagepool, bool backmost)
 {
 	struct inode *inode = f->inode;
 	struct erofs_map_blocks *map = &f->map;
-	erofs_off_t cur;
+	erofs_off_t cur, end, headoffset = f->headoffset;
 	int err;
 
 	if (backmost) {
+		if (rac)
+			end = headoffset + readahead_length(rac) - 1;
+		else
+			end = headoffset + PAGE_SIZE - 1;
 		map->m_la = end;
 		err = z_erofs_map_blocks_iter(inode, map,
 					      EROFS_GET_BLOCKS_READMORE);
 		if (err)
 			return;
 
-		/* expend ra for the trailing edge if readahead */
+		/* expand ra for the trailing edge if readahead */
 		if (rac) {
-			loff_t newstart = readahead_pos(rac);
-
 			cur = round_up(map->m_la + map->m_llen, PAGE_SIZE);
-			readahead_expand(rac, newstart, cur - newstart);
+			readahead_expand(rac, headoffset, cur - headoffset);
 			return;
 		}
 		end = round_up(end, PAGE_SIZE);
@@ -1699,10 +1698,9 @@ static int z_erofs_read_folio(struct file *file, struct folio *folio)
 	trace_erofs_readpage(page, false);
 	f.headoffset = (erofs_off_t)page->index << PAGE_SHIFT;
 
-	z_erofs_pcluster_readmore(&f, NULL, f.headoffset + PAGE_SIZE - 1,
-				  &pagepool, true);
+	z_erofs_pcluster_readmore(&f, NULL, &pagepool, true);
 	err = z_erofs_do_read_page(&f, page, &pagepool);
-	z_erofs_pcluster_readmore(&f, NULL, 0, &pagepool, false);
+	z_erofs_pcluster_readmore(&f, NULL, &pagepool, false);
 
 	(void)z_erofs_collector_end(&f);
 
@@ -1728,8 +1726,7 @@ static void z_erofs_readahead(struct readahead_control *rac)
 
 	f.headoffset = readahead_pos(rac);
 
-	z_erofs_pcluster_readmore(&f, rac, f.headoffset +
-				  readahead_length(rac) - 1, &pagepool, true);
+	z_erofs_pcluster_readmore(&f, rac, &pagepool, true);
 	nr_pages = readahead_count(rac);
 	trace_erofs_readpages(inode, readahead_index(rac), nr_pages, false);
 
@@ -1752,7 +1749,7 @@ static void z_erofs_readahead(struct readahead_control *rac)
 				  page->index, EROFS_I(inode)->nid);
 		put_page(page);
 	}
-	z_erofs_pcluster_readmore(&f, rac, 0, &pagepool, false);
+	z_erofs_pcluster_readmore(&f, rac, &pagepool, false);
 	(void)z_erofs_collector_end(&f);
 
 	z_erofs_runqueue(&f, &pagepool,
-- 
2.39.5



