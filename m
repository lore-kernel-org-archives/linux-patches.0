Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA50664C6;
	Mon, 24 Feb 2025 14:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408095; cv=none; b=sk5P6wPcwQ0G76B/i7gNxziRC4NKRG795opP6I5H8jcbrNm1Y6zmHgDeyR77zpnbyRtf7Bs6FiVzwLOrlZLZOazFCSKB79s09nkb+Pps1a1OhgF24315uNUNJeR332/wgRELQkBnbD0uDtSt96uLVMjMWXGctmrlzRKNj9monec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408095; c=relaxed/simple;
	bh=pokpPH5bcjxcrXJBBVscnRjzVydW27NLzPbX54Z8WKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACMKjwUqa+OrG/NS/DRMdPSyG1ajlGAxQ6Z9DWA0eztNXRzL5lAPyIm6uyxiwmqrqMEcXbH+g9tcrAhdCQwR/9+OWK4BOsJ4HCg7i3s8PVgVGRJj5CReDDju/kgVzVveyM9zY4x4shThK6TeVBcLWBjLS5tl5cOtN0B5JazBt78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhblvZlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhblvZlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E9AC4CED6;
	Mon, 24 Feb 2025 14:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408095;
	bh=pokpPH5bcjxcrXJBBVscnRjzVydW27NLzPbX54Z8WKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhblvZlb4AXCeFpn2AB2GYji1ZfJzM+rlx8l08AEEG8sU+Hh0g1vU55dWQ6gxBs6h
	 sRdPyQlm9NhVbVbptDF8sBrl44TpH0EiREjxZsaOF/M5bgTo3qAJOICFFsoAamkWl4
	 +graiddyY5jsKW9RVoL0cGB3LFUtfCZtKkR9K4r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/140] powerpc/64s/mm: Move __real_pte stubs into hash-4k.h
Date: Mon, 24 Feb 2025 15:34:25 +0100
Message-ID: <20250224142605.606573390@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6472b08fa1b0c..57ebbacf1709c 100644
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
index 5c497c862d757..8a6e6b6daa906 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -319,32 +319,6 @@ extern unsigned long pci_io_base;
 
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



