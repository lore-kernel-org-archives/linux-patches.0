Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A952C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA88C433D2;
	Tue,  7 Feb 2023 13:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775192;
	bh=KbsvTvd8Aeowx7x5k10TFX9LccpJUAGkSGVbHMPpX+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpymQJa0npuDPtM5Kt+3piKka29I5Uv4IOlIgKavnmG2snIZYK8HMqSnqABGndwUL
	 Ckd5gT1Zm+8/tDbQ0taC7NrntDneDmOyCe78IiRaXpf4j1+2aEWa3PQk/mGAdJ3bRg
	 zMhs+dk0Kz/wm7TW5ZLpjBBVb3GJbXu5sjgLDPU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Pengfei Xu <pengfei.xu@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 167/208] mm/uffd: fix pte marker when fork() without fork event
Date: Tue,  7 Feb 2023 13:57:01 +0100
Message-Id: <20230207125641.978859715@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

commit 49d6d7fb631345b0f2957a7c4be24ad63903150f upstream.

Patch series "mm: Fixes on pte markers".

Patch 1 resolves the syzkiller report from Pengfei.

Patch 2 further harden pte markers when used with the recent swapin error
markers.  The major case is we should persist a swapin error marker after
fork(), so child shouldn't read a corrupted page.


This patch (of 2):

When fork(), dst_vma is not guaranteed to have VM_UFFD_WP even if src may
have it and has pte marker installed.  The warning is improper along with
the comment.  The right thing is to inherit the pte marker when needed, or
keep the dst pte empty.

A vague guess is this happened by an accident when there's the prior patch
to introduce src/dst vma into this helper during the uffd-wp feature got
developed and I probably messed up in the rebase, since if we replace
dst_vma with src_vma the warning & comment it all makes sense too.

Hugetlb did exactly the right here (copy_hugetlb_page_range()).  Fix the
general path.

Reproducer:

https://github.com/xupengfe/syzkaller_logs/blob/main/221208_115556_copy_page_range/repro.c

Bugzilla report: https://bugzilla.kernel.org/show_bug.cgi?id=216808

Link: https://lkml.kernel.org/r/20221214200453.1772655-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20221214200453.1772655-2-peterx@redhat.com
Fixes: c56d1b62cce8 ("mm/shmem: handle uffd-wp during fork()")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org> # 5.19+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -875,12 +875,8 @@ copy_nonpresent_pte(struct mm_struct *ds
 			return -EBUSY;
 		return -ENOENT;
 	} else if (is_pte_marker_entry(entry)) {
-		/*
-		 * We're copying the pgtable should only because dst_vma has
-		 * uffd-wp enabled, do sanity check.
-		 */
-		WARN_ON_ONCE(!userfaultfd_wp(dst_vma));
-		set_pte_at(dst_mm, addr, dst_pte, pte);
+		if (userfaultfd_wp(dst_vma))
+			set_pte_at(dst_mm, addr, dst_pte, pte);
 		return 0;
 	}
 	if (!userfaultfd_wp(dst_vma))


