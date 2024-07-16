Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4B417A93F;
	Tue, 16 Jul 2024 15:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145065; cv=none; b=qQXmtq2gAl+LGXBXhfshYEPZdHG8T9an6Dq0mznn4ZsMSRllHIKF9mcWVz4EDvP00OrLTEeLFqBnIoPvxW2xPwSd2HaNnI951B4YYA9QPlmd73jDpbKQRS384Ke9vXHGxxHo837iLaGuhG6MmqPlkBGFmxqWN0MjnxCrSuk0+kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145065; c=relaxed/simple;
	bh=dPGYHwRyTV075muJGCkO2C6LngU86bwdWlRSx5JzmiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qks2SBWVKnY4LFxiCfyXUQReNQO9nIcAt8arj+YcPgWj7ypzusHQ8jeJpbhtzrbpFIJ5ve6eH6MX1uthi3kwb1wLMeFMG/zzubGie1DJ8114dpJiYCpWCyDfpWt4v4UixPMz3q6faiGQ6jhiwnWS0ZR9/7CrD38M5b0iwRQdy2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LV3ayjDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LV3ayjDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A874C116B1;
	Tue, 16 Jul 2024 15:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145065;
	bh=dPGYHwRyTV075muJGCkO2C6LngU86bwdWlRSx5JzmiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LV3ayjDYNw/SbozYr64KqWdtJUpqQuAAgRgBznyMby124lPAjnChU+eqcyoUyxrl7
	 oPIyHqbphOREbXCyTRkuk3GFVThP7sBqgxV0C+l01wqpvxf/O72VLPW1COlRdrinsh
	 XsuQHOaqrxEmCAlylwtSkWnF+0qKiMlay/joYe7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nhat Pham <nphamcs@gmail.com>,
	syzbot+b7f13b2d0cc156edf61a@syzkaller.appspotmail.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Al Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@redhat.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Kairui Song <kasong@tencent.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 086/143] cachestat: do not flush stats in recency check
Date: Tue, 16 Jul 2024 17:31:22 +0200
Message-ID: <20240716152759.281987724@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nhat Pham <nphamcs@gmail.com>

commit 5a4d8944d6b1e1aaaa83ea42c116b520b4ed0394 upstream.

syzbot detects that cachestat() is flushing stats, which can sleep, in its
RCU read section (see [1]).  This is done in the workingset_test_recent()
step (which checks if the folio's eviction is recent).

Move the stat flushing step to before the RCU read section of cachestat,
and skip stat flushing during the recency check.

[1]: https://lore.kernel.org/cgroups/000000000000f71227061bdf97e0@google.com/

Link: https://lkml.kernel.org/r/20240627201737.3506959-1-nphamcs@gmail.com
Fixes: b00684722262 ("mm: workingset: move the stats flush into workingset_test_recent()")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Reported-by: syzbot+b7f13b2d0cc156edf61a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/cgroups/000000000000f71227061bdf97e0@google.com/
Debugged-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: <stable@vger.kernel.org>	[6.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/swap.h |    3 ++-
 mm/filemap.c         |    5 ++++-
 mm/workingset.c      |   14 +++++++++++---
 3 files changed, 17 insertions(+), 5 deletions(-)

--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -344,7 +344,8 @@ static inline swp_entry_t page_swap_entr
 }
 
 /* linux/mm/workingset.c */
-bool workingset_test_recent(void *shadow, bool file, bool *workingset);
+bool workingset_test_recent(void *shadow, bool file, bool *workingset,
+				bool flush);
 void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
 void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg);
 void workingset_refault(struct folio *folio, void *shadow);
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4153,6 +4153,9 @@ static void filemap_cachestat(struct add
 	XA_STATE(xas, &mapping->i_pages, first_index);
 	struct folio *folio;
 
+	/* Flush stats (and potentially sleep) outside the RCU read section. */
+	mem_cgroup_flush_stats_ratelimited(NULL);
+
 	rcu_read_lock();
 	xas_for_each(&xas, folio, last_index) {
 		int order;
@@ -4216,7 +4219,7 @@ static void filemap_cachestat(struct add
 					goto resched;
 			}
 #endif
-			if (workingset_test_recent(shadow, true, &workingset))
+			if (workingset_test_recent(shadow, true, &workingset, false))
 				cs->nr_recently_evicted += nr_pages;
 
 			goto resched;
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -412,10 +412,12 @@ void *workingset_eviction(struct folio *
  * @file: whether the corresponding folio is from the file lru.
  * @workingset: where the workingset value unpacked from shadow should
  * be stored.
+ * @flush: whether to flush cgroup rstat.
  *
  * Return: true if the shadow is for a recently evicted folio; false otherwise.
  */
-bool workingset_test_recent(void *shadow, bool file, bool *workingset)
+bool workingset_test_recent(void *shadow, bool file, bool *workingset,
+				bool flush)
 {
 	struct mem_cgroup *eviction_memcg;
 	struct lruvec *eviction_lruvec;
@@ -467,10 +469,16 @@ bool workingset_test_recent(void *shadow
 
 	/*
 	 * Flush stats (and potentially sleep) outside the RCU read section.
+	 *
+	 * Note that workingset_test_recent() itself might be called in RCU read
+	 * section (for e.g, in cachestat) - these callers need to skip flushing
+	 * stats (via the flush argument).
+	 *
 	 * XXX: With per-memcg flushing and thresholding, is ratelimiting
 	 * still needed here?
 	 */
-	mem_cgroup_flush_stats_ratelimited(eviction_memcg);
+	if (flush)
+		mem_cgroup_flush_stats_ratelimited(eviction_memcg);
 
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
 	refault = atomic_long_read(&eviction_lruvec->nonresident_age);
@@ -558,7 +566,7 @@ void workingset_refault(struct folio *fo
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
-	if (!workingset_test_recent(shadow, file, &workingset))
+	if (!workingset_test_recent(shadow, file, &workingset, true))
 		return;
 
 	folio_set_active(folio);


