Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B0D26D4F2;
	Tue, 15 Jul 2025 13:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586938; cv=none; b=hcq1+7czsLu7ivuX36MCC1cbpqG7BWVaZwC679pO1rSeEeGjA8dD7ZmHMi6KAvfkVP5OG6pIUF3LIeBHsf3Fph/K/cadhat/BnlpERO6/xgZY5xWMKtUaXQU5TEa80pdl9pkimXaCYNg+FeFs6iWLu/PUkeB/NW6IDhuzH/Hyis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586938; c=relaxed/simple;
	bh=Uz9ARDR3tAgGhvBfjC0kzwgTfMo8ytARQ6YeCcW2lfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mM3qwTiqeFZT/ylpMHItjK9PkxfCL5s0QsqPzWrj8UaxbyqxLElsJZj4aehE28iUIhl9vJPQHxwirZp/1b6aVM3MoA98kpc3C8H4zznGuF6avELMc0Ik1hYfUbC/L5ImnUpYO7xzgLlyWs+gfxuns03M9fheQr5508A2maeol+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pv6vsqFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pv6vsqFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A17DC4CEE3;
	Tue, 15 Jul 2025 13:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586938;
	bh=Uz9ARDR3tAgGhvBfjC0kzwgTfMo8ytARQ6YeCcW2lfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pv6vsqFPUbe91qk8Tefth2Hu4frl6399euI8fhOaMWHWCZg4PFrphIxJ2vXyik4iQ
	 1SrQ+HM0r7o6HGSMlC3QOwWopLjtn7Lf6VedN6aiZc2v3QItzZIvJETKweieuy83Mg
	 8dhZHiHpoSLmGhNaN26d+gJ8BL6vKFdC1p+n0FjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 106/192] mm/vmalloc: leave lazy MMU mode on PTE mapping error
Date: Tue, 15 Jul 2025 15:13:21 +0200
Message-ID: <20250715130819.143609927@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

commit fea18c686320a53fce7ad62a87a3e1d10ad02f31 upstream.

vmap_pages_pte_range() enters the lazy MMU mode, but fails to leave it in
case an error is encountered.

Link: https://lkml.kernel.org/r/20250623075721.2817094-1-agordeev@linux.ibm.com
Fixes: 2ba3e6947aed ("mm/vmalloc: track which page-table levels were modified")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202506132017.T1l1l6ME-lkp@intel.com/
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -487,6 +487,7 @@ static int vmap_pages_pte_range(pmd_t *p
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
 		pgtbl_mod_mask *mask)
 {
+	int err = 0;
 	pte_t *pte;
 
 	/*
@@ -500,18 +501,25 @@ static int vmap_pages_pte_range(pmd_t *p
 	do {
 		struct page *page = pages[*nr];
 
-		if (WARN_ON(!pte_none(ptep_get(pte))))
-			return -EBUSY;
-		if (WARN_ON(!page))
-			return -ENOMEM;
-		if (WARN_ON(!pfn_valid(page_to_pfn(page))))
-			return -EINVAL;
+		if (WARN_ON(!pte_none(ptep_get(pte)))) {
+			err = -EBUSY;
+			break;
+		}
+		if (WARN_ON(!page)) {
+			err = -ENOMEM;
+			break;
+		}
+		if (WARN_ON(!pfn_valid(page_to_pfn(page)))) {
+			err = -EINVAL;
+			break;
+		}
 
 		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
 		(*nr)++;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	*mask |= PGTBL_PTE_MODIFIED;
-	return 0;
+
+	return err;
 }
 
 static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,


