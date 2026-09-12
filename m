Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95CF3AC0ED;
	Sat, 12 Sep 2026 17:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232550; cv=none; b=nTyR7irsICmgoJvum3U7CuUFqNTEdAbLvIEopIBU9s9QmW6bYOHtVCQ4G/eLV/lIrCSMh3QhISNGvk65mB2FVYrpTHlTuMKub+61vMfgp3ccF1WfX9lM5y4cK4FW40+tLYVXnd8Q+Q1ZUHejSTL2yNpzyQvtYRZuSl2Tz3e1jF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232550; c=relaxed/simple;
	bh=SbXAKL4F6pd7ZD3bYYe3o0NU07maj3i5UssxMxsqTQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyiS2xrIj2yjI/2G9y+Ym/nWGHpxegsZ6qDcDQQeWCwrI9V0716yZIIkfyDRWCF9mlIViL1332gwu7yjLti8D59rInERPTP+Rlt5AqLsw8u5LGayZ19VSm8GhuDAJureNXDfNb56Z1TJOusilogdrpb6C6tXb5ZFjBwzt8q+99w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h933jAcc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h933jAcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5911F000FF;
	Sat, 12 Sep 2026 17:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232548;
	bh=zTxEAqEuX89klez98Zz5hzOmAP8ir5DnKilrUSB742I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h933jAcc8y1Ap4NPWPTp89bsFXSbX8A++xxdGYzodKf5cej1JzCI47mFf4wOSjUGZ
	 sEZCboAz0jQaijrWwnqxLk4/JwFzo32OaqkIJF0p+N1rG1Pb34Z3U2Ex7BstPIFWIq
	 OiWBMMhShmozlS05YzrVQfcTZajqhojKjfOLaUjQ=
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
Subject: [PATCH 5.15 007/935] mm/vmscan: report RCU-tasks quiescent states in shrink_lruvec()
Date: Sat, 12 Sep 2026 08:50:37 +0200
Message-ID: <20260912065527.009161641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
@@ -2771,7 +2771,7 @@ static void shrink_lruvec(struct lruvec
 			}
 		}
 
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		if (nr_reclaimed < nr_to_reclaim || proportional_reclaim)
 			continue;


