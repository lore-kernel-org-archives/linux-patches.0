Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9921DE2A5;
	Tue,  8 Oct 2024 13:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392765; cv=none; b=obn/JIv16gFpUBCAa+QSKNhMGubcOqnVp2xq9FRAk9/jquvRmpg2Jlfa3FbOLf7VcTFwSrXT0OdK76BlZPEJfmwXgnA/erEGehWTqbAIVWvIBGm84tORiN54XZzu2BfHARaCCOXf6f/Ebq+aIQyXjHwdl00tsIPpLUq+f5Ax0Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392765; c=relaxed/simple;
	bh=Vb/0NYmcHhgbm5GueE9wJAOAKz5b/0X6Dpsa7M1tAno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFuV4xMYzD2nltzQAHWxxLjDb3RPxjnZFa/d1NVVTWm6fIxaS8yOjhWfsl1FI2kXuE2OCkUPJfwxWNU+/VQTD/a8befCbSLB51VCprpFQk9XCqr5iF9NK3RP24FlEt+GlB61EQ0i7syGY5N/qPvd8na0RyN9qs3WVEM+JwQAp6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgSfpKEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgSfpKEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E26C4CEC7;
	Tue,  8 Oct 2024 13:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392764;
	bh=Vb/0NYmcHhgbm5GueE9wJAOAKz5b/0X6Dpsa7M1tAno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgSfpKEBrXwpEGHRqI0U6S5jCT3S68gp/Qu2X7HKhm9wVwDYKUG1T0W1vr8986d8E
	 rRF+7+NQLrXpqkl+pWAoSrFxAPFqAc06pAWCBvqYTsPJ4NpfmmJSsUtXYUAdcbAAtL
	 Fo/2CMzWklC6naWRHzu7zQAfrOkWeMR3+LHgChlQ=
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
Subject: [PATCH 6.11 481/558] mm/hugetlb: fix memfd_pin_folios free_huge_pages leak
Date: Tue,  8 Oct 2024 14:08:31 +0200
Message-ID: <20241008115721.166014543@linuxfoundation.org>
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

commit c56b6f3d801d7ec8965993342bdd9e2972b6cb8e upstream.

memfd_pin_folios followed by unpin_folios fails to restore free_huge_pages
if the pages were not already faulted in, because the folio refcount for
pages created by memfd_alloc_folio never goes to 0.  memfd_pin_folios
needs another folio_put to undo the folio_try_get below:

memfd_alloc_folio()
  alloc_hugetlb_folio_nodemask()
    dequeue_hugetlb_folio_nodemask()
      dequeue_hugetlb_folio_node_exact()
        folio_ref_unfreeze(folio, 1);    ; adds 1 refcount
  folio_try_get()                        ; adds 1 refcount
  hugetlb_add_to_page_cache()            ; adds 512 refcount (on x86)

With the fix, after memfd_pin_folios + unpin_folios, the refcount for the
(unfaulted) page is 512, which is correct, as the refcount for a faulted
unpinned page is 513.

Link: https://lkml.kernel.org/r/1725373521-451395-3-git-send-email-steven.sistare@oracle.com
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
 mm/gup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3618,7 +3618,7 @@ long memfd_pin_folios(struct file *memfd
 	pgoff_t start_idx, end_idx, next_idx;
 	struct folio *folio = NULL;
 	struct folio_batch fbatch;
-	struct hstate *h;
+	struct hstate *h = NULL;
 	long ret = -EINVAL;
 
 	if (start < 0 || start > end || !max_folios)
@@ -3662,6 +3662,8 @@ long memfd_pin_folios(struct file *memfd
 							     &fbatch);
 			if (folio) {
 				folio_put(folio);
+				if (h)
+					folio_put(folio);
 				folio = NULL;
 			}
 


