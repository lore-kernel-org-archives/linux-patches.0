Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377A0332913;
	Tue, 21 Jul 2026 18:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660345; cv=none; b=PPLCF4OaQWlSNElGQZEUyY41s+MIhFO+tz3mNo81C+zv/y5pSTSEvU9R57kpeUZwDOuNAzMLkeCPP6x+P7e1JoaKuSzG5yppNQ33d4Lz3nobqLhG6q8k7+dNyvvfBP4wR6qRh7HAJT7wsol92gcihQCghVvKfO8++0q5qxDkrDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660345; c=relaxed/simple;
	bh=clM40mr7NdDb3Xo8U8eA2disRuwSW0lPsm6DpzlxnX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kD0KqYdchhkVh3ng0T4QRY74E4zQzzUSo9bQc91AJ/DTbF5t9p/euY3lbvK+LlgYSMAz0Exhn55yCa5X5qIh+HEQEZHGh7bAYTDDDCEoh+IKTE/4WkhBPHFj+uu3WfNBvaQ8PvOdWs1DZ1l/3hhytuUJw5k8wqh5xVCN1BrLdVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tAsxqwOF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tAsxqwOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B591F000E9;
	Tue, 21 Jul 2026 18:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660342;
	bh=Lxq0UxWAOhkQkDM6vd51vxZ5YdtXnwuuY8L06f+9uR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tAsxqwOFPbWD8FWWepvtH3DQf9XCtwrqGD98xy4Vim98NRZqaENBB+xfjX2pEEkQ1
	 E0a8GhHaLQuxdpJTpG/aFt84skQQm1Y519komhEjh8MuCnisLp92cltbsrkVFuslhO
	 Vlh8SB2xuhGl4VkmYr8+qyiGXm8MzN3Xq4M5YoHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0944/2077] perf sched: Use is_idle_sample() for idle thread runtime cast guard
Date: Tue, 21 Jul 2026 17:10:17 +0200
Message-ID: <20260721152615.083823288@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit c9b3054c99cafd5f5f92158101760992a83e5a5e ]

timehist_sched_change_event() uses thread__tid(thread) == 0 to decide
whether to cast thread_runtime to idle_thread_runtime.  However, a
crafted perf.data can set common_pid=0 and common_tid=0 (the perf_sample
fields) while prev_pid != 0 (the tracepoint field).  is_idle_sample()
returns false (it checks prev_pid for sched_switch), so
timehist_get_thread() goes through machine__findnew_thread() and returns
the machine's TID 0 thread — whose priv data is a regular thread_runtime,
not the larger idle_thread_runtime allocated by init_idle_thread().

The subsequent cast to idle_thread_runtime reads past the thread_runtime
allocation, accessing itr->last_thread, itr->cursor, and itr->callchain
from adjacent heap memory.  Writing to itr->last_thread corrupts the
heap; calling thread__put() on the OOB value frees an arbitrary pointer.

Replace the thread__tid() == 0 check with is_idle_sample(), which uses
the tracepoint-specific prev_pid field and correctly identifies whether
the sample originated from an idle thread with idle_thread_runtime priv.

Fixes: 5d8f17fb5822 ("perf sched timehist: Add -I/--idle-hist option")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index fc8ae0342dd6c2..9ea3416f30ac6d 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2904,7 +2904,13 @@ static int timehist_sched_change_event(const struct perf_tool *tool,
 			t = ptime->end;
 	}
 
-	if (!sched->idle_hist || thread__tid(thread) == 0) {
+	/*
+	 * Use is_idle_sample() not thread__tid() == 0: a crafted perf.data
+	 * can set common_pid=0 with prev_pid!=0, giving us a machine thread
+	 * whose priv is thread_runtime, not idle_thread_runtime — the cast
+	 * below would read past the allocation.
+	 */
+	if (!sched->idle_hist || is_idle_sample(sample)) {
 		if (!cpu_list || (sample->cpu < MAX_NR_CPUS &&
 				 test_bit(sample->cpu, cpu_bitmap)))
 			timehist_update_runtime_stats(tr, t, tprev);
-- 
2.53.0



