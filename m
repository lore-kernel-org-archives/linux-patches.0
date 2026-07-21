Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D93922B8DF;
	Tue, 21 Jul 2026 18:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660325; cv=none; b=XNPfRxasV5j9uBYGUrhHSkequKwVqihiPNOMd75LXN6Xd+m2BH7ZkzIj5Ir9nLPuH/JkD2OBnFUVoHi93CGkcv2550GJdHPuCgSuqSqWvqiMWw3EL0/vUxFpuxIZMIOHHwTBH7ZyFDo09ae6SEioCEyXYHV0yEcmuEyuk/pi7PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660325; c=relaxed/simple;
	bh=05nP42QSw3QWm06ixgcZcj/I5piFSGT+HJURw4qgbBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2jS26SXdbn5sH9/pJDiJNtK18fmETsTrv8I+WLxBpgcNdZbS14n9PpcVSe7d/Tcn4RNV3e4ZRKX2/hZt2MyAk9teBrbF3o4mlOsxCnzMOGIAw24LuOfwSBGDGXEWiHR1hYNslV7ERxs7tzhsmxTnID3TmLqcgRvPfu+N7M0XzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PU9Ss8nn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PU9Ss8nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91A31F000E9;
	Tue, 21 Jul 2026 18:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660324;
	bh=dgSRX33BFP51L5UmIWJ9OYgLQ2qy0HCTvkJ8Uc2nKUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PU9Ss8nnRKzRcAjDuUb1fOAAP92gT79ZWl0W1wT+0LonGNIVqQ/Uv+Kr4tdnEiGf6
	 ssOXY36aYWY2gP/f/BAn0/By7Vw1ibmnKtZCuVR0q/UlvPSnzZCN+bNQLFU/jeiq8V
	 TSLR2I4uDzrkvgelDTKd90xQiGZNADaEJb4LXQ6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0937/2077] perf sched: Cap max_cpu at MAX_CPUS in timehist sample processing
Date: Tue, 21 Jul 2026 17:10:10 +0200
Message-ID: <20260721152614.917207379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 06e7994427ab56e32699a5e45d048ff0826f3d53 ]

perf_timehist__process_sample() updates sched->max_cpu from the
sample CPU without bounds checking.  Later code uses max_cpu + 1 as
an iteration count over arrays allocated with MAX_CPUS entries
(curr_thread, cpu_last_switched).  A recording with CPU IDs >= MAX_CPUS
causes out-of-bounds array accesses.

Also cap the env->nr_cpus_online initialization of max_cpu in
perf_sched__timehist(), which could exceed MAX_CPUS on very large
systems.

Add bounds checks before both max_cpu updates, matching the pattern
already used in map_switch_event().

Fixes: 49394a2a24c7 ("perf sched timehist: Introduce timehist command")
Reviewed-by: David Ahern <dsahern@kernel.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 7503fc00ff20a3..7cb27fba12a909 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3219,7 +3219,9 @@ static int perf_timehist__process_sample(const struct perf_tool *tool,
 		.cpu = sample->cpu,
 	};
 
-	if (this_cpu.cpu > sched->max_cpu.cpu)
+	/* max_cpu indexes arrays allocated with MAX_CPUS entries */
+	if (this_cpu.cpu >= 0 && this_cpu.cpu < MAX_CPUS &&
+	    this_cpu.cpu > sched->max_cpu.cpu)
 		sched->max_cpu = this_cpu;
 
 	if (evsel->handler != NULL) {
@@ -3389,8 +3391,8 @@ static int perf_sched__timehist(struct perf_sched *sched)
 		perf_session__set_tracepoints_handlers(session, migrate_handlers))
 		goto out;
 
-	/* pre-allocate struct for per-CPU idle stats */
-	sched->max_cpu.cpu = env->nr_cpus_online;
+	/* pre-allocate struct for per-CPU idle stats; cap to array bounds */
+	sched->max_cpu.cpu = min(env->nr_cpus_online, MAX_CPUS);
 	if (sched->max_cpu.cpu == 0)
 		sched->max_cpu.cpu = 4;
 	if (init_idle_threads(sched->max_cpu.cpu))
-- 
2.53.0



