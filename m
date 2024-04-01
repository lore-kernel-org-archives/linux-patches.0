Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA5753E15;
	Mon,  1 Apr 2024 15:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986882; cv=none; b=mMfzn6NROfjdqC6/bs4vG9mOnUIJ/BwWeA4t7ytxtXhy3f5+TAp6cvJ5DY4TlXcQT4Xe6OAr7clxhS/CV/TIo0a8hboMmEg8x3bWFmvxzDg2Ov9t5S7M8kHNWKUslytG6X+c2f57VbWfnhp1Nx39r3xnsfsw0ErtLLo9fJjwtdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986882; c=relaxed/simple;
	bh=j92lLH/g3LjFyMa6wxEl5nCeTg9NTC6oj4/H54fdigI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBMLU8yjCQHYxXlf5CoygS8XKwF1sW657SAsjYvkGUEfsAFMENfpwZyvLaAZPyogYXPn8Ho1U6OJbrF8Zq62V3i6oY8lHIg6lQDigm7Zj9uw14c7wCsXI7p/5d4LEtBhJ//Mesg1WJcTF/9t60mj7PhMTXLbIZCJxsKBNv915R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPa7DSyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPa7DSyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364BBC433F1;
	Mon,  1 Apr 2024 15:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986882;
	bh=j92lLH/g3LjFyMa6wxEl5nCeTg9NTC6oj4/H54fdigI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPa7DSyUHhn6jSEhK6lm8BOf2UP/OQqRddRnFk7ZvWBNuuhjzjIbwYg66u4XRIIt4
	 s6MrnWfCIQkJRw4nKQ4yCnJZ+gFEYtleS55zRyDOjT06R1e37O3DBI9FDmlUrd6e2p
	 mi5hLP2PB656vwXW4bNWG52VyJpsVujAvMXbTcjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 116/399] mm: swap: fix race between free_swap_and_cache() and swapoff()
Date: Mon,  1 Apr 2024 17:41:22 +0200
Message-ID: <20240401152552.653009386@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit 82b1c07a0af603e3c47b906c8e991dc96f01688e ]

There was previously a theoretical window where swapoff() could run and
teardown a swap_info_struct while a call to free_swap_and_cache() was
running in another thread.  This could cause, amongst other bad
possibilities, swap_page_trans_huge_swapped() (called by
free_swap_and_cache()) to access the freed memory for swap_map.

This is a theoretical problem and I haven't been able to provoke it from a
test case.  But there has been agreement based on code review that this is
possible (see link below).

Fix it by using get_swap_device()/put_swap_device(), which will stall
swapoff().  There was an extra check in _swap_info_get() to confirm that
the swap entry was not free.  This isn't present in get_swap_device()
because it doesn't make sense in general due to the race between getting
the reference and swapoff.  So I've added an equivalent check directly in
free_swap_and_cache().

Details of how to provoke one possible issue (thanks to David Hildenbrand
for deriving this):

--8<-----

__swap_entry_free() might be the last user and result in
"count == SWAP_HAS_CACHE".

swapoff->try_to_unuse() will stop as soon as soon as si->inuse_pages==0.

So the question is: could someone reclaim the folio and turn
si->inuse_pages==0, before we completed swap_page_trans_huge_swapped().

Imagine the following: 2 MiB folio in the swapcache. Only 2 subpages are
still references by swap entries.

Process 1 still references subpage 0 via swap entry.
Process 2 still references subpage 1 via swap entry.

Process 1 quits. Calls free_swap_and_cache().
-> count == SWAP_HAS_CACHE
[then, preempted in the hypervisor etc.]

Process 2 quits. Calls free_swap_and_cache().
-> count == SWAP_HAS_CACHE

Process 2 goes ahead, passes swap_page_trans_huge_swapped(), and calls
__try_to_reclaim_swap().

__try_to_reclaim_swap()->folio_free_swap()->delete_from_swap_cache()->
put_swap_folio()->free_swap_slot()->swapcache_free_entries()->
swap_entry_free()->swap_range_free()->
...
WRITE_ONCE(si->inuse_pages, si->inuse_pages - nr_entries);

What stops swapoff to succeed after process 2 reclaimed the swap cache
but before process1 finished its call to swap_page_trans_huge_swapped()?

--8<-----

Link: https://lkml.kernel.org/r/20240306140356.3974886-1-ryan.roberts@arm.com
Fixes: 7c00bafee87c ("mm/swap: free swap slots in batch")
Closes: https://lore.kernel.org/linux-mm/65a66eb9-41f8-4790-8db2-0c70ea15979f@redhat.com/
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/swapfile.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 746aa9da53025..6fe0cc25535f5 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1227,6 +1227,11 @@ static unsigned char __swap_entry_free_locked(struct swap_info_struct *p,
  * with get_swap_device() and put_swap_device(), unless the swap
  * functions call get/put_swap_device() by themselves.
  *
+ * Note that when only holding the PTL, swapoff might succeed immediately
+ * after freeing a swap entry. Therefore, immediately after
+ * __swap_entry_free(), the swap info might become stale and should not
+ * be touched without a prior get_swap_device().
+ *
  * Check whether swap entry is valid in the swap device.  If so,
  * return pointer to swap_info_struct, and keep the swap entry valid
  * via preventing the swap device from being swapoff, until
@@ -1604,13 +1609,19 @@ int free_swap_and_cache(swp_entry_t entry)
 	if (non_swap_entry(entry))
 		return 1;
 
-	p = _swap_info_get(entry);
+	p = get_swap_device(entry);
 	if (p) {
+		if (WARN_ON(data_race(!p->swap_map[swp_offset(entry)]))) {
+			put_swap_device(p);
+			return 0;
+		}
+
 		count = __swap_entry_free(p, entry);
 		if (count == SWAP_HAS_CACHE &&
 		    !swap_page_trans_huge_swapped(p, entry))
 			__try_to_reclaim_swap(p, swp_offset(entry),
 					      TTRS_UNMAPPED | TTRS_FULL);
+		put_swap_device(p);
 	}
 	return p != NULL;
 }
-- 
2.43.0



