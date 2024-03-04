Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6571EB5A;
	Mon,  4 Mar 2024 21:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587774; cv=none; b=jYKsVb4j5nBTaRH7pw4Dt+jyu7bIVVhvBEzWWY40WSYUqFN/ncvk2UwY3oVFdIHvaUe249v3huY2PKDR3etWu75Who5KbN1mD9wrCUlB/xXAm/EoAzds3JFY7WNGEtuypqKYOe22cy8eHr6ih09B+WaFAbwOHtB5FMdbbf+gmDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587774; c=relaxed/simple;
	bh=KP3XmIs45Y1Odvl4JVdg6/JEMu2gMaDSQOXWwJByXbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtYAHD8fWmV+pGHmQ5g9InEoPt9ksNjmpi7Wl4Pfijj4xm5QCvwojvx6sYzQ6O4NELVJQ0L+mcLbxuR1yUDriyOx/OVsbbzA3Ci6OzqE7JFr/W8NniJl5gqUTJKam88M4gS47LHB83yKFwdxjoYfmGxzja6Jbfwa1KL3mp/7cWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mm75f8RF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mm75f8RF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10DCC433C7;
	Mon,  4 Mar 2024 21:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587774;
	bh=KP3XmIs45Y1Odvl4JVdg6/JEMu2gMaDSQOXWwJByXbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mm75f8RFZrDRsm/xVB+ljVuFuP8GuhcmCOwr9JlKPBO0hLPbGiARpgJYQsEd/sFgx
	 OogNfTWFlEc7xIyZ4UGF+pD5fNxdtoELm21z0HV6cPHRk1QpHA6w5i2vKZPaF5zjWw
	 f7s5pu0ONzt3S/Aj5+cHkvQZU7UnzGgf8ZIi74As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 084/162] mm: cachestat: fix folio read-after-free in cache walk
Date: Mon,  4 Mar 2024 21:22:29 +0000
Message-ID: <20240304211554.519570504@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

From: Nhat Pham <nphamcs@gmail.com>

commit 3a75cb05d53f4a6823a32deb078de1366954a804 upstream.

In cachestat, we access the folio from the page cache's xarray to compute
its page offset, and check for its dirty and writeback flags.  However, we
do not hold a reference to the folio before performing these actions,
which means the folio can concurrently be released and reused as another
folio/page/slab.

Get around this altogether by just using xarray's existing machinery for
the folio page offsets and dirty/writeback states.

This changes behavior for tmpfs files to now always report zeroes in their
dirty and writeback counters.  This is okay as tmpfs doesn't follow
conventional writeback cache behavior: its pages get "cleaned" during
swapout, after which they're no longer resident etc.

Link: https://lkml.kernel.org/r/20240220153409.GA216065@cmpxchg.org
Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
Reported-by: Jann Horn <jannh@google.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>	[6.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |   51 ++++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4108,28 +4108,40 @@ static void filemap_cachestat(struct add
 
 	rcu_read_lock();
 	xas_for_each(&xas, folio, last_index) {
+		int order;
 		unsigned long nr_pages;
 		pgoff_t folio_first_index, folio_last_index;
 
+		/*
+		 * Don't deref the folio. It is not pinned, and might
+		 * get freed (and reused) underneath us.
+		 *
+		 * We *could* pin it, but that would be expensive for
+		 * what should be a fast and lightweight syscall.
+		 *
+		 * Instead, derive all information of interest from
+		 * the rcu-protected xarray.
+		 */
+
 		if (xas_retry(&xas, folio))
 			continue;
 
+		order = xa_get_order(xas.xa, xas.xa_index);
+		nr_pages = 1 << order;
+		folio_first_index = round_down(xas.xa_index, 1 << order);
+		folio_last_index = folio_first_index + nr_pages - 1;
+
+		/* Folios might straddle the range boundaries, only count covered pages */
+		if (folio_first_index < first_index)
+			nr_pages -= first_index - folio_first_index;
+
+		if (folio_last_index > last_index)
+			nr_pages -= folio_last_index - last_index;
+
 		if (xa_is_value(folio)) {
 			/* page is evicted */
 			void *shadow = (void *)folio;
 			bool workingset; /* not used */
-			int order = xa_get_order(xas.xa, xas.xa_index);
-
-			nr_pages = 1 << order;
-			folio_first_index = round_down(xas.xa_index, 1 << order);
-			folio_last_index = folio_first_index + nr_pages - 1;
-
-			/* Folios might straddle the range boundaries, only count covered pages */
-			if (folio_first_index < first_index)
-				nr_pages -= first_index - folio_first_index;
-
-			if (folio_last_index > last_index)
-				nr_pages -= folio_last_index - last_index;
 
 			cs->nr_evicted += nr_pages;
 
@@ -4147,24 +4159,13 @@ static void filemap_cachestat(struct add
 			goto resched;
 		}
 
-		nr_pages = folio_nr_pages(folio);
-		folio_first_index = folio_pgoff(folio);
-		folio_last_index = folio_first_index + nr_pages - 1;
-
-		/* Folios might straddle the range boundaries, only count covered pages */
-		if (folio_first_index < first_index)
-			nr_pages -= first_index - folio_first_index;
-
-		if (folio_last_index > last_index)
-			nr_pages -= folio_last_index - last_index;
-
 		/* page is in cache */
 		cs->nr_cache += nr_pages;
 
-		if (folio_test_dirty(folio))
+		if (xas_get_mark(&xas, PAGECACHE_TAG_DIRTY))
 			cs->nr_dirty += nr_pages;
 
-		if (folio_test_writeback(folio))
+		if (xas_get_mark(&xas, PAGECACHE_TAG_WRITEBACK))
 			cs->nr_writeback += nr_pages;
 
 resched:


