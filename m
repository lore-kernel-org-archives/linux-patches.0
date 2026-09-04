Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FCB415B8F;
	Fri,  4 Sep 2026 05:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498482; cv=none; b=OzyBe75IjnmY9PBZpprlPx4ckQ9E7jukmfVpXmt1qGdm7MvIAG66mB7JkkSzXZLzgeEZLR6WqB/9sFKfgTPejdY/KDoA3QbHI4AszgJlHwSwVWskhzogEc6Ubb8MYX4qJlT1Kj/Slxxi6RqZe2s9kdfXEYK8TaTgFMKH2gDVCXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498482; c=relaxed/simple;
	bh=qzjtt3ip2pnxdi4+KVLwm7H2HJJ4WwAezzqXvzHhSzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnNdqO7bsBwGac+XVsiuJeL5qAUmccaeFSzd9EntYVMALuXq8raXiBbYevuUACOPV0m2kDI3xYjk+Nu71eWFZrsS/ls3as2D6Oj6jtFEENcvbrkVshnINlxXJTmXpy3a9yXslbv7CpKkXO6Q3wmvnguznXGEny7dCWRS/6hLAKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1aVtWPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1aVtWPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFDD1F00A3D;
	Fri,  4 Sep 2026 05:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498480;
	bh=RH8sB5wa+wqybl1Tn8hlnk9f9wvN3ZWatlA00TW+cSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1aVtWPxJBN+e+1wtDwc+X935i3JFxCtXQ9oy0bi5EVLomz4fxsVN87JeVMVZ/WU7
	 UyBLeVkjNovbsmP2A792FtyVuMLce671d+4hmW4FLdHM4WnJ0GWQcB8XMH1U7zjPgT
	 VnDBoUA8v+3Sr28Q8aYy+TTW0db86+wH9gyxin9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Neha Gholkar <nehagholkar@gmail.com>,
	Gregory Price <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 076/713] mm: mempolicy: fix automatic numa balancing for shmem
Date: Fri,  4 Sep 2026 06:50:44 +0200
Message-ID: <20260904045805.543518991@linuxfoundation.org>
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

commit d230991493b521eeff39f32434fddcbcdb109eb0 upstream.

Neha reports that mapped shmem aren't considered for NUMA balancing,
noting convergence problems and bandwidth bottlenecking for cachelib based
workloads on tiered memory systems.

Looking at the code and going through the git history, this doesn't
actually seem intentional:

Commit fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault
VMAs") added a vma_policy_mof() gate to task_numa_work() so VMAs whose
policy lacks MPOL_F_MOF are skipped from NUMA balancing scans.  The
motivation was a real usecase: Oracle was pinning shared segments with
mbind(MPOL_BIND) so trapping faults was both expensive and pointless.

The handling of NULL from vm_ops->get_policy, however, treated "user
explicitly opted out" the same as "user never specified anything." For
VMAs whose shared policy is absent - the common case for shmem - the scan
was disabled too.

This issue is old.  It probably hurts less in conventional NUMA.  But it's
very noticeable on tiered systems, where entire tmpfs workingsets can get
stuck on lower-bandwidth memory.

Fix this by having vma_policy_mof() use __get_vma_policy() directly, and
thereby handle the fallback to task policy (-> preferred_node_policy() has
MPOL_F_MOF per default).  Every other consumer of vm_ops->get_policy
already handles it this way, the scan-eligibility check was the outlier.

This preserves Mel's intended fix: don't scan stuff the user explicitly
pinned.  But allow default policy vmas to participate in balancing.

Link: https://lore.kernel.org/20260629163337.1264881-1-hannes@cmpxchg.org
Fixes: fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault VMAs")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Neha Gholkar <nehagholkar@gmail.com>
Tested-by: Neha Gholkar <nehagholkar@gmail.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2059,24 +2059,15 @@ struct mempolicy *get_vma_policy(struct
 bool vma_policy_mof(struct vm_area_struct *vma)
 {
 	struct mempolicy *pol;
+	pgoff_t ilx;
+	bool mof;
 
-	if (vma->vm_ops && vma->vm_ops->get_policy) {
-		bool ret = false;
-		pgoff_t ilx;		/* ignored here */
-
-		pol = vma->vm_ops->get_policy(vma, vma->vm_start, &ilx);
-		if (pol && (pol->flags & MPOL_F_MOF))
-			ret = true;
-		mpol_cond_put(pol);
-
-		return ret;
-	}
-
-	pol = vma->vm_policy;
+	pol = __get_vma_policy(vma, vma->vm_start, &ilx);
 	if (!pol)
 		pol = get_task_policy(current);
-
-	return pol->flags & MPOL_F_MOF;
+	mof = pol->flags & MPOL_F_MOF;
+	mpol_cond_put(pol);
+	return mof;
 }
 
 bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone)


