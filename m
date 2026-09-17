Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9283B9DA1;
	Thu, 17 Sep 2026 18:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668807; cv=none; b=i7hKgow3fN4tJn8mM8NGOQKd5XyayrZ+xTJBvVmDfiLYVd5Uo6CEy1XyAKik7jHHl6zgax03SbUJ7Y90WRzRBVBV0q0ISbe7JvrpzEfMmNZnYdhxLNAXwdRq1avQikRPLaGvn3umLfuw0/G+TfJVpXfprS8/zxVvRAs4a5yTOHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668807; c=relaxed/simple;
	bh=hZnHYe1uNFA1ER9sbhVUm/N04xUXzAxQ7UTyzmRCzHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLnLFUgnKWSu1wH+Su+Q4tbOHB9HzaH3NoKug2LRaHKFOs/OwQpQOpXq4V7+lo8xcex1w0BBc4g8etG/regsBBLDWSyEJx5kVCmDcvHAeP/Vawlcl0TztCej4aGEAoJvEgevvv0R2mBZ/l9ApkNl6oLrEnEfTMF5uFbpEHXOPUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2Oon31k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2Oon31k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BCE1F00893;
	Thu, 17 Sep 2026 18:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668806;
	bh=Lrn0VcH4G0SyBWcuHr9XGxn9TGNVvuUUo2kOC0vAqPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2Oon31kBDBdfZV1vdAcsCWRLAh5CtMI08a5VgIR7vcEnr4I0by2zD0G9v7h7/ggR
	 xAlc/s4vg9s9F9BCzmAjOc4EI0gbwHCyLVMve4qSqxgUfIn/4766PCOcvF7PAmtdmz
	 6C2sEvFHve6rTYJoaGq7RuKgYUtCw2qewnr/gnU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wanwu Li <liwanwu@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0546/1102] sched_ext: Fix timer pinning and return value in scx_central
Date: Thu, 17 Sep 2026 16:08:09 +0100
Message-ID: <20260917151553.537819166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 8dd8eb73b6b8b..91a50e3ec1998 100644
--- a/tools/sched_ext/scx_central.bpf.c
+++ b/tools/sched_ext/scx_central.bpf.c
@@ -261,6 +261,7 @@ static int central_timerfn(void *map, int *key, struct bpf_timer *timer)
 	u64 now = bpf_ktime_get_ns();
 	u64 nr_to_kick = nr_queued;
 	s32 i, curr_cpu;
+	int ret;
 
 	curr_cpu = bpf_get_smp_processor_id();
 	if (timer_pinned && (curr_cpu != central_cpu)) {
@@ -294,7 +295,10 @@ static int central_timerfn(void *map, int *key, struct bpf_timer *timer)
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



