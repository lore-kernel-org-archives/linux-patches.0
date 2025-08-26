Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A521A2AD04;
	Tue, 26 Aug 2025 13:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215527; cv=none; b=G/WVfQ8Mkq9O1HidfGaYevVf29fhWFT2PLuaefbJOujTDq8qVFN1b26KPIseQAR1zQ6pDHyzNdxWUZa/zDtrRc1XaBXInGoFOYiKqMIatXuakSxfi8JlwrDrIleBFUieQcR2ZtuxrkoVexRrxtpEl83Rhv+mjJ7qehrkMWUvrCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215527; c=relaxed/simple;
	bh=2yiwpAQo2vgTjIDhXw0KkQIrCETNtpWdGabupnL1s5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzHJJ4H4Pum5RyI/0Nnjr/CvBNZ1FKg+QwwYqexGXSo0U15B7QRfR/UDTj5EyMZAo6VhueGMCT83KwRAZxPpV8L2TV5JfcQ4XKab53+AoiYet78EzyP/uDV8tvKb+LaG5OA+LY60vgyPZt+SUGzahauzH8z6yqJheLxr4X1HO+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hypzsYry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hypzsYry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEB7C4CEF1;
	Tue, 26 Aug 2025 13:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215527;
	bh=2yiwpAQo2vgTjIDhXw0KkQIrCETNtpWdGabupnL1s5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hypzsYryk1EineXGN13y5b7abjXoASohEc80xAPLr5lUG9vQq7wAAP5k4qV6DYs37
	 1F/xq5Ztpc7H3oY1lIUIobT0D64cjX9IoLIP4ijX3UuT87GjNHoTn8mkDuML0S6P9G
	 /ba/mn6R90DrHFNy3mMJmpN/qEG7W6L1CwtoD/5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 068/644] mm/vmalloc: leave lazy MMU mode on PTE mapping error
Date: Tue, 26 Aug 2025 13:02:39 +0200
Message-ID: <20250826110948.183538037@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 mm/vmalloc.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -460,6 +460,7 @@ static int vmap_pages_pte_range(pmd_t *p
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
 		pgtbl_mod_mask *mask)
 {
+	int err = 0;
 	pte_t *pte;
 
 	/*
@@ -473,15 +474,21 @@ static int vmap_pages_pte_range(pmd_t *p
 	do {
 		struct page *page = pages[*nr];
 
-		if (WARN_ON(!pte_none(*pte)))
-			return -EBUSY;
-		if (WARN_ON(!page))
-			return -ENOMEM;
+		if (WARN_ON(!pte_none(*pte))) {
+			err = -EBUSY;
+			break;
+		}
+		if (WARN_ON(!page)) {
+			err = -ENOMEM;
+			break;
+		}
+
 		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
 		(*nr)++;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	*mask |= PGTBL_PTE_MODIFIED;
-	return 0;
+
+	return err;
 }
 
 static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,


