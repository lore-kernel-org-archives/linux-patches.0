Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809D719D07C;
	Thu,  6 Jun 2024 14:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683467; cv=none; b=OWxOoSbreanM7DG7tHTF8kEWndPD22qN4g3tG/3UHyt88rt4DIo1fH90UwpwtkCw5Vcjs4BAegSTIqXvm3vCWWGc8xQttIVBmcWbE+ZSgVpHnQIVS2HxjQuAbtwYjQkDt4aWRbWkeUUfpIXfaaOBIe2XYf09lSR+rUgblfaZRv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683467; c=relaxed/simple;
	bh=w7lHfxPAzkm3V0BmRUlVsddYwnxHmsxqoFlGzTIpH+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zx8KGhj8Zfp9+w81eyNDzht1Do5hiN2xQxj767xQnkOKaa/6GqPVFs+8LdIT9xkaCKUdSjdvMzsFs09WomEPpvVQYSggPMw/UbDxFLfDtpUUKiD10Xz3GWrn7tt34i9/sId5FjltAorK7SXFcYAR97JUdA9eI2BcsE2WRq9l9vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UU2HYtPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UU2HYtPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6055FC2BD10;
	Thu,  6 Jun 2024 14:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683467;
	bh=w7lHfxPAzkm3V0BmRUlVsddYwnxHmsxqoFlGzTIpH+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UU2HYtPbhKKGnIEvz+ZaFjtHq48I6NWQ/1Vz2pOeDxUScZgUdqWORavFs0LRpJMs3
	 yxW8PR1YWYw6JLaa3hZBEnRKczeq9QdTmOYIK76xMrMtD7hkp0Ub2XEKUZW1AcSrAT
	 KnVeAb3g4EBA7WaRYbdej1/ICtBNC/L0zcBpooaU=
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
Subject: [PATCH 6.6 411/744] perf report: Convert to the global annotation_options
Date: Thu,  6 Jun 2024 16:01:23 +0200
Message-ID: <20240606131745.649598037@linuxfoundation.org>
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

[ Upstream commit 14953f038d6b30e3dc9d1aa4d4584ac505e5a8ec ]

Use the global option and drop the local copy.

Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20231128175441.721579-3-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: aaf494cf483a ("perf annotate: Fix annotation_calc_lines() to pass correct address to get_srcline()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 749246817aed3..00354d16adb43 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -98,7 +98,6 @@ struct report {
 	bool			skip_empty;
 	int			max_stack;
 	struct perf_read_values	show_threads_values;
-	struct annotation_options annotation_opts;
 	const char		*pretty_printing_style;
 	const char		*cpu_list;
 	const char		*symbol_filter_str;
@@ -542,7 +541,7 @@ static int evlist__tui_block_hists_browse(struct evlist *evlist, struct report *
 		ret = report__browse_block_hists(&rep->block_reports[i++].hist,
 						 rep->min_percent, pos,
 						 &rep->session->header.env,
-						 &rep->annotation_opts);
+						 &annotate_opts);
 		if (ret != 0)
 			return ret;
 	}
@@ -670,7 +669,7 @@ static int report__browse_hists(struct report *rep)
 		}
 
 		ret = evlist__tui_browse_hists(evlist, help, NULL, rep->min_percent,
-					       &session->header.env, true, &rep->annotation_opts);
+					       &session->header.env, true, &annotate_opts);
 		/*
 		 * Usually "ret" is the last pressed key, and we only
 		 * care if the key notifies us to switch data file.
@@ -730,7 +729,7 @@ static int hists__resort_cb(struct hist_entry *he, void *arg)
 	if (rep->symbol_ipc && sym && !sym->annotate2) {
 		struct evsel *evsel = hists_to_evsel(he->hists);
 
-		symbol__annotate2(&he->ms, evsel, &rep->annotation_opts, NULL);
+		symbol__annotate2(&he->ms, evsel, &annotate_opts, NULL);
 	}
 
 	return 0;
@@ -1326,15 +1325,15 @@ int cmd_report(int argc, const char **argv)
 		   "list of cpus to profile"),
 	OPT_BOOLEAN('I', "show-info", &report.show_full_info,
 		    "Display extended information about perf.data file"),
-	OPT_BOOLEAN(0, "source", &report.annotation_opts.annotate_src,
+	OPT_BOOLEAN(0, "source", &annotate_opts.annotate_src,
 		    "Interleave source code with assembly code (default)"),
-	OPT_BOOLEAN(0, "asm-raw", &report.annotation_opts.show_asm_raw,
+	OPT_BOOLEAN(0, "asm-raw", &annotate_opts.show_asm_raw,
 		    "Display raw encoding of assembly instructions (default)"),
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
-	OPT_STRING(0, "prefix", &report.annotation_opts.prefix, "prefix",
+	OPT_STRING(0, "prefix", &annotate_opts.prefix, "prefix",
 		    "Add prefix to source file path names in programs (with --prefix-strip)"),
-	OPT_STRING(0, "prefix-strip", &report.annotation_opts.prefix_strip, "N",
+	OPT_STRING(0, "prefix-strip", &annotate_opts.prefix_strip, "N",
 		    "Strip first N entries of source file path name in programs (with --prefix)"),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
 		    "Show a column with the sum of periods"),
@@ -1386,7 +1385,7 @@ int cmd_report(int argc, const char **argv)
 		   "Time span of interest (start,stop)"),
 	OPT_BOOLEAN(0, "inline", &symbol_conf.inline_name,
 		    "Show inline function"),
-	OPT_CALLBACK(0, "percent-type", &report.annotation_opts, "local-period",
+	OPT_CALLBACK(0, "percent-type", &annotate_opts, "local-period",
 		     "Set percent type local/global-period/hits",
 		     annotate_parse_percent_type),
 	OPT_BOOLEAN(0, "ns", &symbol_conf.nanosecs, "Show times in nanosecs"),
@@ -1418,7 +1417,7 @@ int cmd_report(int argc, const char **argv)
 	 */
 	symbol_conf.keep_exited_threads = true;
 
-	annotation_options__init(&report.annotation_opts);
+	annotation_options__init(&annotate_opts);
 
 	ret = perf_config(report__config, &report);
 	if (ret)
@@ -1437,13 +1436,13 @@ int cmd_report(int argc, const char **argv)
 	}
 
 	if (disassembler_style) {
-		report.annotation_opts.disassembler_style = strdup(disassembler_style);
-		if (!report.annotation_opts.disassembler_style)
+		annotate_opts.disassembler_style = strdup(disassembler_style);
+		if (!annotate_opts.disassembler_style)
 			return -ENOMEM;
 	}
 	if (objdump_path) {
-		report.annotation_opts.objdump_path = strdup(objdump_path);
-		if (!report.annotation_opts.objdump_path)
+		annotate_opts.objdump_path = strdup(objdump_path);
+		if (!annotate_opts.objdump_path)
 			return -ENOMEM;
 	}
 	if (addr2line_path) {
@@ -1452,7 +1451,7 @@ int cmd_report(int argc, const char **argv)
 			return -ENOMEM;
 	}
 
-	if (annotate_check_args(&report.annotation_opts) < 0) {
+	if (annotate_check_args(&annotate_opts) < 0) {
 		ret = -EINVAL;
 		goto exit;
 	}
@@ -1684,7 +1683,7 @@ int cmd_report(int argc, const char **argv)
 			 */
 			symbol_conf.priv_size += sizeof(u32);
 		}
-		annotation_config__init(&report.annotation_opts);
+		annotation_config__init(&annotate_opts);
 	}
 
 	if (symbol__init(&session->header.env) < 0)
@@ -1738,7 +1737,7 @@ int cmd_report(int argc, const char **argv)
 	zstd_fini(&(session->zstd_data));
 	perf_session__delete(session);
 exit:
-	annotation_options__exit(&report.annotation_opts);
+	annotation_options__exit(&annotate_opts);
 	free(sort_order_help);
 	free(field_order_help);
 	return ret;
-- 
2.43.0



