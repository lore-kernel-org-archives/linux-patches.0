Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D19D2F745E;
	Tue, 16 Jun 2026 16:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628265; cv=none; b=dNdI5Xp5MYFx5ypt8Lb1kvvR9QtnnSifxrnGnQ8bEK6KyBy4NUUEDPCtzbizs2y9Zsu8/QCuaTdVkEVnnUXAgo7XdLe7bCq2ZgfdJP+lP7MV99ETNGRUHmm7+KX2vmfXV5RTLmpbKOP5Kr6s91DbOj1G2/OA0CBsIWVLrayUNMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628265; c=relaxed/simple;
	bh=8oFxNnN0xYp9R0Beqzj1BnTf7UV4+zYQcgZ3mefpYvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4Oln/AfNSQ5bRtMpbP52+SCLE/Z9OHC55Oqyq5cT8gG0t36NZkxaKMhOpM8bvt9hf3GYgqacO+j+I68UjbD5v7IPbIgWD2cEiIDdjbCeWHg82PQ3fcsEWVDVycKitwTN7jBnWv4k/N48LPj4DACKXKRrZ8L29Ldb0QJMOj02Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHAtZKP0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHAtZKP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34971F000E9;
	Tue, 16 Jun 2026 16:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628264;
	bh=Z5ceESlV3BDh+VjrYtvU5Qikpbwh5gBdID0dfwJShHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHAtZKP03ZeQb8SR+KORoBc3i/VgsDr3U7JBH7SH98HyVnVrfrIdMx0vDc5vA86bs
	 OS339HIkvaUSCqebBKLCbCmKyaDszIEaa0J4kR5YueCqUCxj0g1L55CeMkE6piX/r4
	 Dnrn8f/MaUFpBM6fKGFOfBKB/7XA24Z7bO+6P5bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Chris Li <chrisl@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <ryncsn@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Li Wang <li.wang@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/452] mm/page_alloc: clear page->private in free_pages_prepare()
Date: Tue, 16 Jun 2026 20:24:49 +0530
Message-ID: <20260616145121.213065682@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

[ Upstream commit ac1ea219590c09572ed5992dc233bbf7bb70fef9 ]

Several subsystems (slub, shmem, ttm, etc.) use page->private but don't
clear it before freeing pages.  When these pages are later allocated as
high-order pages and split via split_page(), tail pages retain stale
page->private values.

This causes a use-after-free in the swap subsystem.  The swap code uses
page->private to track swap count continuations, assuming freshly
allocated pages have page->private == 0.  When stale values are present,
swap_count_continued() incorrectly assumes the continuation list is valid
and iterates over uninitialized page->lru containing LIST_POISON values,
causing a crash:

  KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
  RIP: 0010:__do_sys_swapoff+0x1151/0x1860

Fix this by clearing page->private in free_pages_prepare(), ensuring all
freed pages have clean state regardless of previous use.

Link: https://lkml.kernel.org/r/20260207173615.146159-1-mikhail.v.gavrilov@gmail.com
Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be split rather than compound")
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[backport: context only]
Signed-off-by: Li Wang <li.wang@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b617fb364b15d1..ffdc71103c2ad2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1178,6 +1178,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
 
 	page_cpupid_reset_last(page);
 	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	page->private = 0;
 	reset_page_owner(page, order);
 	page_table_check_free(page, order);
 
-- 
2.53.0



