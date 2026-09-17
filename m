Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991653B4E87;
	Thu, 17 Sep 2026 18:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668578; cv=none; b=EKdaaAVn+fQuhSjJh4zYoWaSpeXFih9c9S+qrWqePcIIX6jG7CitItJk4wl6LxA9ddwhoaz5H+ukK8iU6pnzBGmKs82ioDtQNsPIZPsM+O18fExWbyQBoK10bo17ahugI6iWZh+ja6csp0UuOFN0HGySNmH53hWreLrJVd6/3qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668578; c=relaxed/simple;
	bh=NwmaTEFHMA7Nhz2AYJ+siBcgOWcymmfS/V1Ha1v/M+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQzMTZwMYG1YbYdGcGvTPbrZyFcPKC0qwrY/hGqDr40Q1EkDNM/0iVHR/ZZd+5MowlPh736RrfC66qtE1tWvt3ls6NBH+a9th650AqFkI439m1Z73ogdXYJxeFdaJn2G8bMkk7wAS+t1KuihD6fi/R4tGI3GFLipRT+M7bMwrxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aa0naToY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aa0naToY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13211F000FF;
	Thu, 17 Sep 2026 18:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668576;
	bh=XSl//6nFIesR263/gARg8kafzgkTsWNdPbbUABFHFZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aa0naToYIp+L298Wvju9adgPbib0o/3c5ixrYtPa2D9sBCzloEoAGO+CZs8x8Bv0E
	 5DZwYyDwnOKHMC6+LyXAlheDYjeHZW/9KkSIQA2YXm5AghIMzpjMKhjTy20ug8vCIv
	 FxSPVx5uCyWkZ9OC1yZAd90TtOB3SM8APrPzO0L8=
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
Subject: [PATCH 6.12 0472/1102] mm/huge_memory: use folios memcg inside __folio_split()
Date: Thu, 17 Sep 2026 16:06:55 +0100
Message-ID: <20260917151551.542102472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 6fc4e1fb88ae6..1a76a21724d40 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3420,6 +3420,7 @@ int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 	/* reset xarray order to new order after split */
 	XA_STATE_ORDER(xas, &folio->mapping->i_pages, folio->index, new_order);
 	bool is_anon = folio_test_anon(folio);
+	struct mem_cgroup *memcg, *old_memcg;
 	struct address_space *mapping = NULL;
 	struct anon_vma *anon_vma = NULL;
 	int order = folio_order(folio);
@@ -3483,6 +3484,13 @@ int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 	if (folio_test_writeback(folio))
 		return -EBUSY;
 
+	/*
+	 * switch to folio's memcg as xarray node allocation can happen and
+	 * needs to charge to it.
+	 */
+	memcg = folio_memcg(folio);
+	old_memcg = set_active_memcg(memcg);
+
 	if (is_anon) {
 		/*
 		 * The caller does not necessarily hold an mmap_lock that would
@@ -3629,6 +3637,8 @@ int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 	if (mapping)
 		i_mmap_unlock_read(mapping);
 out:
+	/* restore to caller's old_memcg */
+	set_active_memcg(old_memcg);
 	xas_destroy(&xas);
 	if (order == HPAGE_PMD_ORDER)
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
-- 
2.53.0



