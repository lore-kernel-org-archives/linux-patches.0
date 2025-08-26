Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0021D3376BE;
	Tue, 26 Aug 2025 13:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215813; cv=none; b=OFwOlh0WryBMSaSFX9ZX+Z8k0nAS1SSPbbkx7UNLgofdbwA6pYVj9QKERKyBF66V5Uh89sFp2xYhO33K29oikNP5DKnVNuuy/OhzAty5nPj9/l4oyEowmoB0Lps4Cnpxog3KuiAj3xrRDLKYxixuDbJSEYgHC4V3TmdIGTqjZSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215813; c=relaxed/simple;
	bh=ho8KNqDjod76FrQ5MHMWI+QKskQ+qpt6qkAXK0/u84c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2DDiqxECHmp0y/GOuf32P29qyyPUzHMhqe921h3kUw299tM9Oq+G8VHBhT93HfKlzsQm9EQ82sKemP8pdJ7QzWUh0Q584w6AJDZyHda9sRz3kMsJc++FqH0VheOvBe7Gyvreh1cDz6BLu16/QATULNAXr2K6x+qd5EF/dJO2uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrWgCyHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrWgCyHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823A8C4CEF1;
	Tue, 26 Aug 2025 13:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215812;
	bh=ho8KNqDjod76FrQ5MHMWI+QKskQ+qpt6qkAXK0/u84c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrWgCyHAwS4660yMuxrHZZ4bUfJS69PHS+hXhkHUbvLVeC7aBjQGaao6ItfmJ0tnL
	 AaSj58tBNsmuV8wicuPH0/tRA/VMsWCNi6CG3DYCIJq43opCb4B+aojO49tf+kNkOI
	 mTp5EKfmH1hmr22XeDmy/tOlhYFpVs2eH9nEfi3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/644] perf sched: Fix memory leaks for evsel->priv in timehist
Date: Tue, 26 Aug 2025 13:04:27 +0200
Message-ID: <20250826110950.830693048@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 19e96141e7b4..95a549fdabe0 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1902,6 +1902,16 @@ static u64 evsel__get_time(struct evsel *evsel, u32 cpu)
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
@@ -3039,6 +3049,8 @@ static int perf_sched__timehist(struct perf_sched *sched)
 
 	setup_pager();
 
+	evsel__set_priv_destructor(timehist__evsel_priv_destructor);
+
 	/* prefer sched_waking if it is captured */
 	if (evlist__find_tracepoint_by_name(session->evlist, "sched:sched_waking"))
 		handlers[1].handler = timehist_sched_wakeup_ignore;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index c19a583ca9f6..f14c83e6829a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1416,6 +1416,15 @@ static void evsel__free_config_terms(struct evsel *evsel)
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
@@ -1436,6 +1445,8 @@ void evsel__exit(struct evsel *evsel)
 	hashmap__free(evsel->per_pkg_mask);
 	evsel->per_pkg_mask = NULL;
 	zfree(&evsel->metric_events);
+	if (evsel__priv_destructor)
+		evsel__priv_destructor(evsel->priv);
 	perf_evsel__object.fini(evsel);
 }
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 0492cafac443..d39d8aab3769 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -231,6 +231,8 @@ void evsel__init(struct evsel *evsel, struct perf_event_attr *attr, int idx);
 void evsel__exit(struct evsel *evsel);
 void evsel__delete(struct evsel *evsel);
 
+void evsel__set_priv_destructor(void (*destructor)(void *priv));
+
 struct callchain_param;
 
 void evsel__config(struct evsel *evsel, struct record_opts *opts,
-- 
2.39.5



