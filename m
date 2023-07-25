Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AE61D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A8DC433C7;
	Tue, 25 Jul 2023 11:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284049;
	bh=feflpeHgg7K0ThdVANFlkJIp+VRgF47IO90kxz1ElH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjpoJ1yKqBhbc44m6ioQ+dDijkcAfxIEbYOoVNz451CXRx6iZyNSFNwb943QMaM1/
	 Xi275HkH7UliduNUsDQGDBh3DC/5oJD5eFtveVwWMvf0u0rTbot3UhZwWa0If/TZJt
	 Djcrie6galHVKAgU8LNAmMvHHgyQlUNYWmTrzOm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/509] perf script: Fixup struct evsel_script method prefix
Date: Tue, 25 Jul 2023 12:42:06 +0200
Message-ID: <20230725104602.276685371@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 297e69bfa4c7aa27259dd456af1377e868337043 ]

They all operate on 'struct evsel_script' instances, so should be
prefixed with evsel_script__, not with perf_evsel_script__.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 36d3e4138e1b ("perf script: Fix allocation of evsel->priv related to per-event dump files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-script.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 5109d01619eed..5651714e527c5 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -295,8 +295,7 @@ static inline struct evsel_script *evsel_script(struct evsel *evsel)
 	return (struct evsel_script *)evsel->priv;
 }
 
-static struct evsel_script *perf_evsel_script__new(struct evsel *evsel,
-							struct perf_data *data)
+static struct evsel_script *evsel_script__new(struct evsel *evsel, struct perf_data *data)
 {
 	struct evsel_script *es = zalloc(sizeof(*es));
 
@@ -316,7 +315,7 @@ static struct evsel_script *perf_evsel_script__new(struct evsel *evsel,
 	return NULL;
 }
 
-static void perf_evsel_script__delete(struct evsel_script *es)
+static void evsel_script__delete(struct evsel_script *es)
 {
 	zfree(&es->filename);
 	fclose(es->fp);
@@ -324,7 +323,7 @@ static void perf_evsel_script__delete(struct evsel_script *es)
 	free(es);
 }
 
-static int perf_evsel_script__fprintf(struct evsel_script *es, FILE *fp)
+static int evsel_script__fprintf(struct evsel_script *es, FILE *fp)
 {
 	struct stat st;
 
@@ -2166,8 +2165,7 @@ static int process_attr(struct perf_tool *tool, union perf_event *event,
 
 	if (!evsel->priv) {
 		if (scr->per_event_dump) {
-			evsel->priv = perf_evsel_script__new(evsel,
-						scr->session->data);
+			evsel->priv = evsel_script__new(evsel, scr->session->data);
 		} else {
 			es = zalloc(sizeof(*es));
 			if (!es)
@@ -2422,7 +2420,7 @@ static void perf_script__fclose_per_event_dump(struct perf_script *script)
 	evlist__for_each_entry(evlist, evsel) {
 		if (!evsel->priv)
 			break;
-		perf_evsel_script__delete(evsel->priv);
+		evsel_script__delete(evsel->priv);
 		evsel->priv = NULL;
 	}
 }
@@ -2442,7 +2440,7 @@ static int perf_script__fopen_per_event_dump(struct perf_script *script)
 		if (evsel->priv != NULL)
 			continue;
 
-		evsel->priv = perf_evsel_script__new(evsel, script->session->data);
+		evsel->priv = evsel_script__new(evsel, script->session->data);
 		if (evsel->priv == NULL)
 			goto out_err_fclose;
 	}
@@ -2477,8 +2475,8 @@ static void perf_script__exit_per_event_dump_stats(struct perf_script *script)
 	evlist__for_each_entry(script->session->evlist, evsel) {
 		struct evsel_script *es = evsel->priv;
 
-		perf_evsel_script__fprintf(es, stdout);
-		perf_evsel_script__delete(es);
+		evsel_script__fprintf(es, stdout);
+		evsel_script__delete(es);
 		evsel->priv = NULL;
 	}
 }
-- 
2.39.2



