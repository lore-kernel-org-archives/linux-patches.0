Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591592;
	b=vTjxBqmqM8dxIacYHd7PrwJe1Cb8KmpAEpKk+4t76zOO1S02IyYnBB24WXWsKlVOshTz
	 DOnprTXVOyQSnEcdnpLtvc1u0/RnjDSSlq8QBgtPl99sf52SRZ+liP+GLhbxatPLxCJv4
	 K8UoI/AE7yZ0WCEHWD41sXu3Et6kp2N7373LNeYGobOxM+50R+xirVk7bm4DlQNlLMD+o
	 O26Lv7mtqIuELANg+IWEV0uHTRCqlGx+nw5ftlc/LeGwoBNkjLt5kGuIwaq+aQ7W6kZOU
	 XM0YX/D2D8Lwu15DYzyxd1u41h9ctEoEg/XiS4H0AB3eDFl/71T1QEoJxzvgS3wviOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r1o8ZzlAVABMGpwqP2FXMjDLf+HlVU8JY9vcTYmE6ao=;
	b=Ui/rRP+Ibh4719o9hHeWBFKZDenLiokGtrp896xq3m/Xlejc/hZ0QElJjmIwVzLg0X9A
	 LH4zFbFM/AwZoUXHq3mYD0E1EGlg98VtksWhA3DVn5Onuej5I5YL3gUIBICJ8PL79Q2+9
	 hxBnxGHHT5iBmr1JO/GeHSxS6Ci0wD+h5pMLX0rP+I5i4o32wJX4wb/dCFYqanG0aOMnT
	 p2irUpMdUk/NHsRlTeW8soGLI6E7+UccHyILXUjoqoft8P1Khx+XQEOo6OPGg5T8gJmWv
	 QUt/byz25YdnGVh92BwhdcwdGbTa/pEjeujmXm+9ZpYMYl3saSZR0TutbxgW9rV4AFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3A8NFPf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1337A606B445;
	Fri, 13 Nov 2026 17:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3A8NFPf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5181F000C4;
	Fri, 13 Nov 2026 17:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591591;
	bh=r1o8ZzlAVABMGpwqP2FXMjDLf+HlVU8JY9vcTYmE6ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q3A8NFPfsBU8z/Bk8LOz+Wbcs7BQMnSczcWw1EMhzzrv5uWf4zQTsGWZyJmpIJUfj
	 NaAlv817QOr55AlyaaUzhSlB2m0y9Sv1CQ9w+u1JUaoxDl1822jgGp86vPFJUYgZpe
	 J8LNlsEv76h+mU4sjl0FvQtWsnJkz6N7unud4BSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 636/670] mm/huge_memory: split huge PUDs when adjusting VMA boundaries
Date: Fri, 13 Nov 2026 10:53:20 -0500
Message-ID: <20261113153833.355176540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted huge-page splitting helpers to the older VMA and page-table interfaces ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 70 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 60 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d175e93988a92..ce4d17871ff43 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2988,16 +2988,66 @@ void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
 	__split_huge_pmd(vma, pmd, address, freeze, folio);
 }
 
-static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned long address)
+static bool pud_split_required(struct vm_area_struct *vma,
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
-		split_huge_pmd_address(vma, address, false, NULL);
+	if (!vma_is_dax(vma) && !(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
+		return false;
+	return range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PUD_SIZE),
+			    ALIGN(address, HPAGE_PUD_SIZE));
+}
+
+static bool pmd_split_required(struct vm_area_struct *vma,
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
+	__split_huge_pmd(vma, pmd, address, false, NULL);
 }
 
 void vma_adjust_trans_huge(struct vm_area_struct *vma,
@@ -3006,10 +3056,10 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
 			     long adjust_next)
 {
 	/* Check if we need to split start first. */
-	split_huge_pmd_if_needed(vma, start);
+	split_huge_leaf(vma, start);
 
 	/* Check if we need to split end next. */
-	split_huge_pmd_if_needed(vma, end);
+	split_huge_leaf(vma, end);
 
 	/*
 	 * If we're also updating the next vma vm_start,
@@ -3019,7 +3069,7 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
 		struct vm_area_struct *next = find_vma(vma->vm_mm, vma->vm_end);
 		unsigned long nstart = next->vm_start;
 		nstart += adjust_next;
-		split_huge_pmd_if_needed(next, nstart);
+		split_huge_leaf(next, nstart);
 	}
 }
 
-- 
2.53.0



