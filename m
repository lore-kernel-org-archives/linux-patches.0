Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1787A78F58;
	Tue, 29 Apr 2025 17:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946024; cv=none; b=pjKBXPuSpZb4PPy7iiMSF2Pm+TlP8TfwMtvus3QBBWiP4R+DAtHnLlxgzgN3YRfiD7upXuWjZonMqzYHWVtGsFkBfgqJmpUmgyCqnrn4JGdWzTmZnGlOfGHiwDjLZuSZ5clPf0vVUYHNXVQdoKykwrxPj/bOcdGD3ahx4VgRuxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946024; c=relaxed/simple;
	bh=2+OdaB4l89SuCd9MtxYSQ9UuiubVljcfrckZbdEWlV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raLBwXqgQouXgF7LcudPu60h02iGJ2w3d5r6ZIheVDfYQFH6wNe2arls1AQ71m+LwBNq6alMohmQf5IzVNXW7P+3ad2pF89wmLFKmrtIRuQSITzr5PQv+EqMi2q0F3k/LhRue5cBkkb9oxGfR/narcbbHIsHkojb8WVmTz+JUV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0Kma82q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0Kma82q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12628C4CEE9;
	Tue, 29 Apr 2025 17:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946023;
	bh=2+OdaB4l89SuCd9MtxYSQ9UuiubVljcfrckZbdEWlV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0Kma82ql8SYPHbky9FysXbZnHcuw6880omDJlxCttxuMC3nLCQLf4Rk5oh9DBH81
	 VcHdgGMTYawoR/isAxEG5ybfYQIS54KW6WiQm8xXNklXAzl+B8K4mjOcbnRgr++mKQ
	 LfOLMUo5svT9LDRVNAEBr7zTecQsXpLSal/0eB7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Hongchen Zhang <zhanghongchen@loongson.cn>,
	Ming Wang <wangming01@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.14 129/311] LoongArch: Return NULL from huge_pte_offset() for invalid PMD
Date: Tue, 29 Apr 2025 18:39:26 +0200
Message-ID: <20250429161126.325662122@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Wang <wangming01@loongson.cn>

commit bd51834d1cf65a2c801295d230c220aeebf87a73 upstream.

LoongArch's huge_pte_offset() currently returns a pointer to a PMD slot
even if the underlying entry points to invalid_pte_table (indicating no
mapping). Callers like smaps_hugetlb_range() fetch this invalid entry
value (the address of invalid_pte_table) via this pointer.

The generic is_swap_pte() check then incorrectly identifies this address
as a swap entry on LoongArch, because it satisfies the "!pte_present()
&& !pte_none()" conditions. This misinterpretation, combined with a
coincidental match by is_migration_entry() on the address bits, leads to
kernel crashes in pfn_swap_entry_to_page().

Fix this at the architecture level by modifying huge_pte_offset() to
check the PMD entry's content using pmd_none() before returning. If the
entry is invalid (i.e., it points to invalid_pte_table), return NULL
instead of the pointer to the slot.

Cc: stable@vger.kernel.org
Acked-by: Peter Xu <peterx@redhat.com>
Co-developed-by: Hongchen Zhang <zhanghongchen@loongson.cn>
Signed-off-by: Hongchen Zhang <zhanghongchen@loongson.cn>
Signed-off-by: Ming Wang <wangming01@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/mm/hugetlbpage.c
+++ b/arch/loongarch/mm/hugetlbpage.c
@@ -47,7 +47,7 @@ pte_t *huge_pte_offset(struct mm_struct
 				pmd = pmd_offset(pud, addr);
 		}
 	}
-	return (pte_t *) pmd;
+	return pmd_none(pmdp_get(pmd)) ? NULL : (pte_t *) pmd;
 }
 
 uint64_t pmd_to_entrylo(unsigned long pmd_val)


