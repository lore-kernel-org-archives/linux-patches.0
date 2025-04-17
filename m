Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636271B4153;
	Thu, 17 Apr 2025 18:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915986; cv=none; b=WRCxFIVWFtGhmEkRv3CMQbxjZqMepwdHffjcEI7sNKM2/N1kePykA4Viwi+VwoZWDR0z1H/aHCZ+kFIAc4IQEjXHR2Vme392kze6XMqk+9FwRnDlzsG4gXv1TNgWtEmOh9gyDy4Icykb2NnxWwIoaDOPJULDnGmYNnoCN9YapDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915986; c=relaxed/simple;
	bh=cVqa1CqS8089dEgr+GelBcvOlqoT6Q5kR6ZKP7DiFYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGVqoRC+zBhudNLlR5zRqpcQ+MStZuAIeIRtyRuoNjJf6yysfiZr5ru8cFgJ24yRa2vcvKHvnJ9xLVsvzAFxMdeTr60xON5tRBN5XciOXHYlwlLSHqEnTEmqcQ1Z1Az2rNIlxmLQ3N1Mx4t09h/Dx3sajHh7JT9GjS6geNmW+i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wa5JJ5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wa5JJ5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA85CC4CEE4;
	Thu, 17 Apr 2025 18:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915986;
	bh=cVqa1CqS8089dEgr+GelBcvOlqoT6Q5kR6ZKP7DiFYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0wa5JJ5bDJtycOVyPpua83Mgo2li1K5GKhdoGtmu21BsQYfm8JciSZvh/VRWnm+17
	 BnDo48N4O+9xPKdG9PrKHd9WVs/oQ4xGhcJd6SqGIoIj4yEl5VywsmUnOkkL7dLvpZ
	 8YJfP16xqfvild3HWO/BBxjrhg82UZyfPMiNq2jo=
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
Subject: [PATCH 6.12 305/393] mm: make page_mapped_in_vma() hugetlb walk aware
Date: Thu, 17 Apr 2025 19:51:54 +0200
Message-ID: <20250417175119.878095843@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -284,7 +289,7 @@ restart:
 			goto next_pte;
 		}
 this_pte:
-		if (check_pte(pvmw))
+		if (check_pte(pvmw, 1))
 			return true;
 next_pte:
 		do {


