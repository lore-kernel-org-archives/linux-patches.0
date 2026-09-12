Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4854941F35E;
	Sat, 12 Sep 2026 13:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219642; cv=none; b=kLFRJJvJyK1eMRoacJpfXsdy0hzT60H72xC1dqJCsg6/2a09DQhWbafI5tjT7U7p1Fi/OkgR14uInZuxbNnVtm9o8otwnYY10nmW9J1IQB6WvY5zHpCOAg1GzVmyfAe8GVkEuq35V58tYZ08hImMjm+bXdST5Apgv9QttqQVCp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219642; c=relaxed/simple;
	bh=3F0I7g3ES3Os0a2ym+xB+ieFGJno2+bNrrXT7zFk1zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEXh+w/Rut2fSodvsUPwlBS6Eh0ny6iWc+TNOlQCEKt+S3Ye43jaa4XklcskCjEQUwWMdy8LUzFEChknzdKi+k0IrQE+DQCb25PpD36aAa2nHKGQ5PaHwcURPSd5lfP1gu9o0v3shVY5J0hw8qSN18VrpEQIgQzA9WuR5GFov60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMJIIjIv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMJIIjIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357A51F000FF;
	Sat, 12 Sep 2026 13:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219641;
	bh=iOcEaO4nph6emQaugikgxudRhAYHK5fvmEfr3Zw8taA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMJIIjIvDrBWHPul9Xc6SYCb+v1RDXDe21nxh2P2abrtshnlo+bblXBl+3yFkYpK7
	 jQFVrhrgW4tH+KaRE4NUn4bGukDwt7Ok1MQ6puOLP5Oz0wDbfiDfQiDpIpp7pVJl/n
	 Gk3rmBau6CCjbHsDWA4mjnA/V+eey+5IQ6+8Z24c=
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
Subject: [PATCH 6.6 0016/1424] mm/vmscan: report RCU-tasks quiescent states in shrink_lruvec()
Date: Sat, 12 Sep 2026 08:40:48 +0200
Message-ID: <20260912065607.660918651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6342,7 +6342,7 @@ static void shrink_lruvec(struct lruvec
 			}
 		}
 
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		if (nr_reclaimed < nr_to_reclaim || proportional_reclaim)
 			continue;


