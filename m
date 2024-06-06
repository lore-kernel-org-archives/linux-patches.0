Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0303C197A76;
	Thu,  6 Jun 2024 14:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683229; cv=none; b=h4OmwhytqW+UHYtQPSd50s4bI9dHNctvoB9RFRLbBskvkxR400a2ug4Fjpl7+F7MwrFY/2kx4eB8ex8xf4djoqWa8i9bjKWW9xapeDR4wjSxtDfMXb45dpo5EmdFh1GR/mHeJ/Qv7lKSQBfZpPvNn30Dq28xV5RWxa6zURAY8bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683229; c=relaxed/simple;
	bh=pmm0vainrAqkhbNYttD1fZ5SEPf2EAjufHn1CcFNa6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0k5GLPKKjHo+vCRdtJtNj7AUtJQEa8ZuhDkMpSWW2Vi7blaOowjBi+kpbZRx9DRs/as/5keDPeQPswmiJa2alyO+I5vM7l96EvVoRih4ka2iA5UyPbbWL17Tfkof0YFZqYscWWPjtN88CR3XKxvgvN4Q1xZA5FH7iuCEat1hg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXucvda2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXucvda2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3898C2BD10;
	Thu,  6 Jun 2024 14:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683228;
	bh=pmm0vainrAqkhbNYttD1fZ5SEPf2EAjufHn1CcFNa6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXucvda2d7Eu+d15Owa5S2XMpW22NRmJIwQrAOt9xaG6sku/vUPhdnsWG0mep5f1y
	 l3Am71wEta7Boc3kcC6BloV2CVWj76SZdDgvBOBhqrNqy8WbbSTVfOb7xUPoZdi1l+
	 dWPv8usrQEEZyXGyO8aSummzMRQNeNtoHGKfHDTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/744] x86/pat: Introduce lookup_address_in_pgd_attr()
Date: Thu,  6 Jun 2024 15:57:22 +0200
Message-ID: <20240606131737.875336117@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit ceb647b4b529fdeca9021cd34486f5a170746bda ]

Add lookup_address_in_pgd_attr() doing the same as the already
existing lookup_address_in_pgd(), but returning the effective settings
of the NX and RW bits of all walked page table levels, too.

This will be needed in order to match hardware behavior when looking
for effective access rights, especially for detecting writable code
pages.

In order to avoid code duplication, let lookup_address_in_pgd() call
lookup_address_in_pgd_attr() with dummy parameters.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20240412151258.9171-2-jgross@suse.com
Stable-dep-of: 5bc8b0f5dac0 ("x86/pat: Fix W^X violation false-positives when running as Xen PV guest")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/pgtable_types.h |  2 ++
 arch/x86/mm/pat/set_memory.c         | 33 +++++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 9abb8cc4cd474..b786449626267 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -567,6 +567,8 @@ static inline void update_page_count(int level, unsigned long pages) { }
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
 extern pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
 				    unsigned int *level);
+pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
+				  unsigned int *level, bool *nx, bool *rw);
 extern pmd_t *lookup_pmd_address(unsigned long address);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 extern int __init kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn,
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index f3c4c756fe1ee..1132d222ade82 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -657,20 +657,26 @@ static inline pgprot_t verify_rwx(pgprot_t old, pgprot_t new, unsigned long star
 
 /*
  * Lookup the page table entry for a virtual address in a specific pgd.
- * Return a pointer to the entry and the level of the mapping.
+ * Return a pointer to the entry, the level of the mapping, and the effective
+ * NX and RW bits of all page table levels.
  */
-pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
-			     unsigned int *level)
+pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
+				  unsigned int *level, bool *nx, bool *rw)
 {
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
 
 	*level = PG_LEVEL_NONE;
+	*nx = false;
+	*rw = true;
 
 	if (pgd_none(*pgd))
 		return NULL;
 
+	*nx |= pgd_flags(*pgd) & _PAGE_NX;
+	*rw &= pgd_flags(*pgd) & _PAGE_RW;
+
 	p4d = p4d_offset(pgd, address);
 	if (p4d_none(*p4d))
 		return NULL;
@@ -679,6 +685,9 @@ pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
 	if (p4d_large(*p4d) || !p4d_present(*p4d))
 		return (pte_t *)p4d;
 
+	*nx |= p4d_flags(*p4d) & _PAGE_NX;
+	*rw &= p4d_flags(*p4d) & _PAGE_RW;
+
 	pud = pud_offset(p4d, address);
 	if (pud_none(*pud))
 		return NULL;
@@ -687,6 +696,9 @@ pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
 	if (pud_leaf(*pud) || !pud_present(*pud))
 		return (pte_t *)pud;
 
+	*nx |= pud_flags(*pud) & _PAGE_NX;
+	*rw &= pud_flags(*pud) & _PAGE_RW;
+
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
 		return NULL;
@@ -695,11 +707,26 @@ pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
 	if (pmd_large(*pmd) || !pmd_present(*pmd))
 		return (pte_t *)pmd;
 
+	*nx |= pmd_flags(*pmd) & _PAGE_NX;
+	*rw &= pmd_flags(*pmd) & _PAGE_RW;
+
 	*level = PG_LEVEL_4K;
 
 	return pte_offset_kernel(pmd, address);
 }
 
+/*
+ * Lookup the page table entry for a virtual address in a specific pgd.
+ * Return a pointer to the entry and the level of the mapping.
+ */
+pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
+			     unsigned int *level)
+{
+	bool nx, rw;
+
+	return lookup_address_in_pgd_attr(pgd, address, level, &nx, &rw);
+}
+
 /*
  * Lookup the page table entry for a virtual address. Return a pointer
  * to the entry and the level of the mapping.
-- 
2.43.0



