Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C83305E2D;
	Tue, 12 Aug 2025 19:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026296; cv=none; b=lyD8+wi0BrmHFZVdvopwy7gewR27YCJanP/zmF7V8cpP27oItdyI0/89qa8XXuBIb5Z+Pa0HoZxQjpvXmJRX5GJbagbauJ1PdUE3rCeDJtcZZHWf2loYNOnN1BbmZ0MUtgdQaYIgpRAV0PJXbsArMFBn8NK0E9C8BoU6m0ELvq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026296; c=relaxed/simple;
	bh=telwGXL2CEG15Mf84em6rIihxqB1G4spJeMpcA0auI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JopCgd71+1MbqLWmPAlF4bKF5wfqYfcV+kSdjAQcfSS4PXPRmVsD3yQoa03RRjj/QfU/jILcBjA3+paTtLS+s6AWzviX7+0UOOf3jRvkGFKUls/iVF1/mPff49G/0CH/fdx6fwXBiCM6xENS6DOKbZoAkhj76dxoVL1RQc93M+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phBpRNG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phBpRNG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086B1C4CEF0;
	Tue, 12 Aug 2025 19:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026296;
	bh=telwGXL2CEG15Mf84em6rIihxqB1G4spJeMpcA0auI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phBpRNG0e0O+Qw7DWjT+Tk9I652JT0QuJf+Qu+qA0t+HOIWmEyo8PaGDu3PiwWpqJ
	 usUl0LYICZtkXOs8vr5rhRdQy0CI/ewgdrcthDotToLF/M1UXKJ+xIeDopqMDftO/M
	 801pg2duBdeAIMMzRPqC0SYDhv1hh2VVWrTXmZX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 262/480] perf sched: Fix memory leaks for evsel->priv in timehist
Date: Tue, 12 Aug 2025 19:47:50 +0200
Message-ID: <20250812174408.246059379@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 117e5c33b1c44037af016d77ce6c0b086d55535f ]

It uses evsel->priv to save per-cpu timing information.  It should be
freed when the evsel is released.

Add the priv destructor for evsel same as thread to handle that.

Fixes: 49394a2a24c78ce0 ("perf sched timehist: Introduce timehist command")
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250703014942.1369397-6-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 12 ++++++++++++
 tools/perf/util/evsel.c    | 11 +++++++++++
 tools/perf/util/evsel.h    |  2 ++
 3 files changed, 25 insertions(+)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 83b5a85a91b7..a6eb0462dd5b 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2020,6 +2020,16 @@ static u64 evsel__get_time(struct evsel *evsel, u32 cpu)
 	return r->last_time[cpu];
 }
 
+static void timehist__evsel_priv_destructor(void *priv)
+{
+	struct evsel_runtime *r = priv;
+
+	if (r) {
+		free(r->last_time);
+		free(r);
+	}
+}
+
 static int comm_width = 30;
 
 static char *timehist_get_commstr(struct thread *thread)
@@ -3314,6 +3324,8 @@ static int perf_sched__timehist(struct perf_sched *sched)
 
 	setup_pager();
 
+	evsel__set_priv_destructor(timehist__evsel_priv_destructor);
+
 	/* prefer sched_waking if it is captured */
 	if (evlist__find_tracepoint_by_name(session->evlist, "sched:sched_waking"))
 		handlers[1].handler = timehist_sched_wakeup_ignore;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 3c030da2e477..08fd9b9afcf8 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1652,6 +1652,15 @@ static void evsel__free_config_terms(struct evsel *evsel)
 	free_config_terms(&evsel->config_terms);
 }
 
+static void (*evsel__priv_destructor)(void *priv);
+
+void evsel__set_priv_destructor(void (*destructor)(void *priv))
+{
+	assert(evsel__priv_destructor == NULL);
+
+	evsel__priv_destructor = destructor;
+}
+
 void evsel__exit(struct evsel *evsel)
 {
 	assert(list_empty(&evsel->core.node));
@@ -1680,6 +1689,8 @@ void evsel__exit(struct evsel *evsel)
 	hashmap__free(evsel->per_pkg_mask);
 	evsel->per_pkg_mask = NULL;
 	zfree(&evsel->metric_events);
+	if (evsel__priv_destructor)
+		evsel__priv_destructor(evsel->priv);
 	perf_evsel__object.fini(evsel);
 	if (evsel__tool_event(evsel) == TOOL_PMU__EVENT_SYSTEM_TIME ||
 	    evsel__tool_event(evsel) == TOOL_PMU__EVENT_USER_TIME)
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index aae431d63d64..b7f8b29f30ea 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -270,6 +270,8 @@ void evsel__init(struct evsel *evsel, struct perf_event_attr *attr, int idx);
 void evsel__exit(struct evsel *evsel);
 void evsel__delete(struct evsel *evsel);
 
+void evsel__set_priv_destructor(void (*destructor)(void *priv));
+
 struct callchain_param;
 
 void evsel__config(struct evsel *evsel, struct record_opts *opts,
-- 
2.39.5



