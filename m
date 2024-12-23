Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DC01AD41F;
	Mon, 23 Dec 2024 16:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970146; cv=none; b=NvYKrMtZzUrpjoibCF5Vx14DHRuvHsqnbRTnk+vxE4QMPA9C/Z6I33fo8pXuFarx9/DC7krchBVhAb8OIDZcOwd0qNyKvD8V7oVSzrx341T/Wiwni14AD+kGJ1nhzeyNDqPh6qYDCD0NVLHJxGl8afFpiav2J5Np5Vvf1pQv+oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970146; c=relaxed/simple;
	bh=DztSW4tuK+jZUd5XqJ77zciMSgB6KR3YawOXRJwqm8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucbIpNbhN0LDob+BPbcpXMvw5OQPrwXQdnVrewhKmG2MiIMXofufu8KkkR05UI+iyt3UJguzeMNSU1rI2P58ojTNgzkfk/B8tvJ/ic0YUoPYd0AhgkMQDfVMgfmY/7B8RCY3TWAx0VoduYH3NgxYedzAIaiQC7D/Eu1DKu2M7ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ER1ZCYbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ER1ZCYbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39524C4CED3;
	Mon, 23 Dec 2024 16:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970145;
	bh=DztSW4tuK+jZUd5XqJ77zciMSgB6KR3YawOXRJwqm8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ER1ZCYbPBMA/q2KXi+9/3jP5+FNOQyE/7Qh0CDJUoCQoqYUiwh8r1NLutmklaf6wR
	 zNJ8QAZLkLqTu7nD21rPWHWT1YGLJre83n9JgYs9LAOqkoowtdUWJPKQzVtq1rRGuF
	 /ua6S2tjpkm/MLo8lf92TPVKaE4mkWMKU51iV340=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Domenico Cerasuolo <cerasuolodomenico@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 159/160] mm: convert partially_mapped set/clear operations to be atomic
Date: Mon, 23 Dec 2024 16:59:30 +0100
Message-ID: <20241223155414.961764620@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Usama Arif <usamaarif642@gmail.com>

commit 42b2eb69835b0fda797f70eb5b4fc213dbe3a7ea upstream.

Other page flags in the 2nd page, like PG_hwpoison and PG_anon_exclusive
can get modified concurrently.  Changes to other page flags might be lost
if they are happening at the same time as non-atomic partially_mapped
operations.  Hence, make partially_mapped operations atomic.

Link: https://lkml.kernel.org/r/20241212183351.1345389-1-usamaarif642@gmail.com
Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped folios")
Reported-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/all/e53b04ad-1827-43a2-a1ab-864c7efecf6e@redhat.com/
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/page-flags.h |   12 ++----------
 mm/huge_memory.c           |    8 ++++----
 2 files changed, 6 insertions(+), 14 deletions(-)

--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -860,18 +860,10 @@ static inline void ClearPageCompound(str
 	ClearPageHead(page);
 }
 FOLIO_FLAG(large_rmappable, FOLIO_SECOND_PAGE)
-FOLIO_TEST_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
-/*
- * PG_partially_mapped is protected by deferred_split split_queue_lock,
- * so its safe to use non-atomic set/clear.
- */
-__FOLIO_SET_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
-__FOLIO_CLEAR_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
+FOLIO_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
 #else
 FOLIO_FLAG_FALSE(large_rmappable)
-FOLIO_TEST_FLAG_FALSE(partially_mapped)
-__FOLIO_SET_FLAG_NOOP(partially_mapped)
-__FOLIO_CLEAR_FLAG_NOOP(partially_mapped)
+FOLIO_FLAG_FALSE(partially_mapped)
 #endif
 
 #define PG_head_mask ((1UL << PG_head))
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3503,7 +3503,7 @@ int split_huge_page_to_list_to_order(str
 		    !list_empty(&folio->_deferred_list)) {
 			ds_queue->split_queue_len--;
 			if (folio_test_partially_mapped(folio)) {
-				__folio_clear_partially_mapped(folio);
+				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(folio_order(folio),
 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
@@ -3615,7 +3615,7 @@ bool __folio_unqueue_deferred_split(stru
 	if (!list_empty(&folio->_deferred_list)) {
 		ds_queue->split_queue_len--;
 		if (folio_test_partially_mapped(folio)) {
-			__folio_clear_partially_mapped(folio);
+			folio_clear_partially_mapped(folio);
 			mod_mthp_stat(folio_order(folio),
 				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 		}
@@ -3659,7 +3659,7 @@ void deferred_split_folio(struct folio *
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (partially_mapped) {
 		if (!folio_test_partially_mapped(folio)) {
-			__folio_set_partially_mapped(folio);
+			folio_set_partially_mapped(folio);
 			if (folio_test_pmd_mappable(folio))
 				count_vm_event(THP_DEFERRED_SPLIT_PAGE);
 			count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
@@ -3752,7 +3752,7 @@ static unsigned long deferred_split_scan
 		} else {
 			/* We lost race with folio_put() */
 			if (folio_test_partially_mapped(folio)) {
-				__folio_clear_partially_mapped(folio);
+				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(folio_order(folio),
 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}


