Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DC62FD1B2;
	Tue, 12 Aug 2025 17:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020683; cv=none; b=mez+Oxfs1k8TOVYMKPu07v1btLEEmAfX0G/UrDDJuUiSZjUKMJ6i5bwVTp4IsANfjBpwyFyvA4LyQOSwtcpq8FoSbwgFu6GupOPXtjsdtb3dTHmJ/Iycjx0IAu5vYefwWFK/5/Kcx+GGSauO9Du2ibPiBN8oO1CNB4RYBbqc9e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020683; c=relaxed/simple;
	bh=ztyLi5qiVsvPQvtG4Q0cuK+FjStu6wtalkLT0zzH0xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ta+H4hPXRf0jCM5kJblJ16zE875AzvYWJWUNTsKRHITu9ZehKsB5Vy4ft9YoWvAIawNcxTtUcp9cATYktr+O8E5RYBWvP2H1iqA/4tI1m0RQgPuSfPKXApykNEo+oLdRwJWkqJ+yP1AidKSgG5+erO4/IndRJvNfx2t6bewd1Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbdsYHF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbdsYHF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F50C4CEF0;
	Tue, 12 Aug 2025 17:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020683;
	bh=ztyLi5qiVsvPQvtG4Q0cuK+FjStu6wtalkLT0zzH0xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbdsYHF2w/1c9v6kTW1MNEF/Qt9ow1T8RN6FB03U3roqXgikHCdRtoIz6domCyimj
	 Qi6wBP3/1AaAjHGcUNnawwUrXYepG1c0y8dk9DGzxNM4vvPUqo/Y2IPhBhFKfqXx2u
	 d1Rm3xHfjOaEoST1jQqffql8iqL/x4CcxYFRfSUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/253] perf sched: Fix memory leaks for evsel->priv in timehist
Date: Tue, 12 Aug 2025 19:29:00 +0200
Message-ID: <20250812172955.179951108@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e440a00b1613..244f9c6f61ae 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1929,6 +1929,16 @@ static u64 evsel__get_time(struct evsel *evsel, u32 cpu)
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
@@ -3068,6 +3078,8 @@ static int perf_sched__timehist(struct perf_sched *sched)
 
 	setup_pager();
 
+	evsel__set_priv_destructor(timehist__evsel_priv_destructor);
+
 	/* prefer sched_waking if it is captured */
 	if (evlist__find_tracepoint_by_name(session->evlist, "sched:sched_waking"))
 		handlers[1].handler = timehist_sched_wakeup_ignore;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 7db35dbdfcef..22969cc00a5f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1486,6 +1486,15 @@ static void evsel__free_config_terms(struct evsel *evsel)
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
@@ -1508,6 +1517,8 @@ void evsel__exit(struct evsel *evsel)
 	hashmap__free(evsel->per_pkg_mask);
 	evsel->per_pkg_mask = NULL;
 	zfree(&evsel->metric_events);
+	if (evsel__priv_destructor)
+		evsel__priv_destructor(evsel->priv);
 	perf_evsel__object.fini(evsel);
 }
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 8ce30329a077..fabf0697c36a 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -246,6 +246,8 @@ void evsel__init(struct evsel *evsel, struct perf_event_attr *attr, int idx);
 void evsel__exit(struct evsel *evsel);
 void evsel__delete(struct evsel *evsel);
 
+void evsel__set_priv_destructor(void (*destructor)(void *priv));
+
 struct callchain_param;
 
 void evsel__config(struct evsel *evsel, struct record_opts *opts,
-- 
2.39.5



