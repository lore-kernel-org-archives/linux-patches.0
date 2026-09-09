Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23A429346F;
	Wed,  9 Sep 2026 14:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964857; cv=none; b=obEgesC8OHps6Q2FM7R1OXgeAgUMMUp05RcvOLkd8S3cdw3bYW0r2oC8cBk8BorKrTOvPAykeiqjCjsvjQHW19g5sJrtdjjFz6LVPVXwen0zvHsSuDB3rFMhv4n6o2DBe6x0jdY4FxP11sd0RDVjGAK9i3g6IGeXxYn6XSo3m4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964857; c=relaxed/simple;
	bh=+MRL7buD9+ItQZht275Y4wpyAqqaq4g7uinZ/zvjH0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oz+pcnYqkmRzeKKTDR044a3Yuz2ssW5f7OXntrqOHUVHLSUz7nAKs2CZzomGyrwrErcT5p53isIF+b6UCfG3jzA+qbqcSgElSbA+FZxUO4rzDOrT0H9iuenGCYcT84MBUn/Wx+5LphS98qx7qvLL9vfNylLBpvTv18TBFVREgzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSsM5+Eg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSsM5+Eg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D041F00A3D;
	Wed,  9 Sep 2026 14:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964855;
	bh=qu+Xa0NNmp8pgEvPd/DSR9UMxvC3mSSbNvVUFz9I11c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSsM5+EgglDTQ8TNRvwZ/yG/gjFBoo+9ZpZuwXfyoRitkwSDKSUnVjvFcnYtsZmDx
	 af0qEtAD/5ejpT/X3Dgq4Fh0eHfsNFPVfOJA1W/k8Fbp0BJ5nda1GqaAb24fX4uDdU
	 XshaFBCdh5Dw7dTBrvPqfmkXQWuNwsmJHNefkG8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 568/583] mm/damon/vaddr: drop last same folio access check optimization
Date: Wed,  9 Sep 2026 15:44:13 +0200
Message-ID: <20260909134257.389664129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit 831846078caa14b7d00b2ccca8b8fe522afe3204 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/vaddr.c |   34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -431,8 +431,6 @@ static void damon_va_prepare_access_chec
 }
 
 struct damon_young_walk_private {
-	/* size of the folio for the access checked virtual memory address */
-	unsigned long *folio_sz;
 	bool young;
 };
 
@@ -468,7 +466,6 @@ static int damon_young_pmd_entry(pmd_t *
 					mmu_notifier_test_young(walk->mm,
 						addr))
 			priv->young = true;
-		*priv->folio_sz = HPAGE_PMD_SIZE;
 		folio_put(folio);
 huge_out:
 		spin_unlock(ptl);
@@ -490,7 +487,6 @@ regular_page:
 	if (pte_young(ptent) || !folio_test_idle(folio) ||
 			mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	*priv->folio_sz = folio_size(folio);
 	folio_put(folio);
 out:
 	pte_unmap_unlock(pte, ptl);
@@ -519,7 +515,6 @@ static int damon_young_hugetlb_entry(pte
 	if (pte_young(entry) || !folio_test_idle(folio) ||
 	    mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	*priv->folio_sz = huge_page_size(h);
 
 	folio_put(folio);
 
@@ -537,11 +532,9 @@ static const struct mm_walk_ops damon_yo
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
 
@@ -558,29 +551,18 @@ static bool damon_va_young(struct mm_str
  * r	the region to be checked
  */
 static void __damon_va_check_access(struct mm_struct *mm,
-				struct damon_region *r, bool same_target,
+				struct damon_region *r,
 				struct damon_attrs *attrs)
 {
-	static unsigned long last_addr;
-	static unsigned long last_folio_sz = PAGE_SIZE;
-	static bool last_accessed;
+	bool accessed;
 
 	if (!mm) {
 		damon_update_region_access_rate(r, false, attrs);
 		return;
 	}
 
-	/* If the region is in the last checked page, reuse the result */
-	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
-		damon_update_region_access_rate(r, last_accessed, attrs);
-		return;
-	}
-
-	last_accessed = damon_va_young(mm, r->sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed, attrs);
-
-	last_addr = r->sampling_addr;
+	accessed = damon_va_young(mm, r->sampling_addr);
+	damon_update_region_access_rate(r, accessed, attrs);
 }
 
 static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
@@ -589,16 +571,12 @@ static unsigned int damon_va_check_acces
 	struct mm_struct *mm;
 	struct damon_region *r;
 	unsigned int max_nr_accesses = 0;
-	bool same_target;
 
 	damon_for_each_target(t, ctx) {
 		mm = damon_get_mm(t);
-		same_target = false;
 		damon_for_each_region(r, t) {
-			__damon_va_check_access(mm, r, same_target,
-					&ctx->attrs);
+			__damon_va_check_access(mm, r, &ctx->attrs);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
-			same_target = true;
 		}
 		if (mm)
 			mmput(mm);


