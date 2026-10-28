Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209447;
	b=m5x3xlsDfUCZ8hhBJXyc7xs5YpQNK7A/Ov7ouu4gWmaWXuWDXg5zJu8uTFmADSYYcp0U
	 Y64Zs9ZSo0JZb4ACVFyKMK1MvfElQ/anhcMyvj92//FIOYDnCKBubra/mdugNyD/u0lrx
	 x8+arLFkW7hfust4GMr+FSH8PPmfs8/RiysFW7hosaObsHAPmtL3Afh5l2Yb3wO3khTfm
	 HrMDEwxmqQoGFTTDYdhavgfaezRIOpaKXJ3AfEeAQil0c3A+tjZlxePbamoAOUasmEz0B
	 GrFrOJ4Dx6WdaeE79SW/8d+gVNpPZ5d9p8kQcssjCz1VVE7/cm8XKMDJRfSV/hwOI4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dSn2FPkkolOdu9CzkVlDooP1Emp67HylTvxQNVPqVN8=;
	b=lamoyzgNCOeXyuNTx/z43HA/dsqjO5UxMcK8jt+u0qAgwDZDT2BMmYaDwd2cxlOfvOUv
	 p64bc0rwVujSoXtjsWV8YGwHxf8wvyB7J6tFZ2YMBQuzhNT5UEXsT2SZou0iU/31bSDPH
	 9gcGekx9YyKf8UOOTOI09HbaBwHvx+VccOgz7Y56x/qZItT5QowN4kgWwyAZNMKNs+o7s
	 4wqkWqwJTWoZCOcxrjD6tmA/kjzQ8UEUEhhfy1B1BUFhtLVxk+/gkbAiKTREv79luIszI
	 MP3iy149JiYRlybGHHJ6gPnBwtOZtyfvG+5HGy0Z9zwWDBem0oV0SgmUU+zqG4i79vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fB5UjU/g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F6F606A31D;
	Wed, 28 Oct 2026 17:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fB5UjU/g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54741F01825;
	Wed, 28 Oct 2026 17:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209446;
	bh=dSn2FPkkolOdu9CzkVlDooP1Emp67HylTvxQNVPqVN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fB5UjU/gWVbSwu79yJMyEYm50e8bcb+2yfhG4HZLyVjC+wzzII6GwwPmScpOfM5QR
	 BFfv0nEzD/LnadNCEkJq5Iokxtd3qKxtcVPRLsM+h6OcXL/IXNm38ZbOuUY0Jyglp/
	 mngo2o8jh6bOA+XZZ1qYSCBBWzi0nCWP3wCB335s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 475/516] mm/vmalloc: acquire init_mm lock on huge vmap to avoid ptdump UAF
Date: Wed, 28 Oct 2026 18:00:27 +0100
Message-ID: <20261028170014.733661490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 26444eb71465c9934d9d418ef69c43f61185329b ]

Currently there is a nasty race between ptdump and ioremap when attempting
to map a huge P4D, PUD or PMD entry:

* ptdump walks kernel page table ranges it doesn't own.

* When ioremap maps ranges it tries to promote existing ones to huge
  page tables in ioremap_try_huge_[p4d,pud,pmd]() at P4D, PUD and PMD
  level, freeing the lower page table in
  [p4d,pud,pmd]_free_[pud,pmd,pte]_page() when it succeeds.

Both of these things can happen at the same time and as a result ptdump
can access a freed page table, resulting in a use-after-free and memory
corruption.

This is possible because while ptdump_walk_pgd() holds both the mem
hotplug lock and the mmap write lock before invoking
walk_page_range_novma(), ioremap takes no relevant locks at all.

Fix this by holding the mmap read lock in ioremap_try_huge_*() when freeing
page tables.

The read lock is sufficient: ptdump is the only walker that must be
excluded and it holds the mmap write lock.  Other holders of the read lock
may run concurrently, but each exclusively owns the range it operates on
and cannot reach the page tables freed here.

We also hold the lock while assigning the huge page table entry, which
means page table walkers observe only the huge or non-huge page table
entry.

We use a trylock to prevent ptdump from blocking ioremap making forward
progress.  This is fine because it's an optimisation in any case, and thus
the ioremap can safely proceed regardless.

All other kernel page table walkers that touch vmalloc ranges either
exclusively own the memory walked or acquire the mmap lock, so this
correctly excludes those walkers.

The issue has existed as long as ptdump was available and vmap freed page
tables when promoting to a huge leaf entry, that is, since commit
b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
for huge ioremap, and commit 121e6f3258fe ("mm/vmalloc: hugepage vmalloc
mappings") for huge vmalloc.

Since the former is the earlier of the two we choose that for our Fixes
tag.

This patch is based on work by David Carlier (linked), with gratitude!

Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
Link: https://lore.kernel.org/linux-mm/20260706203128.162335-1-devnexen@gmail.com/
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ ljs - Applied to ioremap_try_huge_*() in mm/ioremap.c, open-coded missing
   stuff + other smaller changes. Updated commit msg to reflect. ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ioremap.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/mm/ioremap.c b/mm/ioremap.c
index 5fa1ab41d1526..0f3087e4ea9ef 100644
--- a/mm/ioremap.c
+++ b/mm/ioremap.c
@@ -85,6 +85,8 @@ static int ioremap_try_huge_pmd(pmd_t *pmd, unsigned long addr,
 				unsigned long end, phys_addr_t phys_addr,
 				pgprot_t prot)
 {
+	int ret = 0;
+
 	if (!ioremap_pmd_enabled())
 		return 0;
 
@@ -97,10 +99,23 @@ static int ioremap_try_huge_pmd(pmd_t *pmd, unsigned long addr,
 	if (!IS_ALIGNED(phys_addr, PMD_SIZE))
 		return 0;
 
-	if (pmd_present(*pmd) && !pmd_free_pte_page(pmd, addr))
+	if (!pmd_present(*pmd))
+		return pmd_set_huge(pmd, phys_addr, prot);
+
+	/*
+	 * Acquire the mmap read lock to exclude ptdump, which walks
+	 * kernel page tables it does not own under the mmap write lock.
+	 *
+	 * Concurrent read lock holders are safe: each exclusively owns
+	 * the range it operates on and cannot reach this page table.
+	 */
+	if (!mmap_read_trylock(&init_mm))
 		return 0;
+	if (pmd_free_pte_page(pmd, addr))
+		ret = pmd_set_huge(pmd, phys_addr, prot);
+	mmap_read_unlock(&init_mm);
 
-	return pmd_set_huge(pmd, phys_addr, prot);
+	return ret;
 }
 
 static inline int ioremap_pmd_range(pud_t *pud, unsigned long addr,
@@ -131,6 +146,8 @@ static int ioremap_try_huge_pud(pud_t *pud, unsigned long addr,
 				unsigned long end, phys_addr_t phys_addr,
 				pgprot_t prot)
 {
+	int ret = 0;
+
 	if (!ioremap_pud_enabled())
 		return 0;
 
@@ -143,10 +160,17 @@ static int ioremap_try_huge_pud(pud_t *pud, unsigned long addr,
 	if (!IS_ALIGNED(phys_addr, PUD_SIZE))
 		return 0;
 
-	if (pud_present(*pud) && !pud_free_pmd_page(pud, addr))
+	if (!pud_present(*pud))
+		return pud_set_huge(pud, phys_addr, prot);
+
+	/* See comment in ioremap_try_huge_pmd(). */
+	if (!mmap_read_trylock(&init_mm))
 		return 0;
+	if (pud_free_pmd_page(pud, addr))
+		ret = pud_set_huge(pud, phys_addr, prot);
+	mmap_read_unlock(&init_mm);
 
-	return pud_set_huge(pud, phys_addr, prot);
+	return ret;
 }
 
 static inline int ioremap_pud_range(p4d_t *p4d, unsigned long addr,
@@ -177,6 +201,8 @@ static int ioremap_try_huge_p4d(p4d_t *p4d, unsigned long addr,
 				unsigned long end, phys_addr_t phys_addr,
 				pgprot_t prot)
 {
+	int ret = 0;
+
 	if (!ioremap_p4d_enabled())
 		return 0;
 
@@ -189,10 +215,17 @@ static int ioremap_try_huge_p4d(p4d_t *p4d, unsigned long addr,
 	if (!IS_ALIGNED(phys_addr, P4D_SIZE))
 		return 0;
 
-	if (p4d_present(*p4d) && !p4d_free_pud_page(p4d, addr))
+	if (!p4d_present(*p4d))
+		return p4d_set_huge(p4d, phys_addr, prot);
+
+	/* See comment in ioremap_try_huge_pmd(). */
+	if (!mmap_read_trylock(&init_mm))
 		return 0;
+	if (p4d_free_pud_page(p4d, addr))
+		ret = p4d_set_huge(p4d, phys_addr, prot);
+	mmap_read_unlock(&init_mm);
 
-	return p4d_set_huge(p4d, phys_addr, prot);
+	return ret;
 }
 
 static inline int ioremap_p4d_range(pgd_t *pgd, unsigned long addr,
-- 
2.53.0



