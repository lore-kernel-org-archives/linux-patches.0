Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065337;
	b=Jx7x+cprxFHVXq9YZae9rHBKUAFW46EnCHfLLDyW0MoIHXraFzriuiwxY5Eb87qw32v3
	 ofzaGvX25bWWhTVE0mK/MylFA6/59irAh4WV7M3wOkKS7JCZgn659+Nl+De1EpjbpuWU/
	 LJ+lWoEUaO62khxIbi6myOmIJipSONnjt/cJvHp9/e99et4se3N9UTVoOOryl+s+xk5Jw
	 tLCZZu/NNlmNpKTcCf9ZcbWHmqc2n8C2J2T7S2xgEin/mSG8LrKOPtNghwxCKJCjAwmo2
	 2XCCiCZdrOvtvuDYKJgw1bzuBnCb6/5FVyFunNZIUveJ6FzNzMRCgKVHbvCamlUa6Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4cI/2tdadDPxnaZ7KLd4NSWnuTQ5Bk0Ak9gHzQ7TVLU=;
	b=nCeld8WB4/trmx9OY4xVmqgzg7/VtGFEGVyCYn0QYG2KhtM0fCrSu8alKYT+n5lCXrsW
	 AC/++hTH1Zs3dd49WBdtrTcsP1cOs1ZK99NDMPJFRxxjV/90ZdN3idEv62akpeotmbJ88
	 OvxndKa7jUZx9qw+4qczRf/Yb/qBmcIOkjHuMaqgPGGHthpAA19EljORT986bflO4pRhQ
	 WLYcA+TIojAEfsve052TBKpbJbJsjOkiNMfHlQCefXsFnQNVUYDLvVHq57lw1xm7eC1UL
	 NTtxDd75txG2Fs8hyBFfGtKRSGQ//LaXXaSPzp6KDzx3Qntp/zdow843q+EUXjHDvnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pr9iiurr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC723606A326;
	Sat,  7 Nov 2026 15:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pr9iiurr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221221F0089F;
	Sat,  7 Nov 2026 15:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065336;
	bh=4cI/2tdadDPxnaZ7KLd4NSWnuTQ5Bk0Ak9gHzQ7TVLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pr9iiurrmXy8fRd2elzEz/XWGGvK2/tyJUmBzkHTCtRkMUItj0uue5Z90RvUNDssW
	 85EKSgJQsfisv3dHOhfj2v0joMMMl+59dHijcYfIysm3qH2eKlbvepE1fxjEQPXuKi
	 54NUDY6UsbMGSAjvawW8AqQN8wfzhxxP001wl8Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Down <chris@chrisdown.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1075/1257] mm/hugetlb: account migration target folio in per-node NR_HUGETLB vmstat
Date: Sat,  7 Nov 2026 08:56:11 -0500
Message-ID: <20261107135008.956763232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongfu Li <lihongfu@kylinos.cn>

[ Upstream commit 92635a3ffe8bb48304f50625dd591a27d7505698 ]

Patch series "mm: fix hugetlb NR_HUGETLB accounting on folio migration", v2.

The hugeTLB counters added by 05d4532b60e3 ("memcg/hugetlb: add hugeTLB
counters to memcg") are maintained in two per-node places:
  - the per-node vmstat counter NR_HUGETLB, exposed as nr_hugetlb in
    /proc/vmstat;
  - the per-node memcg lruvec stat, exposed via memory.numa_stat.

Both are accounted against the folio's node, and both drift when a hugetlb
folio is migrated, though in different ways.

A migration target folio is allocated by alloc_hugetlb_folio_nodemask()
and inherits the old folio's state without ever being accounted, while the
old folio is freed right after and its free is accounted.  That alone
loses vmstat accounting: the target node has no matching increment for the
decrement on the old node, so /proc/vmstat's nr_hugetlb shrinks by
nr_pages per migration.  Patch 1 accounts the folio where it is obtained,
so the increment pairs with the free in free_huge_folio() on the
successful as well as the failed migration path.  The memfd page cache
preallocation helper has the same asymmetry and is fixed in the same
patch.

The per-node lruvec stat breaks differently.  mem_cgroup_migrate() moves
the charge to the new folio and drops the old folio's memcg data, so the
old folio's free right after migration skips the memcg per-node decrement;
the count stays attributed to the old node for the rest of the charge's
life, and the target folio never gets an increment on its new node.  Patch
2 moves that per-node accounting along with the charge, in
move_hugetlb_state().

This patch (of 2):

The NR_HUGETLB vmstat counter is maintained per folio's node: incremented
when a huge page is handed to a user via hugetlb_alloc_folio() and
decremented when it is returned to the pool via free_huge_folio().

A folio obtained by alloc_hugetlb_folio_nodemask() never goes through
hugetlb_alloc_folio(), so it is never accounted, while its free always is.
For a migration target this means the target node gets no matching
increment for the decrement on the old node, so the global nr_hugetlb in
/proc/vmstat drops by nr_pages for each migration.  The same asymmetry
affects the failed migration path, which frees the target again right
away, and the temporary folio hugetlb_mfill_atomic_pte() takes from the
same helper.

alloc_hugetlb_folio_reserve(), used to preallocate the memfd page cache
folios, has the same asymmetry: the folio is handed to a user without
being accounted, while its free is accounted through free_huge_folio().

Account the folio where it is obtained, in alloc_hugetlb_folio_nodemask()
and alloc_hugetlb_folio_reserve(), so that the increment pairs with the
decrement in free_huge_folio(): a successful migration hands the folio to
a user, a failed one frees it again.

Link: https://lore.kernel.org/20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn
Link: https://lore.kernel.org/20260923-for-hugetlb_state3-v2-1-e8a36245bfab@kylinos.cn
Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Chris Down <chris@chrisdown.name>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 30fc6984b2898..90a8076e7ccc4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2191,6 +2191,11 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 		h->resv_huge_pages--;
 
 	spin_unlock_irq(&hugetlb_lock);
+
+	if (folio)
+		lruvec_stat_mod_folio(folio, NR_HUGETLB,
+				      folio_nr_pages(folio));
+
 	return folio;
 }
 
@@ -2198,24 +2203,30 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 		nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback)
 {
-	spin_lock_irq(&hugetlb_lock);
-	if (available_huge_pages(h)) {
-		struct folio *folio;
+	struct folio *folio = NULL;
 
+	spin_lock_irq(&hugetlb_lock);
+	if (available_huge_pages(h))
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
 						preferred_nid, nmask);
-		if (folio) {
-			spin_unlock_irq(&hugetlb_lock);
-			return folio;
-		}
-	}
 	spin_unlock_irq(&hugetlb_lock);
 
-	/* We cannot fallback to other nodes, as we could break the per-node pool. */
-	if (!allow_alloc_fallback)
-		gfp_mask |= __GFP_THISNODE;
+	if (!folio) {
+		/*
+		 * We cannot fallback to other nodes, as we could break the
+		 * per-node pool.
+		 */
+		if (!allow_alloc_fallback)
+			gfp_mask |= __GFP_THISNODE;
 
-	return alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid, nmask);
+		folio = alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid,
+						    nmask);
+	}
+
+	if (folio)
+		lruvec_stat_mod_folio(folio, NR_HUGETLB, folio_nr_pages(folio));
+
+	return folio;
 }
 
 static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
-- 
2.53.0



