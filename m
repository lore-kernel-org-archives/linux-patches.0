Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE25D19AD93;
	Tue, 16 Jul 2024 15:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145251; cv=none; b=rc6GipvOY2ChUiWXpG78kpnOZUvpC5nfBb7qnMz6d16/BJd3xGj4uslw1787qz1OT61zd/y0GyRaHpT3+5LIbmcXYEGmDlusNu3sqFwjhPWhlieHdU+TOYaMVZA6wxhmtiNgh3Y7ldudFTFNLBM9T8ZDGTyxMSXFuV4URO0hO5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145251; c=relaxed/simple;
	bh=SKpIbAmLk0L1gq1Z2JoR2S75fLHx9/CoH3sNvrASKDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aszIsEKop4Zjr4jbL9yjaoUYTO14klW+eoIOFXL8yjXiHVIadpbU7o2v7M6/tNWRtYlJwkU70QkhpP6G/le6q3oKRdTsMPkN4/79af/QhPknhDcmI7k+Jl/yggMV7vY+UlHZhTEzerLJwBQhPNRaKnNKrhmShKovrPfPy8M95v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NeGK3AjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NeGK3AjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415A8C4AF0D;
	Tue, 16 Jul 2024 15:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145250;
	bh=SKpIbAmLk0L1gq1Z2JoR2S75fLHx9/CoH3sNvrASKDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NeGK3AjBUaPvpvEgJtQ3fpLJyDFlWwWghpsLxkBLoxQvbBojnbbEPqxSuyc3lQQn+
	 L7zaF/R7+Od3qpJUwdP0SDM5Y3uTPvqjCLLl2bfnxS2tvnQjgiBJpUJQt/eheIq0+p
	 g8CUTwSyKSJy/04/bWf7sBe1ejJgd/BlUK4RQibI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Don Dutile <ddutile@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	William Kucharski <william.kucharski@oracle.com>,
	Zhenyu Zhang <zhenyzha@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 130/143] mm/readahead: limit page cache size in page_cache_ra_order()
Date: Tue, 16 Jul 2024 17:32:06 +0200
Message-ID: <20240716152800.986784326@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gshan@redhat.com>

commit 1f789a45c3f1aa77531db21768fca70b66c0eeb1 upstream.

In page_cache_ra_order(), the maximal order of the page cache to be
allocated shouldn't be larger than MAX_PAGECACHE_ORDER.  Otherwise, it's
possible the large page cache can't be supported by xarray when the
corresponding xarray entry is split.

For example, HPAGE_PMD_ORDER is 13 on ARM64 when the base page size is
64KB.  The PMD-sized page cache can't be supported by xarray.

Link: https://lkml.kernel.org/r/20240627003953.1262512-3-gshan@redhat.com
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Zhenyu Zhang <zhenyzha@redhat.com>
Cc: <stable@vger.kernel.org>	[5.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/readahead.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -499,11 +499,11 @@ void page_cache_ra_order(struct readahea
 
 	limit = min(limit, index + ra->size - 1);
 
-	if (new_order < MAX_PAGECACHE_ORDER) {
+	if (new_order < MAX_PAGECACHE_ORDER)
 		new_order += 2;
-		new_order = min_t(unsigned int, MAX_PAGECACHE_ORDER, new_order);
-		new_order = min_t(unsigned int, new_order, ilog2(ra->size));
-	}
+
+	new_order = min_t(unsigned int, MAX_PAGECACHE_ORDER, new_order);
+	new_order = min_t(unsigned int, new_order, ilog2(ra->size));
 
 	/* See comment in page_cache_ra_unbounded() */
 	nofs = memalloc_nofs_save();


