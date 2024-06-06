Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AEB19755E;
	Thu,  6 Jun 2024 14:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682919; cv=none; b=noO2a7Ap1TQBsCEpnxiVoCee1Xg975hevHArfMlSljINSuyJvwHwRkr0S1aL0GuSfdQTw0wyNzZb9e46yqgpaeknAKIih0N3aF1F1G7qJCEplyc3/OSooRuU5Ll13HUCHVpfCXU7cy2dGYl+BGz8KzatoOe1at/zws6d4rVxU3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682919; c=relaxed/simple;
	bh=jkFR+4kGniqE1qO4p5ulCDjSxbjVjtWKLrKxMhuMHx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdHB4ORjHKLman5NFMD0jGi9CBiqlFRQ6Jzb9aE2cskoKj6pgZRsxLquvgSe59RPGLmbSi5g88fQa76LS6P9W2V5YVhjZD7d6jP08Wz3djVCwo8D85LDaI2B7PmJm2QCu+3ceJNTQW8Bog0/1aqq5ZYFyU6cKqKL/s/hVV7GRuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXINC+jb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXINC+jb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C1DC4AF07;
	Thu,  6 Jun 2024 14:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682919;
	bh=jkFR+4kGniqE1qO4p5ulCDjSxbjVjtWKLrKxMhuMHx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXINC+jbMvRjA5bgB3kNrHGzpRFwTAEjSyrxGPfLkxXU8bt0t7Udts143g03W1v1L
	 6YZe2rl0Ee+OlFOpJqUToy3zAy0EtQVYJ9+6Yn44QKKmPA94wJa5sDee/jD9iRZ0vM
	 Fk4UVl1plOW3BsBTNNxr2T7KzG6F4kku5wPXyctg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Yang Jihong <yangjihong@bytedance.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Yang Jihong <yangjihong1@huawei.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 014/374] perf sched timehist: Fix -g/--call-graph option failure
Date: Thu,  6 Jun 2024 15:59:53 +0200
Message-ID: <20240606131652.239210235@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Jihong <yangjihong@bytedance.com>

[ Upstream commit 6e4b398770d5023eb6383da9360a23bd537c155b ]

When 'perf sched' enables the call-graph recording, sample_type of dummy
event does not have PERF_SAMPLE_CALLCHAIN, timehist_check_attr() checks
that the evsel does not have a callchain, and set show_callchain to 0.

Currently 'perf sched timehist' only saves callchain when processing the
'sched:sched_switch event', timehist_check_attr() only needs to determine
whether the event has PERF_SAMPLE_CALLCHAIN.

Before:

  # perf sched record -g true
  [ perf record: Woken up 0 times to write data ]
  [ perf record: Captured and wrote 4.153 MB perf.data (7536 samples) ]
  # perf sched timehist
  Samples do not have callchains.
             time    cpu  task name                       wait time  sch delay   run time
                          [tid/pid]                          (msec)     (msec)     (msec)
  --------------- ------  ------------------------------  ---------  ---------  ---------
    147851.826019 [0000]  perf[285035]                        0.000      0.000      0.000
    147851.826029 [0000]  migration/0[15]                     0.000      0.003      0.009
    147851.826063 [0001]  perf[285035]                        0.000      0.000      0.000
    147851.826069 [0001]  migration/1[21]                     0.000      0.003      0.006
  <SNIP>

After:

  # perf sched record -g true
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 2.572 MB perf.data (822 samples) ]
  # perf sched timehist
         time cpu task name        waittime  sch delay  runtime
                    [tid/pid]        (msec)  (msec)    (msec)
  ----------- --- ---------------  --------  --------  -----
  4193.035164 [0] perf[277062]        0.000     0.000   0.000 __traceiter_sched_switch <- __traceiter_sched_switch <- __sched_text_start <- preempt_schedule_common <- __cond_resched <- __wait_for_common <- wait_for_completion
  4193.035174 [0] migration/0[15]     0.000     0.003   0.009 __traceiter_sched_switch <- __traceiter_sched_switch <- __sched_text_start <- smpboot_thread_fn <- kthread <- ret_from_fork
  4193.035207 [1] perf[277062]        0.000     0.000   0.000 __traceiter_sched_switch <- __traceiter_sched_switch <- __sched_text_start <- preempt_schedule_common <- __cond_resched <- __wait_for_common <- wait_for_completion
  4193.035214 [1] migration/1[21]     0.000     0.003   0.007 __traceiter_sched_switch <- __traceiter_sched_switch <- __sched_text_start <- smpboot_thread_fn <- kthread <- ret_from_fork
  <SNIP>

Fixes: 9c95e4ef06572349 ("perf evlist: Add evlist__findnew_tracking_event() helper")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Yang Jihong <yangjihong@bytedance.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yang Jihong <yangjihong1@huawei.com>
Link: https://lore.kernel.org/r/20240401062724.1006010-2-yangjihong@bytedance.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index b248c433529a8..1bfb223473715 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2963,8 +2963,11 @@ static int timehist_check_attr(struct perf_sched *sched,
 			return -1;
 		}
 
-		if (sched->show_callchain && !evsel__has_callchain(evsel)) {
-			pr_info("Samples do not have callchains.\n");
+		/* only need to save callchain related to sched_switch event */
+		if (sched->show_callchain &&
+		    evsel__name_is(evsel, "sched:sched_switch") &&
+		    !evsel__has_callchain(evsel)) {
+			pr_info("Samples of sched_switch event do not have callchains.\n");
 			sched->show_callchain = 0;
 			symbol_conf.use_callchain = 0;
 		}
-- 
2.43.0



