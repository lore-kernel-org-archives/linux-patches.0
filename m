Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431CC1EFFB9;
	Wed, 23 Apr 2025 15:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421542; cv=none; b=mS2CarGpzpdSSVWgSVlJmvmYYcwT1KbRX9qC7P1aa0zEjW5L3lpB9FGKSukW388vi3X8Be7sCZ0zJQ46I/anPs/4h0Zt7vUj06kVuCCr3XikdEgHdGII4jnm9vHUmIQnoMnAsJX/JreeSop38eXyUOXkyqyOoglfTgQ1yOsSe3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421542; c=relaxed/simple;
	bh=DRp1oIIWetkesQhj+5xLltDuJi3UnY5kj2PuG3J5uU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFo7+IKeXqQrMXd+MHBZZIVXLzh9O6c9hW4hllYneTGU3ZW0kSFGvFPs+QpQlkbomC700coO4zqhgowSoPN/yFb40gsfXpXQ7PiVT3wuCnGO6GV0PXGXQM5v9bHQajjWQsP1X44bqa9XaMTTESOT9cTRkk9CBVBvdGuIswVB7Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Faa0tinN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Faa0tinN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EF7C4CEE2;
	Wed, 23 Apr 2025 15:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421542;
	bh=DRp1oIIWetkesQhj+5xLltDuJi3UnY5kj2PuG3J5uU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Faa0tinNnwHPvUssw36cpPCoZQTlZjYGWkxVcRdaZQ9ft8gki7QNQ84feXwkCkD+c
	 Eu4jwhrrPueowGOltNr8CDnE+ModdIPIxj/T/Ijam30zuW//1bBfMWQBaToY0wwE4t
	 ZChGXu5zFZTcUKzEsQULOaiaHE+pjNPHPdB5umSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jane Chu <jane.chu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	"Kirill A. Shuemov" <kirill.shutemov@linux.intel.com>,
	linmiaohe <linmiaohe@huawei.com>,
	"Matthew Wilcow (Oracle)" <willy@infradead.org>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 190/393] mm: make page_mapped_in_vma() hugetlb walk aware
Date: Wed, 23 Apr 2025 16:41:26 +0200
Message-ID: <20250423142651.234737483@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jane Chu <jane.chu@oracle.com>

commit 442b1eca223b4860cc85ef970ae602d125aec5a4 upstream.

When a process consumes a UE in a page, the memory failure handler
attempts to collect information for a potential SIGBUS.  If the page is an
anonymous page, page_mapped_in_vma(page, vma) is invoked in order to

  1. retrieve the vaddr from the process' address space,

  2. verify that the vaddr is indeed mapped to the poisoned page,
     where 'page' is the precise small page with UE.

It's been observed that when injecting poison to a non-head subpage of an
anonymous hugetlb page, no SIGBUS shows up, while injecting to the head
page produces a SIGBUS.  The cause is that, though hugetlb_walk() returns
a valid pmd entry (on x86), but check_pte() detects mismatch between the
head page per the pmd and the input subpage.  Thus the vaddr is considered
not mapped to the subpage and the process is not collected for SIGBUS
purpose.  This is the calling stack:

      collect_procs_anon
        page_mapped_in_vma
          page_vma_mapped_walk
            hugetlb_walk
              huge_pte_lock
                check_pte

check_pte() header says that it
"check if [pvmw->pfn, @pvmw->pfn + @pvmw->nr_pages) is mapped at the @pvmw->pte"
but practically works only if pvmw->pfn is the head page pfn at pvmw->pte.
Hindsight acknowledging that some pvmw->pte could point to a hugepage of
some sort such that it makes sense to make check_pte() work for hugepage.

Link: https://lkml.kernel.org/r/20250224211445.2663312-1-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_vma_mapped.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -77,6 +77,7 @@ static bool map_pte(struct page_vma_mapp
  * mapped at the @pvmw->pte
  * @pvmw: page_vma_mapped_walk struct, includes a pair pte and pfn range
  * for checking
+ * @pte_nr: the number of small pages described by @pvmw->pte.
  *
  * page_vma_mapped_walk() found a place where pfn range is *potentially*
  * mapped. check_pte() has to validate this.
@@ -93,7 +94,7 @@ static bool map_pte(struct page_vma_mapp
  * Otherwise, return false.
  *
  */
-static bool check_pte(struct page_vma_mapped_walk *pvmw)
+static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
 {
 	unsigned long pfn;
 	pte_t ptent = ptep_get(pvmw->pte);
@@ -126,7 +127,11 @@ static bool check_pte(struct page_vma_ma
 		pfn = pte_pfn(ptent);
 	}
 
-	return (pfn - pvmw->pfn) < pvmw->nr_pages;
+	if ((pfn + pte_nr - 1) < pvmw->pfn)
+		return false;
+	if (pfn > (pvmw->pfn + pvmw->nr_pages - 1))
+		return false;
+	return true;
 }
 
 /* Returns true if the two ranges overlap.  Careful to not overflow. */
@@ -201,7 +206,7 @@ bool page_vma_mapped_walk(struct page_vm
 			return false;
 
 		pvmw->ptl = huge_pte_lock(hstate, mm, pvmw->pte);
-		if (!check_pte(pvmw))
+		if (!check_pte(pvmw, pages_per_huge_page(hstate)))
 			return not_found(pvmw);
 		return true;
 	}
@@ -283,7 +288,7 @@ restart:
 			goto next_pte;
 		}
 this_pte:
-		if (check_pte(pvmw))
+		if (check_pte(pvmw, 1))
 			return true;
 next_pte:
 		do {


