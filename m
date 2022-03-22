Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A79C6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BD8C340EC;
	Tue, 22 Mar 2022 21:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985467;
	bh=vOR0AWbeZ0W+/p8PKfNYSI+2VebxktM8MpUsSX/2EA0=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=RmXiSxIgUbDoNDYofhuj2yUWkr1X7nMiZEVqbPrLAJPMFb0MxiWrHaPDNtJDANv3w
	 EDpHGcTi07IXZmG84KKuJcTsfhIFOQQXQfimqCcWac0m5f5hiKR33Tz4uvToaPSGw0
	 BrrggZre6i4sMOUjWHbwZFyVtlEtqi2KvRUMV0rU=
Date: Tue, 22 Mar 2022 14:44:27 -0700
To: naoya.horiguchi@nec.com,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 117/227] mm/memory-failure.c: rework the try_to_unmap logic in hwpoison_user_mappings()
Message-Id: <20220322214427.D8BD8C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: rework the try_to_unmap logic in hwpoison_user_mappings()

Only for hugetlb pages in shared mappings, try_to_unmap should take
semaphore in write mode here.  Rework the code to make it clear.

Link: https://lkml.kernel.org/r/20220218090118.1105-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings
+++ a/mm/memory-failure.c
@@ -1404,26 +1404,22 @@ static bool hwpoison_user_mappings(struc
 	if (kill)
 		collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
-	if (!PageHuge(hpage)) {
-		try_to_unmap(hpage, ttu);
+	if (PageHuge(hpage) && !PageAnon(hpage)) {
+		/*
+		 * For hugetlb pages in shared mappings, try_to_unmap
+		 * could potentially call huge_pmd_unshare.  Because of
+		 * this, take semaphore in write mode here and set
+		 * TTU_RMAP_LOCKED to indicate we have taken the lock
+		 * at this higher level.
+		 */
+		mapping = hugetlb_page_mapping_lock_write(hpage);
+		if (mapping) {
+			try_to_unmap(hpage, ttu|TTU_RMAP_LOCKED);
+			i_mmap_unlock_write(mapping);
+		} else
+			pr_info("Memory failure: %#lx: could not lock mapping for mapped huge page\n", pfn);
 	} else {
-		if (!PageAnon(hpage)) {
-			/*
-			 * For hugetlb pages in shared mappings, try_to_unmap
-			 * could potentially call huge_pmd_unshare.  Because of
-			 * this, take semaphore in write mode here and set
-			 * TTU_RMAP_LOCKED to indicate we have taken the lock
-			 * at this higher level.
-			 */
-			mapping = hugetlb_page_mapping_lock_write(hpage);
-			if (mapping) {
-				try_to_unmap(hpage, ttu|TTU_RMAP_LOCKED);
-				i_mmap_unlock_write(mapping);
-			} else
-				pr_info("Memory failure: %#lx: could not lock mapping for mapped huge page\n", pfn);
-		} else {
-			try_to_unmap(hpage, ttu);
-		}
+		try_to_unmap(hpage, ttu);
 	}
 
 	unmap_success = !page_mapped(hpage);
_
