Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3B11C5793;
	Tue,  8 Oct 2024 13:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392771; cv=none; b=eGXTAzIPhHsNL6M9r7hb7CFh1jcKiInE/nVMosVptu1lqcfVcu2YVCQI7D7v5pt09RPimm2x/luKLBY3JSZvjfnPf5IguG4BaKlvSF6bbbyZWubpASBFBw1jLgiw6pbkuvZ9WbbJSZFUhAa5LK7pDab2ouLUJjBoSkgGn2SNyJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392771; c=relaxed/simple;
	bh=nS4cKFDcZcA30smaD8BgFwUcCpjcCSc++P9HtTD06As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qsu1r3dCpBGUVXAE2/4Fjy4ZlsUxdCOkSYtvrHI+cYd1Tv6HbXdVzstCjZv5Q5W0gwn60dJVAvvLvkjRewnguTkJjExOPQkgd+4HaOPeXdfarn4/OjN19MCWeaYpVPHu1il/0jD+4xjTrkEWPkzLwtSZhZqIA9/oEpuH6W2TMUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYFlCGoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYFlCGoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00083C4CEC7;
	Tue,  8 Oct 2024 13:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392771;
	bh=nS4cKFDcZcA30smaD8BgFwUcCpjcCSc++P9HtTD06As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xYFlCGoHkj5O8Im+c9fUAk1ZeBRMSZdlcWMk5FFjDVlU4rquQmqWJ/x7H//ou0L9p
	 YCrUXUm16TalP3FNs9Aqs0N7NZM4G1D32KvicLdnQ1f7bJRVYZGse8Jg9kANoTpcKP
	 /Al7LPWRJu+z+z4Ath+blxH3TjvBgIqrRrE3o8/k=
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
Subject: [PATCH 6.11 483/558] mm/gup: fix memfd_pin_folios hugetlb page allocation
Date: Tue,  8 Oct 2024 14:08:33 +0200
Message-ID: <20241008115721.243699291@linuxfoundation.org>
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

commit 9289f020da47ef04b28865589eeee3d56d4bafea upstream.

When memfd_pin_folios -> memfd_alloc_folio creates a hugetlb page, the
index is wrong.  The subsequent call to filemap_get_folios_contig thus
cannot find it, and fails, and memfd_pin_folios loops forever.  To fix,
adjust the index for the huge_page_order.

memfd_alloc_folio also forgets to unlock the folio, so the next touch of
the page calls hugetlb_fault which blocks forever trying to take the lock.
Unlock it.

Link: https://lkml.kernel.org/r/1725373521-451395-5-git-send-email-steven.sistare@oracle.com
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
 mm/memfd.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index bfe0e7189a37..bcb131db829d 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -79,10 +79,13 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		 * alloc from. Also, the folio will be pinned for an indefinite
 		 * amount of time, so it is not expected to be migrated away.
 		 */
-		gfp_mask = htlb_alloc_mask(hstate_file(memfd));
-		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
+		struct hstate *h = hstate_file(memfd);
 
-		folio = alloc_hugetlb_folio_reserve(hstate_file(memfd),
+		gfp_mask = htlb_alloc_mask(h);
+		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
+		idx >>= huge_page_order(h);
+
+		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
 						    gfp_mask);
@@ -95,6 +98,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 				free_huge_folio(folio);
 				return ERR_PTR(err);
 			}
+			folio_unlock(folio);
 			return folio;
 		}
 		return ERR_PTR(-ENOMEM);
-- 
2.46.2



