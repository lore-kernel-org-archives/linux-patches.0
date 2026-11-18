Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038384;
	b=0xzc3f28yuFW5SajBrfdOk8cbPHR564vq/xbz1lLX+/45Vvwwfeg8aX+jeL8ZScVcnX6
	 vxd16YxcjaA8VxnW0Anwxfdf1UE7mEPZ+ZMTZXTodIL8ypISY0vgVJJGJM5E6B28QVAYI
	 xBpO+7FI/tnQ2tgzcUWXpacdzb/qxxwtlu93cJTZcDeR5Kuz7fsodq7xp22ayI968T0mb
	 0kdwW+GG5FlJ9rsj6d357B+lbEfGqdAVosi8QOIrptwz4ikv8hFZXtfkhckxY6nq+1PCx
	 gDtIFJQWu7NEQYyytotwc3XI8lHKnN1wYBkHGoLCGOmXeRwBwTJY+5G6e9ps2JCehUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y3YKe/XxZpMFfy96IA6cAy57EoqanwmTCpuDiBIaU0E=;
	b=tPy4rDPQ+aNaxi7relgiwTaElW4PJjDlUWCjGGmwtGwYdb3mtQx9oAm6O89nl7hOj3/E
	 jjCaYN4J0apwTCOQBJxBKtijnHkGCtFjAg6VVf0xIAlV8+n3yQJ2vWyMsEEHzJPjRW7Zh
	 PdTby13gIn1VOTRBB6ghR2zd2cyRrb+3SSii4U+nL0VhO8C6lZPHtkUNA506vbDobjr+T
	 5aromyG2/1VVv9/Ajp8Lv13AtNW5Moe4hWy5TN+n6afEDUhyJ6nFJOAihPpTI8Kzs5Pcv
	 DGvtn5XZ7nwZpmSZYaGEIFxz8dR4FL6ZOnW5WD7G5TVqXeMungQS0EySgx/om8tJf7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XP4pSd2+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D831606A325;
	Wed, 18 Nov 2026 21:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XP4pSd2+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788521F000C5;
	Wed, 18 Nov 2026 21:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038384;
	bh=y3YKe/XxZpMFfy96IA6cAy57EoqanwmTCpuDiBIaU0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XP4pSd2+BZ3Kpu2NXZWB1aimfAUAedXnq5P17bwjxWErtvlFTwV3bJ3Ln/CWc6hEk
	 buWQXtr1CBPILPhyhvK9aIWR5dDPKo33VARqokqtBT83gy+yN/S0iEO+f3nwvkMmkh
	 8GXUNqXRyPm9NL3wor7drJJCfCWz0ufOU5DZOeO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vega <vega@nebusec.ai>,
	David Hildenbrand <david@kernel.org>,
	Grazvydas Ignotas <notasas@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1724/3318] mm/memory: constrain generic_access_phys() to page boundary
Date: Wed, 18 Nov 2026 15:39:06 +0100
Message-ID: <20261118150413.584834473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luxiao Xu <rakukuip@gmail.com>

[ Upstream commit ae0298a5fbeff32951c0d31398ccec97ec6aa0ea ]

This patch addresses an issue in generic_access_phys() where accessing
memory across page boundaries in PFNMAP VMAs assumes physical pages are
contiguous, which can lead to accessing unintended physical memory or
exceeding VMA boundaries.

generic_access_phys() improperly validates the memory access range: it
only validates the start address using follow_pfnmap_start() and passes
PAGE_ALIGN(len + offset) to ioremap_prot().

This poses two problems:
1. In PFNMAP VMAs, consecutive virtual pages are not guaranteed to be
   physically contiguous, and individual PTEs may have different access
   permissions or writability.
2. The mapping may cross VMA boundaries if len extends beyond vma->vm_end.

Constrain the access in generic_access_phys() to at most the current page
boundary (PAGE_SIZE - offset) and map only a single PAGE_SIZE via
ioremap_prot().  Since the caller __access_remote_vm() already loops over
the requested length and handles partial transfers, it will naturally
iterate over the remaining pages.

Also add a missing (resource_size_t) cast during PFN re-validation to
avoid truncation on 32-bit PAE systems.

Link: https://lore.kernel.org/e06e28a46c2a176238f03b5740df0913e57c2861.1788842306.git.rakukuip@gmail.com
Fixes: 9cb12d7b4cca ("mm/memory.c: actually remap enough memory")
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Grazvydas Ignotas <notasas@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: Adapted to the existing follow_pte() lookup and pte_same() revalidation instead of follow_pfnmap_start() and individual mapping checks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 8376b7c768831..853400f26159b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5766,6 +5766,12 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		return -EINVAL;
 
+	/*
+	 * Limit access to one page at a time, as that's what follow_pte()
+	 * guarantees; expect the caller to retry to read larger ranges.
+	 */
+	len = min_t(int, len, PAGE_SIZE - offset);
+
 retry:
 	if (follow_pte(vma->vm_mm, addr, &ptep, &ptl))
 		return -EINVAL;
@@ -5791,7 +5797,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	if ((write & FOLL_WRITE) && !pte_write(pte))
 		return -EINVAL;
 
-	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
+	maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);
 	if (!maddr)
 		return -ENOMEM;
 
-- 
2.53.0



