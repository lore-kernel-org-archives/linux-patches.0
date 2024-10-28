Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CF92C697;
	Mon, 28 Oct 2024 06:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097669; cv=none; b=TnOxxDbYpTn3Mk0Tsh0SMzQKBInEkFxveWH6FMDW8JoqvEF0TJPgZsPGisSbQP9kKkJTzuG/cPdloJd9Iu//ydzD9hSgO98nQaHIUcmtBMUnSeBQmDUjys9Yo9HORlaXI1EQmrh710sD58wZpr5m87KZ0eVQLW8Z9KoQ34C5sNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097669; c=relaxed/simple;
	bh=StoG53KJ3PP/AU3n5Fe3jQlKMElG7r9CdLAKYnHJj1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxURy5LX3KPWjAFeZ84YrYVnKJhVWfJZOUQAsTX+iyx53N/WccY0IGYVMV7+SlrNebAgQIGPGh3q9yER0zD5Ufle8zvKNuQHzvbxeMUKzpdpHSvDLDs7zvShN5ttKXAe78fUHUAL42ZVpszlJFToxxzR1FhLuXgALxIAMSYkZiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbaBAQC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbaBAQC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01457C4CEC3;
	Mon, 28 Oct 2024 06:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097669;
	bh=StoG53KJ3PP/AU3n5Fe3jQlKMElG7r9CdLAKYnHJj1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbaBAQC9yozCor9snzvuxwRYKwYjO83RI5n9cwjCHYzJ+K/C6m9KwJ3A34Hku+ure
	 oTAlhJ4hh1qI3NAASGHfWn9p9EaxQdqtzulzEgcir5lrWw7JVPhOiEqfFk3qvQLcEl
	 tAvgQBQqXFTdoA4SpubJmhqS7rVv6upNOMVr1TSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/208] khugepaged: inline hpage_collapse_alloc_folio()
Date: Mon, 28 Oct 2024 07:24:34 +0100
Message-ID: <20241028062308.972084113@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 4746f5ce0fa52e21b5fe432970fe9516d1a45ebc ]

Patch series "khugepaged folio conversions".

We've been kind of hacking piecemeal at converting khugepaged to use
folios instead of compound pages, and so this patchset is a little larger
than it should be as I undo some of our wrong moves in the past.  In
particular, collapse_file() now consistently uses 'new_folio' for the
freshly allocated folio and 'folio' for the one that's currently in use.

This patch (of 7):

This function has one caller, and the combined function is simpler to
read, reason about and modify.

Link: https://lkml.kernel.org/r/20240403171838.1445826-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240403171838.1445826-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 37f0b47c5143 ("mm: khugepaged: fix the arguments order in khugepaged_collapse_file trace point")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index cb6a243688045..d0fcfa47085b4 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -887,20 +887,6 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
 }
 #endif
 
-static bool hpage_collapse_alloc_folio(struct folio **folio, gfp_t gfp, int node,
-				      nodemask_t *nmask)
-{
-	*folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, nmask);
-
-	if (unlikely(!*folio)) {
-		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
-		return false;
-	}
-
-	count_vm_event(THP_COLLAPSE_ALLOC);
-	return true;
-}
-
 /*
  * If mmap_lock temporarily dropped, revalidate vma
  * before taking mmap_lock.
@@ -1063,11 +1049,14 @@ static int alloc_charge_hpage(struct page **hpage, struct mm_struct *mm,
 	int node = hpage_collapse_find_target_node(cc);
 	struct folio *folio;
 
-	if (!hpage_collapse_alloc_folio(&folio, gfp, node, &cc->alloc_nmask)) {
+	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
+	if (!folio) {
 		*hpage = NULL;
+		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
 	}
 
+	count_vm_event(THP_COLLAPSE_ALLOC);
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
 		*hpage = NULL;
-- 
2.43.0



