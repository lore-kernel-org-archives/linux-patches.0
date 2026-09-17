Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156785AEC6D;
	Thu, 17 Sep 2026 15:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659001; cv=none; b=AIUmy2dUOeJlqUx92H46bMWl7o86M5rr7lXY4DV8AHX1gnJgf5j04KLejI3+Yv76kgzeQfvZJWTHx+rWWdzg1Y0MfPpr22Na4swlz0X+8H1/Gm0TLEZXZR2k399HG3ZK/AgrQoHb5JmqLzUPqCeCEZLy7J4jpSRUgJeV3oau1Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659001; c=relaxed/simple;
	bh=QV/XDEerXu1rxttDl/Jb5ADmoX+G0apdN7scsDbORF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5UEqmjMU3OtVar88II2rcEm0Oa4aiiEEtXjMAxG3Rm5O1aYf3jsCe/Z8IiuNTGtj9r1bwHgn6LtuIkmKJ4Akke0uCmBEjF8bOHc7/GUgqDj4W0pa7OWjK8Go1d70plO8B+S/dco3FvdUapPZDA9kqPMSwANDoz5CFbHOyCU1gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAPQr5ST; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAPQr5ST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412D21F00898;
	Thu, 17 Sep 2026 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658986;
	bh=Oi1iZvblqCYn1tD9f0vZ82+dwPkpAjtk4K+UUEILNzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAPQr5ST525RPFsomGTytvKSv65Dhkhb37UrkzD8JepJTpJL5WuxzlmUzC9fj5aCu
	 aZOxR2aPQeTJdJMCqxcGvG+xbKknheTpHqF/zDabpJPYC96MwRENcUxDS3wo3K2DN2
	 oQklf9EekC1TutytbNsXKcypGhQtIQyrooAUShmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wanwu Li <liwanwu@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 105/733] sched_ext: Fix timer pinning and return value in scx_central
Date: Thu, 17 Sep 2026 16:06:53 +0100
Message-ID: <20260917151353.583256955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

[ Upstream commit 23761359861ca4bb087540937dfea8b0716914c2 ]

central_timerfn() re-arms the timer with a hardcoded
BPF_F_TIMER_CPU_PIN flag and ignores the return value, defeating
start_central_timer()'s -EINVAL fallback for kernels without the flag
(<6.7): on such kernels the first tick kills the timer permanently
with no diagnostic.  Honor timer_pinned and check the return like
the initial arm does.

Fixes: 22a920209ab6 ("sched_ext: Implement tickless support")
Signed-off-by: Wanwu Li <liwanwu@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_central.bpf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/sched_ext/scx_central.bpf.c b/tools/sched_ext/scx_central.bpf.c
index 64dd60b3e9223..65dae9e454009 100644
--- a/tools/sched_ext/scx_central.bpf.c
+++ b/tools/sched_ext/scx_central.bpf.c
@@ -299,6 +299,7 @@ static int central_timerfn(void *map, int *key, struct bpf_timer *timer)
 	u64 now = scx_bpf_now();
 	u64 nr_to_kick = nr_queued;
 	s32 i, curr_cpu;
+	int ret;
 
 	curr_cpu = bpf_get_smp_processor_id();
 	if (timer_pinned && (curr_cpu != central_cpu)) {
@@ -332,7 +333,10 @@ static int central_timerfn(void *map, int *key, struct bpf_timer *timer)
 		scx_bpf_kick_cpu(cpu, SCX_KICK_PREEMPT);
 	}
 
-	bpf_timer_start(timer, TIMER_INTERVAL_NS, BPF_F_TIMER_CPU_PIN);
+	ret = bpf_timer_start(timer, TIMER_INTERVAL_NS,
+			      timer_pinned ? BPF_F_TIMER_CPU_PIN : 0);
+	if (ret)
+		scx_bpf_error("bpf_timer_start failed (%d)", ret);
 	__sync_fetch_and_add(&nr_timers, 1);
 	return 0;
 }
-- 
2.53.0



