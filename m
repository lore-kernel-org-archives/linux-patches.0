Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062580;
	b=u6XK2wPd4AsHIdAv2LRtzPM0MX3Fm8XBqGax765Dw4DHD59deqXhLWDNG+/r5pH1GdNm
	 h+JLZLa0xQAI1tyVmsh3S8I1NvQsUe6aL0AIJKpHWnx7YDtbXjR6I0E52Yd0z8rWiKT+j
	 +ZdqPqnNAh+lhy5aE92Mw2u91rntxF8fRHEfdVLHNodxMCTKN6aqr7wH2de5ExvV88c50
	 vvDeLyWr8TMYJRTlbb26yOx2pri4nXKH5R9sWRvC9avs0Z5lx7CsdAoAOpICt4GLelnPc
	 e8qr6syyIxFuJB0K31w4723RLfppSujxPzHGh43J6YEjRUYlDGDGhAZTsgJGRyTWyNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JiT+25BzF8lErBGfDBwLaqBZb4ufxjux7fN+h4OQjTM=;
	b=F27X8BHE8OaEE4RGamwXqU9I027xENqeCDTfqXrjovlgrzIMZeyQk/ZJa9o5wG2YXNzV
	 CLyWxYcbUm3bltHbyQKNJBrqxn+iBcLwqw+okkbEn6UE0RSmTOYFkG0sw8z3lUEEY97ew
	 N9MCw+aXpkjnYcupa1txdseMrz+ZZ7EGP4rOMU7zM3krAlXOT2pXRroWdfnqsKQGgQgEj
	 oXvGY1Av8HJMBRa4JxkyKmhoXiMVq7EhWGgyMVt+iUeTY5FRqTnLADbS1zm5oypXCI8hK
	 JoeXusfFAtl0tS3i3pS4S9uA5fKwsKaaMJNNyJg2dviIDwLyvTY3fD+SNFvjgeolNXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfsaC21U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE064606A66B;
	Sat,  7 Nov 2026 14:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfsaC21U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388E31F0089F;
	Sat,  7 Nov 2026 14:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062579;
	bh=JiT+25BzF8lErBGfDBwLaqBZb4ufxjux7fN+h4OQjTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TfsaC21U7wIZC2AlqvnXLu6PUcZ44i/E5y/0sU0T4L2Nwp8qy67M92GdvxxKZQqj0
	 l6E/NV6Xlwcq9hVOG3NhX6eJzJrpiOUADcu/Nfi4wmMniHvDMGHspcLoXvAwmbc8g2
	 QxtRjJDtB97lWIPiKJr0ZVSMwnfdHT12e8mxKRL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samarth Narang <samarth.colleges@gmail.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1443/1536] mm/madvise: atomically clear the young bit on THP MADV_COLD
Date: Sat,  7 Nov 2026 08:57:39 -0500
Message-ID: <20261107135038.365679494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Falcato <pfalcato@suse.de>

[ Upstream commit 246c8cc33438a71c28f9b86baa492d9a0a130316 ]

As-is, madvise_cold_or_pageout_pte_range() discards the hardware young bit
by invalidating the PMD, doing pmd_mkold() and subsequently writing to the
pmd again.  However, it does so in a racy manner, looking at a
possibly-stale snapshot.  It's entirely possible that a write elsewhere
set the hardware D bit, which this logic now loses.

Fix it by using pmdp_test_and_clear_young().  This is an atomic
modification of the PMD entry, and thus safe against any possible racing
writes.  As a (nice) side-effect, this elides one non-required TLB flush
in pmdp_invalidate().

This bug can interact with the swapping system in complicated ways,
leading to data loss.  For instance, if a folio is marked lazyfree, but
was later read from, and then MADV_COLD'd while racing a write to that
same THP, dropping the dirty bit may lead to data loss as
reclaim/MADV_PAGEOUT drops the "clean" anon folio:

T0                                T1
================================================================
MADV_FREE(thp)			|
  folio marked lazyfree		|
read(thp)			|
  PMD marked young by hardware	|
				| MADV_COLD(thp)
write(thp)			|   if (pmd_young(pmd)) {
  PMD marked dirty by hardware	|     set(pmdp, pmd_mkold(pmd));
MADV_PAGEOUT/reclaim		|
  dirty bit may or may not be   |
  set				|
    reclaim/pageout may drop    |
    the folio			|

Link: https://lore.kernel.org/20261013191719.95502-1-pfalcato@suse.de
Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Samarth Narang <samarth.colleges@gmail.com>
Closes: https://lore.kernel.org/linux-mm/20261011132227.413217-1-samarth.colleges@gmail.com/
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index e1470b35d43ae..ea966d402f073 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -408,10 +408,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		}
 
 		if (!pageout && pmd_young(orig_pmd)) {
-			pmdp_invalidate(vma, addr, pmd);
-			orig_pmd = pmd_mkold(orig_pmd);
-
-			set_pmd_at(mm, addr, pmd, orig_pmd);
+			pmdp_test_and_clear_young(vma, addr, pmd);
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-- 
2.53.0



