Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD5015705F;
	Mon, 29 Jan 2024 17:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548114; cv=none; b=ATFK88vThaoO+KtsV0Qi1HjIdFxK2FlZpZJdLFGGVZ4+MABLWXES1SaiyrFVmNk0I6/dRCIXHIU8iQ05Kis0MGkiZln+5J+FtZQYpUtkPstViWHg7vs7TTUfDOhZtdLAyIoNwHb2aPQ1qJeEcd3mvJ2jQk3KpQh0sfLohNYCwok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548114; c=relaxed/simple;
	bh=HGCzG06EeLdonMuvNdd64AudNDrvFeBQlqOu10KOu/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMzlT9oGubBbwIGMeVrQa518d5KmAQoVDqaR+pBr+5goMcMffVDUxly5BC0Dhro2P1k8Z2K3N+Z2TRKyLN7M8eRQmgorVhBRslGsX04JpJWrwhJNxvohctGfbl2oNEKWKG6PVOUIH4M7ElNj4NaSVJYV30P6AlcG/yFHV8qlY88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJnCsN2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJnCsN2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAC0C433B1;
	Mon, 29 Jan 2024 17:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548114;
	bh=HGCzG06EeLdonMuvNdd64AudNDrvFeBQlqOu10KOu/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJnCsN2nM5gRmNneMIqhSPwGlh1nFjMY8ddwhythApHf0F18XWI5K7g1SQl77LQsI
	 s5/6fUkk2yDvf9QiLeIZcggG9G8KTo6W2WoY9VxynLtJPNZx5gB+uMa3NRjN7RSDCK
	 HNJGRYquZm6zBsKKDopvRqm/jGmSZAr4gE+Sw5Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	Chris Goldsworthy <quic_cgoldswo@quicinc.com>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Pavankumar Kondeti <quic_pkondeti@quicinc.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 137/346] mm: page_alloc: unreserve highatomic page blocks before oom
Date: Mon, 29 Jan 2024 09:02:48 -0800
Message-ID: <20240129170020.418993237@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charan Teja Kalla <quic_charante@quicinc.com>

commit ac3f3b0a55518056bc80ed32a41931c99e1f7d81 upstream.

__alloc_pages_direct_reclaim() is called from slowpath allocation where
high atomic reserves can be unreserved after there is a progress in
reclaim and yet no suitable page is found.  Later should_reclaim_retry()
gets called from slow path allocation to decide if the reclaim needs to be
retried before OOM kill path is taken.

should_reclaim_retry() checks the available(reclaimable + free pages)
memory against the min wmark levels of a zone and returns:

a) true, if it is above the min wmark so that slow path allocation will
   do the reclaim retries.

b) false, thus slowpath allocation takes oom kill path.

should_reclaim_retry() can also unreserves the high atomic reserves **but
only after all the reclaim retries are exhausted.**

In a case where there are almost none reclaimable memory and free pages
contains mostly the high atomic reserves but allocation context can't use
these high atomic reserves, makes the available memory below min wmark
levels hence false is returned from should_reclaim_retry() leading the
allocation request to take OOM kill path.  This can turn into a early oom
kill if high atomic reserves are holding lot of free memory and
unreserving of them is not attempted.

(early)OOM is encountered on a VM with the below state:
[  295.998653] Normal free:7728kB boost:0kB min:804kB low:1004kB
high:1204kB reserved_highatomic:8192KB active_anon:4kB inactive_anon:0kB
active_file:24kB inactive_file:24kB unevictable:1220kB writepending:0kB
present:70732kB managed:49224kB mlocked:0kB bounce:0kB free_pcp:688kB
local_pcp:492kB free_cma:0kB
[  295.998656] lowmem_reserve[]: 0 32
[  295.998659] Normal: 508*4kB (UMEH) 241*8kB (UMEH) 143*16kB (UMEH)
33*32kB (UH) 7*64kB (UH) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB
0*4096kB = 7752kB

Per above log, the free memory of ~7MB exist in the high atomic reserves
is not freed up before falling back to oom kill path.

Fix it by trying to unreserve the high atomic reserves in
should_reclaim_retry() before __alloc_pages_direct_reclaim() can fallback
to oom kill path.

Link: https://lkml.kernel.org/r/1700823445-27531-1-git-send-email-quic_charante@quicinc.com
Fixes: 0aaa29a56e4f ("mm, page_alloc: reserve pageblocks for high-order atomic allocations on demand")
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Reported-by: Chris Goldsworthy <quic_cgoldswo@quicinc.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Chris Goldsworthy <quic_cgoldswo@quicinc.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3951,14 +3951,9 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 	else
 		(*no_progress_loops)++;
 
-	/*
-	 * Make sure we converge to OOM if we cannot make any progress
-	 * several times in the row.
-	 */
-	if (*no_progress_loops > MAX_RECLAIM_RETRIES) {
-		/* Before OOM, exhaust highatomic_reserve */
-		return unreserve_highatomic_pageblock(ac, true);
-	}
+	if (*no_progress_loops > MAX_RECLAIM_RETRIES)
+		goto out;
+
 
 	/*
 	 * Keep reclaiming pages while there is a chance this will lead
@@ -4001,6 +3996,11 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		schedule_timeout_uninterruptible(1);
 	else
 		cond_resched();
+out:
+	/* Before OOM, exhaust highatomic_reserve */
+	if (!ret)
+		return unreserve_highatomic_pageblock(ac, true);
+
 	return ret;
 }
 


