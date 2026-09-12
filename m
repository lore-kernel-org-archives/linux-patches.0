Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D1F29DB64;
	Sat, 12 Sep 2026 15:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228688; cv=none; b=eIfnb1ai/zhOTuMY9d5c+Fs4jr2qyzcd9G8rzY1DccD9IMTNnf+ypBXOwmwb3xnew+1pKuh269UFF3csg7Gdkl8zy8H1QvQ4ljq4p/PasQZE5eyJCFKAhe1QMHdfEU53H/tOvnSu4N/Dp2zTumxX73eJ6TAH5HeVmoZpWjdbZ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228688; c=relaxed/simple;
	bh=K1x+cJCJgPVu/oRK26QFEG7Ufyd3eEjdC4nAxyKqXKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSu1horbL0B3hiHDGSFGW2uI1xleb2ukQ0IRl6WXYD4TTgAyL3x/LE6/wYavym5RJ7sprlvOjuT3ulBB04fxVVSGKrbxwgeJkHN3LCt81SZayHvcDjr1CsrEUJru99aj50RwDNbla859kveEucmmTZgTpFRSHWCamoejxfPw3ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hL6nvAX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hL6nvAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122C01F000FF;
	Sat, 12 Sep 2026 15:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228687;
	bh=7yel8AspmeOQFjLOdX3o5LKrzgpV4R3L7nWwIwSJPBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hL6nvAXe/JOssxhw/k/BW59JFWXudkgbQEhk0M0tcxMMsq8KAaLe0NFmuMIsxL6m
	 k/s/8neX+yRvQ93BLi6B/gdnpUdOMOkiJZKTpyTShltO1uuCj33rsZgyQj73q7lS+2
	 3yzVAr6PiraoJZNlTj/Kgn7hbeWFMV478znW/bJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0436/1191] mm/damon/vaddr: drop last same folio access check optimization
Date: Sat, 12 Sep 2026 08:52:44 +0200
Message-ID: <20260912065558.027001214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 mm/damon/vaddr.c | 42 +++++++++---------------------------------
 1 file changed, 9 insertions(+), 33 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 708f281c1b6b4..4aa89347d754d 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -424,7 +424,6 @@ static void damon_va_prepare_access_checks(struct damon_ctx *ctx)
 }
 
 struct damon_young_walk_private {
-	unsigned long *page_sz;
 	bool young;
 };
 
@@ -453,10 +452,8 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 			goto huge_out;
 		if (pmd_young(*pmd) || !page_is_idle(page) ||
 					mmu_notifier_test_young(walk->mm,
-						addr)) {
-			*priv->page_sz = HPAGE_PMD_SIZE;
+						addr))
 			priv->young = true;
-		}
 		put_page(page);
 huge_out:
 		spin_unlock(ptl);
@@ -475,10 +472,8 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 	if (!page)
 		goto out;
 	if (pte_young(*pte) || !page_is_idle(page) ||
-			mmu_notifier_test_young(walk->mm, addr)) {
-		*priv->page_sz = PAGE_SIZE;
+			mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	}
 	put_page(page);
 out:
 	pte_unmap_unlock(pte, ptl);
@@ -505,10 +500,8 @@ static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	get_page(page);
 
 	if (pte_young(entry) || !page_is_idle(page) ||
-	    mmu_notifier_test_young(walk->mm, addr)) {
-		*priv->page_sz = huge_page_size(h);
+	    mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	}
 
 	put_page(page);
 
@@ -525,11 +518,9 @@ static const struct mm_walk_ops damon_young_ops = {
 	.hugetlb_entry = damon_young_hugetlb_entry,
 };
 
-static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
-		unsigned long *page_sz)
+static bool damon_va_young(struct mm_struct *mm, unsigned long addr)
 {
 	struct damon_young_walk_private arg = {
-		.page_sz = page_sz,
 		.young = false,
 	};
 
@@ -546,25 +537,13 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
  * r	the region to be checked
  */
 static void __damon_va_check_access(struct mm_struct *mm,
-				struct damon_region *r, bool same_target)
+				struct damon_region *r)
 {
-	static unsigned long last_addr;
-	static unsigned long last_page_sz = PAGE_SIZE;
-	static bool last_accessed;
-
-	/* If the region is in the last checked page, reuse the result */
-	if (same_target && (ALIGN_DOWN(last_addr, last_page_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_page_sz))) {
-		if (last_accessed)
-			r->nr_accesses++;
-		return;
-	}
+	bool accessed;
 
-	last_accessed = damon_va_young(mm, r->sampling_addr, &last_page_sz);
-	if (last_accessed)
+	accessed = damon_va_young(mm, r->sampling_addr);
+	if (accessed)
 		r->nr_accesses++;
-
-	last_addr = r->sampling_addr;
 }
 
 static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
@@ -573,17 +552,14 @@ static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
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



