Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6F4442FDA;
	Thu, 30 Jul 2026 15:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424865; cv=none; b=pnTsF41/KB9xGmqkwt5JWvFg+dnhKuC2cn/g4m96K49WQJ9FhTISXGiVZGbGs1XC/g2DHLrmgDPFCXQiQrVDe+hvDIU9ue7TvHExLphn/wnozICjbXBsrS2hmhCHQYy6G5VVfGoI5o1ep/6ym454XKOyk4LpbBsKJO6F4SwTRzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424865; c=relaxed/simple;
	bh=UPNIHN35LEizrQlVJX0CIUI68bUICmH9qtwqAifZhBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9xi4Ij+8ISGbdAAcM0XluewtpkJWuNgtSxNETozaBFBi6Mw0+a/9fo62frdoZ2SKuZPNHFuG+4zH1u6z98lxOSAX4UqsC1fBkj6kwu+TODPmvseTv9ynSTHUBfZLydb7oa/6Sfbdp8b6njkOQxFvsd3UXC8fVNIgO3Lbjo8oK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgKKnuTv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgKKnuTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0FC1F00ACF;
	Thu, 30 Jul 2026 15:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424863;
	bh=BHUXSlkq+F7XZusUtZ43ZskoX8vfdcCJ25dehEDp2QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AgKKnuTvX10kPagww8nRp77NhtoDYb3b/ZCT5wbHrHcjty+0lNOvM1j47StUFYwVR
	 8H4z31iwD6U3fKP35Le98K3iDR7EagwQ4wVXkExWTtDq60drMBiDgL9PBm+Vgr9kNw
	 24+qOO+vkziUt4zbO+O2stBOXhO1Kh+k72f8PJh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 506/675] mm/huge_memory: set PG_has_hwpoisoned only after new folio head is established
Date: Thu, 30 Jul 2026 16:13:56 +0200
Message-ID: <20260730141455.882578881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

commit e1cd30eceb6908fc13bebce41283b885d71ee8d6 upstream.

__split_folio_to_order() copies the hwpoison state onto each new sub-folio
while splitting a folio to a non-zero order.  It does so via

	if (handle_hwpoison && page_range_has_hwpoisoned(new_head, new_nr_pages))
		folio_set_has_hwpoisoned(new_folio);

*before* clear_compound_head(new_head)/prep_compound_page(new_head, ...)
turns @new_head from a tail page into a proper folio head.

PG_has_hwpoisoned is a FOLIO_SECOND_PAGE flag, so
folio_set_has_hwpoisoned() resolves to folio_flags(folio, 1).  With the
new compound_info-based page-flags layout, folio_flags() asserts the page
is not a tail:

	VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);

At the current call site @new_head still has the tail marker
(compound_info bit 0 set, PG_head clear), so on CONFIG_DEBUG_VM kernels
this hits:

  kernel BUG at include/linux/page-flags.h:354
  folio_flags+0x82
  folio_set_has_hwpoisoned
  __split_folio_to_order
  __split_unmapped_folio
  __folio_split
  truncate_inode_partial_folio  (shmem hole-punch / MADV_REMOVE)

Reproduced by syzkaller: hwpoison-inject a few subpages of a large shmem
folio, then MADV_REMOVE (fallocate punch hole) on the same range, which
splits the partial folio to a non-zero order.

memory_failure() tries to split the poisoned folio to order 0 first, but
that split is best-effort; when it fails the folio is left large with
PG_has_hwpoisoned set, the case fa5a06170036 added this hwpoison copying
for.

Move the folio_set_has_hwpoisoned() call to after
clear_compound_head()/prep_compound_page(), where @new_folio is a real
order-new_order head folio (handle_hwpoison implies new_order != 0, so a
second page always exists).  The flag still lands on the same struct page
(page[1] of the new folio); only the ordering relative to compound-head
setup changes, satisfying the FOLIO_SECOND_PAGE precondition.

Link: https://lore.kernel.org/20260701174235.3173401-1-riel@surriel.com
Fixes: fa5a06170036 ("mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order")
Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3344,10 +3344,6 @@ static void __split_folio_to_order(struc
 				 (1L << PG_dirty) |
 				 LRU_GEN_MASK | LRU_REFS_MASK));
 
-		if (handle_hwpoison &&
-		    page_range_has_hwpoisoned(new_head, new_nr_pages))
-			folio_set_has_hwpoisoned(new_folio);
-
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
@@ -3378,6 +3374,14 @@ static void __split_folio_to_order(struc
 			folio_set_large_rmappable(new_folio);
 		}
 
+		/*
+		 * PG_has_hwpoisoned is on the 2nd page, so set it after
+		 * the compound head is prepped.
+		 */
+		if (handle_hwpoison &&
+		    page_range_has_hwpoisoned(new_head, new_nr_pages))
+			folio_set_has_hwpoisoned(new_folio);
+
 		if (folio_test_young(folio))
 			folio_set_young(new_folio);
 		if (folio_test_idle(folio))


