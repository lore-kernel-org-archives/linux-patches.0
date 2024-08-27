Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCE11C93AB;
	Tue, 27 Aug 2024 15:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772670; cv=none; b=C4zdOd6G4wDhmlM8MyXQL0CS6lVhrNL/0IBpqtcWhr4WIdZfg9EU6mY6yVMHN4JYpaa4jkRm/VJGsGCqsuFq0QXQKQHCc2D2vjxDUuyZAx7OpXA3EonEZ0nJAZfszlik0vQYX+qmIM2S8phMiBu0Uy+USYWS/kAtRr5ysttGKaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772670; c=relaxed/simple;
	bh=bLKuIY4KgwuDVv51XHTZ5nQhbhMhG1LA2f1Cf9qJ4Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXm+8UjbHs6lPr57niojCR3quyzYCeSYksNlX3Glc/JZBZXO/KFMiwlB3fisoVfNV6/6DQsQdtdqO7od8+vzuuOhv3YTmC1ZynNKFwXOuFVunimKQ+W+zdQpNhma+Sy361Bh5uVS1APZVRefcg/lJYOdzWdz1wkgcuhxy9L2LwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EREN9kRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EREN9kRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB4BC4DDE9;
	Tue, 27 Aug 2024 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772670;
	bh=bLKuIY4KgwuDVv51XHTZ5nQhbhMhG1LA2f1Cf9qJ4Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EREN9kRcNOwoJoP6ogygFr9zFF0IY0MYmO5RCCw0BcP15327Rep+6LRmQ8KQocAvl
	 oTusXAaAlswgyoOFKRLgw4itD/nVLDbcruggC6Inr3Rcz+AasdQdp5i5dwLQC3PGHm
	 JVdVgEkSQBWrhqu2Yng7J1N9s14uETPpL7hYyWgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hailong Liu <hailong.liu@oppo.com>,
	Tangquan Zheng <zhengtangquan@oppo.com>,
	Baoquan He <bhe@redhat.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 285/321] mm/vmalloc: fix page mapping if vm_area_alloc_pages() with high order fallback to order 0
Date: Tue, 27 Aug 2024 16:39:53 +0200
Message-ID: <20240827143849.096663262@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Hailong Liu <hailong.liu@oppo.com>

commit 61ebe5a747da649057c37be1c37eb934b4af79ca upstream.

The __vmap_pages_range_noflush() assumes its argument pages** contains
pages with the same page shift.  However, since commit e9c3cda4d86e ("mm,
vmalloc: fix high order __GFP_NOFAIL allocations"), if gfp_flags includes
__GFP_NOFAIL with high order in vm_area_alloc_pages() and page allocation
failed for high order, the pages** may contain two different page shifts
(high order and order-0).  This could lead __vmap_pages_range_noflush() to
perform incorrect mappings, potentially resulting in memory corruption.

Users might encounter this as follows (vmap_allow_huge = true, 2M is for
PMD_SIZE):

kvmalloc(2M, __GFP_NOFAIL|GFP_X)
    __vmalloc_node_range_noprof(vm_flags=VM_ALLOW_HUGE_VMAP)
        vm_area_alloc_pages(order=9) ---> order-9 allocation failed and fallback to order-0
            vmap_pages_range()
                vmap_pages_range_noflush()
                    __vmap_pages_range_noflush(page_shift = 21) ----> wrong mapping happens

We can remove the fallback code because if a high-order allocation fails,
__vmalloc_node_range_noprof() will retry with order-0.  Therefore, it is
unnecessary to fallback to order-0 here.  Therefore, fix this by removing
the fallback code.

Link: https://lkml.kernel.org/r/20240808122019.3361-1-hailong.liu@oppo.com
Fixes: e9c3cda4d86e ("mm, vmalloc: fix high order __GFP_NOFAIL allocations")
Signed-off-by: Hailong Liu <hailong.liu@oppo.com>
Reported-by: Tangquan Zheng <zhengtangquan@oppo.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2992,15 +2992,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			page = alloc_pages(alloc_gfp, order);
 		else
 			page = alloc_pages_node(nid, alloc_gfp, order);
-		if (unlikely(!page)) {
-			if (!nofail)
-				break;
-
-			/* fall back to the zero order allocations */
-			alloc_gfp |= __GFP_NOFAIL;
-			order = 0;
-			continue;
-		}
+		if (unlikely(!page))
+			break;
 
 		/*
 		 * Higher order allocations must be able to be treated as


