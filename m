Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3813B813A;
	Sat, 12 Sep 2026 07:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196903; cv=none; b=OxaC4Pma/QhDPI+KPX41m6psLHTvpSknN5PlL+l6tL/DMzQOD0PXOGCnMSUVcmlUYeybqClo4S6klzoXAyNg8xOzdb0xRvwef1ME2pgFroXxoCYWKdy/O9tWPnKSKDJT+3JLHLd+V7iuFxp3IJeeBI5Opcb+PaTjmxFH2o9+qFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196903; c=relaxed/simple;
	bh=iIbwfLzVlcq4gyubyMDeMgwUvfB0+airxZaqmmM+HJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOX6b84PY/TNKo72/KeNH5bdUHlfj+7gennG6bBcESCqt4qrYsvDN2QH8kFyFEPz3APJgDhFeyptDaxBKOMCiE12f8kprnPr3Du8TcReALp7ydcW29FoICFSWTW7gO1jjiAkmLbLmJHTjErkbauGXPycy1g0Hc5FuBTdGG75dps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVhZ0wmu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVhZ0wmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1511F000FF;
	Sat, 12 Sep 2026 07:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196901;
	bh=3zN1VHrajg9vyJDnG4qYlK+OpYyTXO6HWn/8aAbQEb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVhZ0wmuFQ0eRn0bVVjLheGMHXfAmTw7i0lzWDsMmSPSMcI6IN+5w5YfAIBqZVptm
	 boCWMTMW0kJHbz9UI3nBynII+KKsCCMA4hsqe+HdOIQxNWfyGFGgpTzewPaI9Gulwa
	 Y2PAqlFpArOJepSf3duktY3uwVCadNcQivxp0qk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wanwu Li <liwanwu@kylinos.cn>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0061/1815] sched_ext/scx_flatcg: Fix cvtime_delta race and add hweight scaling to bypass charging
Date: Sat, 12 Sep 2026 08:30:11 +0200
Message-ID: <20260912065650.443367068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Wanwu Li <liwanwu@kylinos.cn>

[ Upstream commit a5cc43414b38decd50bdd447e558358a6fbd5864 ]

1. cgrp_cap_budget() used __sync_fetch_and_sub(&cgc->cvtime_delta,
   cgc->cvtime_delta) to atomically read and clear cvtime_delta. However,
   this is not a true atomic read-clear operation: the second argument
   (cgc->cvtime_delta) is evaluated as a normal read before the atomic
   fetch_and_sub executes. If a concurrent __sync_fetch_and_add() happens
   between the read and the sub, the added value gets included in the
   returned delta AND remains in cvtime_delta, causing double charging.

   Example:
   CPU 0 runs cgrp_cap_budget(), CPU 1 runs fcg_stopping().
   Assume cvtime_delta = 100 initially.

     T1  CPU 0: sub_val = cvtime_delta = 100                 cvtime_delta = 100
     T2  CPU 1: __sync_fetch_and_add(&cvtime_delta, 10)      cvtime_delta = 110
     T3  CPU 0: __sync_fetch_and_sub(&cvtime_delta, sub_val) cvtime_delta = 10
                                                                returns old=110

   delta = 110 (includes the 10 from CPU 1), but cvtime_delta = 10
   (the 10 also remains). The 10 is charged twice: once in delta
   (applied to cgv_node->cvtime) and once in the residual cvtime_delta
   (fetched again next time).

   Fix by using __sync_fetch_and_and(&cgc->cvtime_delta, 0).
   Disassembly comparison:
   (1) delta = __sync_fetch_and_sub(&cgc->cvtime_delta, cgc->cvtime_delta);
   228: (79) r7 = *(u64 *)(r9 +40)
   229: (87) r7 = -r7
   230: (db) r7 = atomic64_fetch_add((u64 *)(r9 +40), r7) //r9 may be changed

   (2) delta = __sync_fetch_and_and(&cgc->cvtime_delta, 0);
   228: (b7) r8 = 0
   229: (db) r8 = atomic64_xchg((u64 *)(r9 +40), r8)

2. The bypass charging path in fcg_stopping() charges raw execution time
   to cvtime_delta without scaling by the inverse of the cgroup hweight.
   Since cvtime_delta is eventually applied to cgv_node->cvtime which is
   in vtime space (weight-scaled), the bypass path should also scale by
   FCG_HWEIGHT_ONE / hweight to match the units used by the dispatch path.

Fixes: a4103eacc2ab ("sched_ext: Add a cgroup scheduler which uses flattened hierarchy")
Signed-off-by: Wanwu Li <liwanwu@kylinos.cn>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_flatcg.bpf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/sched_ext/scx_flatcg.bpf.c b/tools/sched_ext/scx_flatcg.bpf.c
index fec3595818269..0fd214cc61dae 100644
--- a/tools/sched_ext/scx_flatcg.bpf.c
+++ b/tools/sched_ext/scx_flatcg.bpf.c
@@ -256,7 +256,7 @@ static void cgrp_cap_budget(struct cgv_node *cgv_node, struct fcg_cgrp_ctx *cgc)
 	 * and thus can't be updated and repositioned. Instead, we collect the
 	 * vtime deltas separately and apply it asynchronously here.
 	 */
-	delta = __sync_fetch_and_sub(&cgc->cvtime_delta, cgc->cvtime_delta);
+	delta = __sync_fetch_and_and(&cgc->cvtime_delta, 0);
 	cvtime = cgv_node->cvtime + delta;
 
 	/*
@@ -570,7 +570,8 @@ void BPF_STRUCT_OPS(fcg_stopping, struct task_struct *p, bool runnable)
 	cgc = find_cgrp_ctx(cgrp);
 	if (cgc) {
 		__sync_fetch_and_add(&cgc->cvtime_delta,
-				     p->se.sum_exec_runtime - taskc->bypassed_at);
+				     (p->se.sum_exec_runtime - taskc->bypassed_at) *
+				     FCG_HWEIGHT_ONE / (cgc->hweight ?: 1));
 		taskc->bypassed_at = 0;
 	}
 	bpf_cgroup_release(cgrp);
-- 
2.53.0



