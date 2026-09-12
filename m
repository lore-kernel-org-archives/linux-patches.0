Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593E335DA40;
	Sat, 12 Sep 2026 18:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238002; cv=none; b=KHn1FfBHvjF7VIog26wDM4N86PjPbK9SOVa+Ul10L6aW9kWANU4X2pL2IAq+k+mvn8sqw1OOQz4n64h1zUaXexaKGILpnKW3fD8o0DdAKJiky+pCzpXBbhwt3u1LboGo2B0Na3n51hG2KgLY+zCF+Ek64YQF73/sy/ozBw2s+gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238002; c=relaxed/simple;
	bh=Ci/t/LyfDXgZqUkthpM6I13Ns8Gffxg3IhYFr72c5M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPlldENTBC3kyv6W55P2HnGoEGe5COpHHrMtBD0FglvrD0r+kmJJGs5vwJdP1xty2q80/wSpzKkk50fBNVP03RpQ1sn2LUJoNRM0WNBjum9GRyIlqMz8kn6ob5oHjbAk5Aij3Na4o7V84bK9fGHbQB3cB3U65Bdek4vH8ahxCog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztx2rw3P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztx2rw3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889E61F000FF;
	Sat, 12 Sep 2026 18:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238001;
	bh=eLrWyS+CrCv3BGsS85jrthj0TA2sC6/SqULAf97guUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztx2rw3P7Ef8T7K774u+No7dVhCR80kGh2tWww5/MYdEnO/egKoX/qz1MbjCcvkf+
	 vG06EgIbqVvkd2AvuQEjS6cUPj3O4yPFhpWIgdFu3W3VQGrdUsSlDz5fPMV/o88iQO
	 CtL19qvupauu9iqSqAZBaOtPi122VtMFH4CTOmt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 373/935] mm/damon/vaddr: drop last same folio access check optimization
Date: Sat, 12 Sep 2026 08:56:43 +0200
Message-ID: <20260912065535.367861716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 mm/damon/vaddr.c | 33 ++++++---------------------------
 1 file changed, 6 insertions(+), 27 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index dbb0f0fb2e598..bc0034b235d83 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -516,7 +516,6 @@ void damon_va_prepare_access_checks(struct damon_ctx *ctx)
 }
 
 struct damon_young_walk_private {
-	unsigned long *page_sz;
 	bool young;
 };
 
@@ -545,10 +544,8 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 			goto huge_out;
 		if (pmd_young(*pmd) || !page_is_idle(page) ||
 					mmu_notifier_test_young(walk->mm,
-						addr)) {
-			*priv->page_sz = ((1UL) << HPAGE_PMD_SHIFT);
+						addr))
 			priv->young = true;
-		}
 		put_page(page);
 huge_out:
 		spin_unlock(ptl);
@@ -567,10 +564,8 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
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
@@ -581,11 +576,9 @@ static struct mm_walk_ops damon_young_ops = {
 	.pmd_entry = damon_young_pmd_entry,
 };
 
-static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
-		unsigned long *page_sz)
+static bool damon_va_young(struct mm_struct *mm, unsigned long addr)
 {
 	struct damon_young_walk_private arg = {
-		.page_sz = page_sz,
 		.young = false,
 	};
 
@@ -604,25 +597,11 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
 static void damon_va_check_access(struct damon_ctx *ctx,
 			       struct mm_struct *mm, struct damon_region *r)
 {
-	static struct mm_struct *last_mm;
-	static unsigned long last_addr;
-	static unsigned long last_page_sz = PAGE_SIZE;
-	static bool last_accessed;
-
-	/* If the region is in the last checked page, reuse the result */
-	if (mm == last_mm && (ALIGN_DOWN(last_addr, last_page_sz) ==
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
-	last_mm = mm;
-	last_addr = r->sampling_addr;
 }
 
 unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
-- 
2.53.0



