Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2849415F33;
	Tue, 21 Jul 2026 18:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657114; cv=none; b=RKguhK1Ay/6mQn66KiO+k0CK+bqu1GBEi9BRkUVWXictlcfOpGzGFHnSTl8lk101G82HTHi+iFTAVgZAAYDMglkwP8QndOHa70E6+3aOgks5CZg/eB4TPU+B1trA9/+M02fjcsZZeqGwMqF6hV3w94pSsW/1TtON3LK3sYyzj04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657114; c=relaxed/simple;
	bh=IeGcXU+mtMYkgSGv+7G71u1l1CBAgNiObFxcsL3wdrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHNam7wfQhlU65MHFseyFOMgTg6TtCrjKgsaGHQTqT6VNmhtWwqGlt2P3g0EYWIXPSw74lLyVd8bV3UcwzOzFeIL+79u7GUQ/UnLdo0d1WEf8QnKAU5ZHCRlr0F8+q31bjkfb/zJ8rAIQgzI5mkaUauw+cxKE/DRBzheTeKm3A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYS64YvI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYS64YvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646611F000E9;
	Tue, 21 Jul 2026 18:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657112;
	bh=c+LCkqF9OD+4pEFVDs1wpc7I9lh1QR57CvEIDq+zwWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYS64YvIsAf9ycmO+pIAPitDnJ2CCmyrNzMOhuSLBuf6aUc9BhyjG6nqW+jf/yvn3
	 ClFo1yFU3wqCgy0tagDgyFeJupHZSEgALdDF3PISw/i3Kn9KpZblsXmPgR7sO7Cm1u
	 lL98xNKQn2Nf6wYl7oYs1X1VmofGfDpnqQkdsWmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0641/1611] perf sched: Cap max_cpu at MAX_CPUS in timehist sample processing
Date: Tue, 21 Jul 2026 17:12:37 +0200
Message-ID: <20260721152529.807644646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 273a7eadfa8528..2600747b243184 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3206,7 +3206,9 @@ static int perf_timehist__process_sample(const struct perf_tool *tool,
 		.cpu = sample->cpu,
 	};
 
-	if (this_cpu.cpu > sched->max_cpu.cpu)
+	/* max_cpu indexes arrays allocated with MAX_CPUS entries */
+	if (this_cpu.cpu >= 0 && this_cpu.cpu < MAX_CPUS &&
+	    this_cpu.cpu > sched->max_cpu.cpu)
 		sched->max_cpu = this_cpu;
 
 	if (evsel->handler != NULL) {
@@ -3376,8 +3378,8 @@ static int perf_sched__timehist(struct perf_sched *sched)
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



