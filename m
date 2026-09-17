Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334884EF123;
	Thu, 17 Sep 2026 17:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665410; cv=none; b=By6YimlfllPjPyJTt1eOBybzUO+k1sAAVEX/1V1zvSejGiVoimNpi7ETx8vkV3X/MSE7804RlbWRIEZSVcVcPoWGRjPHVvABVbL4r7W2qT+YpOHfi0LHKYqSKw3bvQ0wDwPkd6SCAL2UNk5W+xGg0zbsl4TKIUBDP2Hyth22z1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665410; c=relaxed/simple;
	bh=c4DSUiU5XN90dMWwMR6SRhHWeZWsqW+UfGN/ljQ5/zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLTCPL/yBzCTHyfEENYFWRG78NTarbKUtvgpkfha2ARyykVUc46F3lrRMb7XCk2EW5f4ZzGJBr1ybJ5GgBPi5KUUyeVBN77vUTmoBoryb+TfwDr7sMCqp6xm5DHDqDYTEARuCAYES7ehhsBXC2rwvUffig4Tu5jgP9pBpXvIus0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uysz2lOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uysz2lOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6791F000FF;
	Thu, 17 Sep 2026 17:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665409;
	bh=+KsabF6FgfttSWLsASKr1Qbli7ZJjhzztn6wH1bdKHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uysz2lOEMLEt1CuZ2wZ5yMtOrjrqrKIu+tG2FKk/TPNNQYdJI2oubVgSEvP/FsoTC
	 I5Jq19tjot6PpczWMTQ6+i/tlcr9K5D/e/p2glvXrruE3XfFEbzYVH5InX1SiC1fzt
	 FirAsh45bcziHtwXq+MT61jtOg21lbw1Uwia4Gcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wanwu Li <liwanwu@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0656/1250] sched_ext: Fix timer pinning and return value in scx_central
Date: Thu, 17 Sep 2026 16:07:31 +0100
Message-ID: <20260917151609.675526268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 55df8b7988657..4f0eee5d8f26b 100644
--- a/tools/sched_ext/scx_central.bpf.c
+++ b/tools/sched_ext/scx_central.bpf.c
@@ -256,6 +256,7 @@ static int central_timerfn(void *map, int *key, struct bpf_timer *timer)
 	u64 now = scx_bpf_now();
 	u64 nr_to_kick = nr_queued;
 	s32 i, curr_cpu;
+	int ret;
 
 	curr_cpu = bpf_get_smp_processor_id();
 	if (timer_pinned && (curr_cpu != central_cpu)) {
@@ -289,7 +290,10 @@ static int central_timerfn(void *map, int *key, struct bpf_timer *timer)
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



