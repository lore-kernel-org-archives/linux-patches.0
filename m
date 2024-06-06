Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA10D19D07B;
	Thu,  6 Jun 2024 14:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683469; cv=none; b=jXaBrOhzQj/Cl6osp/ClQtZu+tJmwjbev4pjFYlJh6tpaTJ6ul1aKo5rGhkcbs5bWZDAofGgOLhZ+/IaTbT0zu08m1p6dCwKcG9Mhb98sSUWTe+fjrNnKeD/TJ3uh9DpzTaDDScgvJc6FlyoygX726U5dOb3v8ZBhGlLUkSaOx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683469; c=relaxed/simple;
	bh=rtQe5lYIWcYt1ujuPz0GFxFDbW6vvQjPB75xTU0m8/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bzols3eO2mJ8Fc9dhHyZeME4RG+1TVkSAx1A+4hzca0OMxazht6jO53Sp9WLZsmUeZXVe/dENW74Hz55hx7PAv1lLHhgJkGMBRnN/pvagZHN7dpOwErTz1YH9CzaGqJgDvGFwwdPS1NJwtnVjzA83Twbrg+s6Sx+ZifBKAExPSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5qLHkhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5qLHkhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0C8C2BD10;
	Thu,  6 Jun 2024 14:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683468;
	bh=rtQe5lYIWcYt1ujuPz0GFxFDbW6vvQjPB75xTU0m8/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5qLHkhDMZfgAawTKSVbRCiOGQkBwBDwj/3vrC6doiUswSxw3szEFHywJvwEkEZL4
	 DUsJqgM8DkO03QhhoZ5aokjKBi5GCktRvywy1np7bpkb59gHT68XMyqYoMAhwX63Yr
	 xeYbqSZu6h0/V6vXQjYNq6JArivrFiyP5J4cUH+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 412/744] perf top: Convert to the global annotation_options
Date: Thu,  6 Jun 2024 16:01:24 +0200
Message-ID: <20240606131745.684667657@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit c9a21a872c69032cb9a94ebc171649c0c28141d7 ]

Use the global option and drop the local copy.

Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20231128175441.721579-4-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: aaf494cf483a ("perf annotate: Fix annotation_calc_lines() to pass correct address to get_srcline()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-top.c | 44 ++++++++++++++++++++--------------------
 tools/perf/util/top.h    |  1 -
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index cd64ae44ccbde..ecf98169fd8fd 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -147,7 +147,7 @@ static int perf_top__parse_source(struct perf_top *top, struct hist_entry *he)
 		return err;
 	}
 
-	err = symbol__annotate(&he->ms, evsel, &top->annotation_opts, NULL);
+	err = symbol__annotate(&he->ms, evsel, &annotate_opts, NULL);
 	if (err == 0) {
 		top->sym_filter_entry = he;
 	} else {
@@ -261,9 +261,9 @@ static void perf_top__show_details(struct perf_top *top)
 		goto out_unlock;
 
 	printf("Showing %s for %s\n", evsel__name(top->sym_evsel), symbol->name);
-	printf("  Events  Pcnt (>=%d%%)\n", top->annotation_opts.min_pcnt);
+	printf("  Events  Pcnt (>=%d%%)\n", annotate_opts.min_pcnt);
 
-	more = symbol__annotate_printf(&he->ms, top->sym_evsel, &top->annotation_opts);
+	more = symbol__annotate_printf(&he->ms, top->sym_evsel, &annotate_opts);
 
 	if (top->evlist->enabled) {
 		if (top->zero)
@@ -450,7 +450,7 @@ static void perf_top__print_mapped_keys(struct perf_top *top)
 
 	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", top->count_filter);
 
-	fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", top->annotation_opts.min_pcnt);
+	fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", annotate_opts.min_pcnt);
 	fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
 	fprintf(stdout, "\t[S]     stop annotation.\n");
 
@@ -553,7 +553,7 @@ static bool perf_top__handle_keypress(struct perf_top *top, int c)
 			prompt_integer(&top->count_filter, "Enter display event count filter");
 			break;
 		case 'F':
-			prompt_percent(&top->annotation_opts.min_pcnt,
+			prompt_percent(&annotate_opts.min_pcnt,
 				       "Enter details display event filter (percent)");
 			break;
 		case 'K':
@@ -647,7 +647,7 @@ static void *display_thread_tui(void *arg)
 
 	ret = evlist__tui_browse_hists(top->evlist, help, &hbt, top->min_percent,
 				       &top->session->header.env, !top->record_opts.overwrite,
-				       &top->annotation_opts);
+				       &annotate_opts);
 	if (ret == K_RELOAD) {
 		top->zero = true;
 		goto repeat;
@@ -1241,9 +1241,9 @@ static int __cmd_top(struct perf_top *top)
 	pthread_t thread, thread_process;
 	int ret;
 
-	if (!top->annotation_opts.objdump_path) {
+	if (!annotate_opts.objdump_path) {
 		ret = perf_env__lookup_objdump(&top->session->header.env,
-					       &top->annotation_opts.objdump_path);
+					       &annotate_opts.objdump_path);
 		if (ret)
 			return ret;
 	}
@@ -1537,9 +1537,9 @@ int cmd_top(int argc, const char **argv)
 		   "only consider symbols in these comms"),
 	OPT_STRING(0, "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
-	OPT_BOOLEAN(0, "source", &top.annotation_opts.annotate_src,
+	OPT_BOOLEAN(0, "source", &annotate_opts.annotate_src,
 		    "Interleave source code with assembly code (default)"),
-	OPT_BOOLEAN(0, "asm-raw", &top.annotation_opts.show_asm_raw,
+	OPT_BOOLEAN(0, "asm-raw", &annotate_opts.show_asm_raw,
 		    "Display raw encoding of assembly instructions (default)"),
 	OPT_BOOLEAN(0, "demangle-kernel", &symbol_conf.demangle_kernel,
 		    "Enable kernel symbol demangling"),
@@ -1550,9 +1550,9 @@ int cmd_top(int argc, const char **argv)
 		   "addr2line binary to use for line numbers"),
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
-	OPT_STRING(0, "prefix", &top.annotation_opts.prefix, "prefix",
+	OPT_STRING(0, "prefix", &annotate_opts.prefix, "prefix",
 		    "Add prefix to source file path names in programs (with --prefix-strip)"),
-	OPT_STRING(0, "prefix-strip", &top.annotation_opts.prefix_strip, "N",
+	OPT_STRING(0, "prefix-strip", &annotate_opts.prefix_strip, "N",
 		    "Strip first N entries of source file path name in programs (with --prefix)"),
 	OPT_STRING('u', "uid", &target->uid_str, "user", "user to profile"),
 	OPT_CALLBACK(0, "percent-limit", &top, "percent",
@@ -1610,10 +1610,10 @@ int cmd_top(int argc, const char **argv)
 	if (status < 0)
 		return status;
 
-	annotation_options__init(&top.annotation_opts);
+	annotation_options__init(&annotate_opts);
 
-	top.annotation_opts.min_pcnt = 5;
-	top.annotation_opts.context  = 4;
+	annotate_opts.min_pcnt = 5;
+	annotate_opts.context  = 4;
 
 	top.evlist = evlist__new();
 	if (top.evlist == NULL)
@@ -1643,13 +1643,13 @@ int cmd_top(int argc, const char **argv)
 		usage_with_options(top_usage, options);
 
 	if (disassembler_style) {
-		top.annotation_opts.disassembler_style = strdup(disassembler_style);
-		if (!top.annotation_opts.disassembler_style)
+		annotate_opts.disassembler_style = strdup(disassembler_style);
+		if (!annotate_opts.disassembler_style)
 			return -ENOMEM;
 	}
 	if (objdump_path) {
-		top.annotation_opts.objdump_path = strdup(objdump_path);
-		if (!top.annotation_opts.objdump_path)
+		annotate_opts.objdump_path = strdup(objdump_path);
+		if (!annotate_opts.objdump_path)
 			return -ENOMEM;
 	}
 	if (addr2line_path) {
@@ -1662,7 +1662,7 @@ int cmd_top(int argc, const char **argv)
 	if (status)
 		goto out_delete_evlist;
 
-	if (annotate_check_args(&top.annotation_opts) < 0)
+	if (annotate_check_args(&annotate_opts) < 0)
 		goto out_delete_evlist;
 
 	if (!top.evlist->core.nr_entries) {
@@ -1788,7 +1788,7 @@ int cmd_top(int argc, const char **argv)
 	if (status < 0)
 		goto out_delete_evlist;
 
-	annotation_config__init(&top.annotation_opts);
+	annotation_config__init(&annotate_opts);
 
 	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
 	status = symbol__init(NULL);
@@ -1841,7 +1841,7 @@ int cmd_top(int argc, const char **argv)
 out_delete_evlist:
 	evlist__delete(top.evlist);
 	perf_session__delete(top.session);
-	annotation_options__exit(&top.annotation_opts);
+	annotation_options__exit(&annotate_opts);
 
 	return status;
 }
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index a8b0d79bd96cf..4c5588dbb1317 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -21,7 +21,6 @@ struct perf_top {
 	struct perf_tool   tool;
 	struct evlist *evlist, *sb_evlist;
 	struct record_opts record_opts;
-	struct annotation_options annotation_opts;
 	struct evswitch	   evswitch;
 	/*
 	 * Symbols will be added here in perf_event__process_sample and will
-- 
2.43.0



