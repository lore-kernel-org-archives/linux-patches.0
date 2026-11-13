Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590732;
	b=XX0gMCNpYn2Q8Nzy5ZCj3sobH46rLo9eEYUC74BJ7wd5/O6VBomWKY5x2eIVty/+d0ux
	 wOnX1V6i2NxYw0sT5Dp8DeVRDScYnm5DILAfRElOYX5o1dgbDgReXqVTMo3IDpfThWkxn
	 y7fLnHWWxCIDLBLMqNOSudVI0haLSjfyzX8yD/USufs1VeDEORnFkF2GgfQwIElbyIMTA
	 0g8bt9xEKt1wBeiMBWTFliHG8miHLkjcDMvw2hejQ765VZiiq5/QIvHa+x4hUGUk6L89K
	 CKnKxJESmW3bHfDQvUW8rF66LwQQ5JdyV6HNf47Ly/oBA2n4mZM4HwLrmVpzXbsD7TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IVDs7es/3i4Jz1J76pqZ6EdRRj2UGGTgqnU6mKmC64E=;
	b=cCKO+HEmTNeSiChVp6SwBG8Oh0H28DHvdMStou9Ov7qH/gee7J5+0iCrMV5vigK886az
	 lRcLyDLnZvMPws4nvMGNLuyefM0mB5aDOPFS1FniXo35VBveZlFtwgUECwSzFcTzXYOAC
	 C2wgR9WmYFrF9dIlj7VfLR2peOqmBpIju0lpV41S2f/dOtwLrX0MBPVscYtqGKjcmHKHe
	 sKOnZ5FWzRqhoLLdLrzCtzLY7kbQ0Gh+Dpeqht3eNLkMOUDOTnB0j284hxTMOdrXmecd/
	 rBSZd3sIuIafwV01wMoBjDiLPVB4QFzWsKsGYosF8c9Kd3M0/pIqbuMT9V82kbOJ/jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XU5Qi7qV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D346079D6C;
	Fri, 13 Nov 2026 17:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XU5Qi7qV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D8D1F000C5;
	Fri, 13 Nov 2026 17:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590731;
	bh=IVDs7es/3i4Jz1J76pqZ6EdRRj2UGGTgqnU6mKmC64E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XU5Qi7qVvo3ucSoCAHPoorHEjP5r0/cHJypsQyOBgcLy8q/sDwK+d52wlq/ENBkbW
	 RZ70FfCCN8v0Gt6SMs41bnsASSBpj3aaem776H29rLFeZHDxe/ZyneKjpm1sVRKmgy
	 dEYNbyHRr33jl9Z1mrT29eiDRrEQOBvt0jgH2faU=
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
Subject: [PATCH 6.18 635/686] mm/hugetlb: charge folios to the target mms memcg
Date: Fri, 13 Nov 2026 10:52:48 -0500
Message-ID: <20261113153843.333694047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
[ sashal: Passed vma->vm_mm directly to mem_cgroup_charge_hugetlb() in alloc_hugetlb_folio() because hugetlb_alloc_folio() is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memcontrol.h | 8 +++++---
 mm/hugetlb.c               | 2 +-
 mm/memcontrol.c            | 6 ++++--
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 2df30cce143de..fc13c85ea903e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -662,7 +662,8 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 	return __mem_cgroup_charge(folio, mm, gfp);
 }
 
-int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
+int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
+			      gfp_t gfp);
 
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry);
@@ -1175,9 +1176,10 @@ static inline int mem_cgroup_charge(struct folio *folio,
 	return 0;
 }
 
-static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
+static inline int mem_cgroup_charge_hugetlb(struct folio *folio,
+					    struct mm_struct *mm, gfp_t gfp)
 {
-        return 0;
+	return 0;
 }
 
 static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fad8c38ab4da6..a8da4cb7ad10f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3125,7 +3125,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		}
 	}
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp);
+	ret = mem_cgroup_charge_hugetlb(folio, vma->vm_mm, gfp);
 	/*
 	 * Unconditionally increment NR_HUGETLB here. If it turns out that
 	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 61092a05f108e..3ce613dab616e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4824,6 +4824,7 @@ int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
 /**
  * mem_cgroup_charge_hugetlb - charge the memcg for a hugetlb folio
  * @folio: folio being charged
+ * @mm: mm context of the allocation target
  * @gfp: reclaim mode
  *
  * This function is called when allocating a huge page folio, after the page has
@@ -4833,9 +4834,10 @@ int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
  * Returns ENOMEM if the memcg is already full.
  * Returns 0 if either the charge was successful, or if we skip the charging.
  */
-int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
+int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
+			      gfp_t gfp)
 {
-	struct mem_cgroup *memcg = get_mem_cgroup_from_current();
+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
 	int ret = 0;
 
 	/*
-- 
2.53.0



