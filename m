Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065365;
	b=cJvD0/LK0oAA+lpqOY4ueYpTX9aXoWbmYm360YsTJxZniabsjSIB1Qgb0jpK05vWlk9k
	 osZRrfIBZteVAX0jzpU6NT2uuxCsT2yEA7jIjJpMz4wkyykw4qZwDrC1SYorWGpYI1YUb
	 nPbRLxv61dZqCkWCdzc+dwzm47Vi0XeX6nW8FVAwg2rnjuLd/ED0ZP8ees4HDgTKCAAKo
	 e/rDUX8V3/TPzyrtZkfXCYiPvDDKLZrEBy0NiQTT0zoSfXqEMikVIhR58uzjTgTwl0mBe
	 MR79TpwDFBL7L0X4E5Y5jOD9hjZotnvfR6O/3s5FUE5uV8W2OlZPnc+1CZlEGKIqIDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fcuIReQAaUWUgN06BaM5p6Np7/tMRMkyICarAhFSRzE=;
	b=yAoZ43JkZZXbJXNp9WbgT0p1jhyk0kZ9QGJiHL5lV6YRhKCaiapD05UuJ0JhjFaVjSwE
	 JG93FgijIBXU03P/6uTXMdTCtrArscYlOPC5dA3e4Wrwy1KHDVmEj9RPemNiaZfJbMMIP
	 ycXF1TBYofUvXdxsVLM3islUQYMGZXB98SVTqc6pjb3iZ6IBzi8uop48ZNoxnkcAre2Wl
	 WLANJ2b3lcjMzdF23ZPVwIFnzaUG0UH1ZJYav6qU2un75rqUxmpj8QlELvDYJehbhhgSF
	 mdTmSrSIm7/bO0z2L9pBzzL/ZFOW13DbdP3IFDS+Q2P9ANesrOWrcuDvZx770KfZKAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPTvo9JC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08690606A32C;
	Sat,  7 Nov 2026 15:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPTvo9JC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B147B1F008A1;
	Sat,  7 Nov 2026 15:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065364;
	bh=fcuIReQAaUWUgN06BaM5p6Np7/tMRMkyICarAhFSRzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPTvo9JCdnsu5Y6g34TAWU1ExzcuWgGZFr9fgktWMK9lyCuebDG57/Vl+WhZdFzdC
	 oMSj/BjRoqVsGNXKSzknQSDHafixNHfeF9al2YyOW6TYVHFEp+jOIfktIiRvTurd1r
	 BYuujsScv2YkGYMMyZSH1fYtx6N5LlqPyecqKO9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	tongtiangen <tongtiangen@huawei.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Yaxing Guo <guoyaxing@bosc.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1098/1257] riscv: mm: exclude invalid THP PMDs from page table check
Date: Sat,  7 Nov 2026 08:56:34 -0500
Message-ID: <20261107135009.586290066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunhui Cui <cuiyunhui@bytedance.com>

[ Upstream commit bdda2887cbf3937c2d0f56589c2124c4167324e1 ]

RISC-V THP splitting uses a temporary invalid PMD state where
pmd_mkinvalid() clears _PAGE_PRESENT and _PAGE_PROT_NONE but leaves
_PAGE_LEAF set so the MM code can still recognize the PMD as a THP split
in-progress entry.

That temporary state no longer describes a user-accessible mapping, but
page_table_check currently treats it as one because the RISC-V PMD
user-accessibility test only checks whether the PMD is a leaf and has user
permissions.

As a result, when a PMD-sized anonymous THP is split during a COW fault,
page_table_check can account the invalid intermediate PMD as a live PMD
mapping, and then account the replacement PTE mappings again when the
split installs the PTE table.  This leaves stale PMD accounting behind and
later triggers page_table_check failures such as a non-zero anon_map_count
when the folio is freed.

Fix this by tightening pmd_user_accessible_page() so PMD page-table-check
accounting only considers leaf PMDs that still carry either _PAGE_PRESENT
or _PAGE_PROT_NONE.  This preserves the THP split semantics required by
the MM code while preventing page_table_check from treating invalid split
PMDs as live user mappings.

With CONFIG_PAGE_TABLE_CHECK=y and CONFIG_PAGE_TABLE_CHECK_ENFORCED=y,
tools/testing/selftests/mm/cow completes successfully on RISC-V after this
change.

Link: https://lore.kernel.org/20260523042052.35476-1-cuiyunhui@bytedance.com
Fixes: 3fee229a8eb9 ("riscv/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK")
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: tongtiangen <tongtiangen@huawei.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: Yaxing Guo <guoyaxing@bosc.ac.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 40b1ed4f3ea89..bda7c021b4299 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -993,7 +993,14 @@ static inline bool pte_user_accessible_page(struct mm_struct *mm, unsigned long
 
 static inline bool pmd_user_accessible_page(struct mm_struct *mm, unsigned long addr, pmd_t pmd)
 {
-	return pmd_leaf(pmd) && pmd_user(pmd);
+	/*
+	 * page_table_check() must ignore THP split invalidation entries created by
+	 * pmd_mkinvalid(). These retain _PAGE_LEAF so pmd_present()/pmd_leaf() stay
+	 * true during the split, but they no longer describe a user-accessible
+	 * mapping once both _PAGE_PRESENT and _PAGE_PROT_NONE are cleared.
+	 */
+	return (pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE)) &&
+		(pmd_val(pmd) & _PAGE_LEAF) && pmd_user(pmd);
 }
 
 static inline bool pud_user_accessible_page(struct mm_struct *mm, unsigned long addr, pud_t pud)
-- 
2.53.0



