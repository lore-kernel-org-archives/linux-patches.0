Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E6E135A4A;
	Tue, 14 May 2024 11:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686177; cv=none; b=Ehv8Pwq5x4XMYztRvHs7FXCi5Zz5NDT1fVeurkAAcV+bK+10rI6zW/+aOuo4PJwo8JiwLdo+GTe7Aa8C2DfezhlTxtwLCBkhXItyAhiMQMO61Uy5g47otKk0x9Mzqj0Eb44TcNZvdwfIbFHrOWeQDHTbH1sb9Nz0uGkYMIjI4H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686177; c=relaxed/simple;
	bh=s1hTGlhNaBHCWvPsVRLC4FK8f0d555HfBeFY7gTOt5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bu7fgQVFADfkNsDOKb5CmQ0xT6Cj3z/yC/Be7j3kTFYTCiS9LLPKyhGZ+41YpsTLwYg4GzvL66eXHkdMAMm8AdrY9DHeljqAFfrBhZhwYcL3qt5tKyc9lom2cRRHvzwxMuHzW+GqEvRA7Q9rudfLBevHhcayfmjUMzVjM6Aw1I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXL4iL9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXL4iL9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB62C2BD10;
	Tue, 14 May 2024 11:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686176;
	bh=s1hTGlhNaBHCWvPsVRLC4FK8f0d555HfBeFY7gTOt5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXL4iL9/C0finelzmKBCnKN9EO7SAug5dBdoswtMWqeb4YyAsG2RWBr/YeMub13/n
	 NlNA4e/ufuWDLTpWbCYK0Mc6+N7OwJ9HJ1W+VgcWWeu/8FDjwLkB6U0G6g7cpbvRLu
	 liNuYCr+6uY24hH+8awHpg1zDMDSbxDbdmbMcK1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	syzbot+4b8077a5fccc61c385a1@syzkaller.appspotmail.com,
	Mina Almasry <almasrymina@google.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/236] mm/hugetlb: fix missing hugetlb_lock for resv uncharge
Date: Tue, 14 May 2024 12:16:19 +0200
Message-ID: <20240514101020.986214186@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Xu <peterx@redhat.com>

[ Upstream commit b76b46902c2d0395488c8412e1116c2486cdfcb2 ]

There is a recent report on UFFDIO_COPY over hugetlb:

https://lore.kernel.org/all/000000000000ee06de0616177560@google.com/

350:	lockdep_assert_held(&hugetlb_lock);

Should be an issue in hugetlb but triggered in an userfault context, where
it goes into the unlikely path where two threads modifying the resv map
together.  Mike has a fix in that path for resv uncharge but it looks like
the locking criteria was overlooked: hugetlb_cgroup_uncharge_folio_rsvd()
will update the cgroup pointer, so it requires to be called with the lock
held.

Link: https://lkml.kernel.org/r/20240417211836.2742593-3-peterx@redhat.com
Fixes: 79aa925bf239 ("hugetlb_cgroup: fix reservation accounting")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: syzbot+4b8077a5fccc61c385a1@syzkaller.appspotmail.com
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e720b9ac28337..e9ae0fc81dfbe 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3190,9 +3190,12 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 
 		rsv_adjust = hugepage_subpool_put_pages(spool, 1);
 		hugetlb_acct_memory(h, -rsv_adjust);
-		if (deferred_reserve)
+		if (deferred_reserve) {
+			spin_lock_irq(&hugetlb_lock);
 			hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
 					pages_per_huge_page(h), folio);
+			spin_unlock_irq(&hugetlb_lock);
+		}
 	}
 	return page;
 
-- 
2.43.0



