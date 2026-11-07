Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063637;
	b=j6gXCHZvfP9H9d3A2LeIpDumfAoBuKMFkb/IHA3nPL9GHUdbBNpRnkYTiGmfidmtUdlb
	 0UxnA+s+cAG1M8jjzzf+642IdiUE0ex3ZkKHWcJbfFURG+e8io/SY7WoE2U76e7NywLO8
	 XQTsZ6kSsqBz6sLPbPFIkg0ftuE8niQWLnmzuf1qPpe50LLg3ALR5vCk/++3StMZDzj/q
	 j6R2SL0ORhwCgd4nrkc+tM7n821pV2ncdCpy7EUlP1nQlT9lpH3O2Uc+y8apbuw44cs7s
	 H9jrZSeWsLlye2ZUXMdVY2qiObFDlr7rSrwLyg15a8ibGD1+Z6Oys+G7XQs9giQR7bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qE9E2PB1w5qa6iVGCQ7WcRrrPErbrUXek8BaBP7DQzA=;
	b=KUemnUtoOIOnNJ5iJKmnHnSpnojhfvtt8CXnmgnVeWFTFP74oOegZpJ6W46vspRY5j3N
	 sI/csqe4JN8Q5q+MvJaQCgyOI/xjAofgP+0iqrX3jllcJh4e31eQaITbFYGnZsM7QtWxw
	 pf79Pv3LR0A+8cjzRCHk9AsFbJY6lb4kAtuahSbSf2rDxhxKCSKRqVAhjjVyVwtbX1C4x
	 wHYFes2xK+ZL3pLAIQxapZSzlLb4GbpNlYPcElc9H2+hZXzvgvLf1/IeeRubO3EozDTAo
	 YneiPY9mjK5GmAt6I6/gRStE0jeCDlJcvIdv8dAuiHcllXirvwTaZPl4y6Nit3Knrdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qn5ARMKw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F41606A333;
	Sat,  7 Nov 2026 15:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qn5ARMKw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CF61F008A1;
	Sat,  7 Nov 2026 15:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063636;
	bh=qE9E2PB1w5qa6iVGCQ7WcRrrPErbrUXek8BaBP7DQzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qn5ARMKwsGlqvHhT9ZzWi/We/L2wjFhX/v8ivRn7aIVjyDMzkVyXgWvMuRadfORTK
	 Olg92OHAqPLAXbQf9rx3qBTm+JR5UC7QDP8vEpMvmQ7trXhZ6rKgNmEk4yeSJZOxaR
	 y/OQS7FJ6EvfWRoKC1MqX4Q3D6OKFWjUDGgYvr78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 752/869] mm/swap: fix swap_cache_get_folio() returning a folio that left the swap cache
Date: Sat,  7 Nov 2026 08:57:14 -0500
Message-ID: <20261107134918.244486261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 60f34fedf3a4c91ed631ed2f80713ab993cde5ee ]

swap_cache_get_folio() reads the folio from the swap table and takes a
reference with folio_try_get(), without any lock.  If the folio is removed
from the swap cache and freed in between, and its memory gets reused,
folio_try_get() still succeeds and we return a page that has nothing to do
with the swap entry:

  CPU 0                                  CPU 1
  do_swap_page()
    swap_cache_get_folio()
      swp_tb = swap_table_get()
      folio = swp_tb_to_folio(swp_tb)
                                         madvise(MADV_DONTNEED)
                                           zap_nonpresent_ptes()
                                             swap_put_entries_direct()
                                               swap_put_entries_cluster()
                                                 __try_to_reclaim_swap()
                                                   swap_cache_del_folio()
                                                   folio_put()   <- freed
                                         page reused, e.g. as an anon
                                         folio of another task
      folio_try_get(folio)               <- succeeds
      return folio
    swap_update_readahead()              <- may clear PG_readahead on it
    folio_lock_or_retry()                <- locks it
    folio_matches_swap_entry() fails, unlock and put

filemap_get_entry() does the same lockless lookup for the page cache, and
after folio_try_get() it rechecks the xarray, because the folio may have
been freed and reused in between.  swap_cache_get_folio() lost that
recheck when the swap cache moved to the swap table.

So CPU 0 writes to a folio it doesn't own: it may clear PG_readahead and
takes the folio lock of someone else's page, before
folio_matches_swap_entry() finds out the folio is not ours.

When the race occurs, a swap fault can acquire a reference to a
physical page that has been freed and reused for an unrelated purpose,
potentially by another process.  The fault handler may then clear that
page's PG_readahead/PG_reclaim flag, wait on or acquire its folio lock,
and potentially attempt to remove it from an unrelated swap cache.

These operations can interfere with unrelated workloads and may cause
unexpected stalls and impaired reclaim.  The subsequent swap-entry
validation normally prevents the wrong folio from being mapped into the
faulting process.

It's documented that caller always double checks the folio so this part
is harmless from the aspect of data corruption or crash.

Recheck the slot after folio_try_get() and retry if it no longer holds
this folio.

[akpm@linux-foundation.org: add LLM-generated description of userspace impact]
Link: https://lore.kernel.org/20261015060528.302634-1-jiayuan.chen@linux.dev
Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/swap_state.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index b8d7744b4436a..57cae6f6eac1e 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -86,17 +86,27 @@ void show_swap_cache_info(void)
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
+	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
+	unsigned int ci_off = swp_cluster_offset(entry);
 	unsigned long swp_tb;
 	struct folio *folio;
 
 	for (;;) {
-		swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
-					swp_cluster_offset(entry));
+		swp_tb = swap_table_get(ci, ci_off);
 		if (!swp_tb_is_folio(swp_tb))
 			return NULL;
 		folio = swp_tb_to_folio(swp_tb);
-		if (likely(folio_try_get(folio)))
+		if (!folio_try_get(folio))
+			continue;
+		/*
+		 * The folio may have been freed and its memory reused before
+		 * we got the reference. Make sure it is still in the slot.
+		 */
+		swp_tb = swap_table_get(ci, ci_off);
+		if (likely(swp_tb_is_folio(swp_tb) &&
+			   swp_tb_to_folio(swp_tb) == folio))
 			return folio;
+		folio_put(folio);
 	}
 
 	return NULL;
-- 
2.53.0



