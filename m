Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058006;
	b=wgJ0enwj3M5TVUvrb/KdHvbJrw358ZSNOxYXtNwU7gsLjAN4wrUgQX5drF4BWyn/cIyl
	 SbpWpCPdDNrrdykJZSJQvF1n9k3XtJ9+Tsp62bpmsIxMtl9Lh90YpYQ+Zg4z1J6FMksQE
	 8WJhAj1dNFTKONEWNtGDuq9vJEIUDehy3aPeI2+xkndbHLAYv+0gxzcMfLqpxu1LvjUzW
	 a7dLwa0kUEpheoHSyScbZLWPh2EeOU8bVhNNACDhZ+IM4SeR+IvcJT1cUYJq7MqfjAPtd
	 a1PvBIGU8z4tNpIVnYV9OoUG46+cmBU4LooFUA9baKixjGtA2ni4nXdl+uuRF51dVpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=frUenuvuYI5n5HcLaU8UjYlTpRqw7p2BmQcwTxdB3N4=;
	b=oB56MAViCD9XHvHdVofoYZg1/DRMjqYpwsuaR8sXLrcEpMwt9F6/kO7l3Z0gmLV1tWYz
	 ZubE4coF4Cmf3DWKAtBgI4mLrRQl8v44vUP17vXDoqzUAal/Ls8yiPq9lotF81wGMF6UM
	 6jGDIA7h27kzCNGdNWroX82njWBurd9kENE957A/JVYPRzzTH212tfRCO0OqXrv1TMt2L
	 EW02elyRIFPioRfFRK8aPU/mXpoaO7Re0FKMs/a1nxG/tUZ258BIveCmuXJ/2zYTJPYaa
	 QhzInfk8L4nvCXFEiz5uDU02YuCt5K+WRPwMIyo9BmqXhhNs0EZT3DVmYCy+FcxZFUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nZ4EpMbm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB70606A325;
	Thu, 19 Nov 2026 03:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nZ4EpMbm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693591F000C4;
	Thu, 19 Nov 2026 03:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058006;
	bh=frUenuvuYI5n5HcLaU8UjYlTpRqw7p2BmQcwTxdB3N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZ4EpMbmgHyZaTJcBJhkzPQQ+iqU7sU1Ps6R8eXgn5JkvAdsqoRYwE88Q4lyhB5qV
	 SIE8wPpbDCGqkiAL+jhnjxMQfOx+vp0n1aI1mJmEeo8gqsp5EQuo7t3j1Y+xI8/6AD
	 foYqZHMdhC7/fYRoozG6+5cVK6PIasf+xllpfOQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Adam Litke <agl@us.ibm.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Rik van Riel <riel@surriel.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0332/1848] mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
Date: Wed, 18 Nov 2026 15:39:30 +0100
Message-ID: <20261118145926.133721100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit d8a9cd7fd2fb01211430c933932da58839b8ca65 ]

Let's fix another instance where we use a folio after dropping the PTL,
where someone else could e.g., MADV_DONTNEED it once we drop the PTL,
making us trigger a use-after-free on the folio.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-3-42796911043b@kernel.org
Fixes: cb6acd01e2e4 ("hugetlbfs: fix races and page leaks during migration")
Fixes: 1c9e8def43a3 ("userfaultfd: hugetlbfs: add UFFDIO_COPY support for shared mappings")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>
[ sashal: Adapted folio-based hugetlb_mfill_atomic_pte() logic to page-based hugetlb_mcopy_atomic_pte() without continue support. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b23c8b2699b58..da47b6d218e01 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4806,10 +4806,15 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 
-	spin_unlock(ptl);
 	set_page_huge_active(page);
 	if (vm_shared)
 		unlock_page(page);
+
+	/*
+	 * Hold the PTL until we're done with the page: the page table owns the
+	 * page reference now.
+	 */
+	spin_unlock(ptl);
 	ret = 0;
 out:
 	return ret;
-- 
2.53.0



