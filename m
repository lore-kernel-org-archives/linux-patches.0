Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9AE8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B10C433C9;
	Sun, 16 Jul 2023 20:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539178;
	bh=OAwa4yHFrLFWnhI9AOF1MEHPvOmbJPFxZWG6pgcXj+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3c+Zy9U/HEnmzxNz/rgKt41aRaoogNm5Hl94lOsoioCoUjezPsGgVnibtQur32iI
	 eRpa/3YRclqO+4jdKrJLHe77Uwo2zRoA+TlB6G+IKejSVUxUm91PjwJzJe0h0QZcO1
	 06MaY+Oi2bZ+XypEzy8uiCDMPEDOtT6tVsgE+4eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 715/800] writeback: account the number of pages written back
Date: Sun, 16 Jul 2023 21:49:28 +0200
Message-ID: <20230716195005.725847022@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 8344a3d44be3d18671e18c4ba23bb03dd21e14ad ]

nr_to_write is a count of pages, so we need to decrease it by the number
of pages in the folio we just wrote, not by 1.  Most callers specify
either LONG_MAX or 1, so are unaffected, but writeback_sb_inodes() might
end up writing 512x as many pages as it asked for.

Dave added:

: XFS is the only filesystem this would affect, right?  AFAIA, nothing
: else enables large folios and uses writeback through
: write_cache_pages() at this point...
:
: In which case, I'd be surprised if much difference, if any, gets
: noticed by anyone.

Link: https://lkml.kernel.org/r/20230628185548.981888-1-willy@infradead.org
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page-writeback.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index db79439990073..6faa09f1783b3 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2434,6 +2434,7 @@ int write_cache_pages(struct address_space *mapping,
 
 		for (i = 0; i < nr_folios; i++) {
 			struct folio *folio = fbatch.folios[i];
+			unsigned long nr;
 
 			done_index = folio->index;
 
@@ -2471,6 +2472,7 @@ int write_cache_pages(struct address_space *mapping,
 
 			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
 			error = writepage(folio, wbc, data);
+			nr = folio_nr_pages(folio);
 			if (unlikely(error)) {
 				/*
 				 * Handle errors according to the type of
@@ -2489,8 +2491,7 @@ int write_cache_pages(struct address_space *mapping,
 					error = 0;
 				} else if (wbc->sync_mode != WB_SYNC_ALL) {
 					ret = error;
-					done_index = folio->index +
-						folio_nr_pages(folio);
+					done_index = folio->index + nr;
 					done = 1;
 					break;
 				}
@@ -2504,7 +2505,8 @@ int write_cache_pages(struct address_space *mapping,
 			 * keep going until we have written all the pages
 			 * we tagged for writeback prior to entering this loop.
 			 */
-			if (--wbc->nr_to_write <= 0 &&
+			wbc->nr_to_write -= nr;
+			if (wbc->nr_to_write <= 0 &&
 			    wbc->sync_mode == WB_SYNC_NONE) {
 				done = 1;
 				break;
-- 
2.39.2



