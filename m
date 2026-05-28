Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8B9409DE0;
	Thu, 28 May 2026 19:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998050; cv=none; b=kbTJbsRPUPT49UDlRAUlFw93Fy2hr/TgoMs+WbaMOwoIlVu6Dz6avcx34hIAVzLagyeVRW8NGihZyPPxu168P5d6GcyuU66a4VWeEyorKcCwcAila0the00vl++Po3jYozhhPGi9pow9sSEKsJ7iGudZpGwyrmKsgJyHEmabOoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998050; c=relaxed/simple;
	bh=TJBYtCBK8Tx5Mumv7vXzqWvO/bRwv3sYY7rbAN/FZRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NauT1ExajuPesWo5ABI9WT09QDeZB2JOCr6Rq3zdX8IfzhjC2wYwlQO0WFws7PAgke4MwvP4e+r4j3zjnZZlz+cAaVo25bvVuWj3aTMDM9OE1ZjYYA7FCxqV1yN1iJkfNPHgLHvlQFn0RizTr89t6qZH8e4ch7tDF+3QlsKlRxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTRnnEU/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTRnnEU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841741F00A3A;
	Thu, 28 May 2026 19:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998049;
	bh=75hrHeJGhdskIk1BP1nKaEPcRAuYmofK6lB8sFG4JtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RTRnnEU/w/G2fmlDO72zsenHyYSopVsXjBI2csw395lWcKBd0rZM5PjzlN4iiRU4Q
	 V0X+DGmCl+SxLE99NTe5Mo6zskvPMC1kdEjGunMUaOOedbL/mRYRCkzLvlSK/+//sJ
	 RYYJUY/yBLaGryLv1YswJNKqxSrhw0C9/SKzt/CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Bibo Mao <maobibo@loongson.cn>,
	Lance Yang <lance.yang@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 034/461] mm: fix __vm_normal_page() to handle missing support for pmd_special()/pud_special()
Date: Thu, 28 May 2026 21:42:43 +0200
Message-ID: <20260528194647.883513551@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

commit c0c6ccd9828c3a1950623b546fa57292a77b5c73 upstream.

On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
"WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed by
"BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s when
reclaim gets to call shrink_huge_zero_folio_scan().

It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd: and
indeed, whereas pte_special() and pte_mkspecial() are subject to a
dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled on
any 32-bit architecture.

While the problem was exposed through commit d80a9cb1a64a
("mm/huge_memory: add and use normal_or_softleaf_folio_pmd()"), it was an
oversight in commit af38538801c6 ("mm/memory: factor out common code from
vm_normal_page_*()") and would result in other problems:
* huge zero folio accounted in smaps, pagemap (PAGE_IS_FILE) and
  numamaps as file-backed THP
* folio_walk_start() returning the folio even without FW_ZEROPAGE set.
  Callers seem to tolerate that, though.

... and triggering the VM_WARN_ON_ONE(), although never reported so far.

To fix it, teach vm_normal_page_pmd()/vm_normal_page_pud() to consider
whether pmd_special/pud_special is actually implemented.

Link: https://lore.kernel.org/20260430-pmd_special-v1-1-dbcbcfd72c20@kernel.org
Fixes: af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reported-by: Hugh Dickins <hughd@google.com>
Closes: https://lore.kernel.org/r/74a75b59-2e13-3985-ee99-d5521f39df2a@google.com
Reported-by: Bibo Mao <maobibo@loongson.cn>
Closes: https://lore.kernel.org/r/20260430041121.2839350-1-maobibo@loongson.cn
Debugged-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Bibo Mao <maobibo@loongson.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -625,6 +625,21 @@ static void print_bad_page_map(struct vm
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
+
+static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
+{
+	switch (level) {
+	case PGTABLE_LEVEL_PTE:
+		return IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL);
+	case PGTABLE_LEVEL_PMD:
+		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP);
+	case PGTABLE_LEVEL_PUD:
+		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP);
+	default:
+		return false;
+	}
+}
+
 #define print_bad_pte(vma, addr, pte, page) \
 	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
 
@@ -697,7 +712,7 @@ static inline struct page *__vm_normal_p
 		unsigned long addr, unsigned long pfn, bool special,
 		unsigned long long entry, enum pgtable_level level)
 {
-	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
+	if (pgtable_level_has_pxx_special(level)) {
 		if (unlikely(special)) {
 #ifdef CONFIG_FIND_NORMAL_PAGE
 			if (vma->vm_ops && vma->vm_ops->find_normal_page)
@@ -712,8 +727,9 @@ static inline struct page *__vm_normal_p
 			return NULL;
 		}
 		/*
-		 * With CONFIG_ARCH_HAS_PTE_SPECIAL, any special page table
-		 * mappings (incl. shared zero folios) are marked accordingly.
+		 * With working pte_special()/pmd_special()..., any special page
+		 * table mappings (incl. shared zero folios) are marked
+		 * accordingly.
 		 */
 	} else {
 		if (unlikely(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))) {


