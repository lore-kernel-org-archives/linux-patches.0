Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E898112F5A7;
	Tue, 23 Jan 2024 00:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969042; cv=none; b=ns5bXsQQUMMp2CgXj+5MGAh2CEuTrsLRD5eaETYvTBqGK8kGUXJxBjN4i6RZtc2LxugikQQ05tRHXfEb1IExhuu/252xBSRl4Nais4eWmLRZ/9DrpBsgviGar0kzUBRSaA/GPFE+X0xOxX158KMBWgKLYEGhxSWORVEsCyXvF/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969042; c=relaxed/simple;
	bh=b0cTGfOflUmMCwLe5PCgyd8p9BCtKMKzqQR6GtO/IEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjWsGJvUUGgSm7dbKqgdxbDhj1R0vT5v3Jm/kRcYFEJb36v+JAu0b0qszmLvPPIg1CCvTO9sYZ7PvriRehPS/x+3mooS6ZeZQPOlLBq7mXWB5VIcxxmVxWhe5u7t/a85fn6ce8zXM4qN8g3u7V9Q5xx6E3ohXKKWlnxKkEB6/3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Glr8orFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Glr8orFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A98C433C7;
	Tue, 23 Jan 2024 00:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969041;
	bh=b0cTGfOflUmMCwLe5PCgyd8p9BCtKMKzqQR6GtO/IEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Glr8orFsen4rR08yzrCwRYSLjiWoxvjEfgD//RY2usit8m6d68DnEuPam1yiMs/UJ
	 5/Fe1MBJzjQzPYXoN7RQJXiVtCQbPRcQMAyCHOX223vkXa5sHTuC16HaRtgcRKk24T
	 wNB/qQBEzblPMj5yIylMiYj8bVJasNzRFaI+hRGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 176/194] perf bpf: Decouple creating the evlist from adding the SB event
Date: Mon, 22 Jan 2024 15:58:26 -0800
Message-ID: <20240122235726.767620645@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit b38d85ef49cf6af9d1deaaf01daf0986d47e6c7a ]

Renaming bpf_event__add_sb_event() to evlist__add_sb_event() and
requiring that the evlist be allocated beforehand.

This will allow using the same side band thread and evlist to be used
for multiple purposes in addition to react to PERF_RECORD_BPF_EVENT soon
after they are generated.

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Link: http://lore.kernel.org/lkml/20200429131106.27974-4-acme@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 9c51f8788b5d ("perf env: Avoid recursively taking env->bpf_progs.lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c | 17 ++++++++++++++---
 tools/perf/builtin-top.c    | 15 +++++++++++++--
 tools/perf/util/bpf-event.c |  3 +--
 tools/perf/util/bpf-event.h |  7 +++----
 tools/perf/util/evlist.c    | 21 ++++-----------------
 tools/perf/util/evlist.h    |  2 +-
 6 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7fc3dadfa156..a9891c9fe94d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1446,16 +1446,27 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 			goto out_child;
 	}
 
+	err = -1;
 	if (!rec->no_buildid
 	    && !perf_header__has_feat(&session->header, HEADER_BUILD_ID)) {
 		pr_err("Couldn't generate buildids. "
 		       "Use --no-buildid to profile anyway.\n");
-		err = -1;
 		goto out_child;
 	}
 
-	if (!opts->no_bpf_event)
-		bpf_event__add_sb_event(&rec->sb_evlist, &session->header.env);
+	if (!opts->no_bpf_event) {
+		rec->sb_evlist = evlist__new();
+
+		if (rec->sb_evlist == NULL) {
+			pr_err("Couldn't create side band evlist.\n.");
+			goto out_child;
+		}
+
+		if (evlist__add_bpf_sb_event(rec->sb_evlist, &session->header.env)) {
+			pr_err("Couldn't ask for PERF_RECORD_BPF_EVENT side band events.\n.");
+			goto out_child;
+		}
+	}
 
 	if (perf_evlist__start_sb_thread(rec->sb_evlist, &rec->opts.target)) {
 		pr_debug("Couldn't start the BPF side band thread:\nBPF programs starting from now on won't be annotatable\n");
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index d83954f75557..82642fe5cd21 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1682,8 +1682,19 @@ int cmd_top(int argc, const char **argv)
 		goto out_delete_evlist;
 	}
 
-	if (!top.record_opts.no_bpf_event)
-		bpf_event__add_sb_event(&top.sb_evlist, &perf_env);
+	if (!top.record_opts.no_bpf_event) {
+		top.sb_evlist = evlist__new();
+
+		if (top.sb_evlist == NULL) {
+			pr_err("Couldn't create side band evlist.\n.");
+			goto out_delete_evlist;
+		}
+
+		if (evlist__add_bpf_sb_event(top.sb_evlist, &perf_env)) {
+			pr_err("Couldn't ask for PERF_RECORD_BPF_EVENT side band events.\n.");
+			goto out_delete_evlist;
+		}
+	}
 
 	if (perf_evlist__start_sb_thread(top.sb_evlist, target)) {
 		pr_debug("Couldn't start the BPF side band thread:\nBPF programs starting from now on won't be annotatable\n");
diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 782c0c8a9a83..96e0a31a38f6 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -422,8 +422,7 @@ static int bpf_event__sb_cb(union perf_event *event, void *data)
 	return 0;
 }
 
-int bpf_event__add_sb_event(struct evlist **evlist,
-			    struct perf_env *env)
+int evlist__add_bpf_sb_event(struct evlist *evlist, struct perf_env *env)
 {
 	struct perf_event_attr attr = {
 		.type	          = PERF_TYPE_SOFTWARE,
diff --git a/tools/perf/util/bpf-event.h b/tools/perf/util/bpf-event.h
index 81fdc88e6c1a..68f315c3df5b 100644
--- a/tools/perf/util/bpf-event.h
+++ b/tools/perf/util/bpf-event.h
@@ -33,8 +33,7 @@ struct btf_node {
 #ifdef HAVE_LIBBPF_SUPPORT
 int machine__process_bpf(struct machine *machine, union perf_event *event,
 			 struct perf_sample *sample);
-int bpf_event__add_sb_event(struct evlist **evlist,
-				 struct perf_env *env);
+int evlist__add_bpf_sb_event(struct evlist *evlist, struct perf_env *env);
 void bpf_event__print_bpf_prog_info(struct bpf_prog_info *info,
 				    struct perf_env *env,
 				    FILE *fp);
@@ -46,8 +45,8 @@ static inline int machine__process_bpf(struct machine *machine __maybe_unused,
 	return 0;
 }
 
-static inline int bpf_event__add_sb_event(struct evlist **evlist __maybe_unused,
-					  struct perf_env *env __maybe_unused)
+static inline int evlist__add_bpf_sb_event(struct evlist *evlist __maybe_unused,
+					   struct perf_env *env __maybe_unused)
 {
 	return 0;
 }
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 505b890ac85c..b110deb88425 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1672,39 +1672,26 @@ struct evsel *perf_evlist__reset_weak_group(struct evlist *evsel_list,
 	return leader;
 }
 
-int perf_evlist__add_sb_event(struct evlist **evlist,
+int perf_evlist__add_sb_event(struct evlist *evlist,
 			      struct perf_event_attr *attr,
 			      perf_evsel__sb_cb_t cb,
 			      void *data)
 {
 	struct evsel *evsel;
-	bool new_evlist = (*evlist) == NULL;
-
-	if (*evlist == NULL)
-		*evlist = evlist__new();
-	if (*evlist == NULL)
-		return -1;
 
 	if (!attr->sample_id_all) {
 		pr_warning("enabling sample_id_all for all side band events\n");
 		attr->sample_id_all = 1;
 	}
 
-	evsel = perf_evsel__new_idx(attr, (*evlist)->core.nr_entries);
+	evsel = perf_evsel__new_idx(attr, evlist->core.nr_entries);
 	if (!evsel)
-		goto out_err;
+		return -1;
 
 	evsel->side_band.cb = cb;
 	evsel->side_band.data = data;
-	evlist__add(*evlist, evsel);
+	evlist__add(evlist, evsel);
 	return 0;
-
-out_err:
-	if (new_evlist) {
-		evlist__delete(*evlist);
-		*evlist = NULL;
-	}
-	return -1;
 }
 
 static void *perf_evlist__poll_thread(void *arg)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 7cfe75522ba5..6f920ca91a69 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -107,7 +107,7 @@ int __perf_evlist__add_default_attrs(struct evlist *evlist,
 
 int perf_evlist__add_dummy(struct evlist *evlist);
 
-int perf_evlist__add_sb_event(struct evlist **evlist,
+int perf_evlist__add_sb_event(struct evlist *evlist,
 			      struct perf_event_attr *attr,
 			      perf_evsel__sb_cb_t cb,
 			      void *data);
-- 
2.43.0



