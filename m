Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7175A27055F;
	Wed, 23 Apr 2025 15:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420947; cv=none; b=EwUJsZXPpzYHYVLBxnlhsZegPO7xXE5Sq14qklw1tGXfUIfbpQrGeMXqTwsthE7a2gAycd27Ef2GILVd8a2qMPfgQY/w4dptUThxT4VWcWwik+71rQsZs06xp1UAK2aRq/6KF1lop1vAVy+yOMd37gHVQmxGm6lPm0JAX5pM6k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420947; c=relaxed/simple;
	bh=CpCEYuyAOHkJKrclegSWwyOrBN/oZApYVqVt+kiDJUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Icef1ltIxZFnUzNDTRrLBc/kPHp8fJL3/NClQzGz5Z7KO682QzzOWQ5cyjiu6Pflo8EsGJ142alJPnVcWLJ35qOwAbNegIhTJwPIWmcJEJ0IRVPMcFKgmdzBGlWnse34dRFB2WL17Pn543irTOmxLmQk69jjDgcnPEBO9LCg1dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7sQmZEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7sQmZEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06575C4CEE3;
	Wed, 23 Apr 2025 15:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420947;
	bh=CpCEYuyAOHkJKrclegSWwyOrBN/oZApYVqVt+kiDJUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7sQmZEu5y5NeUX2rH0nEMDryzXUpYlM3DCKeFQUZT/Kge8Q0Qvk1yl103UxAEtpN
	 llm1gGvp62d/8PxuP47DSKMnhDVGbe7u+Q6Of2xxfeGN29Pu+qhNl5LaGyi1LfqMw4
	 crXdoBDeXpsyHHkAsulU9I5gCbxmZD8m0VdWWmrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Zi Yan <ziy@nvidia.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 138/241] mm/compaction: fix bug in hugetlb handling pathway
Date: Wed, 23 Apr 2025 16:43:22 +0200
Message-ID: <20250423142626.197299914@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Moola (Oracle) <vishal.moola@gmail.com>

commit a84edd52f0a0fa193f0f685769939cf84510755b upstream.

The compaction code doesn't take references on pages until we're certain
we should attempt to handle it.

In the hugetlb case, isolate_or_dissolve_huge_page() may return -EBUSY
without taking a reference to the folio associated with our pfn.  If our
folio's refcount drops to 0, compound_nr() becomes unpredictable, making
low_pfn and nr_scanned unreliable.  The user-visible effect is minimal -
this should rarely happen (if ever).

Fix this by storing the folio statistics earlier on the stack (just like
the THP and Buddy cases).

Also revert commit 66fe1cf7f581 ("mm: compaction: use helper compound_nr
in isolate_migratepages_block") to make backporting easier.

Link: https://lkml.kernel.org/r/20250401021025.637333-1-vishal.moola@gmail.com
Fixes: 369fa227c219 ("mm: make alloc_contig_range handle free hugetlb pages")
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/compaction.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -981,13 +981,13 @@ isolate_migratepages_block(struct compac
 		}
 
 		if (PageHuge(page)) {
+			const unsigned int order = compound_order(page);
 			/*
 			 * skip hugetlbfs if we are not compacting for pages
 			 * bigger than its order. THPs and other compound pages
 			 * are handled below.
 			 */
 			if (!cc->alloc_contig) {
-				const unsigned int order = compound_order(page);
 
 				if (order <= MAX_PAGE_ORDER) {
 					low_pfn += (1UL << order) - 1;
@@ -1011,8 +1011,8 @@ isolate_migratepages_block(struct compac
 				 /* Do not report -EBUSY down the chain */
 				if (ret == -EBUSY)
 					ret = 0;
-				low_pfn += compound_nr(page) - 1;
-				nr_scanned += compound_nr(page) - 1;
+				low_pfn += (1UL << order) - 1;
+				nr_scanned += (1UL << order) - 1;
 				goto isolate_fail;
 			}
 


