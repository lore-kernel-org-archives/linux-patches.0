Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3474C30C160;
	Fri,  4 Sep 2026 05:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498418; cv=none; b=TiAO9a6bv8r5j3oVAC0WY3/U3JeIO1sduTyM9hxssGgUhQJCkG+6RJB+Urf1GR8XqZWK9Wl/4gyZQ8rkGViaD4TAmZcCh3CtNScv6b3xGOpnZaGXlYTlX5QV0MFmYMeq6Z99gPjztGlAx4JpdHrbob45CBAzxZlHRF+3LwYwi3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498418; c=relaxed/simple;
	bh=H/pJzNh20eU50MppEHtwHfiqApArqs4MfvxT0LJ/Y7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJLG5eDVv81/nGGJBqJQP4R0uFxjZ+snKX75nadu8DpH5unANUe15rHwjXB1ztwtOoPqUaoZbO4WoH9X8ikYoAC+f47zKh1hC9s7gsa3zFiOI80bIixxUa6rHVeKzsrB+TBVbGiS7NovLZOLk6HXYEuzjnq7Y8KpPC/MbGzAVNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdweMh18; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdweMh18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C031F00A3E;
	Fri,  4 Sep 2026 05:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498417;
	bh=O06gei7IOLMjB/OKAA16k0u/CJNoLC25r+wPlGQkAVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wdweMh187suW8ydbrofXmsETRmxMXCHmoRBlPl9jsyyAqkKsdxXfY66SU0Ws7dF7z
	 3259MFlRAiRv7A2NSC9VUDyr86ftR+9Dhu5IwyUB6I3f0iU1ThrK71+tWumLWn8JbM
	 K2h+dMcuNd3e7howIkhjPKoMj7f2GKpTM1OfDVG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usama.arif@linux.dev>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Byungchul Park <byungchul@sk.com>,
	Dev Jain <dev.jain@arm.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Nico Pache <npache@redhat.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 055/713] mm/mempolicy: skip non-present PMDs when queueing folios
Date: Fri,  4 Sep 2026 06:50:23 +0200
Message-ID: <20260904045805.068965292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Usama Arif <usama.arif@linux.dev>

commit 2858b4027f491e6fdb8ee2d8923798b619bf2791 upstream.

Patch series "mm: handle device-private PMDs in walk callbacks", v3.

Since commit 368076f52ebe ("mm/huge_memory: add device-private THP support
to PMD operations") a PMD may hold a device-private swap entry whenever an
HMM-based GPU driver migrates an anonymous THP folio to device memory via
migrate_vma_pages().

pmd_trans_huge_lock() succeeds for such PMDs (pmd_is_huge() returns true
for any non-present, non-none huge PMD), so several MM walk callbacks that
used to assume present THP or migration entry are now reachable with a
device-private PMD.  The results range from a VM_BUG_ON() firing on debug
kernels, to an oops on a bogus vmemmap dereference, to silently isolating
an unrelated live folio from LRU in the aliasing case.


This patch (of 3):

queue_folios_pmd() is called under pmd_trans_huge_lock(), whose
pmd_is_huge() check returns true for any non-present, non-none PMD
softleaf.  Passing such a PMD to pmd_folio() treats the softleaf encoding
as a hardware PFN and can return a bogus folio pointer.

Mirror queue_folios_pte_range(): handle non-present entries before looking
up a folio.  Keep migration entries counted as failures, but skip other
non-present PMDs such as device-private entries.

Potential trigger: an HMM-based GPU driver migrates an anonymous THP folio
to device memory via migrate_vma_pages(), leaving a device-private PMD.
Userspace then calls mbind(), migrate_pages() or set_mempolicy_home_node()
on that range.

Link: https://lore.kernel.org/20260710105557.1987433-1-usama.arif@linux.dev
Link: https://lore.kernel.org/20260710105557.1987433-2-usama.arif@linux.dev
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -653,12 +653,14 @@ static void queue_folios_pmd(pmd_t *pmd,
 {
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
+	pmd_t pmdval = pmdp_get(pmd);
 
-	if (unlikely(pmd_is_migration_entry(*pmd))) {
-		qp->nr_failed++;
+	if (unlikely(!pmd_present(pmdval))) {
+		if (pmd_is_migration_entry(pmdval))
+			qp->nr_failed++;
 		return;
 	}
-	folio = pmd_folio(*pmd);
+	folio = pmd_folio(pmdval);
 	if (is_huge_zero_folio(folio)) {
 		walk->action = ACTION_CONTINUE;
 		return;


