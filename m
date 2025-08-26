Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C67221D3F2;
	Tue, 26 Aug 2025 14:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217200; cv=none; b=CUZu1bNw/9ZATiY0GpHKbGBs/JihrfbKsRaXdHc54lDAD1lNFWHILUd7DLOs2Iuo/jAeUZbwO6qgZz26sCOzm0QtvfWbJi9EvPbwsyosdoIMwEfQVEzlAQVdIxQIoniUJUBSOaLsEbHxOTEcuVfuc+MuiqHnIRnLDE2WaYw9YJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217200; c=relaxed/simple;
	bh=D82G4aV9diF+wH428zQNlfpXg0MqS1aF5yFDZlH+8BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JazisVT/9ljmrqp7DLzodjCy3/r6hgF6CkTk8vztDlIBn6+CCbim73vKldsXrdJFNZkO59eM3eeFlsCjSGWBGjrWJk7gLTV96UlzaapeMEdAg/8QaEZIvWRCnyZzugB58I4aklaNyovECw+Ttf3F/4nCsxR6SRx4VPSFnTEJr60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vN/WHlXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vN/WHlXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C96C4CEF1;
	Tue, 26 Aug 2025 14:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217197;
	bh=D82G4aV9diF+wH428zQNlfpXg0MqS1aF5yFDZlH+8BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vN/WHlXejPFMFiuConSYK1E/q5hUSgBqOn6OkTUzkMFazd+Lg8ci7nFC+qk2pX8sJ
	 I9uwGm0r4I/NkjYhFpbLOsW9POnzPcIJH9q6xon9A1GtOVcFMCpdrEYyrH22xWQ3ay
	 53FiPgU+a7F2b6c2fywiEKk0JRP7x1H/DF0cDUog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 052/523] mm/vmalloc: leave lazy MMU mode on PTE mapping error
Date: Tue, 26 Aug 2025 13:04:22 +0200
Message-ID: <20250826110925.879663643@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 mm/vmalloc.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -193,6 +193,7 @@ static int vmap_pte_range(pmd_t *pmd, un
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
 		pgtbl_mod_mask *mask)
 {
+	int err = 0;
 	pte_t *pte;
 
 	/*
@@ -206,15 +207,20 @@ static int vmap_pte_range(pmd_t *pmd, un
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
 		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
 		(*nr)++;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	*mask |= PGTBL_PTE_MODIFIED;
-	return 0;
+
+	return err;
 }
 
 static int vmap_pmd_range(pud_t *pud, unsigned long addr,


