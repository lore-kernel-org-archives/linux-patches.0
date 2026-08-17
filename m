Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4380743CED9;
	Mon, 17 Aug 2026 13:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974248; cv=none; b=Id2udx8OdFrjqOGivekOM1EpO/1dgiCDzauTC5eiTkrn722+ipIhYGIjefQUF7SfRetiMGVUgpSepujmE1Z4YAzcLIJrEbFn+d7sAyAXKGDY2VPHnYZU4ALRQz0NwGHN3jBk34A2SItOiQ0X3A9rWjS4fYanjNjZnQHZHtUr92M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974248; c=relaxed/simple;
	bh=qN03vMy+1+TF5JV3G8zM5bhysL+1tujWlfLxXdShZCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rc7LhTWOtdiccjvYHrQRQyIKYUn5YUKymF4rrRgB6c7oF672GN4McONmxLHTBRTvmF7Ox2HEXViZBObzf/zl9R8uT+MCz22CBJAojzpyomVt+AHJKo8/rzTtGgrfgo8aUYmU3/pNzQMdxDubDpYs1m7gIBmHqyk3B46aezSzgUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcO+DZyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcO+DZyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8B81F00AC4;
	Mon, 17 Aug 2026 13:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974244;
	bh=qYK878EdTXmsZEpEO+GEdMOc1B0FwBFQG7jcp1o/h9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcO+DZylqhhQyhxwi7kBLq4MMM9QLdodUH6/EEa73AI525wtA9YuBEGme323o4kHE
	 yRjtVezIWogBTObQH9DCH4qLiSgNo8Feqt+fZKBX9PKrVx67oriMazt3QDNPxclCeO
	 GLr625LxbovgaOz71HzPtnS8profmeOJJVCiuU8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Lutomirski <luto@kernel.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 7.1 140/271] mm: fix incorrect flush address in direct page table reclaim
Date: Mon, 17 Aug 2026 15:31:05 +0200
Message-ID: <20260817132542.608397739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@kernel.org>

commit 478a1c3abebfc717db0d1281a9cdd7befafee542 upstream.

When zap_pte_range reclaims a page table, it does:

    pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);

and this is unconditionally wrong: if this code executes, addr *always*
points one past the end of the range covered by the table.  The addr
parameter is used to flush the TLB (really the paging-structure-cache)
to drop references to the to-be-freed table, and any architecture that
cares about the parameter will flush the wrong address.  (But they'll
still free the correct page).

I think it's worth contemplating why the kernel works at all.

If we hit the offending line of code, we will first clear the PMD entry
(line 1954, zap_empty_pte_table), then we will issue pending flushes if
force_flush is set (tlb_flush_mmu_tlbonly(tlb)), then we will skip the
retry on line 1979 (phew!), and then we will do the offending
pte_free_tlb call.  *Or* we will clear the PMD entry immediately before
pte_free_tlb (line 1983, zap_pte_table_if_empty).

If we have any pending flushes (i.e. we actually zapped any last-level
entries) at the time we clear the PMD entry, then the flush really ought
to flush all references to the table (Linus certainly seems to think it
will on all architectures [0]).

The condition under which we have no accumulated flushes at the time of
the clear is very complex (the whole zap_pte_range function has absurdly
complex control flow).  If we do hit the bad case, then we will end up
clearing the PMD entry after the last time the range is flushed, and any
CPU is free to cache a reference to the (empty) page table.  If this
happens due to an ordinary read or write, it would segfault, so it would
be rare.  But the cache could be speculatively filled as well.  Then
we'll flush the wrong address and then free and possibly reuse the
table.

On x86, even flushing the wrong address works on non-KPTI Intel systems
because INVLPG flushes *all* paging-structure-caches, not just the ones
for the target address.  But INVPCID does not, and flush_tlb_one_user
will use INVPCID if it's available.  And then we're toast.  AMD systems
are more susceptible: we set the EFER.TCE bit, which makes even INVLPG
only flush the target address.

I think this might fix an issue in ripgrep reported here:
https://github.com/BurntSushi/ripgrep/issues/3494

[0] https://lore.kernel.org/all/CA+55aFzBggoXtNXQeng5d_mRoDnaMBE5Y+URs+PHR67nUpMtaw@mail.gmail.com/T/#u

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Fixes: 4c640eb4181c ("mm: move pte table reclaim code to memory.c")
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1981,7 +1981,7 @@ retry:
 
 	if (can_reclaim_pt) {
 		if (direct_reclaim || zap_pte_table_if_empty(mm, pmd, start, &pmdval)) {
-			pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
+			pte_free_tlb(tlb, pmd_pgtable(pmdval), start);
 			mm_dec_nr_ptes(mm);
 		}
 	}


