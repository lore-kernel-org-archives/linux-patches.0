Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590757;
	b=Q0GoE3ar3FNhOw8I/Y48KgSuANHMWLy0aHGisbiXzmIxOZJh5EuTiq8mlDkvKXqEeMMl
	 adXJ2077D72c6478G+3JNZp/GG2HpUXPYOz0BvEKwae10hbukdp+NYGqJZ/i4HWTWtrg5
	 dFcM0MwRv1/mSMdiDhtJ0wwIiX39HKirF8+HCy1AE8GKXTdpKyBCamBrkxjJ4G/BdUiDh
	 aFrd9uFuRusLCPpuTriYfhRHoIgS/VDy5VMK6va0cwde0Fo/yicLwuwkotAp99sSo8Iwy
	 sgrqEl08krSzQTmKdGCh3s/4rIRQbguHq8/dPfH4GK00xiBUOiGfhNtSb5ff+8LzzMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FOo5Eh2q/GV3gk4RleaAZDwFBDRyJQnXrUinhWktmCU=;
	b=F2dtdFQs73HWDvoXHOE+9LUqGoiKqEbyi/R66DOXvAYdTjoAXfK4PRqMj6Ipxrk2jPfe
	 y8IqUoqWKNyZrKGNE7aH2hamBVPh3Eb3cKfnNAB31n52qh/LQ3vv6yP1gJXPvjk8JHmT6
	 kGCJ8BofajFJTdf7SRt3DjPNZZSyMGq2WmKJuQPI7cUNaTOdh6syqHnw8rOgEzj8eP4Fz
	 E8EWYaMFbgd+qIFagp/A6IkSXw9lw8COw3NtD3gSVv9nzLfOrSunqn8p0C2ViC/jSENE2
	 qtB7PjtWwCNhkEmnH1FEYQJX9hf/vQt58fOIBHOsxWXME6ZQSsEgUnUL7K2+q3pHWjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LmXspyXI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817CF607C34D;
	Fri, 13 Nov 2026 17:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LmXspyXI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2715B1F000C4;
	Fri, 13 Nov 2026 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590757;
	bh=FOo5Eh2q/GV3gk4RleaAZDwFBDRyJQnXrUinhWktmCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LmXspyXIa1merq+KKaDtTIDINC0BnFjKXH+F6CBdEKO9tBiG4Uq7INZZN251auSq6
	 QQn2deWpN9iGLC2ZVcPmXw4nLgUYPpCksNMD+g3hT10K+XikmUvpSkOLLTCaU6f1D3
	 b/p/0xWbLfv1Yb5eYnSGUNyM1IFILturarEi/ruE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 658/686] mm/huge_memory: split huge PUDs when adjusting VMA boundaries
Date: Fri, 13 Nov 2026 10:53:11 -0500
Message-ID: <20261113153844.025399328@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 23e570927421d569fdc510d5f3f29542a43eeda5 ]

PFN mappings such as VFIO PCI BAR mappings can use PUD leaves while
allowing VMA splits at page granularity. However, vma_adjust_trans_huge()
only handles PMDs.

After faulting a writable PUD-sized VFIO BAR mapping, changing its first
page to read-only with mprotect() makes the PMD walk treat the PUD leaf
as a PMD table. Applying MADV_DONTFORK to the first PMD-sized chunk leaves
the PUD spanning two VMAs: the PMD-aligned boundary skips splitting.

Walk the page tables once at each adjusted boundary and split a huge
PUD or PMD leaf as needed. Handle PUD leaves even when the boundary is
PMD-aligned.

Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
Cc: stable@vger.kernel.org
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Link: https://patch.msgid.link/20261031-fixes_core-v3-43-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Replaced vma_test_any() with a direct vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) test. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 70 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 60 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 78fecc3ad5700..24f5887eb48ee 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3210,16 +3210,66 @@ void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
 	__split_huge_pmd(vma, pmd, address, freeze);
 }
 
-static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned long address)
+static bool pud_split_required(const struct vm_area_struct *vma,
+		unsigned long address)
 {
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
+		return false;
+	if (IS_ALIGNED(address, HPAGE_PUD_SIZE))
+		return false;
 	/*
-	 * If the new address isn't hpage aligned and it could previously
-	 * contain an hugepage: check if we need to split an huge pmd.
+	 * Only selected VMAs support mapping PUDs for now. Lift the
+	 * restriction once this changes.
 	 */
-	if (!IS_ALIGNED(address, HPAGE_PMD_SIZE) &&
-	    range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
-			 ALIGN(address, HPAGE_PMD_SIZE)))
-		split_huge_pmd_address(vma, address, false);
+	if (!vma_is_dax(vma) && !(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
+		return false;
+	return range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PUD_SIZE),
+			    ALIGN(address, HPAGE_PUD_SIZE));
+}
+
+static bool pmd_split_required(const struct vm_area_struct *vma,
+		unsigned long address)
+{
+	if (IS_ALIGNED(address, HPAGE_PMD_SIZE))
+		return false;
+
+	return range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
+			    ALIGN(address, HPAGE_PMD_SIZE));
+}
+
+static void split_huge_leaf(struct vm_area_struct *vma,
+		unsigned long address)
+{
+	const bool split_pud = pud_split_required(vma, address);
+	const bool split_pmd = pmd_split_required(vma, address);
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	/*
+	 * mmap, VMA and rmap write locks protect the walk; the split helpers
+	 * take the page table locks.
+	 */
+	if (!split_pud && !split_pmd)
+		return;
+
+	pgd = pgd_offset(vma->vm_mm, address);
+	if (!pgd_present(*pgd))
+		return;
+
+	p4d = p4d_offset(pgd, address);
+	if (!p4d_present(*p4d))
+		return;
+
+	pud = pud_offset(p4d, address);
+	if (pud_leaf(*pud))
+		__split_huge_pud(vma, pud, address);
+	if (!split_pmd || !pud_present(*pud))
+		return;
+
+	pmd = pmd_offset(pud, address);
+	__split_huge_pmd(vma, pmd, address, false);
 }
 
 void vma_adjust_trans_huge(struct vm_area_struct *vma,
@@ -3228,14 +3278,14 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
 			   struct vm_area_struct *next)
 {
 	/* Check if we need to split start first. */
-	split_huge_pmd_if_needed(vma, start);
+	split_huge_leaf(vma, start);
 
 	/* Check if we need to split end next. */
-	split_huge_pmd_if_needed(vma, end);
+	split_huge_leaf(vma, end);
 
 	/* If we're incrementing next->vm_start, we might need to split it. */
 	if (next)
-		split_huge_pmd_if_needed(next, end);
+		split_huge_leaf(next, end);
 }
 
 static void unmap_folio(struct folio *folio)
-- 
2.53.0



