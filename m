Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C735F6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B3BC340EC;
	Tue, 22 Mar 2022 21:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985332;
	bh=ktw58zu8xgeKHCa3X+x2f4+6x3oBLULyuw0PLP0DeCE=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=jpR7VHY/RGLdGpuQJbzxribKOCS9jZvbwYbAe1LtsPLrOIGuCaEjTRy5IkAUcgnzd
	 dJmt2NiUWEPr8FshxzgMM4Fi956HcAhdMfJEeiH+VxAB2/vjH6hzNK8OU/dRp34ApI
	 OdbcUpPBPw6wJRZhC/XiGqYCDmx9h3bSr5MwDROM=
Date: Tue, 22 Mar 2022 14:42:11 -0700
To: ziy@nvidia.com,rientjes@google.com,peterx@redhat.com,mike.kravetz@oracle.com,lars.persson@axis.com,kirill.shutemov@linux.intel.com,fam.zheng@bytedance.com,duanxiongchun@bytedance.com,axelrasmussen@google.com,songmuchun@bytedance.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 072/227] mm: replace multiple dcache flush with flush_dcache_folio()
Message-Id: <20220322214212.79B3BC340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: replace multiple dcache flush with flush_dcache_folio()

Simplify the code by using flush_dcache_folio().

Link: https://lkml.kernel.org/r/20220210123058.79206-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/migrate.c~mm-replace-multiple-dcache-flush-with-flush_dcache_folio
+++ a/mm/migrate.c
@@ -916,12 +916,8 @@ static int move_to_new_page(struct page
 		if (!PageMappingFlags(page))
 			page->mapping = NULL;
 
-		if (likely(!is_zone_device_page(newpage))) {
-			int i, nr = compound_nr(newpage);
-
-			for (i = 0; i < nr; i++)
-				flush_dcache_page(newpage + i);
-		}
+		if (likely(!is_zone_device_page(newpage)))
+			flush_dcache_folio(page_folio(newpage));
 	}
 out:
 	return rc;
_
