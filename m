Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211844;
	b=UgqMaqrsJLGjk8v+IuhQaEHZiqL7z2peGucsrUj90E1erDIeFTadbs3AuRhgDpPiH/QT
	 uXHNXyLIj/s1LVuBOrXeGqXlPIesJuH+3/J0WxcKVbqt9bZA78xlV8Bbrug30v/spKIb/
	 CnBf0RIjKyJ9kDpuRnlX/ljgdE+HXw1WCecMhK+5Ft+w2DAyCCZBaXYj3tJV68lqGdJh9
	 xs0W9kGz2pD0PpF8eMp9HNDu+EMLZhCE8H3XZrOvSHpVioKpzewb2uqU7Llq99fWsOrsm
	 qofWneFzYC1qiAokL12QMXY0n+DDuefzkG8bjnpd/q4U8kULqSNt89f/HNgYU18krMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=APTos9o8/QRarZ4GbM1rBHrVQQmSadjc6mx91Nj2s4o=;
	b=QYLyVUqvYmrrYSU23H1MtiyUg4+HhKhxvhYuT9sDFC8La7nXwIhL62s52Wf1w20hFM87
	 EmmRmLh6Ii3qbc+C+vHH4KCVjAUCvx2u1QJqczdyfNCo2IjTcA6H88TTMlzuYcGFSOdI5
	 9BAnKpMJKPzUsCAubSC84mkmO5ICyGdYtesRn22Q+EJ9dobRRuxb33BiayyXzv6c+LSPV
	 2HB55Rv640VXT3NIFRvA50bndKfBVhQ1LR9i65VyB2fJsZRCZ1YFB785G5gbTBuVjAPOL
	 QWRJ649roa80ywYWBQfxqNK14JYEgCF0+BHIf33jtfS1flPpZdS7RZ6MPIUEMmvYDPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b0P0gSis;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF028606A329;
	Wed, 28 Oct 2026 18:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b0P0gSis
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4781D1F01825;
	Wed, 28 Oct 2026 18:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211843;
	bh=APTos9o8/QRarZ4GbM1rBHrVQQmSadjc6mx91Nj2s4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0P0gSiscaNKK4VuGxlpQ/aJ2gu2J18Si2dYk2Ozhe9UBdF3GsuMMLhNqb4oGrpeD
	 JEZd7pCp7xQ8tjkUWACCUPMTN1SvLA0aWE0BlPNhK5sX52hqyPztZoKN4SZ+XS7mHF
	 qco3rKDoY7u7FXoGgFtc5m6kpBM9666VpEtl0t4c=
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
Subject: [PATCH 5.15 521/571] mm/vmalloc: acquire init_mm lock on huge vmap to avoid ptdump UAF
Date: Wed, 28 Oct 2026 18:01:08 +0100
Message-ID: <20261028170020.394835954@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 26444eb71465c9934d9d418ef69c43f61185329b ]

Currently there is a nasty race between ptdump and vmap when attempting to
map a huge P4D, PUD or PMD entry:

* ptdump walks kernel page table ranges it doesn't own.

* When vmap maps ranges it tries to promote existing ones to huge page
  tables in vmap_try_huge_[p4d,pud,pmd]() at P4D, PUD and PMD level,
  freeing the lower page table in [p4d,pud,pmd]_free_[pud,pmd,pte]_page()
  when it succeeds.

Both of these things can happen at the same time and as a result ptdump
can access a freed page table, resulting in a use-after-free and memory
corruption.

This is possible because while ptdump_walk_pgd() holds both the mem
hotplug lock and the mmap write lock before invoking
walk_page_range_novma(), vmap takes no relevant locks at all.

Fix this by holding the mmap read lock in vmap_try_huge_*() when freeing
page tables.

The read lock is sufficient: ptdump is the only walker that must be
excluded and it holds the mmap write lock.  Other holders of the read lock
may run concurrently, but each exclusively owns the range it operates on
and cannot reach the page tables freed here.

We also hold the lock while assigning the huge page table entry, which
means page table walkers observe only the huge or non-huge page table
entry.

We use a trylock to prevent ptdump from blocking vmap making forward
progress.  This is fine because it's an optimisation in any case, and thus
the vmap can safely proceed regardless.

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
[ ljs - Open-coded missing stuff + other smaller changes. Updated commit
   msg to reflect. ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmalloc.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 502f51b86fa37..d87385ed84e12 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -134,6 +134,8 @@ static int vmap_try_huge_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift)
 {
+	int ret = 0;
+
 	if (max_page_shift < PMD_SHIFT)
 		return 0;
 
@@ -149,10 +151,23 @@ static int vmap_try_huge_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
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
 
 static int vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
@@ -184,6 +199,8 @@ static int vmap_try_huge_pud(pud_t *pud, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift)
 {
+	int ret = 0;
+
 	if (max_page_shift < PUD_SHIFT)
 		return 0;
 
@@ -199,10 +216,17 @@ static int vmap_try_huge_pud(pud_t *pud, unsigned long addr, unsigned long end,
 	if (!IS_ALIGNED(phys_addr, PUD_SIZE))
 		return 0;
 
-	if (pud_present(*pud) && !pud_free_pmd_page(pud, addr))
+	if (!pud_present(*pud))
+		return pud_set_huge(pud, phys_addr, prot);
+
+	/* See comment in vmap_try_huge_pmd(). */
+	if (!mmap_read_trylock(&init_mm))
 		return 0;
+	if (pud_free_pmd_page(pud, addr))
+		ret = pud_set_huge(pud, phys_addr, prot);
+	mmap_read_unlock(&init_mm);
 
-	return pud_set_huge(pud, phys_addr, prot);
+	return ret;
 }
 
 static int vmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
@@ -235,6 +259,8 @@ static int vmap_try_huge_p4d(p4d_t *p4d, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift)
 {
+	int ret = 0;
+
 	if (max_page_shift < P4D_SHIFT)
 		return 0;
 
@@ -250,10 +276,17 @@ static int vmap_try_huge_p4d(p4d_t *p4d, unsigned long addr, unsigned long end,
 	if (!IS_ALIGNED(phys_addr, P4D_SIZE))
 		return 0;
 
-	if (p4d_present(*p4d) && !p4d_free_pud_page(p4d, addr))
+	if (!p4d_present(*p4d))
+		return p4d_set_huge(p4d, phys_addr, prot);
+
+	/* See comment in vmap_try_huge_pmd(). */
+	if (!mmap_read_trylock(&init_mm))
 		return 0;
+	if (p4d_free_pud_page(p4d, addr))
+		ret = p4d_set_huge(p4d, phys_addr, prot);
+	mmap_read_unlock(&init_mm);
 
-	return p4d_set_huge(p4d, phys_addr, prot);
+	return ret;
 }
 
 static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
-- 
2.53.0



