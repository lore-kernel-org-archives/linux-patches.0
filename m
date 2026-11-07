Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063161;
	b=ss9V44itpDEIPr/0l2/kX0nn+yUUEf0LR3rno9evafdZsZ9dS1yPKWxxj58QT3ve6i+Z
	 VNOc2CJ1wK1IaAjoUdHT87IHUvLLiIq/gn6NQG4glpUQHEYdwjTbdjYuOUVFmZYpUoWpR
	 3BOWP4oLa8J7KtPR/TjSaMfy4PzUBrISM9EiOY9U8WKyErU5pGESp1QK3XIPKCCQbKyql
	 LUjxEglSzZ4UPAMoG+GlCIL5KHOiU3PPJo6fK0joOtU3G9/qApdgAsttc5Z2RZ8zVs0Rx
	 dH7tCvLazU76xG9ZIOOzCrh5XsPfbF82YCreqqGhXj9Wet6QHbysgHOx1imAbJ1Dltw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JqjanQvx/jEAyBanwzBb5iv8/0t5HCkCi/p4NOWCZXM=;
	b=xR4aqewu0aThXi+2dkS8WrMhfMIiHSW0GavLss41PCZdMaJv3ikVlh1S8SEfDECWD0iw
	 HtUsxEw2JJ4uLjNOtgaJ6sonGH9wJ8BCXwyaqCZab0kUc7ZnDSatDv9maIZVlr3KYPejt
	 8bRQmBVtRomn4qoBE74cN2tmwP5QmMzKrZNk5V/HIDGrUZWM/UDHiUHGLiRiewcEcGztn
	 5mT4Prx8DawP+kwnFynfkdRO+I0rVC3eESoUBHUGvanmVIu5tZh6kXid8ewfMpM9WLRsA
	 PMXW0r2XFOX+KYZ3HzUR6KGLjAu1sAD5ighvlSgXPjmTJ46vhoi/gL2ZrL6E7Q36zjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t56toskc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDC8606A331;
	Sat,  7 Nov 2026 14:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t56toskc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B929B1F0089F;
	Sat,  7 Nov 2026 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063161;
	bh=JqjanQvx/jEAyBanwzBb5iv8/0t5HCkCi/p4NOWCZXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t56toskcaDR9MOBmosTxITbJl/Ssfru25iA62xa7uSZhNR2L5XK8xsFnPHT78+P00
	 077eBsRfU4uBSXnF9P+EFaRpe8XH+GGTYqzKN2IWzg0dUvUi7XqEhNjcWkPTyo08YF
	 MRl3uNx4N2AzhNTIEkgAKE+w26HJHovoF3mltOGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 383/869] mm/damon/vaddr: respect folio end for DAMOS_STAT
Date: Sat,  7 Nov 2026 08:51:05 -0500
Message-ID: <20261107134906.241573405@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 946351a5fc5d4e3afec2bdf735935d17d6c9ceb2 ]

For applying DAMOS_STAT action to a region, DAMON virtual address space
operation set (vaddr) calls walk_page_range[_vma]() for the region.  The
pmd walk entry function, namely damon_va_stat_pmd_entry(), applies DAMOS
filters to folios of addresses of the region in the pmd.  It starts from
the walking address and advances the address by the size of the folio of
the address until it goes out of the pmd or the region.

Let's suppose it is for the first pmd of the region, and the region start
address is in the middle of a large folio.  Also, the next folios are
small.  Then, some of the next folios could be skipped.  Fix the issue by
advancing the address to exactly the start address of the next folio.

The user impact is that the DAMOS_STAT-based page level monitoring results
become inaccurate.  Since the page level monitoring is supposed to provide
relatively high precision, this is definitely a problem.  It is arguably
not critical since it is only monitoring quality degradation.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-5-sj@kernel.org
Link: https://lore.kernel.org/20260514015053.149396-1-sj@kernel.org [1]
Fixes: 63f39737d1e3 ("mm/damon/vaddr: support stat-purpose DAMOS filters")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/vaddr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index cfa7849041ad9..7d4d7565e8ee3 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -925,6 +925,8 @@ static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
 		return 0;
 
 	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		unsigned long page_idx;
+
 		nr = 1;
 		ptent = ptep_get(pte);
 
@@ -938,7 +940,8 @@ static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
 
 		if (!damos_va_filter_out(s, folio, vma, addr, pte, NULL))
 			*sz_filter_passed += folio_size(folio);
-		nr = folio_nr_pages(folio);
+		page_idx = folio_page_idx(folio, pte_page(ptent));
+		nr = folio_nr_pages(folio) - page_idx;
 		s->last_applied = folio;
 	}
 	pte_unmap_unlock(start_pte, ptl);
-- 
2.53.0



