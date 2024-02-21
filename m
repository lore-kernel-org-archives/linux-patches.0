Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2005A7EEF7;
	Wed, 21 Feb 2024 14:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524971; cv=none; b=uZEgDHBuxxSzQwT1HTQ+E0AIIn11jxY5iNc1rsqBsHv0PwbdsGxaWGrbADuaQEp+QrsFMYfWCe9zBOcKp4dbyUxIDGxIlEM8hTJ01Q+TEhVke+gqjfUtd5KI7mKAHAPGEPq+zfEU4zcWmpKCRYD8ZkJPCWF9KQPpLQPbKDlPxc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524971; c=relaxed/simple;
	bh=5vzBi9xoK9jjfntcpkgV+QUVedwdoSZ5U62wJFw9ajk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1xcVxbRw/a/gsOlpfM+o0IBUWRbHIfEXTv9kBdnY730XYP9WUKWakOVMH3SGjZvj4nyESqnhzjqyGGaNgZBYblCMPfqY7XpWgJz3Ru4m1rjSX2v1AqHDjjZklQ3wv5MbarlCjwcHq5xKJ+cBIaQh8TMXbyEU6YkX2zNUxXVBWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8xHTeqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8xHTeqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E642C43390;
	Wed, 21 Feb 2024 14:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524969;
	bh=5vzBi9xoK9jjfntcpkgV+QUVedwdoSZ5U62wJFw9ajk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8xHTeqdmfpga8qpxY5Osym2JJN3a0LZ8XPJPiLC0i5JKyvF0dklZ5mXGhCfcH2Xm
	 snSq84+fRd1yqu3qiEgqnPRN4cufy01zS5jNfwlPSsEq0W26E9saAwXYfDUDwIdre2
	 XTmv79BAXdInJejsW5sOhZQcuvqBLYGO9v41pwW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 020/267] block: Remove special-casing of compound pages
Date: Wed, 21 Feb 2024 14:06:01 +0100
Message-ID: <20240221125940.684073698@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 block/bio.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -884,7 +884,7 @@ void bio_release_pages(struct bio *bio,
 		return;
 
 	bio_for_each_segment_all(bvec, bio, iter_all) {
-		if (mark_dirty && !PageCompound(bvec->bv_page))
+		if (mark_dirty)
 			set_page_dirty_lock(bvec->bv_page);
 		put_page(bvec->bv_page);
 	}
@@ -1691,8 +1691,7 @@ void bio_set_pages_dirty(struct bio *bio
 	struct bvec_iter_all iter_all;
 
 	bio_for_each_segment_all(bvec, bio, iter_all) {
-		if (!PageCompound(bvec->bv_page))
-			set_page_dirty_lock(bvec->bv_page);
+		set_page_dirty_lock(bvec->bv_page);
 	}
 }
 
@@ -1740,7 +1739,7 @@ void bio_check_pages_dirty(struct bio *b
 	struct bvec_iter_all iter_all;
 
 	bio_for_each_segment_all(bvec, bio, iter_all) {
-		if (!PageDirty(bvec->bv_page) && !PageCompound(bvec->bv_page))
+		if (!PageDirty(bvec->bv_page))
 			goto defer;
 	}
 


