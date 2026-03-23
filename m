Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D676E387593;
	Mon, 23 Mar 2026 14:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276911; cv=none; b=jW/7pzuHlPocEILbwgTtjKM1UWPEHdXWlT7cBYJSd3j6msORD9CYDld9RQ1vYSlIQKD5vfxu3uKDTKZGIDGDNq8rkNurlYnVyz4Mvgn/q4BmSAo0kk2Q2jsnpzu4MAaw/hEuZ200SU8bu/Nmbh3EVnPdvJ3H7uNhTi/pNzFNPyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276911; c=relaxed/simple;
	bh=+ne5dcj5rOucQiG3Z49b+DjkhtN0VhGepV4zQm4wn5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ml9zKWPCm5fcN7wV3ExVnAY51hcQ0iPZ9+8Cwg/kixtjAvp8Q4cETJ8Di8L0li7YXyyRPkpGr5lBCqZRrUkzRVDXIHFlyO0Q4JZMGdY8Sr3RnQI5GXR6Ek9muZSmmkfrqZo0+vNWzOZ8ZSK8alA2G4DY/2pFKOCWpZBXUnCLUb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPUYDR7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPUYDR7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF18C4CEF7;
	Mon, 23 Mar 2026 14:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276911;
	bh=+ne5dcj5rOucQiG3Z49b+DjkhtN0VhGepV4zQm4wn5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPUYDR7DkbY96YYFmPlOTxgmwjIA9Q+dql/haEHsHko2DJJbHU0ADlj//FPq/Bvn9
	 C3TulcBuEnGeOgvGAkd8qAaboX83weAyI4l2s4/6pBh6UcABIdlmvoh0FCbBrt4tAl
	 AnDN/V9eNoP/ywH57KGLmpUKhmxMbF+seyqo3wag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Naveen N Rao <naveen@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 252/460] mm/page_alloc: forward the gfp flags from alloc_contig_range() to post_alloc_hook()
Date: Mon, 23 Mar 2026 14:44:08 +0100
Message-ID: <20260323134532.684058386@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 7b755570064fcb9cde37afd48f6bc65151097ba7 ]

In the __GFP_COMP case, we already pass the gfp_flags to
prep_new_page()->post_alloc_hook().  However, in the !__GFP_COMP case, we
essentially pass only hardcoded __GFP_MOVABLE to post_alloc_hook(),
preventing some action modifiers from being effective..

Let's pass our now properly adjusted gfp flags there as well.

This way, we can now support __GFP_ZERO for alloc_contig_*().

As a side effect, we now also support __GFP_SKIP_ZERO and__GFP_ZEROTAGS;
but we'll keep the more special stuff (KASAN, NOLOCKDEP) disabled for now.

It's worth noting that with __GFP_ZERO, we might unnecessarily zero pages
when we have to release part of our range using free_contig_range() again.
This can be optimized in the future, if ever required; the caller we'll
be converting (powernv/memtrace) next won't trigger this.

Link: https://lkml.kernel.org/r/20241203094732.200195-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: d155aab90fff ("mm/kfence: fix KASAN hardware tag faults during late enablement")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6579,7 +6579,7 @@ int __alloc_contig_migrate_range(struct
 	return (ret < 0) ? ret : 0;
 }
 
-static void split_free_pages(struct list_head *list)
+static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
 {
 	int order;
 
@@ -6590,7 +6590,7 @@ static void split_free_pages(struct list
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, __GFP_MOVABLE);
+			post_alloc_hook(page, order, gfp_mask);
 			set_page_refcounted(page);
 			if (!order)
 				continue;
@@ -6608,7 +6608,8 @@ static void split_free_pages(struct list
 static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 {
 	const gfp_t reclaim_mask = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
-	const gfp_t action_mask = __GFP_COMP | __GFP_RETRY_MAYFAIL | __GFP_NOWARN;
+	const gfp_t action_mask = __GFP_COMP | __GFP_RETRY_MAYFAIL | __GFP_NOWARN |
+				  __GFP_ZERO | __GFP_ZEROTAGS | __GFP_SKIP_ZERO;
 	const gfp_t cc_action_mask = __GFP_RETRY_MAYFAIL | __GFP_NOWARN;
 
 	/*
@@ -6756,7 +6757,7 @@ int alloc_contig_range_noprof(unsigned l
 	}
 
 	if (!(gfp_mask & __GFP_COMP)) {
-		split_free_pages(cc.freepages);
+		split_free_pages(cc.freepages, gfp_mask);
 
 		/* Free head and tail (if any) */
 		if (start != outer_start)


