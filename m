Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039025;
	b=cKTKAARTTD3kicowFs7ivWm6IIhmlTtfYJgfRYHJ/4h6eLUusM7uQ3vS1tmXTMhghJS9
	 vr7hrDPX11CrWvL+x+aQ6PQntQDWPJ+Uj+fhzmF+Dr+MVcrK5oDwDawxHY7tSz6FeJfPP
	 Jy58ldqGhpFbRSGItVCHItyLTsjBSCYttFYGKCm1aFgNqHAIwWm9odpx3DH4j3wFulOu1
	 EhALTL13NPvMEXHRKU4OOtZpkW8DPhTYvjCVpzEQauO6poVSV7tYkwBF1lbuPF47Y0Tyb
	 IZqZx+FU9hHVlbQyjZDdL2qzTZ+pe4MY93j/gy/gJ8z86UE2Dxcmm7rtOTPhX0ZBF/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XfpND31mj0GZvh2MJmuGYg65mgFdzVvwzFBzf7SeL5s=;
	b=TrWhDHcXp5XXucQElglxm27Kdk2R72VeWoQyWL4m0vpEyYJM3x/b+O8A/lChklPzaEzC
	 62nL6OikFI95rUlFIyqFMIE0bKdzctzvoZG2DrnaSMmpfgWLl+QF4snjjiwBjqPp048Vg
	 7WuUaccAhONbuIgH4k2TRKoet0XMNIeAYzs1KYuoL+mrZuKjCcSgbDgwT1joFmj18wGGL
	 MSAlOkmh7y8ar81sCN38jCyBVFQ+PlV6ckZpEvVZTF4PA9V98F5KvSt/mp1ZZXIMBEeWw
	 YdmXMTcqVyVvJgfxm38OWMHseK3bBa9US3jDuSZqdWKia4VQooV6Hh4wP9hdERXB7IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GG7SjOP4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAA2606A31C;
	Wed, 18 Nov 2026 21:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GG7SjOP4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB5A1F000C4;
	Wed, 18 Nov 2026 21:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039025;
	bh=XfpND31mj0GZvh2MJmuGYg65mgFdzVvwzFBzf7SeL5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GG7SjOP4w2qQMv/7fDUCX7364YufRh5wII/oqwpGfsz7AL+E7K0I0OslJhm+PSUB4
	 e1LG5jntDX6C+n75XpCPKw/F3P7xL9B5PzWsz1zsfXn290K6JEyMaVBITJDuuEslrU
	 h50/SuW3Ohn5xD2vavMKEyRGBs9bY5GMWzcmf+54=
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
Subject: [PATCH 6.6 1951/3318] mm/rmap: handle device-exclusive entries in folio_referenced_one()
Date: Wed, 18 Nov 2026 15:42:53 +0100
Message-ID: <20261118150420.605016691@linuxfoundation.org>
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
[ sashal: adapted batched PTE handling to single-PTE processing with the older MGLRU API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/rmap.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index bdd32890d5487..2ae76b671825c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -825,14 +825,25 @@ static bool folio_referenced_one(struct folio *folio,
 		}
 
 		if (pvmw.pte) {
-			if (lru_gen_enabled() &&
-			    pte_young(ptep_get(pvmw.pte))) {
+			pte_t pteval = ptep_get(pvmw.pte);
+			bool young = false;
+
+			if (lru_gen_enabled() && pte_present(pteval) &&
+			    pte_young(pteval)) {
 				lru_gen_look_around(&pvmw);
 				referenced++;
 			}
 
-			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte))
+			/*
+			 * PFN swap PTEs, such as device-exclusive ones, that
+			 * actually map pages are "old" from a CPU perspective.
+			 * The MMU notifier takes care of any device aspects.
+			 */
+			if (pte_present(pteval))
+				young = ptep_clear_flush_young(vma, address, pvmw.pte);
+			young |= mmu_notifier_clear_flush_young(vma->vm_mm, address,
+							address + PAGE_SIZE);
+			if (young)
 				referenced++;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
-- 
2.53.0



