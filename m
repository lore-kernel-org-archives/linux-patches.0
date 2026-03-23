Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCAF3AE18A;
	Mon, 23 Mar 2026 14:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275628; cv=none; b=scrl6yJBEbYayoH6CF/ic7+D2O8s0a0uLiZQreMoM1+PCzI3uoYSXT7WecLKbMupVr75UYyy3ENFYQBshVnQi2jjuMNFWYSzcAkQV19zkyFc9AwzyXSsEo/KWKjODxhDebkuzfZZN8Z1t//DeMA86xkqEN/2AmpCZWs6C7B54FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275628; c=relaxed/simple;
	bh=lZZmQY5WXuc4j/UdiqWmjemW+3Yij7xAli+O7jUj9Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EF7MSQIGe04pKj5rAsiFCpnCTBWwZmZV9F4w0y4FZ/yWFwhDkgphc8tAtkrIRsx7T1uyB37mJVGlCsbg8cHT+62YFQ8ztOuif/H8zXiZNbaSfRrrAj4LH/PA08fzEf7oxODczbkYeTCW5alkM5NEU2rx1mH4hxDplk9kMiyGTHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PU3ceJ0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PU3ceJ0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5324C4CEF7;
	Mon, 23 Mar 2026 14:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275628;
	bh=lZZmQY5WXuc4j/UdiqWmjemW+3Yij7xAli+O7jUj9Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PU3ceJ0KMRgM2wjjBgJn39ooLOPEdKpU7dhGh+O4AAMnIEf4651GlS3CuY5UsbjUz
	 3MHitLOPfrNvPFN7NJ33YAg7qY8EtC/Br+WZjtq2CB9xz6LkrOIbJMdXKYzi+EQwCp
	 af5iqbSbmS1E50chgZCxHjbAtvLaWdSpn/sFhvAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Breno Leitao <leitao@debian.org>,
	Alistair Popple <apopple@nvidia.com>,
	James Houghton <jthoughton@google.com>,
	Piotr Jaroszynski <pjaroszynski@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>
Subject: [PATCH 6.12 165/460] arm64: contpte: fix set_access_flags() no-op check for SMMU/ATS faults
Date: Mon, 23 Mar 2026 14:42:41 +0100
Message-ID: <20260323134530.607769013@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Jaroszynski <pjaroszynski@nvidia.com>

commit 97c5550b763171dbef61e6239cab372b9f9cd4a2 upstream.

contpte_ptep_set_access_flags() compared the gathered ptep_get() value
against the requested entry to detect no-ops. ptep_get() ORs AF/dirty
from all sub-PTEs in the CONT block, so a dirty sibling can make the
target appear already-dirty. When the gathered value matches entry, the
function returns 0 even though the target sub-PTE still has PTE_RDONLY
set in hardware.

For a CPU with FEAT_HAFDBS this gathered view is fine, since hardware may
set AF/dirty on any sub-PTE and CPU TLB behavior is effectively gathered
across the CONT range. But page-table walkers that evaluate each
descriptor individually (e.g. a CPU without DBM support, or an SMMU
without HTTU, or with HA/HD disabled in CD.TCR) can keep faulting on the
unchanged target sub-PTE, causing an infinite fault loop.

Gathering can therefore cause false no-ops when only a sibling has been
updated:
 - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
 - read faults:  target still lacks PTE_AF

Fix by checking each sub-PTE against the requested AF/dirty/write state
(the same bits consumed by __ptep_set_access_flags()), using raw
per-PTE values rather than the gathered ptep_get() view, before
returning no-op. Keep using the raw target PTE for the write-bit unfold
decision.

Per Arm ARM (DDI 0487) D8.7.1 ("The Contiguous bit"), any sub-PTE in a CONT
range may become the effective cached translation and software must
maintain consistent attributes across the range.

Fixes: 4602e5757bcc ("arm64/mm: wire up PTE_CONT for user mappings")
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: stable@vger.kernel.org
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Piotr Jaroszynski <pjaroszynski@nvidia.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/contpte.c |   53 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 4 deletions(-)

--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -390,6 +390,27 @@ void contpte_clear_young_dirty_ptes(stru
 }
 EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);
 
+static bool contpte_all_subptes_match_access_flags(pte_t *ptep, pte_t entry)
+{
+	pte_t *cont_ptep = contpte_align_down(ptep);
+	/*
+	 * PFNs differ per sub-PTE. Match only bits consumed by
+	 * __ptep_set_access_flags(): AF, DIRTY and write permission.
+	 */
+	const pteval_t cmp_mask = PTE_RDONLY | PTE_AF | PTE_WRITE | PTE_DIRTY;
+	pteval_t entry_cmp = pte_val(entry) & cmp_mask;
+	int i;
+
+	for (i = 0; i < CONT_PTES; i++) {
+		pteval_t pte_cmp = pte_val(__ptep_get(cont_ptep + i)) & cmp_mask;
+
+		if (pte_cmp != entry_cmp)
+			return false;
+	}
+
+	return true;
+}
+
 int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 					unsigned long addr, pte_t *ptep,
 					pte_t entry, int dirty)
@@ -399,14 +420,38 @@ int contpte_ptep_set_access_flags(struct
 	int i;
 
 	/*
-	 * Gather the access/dirty bits for the contiguous range. If nothing has
-	 * changed, its a noop.
+	 * Check whether all sub-PTEs in the CONT block already match the
+	 * requested access flags/write permission, using raw per-PTE values
+	 * rather than the gathered ptep_get() view.
+	 *
+	 * __ptep_set_access_flags() can update AF, dirty and write
+	 * permission, but only to make the mapping more permissive.
+	 *
+	 * ptep_get() gathers AF/dirty state across the whole CONT block,
+	 * which is correct for a CPU with FEAT_HAFDBS. But page-table
+	 * walkers that evaluate each descriptor individually (e.g. a CPU
+	 * without DBM support, or an SMMU without HTTU, or with HA/HD
+	 * disabled in CD.TCR) can keep faulting on the target sub-PTE if
+	 * only a sibling has been updated. Gathering can therefore cause
+	 * false no-ops when only a sibling has been updated:
+	 *  - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
+	 *  - read faults:  target still lacks PTE_AF
+	 *
+	 * Per Arm ARM (DDI 0487) D8.7.1, any sub-PTE in a CONT range may
+	 * become the effective cached translation, so all entries must have
+	 * consistent attributes. Check the full CONT block before returning
+	 * no-op, and when any sub-PTE mismatches, proceed to update the whole
+	 * range.
 	 */
-	orig_pte = pte_mknoncont(ptep_get(ptep));
-	if (pte_val(orig_pte) == pte_val(entry))
+	if (contpte_all_subptes_match_access_flags(ptep, entry))
 		return 0;
 
 	/*
+	 * Use raw target pte (not gathered) for write-bit unfold decision.
+	 */
+	orig_pte = pte_mknoncont(__ptep_get(ptep));
+
+	/*
 	 * We can fix up access/dirty bits without having to unfold the contig
 	 * range. But if the write bit is changing, we must unfold.
 	 */


