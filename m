Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEC61A01BE;
	Wed,  5 Mar 2025 18:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198648; cv=none; b=R5nXLvgw7K+5fvb4hSRxv0OafAVKHosdOUCw/9biv936vtX3h6p5rYRCc4MdlFz6fhRt6i0QQ1vzA0yP5xlbBZ8BJ266GCEsz4MlXhI7R5h80ncfw3tqbfUqlO8FkY8U0mVGWh7sOvZ2uObUIgLiEYpDR1t8vBoGSg7CljSQRBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198648; c=relaxed/simple;
	bh=NbPKTofL4oAqEXEz1k6jtEKfh0NupwNMInXQeWc9d48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjxBgkVdgzf6p0C0v7lT14GIo4zhrK1hmqEvl+x6Ru8ipsJDeU7ZwMk91oybViUSZHujGruYmHKL1xvJecf4YHTJuXKPIZPPzNZVvVcr9Mh+USrcbAuvU0WWuzXKTZiMysUYbgvtfBXN1IIcWm791u35wgIVKlUiwG7G+oIa0XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjyLRYDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjyLRYDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5E5C4CED1;
	Wed,  5 Mar 2025 18:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198647;
	bh=NbPKTofL4oAqEXEz1k6jtEKfh0NupwNMInXQeWc9d48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjyLRYDSyzrM5Z9GCHiCbAJntjWes4qHHKx7Oeo1tI62YvbUs+4B0MfRCc3ShN9R7
	 izmgQLkZtjhC1C92+SaC23tpmUEJUEc8uaMuxJqzMW2vZrzCzA+yryrS9tjKK6OgGd
	 JgSaOt0xgQBk04OAzt8gK/9BVKKAAd+pkTOPONQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.13 101/157] arm64: hugetlb: Fix flush_hugetlb_tlb_range() invalidation level
Date: Wed,  5 Mar 2025 18:48:57 +0100
Message-ID: <20250305174509.368943211@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit eed6bfa8b28230382b797a88569f2c7569a1a419 upstream.

commit c910f2b65518 ("arm64/mm: Update tlb invalidation routines for
FEAT_LPA2") changed the "invalidation level unknown" hint from 0 to
TLBI_TTL_UNKNOWN (INT_MAX). But the fallback "unknown level" path in
flush_hugetlb_tlb_range() was not updated. So as it stands, when trying
to invalidate CONT_PMD_SIZE or CONT_PTE_SIZE hugetlb mappings, we will
spuriously try to invalidate at level 0 on LPA2-enabled systems.

Fix this so that the fallback passes TLBI_TTL_UNKNOWN, and while we are
at it, explicitly use the correct stride and level for CONT_PMD_SIZE and
CONT_PTE_SIZE, which should provide a minor optimization.

Cc: stable@vger.kernel.org
Fixes: c910f2b65518 ("arm64/mm: Update tlb invalidation routines for FEAT_LPA2")
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Link: https://lore.kernel.org/r/20250226120656.2400136-4-ryan.roberts@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/hugetlb.h |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/hugetlb.h
+++ b/arch/arm64/include/asm/hugetlb.h
@@ -76,12 +76,22 @@ static inline void flush_hugetlb_tlb_ran
 {
 	unsigned long stride = huge_page_size(hstate_vma(vma));
 
-	if (stride == PMD_SIZE)
-		__flush_tlb_range(vma, start, end, stride, false, 2);
-	else if (stride == PUD_SIZE)
-		__flush_tlb_range(vma, start, end, stride, false, 1);
-	else
-		__flush_tlb_range(vma, start, end, PAGE_SIZE, false, 0);
+	switch (stride) {
+#ifndef __PAGETABLE_PMD_FOLDED
+	case PUD_SIZE:
+		__flush_tlb_range(vma, start, end, PUD_SIZE, false, 1);
+		break;
+#endif
+	case CONT_PMD_SIZE:
+	case PMD_SIZE:
+		__flush_tlb_range(vma, start, end, PMD_SIZE, false, 2);
+		break;
+	case CONT_PTE_SIZE:
+		__flush_tlb_range(vma, start, end, PAGE_SIZE, false, 3);
+		break;
+	default:
+		__flush_tlb_range(vma, start, end, PAGE_SIZE, false, TLBI_TTL_UNKNOWN);
+	}
 }
 
 #endif /* __ASM_HUGETLB_H */


