Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036895;
	b=MgkiZg+yuEztUPhf6ZqDNow0pVq97D1gFmFSQBBHcPjMKQwhLBH14MSH47pT3vDIEv8J
	 ukwq6G0/3jPiebCffN1IfFSy8ySVB3qp35vyqKm8Hh2tvGisPMqwdb8RCrfQzNQCdZmnn
	 vApTLs8JNuyhq95ITYG5EaSabuUBgx793XA5kUdsmEMcq/buUsx0jJTRMsoU0ad03Y9n3
	 g+EoXAWjQohGLjHOrzV6RSYjzDLFH7W0epk4wK/ndQToal8vzyyu9jQbOX2onxAb75+ij
	 Hvf9mZbNvxy2gTcRJhxm6IKNlTqWVmaVZ46rdDn1CVhxJNeaIn6Zt3E/aNll6a1XpLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XhJcJ+nPe05RIJnyTnaAihugS8acTJeGWb7FkdXwnxA=;
	b=b8X0m7y1fdMQ4wroAWjZmO4tXEwn/XV/HW/+w3RmkZykj4uv7P0s/Etx7uKOdBtywA8B
	 8KoeuhYsLY6I/USDcd6VUQVcjJA/d6h1UzcmlwBJFuzNsTzysXwDHHXOJJI4wcTBAgV0X
	 NxSdbz08wm2FE/xF+fGgPyHM7D/Ror0ZWUku7F+8bdMaugaP15rcICWh6UclG1kqt39P2
	 /nH/unWsBXATFTXpTC+xLgbxBaZtJFK+l0eEidA2Fy0XlBFWOQ2zrrb3r2jbpCSVWNPUJ
	 5cxosaJfZ3+S+suQfGM2nSH88/uDxl0wJXft29mSa4pw3EdXnG/IUhV5lM6R944arkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ox0xYkBU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17312606A325;
	Wed, 18 Nov 2026 21:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ox0xYkBU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398CA1F000C4;
	Wed, 18 Nov 2026 21:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036894;
	bh=XhJcJ+nPe05RIJnyTnaAihugS8acTJeGWb7FkdXwnxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ox0xYkBU+Vf7Ht5keqTSf2pLaq08IlhtJOCVeFlDcokFMaf8OB/qsW22jnOi8li5x
	 3NOe5eEHzM6wGF02ZzufGSpbRfw1cxyDbspI/8HnOFOvdwkqL27rTWZyh/LM1X+0JT
	 JzmeBURpJ2cV5RvVDT9sfrKXmTSxIxKzv6aM5png=
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
Subject: [PATCH 6.6 1221/3318] riscv: mm: exclude invalid THP PMDs from page table check
Date: Wed, 18 Nov 2026 15:30:43 +0100
Message-ID: <20261118150356.810073753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 13c331c9cbca4..dcdf285b63c11 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -731,7 +731,14 @@ static inline bool pte_user_accessible_page(pte_t pte)
 
 static inline bool pmd_user_accessible_page(pmd_t pmd)
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
 
 static inline bool pud_user_accessible_page(pud_t pud)
-- 
2.53.0



