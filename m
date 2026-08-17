Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495C243B6E7;
	Mon, 17 Aug 2026 14:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978212; cv=none; b=s+ewUA5RWiDXN8QqgD2aCYZxDxvQAWzZdIvwulAmIX9OM3KSHoWhY8svsrMEiOo11s+Oxd5qTGCzZ1sjN89jIK2CquI+y/2wO6U0VusbAisDROXPWNmxUlIuW1eaVqNXerZqjJcJLI5541ySYYoSydq1y7vgOlV0hIvjY3yYPRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978212; c=relaxed/simple;
	bh=O2Crn5x7r/0jSYb+dPRm8djtiybRcMrhLI1dWXT5uvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcDNsCXTtXy0SKD/oHeDFMjCmiU74pJo9d4dsrWDvMEKQaRJThPR1pI8dUDt5yDMhPk9qMf7qLjFdvwvDD6mCTMWUR2SygnSEQJ9mKKtGu9CRocxz8uLDAW/9ww0CcNZX0Zw8rOnn4iQ1TGpruxGaeP5j3IOPItwyDdzSlxaz6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5NpkN+N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5NpkN+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DACB1F000E9;
	Mon, 17 Aug 2026 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978211;
	bh=E7qPgk89CGt1mQ9amPs8g7loez73vouEoeo3MqDwEsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w5NpkN+NnblEVLDtKNBYPCf3s9T+TzwG5o33MkGyJfxiHMXV34g78QEWZ+vgbcjSO
	 Us5e09jxvrMNSfeYLh5ZUo1OguATQLSNh/jq03hgCgN7oy1nsNVzP3xNaEmzmQOAVC
	 xjt1jZwRu3uJa4SpCPv/rOFlrRAoBBmO6LfhriQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Hengbin Zhang <uqbarz@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hannes Reinecke <hare@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <shy828301@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 140/181] mm/huge_memory: fix huge_zero_pfn race
Date: Mon, 17 Aug 2026 15:33:54 +0200
Message-ID: <20260817132541.153099474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

commit 33192a26cddea7a7e4ca66e5c3eebd36fa8be2bb upstream.

Patch series "mm/huge_memory: fix huge_zero_pfn race", v2.

There is a subtle race in the reference-counted huge_zero_folio
implementation.

The fast path atomic logic fails to account for the fact that the shrinker
(which drops the final huge_zero_refcount pin) can overwrite huge_zero_pfn
with the ~0UL sentinel value in shrink_huge_zero_folio_scan() after a
racing get_huge_zero_folio() installed a valid value there.

This results in huge_zero_folio being correctly set but huge_zero_pfn
being set incorrectly and thus is_huge_zero_pfn() and consequently
is_huge_zero_pmd() will misidentify the huge zero folio as being an
ordinary THP folio.

This can result in the huge zero folio being split and otherwise treated
incorrectly.

The solution to this is very subtle as there is an atomic fast path, and
thus ordering in weakly ordered architectures has to be treated very
carefully.

The first commit fixes the issue by introducing a spinlock around
huge_zero_[pfn, folio, refcount] write, with careful consideration paid to
load/store ordering in the fast path.  It is placed first and kept as
small as possible so that it can be backported on its own.

The second commit is a pure cleanup which reworks the
CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic to better separate the persistent
logic from the dynamically allocated one.


This patch (of 2):

If !CONFIG_PERSISTENT_HUGE_ZERO_FOLIO, the huge_zero_folio is refcounted
by huge_zero_refcount and returned by mm_get_huge_zero_folio().

When the caller is done with the huge zero page, its reference count is
decremented.  Only a shrinker can set the reference count to zero.

A race can unfortunately occur between a shrinker decrementing the
reference count to zero and a concurrent page fault.

This is because shrink_huge_zero_folio_scan() might, if very unlucky, be
preempted between setting huge_zero_refcount to zero and writing an
invalid value.

During this time get_huge_zero_folio() could write to huge_zero_pfn before
shrink_huge_zero_folio_scan() resumes.

In this event the huge zero folio will be persistently misidentified
causing the THP code path to be entered inappropriately for the huge zero
folio:

                CPU 0                                   CPU 1
=======================================|=================================
shrink_huge_zero_folio_scan()          |
   atomic_cmpxchg() sets refcount to 0 |
   xchg() sets huge_zero_folio to NULL | get_huge_zero_folio()
                 |                     |    atomic_inc_not_zero() -> zero
      preempted for a long time        |    Allocate new huge zero folio
                 |                     |    Write valid huge_zero_folio
                 v                     |    Write valid huge_zero_pfn
  Overwrite huge_zero_pfn with ~0UL   <--- Invalid overwrite!

This results in is_huge_zero_pfn() and is_huge_zero_pmd() incorrectly
returning false for a huge zero page which could result in issues like the
huge zero folio being incorrectly split.

Note that the issue is with huge_zero_pfn not huge_zero_folio, as
get_huge_zero_folio() uses cmpxchg() gated on huge_zero_folio being NULL
with a retry loop and shrink_huge_zero_folio_scan() uses xchg() to set
huge_zero_folio.

Fix the issue by introducing a spinlock, huge_zero_lock, to prevent
concurrent write of huge_zero_folio, huge_zero_pfn and huge_zero_refcount.

There needs to be significant care taken here to ensure correctness:

The fast path in get_huge_zero_folio() uses atomic_inc_not_zero(), which
is outside of the critical section, and means huge zero allocation is
gated on zero huge_zero_refcount.

The fast path doesn't use huge_zero_lock, so the critical section is
irrelevant to it.

So invariants are required - huge_zero_refcount MUST:

* Only be set in the huge_zero_lock critical section to ensure
  serialisation of huge_zero_pfn, huge_zero_folio and huge_zero_refcount
  writes.

* Be set non-zero only AFTER huge_zero_[pfn, folio] are set to valid values
  so installation of the huge zero folio on read page fault ensures
  concurrent is_huge_zero_*() calls correctly identify the huge zero folio.

* Be set zero only BEFORE huge_zero_[pfn, folio] are set to NULL and ~0UL
  respectively, and atomically.

Establish these by:

* Only setting huge_zero_refcount to zero or an absolute value in the
  huge_zero_lock critical section in get_huge_zero_folio() and
  shrink_huge_zero_folio_scan(), and always updating atomically there
  and elsewhere.

* Using atomic_set_release(&huge_zero_refcount) in get_huge_zero_folio()
  after huge_zero_[pfn, folio] are set. This is paired with
  atomic_inc_not_zero() to ensure atomic_inc_not_zero() only observes a
  non-zero value if huge_zero_[pfn, folio] are set.

* Using atomic_cmpxchg() in shrink_huge_zero_folio_scan() (as before) to
  ensure that it is set zero only when equal to 1 and set atomically.

* atomic_cmpxchg() being fully ordered ensures this is done prior to
  huge_zero_[folio, pfn] being set to NULL and ~0UL respectively.

Eliminate the retry loop in get_huge_zero_folio() as the atomic_cmpxchg()
in shrink_huge_zero_folio_scan() is now performed under the lock, and
replace with an equally locked atomic_inc() to set the reference count
should the caller be raced on huge zero folio installation.

folio_put() naturally implies a full memory barrier so its ordering is
maintained correctly.

The huge zero folio also cannot be released except when the shrinker does
so as it is non-LRU and non-rmappable.

Note that only the huge zero shrinker (via shrink_huge_zero_folio_scan())
can actually set huge_zero_refcount to zero, which is the count of mm's
which have at least one huge zero folio installed plus one shrinker pin.

Additionally convert a BUG_ON() to a VM_WARN_ON_ONCE().

Link: https://lore.kernel.org/20260730-fix-refcounted-huge-zero-v2-0-c5d8a41b317f@kernel.org
Link: https://lore.kernel.org/20260730-fix-refcounted-huge-zero-v2-1-c5d8a41b317f@kernel.org
Fixes: 3b77e8c8cde5 ("mm/thp: make is_huge_zero_pmd() safe and quicker")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reported-by: Hengbin Zhang <uqbarz@gmail.com>
Closes: https://lore.kernel.org/linux-mm/20260727154001.4102341-1-uqbarz@gmail.com/
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -41,6 +41,7 @@
 #include <linux/compat.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/cleanup.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -77,6 +78,7 @@ static unsigned long deferred_split_scan
 static bool split_underused_thp = true;
 
 static atomic_t huge_zero_refcount;
+static DEFINE_SPINLOCK(huge_zero_lock);
 struct folio *huge_zero_folio __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
 unsigned long huge_anon_orders_always __read_mostly;
@@ -197,7 +199,8 @@ unsigned long __thp_vma_allowable_orders
 static bool get_huge_zero_page(void)
 {
 	struct folio *zero_folio;
-retry:
+
+	/* Paired with atomic_set_release(). */
 	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
 		return true;
 
@@ -209,17 +212,22 @@ retry:
 	}
 	/* Ensure zero folio won't have large_rmappable flag set. */
 	folio_clear_large_rmappable(zero_folio);
-	preempt_disable();
-	if (cmpxchg(&huge_zero_folio, NULL, zero_folio)) {
-		preempt_enable();
+
+	/* Paired with critical section in shrink_huge_zero_folio_scan(). */
+	spin_lock(&huge_zero_lock);
+	if (huge_zero_folio) {
+		/* Somebody else already installed it. */
+		atomic_inc(&huge_zero_refcount);
+		spin_unlock(&huge_zero_lock);
 		folio_put(zero_folio);
-		goto retry;
+		return true;
 	}
+	WRITE_ONCE(huge_zero_folio, zero_folio);
 	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
+	/* Paired with atomic_inc_not_zero(). +1 for shrinker pin. */
+	atomic_set_release(&huge_zero_refcount, 2);
+	spin_unlock(&huge_zero_lock);
 
-	/* We take additional reference here. It will be put back by shrinker */
-	atomic_set(&huge_zero_refcount, 2);
-	preempt_enable();
 	count_vm_event(THP_ZERO_PAGE_ALLOC);
 	return true;
 }
@@ -263,15 +271,22 @@ static unsigned long shrink_huge_zero_pa
 static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
 				       struct shrink_control *sc)
 {
-	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
-		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
-		BUG_ON(zero_folio == NULL);
+	struct folio *zero_folio;
+
+	/* Paired with critical section in get_huge_zero_folio(). */
+	scoped_guard(spinlock, &huge_zero_lock) {
+		/* Paired with atomic_inc_not_zero() in get_huge_zero_folio(). */
+		if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) != 1)
+			return 0;
+
+		zero_folio = huge_zero_folio;
+		VM_WARN_ON_ONCE(!zero_folio);
+		WRITE_ONCE(huge_zero_folio, NULL);
 		WRITE_ONCE(huge_zero_pfn, ~0UL);
-		folio_put(zero_folio);
-		return HPAGE_PMD_NR;
 	}
 
-	return 0;
+	folio_put(zero_folio);
+	return HPAGE_PMD_NR;
 }
 
 static struct shrinker *huge_zero_page_shrinker;


