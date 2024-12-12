Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087FB21578A;
	Thu, 12 Dec 2024 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016448; cv=none; b=UHNs7WrBDPUUtagbaSbED+sw8iuUpUNeC7b/tC3C7rRyGHTAgmzaEj4CKXNElmjyhoOrYuWYn+eaYfy68SbvYAnH1p3pykF+oCoQmfWxbHjCeGr1OQTqPL+RWi8SR8I2s77bo/ONnH9BgXub/HIZlAvtL0uKnMUoTMPZwKLzDVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016448; c=relaxed/simple;
	bh=B6W8N8zCdgy8hyHQZLvGlXpZnpvNL+KkAVevxGWMuMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3Y0QWemQkkIxcS+My/CyruP3CBSDzGGRxsAY0unuGKS8vuqF43PvjTSw/4QpjdGOJggr0F9c50hZvUVwfdn8K0fB5I9GVqVl8aGzE448knbhtLxZDhWZAYM8UeSap8XRwcbKGmr0YWkaKaCh5WHY+7/WD77O45IaqBeNE7Hs8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0c2jXCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0c2jXCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A939C4CED0;
	Thu, 12 Dec 2024 15:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016447;
	bh=B6W8N8zCdgy8hyHQZLvGlXpZnpvNL+KkAVevxGWMuMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0c2jXCIhdwrvQTglUUmQ6wQ9hl/TDu7/A8PtcXoi8d1CbVVMHySl/LXKGkAc1CuM
	 fqt8Bj5IhbYBl/DaFITryigzzaXHVHPCMAJqAvuT+GSa2tZiH/QVWyTVwIberEHqnW
	 nbToGS/C/aHWFRjBUOaU7b3r1qv81QmbdewzCR5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@intel.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ingo Molnar <mingo@kernel.org>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH 6.12 202/466] x86/mm: Add _PAGE_NOPTISHADOW bit to avoid updating userspace page tables
Date: Thu, 12 Dec 2024 15:56:11 +0100
Message-ID: <20241212144314.769023779@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

commit d0ceea662d459726487030237689835fcc0483e5 upstream.

The set_p4d() and set_pgd() functions (in 4-level or 5-level page table setups
respectively) assume that the root page table is actually a 8KiB allocation,
with the userspace root immediately after the kernel root page table (so that
the former can enforce NX on on all the subordinate page tables, which are
actually shared).

However, users of the kernel_ident_mapping_init() code do not give it an 8KiB
allocation for its PGD. Both swsusp_arch_resume() and acpi_mp_setup_reset()
allocate only a single 4KiB page. The kexec code on x86_64 currently gets
away with it purely by chance, because it allocates 8KiB for its "control
code page" and then actually uses the first half for the PGD, then copies the
actual trampoline code into the second half only after the identmap code has
finished scribbling over it.

Fix this by defining a _PAGE_NOPTISHADOW bit (which can use the same bit as
_PAGE_SAVED_DIRTY since one is only for the PGD/P4D root and the other is
exclusively for leaf PTEs.). This instructs __pti_set_user_pgtbl() not to
write to the userspace 'shadow' PGD.

Strictly, the _PAGE_NOPTISHADOW bit doesn't need to be written out to the
actual page tables; since __pti_set_user_pgtbl() returns the value to be
written to the kernel page table, it could be filtered out. But there seems
to be no benefit to actually doing so.

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/412c90a4df7aef077141d9f68d19cbe5602d6c6d.camel@infradead.org
Cc: stable@kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/pgtable_types.h |    8 ++++++--
 arch/x86/mm/ident_map.c              |    6 +++---
 arch/x86/mm/pti.c                    |    2 +-
 3 files changed, 10 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -36,10 +36,12 @@
 #define _PAGE_BIT_DEVMAP	_PAGE_BIT_SOFTW4
 
 #ifdef CONFIG_X86_64
-#define _PAGE_BIT_SAVED_DIRTY	_PAGE_BIT_SOFTW5 /* Saved Dirty bit */
+#define _PAGE_BIT_SAVED_DIRTY	_PAGE_BIT_SOFTW5 /* Saved Dirty bit (leaf) */
+#define _PAGE_BIT_NOPTISHADOW	_PAGE_BIT_SOFTW5 /* No PTI shadow (root PGD) */
 #else
 /* Shared with _PAGE_BIT_UFFD_WP which is not supported on 32 bit */
-#define _PAGE_BIT_SAVED_DIRTY	_PAGE_BIT_SOFTW2 /* Saved Dirty bit */
+#define _PAGE_BIT_SAVED_DIRTY	_PAGE_BIT_SOFTW2 /* Saved Dirty bit (leaf) */
+#define _PAGE_BIT_NOPTISHADOW	_PAGE_BIT_SOFTW2 /* No PTI shadow (root PGD) */
 #endif
 
 /* If _PAGE_BIT_PRESENT is clear, we use these: */
@@ -139,6 +141,8 @@
 
 #define _PAGE_PROTNONE	(_AT(pteval_t, 1) << _PAGE_BIT_PROTNONE)
 
+#define _PAGE_NOPTISHADOW (_AT(pteval_t, 1) << _PAGE_BIT_NOPTISHADOW)
+
 /*
  * Set of bits not changed in pte_modify.  The pte's
  * protection key is treated like _PAGE_RW, for
--- a/arch/x86/mm/ident_map.c
+++ b/arch/x86/mm/ident_map.c
@@ -174,7 +174,7 @@ static int ident_p4d_init(struct x86_map
 		if (result)
 			return result;
 
-		set_p4d(p4d, __p4d(__pa(pud) | info->kernpg_flag));
+		set_p4d(p4d, __p4d(__pa(pud) | info->kernpg_flag | _PAGE_NOPTISHADOW));
 	}
 
 	return 0;
@@ -218,14 +218,14 @@ int kernel_ident_mapping_init(struct x86
 		if (result)
 			return result;
 		if (pgtable_l5_enabled()) {
-			set_pgd(pgd, __pgd(__pa(p4d) | info->kernpg_flag));
+			set_pgd(pgd, __pgd(__pa(p4d) | info->kernpg_flag | _PAGE_NOPTISHADOW));
 		} else {
 			/*
 			 * With p4d folded, pgd is equal to p4d.
 			 * The pgd entry has to point to the pud page table in this case.
 			 */
 			pud_t *pud = pud_offset(p4d, 0);
-			set_pgd(pgd, __pgd(__pa(pud) | info->kernpg_flag));
+			set_pgd(pgd, __pgd(__pa(pud) | info->kernpg_flag | _PAGE_NOPTISHADOW));
 		}
 	}
 
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -132,7 +132,7 @@ pgd_t __pti_set_user_pgtbl(pgd_t *pgdp,
 	 * Top-level entries added to init_mm's usermode pgd after boot
 	 * will not be automatically propagated to other mms.
 	 */
-	if (!pgdp_maps_userspace(pgdp))
+	if (!pgdp_maps_userspace(pgdp) || (pgd.pgd & _PAGE_NOPTISHADOW))
 		return pgd;
 
 	/*


