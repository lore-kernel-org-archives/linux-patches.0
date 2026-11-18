Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053704;
	b=ojkt1DKrxhoXs3hcbOXFnWkvOPw0wPmaJqxpNtvL4/OFAs355/7iMCxo6dxupK8RTBhM
	 5Q2GmkSVV4EbsswwZZE9hMwd9fWTjYSxvIyPxyq1kzSt6wYfMQUQ0Hq0xisjbINfupata
	 50KAdjTTFuoNqMKggE/bY9iQN7BjHcAsVRjcgHfayphVU+UcmFKmap+H8c4l6lHAB4g5J
	 3pCof+qkO/yLXTmqHn/ydcDZ4UqxEXtJQqwrI/Q2xyhuRA+r27VxKU0frWm/cDlh5czgl
	 MdFzdbwjfOI2KfkokkYiFofX9c9J5gd9HEzg+mhJIxNhmGny+640xL5TyI351cYE1mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g6vKVuasMkoUOMYgffa1iiG9zunRNdJY9cS3pMJ/spw=;
	b=Qz7S5IOuEYXo4t2jjv9VfXuRl0XoaZoIJDkRF0dnijCCAT17HegNlytTD/bcGnQx+qKa
	 FScRg6ZnEqnl7MnXkVMR0XbvINcHF/kOOPjy1jrXoYfH7vUlxh2McmyUtsUyLs0rw5AP5
	 arCRdaN/HGSFwMmDKnBgYgwDqX13O0MV1Ocq2wW3VjQKWMR4cG7N5NlQ2dx6SkKfb4fCY
	 oCcCshBTiAmOVq2DBU+/SbwISAtMVmTgFyTTQ29ekmUdPicTYNkYt55ZJqe+t0MtqWezf
	 E4yu+K6EUM0RSgiy2xF6SCcuC8MjayskszEwdu4J/ix2MRJIHtyVB/2X0U5vaxXvd3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YBI5kfP6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54428606A320;
	Thu, 19 Nov 2026 02:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YBI5kfP6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A4D1F000C4;
	Thu, 19 Nov 2026 02:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053704;
	bh=g6vKVuasMkoUOMYgffa1iiG9zunRNdJY9cS3pMJ/spw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBI5kfP6vA+ZVWc0AVf/4eFxt8WTf8x0bb3KIUt61b4oshQJt2u/42Do3LJYdDsq4
	 53rW0C6HaUiqk9+R3G75jNnfkLdLCrop+/2tFWMc+E9pnHAhDaSzl/q+SsUctIXtDt
	 z63Bl25swDPVcZ/ukSU3XjoUWJu2Dvy29EThVOvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samarth Narang <samarth.colleges@gmail.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1012/2214] mm/madvise: atomically clear the young bit on THP MADV_COLD
Date: Wed, 18 Nov 2026 15:44:48 +0100
Message-ID: <20261118150052.862860948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Falcato <pfalcato@suse.de>

[ Upstream commit 246c8cc33438a71c28f9b86baa492d9a0a130316 ]

As-is, madvise_cold_or_pageout_pte_range() discards the hardware young bit
by invalidating the PMD, doing pmd_mkold() and subsequently writing to the
pmd again.  However, it does so in a racy manner, looking at a
possibly-stale snapshot.  It's entirely possible that a write elsewhere
set the hardware D bit, which this logic now loses.

Fix it by using pmdp_test_and_clear_young().  This is an atomic
modification of the PMD entry, and thus safe against any possible racing
writes.  As a (nice) side-effect, this elides one non-required TLB flush
in pmdp_invalidate().

This bug can interact with the swapping system in complicated ways,
leading to data loss.  For instance, if a folio is marked lazyfree, but
was later read from, and then MADV_COLD'd while racing a write to that
same THP, dropping the dirty bit may lead to data loss as
reclaim/MADV_PAGEOUT drops the "clean" anon folio:

T0                                T1
================================================================
MADV_FREE(thp)			|
  folio marked lazyfree		|
read(thp)			|
  PMD marked young by hardware	|
				| MADV_COLD(thp)
write(thp)			|   if (pmd_young(pmd)) {
  PMD marked dirty by hardware	|     set(pmdp, pmd_mkold(pmd));
MADV_PAGEOUT/reclaim		|
  dirty bit may or may not be   |
  set				|
    reclaim/pageout may drop    |
    the folio			|

Link: https://lore.kernel.org/20261013191719.95502-1-pfalcato@suse.de
Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Samarth Narang <samarth.colleges@gmail.com>
Closes: https://lore.kernel.org/linux-mm/20261011132227.413217-1-samarth.colleges@gmail.com/
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
[ sashal: adjusted context for the pmd_young() check without the !pageout guard ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 367220e1fe52a..3079da08c19de 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -363,10 +363,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		}
 
 		if (pmd_young(orig_pmd)) {
-			pmdp_invalidate(vma, addr, pmd);
-			orig_pmd = pmd_mkold(orig_pmd);
-
-			set_pmd_at(mm, addr, pmd, orig_pmd);
+			pmdp_test_and_clear_young(vma, addr, pmd);
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-- 
2.53.0



