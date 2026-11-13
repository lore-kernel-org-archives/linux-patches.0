Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591589;
	b=YgzrUKW78La5dGrx46/X5MWmTP6/W/A6l/6XS4oa1Vrlv9yXd2KI1yL8DZ+ZFiVfhhsV
	 zcbvCOlzWGhztnvThg5KUQ/x7rczmpLvaBVRaWUtxmItO6GoF3bQ15/wXfNBHcmZClPoW
	 nPV3TJYYZ3mS/aTyabHGUS2JUO+7caaaISS+22pn/bgSArfG8Ho73qzM4IxVmepoKMJZE
	 WU7hcRqBP3nusbC0f3JT14ARfWtPCImgeQDoLIudV1Bgyvdz4jcxI6xUM/1MVT0enS68u
	 9L69nXMLz8kN6lMqz6V+Y4o4C9bCF5FazFHE9RemuacuL3pUmMhznUqqpht81pbIj/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hhulhz64MXKxndw17uMRcFJew3ZW2V5PgPvR5BvY7TM=;
	b=s8uyCUg4yyTxMoDhOk4vOOBPckok2tkNRIukPkh6s2sKj8BjR4YHkN2CGb240a+AOFJw
	 TW7sOumE4q1he7Sz9Bny1/SICw/cN/JqIPr64s/TLGEvGkwUJmi6lVz9e42IdH9AEiwl9
	 zd1tf3UD2S7KemMoQzY1LJ8h5tN/jvciErqXzZJruxUr3oLU84mDHxIJhIdhyB7BrHyBU
	 Ux6xqBNMrfTa1E9986QO0jX0oi4DF+/xOpDRqzS+gY09zr9ewOoJiZeRRVovqEZE4t79T
	 OyAinMi+LTD3ZpG0O60kjSl0ldQWlqdM+W6RLza+S9FVMjdqzAWLy/Zb+Bq5h5uzksA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=obtux5iD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944E9606E678;
	Fri, 13 Nov 2026 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=obtux5iD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E331F000C4;
	Fri, 13 Nov 2026 17:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591589;
	bh=Hhulhz64MXKxndw17uMRcFJew3ZW2V5PgPvR5BvY7TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obtux5iDxHIb+cacrY1cgQsE2Nd8ZNFm9pvaAHuOlxIHbq9zpEDkAnOGgru0IAktd
	 iY571vidklO1Jb2uh/KQGu1P0kwHHnGUKmfuOYieetiiiWdmioXnag3tTDvUNuOgsS
	 HBNKfesfHGIFVdkeE2FpvkBjGwhe3jPLTpaWcdu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinmeng Zhou <zhoujinmeng@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Hongfu Li <lihongfu@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 608/670] mm/hugetlb: charge folios to the target mms memcg
Date: Fri, 13 Nov 2026 10:52:52 -0500
Message-ID: <20261113153832.424747713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinmeng Zhou <jinmengzhou22@gmail.com>

[ Upstream commit c2deb1356d82c9d54bd2fcf1241cc97eb66fd81f ]

HugeTLB folios are currently charged to the memcg of the allocating task.
This gives the wrong result when a userfaultfd handler populates a HugeTLB
VMA that belongs to another process.  The UFFDIO_COPY ioctl operates on
the userfaultfd context's mm, but get_mem_cgroup_from_current() charges
the folio to the handler's memcg instead.

This can be reproduced by placing the faulting process and its userfaultfd
handler in different memory cgroups.  Have the target process register a
HugeTLB mapping with userfaultfd, trigger a missing fault, and let the
handler resolve it with UFFDIO_COPY.  The hugepage usage is then reported
in the handler's memory.current instead of the target's.

The generic userfaultfd population path avoids this problem by charging
folios to dst_vma->vm_mm.

Pass the target mm through hugetlb_alloc_folio() and charge the folio by
using get_mem_cgroup_from_mm().  This preserves the existing charge timing
and error handling while making HugeTLB userfaultfd population consistent
with the generic path.

Link: https://lore.kernel.org/20260903075048.3316-1-zhoujinmeng@bytedance.com
Fixes: 8cba9576df60 ("hugetlb: memcg: account hugetlb-backed memory in memory controller")
Signed-off-by: Jinmeng Zhou <zhoujinmeng@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Hongfu Li <lihongfu@kylinos.cn>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
[ sashal: Used vma->vm_mm directly in alloc_hugetlb_folio() instead of passing it through the unavailable upstream helpers. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 43f4f2a06f463..1dd80a5b72b07 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3043,7 +3043,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	bool deferred_reserve;
 	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
 
-	memcg = get_mem_cgroup_from_current();
+	memcg = get_mem_cgroup_from_mm(vma->vm_mm);
 	memcg_charge_ret = mem_cgroup_hugetlb_try_charge(memcg, gfp, nr_pages);
 	if (memcg_charge_ret == -ENOMEM) {
 		mem_cgroup_put(memcg);
-- 
2.53.0



