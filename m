Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052042;
	b=NVgh/EtsBR20SUGcc7fYbObFy/y/Sv6cKUk628GCHLg9xgx2fDcELGWvCTGmc1Qidj9R
	 3mH+06VfDRWGB5ufV5418HRRGP3oomBqBQ6pTv44eTKKpD1fKdUCGHRS3P2WXiX+ykLhs
	 2rhtdSeYM5NOGvBS7eTsoMt6e3CF5ufZJPU0Rqi20hzELkLbyocON/MPYrb7ET41Wttq5
	 1iSPSrajGpzvmuN7aPaHGSTTgCWrF/qzqWVGIom2xCIbdLSc+Xx8gkneYWE8w1Bb0yiEu
	 1ay23GhmDFdDSB17Bn0x6VPyM+6oyLyVFP19V61cTysJKHKKJwNcFHOluLmrXzSTBAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qxKdIId9MYnyWtM+2lZetbAt1LVzLc9KENu4fOjE1WE=;
	b=b8cZLRqKkxRHZJrcxEzDKCKPkTggcS/uDX5v9dxLy74wG37AZXBfTaGEVL6rOU2JgBwx
	 HULn37el/dt4XnEi/F5iSt5SkcBW70IwB9miEcVHeNwJEYhmr4WsE91B4mxsbsys6djda
	 PYxCvzndMIajNEO5hZSk79ybakr9Mo9BFu+yqZ5+Rv1BWMxj5JKx4rvhDvWeUq+ozKOTM
	 UQMRS76TxFRA16mib5xJ2De1FCjB47SxnaqO534io5X1HnRY+gYvUsiufNAWAR/X3iGAS
	 oH66+PVJxEp2r+8BVNxOYOWKHaSSPQkvp/XSqpaJNLsP/DI5FH/cyI0SOk81wpK5MSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DL7BDGgJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42118606A325;
	Thu, 19 Nov 2026 01:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DL7BDGgJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1947B1F000C4;
	Thu, 19 Nov 2026 01:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052041;
	bh=qxKdIId9MYnyWtM+2lZetbAt1LVzLc9KENu4fOjE1WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DL7BDGgJwG85FrbNuyWWFB7czR4KGxaODmwIh9LB3kEIrNvY2VF7rPfd93+XXoSSW
	 xGxPz8huLtsE2pEcFwjir/h8+6ieikWEk6eykvjZEjDi5cNbMSvZfgdBBvf0JR16oN
	 J66oTsBNqp3/sCYuqE8QAW8P51aoZOv7LT39hxhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Adam Litke <agl@us.ibm.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Rik van Riel <riel@surriel.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0416/2214] mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
Date: Wed, 18 Nov 2026 15:34:52 +0100
Message-ID: <20261118150027.495155136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit d8a9cd7fd2fb01211430c933932da58839b8ca65 ]

Let's fix another instance where we use a folio after dropping the PTL,
where someone else could e.g., MADV_DONTNEED it once we drop the PTL,
making us trigger a use-after-free on the folio.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-3-42796911043b@kernel.org
Fixes: cb6acd01e2e4 ("hugetlbfs: fix races and page leaks during migration")
Fixes: 1c9e8def43a3 ("userfaultfd: hugetlbfs: add UFFDIO_COPY support for shared mappings")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>
[ sashal: adapted folio-based code and comments to page-based APIs in hugetlb_mcopy_atomic_pte() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 947610e37a33c..e8ee7ef7fe03b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5390,11 +5390,16 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 
-	spin_unlock(ptl);
 	if (!is_continue)
 		SetHPageMigratable(page);
 	if (vm_shared || is_continue)
 		unlock_page(page);
+
+	/*
+	 * Hold the PTL until we're done with the page: the page table owns the
+	 * page reference now.
+	 */
+	spin_unlock(ptl);
 	ret = 0;
 out:
 	return ret;
-- 
2.53.0



