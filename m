Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044016;
	b=wQdoTmqYn9JAoa6asF/BCfzKBuxLxjfgsLcCMcx0vvh+G48sMXw91NHZVV2RpA8hdujm
	 tQkrUmBgo0N1xEnH301G/3C3PeC8ZXiQcZJ+ZxJv+E/gbOvsYVqJqwRvoR/bVZ9PFbwwb
	 32x8U7ULJb6V1iJm/2+/4VmVflKSUKktf7w7YZ1P9/sJaMAMF4OqgPXxgFs3H3ZjJF3hS
	 4voxcsHtJrCdZqC0ba6V0ojOjjsvI4QcIeZNvi/9eSCnDREJDrUXZR/M4unMu1t3NNVqe
	 hOxnCvqGbbyvpcXFmmITfKUJElPgxFqkc8OVAGwtOAj1bVXcBfdQA3nDlSdoLTuqXOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xa2BxnnJm7YO8T6M/1AV9BJre3xraHPDeA8aFb0Es4s=;
	b=GhBZCamgRI+Fw2panZkdYtt/XbCYI1rI8Q4k3Edcc/vK6cpLqRYFDS0OUt7+fSKItB24
	 KTg5a+Acj6f5JhRhXkAcWTRMH2NQUWqG1K6J5XlQBUkLDm5hj83X57hMXihDn3/XqJ6fm
	 Fe9E4s5t0g3oZqdlstyO3CujZtX0v73JYLNDJuepEflQbVxMURASj6TjOEsjMGTExd+ky
	 1vsDyLrdVCav7k+hUxzdSBVUD1tA5tLaG4fDO9rF94OgVPnwgyoGZk1BSrsIvlqFY9C4w
	 NVPurwK5s7uKfbiniGSj2g93cp99hglcD+W8vzr1u8QyHxXnIYCVlN+BE2NTi0hcIYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTqLx6CK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C160A606A332;
	Wed, 18 Nov 2026 23:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTqLx6CK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DC71F000C5;
	Wed, 18 Nov 2026 23:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044016;
	bh=xa2BxnnJm7YO8T6M/1AV9BJre3xraHPDeA8aFb0Es4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTqLx6CKGGiW05AXXlMqOsP6bVqC6404TA0oBJnLc8KAQd76s/eI3I2EuRmGsRUNc
	 59f3cFPLOm2ks/Snus5leILtCy4Rd/DNlZoyPef+sj9KI4nynmv3DMq5fnN+VBQ4iL
	 cC27mApu0Hdj9z5Bvf9Rshaxea1rYEUbZ0bUASYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0372/2857] mm/gup: fix always draining LRU caches in collect_longterm_unpinnable_folios()
Date: Wed, 18 Nov 2026 15:23:26 +0100
Message-ID: <20261118150214.810214374@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 078e1a0fc41a42baaf113383b52dab8874c0b967 ]

folio_may_be_lru_cached() is currently only true for small folios, and
for small folios FOLL_PIN adds GUP_PIN_COUNTING_BIAS references instead
of 1 in try_grab_folio()/try_grab_folio_fast().

Consequently, our

	folio_ref_count(folio) != folio_expected_ref_count(folio) + 1

check in collect_longterm_unpinnable_folios() will currently always
identify "reference mismatch" and first drain the local LRU cache to then
drain the LRU cache on all CPUs, as collect_longterm_unpinnable_folios()
is really called after pinning the folios with FOLL_PIN.

Add a comment because the current code is not quite intuitive: we used to
drain only to make sure the folio_isolate_lru() would succeed. But then we
also started draining to make later migration more reliable.

We'll refactor that code soon a bit, to also make it usable in other
context where we really want to remove any references from LRU caches.

Let's add CC stable, because having an easy way for excessive LRU cache
draining on all CPUs does not sound right. In common scenarios we
don't expect to ever have to drain.

Link: https://lore.kernel.org/20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org
Fixes: 98c6d259319e ("mm/gup: check ref_count instead of lru before migration")
Fixes: a09a8a1fbb37 ("mm/gup: local lru_add_drain() to avoid lru_add_drain_all()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ sashal: Adapted to the older page-array loop in the collect function and used folio_test_large() in place of the missing folio_has_pincount() to compute pin_refs. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 72e01b8311d7c..2c20548a0c46e 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1972,6 +1972,7 @@ static unsigned long collect_longterm_unpinnable_pages(
 
 	for (i = 0; i < nr_pages; i++) {
 		struct folio *folio = page_folio(pages[i]);
+		const int pin_refs = folio_test_large(folio) ? 1 : GUP_PIN_COUNTING_BIAS;
 
 		if (folio == prev_folio)
 			continue;
@@ -1990,15 +1991,20 @@ static unsigned long collect_longterm_unpinnable_pages(
 			continue;
 		}
 
+		/*
+		 * We drain not only to make the folio_isolate_lru() succeed,
+		 * but also to remove any other folio references from LRU
+		 * caches.
+		 */
 		if (drained == 0 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
+				folio_expected_ref_count(folio) + pin_refs) {
 			lru_add_drain();
 			drained = 1;
 		}
 		if (drained == 1 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
+				folio_expected_ref_count(folio) + pin_refs) {
 			lru_add_drain_all();
 			drained = 2;
 		}
-- 
2.53.0



