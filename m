Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C984282F0C;
	Mon, 23 Mar 2026 15:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278740; cv=none; b=Sv2FMbMNQz+3vQa/vfd3hConW8pGjo2/X1o9JtFIf405CGA0SgqulF4AC1I4su51T9BZMygPK2u8f+LB30RSuz0enPA7XiJdg6B34vc8X6M2QwJVxVpBT+l9ELQfSNimZoSwz9vuVnSksfm32ENKBUmMalXZIDd1YZ8owVj8AYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278740; c=relaxed/simple;
	bh=z2tKeE60t1ifKNA9H5ufsEwqreeYJ0lMVnUL+53q9vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bynPb782Wncd7CFre/obdIdwgkV011zKC6vBPAPGpQW4O8x0Rjjkl3NdMX8tGLMkB8NvslIqBiHW+tnvJl2nIwW8A6uHtvegsiYAqLfNVUSE4p2xde/BlcsJDrLlRfFM6mDqPRXM8EOWYOVqiZDAM8MeElkPFWlTwQeyq3QDH4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swlYwepL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swlYwepL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9548EC2BC9E;
	Mon, 23 Mar 2026 15:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278740;
	bh=z2tKeE60t1ifKNA9H5ufsEwqreeYJ0lMVnUL+53q9vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swlYwepLgKZlyx3B0iLVINc11a5SZPXfpF+faLifKND4fzgc7oMQ2IA6essOMf9xb
	 KRsceP4Oz1qgzo0rdr0LBoZTi9xRbp7Lr95zTvg2a/xCMO+XMN4RiwpoBcgBirnTGt
	 zHTfwMgcLVq33ZUVScLweRhCXvgOzj3tiaYSSSSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Eric Chanudet <echanude@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 403/567] arm64: mm: Batch dsb and isb when populating pgtables
Date: Mon, 23 Mar 2026 14:45:23 +0100
Message-ID: <20260323134543.840900035@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit 1fcb7cea8a5f7747e02230f816c2c80b060d9517 ]

After removing uneccessary TLBIs, the next bottleneck when creating the
page tables for the linear map is DSB and ISB, which were previously
issued per-pte in __set_pte(). Since we are writing multiple ptes in a
given pte table, we can elide these barriers and insert them once we
have finished writing to the table.

Execution time of map_mem(), which creates the kernel linear map page
tables, was measured on different machines with different RAM configs:

               | Apple M2 VM | Ampere Altra| Ampere Altra| Ampere Altra
               | VM, 16G     | VM, 64G     | VM, 256G    | Metal, 512G
---------------|-------------|-------------|-------------|-------------
               |   ms    (%) |   ms    (%) |   ms    (%) |    ms    (%)
---------------|-------------|-------------|-------------|-------------
before         |   78   (0%) |  435   (0%) | 1723   (0%) |  3779   (0%)
after          |   11 (-86%) |  161 (-63%) |  656 (-62%) |  1654 (-56%)

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Tested-by: Eric Chanudet <echanude@redhat.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20240412131908.433043-3-ryan.roberts@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
[ Ryan: Trivial backport ]
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/pgtable.h |    7 ++++++-
 arch/arm64/mm/mmu.c              |   11 ++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -262,9 +262,14 @@ static inline pte_t pte_mkdevmap(pte_t p
 	return set_pte_bit(pte, __pgprot(PTE_DEVMAP | PTE_SPECIAL));
 }
 
-static inline void set_pte(pte_t *ptep, pte_t pte)
+static inline void set_pte_nosync(pte_t *ptep, pte_t pte)
 {
 	WRITE_ONCE(*ptep, pte);
+}
+
+static inline void set_pte(pte_t *ptep, pte_t pte)
+{
+	set_pte_nosync(ptep, pte);
 
 	/*
 	 * Only if the new pte is valid and kernel, otherwise TLB maintenance
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -175,7 +175,11 @@ static void init_pte(pte_t *ptep, unsign
 	do {
 		pte_t old_pte = READ_ONCE(*ptep);
 
-		set_pte(ptep, pfn_pte(__phys_to_pfn(phys), prot));
+		/*
+		 * Required barriers to make this visible to the table walker
+		 * are deferred to the end of alloc_init_cont_pte().
+		 */
+		set_pte_nosync(ptep, pfn_pte(__phys_to_pfn(phys), prot));
 
 		/*
 		 * After the PTE entry has been populated once, we
@@ -229,6 +233,11 @@ static void alloc_init_cont_pte(pmd_t *p
 		phys += next - addr;
 	} while (addr = next, addr != end);
 
+	/*
+	 * Note: barriers and maintenance necessary to clear the fixmap slot
+	 * ensure that all previous pgtable writes are visible to the table
+	 * walker.
+	 */
 	pte_clear_fixmap();
 }
 


