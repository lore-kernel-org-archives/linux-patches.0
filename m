Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FD91465B0;
	Thu, 13 Jun 2024 11:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279590; cv=none; b=IgCH+HiVzT6AnohrG/fZNOZq5MNLI79THZc5mk2Zqmtirhk6ztzW0uo0Dr8wxPYwTTuNyFdSKByw8JwLPhPKJ+8pB9ELQ94U+q4sujzXhqf5gfpCJXfeB1/hVIsnLL7ZbyO1PMasnKiWMMp7CJ7MlpYH4pKv3tuEwmXlpMkAXvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279590; c=relaxed/simple;
	bh=y0txJ4wajv1n+qqdE31I87uq+m+QAqWOlJG7gh3kMNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bozfhUdSZcxiadcGZHg0flTGPFH6WDEXHIhUSGfUE7PCs9T0/TCwp5ZKQstsEdrUQw0xVotYyutNiPosv8zdnSCHspJ0b2WXPujehEAjW/BXlfzmndL3l7h01e6EcF4pvBzVij0Ae5bZgyguVlBrbRnolYXYODXKOE2IGv7nMqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bz1bE+X3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bz1bE+X3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28C9C2BBFC;
	Thu, 13 Jun 2024 11:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279590;
	bh=y0txJ4wajv1n+qqdE31I87uq+m+QAqWOlJG7gh3kMNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bz1bE+X3rXoNRug7Sm7Z8ABzo8BVXlt4Og6+oj8GLA4i1AzRJ9T+jiUYW420q33id
	 dDs1NNx8VON/rh0FGO9Y8L46Up3GypG0j0hgCzEm4413FqFnZQ6g/juBaknwsSgq39
	 hVaBXhfk8WXctyBaJssD31QwEjF0MxFZrTlXXiQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank van der Linden <fvdl@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 097/157] mm/hugetlb: pass correct order_per_bit to cma_declare_contiguous_nid
Date: Thu, 13 Jun 2024 13:33:42 +0200
Message-ID: <20240613113231.175986049@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

From: Frank van der Linden <fvdl@google.com>

commit 55d134a7b499c77e7cfd0ee41046f3c376e791e5 upstream.

The hugetlb_cma code passes 0 in the order_per_bit argument to
cma_declare_contiguous_nid (the alignment, computed using the page order,
is correctly passed in).

This causes a bit in the cma allocation bitmap to always represent a 4k
page, making the bitmaps potentially very large, and slower.

It would create bitmaps that would be pretty big.  E.g.  for a 4k page
size on x86, hugetlb_cma=64G would mean a bitmap size of (64G / 4k) / 8
== 2M.  With HUGETLB_PAGE_ORDER as order_per_bit, as intended, this
would be (64G / 2M) / 8 == 4k.  So, that's quite a difference.

Also, this restricted the hugetlb_cma area to ((PAGE_SIZE <<
MAX_PAGE_ORDER) * 8) * PAGE_SIZE (e.g.  128G on x86) , since
bitmap_alloc uses normal page allocation, and is thus restricted by
MAX_PAGE_ORDER.  Specifying anything about that would fail the CMA
initialization.

So, correctly pass in the order instead.

Link: https://lkml.kernel.org/r/20240404162515.527802-2-fvdl@google.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7879,9 +7879,9 @@ void __init hugetlb_cma_reserve(int orde
 		 * huge page demotion.
 		 */
 		res = cma_declare_contiguous_nid(0, size, 0,
-						PAGE_SIZE << HUGETLB_PAGE_ORDER,
-						 0, false, name,
-						 &hugetlb_cma[nid], nid);
+					PAGE_SIZE << HUGETLB_PAGE_ORDER,
+					HUGETLB_PAGE_ORDER, false, name,
+					&hugetlb_cma[nid], nid);
 		if (res) {
 			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
 				res, nid);


