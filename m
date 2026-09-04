Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4593515D2;
	Fri,  4 Sep 2026 05:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498628; cv=none; b=tJp/RamKgkkQTH/bOj4Nn7qr9x+d+tCHMfXcNYrXsjF49rE6+QF1RQnH8zL2fs03KZz+zwLsNLkDmFQ1c9wEgK1G4JI+qDoSHiGN1k17dagCkN6iwp1R84m5O+fN3UzSevukcKIoAjHPdTgi5Xrs37FlhsU+oGJgsnT0YlnKj/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498628; c=relaxed/simple;
	bh=4VKcwQe0hDtUHlynex/vVliv8NIVFEpw+zzJuZ4Vj+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIt+fa0Uas5bbkdoX9homDlts09VP2VKUXYXOEduKvkTQ8HK9jhln7VFQT4mSEezCqo8EjqxW4yyEh4fqGB9sL4u7Yd+DEc0dqa73S0f2H0HCDrGepUfgPRn64b0TsWOlcRAuLHfFEhD+RH3ingIEnseqvWvmd94kMeXPOrvmYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbrrYpUy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbrrYpUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1971F00A3D;
	Fri,  4 Sep 2026 05:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498626;
	bh=pNyWih5jgB5xzRpcm134tOTcPRwb4i13pp8nvKCX0Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbrrYpUy9J4y551nr/r5heR0RfdnOMLzaY/7lFmwYZSltb8MpRhyGsbRPyp0jO4re
	 bCWNIuW26w5Pl85l/F62ygsAc/j4bLf4JvANbCuFFQUtmJFT+Qp9H4zFpYOUqn65F1
	 mmD3xhXbjglEyVRavjMhRo2JxpdOT7TswX+b/ROw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Brendan Jackman <jackmanb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 077/713] mm: page_alloc: __GFP_FS lockdep annotation for direct compaction
Date: Fri,  4 Sep 2026 06:50:45 +0200
Message-ID: <20260904045805.564959263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 37864d0bf5a4d60da6109b9078cc78ef3fc81216 upstream.

Patch series "mm: fix reclaim storms in defrag_mode", v2.

As we deployed vm.defrag_mode=1 in Meta production, some workloads
regressed with recurring pressure spikes and swap storms (which in turn
triggered userspace OOM rules on pressure and swap utilization levels).

Tracing pinned this to non-movable requests spinning and reclaiming
unproductively when kswapd/kcompactd are overwhelmed.  Direct reclaim
predominantly frees up pages in movable blocks, but those requests cannot
use that space under defrag_mode rules; and it is unlikely to free up
whole blocks incidentally for __rmqueue_claim() to work.

This series fixes it by making non-movable requests participate in
pageblock production in the allocator slowpath - meaning, they will invoke
direct reclaim and direct compaction with pageblock_order.

That requires some small-ish adjustments up front in the allocator and the
compaction code: three prep patches and the fix last.

The series has been in production against one of the affected workloads
for several weeks and restores the OOM kill rate to !defrag_mode baseline.


This patch (of 4):

A subsequent patch will have some order-0 allocations participate in
compaction under defrag_mode, to stave off extfrag events.

Since this is a sprawling expansion of entry points, and compaction can
enter filesystem paths, add lockdep annotations that catches __GFP_FS
passing errors.

Direct reclaim has had this annotation for a while, and since reclaim and
compaction are usually used in conjunction, this is unlikely to unearth
old bugs.  It's more about future proofing and peace of mind.

Link: https://lore.kernel.org/20260722150006.3848560-1-hannes@cmpxchg.org
Link: https://lore.kernel.org/20260722150006.3848560-2-hannes@cmpxchg.org
Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Gregory Price <gourry@gourry.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4152,12 +4152,14 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 
 	psi_memstall_enter(&pflags);
 	delayacct_compact_start();
+	fs_reclaim_acquire(gfp_mask);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
 								prio, &page);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
+	fs_reclaim_release(gfp_mask);
 	psi_memstall_leave(&pflags);
 	delayacct_compact_end();
 


