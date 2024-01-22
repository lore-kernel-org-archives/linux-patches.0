Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CB94EB4A;
	Tue, 23 Jan 2024 00:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969777; cv=none; b=uzn6JinjdN+NKii86ydX8gbtkybsgB3qnStAIRs/1NJVUohF8p5n6SAZZHHKVbUXR4QMhv1IqBLg6FLRMlq0pGLBsbBVwyPIgmbXzpvE//WyiMsMd8vuQUpHfX6ZLuArEVkxhakdgiUw2w9Co9mRgNt0YLNgviAgZYSFgFGHq84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969777; c=relaxed/simple;
	bh=3taIzJyi/OiMhSII2V3/V4Wnmct3I4wJsKvOD02Hq3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVgG8jy3KZRtRDnnEcAK+HFvvugFAMD76xGFKtqgzvadPpNxW72zGGlXFpuH+E7BERhfRNdw/9/0s9bMIdzj6ohhLyIdVydrDdSqKHKT0HWmy9MC8Bjww+Rf6Yq4sKytUje9wFOSaM9/ArRfppT0cyvyfXIqAPgR+M8yswpraJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8cUimKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8cUimKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC69C433F1;
	Tue, 23 Jan 2024 00:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969776;
	bh=3taIzJyi/OiMhSII2V3/V4Wnmct3I4wJsKvOD02Hq3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8cUimKqQmFWmd6L5q8rLHnITL2EsgDAdK76TETqJl6uuQv3AWYUB/R8A3403lNp6
	 JUtZUM859JhYLtojcII6IqRwrhgvGJrvhR2y6Gfi5sg5A3+rWb7lUg57qoouh6WyuT
	 lkAbdZAUro7nJwZ8gaLI6rg9ahnhstV+dHPkFQE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.7 442/641] block: Remove special-casing of compound pages
Date: Mon, 22 Jan 2024 15:55:46 -0800
Message-ID: <20240122235831.855984997@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 1b151e2435fc3a9b10c8946c6aebe9f3e1938c55 upstream.

The special casing was originally added in pre-git history; reproducing
the commit log here:

> commit a318a92567d77
> Author: Andrew Morton <akpm@osdl.org>
> Date:   Sun Sep 21 01:42:22 2003 -0700
>
>     [PATCH] Speed up direct-io hugetlbpage handling
>
>     This patch short-circuits all the direct-io page dirtying logic for
>     higher-order pages.  Without this, we pointlessly bounce BIOs up to
>     keventd all the time.

In the last twenty years, compound pages have become used for more than
just hugetlb.  Rewrite these functions to operate on folios instead
of pages and remove the special case for hugetlbfs; I don't think
it's needed any more (and if it is, we can put it back in as a call
to folio_test_hugetlb()).

This was found by inspection; as far as I can tell, this bug can lead
to pages used as the destination of a direct I/O read not being marked
as dirty.  If those pages are then reclaimed by the MM without being
dirtied for some other reason, they won't be written out.  Then when
they're faulted back in, they will not contain the data they should.
It'll take a pretty unusual setup to produce this problem with several
races all going the wrong way.

This problem predates the folio work; it could for example have been
triggered by mmaping a THP in tmpfs and using that as the target of an
O_DIRECT read.

Fixes: 800d8c63b2e98 ("shmem: add huge pages support")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c |   46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -1145,13 +1145,22 @@ EXPORT_SYMBOL(bio_add_folio);
 
 void __bio_release_pages(struct bio *bio, bool mark_dirty)
 {
-	struct bvec_iter_all iter_all;
-	struct bio_vec *bvec;
+	struct folio_iter fi;
 
-	bio_for_each_segment_all(bvec, bio, iter_all) {
-		if (mark_dirty && !PageCompound(bvec->bv_page))
-			set_page_dirty_lock(bvec->bv_page);
-		bio_release_page(bio, bvec->bv_page);
+	bio_for_each_folio_all(fi, bio) {
+		struct page *page;
+		size_t done = 0;
+
+		if (mark_dirty) {
+			folio_lock(fi.folio);
+			folio_mark_dirty(fi.folio);
+			folio_unlock(fi.folio);
+		}
+		page = folio_page(fi.folio, fi.offset / PAGE_SIZE);
+		do {
+			bio_release_page(bio, page++);
+			done += PAGE_SIZE;
+		} while (done < fi.length);
 	}
 }
 EXPORT_SYMBOL_GPL(__bio_release_pages);
@@ -1439,18 +1448,12 @@ EXPORT_SYMBOL(bio_free_pages);
  * bio_set_pages_dirty() and bio_check_pages_dirty() are support functions
  * for performing direct-IO in BIOs.
  *
- * The problem is that we cannot run set_page_dirty() from interrupt context
+ * The problem is that we cannot run folio_mark_dirty() from interrupt context
  * because the required locks are not interrupt-safe.  So what we can do is to
  * mark the pages dirty _before_ performing IO.  And in interrupt context,
  * check that the pages are still dirty.   If so, fine.  If not, redirty them
  * in process context.
  *
- * We special-case compound pages here: normally this means reads into hugetlb
- * pages.  The logic in here doesn't really work right for compound pages
- * because the VM does not uniformly chase down the head page in all cases.
- * But dirtiness of compound pages is pretty meaningless anyway: the VM doesn't
- * handle them at all.  So we skip compound pages here at an early stage.
- *
  * Note that this code is very hard to test under normal circumstances because
  * direct-io pins the pages with get_user_pages().  This makes
  * is_page_cache_freeable return false, and the VM will not clean the pages.
@@ -1466,12 +1469,12 @@ EXPORT_SYMBOL(bio_free_pages);
  */
 void bio_set_pages_dirty(struct bio *bio)
 {
-	struct bio_vec *bvec;
-	struct bvec_iter_all iter_all;
+	struct folio_iter fi;
 
-	bio_for_each_segment_all(bvec, bio, iter_all) {
-		if (!PageCompound(bvec->bv_page))
-			set_page_dirty_lock(bvec->bv_page);
+	bio_for_each_folio_all(fi, bio) {
+		folio_lock(fi.folio);
+		folio_mark_dirty(fi.folio);
+		folio_unlock(fi.folio);
 	}
 }
 EXPORT_SYMBOL_GPL(bio_set_pages_dirty);
@@ -1515,12 +1518,11 @@ static void bio_dirty_fn(struct work_str
 
 void bio_check_pages_dirty(struct bio *bio)
 {
-	struct bio_vec *bvec;
+	struct folio_iter fi;
 	unsigned long flags;
-	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bvec, bio, iter_all) {
-		if (!PageDirty(bvec->bv_page) && !PageCompound(bvec->bv_page))
+	bio_for_each_folio_all(fi, bio) {
+		if (!folio_test_dirty(fi.folio))
 			goto defer;
 	}
 


