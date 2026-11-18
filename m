Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054478;
	b=U+rHGPDnxv5Gcy+Gi1GNcdy56e/yX6JH4wechaU59k8OsBxazD1WdSvowJCT3Mkv3jz/
	 SN44TtmMixtTl7qHhe133TMxZ0avVsZY9M5zu6vCGRceLCiB1EV+Nmmy96FvZbyU5Ti7N
	 1clIxefUxW0yFNJNFMNmJRrsIFEDyYChaQqutO2qk0RlM8ZgPfuymwzmFGINVz0EaWW+D
	 OWBzcDNrkfnK3hZwxuridcErIQ/8UueHToutkAqSraEZeSOMwzG3YySKrQN1hqzJ+Tm3S
	 TtuAwNlHQZdR4xfzzyB4QwhCPqZrfp0Ac7GWctXO9W+8WeRc/j8svsYuFtI/26NSKGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cS1CTNLZ6fohVlYG9X8+bhHsm6ohFEHklpkWPmEP/1E=;
	b=WlTHnKuM/NTQwZTE8zCadgvCjVDj0NM290AI/3AB7S2gIVOlVnsq4xsksgyCrFwXaJaS
	 GzXNzVfUzaiW5ocFYQ+ayGR3mcm958iY9nlJ4aW9+2eXSxLndgrO1V4l75y6DEfrtiwOq
	 0rPOXE0KosVOSJSq2cLydy++8vjB52NgLzyVyENL7axsL/KK77w9efgjQK6qOdxfODtMq
	 bWXw+BZSVQFmHeLUez4niafG2h4tgEhmT7c8SBbxpQYlqdSK6acTnBGlNIveA+mYHyOUx
	 XbzlQCmsgzUDBsA+FLI1WkcxI1oYGDZ1OeLE+9N6S961l4ZOE5BPVcBJQ8wp0ZvB74A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YdrsKcAe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25802606A320;
	Thu, 19 Nov 2026 02:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YdrsKcAe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7BF1F000C4;
	Thu, 19 Nov 2026 02:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054478;
	bh=cS1CTNLZ6fohVlYG9X8+bhHsm6ohFEHklpkWPmEP/1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YdrsKcAed6xZo+hG+uSgFtpi54x+Rat9ROR9iIwcabYQny+QlPJnDLSuIKliUwh13
	 lNYDQv3MYCB+cWyy5fJ+DlkRn6e0rzEP5CwzT5cboTPropQahXVAApd/9du/ojhxtV
	 prliuwjq9q/9KRvtYLpnLF5Kn/HO2iOuNLwjOMu0=
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
Subject: [PATCH 5.15 1286/2214] mm/rmap: handle device-exclusive entries in folio_referenced_one()
Date: Wed, 18 Nov 2026 15:49:22 +0100
Message-ID: <20261118150103.025495398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted folio_referenced_one() changes to page_referenced_one() using single-PTE operations because batching and MGLRU are absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/rmap.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 24da8320a6015..544999a055c49 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -797,8 +797,19 @@ static bool page_referenced_one(struct page *page, struct vm_area_struct *vma,
 		}
 
 		if (pvmw.pte) {
-			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte)) {
+			pte_t pteval = ptep_get(pvmw.pte);
+			bool young = false;
+
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



