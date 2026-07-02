Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DF33385A7;
	Thu,  2 Jul 2026 16:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009941; cv=none; b=VbEMOYYYrp8X6ojnD/zZULyDTjhRz1eMUEWtMCFDZcqtxdgyt8mFZYGriSQVLmePtAVVsLxs0Uacj6+Og3aEgRzuYmHmvdHiTgVcg0RAwZICFMH+YjBRFURJyXpb1Pr3CkY1QICuSSS5k/9kC3QJxh2gmCbvgYTTg79xmY67vMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009941; c=relaxed/simple;
	bh=bqQ/TLV7qDXbqJELw1eAIbjlyjla+ML5r/9NUO+uKjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXuT2EQJk2wmHWN8nAQuVdKLzBT7BlHSYG80iKpVZGiM+wQUJxZE/AFR1SC92CFEZvkv+AktaESwTuFRbGrqBWqUGsyqC8t/j3E8Q7tNu8XqAvsZFjz4OWC+8ehli0/wKj7XTICzFYT2lxaPILIHa+zhp8IHzheCrd6bYxlDPlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zl03/L7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zl03/L7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD451F00A3A;
	Thu,  2 Jul 2026 16:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009940;
	bh=DJpjH9SoXbhdA906vf975aRz4iZAVBiJs0zVvsspfAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zl03/L7R8ltdiF8R9YHRpP5xASY4L86PSpIaULO2zmypvDO8MncwdYjiyVbJ937pU
	 /Vh4puLR0bsV6UmgtUIKNEenslPoESD2uDTS2ufBd/6P+rCd7BOgJ9Z/AYScAV30et
	 QN+kh209XBPGhWhv6eP05K0XelCJHUqlUjGOaC4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhao <yuzhao@google.com>,
	syzbot+03fd9b3f71641f0ebf2d@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Jakov Novak <jakovnovak30@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/129] mm/mglru: skip special VMAs in lru_gen_look_around()
Date: Thu,  2 Jul 2026 18:19:28 +0200
Message-ID: <20260702155113.165543024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

From: Yu Zhao <yuzhao@google.com>

[ Upstream commit c28ac3c7eb945fee6e20f47d576af68fdff1392a ]

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
[fix conflicts with variable declarations and vma pointer usage]
Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1f7a90ecc7007d..f6f8c18dc45f57 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4622,6 +4622,7 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	struct lru_gen_mm_walk *walk;
 	int young = 0;
 	unsigned long bitmap[BITS_TO_LONGS(MIN_LRU_BATCH)] = {};
+	struct vm_area_struct *vma = pvmw->vma;
 	struct folio *folio = pfn_folio(pvmw->pfn);
 	struct mem_cgroup *memcg = folio_memcg(folio);
 	struct pglist_data *pgdat = folio_pgdat(folio);
@@ -4635,11 +4636,15 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	if (spin_is_contended(pvmw->ptl))
 		return;
 
+	/* exclude special VMAs containing anon pages from COW */
+	if (vma->vm_flags & VM_SPECIAL)
+		return;
+
 	/* avoid taking the LRU lock under the PTL when possible */
 	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
 
-	start = max(pvmw->address & PMD_MASK, pvmw->vma->vm_start);
-	end = min(pvmw->address | ~PMD_MASK, pvmw->vma->vm_end - 1) + 1;
+	start = max(pvmw->address & PMD_MASK, vma->vm_start);
+	end = min(pvmw->address | ~PMD_MASK, vma->vm_end - 1) + 1;
 
 	if (end - start > MIN_LRU_BATCH * PAGE_SIZE) {
 		if (pvmw->address - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
@@ -4660,7 +4665,7 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	for (i = 0, addr = start; addr != end; i++, addr += PAGE_SIZE) {
 		unsigned long pfn;
 
-		pfn = get_pte_pfn(pte[i], pvmw->vma, addr);
+		pfn = get_pte_pfn(pte[i], vma, addr);
 		if (pfn == -1)
 			continue;
 
@@ -4671,7 +4676,7 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young(pvmw->vma, addr, pte + i))
+		if (!ptep_test_and_clear_young(vma, addr, pte + i))
 			VM_WARN_ON_ONCE(true);
 
 		young++;
-- 
2.53.0



