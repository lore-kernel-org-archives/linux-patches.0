Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DBC1C5793;
	Tue,  8 Oct 2024 13:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392777; cv=none; b=LbcxX34hw98UWQngSJEmTnIRQtEvGLyOcapNUYwWT7YlAj1W5w2G8JZgr9xc9P0CgJtEXeFXv9Lunc9DyQOs4deDs8AGDPggsZb3HHU/TqGqWk+pWn6hHSvgS6kb7OISop9KATExumDcn8QRLbqVHQ/7eCaf83jPOgk/J3I426U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392777; c=relaxed/simple;
	bh=KyIY5r8X7jGeBO5es3HLKichb64PQVhISU2+qX5JgH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tze1xA2ygIu9ZwWNK7g1U4jGiFmTyEUqxL3HXh43cGRyNOjnkzE3e8hfkBprpzs/Ir2o2I+0/5hTJM/9kQMXI8BlW+hMoeoy8zIBEP48RiRrZkyWFU6qSAM0aPRFY3HrfKjJ8EyN2nplzRVUC3fwciLo9V8qe8UkQ+yS2d1vI3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RZJXleJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RZJXleJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44C4C4CEC7;
	Tue,  8 Oct 2024 13:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392777;
	bh=KyIY5r8X7jGeBO5es3HLKichb64PQVhISU2+qX5JgH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RZJXleJndiUi2g0XZ9MjqSUSO6HeBDtEYZElsL3UX5GtaNl9/ItxGATGB4vV3xpx
	 +NR0L8yvZZ6qRNl95deyCiKDplc2NFSGD6Ue539/NrYKuwT0o48Hq0PqWuGx1j37CD
	 pmsK4kGHGmx1n7OVZ6f4dGRKv/j2mMaUsriQjPDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Sistare <steven.sistare@oracle.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 485/558] mm/hugetlb: simplify refs in memfd_alloc_folio
Date: Tue,  8 Oct 2024 14:08:35 +0200
Message-ID: <20241008115721.320902391@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Sistare <steven.sistare@oracle.com>

commit dc677b5f3765cfd0944c8873d1ea57f1a3439676 upstream.

The folio_try_get in memfd_alloc_folio is not necessary.  Delete it, and
delete the matching folio_put in memfd_pin_folios.  This also avoids
leaking a ref if the memfd_alloc_folio call to hugetlb_add_to_page_cache
fails.  That error path is also broken in a second way -- when its
folio_put causes the ref to become 0, it will implicitly call
free_huge_folio, but then the path *explicitly* calls free_huge_folio.
Delete the latter.

This is a continuation of the fix
  "mm/hugetlb: fix memfd_pin_folios free_huge_pages leak"

[steven.sistare@oracle.com: remove explicit call to free_huge_folio(), per Matthew]
  Link: https://lkml.kernel.org/r/Zti-7nPVMcGgpcbi@casper.infradead.org
  Link: https://lkml.kernel.org/r/1725481920-82506-1-git-send-email-steven.sistare@oracle.com
Link: https://lkml.kernel.org/r/1725478868-61732-1-git-send-email-steven.sistare@oracle.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Suggested-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c   |    4 +---
 mm/memfd.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3618,7 +3618,7 @@ long memfd_pin_folios(struct file *memfd
 	pgoff_t start_idx, end_idx, next_idx;
 	struct folio *folio = NULL;
 	struct folio_batch fbatch;
-	struct hstate *h = NULL;
+	struct hstate *h;
 	long ret = -EINVAL;
 
 	if (start < 0 || start > end || !max_folios)
@@ -3662,8 +3662,6 @@ long memfd_pin_folios(struct file *memfd
 							     &fbatch);
 			if (folio) {
 				folio_put(folio);
-				if (h)
-					folio_put(folio);
 				folio = NULL;
 			}
 
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -89,13 +89,12 @@ struct folio *memfd_alloc_folio(struct f
 						    numa_node_id(),
 						    NULL,
 						    gfp_mask);
-		if (folio && folio_try_get(folio)) {
+		if (folio) {
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
 							idx);
 			if (err) {
 				folio_put(folio);
-				free_huge_folio(folio);
 				return ERR_PTR(err);
 			}
 			folio_unlock(folio);


