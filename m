Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA013B27D9;
	Mon, 23 Mar 2026 14:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277450; cv=none; b=U7xiaDDvcyvJxxIrqV7AirLGjzx+qytuKpdA1Zwcx18/BO8x2s3vDoBMKFBglLj2FqwlETwpoymVU77cPtcy6uW9CKiYtS15j2h20ggRpb8f+4IetaKFDQA05iLnYwnYY2CMOKpNMuV/oJV5gXZepbtx/xudKZuubjhNZYw39rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277450; c=relaxed/simple;
	bh=v4fLwQL/NYBrEhg80/5I3eBaqoR5StYLUz1NaQOXyi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AT6Bqg8XBzShRyhJuYkrbTSLSopNS6fVUPJuheaqerfscOiW4Sa4zTU+iJP1qk4HWrye1f28nCNZOHvww0NhPoffHsqS1oD0nmIBroGt97rsBthV5q8yG2+Cjqm71hLqfxvqTmjtAxyWdyIV3xF7ur+G8m9kQm4iUZosa27JYTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCygplxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCygplxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E732EC4CEF7;
	Mon, 23 Mar 2026 14:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277450;
	bh=v4fLwQL/NYBrEhg80/5I3eBaqoR5StYLUz1NaQOXyi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCygplxaxEhe6WHypvaQKUCDINDXpGnN6K8DwK5lTN+OwYfIG4aD/p3bpdKRFJA44
	 SbLPNY5v8Q4GLNuqQX0YzViTZXRHIT0Gv6QJqjxCHW6LvkOPFY28Nx417rkgh97pEL
	 1ysKFrckExUrwSRBBKuNWWPa5YxMzhCrHFaXtbCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
	Kairui Song <ryncsn@gmail.com>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@redhat.com>,
	Lance Yang <ioworker0@gmail.com>,
	Matthew Wilcow <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 445/460] mm: shmem: fix potential data corruption during shmem swapin
Date: Mon, 23 Mar 2026 14:47:21 +0100
Message-ID: <20260323134537.518504587@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

commit 058313515d5aab10d0a01dd634f92ed4a4e71d4c upstream.

Alex and Kairui reported some issues (system hang or data corruption) when
swapping out or swapping in large shmem folios.  This is especially easy
to reproduce when the tmpfs is mount with the 'huge=within_size'
parameter.  Thanks to Kairui's reproducer, the issue can be easily
replicated.

The root cause of the problem is that swap readahead may asynchronously
swap in order 0 folios into the swap cache, while the shmem mapping can
still store large swap entries.  Then an order 0 folio is inserted into
the shmem mapping without splitting the large swap entry, which overwrites
the original large swap entry, leading to data corruption.

When getting a folio from the swap cache, we should split the large swap
entry stored in the shmem mapping if the orders do not match, to fix this
issue.

Link: https://lkml.kernel.org/r/2fe47c557e74e9df5fe2437ccdc6c9115fa1bf70.1740476943.git.baolin.wang@linux.alibaba.com
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
Reported-by: Kairui Song <ryncsn@gmail.com>
Closes: https://lore.kernel.org/all/1738717785.im3r5g2vxc.none@localhost/
Tested-by: Kairui Song <kasong@tencent.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcow <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ hughd: removed skip_swapcache dependencies ]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2132,7 +2132,7 @@ static int shmem_swapin_folio(struct ino
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	swp_entry_t swap;
-	int error, nr_pages;
+	int error, nr_pages, order, split_order;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
 	swap = radix_to_swp_entry(*foliop);
@@ -2151,8 +2151,8 @@ static int shmem_swapin_folio(struct ino
 
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
+	order = xa_get_order(&mapping->i_pages, index);
 	if (!folio) {
-		int split_order;
 
 		/* Or update major stats only when swapin succeeds?? */
 		if (fault_type) {
@@ -2189,13 +2189,37 @@ static int shmem_swapin_folio(struct ino
 			error = -ENOMEM;
 			goto failed;
 		}
+	} else if (order != folio_order(folio)) {
+		/*
+		 * Swap readahead may swap in order 0 folios into swapcache
+		 * asynchronously, while the shmem mapping can still stores
+		 * large swap entries. In such cases, we should split the
+		 * large swap entry to prevent possible data corruption.
+		 */
+		split_order = shmem_split_large_entry(inode, index, swap, gfp);
+		if (split_order < 0) {
+			error = split_order;
+			goto failed;
+		}
+
+		/*
+		 * If the large swap entry has already been split, it is
+		 * necessary to recalculate the new swap entry based on
+		 * the old order alignment.
+		 */
+		if (split_order > 0) {
+			pgoff_t offset = index - round_down(index, 1 << split_order);
+
+			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
+		}
 	}
 
 	/* We have to do this with folio locked to prevent races */
 	folio_lock(folio);
 	if (!folio_test_swapcache(folio) ||
 	    folio->swap.val != swap.val ||
-	    !shmem_confirm_swap(mapping, index, swap)) {
+	    !shmem_confirm_swap(mapping, index, swap) ||
+	    xa_get_order(&mapping->i_pages, index) != folio_order(folio)) {
 		error = -EEXIST;
 		goto unlock;
 	}


