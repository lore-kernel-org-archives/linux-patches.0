Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C94444718;
	Tue, 21 Jul 2026 21:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668072; cv=none; b=hyyuB/KHYGoyGKX+03VR2GEg5aAGx6/pM+N2Th+/iyC4m7pQIXQ5QaUZbCUxi+3otVxQsdy20HGVEI6txAfODSm6r+7cs/a6poDsRSj7cTm0FQNHYqT/PW6Vj4tBeK6NDGhN033eFOvi2mpgyxIK/Dr5JcAjrWpO2BT2ub6K8lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668072; c=relaxed/simple;
	bh=+QJzsa2rloc2rSQ91NaSLdjg9CKjNy4wGJ2qWVoUdLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIpPkOm41YPNPLaLdNaMDdHll+oSdF6uO8KNGjFdLLK0P6iucZsG2rsbrne/d4b3yhAKQKInrSFOpLUFVsrfhi1OXGbyViFtFczRrTP/xsuNagJ0SKc8YZdaqhyp0+upyGxQ0uqOh+zCrpN+axx8MaKtvXhgd5feqAm9HV4HBPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUwrAj86; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUwrAj86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F331F000E9;
	Tue, 21 Jul 2026 21:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668068;
	bh=NF0ckHGsKCEyYce4n5xdBuNl8tXerKEsaQ7Jm5cMc2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LUwrAj86BlSSNFJzTAoDUDLiH8EDs1Id2dJQjLYCyVpiWnGusctpNqQ866uDAbfVH
	 C0zctw0gVCTLHwB80GUM8Nf9mltV1o6U0Oo9f9QwuWeE7Qs4My7+82eIYrnsK4j73T
	 MpmIihEhWTRMMuVA1I0x9HfHxw+zjLseYDz21cAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingfu Zhou <yingfu.zhou@shopee.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0035/1067] mm/vmscan: flush deferred TLB before freeing large folios
Date: Tue, 21 Jul 2026 17:10:36 +0200
Message-ID: <20260721152425.337260475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

In reclaim, shrink_folio_list() unmaps PTEs with a deferred, batched TLB
flush. The batch is only flushed by try_to_unmap_flush() near the end of
the function, just before the order-0 folios collected in @free_folios are
handed back to the allocator.

Large folios don't go through @free_folios -- they're freed inline at the
free_it label via destroy_large_folio(), which runs before that flush. So
a large folio's pages can be returned to the buddy allocator and reused
while another CPU still holds a stale TLB entry for them, and that CPU then
reads or executes through the stale translation into the reused page. For
file-backed large folios (e.g. executable text) this shows up as random
SIGSEGV/SIGILL in user space, with fault addresses that don't match the
code being run.

Flush the deferred batch before freeing a large folio inline, the same way
the order-0 path already waits for the flush.

Upstream this is fixed as a side effect of commit bc2ff4cbc329 ("mm: free
folios in a batch in shrink_folio_list()"), which is a larger change; this
is the minimal fix for -stable.

Reported-by: Yingfu Zhou <yingfu.zhou@shopee.com>
Fixes: bd4c82c22c36 ("mm, THP, swap: delay splitting THP after swapped out")
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reviewed-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f6f8c18dc45f57..964802dad63803 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2050,10 +2050,12 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 * Is there need to periodically free_folio_list? It would
 		 * appear not as the counts should be low
 		 */
-		if (unlikely(folio_test_large(folio)))
+		if (unlikely(folio_test_large(folio))) {
+			try_to_unmap_flush();
 			destroy_large_folio(folio);
-		else
+		} else {
 			list_add(&folio->lru, &free_folios);
+		}
 		continue;
 
 activate_locked_split:
-- 
2.53.0



