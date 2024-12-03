Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F1A1F75AE;
	Tue,  3 Dec 2024 15:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239197; cv=none; b=SyQJ6RAIBguVExwW6gFQyNDVP/mXauBvks66QA2wLj4+1bRieXGDamR1b7dJybybeAB91kpF103joGjv2LgkbtRkPofPWB3/MjyBZsOd23o1bOHrhGLz83aJNTfKoTpnc+2uPOK3kKkWkKhey3gujsLuim2FsH5AqGdSknZVBYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239197; c=relaxed/simple;
	bh=WUz+LhRNwa//lDttx+vUrxZ0gNmxKO7KELniIqmFtW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTPoDHviHZZe+aLMvqiJA3xE3s63VkKWJMtk/JAoJ/ytsKlqjrXXfQb7Hzb3nFefznmXd5k8fD/2si1IX223fOCCPT2jdigL37ujrmc70nsh74ucd7nvKpSQGKZ/2NhrwOrNI/uMSxaIPxg5pIzsxDdokmWRWjC62RVxhUjdsmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/fjY9f/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/fjY9f/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71340C4CEDA;
	Tue,  3 Dec 2024 15:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239197;
	bh=WUz+LhRNwa//lDttx+vUrxZ0gNmxKO7KELniIqmFtW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/fjY9f/eeJ2hN29Ot7KNtVONJuXmySmfRr1TAnUmeigjFUpLMvDwcqMRg6Rtqpqp
	 AEAXVhPj7xNZNhdOr+f+40L2+CyEr/7l5Wt0aUkETa4XI9CO17gqqZbiujD5dKXXeN
	 GV1s2aLh8YHH6BXy2NDsaTe/m+9WZGNiDdZnqdWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Peterson <benjamin@engflow.com>,
	Howard Chu <howardchu95@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 532/817] perf trace: Do not lose last events in a race
Date: Tue,  3 Dec 2024 15:41:44 +0100
Message-ID: <20241203144016.665517080@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Peterson <benjamin@engflow.com>

[ Upstream commit 3fd7c36973a250e17a4ee305a31545a9426021f4 ]

If a perf trace event selector specifies a maximum number of events to output
(i.e., "/nr=N/" syntax), the event printing handler, trace__event_handler,
disables the event selector after the maximum number events are
printed.

Furthermore, trace__event_handler checked if the event selector was
disabled before doing any work. This avoided exceeding the maximum
number of events to print if more events were in the buffer before the
selector was disabled.

However, the event selector can be disabled for reasons other than
exceeding the maximum number of events. In particular, when the traced
subprocess exits, the main loop disables all event selectors. This meant
the last events of a traced subprocess might be lost to the printing
handler's short-circuiting logic.

This nondeterministic problem could be seen by running the following many times:

  $ perf trace -e syscalls:sys_enter_exit_group true

trace__event_handler should simply check for exceeding the maximum number of
events to print rather than the state of the event selector.

Fixes: a9c5e6c1e9bff42c ("perf trace: Introduce per-event maximum number of events property")
Signed-off-by: Benjamin Peterson <benjamin@engflow.com>
Tested-by: Howard Chu <howardchu95@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241107232128.108981-1-benjamin@engflow.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c9399bf07c4cf..fb1673f704a31 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2811,13 +2811,8 @@ static int trace__event_handler(struct trace *trace, struct evsel *evsel,
 {
 	struct thread *thread;
 	int callchain_ret = 0;
-	/*
-	 * Check if we called perf_evsel__disable(evsel) due to, for instance,
-	 * this event's max_events having been hit and this is an entry coming
-	 * from the ring buffer that we should discard, since the max events
-	 * have already been considered/printed.
-	 */
-	if (evsel->disabled)
+
+	if (evsel->nr_events_printed >= evsel->max_events)
 		return 0;
 
 	thread = machine__findnew_thread(trace->host, sample->pid, sample->tid);
-- 
2.43.0



