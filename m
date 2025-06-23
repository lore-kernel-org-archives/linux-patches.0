Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874F321B9C9;
	Mon, 23 Jun 2025 21:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714096; cv=none; b=jxfOkxQxCCS5UAEJoclCboCa2tqXieSmLL8inCV1jBYgWAQW/cqGNbvxoTG8zwDSqKxPFGZ0ilKZZMkQZpZSPHdmiX9zhUykeXCyKvrOsPWk2nanlACWTVWCdi+xj8Yc40/0Clzgk1QkD7+wrahuRrTKE9Dka/xfl9qwRxL1fL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714096; c=relaxed/simple;
	bh=6pqwFCdFNySOoKfaFloaBmZ8YPp04dwWPmy7j8n757E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+iM/pMYKk3RZIN95WLajjuQsxPSBwLucJC/V+bvGtYWXWBpz47JNBaV4F3rDOXECQoHyKjAMmrdYJhbA7WavR9P4zP2/zp4hALAdp9YFArSuJzlq/RO9q6AjTSYDebJb0NRx7qYDY0TVT0qnuCgCkE42fRvy+2YnWP3s31eTDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8QYs+Gn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8QYs+Gn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21045C4CEEA;
	Mon, 23 Jun 2025 21:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714096;
	bh=6pqwFCdFNySOoKfaFloaBmZ8YPp04dwWPmy7j8n757E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8QYs+GnnZQ9Rrh1ssaZ9tD6rTpccOogEAoeVkqpoEJgknCeonFHFHtLyMKj55X2g
	 qs9CEtSBTikHg/mzbTW0kNMkj990UNjqMb9OFOtn/a+yGZnBiJkdaZG+4H1nuGi0nZ
	 ZVKL5u598PG1Fl0P7o0Yc9Tr4MxmNC60Se8wN6PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 113/290] mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race
Date: Mon, 23 Jun 2025 15:06:14 +0200
Message-ID: <20250623130630.349590788@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 1013af4f585fccc4d3e5c5824d174de2257f7d6d upstream.

huge_pmd_unshare() drops a reference on a page table that may have
previously been shared across processes, potentially turning it into a
normal page table used in another process in which unrelated VMAs can
afterwards be installed.

If this happens in the middle of a concurrent gup_fast(), gup_fast() could
end up walking the page tables of another process.  While I don't see any
way in which that immediately leads to kernel memory corruption, it is
really weird and unexpected.

Fix it with an explicit broadcast IPI through tlb_remove_table_sync_one(),
just like we do in khugepaged when removing page tables for a THP
collapse.

Link: https://lkml.kernel.org/r/20250528-hugetlb-fixes-splitrace-v2-2-1329349bad1a@google.com
Link: https://lkml.kernel.org/r/20250527-hugetlb-fixes-splitrace-v1-2-f4136f5ec58a@google.com
Fixes: 39dde65c9940 ("[PATCH] shared page table for hugetlb page")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7062,6 +7062,13 @@ int huge_pmd_unshare(struct mm_struct *m
 		return 0;
 
 	pud_clear(pud);
+	/*
+	 * Once our caller drops the rmap lock, some other process might be
+	 * using this page table as a normal, non-hugetlb page table.
+	 * Wait for pending gup_fast() in other threads to finish before letting
+	 * that happen.
+	 */
+	tlb_remove_table_sync_one();
 	ptdesc_pmd_pts_dec(virt_to_ptdesc(ptep));
 	mm_dec_nr_pmds(mm);
 	return 1;


