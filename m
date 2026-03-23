Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFB3396D3D;
	Mon, 23 Mar 2026 14:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276906; cv=none; b=SF+/BLQP1r+Kb5CuTgg/8EvxLOwTu12/Y4fIHfbQUy7fafbApYnp/tBwjrYFjwErKMSlRs4VHYT6sC0Ahaw26W07OFi9pucYsol0A67F9WQeSlNpufWU1H7/dnMq6Y9bxPpJ4mTFIJ1gCcHLdYHjrU35RhyO9brQd8MsQZb9TqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276906; c=relaxed/simple;
	bh=pVEPtLfdr35NL3sccPg0fMdXMHDsCa6dlEOpC+vqEW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ibl2VA0tNz4f6MKtDvpvyoKuy6CUVba/diUGlU24jKGPOi5cVt2G+YS+iXU/n7Bt9IRQsNxpocfxFHuSZjbRAw+Va8vYmdeOWFKvYgvvvyF9ikYqeJPBFqeZ0ShrsELSklw+eBxmlmE2g9dJsFrVR61FrTzxogO5FZNy5QjspuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQoTKlZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQoTKlZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E6AC4CEF7;
	Mon, 23 Mar 2026 14:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276906;
	bh=pVEPtLfdr35NL3sccPg0fMdXMHDsCa6dlEOpC+vqEW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQoTKlZzGM6XBg/P5kKrduab704OGnY5c0/Zg7aKtcSapGrlKuwd9DoRZWGpexIzY
	 M/osx3U4orUA5uUyo5olYIdoLXDO8FN0Spcj3BURZ7dwoCXIIAwfNKcWXbw7vMFd0h
	 NLuP5V0rq5XDjz1hqXeTR+eiLBzEV6kjyZWMwX8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Muchun Song <songmuchun@bytedance.com>,
	William Kucharski <william.kucharski@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 250/460] mm/page_alloc: move set_page_refcounted() to callers of post_alloc_hook()
Date: Mon, 23 Mar 2026 14:44:06 +0100
Message-ID: <20260323134532.638175106@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit 8fd10a892a8db797fffb59a9a60bce23a56eef46 ]

In preparation for allocating frozen pages, stop initialising the page
refcount in post_alloc_hook().

Link: https://lkml.kernel.org/r/20241125210149.2976098-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: d155aab90fff ("mm/kfence: fix KASAN hardware tag faults during late enablement")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/compaction.c |    2 ++
 mm/internal.h   |    3 +--
 mm/page_alloc.c |    3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -83,6 +83,7 @@ static inline bool is_via_compact_memory
 static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
 	post_alloc_hook(page, order, __GFP_MOVABLE);
+	set_page_refcounted(page);
 	return page;
 }
 #define mark_allocated(...)	alloc_hooks(mark_allocated_noprof(__VA_ARGS__))
@@ -1869,6 +1870,7 @@ again:
 	dst = (struct folio *)freepage;
 
 	post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
+	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
 	cc->nr_freepages -= 1 << order;
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -729,8 +729,7 @@ static inline void prep_compound_tail(st
 
 extern void prep_compound_page(struct page *page, unsigned int order);
 
-extern void post_alloc_hook(struct page *page, unsigned int order,
-					gfp_t gfp_flags);
+void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1542,7 +1542,6 @@ inline void post_alloc_hook(struct page
 	int i;
 
 	set_page_private(page, 0);
-	set_page_refcounted(page);
 
 	arch_alloc_page(page, order);
 	debug_pagealloc_map_pages(page, 1 << order);
@@ -1598,6 +1597,7 @@ static void prep_new_page(struct page *p
 							unsigned int alloc_flags)
 {
 	post_alloc_hook(page, order, gfp_flags);
+	set_page_refcounted(page);
 
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
@@ -6591,6 +6591,7 @@ static void split_free_pages(struct list
 			int i;
 
 			post_alloc_hook(page, order, __GFP_MOVABLE);
+			set_page_refcounted(page);
 			if (!order)
 				continue;
 


