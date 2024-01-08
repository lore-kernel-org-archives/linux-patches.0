Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9272F6D6E4;
	Mon,  8 Jan 2024 15:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kO45VY8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE98C433C8;
	Mon,  8 Jan 2024 15:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726886;
	bh=orBrWnFWKBH6exYez9qDH8gLxjum2IUVYCFvoiPL9uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kO45VY8R+vf3eeQs5LgYT2/DGXx2beWktYRWLQyFpNs/zA1mPsQ2dN062xAALKxP7
	 80peXt3xCiRyqMYsWZA15+P0Vang/42n82LtA2GWoITw6Vjf2WxPDEwkV26Y1ZcNtA
	 StCrplKUT/FVfPp6XRaYgqsOqkg21B8oEijspmbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhao <yuzhao@google.com>,
	syzbot+03fd9b3f71641f0ebf2d@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 109/124] mm/mglru: skip special VMAs in lru_gen_look_around()
Date: Mon,  8 Jan 2024 16:08:55 +0100
Message-ID: <20240108150607.977597911@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Yu Zhao <yuzhao@google.com>

commit c28ac3c7eb945fee6e20f47d576af68fdff1392a upstream.

Special VMAs like VM_PFNMAP can contain anon pages from COW.  There isn't
much profit in doing lookaround on them.  Besides, they can trigger the
pte_special() warning in get_pte_pfn().

Skip them in lru_gen_look_around().

Link: https://lkml.kernel.org/r/20231223045647.1566043-1-yuzhao@google.com
Fixes: 018ee47f1489 ("mm: multi-gen LRU: exploit locality in rmap")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: syzbot+03fd9b3f71641f0ebf2d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/000000000000f9ff00060d14c256@google.com/
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4656,6 +4656,7 @@ void lru_gen_look_around(struct page_vma
 	int young = 0;
 	pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
+	struct vm_area_struct *vma = pvmw->vma;
 	struct folio *folio = pfn_folio(pvmw->pfn);
 	bool can_swap = !folio_is_file_lru(folio);
 	struct mem_cgroup *memcg = folio_memcg(folio);
@@ -4670,11 +4671,15 @@ void lru_gen_look_around(struct page_vma
 	if (spin_is_contended(pvmw->ptl))
 		return;
 
+	/* exclude special VMAs containing anon pages from COW */
+	if (vma->vm_flags & VM_SPECIAL)
+		return;
+
 	/* avoid taking the LRU lock under the PTL when possible */
 	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
 
-	start = max(addr & PMD_MASK, pvmw->vma->vm_start);
-	end = min(addr | ~PMD_MASK, pvmw->vma->vm_end - 1) + 1;
+	start = max(addr & PMD_MASK, vma->vm_start);
+	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
 
 	if (end - start > MIN_LRU_BATCH * PAGE_SIZE) {
 		if (addr - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
@@ -4699,7 +4704,7 @@ void lru_gen_look_around(struct page_vma
 		unsigned long pfn;
 		pte_t ptent = ptep_get(pte + i);
 
-		pfn = get_pte_pfn(ptent, pvmw->vma, addr);
+		pfn = get_pte_pfn(ptent, vma, addr);
 		if (pfn == -1)
 			continue;
 
@@ -4710,7 +4715,7 @@ void lru_gen_look_around(struct page_vma
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young(pvmw->vma, addr, pte + i))
+		if (!ptep_test_and_clear_young(vma, addr, pte + i))
 			VM_WARN_ON_ONCE(true);
 
 		young++;


