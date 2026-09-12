Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8322D23A6;
	Sat, 12 Sep 2026 14:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222181; cv=none; b=fEeSMaNDTO7prTwzyWDnfz9d/OCndibKcQ3M8YAOw1OBD9sKVN0Hi8GGRJE2blSXEtJ8eBXev3SE+KqURhofv79G9dcVaxox2WFxV2Jnyqg/X/DMh3//JkxzuJumAIcEAMYu/+9dMjGs+1dMFabhcY8iviJ1PLvTC2CtXoK4oQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222181; c=relaxed/simple;
	bh=BmRYpg0Nw9G+lARet5Y2Wt7DuIhYWLVVLpuZNOm+JMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8eFTj2p7e4fVHNhHz0Xp/atimmokgFKoJhGlLlY+ICu7jK0vLt1NgM4x+XwKNQ2JPNCYdih2UxzG0mjBCtxv9xhKCgrkijxZkBMqm2kVPb3iMwTJycn3aJRALCKgElbYUbEEBEX/T9DwOu3mZrrmb11NROSCIADgJA5cLBzph0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6Bjvv3J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6Bjvv3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396F41F000FF;
	Sat, 12 Sep 2026 14:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222180;
	bh=WLVC/tl2t1L9aI1PTwBvfQfGxekxMr6Tu7RhRChLhCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6Bjvv3JnZA0VugEhenbZr8ASL3kKnzgMzWr3L5k6wPL/vH/RuNAp3O8ztsWmNOda
	 lmkNiotot/DElVhDAXh2NR5luHd8Ib+Lf2KYAJkXZsfDheumkxvPD8d/HbGIw/ZsgJ
	 9aLGZCQUmTOcmqsn+qom7jiJxnomH5sbancaZLkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0533/1424] mm/damon/vaddr: drop last same folio access check optimization
Date: Sat, 12 Sep 2026 08:49:25 +0200
Message-ID: <20260912065619.231308821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit 831846078caa14b7d00b2ccca8b8fe522afe3204 ]

The optimization can race when multiple kdamonds are running.  Meanwhile,
the impact of the optimization is quite doubtful.  Just remove it.

The user impact of the issue should be quite trivial.  After all, the race
can happen only when the user intentionally setup DAMON in the way.  Even
if it happens, it would be rare and only degrade the best-effort
monitoring results.  No critical consequences like kernel panic or memory
corruption happen.

The race possibility was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-4-sj@kernel.org
Link: https://lore.kernel.org/20260621204050.10993-1-sj@kernel.org [1]
Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/vaddr.c | 34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 4d7dc9f65f682..c74b3fd1d227a 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -429,8 +429,6 @@ static void damon_va_prepare_access_checks(struct damon_ctx *ctx)
 }
 
 struct damon_young_walk_private {
-	/* size of the folio for the access checked virtual memory address */
-	unsigned long *folio_sz;
 	bool young;
 };
 
@@ -466,7 +464,6 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 					mmu_notifier_test_young(walk->mm,
 						addr))
 			priv->young = true;
-		*priv->folio_sz = HPAGE_PMD_SIZE;
 		folio_put(folio);
 huge_out:
 		spin_unlock(ptl);
@@ -488,7 +485,6 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 	if (pte_young(ptent) || !folio_test_idle(folio) ||
 			mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	*priv->folio_sz = folio_size(folio);
 	folio_put(folio);
 out:
 	pte_unmap_unlock(pte, ptl);
@@ -517,7 +513,6 @@ static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	if (pte_young(entry) || !folio_test_idle(folio) ||
 	    mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	*priv->folio_sz = huge_page_size(h);
 
 	folio_put(folio);
 
@@ -535,11 +530,9 @@ static const struct mm_walk_ops damon_young_ops = {
 	.walk_lock = PGWALK_RDLOCK,
 };
 
-static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
-		unsigned long *folio_sz)
+static bool damon_va_young(struct mm_struct *mm, unsigned long addr)
 {
 	struct damon_young_walk_private arg = {
-		.folio_sz = folio_sz,
 		.young = false,
 	};
 
@@ -556,25 +549,13 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
  * r	the region to be checked
  */
 static void __damon_va_check_access(struct mm_struct *mm,
-				struct damon_region *r, bool same_target)
+				struct damon_region *r)
 {
-	static unsigned long last_addr;
-	static unsigned long last_folio_sz = PAGE_SIZE;
-	static bool last_accessed;
-
-	/* If the region is in the last checked page, reuse the result */
-	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
-		if (last_accessed)
-			r->nr_accesses++;
-		return;
-	}
+	bool accessed;
 
-	last_accessed = damon_va_young(mm, r->sampling_addr, &last_folio_sz);
-	if (last_accessed)
+	accessed = damon_va_young(mm, r->sampling_addr);
+	if (accessed)
 		r->nr_accesses++;
-
-	last_addr = r->sampling_addr;
 }
 
 static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
@@ -583,17 +564,14 @@ static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
 	struct mm_struct *mm;
 	struct damon_region *r;
 	unsigned int max_nr_accesses = 0;
-	bool same_target;
 
 	damon_for_each_target(t, ctx) {
 		mm = damon_get_mm(t);
 		if (!mm)
 			continue;
-		same_target = false;
 		damon_for_each_region(r, t) {
-			__damon_va_check_access(mm, r, same_target);
+			__damon_va_check_access(mm, r);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
-			same_target = true;
 		}
 		mmput(mm);
 	}
-- 
2.53.0



