Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B57330B06;
	Fri, 17 Oct 2025 15:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716592; cv=none; b=cqzHsZbd+Bp8DVNGXo27EUPYlPfogR02msskKdrXDoeUsZSma1KC/P7+iPNYzO5zHYpWVQLs+lQ+Q7q+MWbd2O29dT2O0Z9WA0SdX0zviLsjsR6zurpeDKxkcQSb1PoPa9pW2w7532TiUCNjQMtnKYWjKrDxeTmMHc1fbteUfdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716592; c=relaxed/simple;
	bh=fDExw3lajLnEojkhQwcYUzN2OKu8Kilww4+ymcb5DFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnVTYzs5vASix1jWplWS7Y9eW6Zu2I8It8XqMSpfPCT9s4lW5rf9BsN2PU+1sKlTzOC+dzotel0dXPcqHHOhHcbR/Nowm1IR0eRFQorMbJyhllryr3GGNZLdpeBoKimlzyHMRsZDp2KD8vvFqh7FPWawpvsONEhK62LO49HilGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1Di6Baw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1Di6Baw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46362C4CEE7;
	Fri, 17 Oct 2025 15:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716591;
	bh=fDExw3lajLnEojkhQwcYUzN2OKu8Kilww4+ymcb5DFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1Di6BawPMtpBE87ZL7Si+nBiitRzJW3q5aj4PR4zX/MWzVZ8RnryNx07MxotL9Ng
	 O9yO1dRz7c/XWaIZD/GH0/8EYIc+uwy3r+zd0qwSHjaFIpiiA0n5R6gX7NrrUlt8Xi
	 IzLu31SQQo6VU91J15e5aNgRSL8D053bpToDqRLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Helen Koike <koike@igalia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Michal Hocko <mhocko@suse.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Matthew Wilcox <willy@infradead.org>,
	NeilBrown <neilb@suse.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 216/276] mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH allocations
Date: Fri, 17 Oct 2025 16:55:09 +0200
Message-ID: <20251017145150.348477435@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

commit 6a204d4b14c99232e05d35305c27ebce1c009840 upstream.

Commit 524c48072e56 ("mm/page_alloc: rename ALLOC_HIGH to
ALLOC_MIN_RESERVE") is the start of a series that explains how __GFP_HIGH,
which implies ALLOC_MIN_RESERVE, is going to be used instead of
__GFP_ATOMIC for high atomic reserves.

Commit eb2e2b425c69 ("mm/page_alloc: explicitly record high-order atomic
allocations in alloc_flags") introduced ALLOC_HIGHATOMIC for such
allocations of order higher than 0.  It still used __GFP_ATOMIC, though.

Then, commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how
__GFP_HIGH non-blocking allocations accesses reserves") just turned that
check for !__GFP_DIRECT_RECLAIM, ignoring that high atomic reserves were
expected to test for __GFP_HIGH.

This leads to high atomic reserves being added for high-order GFP_NOWAIT
allocations and others that clear __GFP_DIRECT_RECLAIM, which is
unexpected.  Later, those reserves lead to 0-order allocations going to
the slow path and starting reclaim.

>From /proc/pagetypeinfo, without the patch:

Node    0, zone      DMA, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone    DMA32, type   HighAtomic      1      8     10      9      7      3      0      0      0      0      0
Node    0, zone   Normal, type   HighAtomic     64     20     12      5      0      0      0      0      0      0      0

With the patch:

Node    0, zone      DMA, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone    DMA32, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone   Normal, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0

Link: https://lkml.kernel.org/r/20250814172245.1259625-1-cascardo@igalia.com
Fixes: 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Tested-by: Helen Koike <koike@igalia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4743,7 +4743,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsig
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
 			alloc_flags |= ALLOC_NON_BLOCK;
 
-			if (order > 0)
+			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
 				alloc_flags |= ALLOC_HIGHATOMIC;
 		}
 


