Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062614;
	b=oOlcDuz/zlXcaCBuN4BTw8ufiK3ycv4Yb9hGY3qLGHyfHTbB858AlTS9neCeUbn1zgRC
	 j4+Vb2SLTDd0IfTZYYOh0FAnmiSYp8JaN5GOjY3KpdI9Y1/b5nL4w7RmL/YwZJ1cKbw3C
	 h86OgdPrvqpRimAZApejXZeahpcQ11h1LGLEZx8LxlWIQdA4eR+BXdZMfiERHijhP+wPG
	 rp0Yrm0TAvRYQX5xe94el7S2bxXAn91vaOP45ZOO/G7eIYHeO/YzaJlBhIjOCJ+Y2irIL
	 U+M1NN2eU/MGS/BaM0k3K73lSiqSE8Vk76xLp8CZcGt+bqD3DgKUchKfRd2bLYvddLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=crzf5K7Y+xMmzsV/fo4d78yT7KqHHPAKoXMooz1s3Zk=;
	b=oIgZgzSNZploNtlYzrwy/eISC3Bz/ZCbicYGcCv+eXx1aQ8kJorXffs0b4RPJpMMFsi2
	 ry3Q5MKzTf7Q37WwnCsYWespeOPOmNIiikcGWXL+5v3bPPE/GqvWfzQ5NpbPVatbHhfkL
	 oDFGN5poE5yrxhlMZCpOMfA2QXKF7pv3/fYbik4WzAZmQJ7lrP7Tkvfj8SfWLdpA9Vs1h
	 Q7dpc+d4IL10hA489x7PUXssQUaoVq1X2winudHXe3/Uc/NpiqAAQ3Cdz8bsJ42KJr5Id
	 uGWaDswlcKjKWB8ayvuESkpoN17oSZtCUIwYP1Qm+aJ6RzKo3TGG8Nk1fCematNTi4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BDG3u44H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DF1606A32F;
	Sat,  7 Nov 2026 14:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BDG3u44H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8FC1F0089F;
	Sat,  7 Nov 2026 14:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062613;
	bh=crzf5K7Y+xMmzsV/fo4d78yT7KqHHPAKoXMooz1s3Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDG3u44HdrKTPRiz9C03OMcMm7gLx+rrHTwQDk6hq4CSAeeMVziuutVklpZQeOq18
	 88TIAxyCUmTL38WQf4hXAX5UttKEToL+PxtEFl/55fCF7ezOBsPSJouQPqaOqLNGvy
	 HPSYzDWgQbx3UGasVU3utEuH+YOzDsjFeDmGbnHs=
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
Subject: [PATCH 6.12 1447/1536] riscv: mm: exclude invalid THP PMDs from page table check
Date: Sat,  7 Nov 2026 08:57:43 -0500
Message-ID: <20261107135038.475204224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index aeba8028e9aa8..14bbd90c28496 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -777,7 +777,14 @@ static inline bool pte_user_accessible_page(pte_t pte)
 
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



