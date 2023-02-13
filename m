Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A29A8F58
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C488C433D2;
	Mon, 13 Feb 2023 14:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300259;
	bh=QdJbVDLORVGTqvqBjIdlpc60dR5Ps1+GqguQjDvgweA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaMs0LsTgWmDIfvtYUo6jslOlnAyaS2mRzVhAP4AKtFZ86QWSvmnssDazJki3U7+3
	 WkYaIPaICSEPDwo6VnjvH824odKiQytwxGQrDzW3Ex4WYrSEN7Vr3z299WW0CdDu/S
	 xPaABr6c5kWCLkkRd8/3jWXxaJJx2yyR9+JWIv1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	James Houghton <jthoughton@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Naoya Horiguchi <naoya.horiguchi@linux.dev>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Yang Shi <shy828301@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/67] migrate: hugetlb: check for hugetlb shared PMD in node migration
Date: Mon, 13 Feb 2023 15:48:46 +0100
Message-Id: <20230213144732.575198575@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Kravetz <mike.kravetz@oracle.com>

[ Upstream commit 73bdf65ea74857d7fb2ec3067a3cec0e261b1462 ]

migrate_pages/mempolicy semantics state that CAP_SYS_NICE is required to
move pages shared with another process to a different node.  page_mapcount
> 1 is being used to determine if a hugetlb page is shared.  However, a
hugetlb page will have a mapcount of 1 if mapped by multiple processes via
a shared PMD.  As a result, hugetlb pages shared by multiple processes and
mapped with a shared PMD can be moved by a process without CAP_SYS_NICE.

To fix, check for a shared PMD if mapcount is 1.  If a shared PMD is found
consider the page shared.

Link: https://lkml.kernel.org/r/20230126222721.222195-3-mike.kravetz@oracle.com
Fixes: e2d8cf405525 ("migrate: add hugepage migration code to migrate_pages()")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 8687781b41c96..818753635e427 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -603,7 +603,8 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
 
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
-	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1)) {
+	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
+	     !hugetlb_pmd_shared(pte))) {
 		if (isolate_hugetlb(page, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*
-- 
2.39.0



