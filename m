Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6F32CCC0;
	Tue, 27 May 2025 16:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364820; cv=none; b=S90cnIWvQSq+MNAHHtsmlmirvAHyciGwkS0kEjJMCWLcywXPmZlfJhMEKPbxauQOAChQzdWOEPRV2KIT/oNJIMbz9p8Up6N8uPKHR2a75QAt6agvzdcLQC0coVsQA9LqloaVw8OfEJfMuGnFFzBR1PyX/mpFz4JGPPqsMGaPQ+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364820; c=relaxed/simple;
	bh=7ZvZlBwkPSa+PbDN7Jp36C22YU5br7OslYGtyqNZctA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/PxkpeodNStxiZQvKEhid9NcTzKEF7KA/LZgsBRHtTCTQtMtG5aWC4FaMitMn4EMHLvyOc7e6OKPggEtbykdI7bGTZyyvBNtHLfwku9emUyB58ZOQ0HRiepH8TbEGg9jFZzAdBMqqOTumL/kEPCjqgU/5s8f/Sr0SVjdy5hPJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFX1SZQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFX1SZQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E55C4CEE9;
	Tue, 27 May 2025 16:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364820;
	bh=7ZvZlBwkPSa+PbDN7Jp36C22YU5br7OslYGtyqNZctA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFX1SZQr8VCKyvpv6La0RGNGnqdF8N0AXIh4Y2oFlyIYkvkAnkyQjQ4f4Ep0WKebs
	 EHHYVR930SHnZGrzxM5mYqOBIF4rfpwhwsi6G6p/4CDWDAF0hEg61WaIZGJU9Rxpkz
	 uEePzZpBzd6pizuQEaFmEirmVJhfTVfKa5NtFMb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/626] arm64/mm: Check pmd_table() in pmd_trans_huge()
Date: Tue, 27 May 2025 18:21:08 +0200
Message-ID: <20250527162452.124055701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit d1770e909898c108e8c7d30ca039053e8818a9c9 ]

Check for pmd_table() in pmd_trans_huge() rather then just checking for the
PMD_TABLE_BIT. But ensure all present-invalid entries are handled correctly
by always setting PTE_VALID before checking with pmd_table().

Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250221044227.1145393-8-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index c329ea061dc98..8ee56ae999c16 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -554,18 +554,6 @@ static inline int pmd_protnone(pmd_t pmd)
 #endif
 
 #define pmd_present(pmd)	pte_present(pmd_pte(pmd))
-
-/*
- * THP definitions.
- */
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static inline int pmd_trans_huge(pmd_t pmd)
-{
-	return pmd_val(pmd) && pmd_present(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT);
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
 #define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
 #define pmd_young(pmd)		pte_young(pmd_pte(pmd))
 #define pmd_valid(pmd)		pte_valid(pmd_pte(pmd))
@@ -725,6 +713,18 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 #define pmd_leaf_size(pmd)	(pmd_cont(pmd) ? CONT_PMD_SIZE : PMD_SIZE)
 #define pte_leaf_size(pte)	(pte_cont(pte) ? CONT_PTE_SIZE : PAGE_SIZE)
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline int pmd_trans_huge(pmd_t pmd)
+{
+	/*
+	 * If pmd is present-invalid, pmd_table() won't detect it
+	 * as a table, so force the valid bit for the comparison.
+	 */
+	return pmd_val(pmd) && pmd_present(pmd) &&
+	       !pmd_table(__pmd(pmd_val(pmd) | PTE_VALID));
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 #if defined(CONFIG_ARM64_64K_PAGES) || CONFIG_PGTABLE_LEVELS < 3
 static inline bool pud_sect(pud_t pud) { return false; }
 static inline bool pud_table(pud_t pud) { return true; }
-- 
2.39.5



