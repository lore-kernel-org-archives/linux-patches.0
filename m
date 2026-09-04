Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6073F405C3F;
	Fri,  4 Sep 2026 06:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501918; cv=none; b=feswVPuWR65SkeIfvJsgQLll2o69wdmh9elqFlTt6rFCWnQCkScwoEMUk8r/CrJZb+P5j/azF7qT9lSrcxers0N4LiF1cCWv+NosSxTipAsiTi8P74wnkWDDKITgp8GLePlvps4kBBgJgYqinl1Pu7x0iu4WtdaNarp1YnIg2Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501918; c=relaxed/simple;
	bh=gE5bXcPYjpJlQdeyAyRk8EKWL/w6s76PbqV0Z/xGMtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxkZUDe7pwUAa4g/bJlyZ6SdoSu+JMPcGLXqH5IK9Gbm635IBtrmiuw/xhbcG5WkXo8ScdGGZMUyXSEmxc4MKw6p6Kw7xptjZNs8dKRV+1QA18Q4Bn23VoO3XlMeXdkgASpravyB1zr0T4Q/GPT5SaM947Gg0fp6aRYUc9FxNKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJ4b0WnA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJ4b0WnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA301F00A3E;
	Fri,  4 Sep 2026 06:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501916;
	bh=nPq96M3yE4AidtXy97uMuVHx3RecoqGQMMb2nsZbRls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YJ4b0WnAPBWzz7SSdo1zYzzyasaz741KvcV8bvolEsn0UtdPqu8xUbqWveXTNfF5Z
	 TbvDfRHxUkmGadd6MV/XVFg/K7qaqhvFeXqOvvSIFB4xM9hSsqyKrJKTB31xKGPBb3
	 yeFxpfMz88NuF2mI0GjPg8fw95wogZMOr2DTyrrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 025/403] mm/vmscan: report RCU-tasks quiescent states in shrink_lruvec()
Date: Fri,  4 Sep 2026 06:57:08 +0200
Message-ID: <20260904045735.389190465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit 25f52e81216884a7444bf07a606691feb09a94e3 upstream.

I am seeing some rcu_tasks stalls in the Meta fleet during reclaim.

  INFO: rcu_tasks detected stalls on tasks:
	0000000088620d09: .. nvcsw: 6735/6735 holdout: 1 idle_cpu: -1/8
	task:GlobalCPUThread state:R  running task  pid:2552016 tgid:2524552
  Call Trace:
   shrink_lruvec
   mem_cgroup_iter
   shrink_node
   do_try_to_free_pages
   try_to_free_pages
   __alloc_frozen_pages_noprof
   alloc_pages_noprof
   pte_alloc_one
   __pte_alloc
   handle_mm_fault

Nothing promises direct reclaim returns in bounded time, and the scan loop
in shrink_lruvec() only calls cond_resched(), which is a no-op on
PREEMPTION kernels.  Involuntary preemption is not a Tasks-RCU quiescent
state, so the reclaiming task never reports one and becomes a holdout.

Upgrade it to cond_resched_tasks_rcu_qs(), which reports a quiescent state
even when cond_resched() does nothing.

PS: This has been discussed in [1]

Link: https://lore.kernel.org/20260810-rcu_task_shrink_lruvec-v1-1-4d9f7d5251cb@debian.org
Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5761,7 +5761,7 @@ static void shrink_lruvec(struct lruvec
 			}
 		}
 
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		if (nr_reclaimed < nr_to_reclaim || proportional_reclaim)
 			continue;


