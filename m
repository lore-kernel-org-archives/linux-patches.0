Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E6314B96F;
	Wed, 19 Jun 2024 13:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803787; cv=none; b=BuD4/wI+txd1kisdsFZbBVUFQLodL/wVtx+5L7UVueBYvwx8p2NQKDT9LNKtxeXEnuFar0c4nIsbaxNUpRWj89qIILkFLLP7S4n2xw94YCFSWQupnjfyZL/IkNbItvEPgnPCZnKnRPS242mBxgc+E0ixBYcQKhTAlKukDwDypRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803787; c=relaxed/simple;
	bh=dH0kR/iFLSON3irqr8qXIMFYOerx3atf6kxomtx0nPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqrDEJ6m16VNK1CMYDYxRIoQzmFWzkuammllratkzZdqliA1AzhKm1LdqpsaCDuGng99avjy18GH7mjksdhv20MVdJtOJNfy5dtDSWDJGvaXTOYbNbVastSUR4l5khGGMx+EOucdK+BN3gDIzwwWLm5Djl4NQ9PHaOaGuH2jT1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efEXfnjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efEXfnjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B700C2BBFC;
	Wed, 19 Jun 2024 13:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803786;
	bh=dH0kR/iFLSON3irqr8qXIMFYOerx3atf6kxomtx0nPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efEXfnjBBA1B0+VcpHcahQKkje+2/mc6iR7nCWi9poqoX1YRrf06L9uhjaT9yTvL6
	 dDwVDmjBH3VzgpRdgSt6+/+7/I0QzTy74O5MAzrVPd7w6HgkiueqpJEbk16fZReStj
	 qgi3s9qRBeXTypTkM9WoZ4TpZLNsci15cf2pA6t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Michal Hocko <mhocko@suse.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Baoquan He <bhe@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Mel Gorman <mgorman@techsingularity.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/217] mm, vmalloc: fix high order __GFP_NOFAIL allocations
Date: Wed, 19 Jun 2024 14:55:15 +0200
Message-ID: <20240619125559.462342381@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.com>

[ Upstream commit e9c3cda4d86e56bf7fe403729f38c4f0f65d3860 ]

Gao Xiang has reported that the page allocator complains about high order
__GFP_NOFAIL request coming from the vmalloc core:

 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5549
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2286
 vm_area_alloc_pages mm/vmalloc.c:2989 [inline]
 __vmalloc_area_node mm/vmalloc.c:3057 [inline]
 __vmalloc_node_range+0x978/0x13c0 mm/vmalloc.c:3227
 kvmalloc_node+0x156/0x1a0 mm/util.c:606
 kvmalloc include/linux/slab.h:737 [inline]
 kvmalloc_array include/linux/slab.h:755 [inline]
 kvcalloc include/linux/slab.h:760 [inline]

it seems that I have completely missed high order allocation backing
vmalloc areas case when implementing __GFP_NOFAIL support.  This means
that [k]vmalloc at al.  can allocate higher order allocations with
__GFP_NOFAIL which can trigger OOM killer for non-costly orders easily or
cause a lot of reclaim/compaction activity if those requests cannot be
satisfied.

Fix the issue by falling back to zero order allocations for __GFP_NOFAIL
requests if the high order request fails.

Link: https://lkml.kernel.org/r/ZAXynvdNqcI0f6Us@dhcp22.suse.cz
Fixes: 9376130c390a ("mm/vmalloc: add support for __GFP_NOFAIL")
Reported-by: Gao Xiang <hsiangkao@linux.alibaba.com>
  Link: https://lkml.kernel.org/r/20230305053035.1911-1-hsiangkao@linux.alibaba.com
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 8e0545c83d67 ("mm/vmalloc: fix vmalloc which may return null if called with __GFP_NOFAIL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmalloc.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 67a10a04df041..cab30d9497e6b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2923,6 +2923,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		unsigned int order, unsigned int nr_pages, struct page **pages)
 {
 	unsigned int nr_allocated = 0;
+	gfp_t alloc_gfp = gfp;
+	bool nofail = false;
 	struct page *page;
 	int i;
 
@@ -2933,6 +2935,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	 * more permissive.
 	 */
 	if (!order) {
+		/* bulk allocator doesn't support nofail req. officially */
 		gfp_t bulk_gfp = gfp & ~__GFP_NOFAIL;
 
 		while (nr_allocated < nr_pages) {
@@ -2971,20 +2974,35 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			if (nr != nr_pages_request)
 				break;
 		}
+	} else if (gfp & __GFP_NOFAIL) {
+		/*
+		 * Higher order nofail allocations are really expensive and
+		 * potentially dangerous (pre-mature OOM, disruptive reclaim
+		 * and compaction etc.
+		 */
+		alloc_gfp &= ~__GFP_NOFAIL;
+		nofail = true;
 	}
 
 	/* High-order pages or fallback path if "bulk" fails. */
-
 	while (nr_allocated < nr_pages) {
 		if (fatal_signal_pending(current))
 			break;
 
 		if (nid == NUMA_NO_NODE)
-			page = alloc_pages(gfp, order);
+			page = alloc_pages(alloc_gfp, order);
 		else
-			page = alloc_pages_node(nid, gfp, order);
-		if (unlikely(!page))
-			break;
+			page = alloc_pages_node(nid, alloc_gfp, order);
+		if (unlikely(!page)) {
+			if (!nofail)
+				break;
+
+			/* fall back to the zero order allocations */
+			alloc_gfp |= __GFP_NOFAIL;
+			order = 0;
+			continue;
+		}
+
 		/*
 		 * Higher order allocations must be able to be treated as
 		 * indepdenent small pages by callers (as they can with
-- 
2.43.0



