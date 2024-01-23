Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E6965BB4;
	Tue, 23 Jan 2024 01:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975106; cv=none; b=atUuqrCNFM0TxnOse3GewPKEWOgS2ZbIkrNnR63NxEp0hqrWC3BNdOLqZ6GUAeVSXHEhvoGsGvD/Bfa89aoFlV3u+OVOtQ3yPEI9CvPtBkwZaziQq+SvDeb2u+8v+r0ChdhesBe+0XDH5I6KcYAETn4DrIXhXOukQgVvXkfL0FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975106; c=relaxed/simple;
	bh=xdpy8mT8kDQG1lC+o5sTNatXyzNIXOTqGAcVjpcZEIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cb7LS0qySHCn9va0gWqhLNB4Epdm5EQo+M7d9B39uedMpjjNuFQcUIkKqbhykxB5qAWdDhrN5t4pA4m7JlPJi4b9AOBSq0zkS/S7zs5vIAlPxaMRrciRj7+2MfN9UA/YhX3yW/7pmxmWk7QW7g/uPGDtNdQjzf3mManA5gV3NM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hs0H75dw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hs0H75dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B0BC43394;
	Tue, 23 Jan 2024 01:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975105;
	bh=xdpy8mT8kDQG1lC+o5sTNatXyzNIXOTqGAcVjpcZEIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hs0H75dwbpQxvj99us+W6vOtjur3yaKXikwS/aOuw6gHSvYZXHoj/BYiJR7qxWlBb
	 7eqvvtZIe1ZZeouKXHkYS35lw0NvmHYTw10kGnhMr0rGe2ZnWJ7cJCgeYE/6rmyX9y
	 r6HetCvobJxetDzcDjT2ikRNNiHxulhk96cxCx/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 368/374] block: Remove special-casing of compound pages
Date: Mon, 22 Jan 2024 16:00:24 -0800
Message-ID: <20240122235757.765760980@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1026,7 +1026,7 @@ void bio_release_pages(struct bio *bio,
 		return;
 
 	bio_for_each_segment_all(bvec, bio, iter_all) {
-		if (mark_dirty && !PageCompound(bvec->bv_page))
+		if (mark_dirty)
 			set_page_dirty_lock(bvec->bv_page);
 		put_page(bvec->bv_page);
 	}
@@ -1345,8 +1345,7 @@ void bio_set_pages_dirty(struct bio *bio
 	struct bvec_iter_all iter_all;
 
 	bio_for_each_segment_all(bvec, bio, iter_all) {
-		if (!PageCompound(bvec->bv_page))
-			set_page_dirty_lock(bvec->bv_page);
+		set_page_dirty_lock(bvec->bv_page);
 	}
 }
 
@@ -1394,7 +1393,7 @@ void bio_check_pages_dirty(struct bio *b
 	struct bvec_iter_all iter_all;
 
 	bio_for_each_segment_all(bvec, bio, iter_all) {
-		if (!PageDirty(bvec->bv_page) && !PageCompound(bvec->bv_page))
+		if (!PageDirty(bvec->bv_page))
 			goto defer;
 	}
 


