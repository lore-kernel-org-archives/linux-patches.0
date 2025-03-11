Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1A725F7B7;
	Tue, 11 Mar 2025 15:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707269; cv=none; b=BFWPAC/TpKpfwoWoFP8bXliBJP7mDNdI2b+XveJvP5rpxdmhfFVE+iGIvnvAjYCnIqozGliI858pWw+dWBrIOg6/Lq4cC7t86EOIfUmC1K6RUX8Q1qSIERpIG1Q4n1ErR1nZlbfB+NTFu01a6Jq2aRo+kux+m1hsUThjgCslXAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707269; c=relaxed/simple;
	bh=+ZF9YlLz+bx0RCjoQJk82isC0jIjgQgGUyR3ecrRj1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnHjsA1FWOBaFcVQnJ/972hsdq9yTdjOBv2FSHwCgO5CyJioc1CqHySmm2hKmHkcsF/E7OYECMHEta6N9njp21oLEhVWmUCp2msxvXX642Ounw4tEfig1AQj34CaZszP43byffYD7psWLKJ79BhBtEPRfOH579ajWWqm9ZQzx54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/p9jR61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/p9jR61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546DEC4CEEC;
	Tue, 11 Mar 2025 15:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707268;
	bh=+ZF9YlLz+bx0RCjoQJk82isC0jIjgQgGUyR3ecrRj1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/p9jR61Kp8CbzEaLED5SvAvTZDxOhwmXgutvKRSK4w1StnRyvo7LYWP2fYQbAYPH
	 9v40ofr74EzS0a9ToUsHL+qih0cm4ZvPhrrL4jV2O4uQVTQGccPpALCyVOuZ+E/91a
	 jfnUAe2Ew0liG21utBhQ9csXciHDxKO3xiJ3cSyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 331/462] powerpc/64s/mm: Move __real_pte stubs into hash-4k.h
Date: Tue, 11 Mar 2025 15:59:57 +0100
Message-ID: <20250311145811.438960148@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 8ae4f16f7d7b59cca55aeca6db7c9636ffe7fbaa ]

The stub versions of __real_pte() etc are only used with HPT & 4K pages,
so move them into the hash-4k.h header.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240821080729.872034-1-mpe@ellerman.id.au
Stable-dep-of: 61bcc752d1b8 ("powerpc/64s: Rewrite __real_pte() and __rpte_to_hidx() as static inline")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/64/hash-4k.h | 20 +++++++++++++++
 arch/powerpc/include/asm/book3s/64/pgtable.h | 26 --------------------
 2 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerpc/include/asm/book3s/64/hash-4k.h
index b6ac4f86c87b4..5a79dd66b2ed0 100644
--- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
+++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
@@ -89,6 +89,26 @@ static inline int hash__hugepd_ok(hugepd_t hpd)
 }
 #endif
 
+/*
+ * With 4K page size the real_pte machinery is all nops.
+ */
+#define __real_pte(e, p, o)		((real_pte_t){(e)})
+#define __rpte_to_pte(r)	((r).pte)
+#define __rpte_to_hidx(r,index)	(pte_val(__rpte_to_pte(r)) >> H_PAGE_F_GIX_SHIFT)
+
+#define pte_iterate_hashed_subpages(rpte, psize, va, index, shift)       \
+	do {							         \
+		index = 0;					         \
+		shift = mmu_psize_defs[psize].shift;		         \
+
+#define pte_iterate_hashed_end() } while(0)
+
+/*
+ * We expect this to be called only for user addresses or kernel virtual
+ * addresses other than the linear mapping.
+ */
+#define pte_pagesize_index(mm, addr, pte)	MMU_PAGE_4K
+
 /*
  * 4K PTE format is different from 64K PTE format. Saving the hash_slot is just
  * a matter of returning the PTE bits that need to be modified. On 64K PTE,
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 2b4af824bdc55..91ef9d47029b1 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -332,32 +332,6 @@ extern unsigned long pci_io_base;
 
 #ifndef __ASSEMBLY__
 
-/*
- * This is the default implementation of various PTE accessors, it's
- * used in all cases except Book3S with 64K pages where we have a
- * concept of sub-pages
- */
-#ifndef __real_pte
-
-#define __real_pte(e, p, o)		((real_pte_t){(e)})
-#define __rpte_to_pte(r)	((r).pte)
-#define __rpte_to_hidx(r,index)	(pte_val(__rpte_to_pte(r)) >> H_PAGE_F_GIX_SHIFT)
-
-#define pte_iterate_hashed_subpages(rpte, psize, va, index, shift)       \
-	do {							         \
-		index = 0;					         \
-		shift = mmu_psize_defs[psize].shift;		         \
-
-#define pte_iterate_hashed_end() } while(0)
-
-/*
- * We expect this to be called only for user addresses or kernel virtual
- * addresses other than the linear mapping.
- */
-#define pte_pagesize_index(mm, addr, pte)	MMU_PAGE_4K
-
-#endif /* __real_pte */
-
 static inline unsigned long pte_update(struct mm_struct *mm, unsigned long addr,
 				       pte_t *ptep, unsigned long clr,
 				       unsigned long set, int huge)
-- 
2.39.5



