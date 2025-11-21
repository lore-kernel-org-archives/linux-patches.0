Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A7B34C81D;
	Fri, 21 Nov 2025 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733604; cv=none; b=MKb1keeNm5ADwkuMRZcvlaO12+bJKZ2zTnWTUwBIQz8PqQowpoz85cu9ziY4wZCWyhfgMb1vxcRHwuJJnWsoZ0VYtckakLGVhmc8G2ZzoeY7PCFsBDLt5RkvLxjUCMCuGrtm5zDTFR8L2vY1oKhRQN/Cc+32ifiSag7rJYY/UzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733604; c=relaxed/simple;
	bh=v+3s3+8WnDIQ+B5Bm5HINCNzwCrA/QvjEkZprVOIcqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZE5Ji+2feFxYUFPeHl3oC7xtsk5xlHM8WQDhQKak98VTgu3l8eg2aR+MLV+4k2SWraAnOJXeGBzst4FWxD3IslhBrBUsjmr/wER6a7G4Ul3asZdC10qjXd3SAprVJtrmQx+ZgZSav7wtzxBPFiChjC3L8sdPy1egOzbfFa1tl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6bNoREx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6bNoREx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDEDC4CEF1;
	Fri, 21 Nov 2025 14:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733604;
	bh=v+3s3+8WnDIQ+B5Bm5HINCNzwCrA/QvjEkZprVOIcqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6bNoRExGDbz5Uh887nqULCKRpk6de3ISuXgFm6MVaSb70gXkjyi64OQSYnrmOP4O
	 L/PoijFRut+R7KcD5+mPEdcpV/ari195DfxtZ7D4N52hygFXW+amdBaSBh74cXrTKJ
	 WtsPI4jbTwjaOBOPX60HAHZ9PUj392BjjE4NV0LE=
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
Subject: [PATCH 6.6 524/529] cachestat: do not flush stats in recency check
Date: Fri, 21 Nov 2025 14:13:43 +0100
Message-ID: <20251121130249.690298752@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -343,7 +343,8 @@ static inline swp_entry_t page_swap_entr
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
@@ -4210,6 +4210,9 @@ static void filemap_cachestat(struct add
 	XA_STATE(xas, &mapping->i_pages, first_index);
 	struct folio *folio;
 
+	/* Flush stats (and potentially sleep) outside the RCU read section. */
+	mem_cgroup_flush_stats_ratelimited(NULL);
+
 	rcu_read_lock();
 	xas_for_each(&xas, folio, last_index) {
 		int order;
@@ -4273,7 +4276,7 @@ static void filemap_cachestat(struct add
 					goto resched;
 			}
 #endif
-			if (workingset_test_recent(shadow, true, &workingset))
+			if (workingset_test_recent(shadow, true, &workingset, false))
 				cs->nr_recently_evicted += nr_pages;
 
 			goto resched;
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -411,10 +411,12 @@ void *workingset_eviction(struct folio *
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
@@ -466,10 +468,16 @@ bool workingset_test_recent(void *shadow
 
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
@@ -557,7 +565,7 @@ void workingset_refault(struct folio *fo
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
-	if (!workingset_test_recent(shadow, file, &workingset))
+	if (!workingset_test_recent(shadow, file, &workingset, true))
 		return;
 
 	folio_set_active(folio);


