Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C726E6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FBEC340EE;
	Tue, 22 Mar 2022 21:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985135;
	bh=DDf9lcxfMPm5yFDfS0T2nBpsxu+qWkoo1Qjc4KrD/PQ=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=K2yyK5sDaHg696M5bATsqsf1lngM7yb6z7CpgjP2esEJFL3i6AnEPo2qBrYbdUqCY
	 r5h7VzA3PCUslCUtWDYtQw+Y/qQc5VjJ8tLhFpRDQRxdHnvi7pAtZrrt5HyaZZsrpn
	 sLXoXwHS3Th8fde7xP/+kt0uidhCTCaMV0AMoQeg=
Date: Tue, 22 Mar 2022 14:38:54 -0700
To: trond.myklebust@hammerspace.com,philipp.reisner@linbit.com,paolo.valente@linaro.org,miklos@szeredi.hu,lars.ellenberg@linbit.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,jack@suse.cz,idryomov@gmail.com,fengguang.wu@intel.com,djwong@kernel.org,chao@kernel.org,axboe@kernel.dk,Anna.Schumaker@Netapp.com,neilb@suse.de,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 008/227] mm: improve cleanup when ->readpages doesn't process all pages
Message-Id: <20220322213855.86FBEC340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: NeilBrown <neilb@suse.de>
Subject: mm: improve cleanup when ->readpages doesn't process all pages

If ->readpages doesn't process all the pages, then it is best to act as
though they weren't requested so that a subsequent readahead can try
again.

So:
  - remove any 'ahead' pages from the page cache so they can be loaded
    with ->readahead() rather then multiple ->read()s
  - update the file_ra_state to reflect the reads that were actually
    submitted.

This allows ->readpages() to abort early due e.g.  to congestion, which
will then allow us to remove the inode_read_congested() test from
page_Cache_async_ra().

Link: https://lkml.kernel.org/r/164549983736.9187.16755913785880819183.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Paolo Valente <paolo.valente@linaro.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/mm/readahead.c~mm-improve-cleanup-when-readpages-doesnt-process-all-pages
+++ a/mm/readahead.c
@@ -104,7 +104,13 @@
  * for necessary resources (e.g.  memory or indexing information) to
  * become available.  Pages in the final ``async_size`` may be
  * considered less urgent and failure to read them is more acceptable.
- * They will eventually be read individually using ->readpage().
+ * In this case it is best to use delete_from_page_cache() to remove the
+ * pages from the page cache as is automatically done for pages that
+ * were not fetched with readahead_page().  This will allow a
+ * subsequent synchronous read ahead request to try them again.  If they
+ * are left in the page cache, then they will be read individually using
+ * ->readpage().
+ *
  */
 
 #include <linux/kernel.h>
@@ -226,8 +232,17 @@ static void read_pages(struct readahead_
 
 	if (aops->readahead) {
 		aops->readahead(rac);
-		/* Clean up the remaining pages */
+		/*
+		 * Clean up the remaining pages.  The sizes in ->ra
+		 * maybe be used to size next read-ahead, so make sure
+		 * they accurately reflect what happened.
+		 */
 		while ((page = readahead_page(rac))) {
+			rac->ra->size -= 1;
+			if (rac->ra->async_size > 0) {
+				rac->ra->async_size -= 1;
+				delete_from_page_cache(page);
+			}
 			unlock_page(page);
 			put_page(page);
 		}
_
