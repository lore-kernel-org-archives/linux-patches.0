Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795133515C1;
	Sat, 12 Sep 2026 15:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227862; cv=none; b=qB/qfAWzlUynTMveHEy9QoN8sPke0Q8rkn0Pf208U71Umw6MYVJ/Z/PfIbbU5Zs1ekK7C7WlZYUisuUN/rDqupsl/2pcaW2J/FTzYhVeNm+F9Da7A353k/LcvLVg891ta+vgR/kj+5biAXqV7WDZiOjs4igy6XinN3h7w1wZfO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227862; c=relaxed/simple;
	bh=CVhda+fJbkTzYPQwDhDPjIe2SgFD/ms4OQD1A1YTlg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJekZdbzr1Q8HsSKnjViiakPgF6jvpyCpGHdfYMK2A2diH2uu+MMHUZwwcS8akBg12IKw7+mPlRt0iX442OXdXoc9IV4A+DGpaAczgX+mVLGkEOfjUSf0qitzRaPe4JNoWdzLWCQBNUSLF0HTRrt21C8WNlaB8yZbs3ygvnLXh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJMHwacf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJMHwacf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BDB1F00893;
	Sat, 12 Sep 2026 15:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227861;
	bh=Es5JzUtnE6rdZUyH5c4uxYLVI9C6MuG45r0HHm1Blx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJMHwacfaALh0hP4ukKyk3FcUNeOsB1SI8miShe0GdEklPbMZ55q/e8ukIR8A5CLo
	 xWIdLU5dVbP+mcAlZiJV7m/W4Y2llYUw+9qBqXqZpx29JJRRVixj62hnnRAKljTcBa
	 oRBf6GOfnYH4EMQ52k0Ps+yVyxDM408bxWTm5+UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	William Kucharski <william.kucharski@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0267/1191] mm/huge_memory: use folios memcg inside __folio_split()
Date: Sat, 12 Sep 2026 08:49:55 +0200
Message-ID: <20260912065554.220188581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zi Yan <ziy@nvidia.com>

commit c299a2285d9d8bda4da024455de65e3d00de6f17 upstream.

Patch series "Honor XA_FLAGS_ACCOUNT in xas_split_alloc() and charge to
folio's memcg", v3.

__GFP_ACCOUNT is needed for xarray node allocation accounting when
XA_FLAGS_ACCOUNT is set. Commit 7b785645e8f13 ("mm: fix page cache
convergence regression") fixed a workingset regression with it.
xas_split_alloc() does not have it and needs to be fixed.

In addition, based on Sashiko's review[1] and Johannes' confirmation[2], to
charge the right memcg, folio's memcg needs to be active during folio
split. Add that before adding __GFP_ACCOUNT.

There is no workingset convergence regression related to missing
__GFP_ACCOUNT in xas_split_alloc() and the impact to userspace should be
minor.

This patch (of 2):

During a pagecache folio split, an xarray node allocation can happen and
needs to charge at folio's memcg instead of folio split invoker's memcg,
because for example folio split can happen during reclaim and reclaim's
active memcg might not be folio's memcg.  Switch to folio's memcg at the
beginning and switch back afterwards.

Link: https://lore.kernel.org/20260804-add-gfp_account-to-xas_split_alloc-v3-0-38cb3ff325c5@nvidia.com
Link: https://lore.kernel.org/20260804-add-gfp_account-to-xas_split_alloc-v3-1-38cb3ff325c5@nvidia.com
Link: https://sashiko.dev/#/patchset/20260727-add-gfp_account-to-xas_split_alloc-v1-1-9fae6bf64838%40nvidia.com?part=1 [1]
Link: https://lore.kernel.org/all/amtcBZ-_QVRgCd6b@cmpxchg.org/ [2]
Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 35a9a0271492d..483cdc373a20c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2676,6 +2676,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	struct folio *folio = page_folio(page);
 	struct deferred_split *ds_queue = get_deferred_split_queue(&folio->page);
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
+	struct mem_cgroup *memcg, *old_memcg;
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
 	int extra_pins, ret;
@@ -2694,6 +2695,13 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	if (folio_test_writeback(folio))
 		return -EBUSY;
 
+	/*
+	 * switch to folio's memcg as xarray node allocation can happen and
+	 * needs to charge to it.
+	 */
+    memcg = folio_memcg(folio);
+    old_memcg = set_active_memcg(memcg);
+
 	if (folio_test_anon(folio)) {
 		/*
 		 * The caller does not necessarily hold an mmap_lock that would
@@ -2821,6 +2829,8 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	if (mapping)
 		i_mmap_unlock_read(mapping);
 out:
+	/* restore to caller's old_memcg */
+	set_active_memcg(old_memcg);
 	xas_destroy(&xas);
 	count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	return ret;
-- 
2.53.0



