Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33244415F15;
	Tue, 21 Jul 2026 19:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663733; cv=none; b=ndmiSsIf6Epj56WlnWKxUFINqzzG+1Tub01PUUbAKYfpxfBoNjJhbndV0QV0bDEQexOwYdngEwT1CJYB+u1dag/gFo8r5MuChn77cDsaVOYwHvlVbMrTsHS6dIysIlHHAskq4HvljIIhG/zIRdYnBO8l6Io6wjgiel0DPrVnli8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663733; c=relaxed/simple;
	bh=M0tlGFGAMMr08GA0r0k06bVwUJkXfCjXigrVYCladWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efuHdhF/ZZnBVuSrVfKG59AVYFKpHMHFJldnclk/71h7WKOyCr2+Pgzk4WJ+ZyIqNMAc2IQPfNLIqm6Tdd9MwyYC2PJnAHUwf4u6U61/wUQaMLVFWNmHT0S+TPi0QEwmqzrcV9TQ/QuVB4b0gW4zQO1PjT38RY6nxII1YSo7rgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BML2h5uI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BML2h5uI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0D71F00A3A;
	Tue, 21 Jul 2026 19:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663732;
	bh=Lr+2DXT5HEzWxPPxncJUDv0sGYxAqCeC6Dku2R+2AG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BML2h5uIhpBO4vQuV++0JcvTKbpm72Re1R18FA6lcuZKTolkUUMFcPXpvg/Dfuggb
	 FxDXpEZH3ovyWS4Szk/mmG1BF5ogTiRj4Z6Fgu+87Fea3J4sv6xf84cGI5c2H+ota5
	 xrQmpmS1oobZPkrktZA44H3pepFZvA22aI20x+RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 0935/1276] mm/mm_init: fix uninitialized struct pages for ZONE_DEVICE
Date: Tue, 21 Jul 2026 17:22:58 +0200
Message-ID: <20260721152506.955198299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

commit cd681403a87085562499d60325b7b45d3be11217 upstream.

If DAX memory is hotplugged into an unoccupied subsection of an early
section, section_activate() reuses the unoptimized boot memmap.  However,
compound_nr_pages() still assumes that vmemmap optimization is in effect
and initializes only the reduced number of struct pages.  As a result, the
remaining tail struct pages are left uninitialized, which can later lead
to unexpected behavior or crashes.

Fix this by treating early sections as unoptimized when calculating how
many struct pages to initialize.

Link: https://lore.kernel.org/20260428081855.1249045-7-songmuchun@bytedance.com
Fixes: 6fd3620b3428 ("mm/page_alloc: reuse tail struct pages for compound devmaps")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Liam R. Howlett <liam@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mm_init.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1031,10 +1031,17 @@ static void __ref __init_zone_device_pag
  * of how the sparse_vmemmap internals handle compound pages in the lack
  * of an altmap. See vmemmap_populate_compound_pages().
  */
-static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
+static inline unsigned long compound_nr_pages(unsigned long pfn,
+					      struct vmem_altmap *altmap,
 					      struct dev_pagemap *pgmap)
 {
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	/*
+	 * If DAX memory is hot-plugged into an unoccupied subsection
+	 * of an early section, the unoptimized boot memmap is reused.
+	 * See section_activate().
+	 */
+	if (early_section(__pfn_to_section(pfn)) ||
+	    !vmemmap_can_optimize(altmap, pgmap))
 		return pgmap_vmemmap_nr(pgmap);
 
 	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
@@ -1102,7 +1109,7 @@ void __ref memmap_init_zone_device(struc
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pgmap));
+				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,


