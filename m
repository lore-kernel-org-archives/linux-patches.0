Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81B41C9B99;
	Tue,  8 Oct 2024 13:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392768; cv=none; b=AjkLml7rqwfi/uF/0wH5HQMfIo2c8yI3tN8lVxmZ5UzQSwQ5NIRU5Di+ujhfw2vrUJ9NqX4TCGttDId7gmOXc5oSqesAgSkScE2agacZHeOa8LtcF35fhhFh3sQnMhhQQkR2mdc+NruekRlY9ywblx4IWERt1gV0LSSZ1YK2tbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392768; c=relaxed/simple;
	bh=cUD+nTiD9qkJU7OL+1ufMZdMIKmw/yt9A+1K+hh708g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lybgq4TNj7HtPC2X1/fNMh0NRh2eOIoWdzAgv9Zp5rr5uUH1ql/KSQNSDlA+DPxBWx7dr1KVsGIPUBRUGepbjry4a48A8vFkMnn1InJJn3ESQu42gy6MonrmqpYSIv+b/fGqqV1/2v23D1Sd93KWR4M1OKhxKxrq9znjCnfCppM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3N8M81q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3N8M81q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E27C4CEC7;
	Tue,  8 Oct 2024 13:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392768;
	bh=cUD+nTiD9qkJU7OL+1ufMZdMIKmw/yt9A+1K+hh708g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3N8M81qdrv9RKHt/jj6+Iw2xlQS183wP8azh3RCPNYbm4EEnNOIPBCB8dMdHwXdE
	 mlBnZxa8KcKWKBThnFjnESCxz29dMVp3vaTS1xf5F/nX1MTq8/9peP3vs/BSthEta/
	 q6NC+a5IOrYADtVK53uo988ONIyzeLd6uSLiVVV8=
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
Subject: [PATCH 6.11 482/558] mm/hugetlb: fix memfd_pin_folios resv_huge_pages leak
Date: Tue,  8 Oct 2024 14:08:32 +0200
Message-ID: <20241008115721.205151030@linuxfoundation.org>
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

commit 26a8ea80929c518bdec5e53a5776f95919b7c88e upstream.

memfd_pin_folios followed by unpin_folios leaves resv_huge_pages elevated
if the pages were not already faulted in.  During a normal page fault,
resv_huge_pages is consumed here:

hugetlb_fault()
  alloc_hugetlb_folio()
    dequeue_hugetlb_folio_vma()
      dequeue_hugetlb_folio_nodemask()
        dequeue_hugetlb_folio_node_exact()
          free_huge_pages--
      resv_huge_pages--

During memfd_pin_folios, the page is created by calling
alloc_hugetlb_folio_nodemask instead of alloc_hugetlb_folio, and
resv_huge_pages is not modified:

memfd_alloc_folio()
  alloc_hugetlb_folio_nodemask()
    dequeue_hugetlb_folio_nodemask()
      dequeue_hugetlb_folio_node_exact()
        free_huge_pages--

alloc_hugetlb_folio_nodemask has other callers that must not modify
resv_huge_pages.  Therefore, to fix, define an alternate version of
alloc_hugetlb_folio_nodemask for this call site that adjusts
resv_huge_pages.

Link: https://lkml.kernel.org/r/1725373521-451395-4-git-send-email-steven.sistare@oracle.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |   10 ++++++++++
 mm/hugetlb.c            |   17 +++++++++++++++++
 mm/memfd.c              |    9 ++++-----
 3 files changed, 31 insertions(+), 5 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -695,6 +695,9 @@ struct folio *alloc_hugetlb_folio(struct
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
+struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
+					  nodemask_t *nmask, gfp_t gfp_mask);
+
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			pgoff_t idx);
 void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
@@ -1060,6 +1063,13 @@ static inline struct folio *alloc_hugetl
 {
 	return NULL;
 }
+
+static inline struct folio *
+alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
+			    nodemask_t *nmask, gfp_t gfp_mask)
+{
+	return NULL;
+}
 
 static inline struct folio *
 alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2564,6 +2564,23 @@ struct folio *alloc_buddy_hugetlb_folio_
 	return folio;
 }
 
+struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
+		nodemask_t *nmask, gfp_t gfp_mask)
+{
+	struct folio *folio;
+
+	spin_lock_irq(&hugetlb_lock);
+	folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask, preferred_nid,
+					       nmask);
+	if (folio) {
+		VM_BUG_ON(!h->resv_huge_pages);
+		h->resv_huge_pages--;
+	}
+
+	spin_unlock_irq(&hugetlb_lock);
+	return folio;
+}
+
 /* folio migration callback function */
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 		nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback)
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -82,11 +82,10 @@ struct folio *memfd_alloc_folio(struct f
 		gfp_mask = htlb_alloc_mask(hstate_file(memfd));
 		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 
-		folio = alloc_hugetlb_folio_nodemask(hstate_file(memfd),
-						     numa_node_id(),
-						     NULL,
-						     gfp_mask,
-						     false);
+		folio = alloc_hugetlb_folio_reserve(hstate_file(memfd),
+						    numa_node_id(),
+						    NULL,
+						    gfp_mask);
 		if (folio && folio_try_get(folio)) {
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,


