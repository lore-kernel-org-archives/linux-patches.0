Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047691;
	b=tZhmR91NwaG9egdDjeS0N+nDPacnYoxEFoeHFLoT510dcdfuaq4w9qvO9EqYQs3cQ2Sd
	 z7ZqMlVtsfEsMNnh6rPw80H3boPB0KOzHKr/gFGyvg1gFhidzOkPsH+qjcOcw37xSSKJJ
	 c8DGqFrD5ucXzb0lPLTn/AmQytjf7MtQOYeLQTF2vw21vyL+fqbQxWYN3HTWaQpwKhDWV
	 5WwybVJwcV4jmcsI/dnLcy5L5ZFmAzratxLBMGlBbpcyaa3EePHvabMpYYfry1cfnzN1L
	 YimFxq721b1kw1qkKONte89L/w+tcI2IZPTuAIRx6P23Lr0CkjPmDEBImIzl2mJzk7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=chSuBmfW/7gSc3bNSBN8XZJRfa7vXHj1sz0wTzyv/Ac=;
	b=ZfwnyJJmeXwP0KZQodxpTCHVzZT89dTDaETqkfqfG7zlXkCsVNG0ltHJ2ea+EIcuP8rV
	 VwazbMk5qcHzrJ3eau/Hj4zHDHVgTBorx5DBUdgsoa8aPUtUlHcdAZ8nCRRII1nLP64lh
	 s23nIv4AMS4SchBFBNCZofrwn3SgP5GvK+/3Gttbqa5sNqOLn9/nbp1z3M5eLnuVdIOE1
	 HgwY8XBzHDxscSknaPnwz5rPxMhoCmxscNngfO4ars77ObEtctNlIyiY4MCSIloeANFh9
	 22vxlNm5OkyTXu4KhLyU4XQ8X1kJh/y1dc33bFd6TTtJjEPnRKBxbZN/FwIoFtINwCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j/d9q72Q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EFC606A32A;
	Thu, 19 Nov 2026 00:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j/d9q72Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46EC1F000CC;
	Thu, 19 Nov 2026 00:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047691;
	bh=chSuBmfW/7gSc3bNSBN8XZJRfa7vXHj1sz0wTzyv/Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/d9q72QZOFqTskeKBVcW5zxHUVtF0wvABH97UEkLWvO5+CEZ5oX9QTIThN9RjS+k
	 hI/ypceGsV8SATz8XXhoRMt5ASjAaDNjZUE/1dFFzLYDKIlfUpHx+O7MVlT+3leFSj
	 v1bMrktAxIB4+vOJPJmXZTIKOIQT6XhJ8wgatMxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1688/2857] mm/rmap: handle device-exclusive entries in folio_referenced_one()
Date: Wed, 18 Nov 2026 15:45:22 +0100
Message-ID: <20261118150302.113830657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit f3c493d2f42b5f44a5c134d8d7ea7f960caf5e2c ]

page_vma_mapped_walk() can return non-present device-exclusive entries,
but folio_referenced_one() passes them to PTE young-bit accessors that
require present PTEs.

We must neither call clear_flush_young_ptes_notify() nor
folio_pte_batch() with non-present entries. For example, clearing the
young bit on non-present PTEs can corrupt the entry: on arm64
PTE_AF overlaps the swap type, so clearing it turns a device-exclusive
entry into an ordinary swap entry.

folio_pte_batch() will VM_WARN_ON_FOLIO.

Apply the same approach as the previous fixes to e.g., damon_ptep_mkold():
treat these entries as old from the CPU's perspective and obtain their
young state through the MMU notifier.

Skip PTE batching and MGLRU look-around for non-present entries, and
don't modify non-present PTEs.

Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-9-d6437171ecc3@kernel.org
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Adapted batched PTE handling to the single-PTE flow using the older void-returning MGLRU helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/rmap.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index dffd859bdeb96..4ade867a55cf9 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -827,14 +827,26 @@ static bool folio_referenced_one(struct folio *folio,
 		}
 
 		if (pvmw.pte) {
-			if (lru_gen_enabled() && pte_young(*pvmw.pte) &&
+			pte_t pteval = ptep_get(pvmw.pte);
+			bool young = false;
+
+			if (lru_gen_enabled() && pte_present(pteval) &&
+			    pte_young(pteval) &&
 			    !(vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))) {
 				lru_gen_look_around(&pvmw);
 				referenced++;
 			}
 
-			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte)) {
+			/*
+			 * PFN swap PTEs, such as device-exclusive ones, that
+			 * actually map pages are "old" from a CPU perspective.
+			 * The MMU notifier takes care of any device aspects.
+			 */
+			if (pte_present(pteval))
+				young = ptep_clear_flush_young(vma, address, pvmw.pte);
+			young |= mmu_notifier_clear_flush_young(vma->vm_mm, address,
+								address + PAGE_SIZE);
+			if (young) {
 				/*
 				 * Don't treat a reference through
 				 * a sequentially read mapping as such.
-- 
2.53.0



