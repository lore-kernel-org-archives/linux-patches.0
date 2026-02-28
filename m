Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DE637147D;
	Sat, 28 Feb 2026 17:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301527; cv=none; b=Wuh6Lh8XlzYbZ31C+qGcjZB8Lrt3OXWRLAqIsv6lwTcWLrmPEEb8qavONY4/PkJhGOv4QfKZ+lQy+29bHP1GY+9SNdiy6iF2ITxbT0tiIb8hZzd+hNYzkEGEpqOJcKch49/+s9PPJ9X4alq4GqO8ERJ+TZSd5wXGE329oO4VxM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301527; c=relaxed/simple;
	bh=VkU3skQLTfRyKDgniXYLmLKp95I0HHMJi3p59XSQEug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S32+ZcVjiMF1KMbrcKwWqf6jAGrW+3T6rExhOh4IHcTc6mogutsN7cthy9a3UcibsE3+rrYzb6yYeRWg5v28tdUVSJSrhD4UG/WZzLJ3Yn+FhfHP/Tu1ZaClR533m1CS4K1vLHsXbfYG+h0Dv2pyZ/xx20ISyYt6hO29Z5o5re4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W3PyvKEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W3PyvKEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD65C19423;
	Sat, 28 Feb 2026 17:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301527;
	bh=VkU3skQLTfRyKDgniXYLmLKp95I0HHMJi3p59XSQEug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3PyvKEyURqj9FZDtD2RBztvtAcujN4klGPM1tZluSa8f5BH9yX/r0nqu1rIDkqgb
	 NE2eBXDqo9vK1TxKrcgFlRSRD4WS93iTTZA5cLj9ilBakRIJ1Rh3GjcxJWKGqmKFYm
	 yZW3Q4LyMil70T1jKom9SO1FjOxgkv174p5LoN872FBTwixe0PKm1BrC8wmKzeSm2u
	 Cb2G0cY9juMx/h32Z3TlILiWizLxhhkFTeaBb7wZ/MLAzRbFgTdDiSrvlFrHogpYiW
	 49xj75xwMGkKiXYGjgxrah24OlzwW3w9diLmvaiqCfJPjdn2kugD7FdO3+bMbU9IUr
	 ecPrgvTZbZuDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
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
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 709/752] mm/page_alloc: clear page->private in free_pages_prepare()
Date: Sat, 28 Feb 2026 12:47:00 -0500
Message-ID: <20260228174750.1542406-709-sashal@kernel.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f44524e1c92ac..d76f0f60f080d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1429,6 +1429,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
 
 	page_cpupid_reset_last(page);
 	page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	page->private = 0;
 	reset_page_owner(page, order);
 	page_table_check_free(page, order);
 	pgalloc_tag_sub(page, 1 << order);
-- 
2.51.0

