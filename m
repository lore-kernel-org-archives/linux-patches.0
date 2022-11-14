Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97354C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C484C433D6;
	Mon, 14 Nov 2022 13:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431264;
	bh=ZEoHSbRqEBn567S8zRILRF7yEO8d+Xk1JGT+iMq/ovM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soxjyMDAnJADhY+LwrjNP9jYANxRlGkb3VnePXfxzSm00Cq+Z+dohaFVC9VYFLjFx
	 ltodqbRUfXXLuZv2NvzGj0BrupmB1I+V4QRPy67Aq5dNqJ7bg/j91aP3VE36KXNjz1
	 ehZbhzjyJmy08x7dAsiYZa+btH9YR3gdwLB41jP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 161/190] mm/shmem: use page_mapping() to detect page cache for uffd continue
Date: Mon, 14 Nov 2022 13:46:25 +0100
Message-Id: <20221114124505.868509737@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Xu <peterx@redhat.com>

commit 93b0d9178743a68723babe8448981f658aebc58e upstream.

mfill_atomic_install_pte() checks page->mapping to detect whether one page
is used in the page cache.  However as pointed out by Matthew, the page
can logically be a tail page rather than always the head in the case of
uffd minor mode with UFFDIO_CONTINUE.  It means we could wrongly install
one pte with shmem thp tail page assuming it's an anonymous page.

It's not that clear even for anonymous page, since normally anonymous
pages also have page->mapping being setup with the anon vma.  It's safe
here only because the only such caller to mfill_atomic_install_pte() is
always passing in a newly allocated page (mcopy_atomic_pte()), whose
page->mapping is not yet setup.  However that's not extremely obvious
either.

For either of above, use page_mapping() instead.

Link: https://lkml.kernel.org/r/Y2K+y7wnhC4vbnP2@x1n
Fixes: 153132571f02 ("userfaultfd/shmem: support UFFDIO_CONTINUE for shmem")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -64,7 +64,7 @@ int mfill_atomic_install_pte(struct mm_s
 	pte_t _dst_pte, *dst_pte;
 	bool writable = dst_vma->vm_flags & VM_WRITE;
 	bool vm_shared = dst_vma->vm_flags & VM_SHARED;
-	bool page_in_cache = page->mapping;
+	bool page_in_cache = page_mapping(page);
 	spinlock_t *ptl;
 	struct inode *inode;
 	pgoff_t offset, max_off;


