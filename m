Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6EE2FE573;
	Tue, 12 Aug 2025 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021566; cv=none; b=bfg59sfTxksCeUd2nhvrYbAsDwZtQiktohm1+gc+q0gw43N5p3rjbXX0xxnlCmFLaKt1nLrgXyGuI+3EJA/hmlDqqeIEOrCK+QDxuFoYqY9H+ZWob1Vry0BxmzJP8zmJesBdi9cMSh2IiVbdTdWAns/OYnu8MSwUA68+ds796b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021566; c=relaxed/simple;
	bh=9WypVhOSK8srL+IeahHIkUSCokExQJJHRlE5/kcpHwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjy2VIAtUKKfZG+PhsWnuKoz8uNonF/YXBJGlDKfyMhXC0lYk3Tq6q3VnGkjAiSzcnzQZ2o8ZBovqNgA4D7tAtbRcxOTCGxr2n3xCAkUJEuST9XRXMXf9Y5wVXWJa3lrc4EdIfS1Hm2nWLQ3tx7zRGTLnI29ikPiXm7SXBrYgd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OkdFFM+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkdFFM+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4705DC4CEF1;
	Tue, 12 Aug 2025 17:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021565;
	bh=9WypVhOSK8srL+IeahHIkUSCokExQJJHRlE5/kcpHwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkdFFM+5ZJluBBgWZBDRZGAYXa8miSCLWBwDc/0zfUeyxm3036So4Dh8UJBsrVt/M
	 vZCKhtr5AB7ZtXnP71AHHdUUH6n12QGxUeEHQ6rUlK4J5qYQCKVurwuDQ9FIptQUJy
	 eVi6Orn9Ig21/PKvoG8C+PrVAE7U81DLlMTpYtBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/262] perf sched: Fix memory leaks for evsel->priv in timehist
Date: Tue, 12 Aug 2025 19:28:34 +0200
Message-ID: <20250812172958.472827691@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5f4fb1ce1ea9..a1fab1a52b6a 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1949,6 +1949,16 @@ static u64 evsel__get_time(struct evsel *evsel, u32 cpu)
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
@@ -3080,6 +3090,8 @@ static int perf_sched__timehist(struct perf_sched *sched)
 
 	setup_pager();
 
+	evsel__set_priv_destructor(timehist__evsel_priv_destructor);
+
 	/* prefer sched_waking if it is captured */
 	if (evlist__find_tracepoint_by_name(session->evlist, "sched:sched_waking"))
 		handlers[1].handler = timehist_sched_wakeup_ignore;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6d2b056232f6..2a6295f1ac1b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1460,6 +1460,15 @@ static void evsel__free_config_terms(struct evsel *evsel)
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
@@ -1485,6 +1494,8 @@ void evsel__exit(struct evsel *evsel)
 	hashmap__free(evsel->per_pkg_mask);
 	evsel->per_pkg_mask = NULL;
 	zfree(&evsel->metric_events);
+	if (evsel__priv_destructor)
+		evsel__priv_destructor(evsel->priv);
 	perf_evsel__object.fini(evsel);
 }
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 848534ec74fa..ac396d6f95cb 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -252,6 +252,8 @@ void evsel__init(struct evsel *evsel, struct perf_event_attr *attr, int idx);
 void evsel__exit(struct evsel *evsel);
 void evsel__delete(struct evsel *evsel);
 
+void evsel__set_priv_destructor(void (*destructor)(void *priv));
+
 struct callchain_param;
 
 void evsel__config(struct evsel *evsel, struct record_opts *opts,
-- 
2.39.5



