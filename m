Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B055F372235;
	Sat, 28 Feb 2026 17:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301521; cv=none; b=OLCVaLzTdJN5CVJasaZGapvEMC9MmBpvL+TV1t4/faQcWMnFEVzAg9rwm3LbV+GMlS7zccUYSIZ9QpwIFIfQ8RYAXGZLQacopa2n/BbSZMqhN8eGXRBg0mWJ4bofryzgR0/slF20kUtG9BkzdhZtZdITEik1O+YiCpL0KGgkIbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301521; c=relaxed/simple;
	bh=yBx8Qjwn25FiFuBeqQYnN9w7/lwxSY30sDGcdd51+WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoFsxnYeT4C4NE0xHnD21xccvVtQEjnyxtsf38w12vV2YAK+tXAY9EVmT1Lj0/TNVQ+8e979BvMdpRxkfZ8KmC0QW3OTezsasHTv9S2dr2TN+0f/wY6Ek8e9wN8cUxCOWIwLd17ybuUFuvyVLR33hyfU4lA2T/nkdMFLR+h9J/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K4+KkYQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K4+KkYQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41462C116D0;
	Sat, 28 Feb 2026 17:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301521;
	bh=yBx8Qjwn25FiFuBeqQYnN9w7/lwxSY30sDGcdd51+WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4+KkYQrquQO8+GLxt1gsD/AMn0ysfxDjwspB8L68+TTLzSsz9vCNEEoXLYr0ezL2
	 49XDx+DNKtMVMS9cOcNJL70LpCs/doTKbS2PijaSnA63Yc/zAgOF6j7eno65mMq2gF
	 EQfBN8V5ATsDEfnutSnx4LneCVru+g5ZaQsPC08ziCphtrgwLcoDBxrQm112nfL2UL
	 eUmPpfBbjFXdOVjoJzfE1rZpzOf/HzkdRthwgilUYjplfNtGJxGnsNYhaTIifuJn75
	 /OEPR5BkuYfwPavnfL/F2mlx74DtRsUYtiMkwJlg9nJAL17UMwxFWD48ZRa4takLPV
	 DEJKHknHIEAXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 706/752] mm/page_alloc: skip debug_check_no_{obj,locks}_freed with FPI_TRYLOCK
Date: Sat, 28 Feb 2026 12:46:57 -0500
Message-ID: <20260228174750.1542406-706-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Harry Yoo <harry.yoo@oracle.com>

[ Upstream commit 338ad1e84d15078a9ae46d7dd7466329ae0bfa61 ]

When CONFIG_DEBUG_OBJECTS_FREE is enabled,
debug_check_no_{obj,locks}_freed() functions are called.

Since both of them spin on a lock, they are not safe to be called if the
FPI_TRYLOCK flag is specified.  This leads to a lockdep splat:

  ================================
  WARNING: inconsistent lock state
  6.19.0-rc5-slab-for-next+ #326 Tainted: G                 N
  --------------------------------
  inconsistent {INITIAL USE} -> {IN-NMI} usage.
  kunit_try_catch/9046 [HC2[2]:SC0[0]:HE0:SE1] takes:
  ffffffff84ed6bf8 (&obj_hash[i].lock){-.-.}-{2:2}, at: __debug_check_no_obj_freed+0xe0/0x300
  {INITIAL USE} state was registered at:
    lock_acquire+0xd9/0x2f0
    _raw_spin_lock_irqsave+0x4c/0x80
    __debug_object_init+0x9d/0x1f0
    debug_object_init+0x34/0x50
    __init_work+0x28/0x40
    init_cgroup_housekeeping+0x151/0x210
    init_cgroup_root+0x3d/0x140
    cgroup_init_early+0x30/0x240
    start_kernel+0x3e/0xcd0
    x86_64_start_reservations+0x18/0x30
    x86_64_start_kernel+0xf3/0x140
    common_startup_64+0x13e/0x148
  irq event stamp: 2998
  hardirqs last  enabled at (2997): [<ffffffff8298b77a>] exc_nmi+0x11a/0x240
  hardirqs last disabled at (2998): [<ffffffff8298b991>] sysvec_irq_work+0x11/0x110
  softirqs last  enabled at (1416): [<ffffffff813c1f72>] __irq_exit_rcu+0x132/0x1c0
  softirqs last disabled at (1303): [<ffffffff813c1f72>] __irq_exit_rcu+0x132/0x1c0

  other info that might help us debug this:
   Possible unsafe locking scenario:

         CPU0
         ----
    lock(&obj_hash[i].lock);
    <Interrupt>
      lock(&obj_hash[i].lock);

   *** DEADLOCK ***

Rename free_pages_prepare() to __free_pages_prepare(), add an fpi_t
parameter, and skip those checks if FPI_TRYLOCK is set.  To keep the fpi_t
definition in mm/page_alloc.c, add a wrapper function free_pages_prepare()
that always passes FPI_NONE and use it in mm/compaction.c.

Link: https://lkml.kernel.org/r/20260209062639.16577-1-harry.yoo@oracle.com
Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 10708f37575d4..f44524e1c92ac 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1339,8 +1339,8 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
-__always_inline bool free_pages_prepare(struct page *page,
-			unsigned int order)
+__always_inline bool __free_pages_prepare(struct page *page,
+					  unsigned int order, fpi_t fpi_flags)
 {
 	int bad = 0;
 	bool skip_kasan_poison = should_skip_kasan_poison(page);
@@ -1433,7 +1433,7 @@ __always_inline bool free_pages_prepare(struct page *page,
 	page_table_check_free(page, order);
 	pgalloc_tag_sub(page, 1 << order);
 
-	if (!PageHighMem(page)) {
+	if (!PageHighMem(page) && !(fpi_flags & FPI_TRYLOCK)) {
 		debug_check_no_locks_freed(page_address(page),
 					   PAGE_SIZE << order);
 		debug_check_no_obj_freed(page_address(page),
@@ -1472,6 +1472,11 @@ __always_inline bool free_pages_prepare(struct page *page,
 	return true;
 }
 
+bool free_pages_prepare(struct page *page, unsigned int order)
+{
+	return __free_pages_prepare(page, order, FPI_NONE);
+}
+
 /*
  * Frees a number of pages from the PCP lists
  * Assumes all pages on list are in same zone.
@@ -1605,7 +1610,7 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (free_pages_prepare(page, order))
+	if (__free_pages_prepare(page, order, fpi_flags))
 		free_one_page(zone, page, pfn, order, fpi_flags);
 }
 
@@ -2931,7 +2936,7 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 		return;
 	}
 
-	if (!free_pages_prepare(page, order))
+	if (!__free_pages_prepare(page, order, fpi_flags))
 		return;
 
 	/*
@@ -2988,7 +2993,7 @@ void free_unref_folios(struct folio_batch *folios)
 		unsigned long pfn = folio_pfn(folio);
 		unsigned int order = folio_order(folio);
 
-		if (!free_pages_prepare(&folio->page, order))
+		if (!__free_pages_prepare(&folio->page, order, FPI_NONE))
 			continue;
 		/*
 		 * Free orders not handled on the PCP directly to the
-- 
2.51.0

