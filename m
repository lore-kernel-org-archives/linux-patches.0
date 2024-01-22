Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6E57318E;
	Tue, 23 Jan 2024 02:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975445; cv=none; b=hV+CSGrktc2HNbLeQyduGmcRYnzMZqI0vDWtLilOaVtrDVNwZmOlovWpaMod6MDL1h0z23NAW2k3wpZAla+54yvTZrf0+JqnmXs2pGgvTKgop5KXNg4A+v3R6c8wXrIdIcQTdAWmyFLkmQxMvKwG2DvwcbrCKxdBbDxFWcg0M/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975445; c=relaxed/simple;
	bh=VEqKbTbwaeGRclxakFjwulsdPouKcvgMvgGpM/fIe0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnefE5AcvVSUUGRPjF2LReVaohdP0pyBj4G26qxZDNGzVc9tQvK/GKx0f1BQwGJhJskw3dC4ye9j8xv7bsTDpdAqUQnRjMetHA92q4mOWuYMOVddiTRwHmt45FYY4sEEsLu+OqQ2BCmUTpyPSiHGVeJgCfVorLYKD0+1l0egxk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QBU7bgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QBU7bgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFD5C433F1;
	Tue, 23 Jan 2024 02:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975445;
	bh=VEqKbTbwaeGRclxakFjwulsdPouKcvgMvgGpM/fIe0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QBU7bgXjX9Hzugj+x3k10TKuKggPzboZUWXQ1wuKpllqrm/C7cZHRYsRJhLSLbd2
	 gyK1HZZG2hm1ycHRBqcUWaNUBgQYuC2bMMCh7PbPYTVWaJHe+vxwqU/9o4YngZiYEO
	 NWSNq4Gvoiwomp0Cm/B/RAVrtuLRhqYsOxQ4a2nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 402/583] block: Remove special-casing of compound pages
Date: Mon, 22 Jan 2024 15:57:33 -0800
Message-ID: <20240122235824.286907217@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


