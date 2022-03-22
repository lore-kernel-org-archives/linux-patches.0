Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF926453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7207CC340EC;
	Tue, 22 Mar 2022 21:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985329;
	bh=fBURoQBf/NowRAcjUkoyhi0STImz+EpOKIqpkfRNgXY=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=FlYP2pY1YK9tZkBy5h0DoAbInaMf/yVsWIYfUyzfn4cF3vmwcpgIGT/ig5W5gwrr6
	 ZJf5skhU194M5+cNoz/vd7JNrk/kzUemIb7lax6/bleB+Np26O/3dv4wtsIx51hfio
	 U2rf9OQ5bYaz/vTL1VzlMbFyozyycBD9Wwi1VdAU=
Date: Tue, 22 Mar 2022 14:42:08 -0700
To: ziy@nvidia.com,rientjes@google.com,peterx@redhat.com,mike.kravetz@oracle.com,lars.persson@axis.com,kirill.shutemov@linux.intel.com,fam.zheng@bytedance.com,duanxiongchun@bytedance.com,axelrasmussen@google.com,songmuchun@bytedance.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 071/227] mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()
Message-Id: <20220322214209.7207CC340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()

userfaultfd calls mcopy_atomic_pte() and __mcopy_atomic() which do not do
any cache flushing for the target page.  Then the target page will be
mapped to the user space with a different address (user address), which
might have an alias issue with the kernel address used to copy the data
from the user to.  Fix this by insert flush_dcache_page() after
copy_from_user() succeeds.

Link: https://lkml.kernel.org/r/20220210123058.79206-7-songmuchun@bytedance.com
Fixes: b6ebaedb4cb1 ("userfaultfd: avoid mmap_sem read recursion in mcopy_atomic")
Fixes: c1a4de99fada ("userfaultfd: mcopy_atomic|mfill_zeropage: UFFDIO_COPY|UFFDIO_ZEROPAGE preparation")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/userfaultfd.c~mm-userfaultfd-fix-missing-cache-flush-in-mcopy_atomic_pte-and-__mcopy_atomic
+++ a/mm/userfaultfd.c
@@ -150,6 +150,8 @@ static int mcopy_atomic_pte(struct mm_st
 			/* don't free the page */
 			goto out;
 		}
+
+		flush_dcache_page(page);
 	} else {
 		page = *pagep;
 		*pagep = NULL;
@@ -625,6 +627,7 @@ retry:
 				err = -EFAULT;
 				goto out;
 			}
+			flush_dcache_page(page);
 			goto retry;
 		} else
 			BUG_ON(page);
_
