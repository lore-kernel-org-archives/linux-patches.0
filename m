Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047076;
	b=GWVo9Ol/QYt0j5cvaaxfN6lowG5rmyMym4TKnw2TIPsTqZcSndzsL8MavQsAbVrZpoJp
	 7wic4yoxEspzFOlxhhOEIt2vcnwa0byIoPdZtqrbXSILTw/Y6PWAP9r2kt0o6IQmb16YS
	 j3amopSF31xBr7X+pXxgs95nVdoaH9sOhAysOZFFVCS9N+QamEtmwec1cIjl2DwKLHCrr
	 jzy1xj4qvbwlSyfDfBGW+bI/3uNZYJFtKwGbuKg3ID3odjZjyMdTwmU1FcONJu9qjBlet
	 xJ5JMFY65dkVfNESl98l9svPo/iUxJBV8SkALeR5xCJ6NMgC60f2r4nnhqa0+27dqpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tvNS3CilQrzvJiETUcCAdHzZXMA6ZMNwjSCK4BMr6F4=;
	b=4fYhzFNiiDtA7Bj3sfEq8sbauhc7AdEWch70DT4G7srZUphshRnFXg7J60wKAmbRJBf+
	 AtaTyVxZ6Hvk3sKsBka4aYBzn+03DkZKH1BgETl/RptOesZV+JQKFAT/qEhGoRWFmamca
	 WSSuSkEjNnzO2BTZPIoOZOSEMcG9ev0HykncxSudC62ajOQ7DK12BPuILKPfsH2ab/zYV
	 LRShdNBTi84eeElKjkp9vhhTC2TsOSAEl/Bk59USYWc1NFQk6//EpqfsulTB0KyupyZyI
	 9ayFl0Rrxy2F8KLDgluwRTAXBVhaCymgtKyT9iuGU8BFax3MrkGjAUBBaFFPwYjjAKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RqtnJo15;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4F2606A320;
	Thu, 19 Nov 2026 00:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RqtnJo15
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607DF1F000C4;
	Thu, 19 Nov 2026 00:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047075;
	bh=tvNS3CilQrzvJiETUcCAdHzZXMA6ZMNwjSCK4BMr6F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RqtnJo15K6sV74Evy5k9dl3zWQfr0Bdekdopur6xAzEg2XNyyXq0Homd1fJMTq8IH
	 +xZiHGPK+zmvzuE6QqT71/rgeQ7ctchOxL41w6KJ4Zb5qMyCP12K7Cc5lppRlb/fuO
	 Nb8nEGk6rlJM+b4sB77ngCYlLpODOu4fuKZIF+B4=
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
Subject: [PATCH 6.1 1469/2857] mm/memory: constrain generic_access_phys() to page boundary
Date: Wed, 18 Nov 2026 15:41:43 +0100
Message-ID: <20261118150254.201457944@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted to the existing follow_pte() implementation, where the args.pfn cast change is inapplicable ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 2fafde251077c..9f965c12ea0c5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5653,6 +5653,12 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
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
@@ -5678,7 +5684,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	if ((write & FOLL_WRITE) && !pte_write(pte))
 		return -EINVAL;
 
-	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
+	maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);
 	if (!maddr)
 		return -ENOMEM;
 
-- 
2.53.0



