Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01DE345CDC;
	Mon, 13 Apr 2026 17:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099720; cv=none; b=CiebymDTy2wxAJicFAIYS6NqDSSISEK8i7Mw6WQeY9VJm/Ystb+bLcTZQRTzqsybcyy4Z7AN5FFZW5CiTONqOI0wwXN3SNpFEIxPlRxF4GA0mrfFPzkn+e6xvDcu7R2cpa11fi/Qv2+MmFAGCPaMOZmQdxJjPhGXqhfP3+21h4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099720; c=relaxed/simple;
	bh=zDZoORf9XyOrGILCvLTK7ddyAcTgpCmFJ3RQwvP8ADU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=az7cf3EO1JiopA9sCYQ1f2ELe6vdEiINUga3RHWIcynmnB5i2mjTCEhswlNjE5XBPwSlfWpIkf2t+08F6yQw9WXMgzPZWkr13wkLPKbTfvMR4IyG/SxLhXhMHhp1RnNZlQVDQyKnbGzJo+DXH7tJh3+LULLVl/lcMVjzmzq58r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcW413Wk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcW413Wk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDABC2BCAF;
	Mon, 13 Apr 2026 17:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099720;
	bh=zDZoORf9XyOrGILCvLTK7ddyAcTgpCmFJ3RQwvP8ADU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcW413WkmzYrtnXarJYTvhhRLhKbLZhzPZeANUgEABBr+kWwAQs4uLaECk+OFQVzj
	 7a5FglgIZiFSHIA1O5/YIPC7C08r2EIqnFeQxIy4jTnMkMV+AC33qYrMBO4Bd7+6EQ
	 t0TJ+A4oXcUhlvP1yhQPxajpNwj8O1JUe6b9Joes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Lance Yang <lance.yang@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Liu Shixin <liushixin2@huawei.com>,
	"Uschakow, Stanislav" <suschako@amazon.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 421/491] mm/hugetlb: fix hugetlb_pmd_shared()
Date: Mon, 13 Apr 2026 18:01:06 +0200
Message-ID: <20260413155834.787570692@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Red Hat) <david@kernel.org>

Commit ca1a47cd3f5f4c46ca188b1c9a27af87d1ab2216 upstream.

Patch series "mm/hugetlb: fixes for PMD table sharing (incl.  using
mmu_gather)", v3.

One functional fix, one performance regression fix, and two related
comment fixes.

I cleaned up my prototype I recently shared [1] for the performance fix,
deferring most of the cleanups I had in the prototype to a later point.
While doing that I identified the other things.

The goal of this patch set is to be backported to stable trees "fairly"
easily. At least patch #1 and #4.

Patch #1 fixes hugetlb_pmd_shared() not detecting any sharing
Patch #2 + #3 are simple comment fixes that patch #4 interacts with.
Patch #4 is a fix for the reported performance regression due to excessive
IPI broadcasts during fork()+exit().

The last patch is all about TLB flushes, IPIs and mmu_gather.
Read: complicated

There are plenty of cleanups in the future to be had + one reasonable
optimization on x86. But that's all out of scope for this series.

Runtime tested, with a focus on fixing the performance regression using
the original reproducer [2] on x86.

This patch (of 4):

We switched from (wrongly) using the page count to an independent shared
count.  Now, shared page tables have a refcount of 1 (excluding
speculative references) and instead use ptdesc->pt_share_count to identify
sharing.

We didn't convert hugetlb_pmd_shared(), so right now, we would never
detect a shared PMD table as such, because sharing/unsharing no longer
touches the refcount of a PMD table.

Page migration, like mbind() or migrate_pages() would allow for migrating
folios mapped into such shared PMD tables, even though the folios are not
exclusive.  In smaps we would account them as "private" although they are
"shared", and we would be wrongly setting the PM_MMAP_EXCLUSIVE in the
pagemap interface.

Fix it by properly using ptdesc_pmd_is_shared() in hugetlb_pmd_shared().

Link: https://lkml.kernel.org/r/20251223214037.580860-1-david@kernel.org
Link: https://lkml.kernel.org/r/20251223214037.580860-2-david@kernel.org
Link: https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/ [1]
Link: https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/ [2]
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: "Uschakow, Stanislav" <suschako@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit ca1a47cd3f5f4c46ca188b1c9a27af87d1ab2216)
[ David: We don't have ptdesc and the wrappers, so work directly on
  page->pt_share_count. ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 1c03935aa3d13..0d3fece27031c 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -955,7 +955,7 @@ static inline __init void hugetlb_cma_check(void)
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
 static inline bool hugetlb_pmd_shared(pte_t *pte)
 {
-	return page_count(virt_to_page(pte)) > 1;
+	return atomic_read(&virt_to_page(pte)->pt_share_count);
 }
 #else
 static inline bool hugetlb_pmd_shared(pte_t *pte)
-- 
2.53.0



