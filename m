Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C0D2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A8BC433D2;
	Sun, 22 Jan 2023 15:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401015;
	bh=/q6rBZOT3WgoBAtjuHryok5+JLfH9kF2NqsGIKwugmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2I+E7+VMwI9t3yVVdpwAcvJ+zG0Gwk3dbT9eGFTRFp5ezca9EyT5FeJVd8M43pSwi
	 s2YVzl4y2rhUjEFF1XiNXUrGZVrfO3QmMx88V8i5SzXoh3/r8AQfAXQ60f8/gBQuBG
	 QbacgAgrqf/wjgnGyaiwththiVBuonsOXyg+mAt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	James Houghton <jthoughton@google.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 078/193] mm/hugetlb: pre-allocate pgtable pages for uffd wr-protects
Date: Sun, 22 Jan 2023 16:03:27 +0100
Message-Id: <20230122150249.919860960@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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

commit fed15f1345dc8a7fc8baa81e8b55c3ba010d7f4b upstream.

Userfaultfd-wp uses pte markers to mark wr-protected pages for both shmem
and hugetlb.  Shmem has pre-allocation ready for markers, but hugetlb path
was overlooked.

Doing so by calling huge_pte_alloc() if the initial pgtable walk fails to
find the huge ptep.  It's possible that huge_pte_alloc() can fail with
high memory pressure, in that case stop the loop immediately and fail
silently.  This is not the most ideal solution but it matches with what we
do with shmem meanwhile it avoids the splat in dmesg.

Link: https://lkml.kernel.org/r/20230104225207.1066932-2-peterx@redhat.com
Fixes: 60dfaad65aa9 ("mm/hugetlb: allow uffd wr-protect none ptes")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: James Houghton <jthoughton@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: James Houghton <jthoughton@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6604,8 +6604,17 @@ unsigned long hugetlb_change_protection(
 		spinlock_t *ptl;
 		ptep = huge_pte_offset(mm, address, psize);
 		if (!ptep) {
-			address |= last_addr_mask;
-			continue;
+			if (!uffd_wp) {
+				address |= last_addr_mask;
+				continue;
+			}
+			/*
+			 * Userfaultfd wr-protect requires pgtable
+			 * pre-allocations to install pte markers.
+			 */
+			ptep = huge_pte_alloc(mm, vma, address, psize);
+			if (!ptep)
+				break;
 		}
 		ptl = huge_pte_lock(h, mm, ptep);
 		if (huge_pmd_unshare(mm, vma, address, ptep)) {


