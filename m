Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B41519F43A;
	Thu,  3 Jul 2025 14:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554469; cv=none; b=lVNFI8yPaDBu4V/RTfoRMAggzWB1Z8nLiC3IXq28JpKnpFTGmGyJMgmygvYs08yChNWIessrrKmK+mwxEd4FG6th7SH0zDDDVZLrWbNVahrMty3FmYCdFTE5v4LGfhHYCZJwgDPyKm4ioDOme8vgenilhMoVFvEd2plH0oRIhjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554469; c=relaxed/simple;
	bh=edGEnBp5BzXMXMM7YBQL+8TpIKk77KJsGg1QEZm1cts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+TLA5zZPTrKY5S1fOBe9g1aL9gPNsBXCFS83wsqRkSh07UKpRl7SrLHbXgTpjAWvw4phfHjObLSz5vv8VIcwdIPfyzk69TCj0VZHjPSB69E7qT8kO6j5lwLRIOhnOZikcAuB6CBFdx/6I9Y6g8JQVNcbBVcPg0PfIuV1c3F4zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LN7rJaYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LN7rJaYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55576C4CEE3;
	Thu,  3 Jul 2025 14:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554468;
	bh=edGEnBp5BzXMXMM7YBQL+8TpIKk77KJsGg1QEZm1cts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LN7rJaYQ5FkFAERMuga5U574Sy2a3mPoNIyAbagsyQsKQfeq4zcb535uf45QOxnKo
	 zOoUbtOaQuw5IrI23jxvfE2UrjCBd83HfIZOm2N5IHx7seXPZI0MRxn4r+sEZk05e7
	 53Sa0RZY6wHJFgTYuvxI9TxDvGC5aD9yre2bzAEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	syzbot+d16409ea9ecc16ed261a@syzkaller.appspotmail.com,
	Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 190/218] mm/vma: reset VMA iterator on commit_merge() OOM failure
Date: Thu,  3 Jul 2025 16:42:18 +0200
Message-ID: <20250703144003.800884533@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 0cf4b1687a187ba9247c71721d8b064634eda1f7 upstream.

While an OOM failure in commit_merge() isn't really feasible due to the
allocation which might fail (a maple tree pre-allocation) being 'too small
to fail', we do need to handle this case correctly regardless.

In vma_merge_existing_range(), we can theoretically encounter failures
which result in an OOM error in two ways - firstly dup_anon_vma() might
fail with an OOM error, and secondly commit_merge() failing, ultimately,
to pre-allocate a maple tree node.

The abort logic for dup_anon_vma() resets the VMA iterator to the initial
range, ensuring that any logic looping on this iterator will correctly
proceed to the next VMA.

However the commit_merge() abort logic does not do the same thing.  This
resulted in a syzbot report occurring because mlockall() iterates through
VMAs, is tolerant of errors, but ended up with an incorrect previous VMA
being specified due to incorrect iterator state.

While making this change, it became apparent we are duplicating logic -
the logic introduced in commit 41e6ddcaa0f1 ("mm/vma: add give_up_on_oom
option on modify/merge, use in uffd release") duplicates the
vmg->give_up_on_oom check in both abort branches.

Additionally, we observe that we can perform the anon_dup check safely on
dup_anon_vma() failure, as this will not be modified should this call
fail.

Finally, we need to reset the iterator in both cases, so now we can simply
use the exact same code to abort for both.

We remove the VM_WARN_ON(err != -ENOMEM) as it would be silly for this to
be otherwise and it allows us to implement the abort check more neatly.

Link: https://lkml.kernel.org/r/20250606125032.164249-1-lorenzo.stoakes@oracle.com
Fixes: 47b16d0462a4 ("mm: abort vma_modify() on merge out of memory failure")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: syzbot+d16409ea9ecc16ed261a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/6842cc67.a00a0220.29ac89.003b.GAE@google.com/
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vma.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

--- a/mm/vma.c
+++ b/mm/vma.c
@@ -836,9 +836,6 @@ static struct vm_area_struct *vma_merge_
 		err = dup_anon_vma(next, vma, &anon_dup);
 	}
 
-	if (err)
-		goto abort;
-
 	/*
 	 * In nearly all cases, we expand vmg->vma. There is one exception -
 	 * merge_right where we partially span the VMA. In this case we shrink
@@ -846,22 +843,11 @@ static struct vm_area_struct *vma_merge_
 	 */
 	expanded = !merge_right || merge_will_delete_vma;
 
-	if (commit_merge(vmg, adjust,
-			 merge_will_delete_vma ? vma : NULL,
-			 merge_will_delete_next ? next : NULL,
-			 adj_start, expanded)) {
-		if (anon_dup)
-			unlink_anon_vmas(anon_dup);
-
-		/*
-		 * We've cleaned up any cloned anon_vma's, no VMAs have been
-		 * modified, no harm no foul if the user requests that we not
-		 * report this and just give up, leaving the VMAs unmerged.
-		 */
-		if (!vmg->give_up_on_oom)
-			vmg->state = VMA_MERGE_ERROR_NOMEM;
-		return NULL;
-	}
+	if (err || commit_merge(vmg, adjust,
+			merge_will_delete_vma ? vma : NULL,
+			merge_will_delete_next ? next : NULL,
+			adj_start, expanded))
+		goto abort;
 
 	res = merge_left ? prev : next;
 	khugepaged_enter_vma(res, vmg->flags);
@@ -873,6 +859,9 @@ abort:
 	vma_iter_set(vmg->vmi, start);
 	vma_iter_load(vmg->vmi);
 
+	if (anon_dup)
+		unlink_anon_vmas(anon_dup);
+
 	/*
 	 * This means we have failed to clone anon_vma's correctly, but no
 	 * actual changes to VMAs have occurred, so no harm no foul - if the


