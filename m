Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA853519DFF;
	Thu, 17 Sep 2026 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667103; cv=none; b=ZWc9tQksPaSS8Apjq0I54EFMOdPw7j9fEiXVzJ2h+vrstLQWWayzfzRYO0qenujCt+2vdU2FsBuvar4V/WdZBVzJwqbbu/ZLxElOu6mny1YGNHWQM14Agxav298VhRoVwXQcjvh/yMn4iOa9WjB0hoFYUtSfjE7aM3DggTXt8e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667103; c=relaxed/simple;
	bh=QY6Qn57pz12oDRnAm/2adZoPLiiTcNO+sa8J4VcyPzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuZM6ahIHHdswyulnSCtscs1J+d4r+lFutbF3YG3Q/6riz2aLAWaPAD7e6wbjkXfYM8XbBNtEzA7D03PClrWRDQf9Xyko4AE2yb0f5KaKS14dD89sG3mtJF9E4e/x0Qi9S7RnNQf+y4JtgrxX/yvOuDhGzVAy0t7YztwX2Y4i0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEfKGlTU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEfKGlTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B081F000FF;
	Thu, 17 Sep 2026 17:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667101;
	bh=wVFobfo1UsZI75u8JE523RILn87P/DJ2bs0MzuReuYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEfKGlTUIS0Q1KkgLijnEEq7NIlGWGwma26+RsTXt/d9sSzEagIh742tD7LmicNPP
	 OHm0gCXJR5netJMnTiF2ys/HW+utyVsTo6XqZqW0y2NVq/iLOiRWHqqWXfjXOuOaNn
	 Lxoop+uqGLRJ2ECsp1QmddfGC5Gfxt2pdxMv2Nqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1192/1250] x86/mm/pat: Convert split_large_page() to use ptdescs
Date: Thu, 17 Sep 2026 16:16:27 +0100
Message-ID: <20260917151624.593005259@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>

[ Upstream commit e751303e0ad2e998f421d104193f6904df3516d1 ]

Use the ptdesc APIs for all page table allocation and free sites to
allow their separate allocation from struct page in the future.

Update split_large_page() to allocate a ptdesc instead of allocating a
page for use as a page table.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Link: https://patch.msgid.link/20260303194828.1406905-5-vishal.moola@gmail.com
Stable-dep-of: 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel page tables")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/set_memory.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1138,9 +1138,10 @@ set:
 
 static int
 __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
-		   struct page *base)
+		   struct ptdesc *ptdesc)
 {
 	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
+	struct page *base = ptdesc_page(ptdesc);
 	pte_t *pbase = (pte_t *)page_address(base);
 	unsigned int i, level;
 	pgprot_t ref_prot;
@@ -1245,18 +1246,18 @@ __split_large_page(struct cpa_data *cpa,
 static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 			    unsigned long address)
 {
-	struct page *base;
+	struct ptdesc *ptdesc;
 
 	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
-	base = alloc_pages(GFP_KERNEL, 0);
+	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
 	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
-	if (!base)
+	if (!ptdesc)
 		return -ENOMEM;
 
-	if (__split_large_page(cpa, kpte, address, base))
-		__free_page(base);
+	if (__split_large_page(cpa, kpte, address, ptdesc))
+		pagetable_free(ptdesc);
 
 	return 0;
 }


