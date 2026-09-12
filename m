Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3352931FB;
	Sat, 12 Sep 2026 08:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200160; cv=none; b=RtHSnKLvTuNkHtsQwvWrnoQJPRBLj/+b/PakT7tTGm1IDwzEtpSf/D3a5kggC05CyURzRh2aquIMLbysKFt3b4B8RFaiuBdAPvKj21T/LOIsECTcr5Fht1LgOGSBOPHQ8neGWfd9I1fGN1o+9kZRuas6LNppvkZKOuuSQd4sKeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200160; c=relaxed/simple;
	bh=FB+VCTML0CLKggtJT/zhLswidohAitwCG0xc+pONBE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EE6bQE2uU+ZFrSfhZ4Ij8Al8wTmq3Sou8B5yxmvLJmT5q9oGYP2ZNxKWoWunOdT0Msr4gZu71M2rLNAmW/xl2qgXW1tMn46h0sxKdNbKIYUAj9P4JEd/YjjQIijKZxjM9heYDEaifmaBExXoKPI2D4OaFEkgZ7+fE68EKCZF0jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fD4TCim7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fD4TCim7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EB11F000FF;
	Sat, 12 Sep 2026 08:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200159;
	bh=WJ/PFKu8o8RKmxaFRojaEtZBkthemHX4dmX80uoP+Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fD4TCim7Yw3K8Sy/tsxQo2Qu9WhSNsKK6SpZShOG66i6Y8IvOe+NGKVzwOLTF4gzS
	 8qfTudrW+GmmXHGUU3iU8jsvUM+KdHVCp29LQpel1X1U2Hh8QaTnaq7rM6k4ztQ1ZF
	 C5Gb1SGI83xCrVBiyVeivxnSObLt60w8gY99qkRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Stone <jistone@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0691/1815] perf ui hists: In report UI ensure thread is set with reference counting
Date: Sat, 12 Sep 2026 08:40:41 +0200
Message-ID: <20260912065705.112904769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit ae89153d5e50d22e04a084829f74dc5a9ae6eb6d ]

Populates the map_symbol thread in the UI code to fix the e_machine
lookup for cross-platform disassembly when using the annotate action.
At the same time, refactor the UI options and actions generation to
comply with the perf subsystem's strict reference counting abstraction
requirements for 'struct map_symbol' and 'struct thread'. Introduce
explicit reference acquiring via map_symbol__copy() and thread__get() for
menu items, safely clean them up between menu iterations using a new
free_popup_actions() helper, and utilize insulated temporary action
variables for direct hotkey handler execution.

Fixes: 0e26ba5a8774 ("perf disasm: Refactor arch__find and initialization of arch structs")
Reported-by: Josh Stone <jistone@redhat.com>
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 135 +++++++++++++++++++++------------
 1 file changed, 87 insertions(+), 48 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index bae7e4943abff..d77f9890b3e9c 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -2356,6 +2356,16 @@ static int hists_browser__scnprintf_title(struct hist_browser *browser, char *bf
 	return printed;
 }
 
+struct popup_action {
+	unsigned long		time;
+	struct thread		*thread;
+	int (*fn)(struct hist_browser *browser, struct popup_action *act);
+	struct map_symbol	ms;
+	int			socket;
+	enum rstype		rstype;
+
+};
+
 static inline void free_popup_options(char **options, int n)
 {
 	int i;
@@ -2364,6 +2374,16 @@ static inline void free_popup_options(char **options, int n)
 		zfree(&options[i]);
 }
 
+static inline void free_popup_actions(struct popup_action *actions, int n)
+{
+	int i;
+
+	for (i = 0; i < n; ++i) {
+		map_symbol__exit(&actions[i].ms);
+		memset(&actions[i], 0, sizeof(struct popup_action));
+	}
+}
+
 /*
  * Only runtime switching of perf data file will make "input_name" point
  * to a malloced buffer. So add "is_input_name_malloced" flag to decide
@@ -2453,16 +2473,6 @@ static int switch_data_file(void)
 	return ret;
 }
 
-struct popup_action {
-	unsigned long		time;
-	struct thread 		*thread;
-	int (*fn)(struct hist_browser *browser, struct popup_action *act);
-	struct map_symbol 	ms;
-	int			socket;
-	enum rstype		rstype;
-
-};
-
 static int
 do_annotate(struct hist_browser *browser, struct popup_action *act)
 {
@@ -2540,7 +2550,7 @@ add_annotate_opt(struct popup_action *act, char **optstr,
 	if (asprintf(optstr, "Annotate %s", ms->sym->name) < 0)
 		return 0;
 
-	act->ms = *ms;
+	map_symbol__copy(&act->ms, ms);
 	act->fn = do_annotate;
 	return 1;
 }
@@ -2572,7 +2582,7 @@ add_annotate_type_opt(struct popup_action *act, char **optstr,
 static int
 do_zoom_thread(struct hist_browser *browser, struct popup_action *act)
 {
-	struct thread *thread = act->thread;
+	struct thread *thread = act->ms.thread;
 
 	if ((!hists__has(browser->hists, thread) &&
 	     !hists__has(browser->hists, comm)) || thread == NULL)
@@ -2627,7 +2637,7 @@ add_thread_opt(struct hist_browser *browser, struct popup_action *act,
 	if (ret < 0)
 		return 0;
 
-	act->thread = thread;
+	act->ms.thread = thread__get(thread);
 	act->fn = do_zoom_thread;
 	return 1;
 }
@@ -2674,7 +2684,7 @@ add_dso_opt(struct hist_browser *browser, struct popup_action *act,
 		     __map__is_kernel(map) ? "the Kernel" : dso__short_name(map__dso(map))) < 0)
 		return 0;
 
-	act->ms.map = map;
+	act->ms.map = map__get(map);
 	act->fn = do_zoom_dso;
 	return 1;
 }
@@ -2719,7 +2729,7 @@ add_map_opt(struct hist_browser *browser,
 	if (asprintf(optstr, "Browse map details") < 0)
 		return 0;
 
-	act->ms.map = map;
+	act->ms.map = map__get(map);
 	act->fn = do_browse_map;
 	return 1;
 }
@@ -2733,8 +2743,8 @@ do_run_script(struct hist_browser *browser,
 	int n = 0;
 
 	len = 100;
-	if (act->thread)
-		len += strlen(thread__comm_str(act->thread));
+	if (act->ms.thread)
+		len += strlen(thread__comm_str(act->ms.thread));
 	else if (act->ms.sym)
 		len += strlen(act->ms.sym->name);
 	script_opt = malloc(len);
@@ -2742,9 +2752,9 @@ do_run_script(struct hist_browser *browser,
 		return -1;
 
 	script_opt[0] = 0;
-	if (act->thread) {
+	if (act->ms.thread) {
 		n = scnprintf(script_opt, len, " -c %s ",
-			  thread__comm_str(act->thread));
+			  thread__comm_str(act->ms.thread));
 	} else if (act->ms.sym) {
 		n = scnprintf(script_opt, len, " -S %s ",
 			  act->ms.sym->name);
@@ -2799,7 +2809,7 @@ add_script_opt_2(struct popup_action *act, char **optstr,
 			return 0;
 	}
 
-	act->thread = thread;
+	act->ms.thread = thread__get(thread);
 	act->ms.sym = sym;
 	act->fn = do_run_script;
 	return 1;
@@ -3087,6 +3097,8 @@ static int evsel__hists_browse(struct evsel *evsel, int nr_events, const char *h
 
 		key = 0; // reset key
 do_hotkey:		 // key came straight from options ui__popup_menu()
+		free_popup_options(options, MAX_OPTIONS);
+		free_popup_actions(actions, MAX_OPTIONS);
 		choice = nr_options = 0;
 		key = hist_browser__run(browser, helpline, warn_lost_event, key);
 
@@ -3146,24 +3158,40 @@ static int evsel__hists_browse(struct evsel *evsel, int nr_events, const char *h
 			}
 
 			if (!browser->selection->sym) {
+				struct map_symbol source_ms;
+
 				if (!browser->he_selection)
 					continue;
 
+				memset(&source_ms, 0, sizeof(source_ms));
+
 				if (sort__mode == SORT_MODE__BRANCH) {
 					bi = browser->he_selection->branch_info;
 					if (!bi || !bi->to.ms.map)
 						continue;
 
-					actions->ms.sym = symbol__new_unresolved(bi->to.al_addr, bi->to.ms.map);
-					actions->ms.map = bi->to.ms.map;
+					source_ms.sym =
+						symbol__new_unresolved(
+							bi->to.al_addr,
+							bi->to.ms.map);
+					source_ms.thread = bi->to.ms.thread;
+					source_ms.map = bi->to.ms.map;
 				} else {
-					actions->ms.sym = symbol__new_unresolved(browser->he_selection->ip,
-										 browser->selection->map);
-					actions->ms.map = browser->selection->map;
+					source_ms.sym =
+						symbol__new_unresolved(
+							browser->he_selection->ip,
+							browser->selection->map);
+					source_ms.thread = browser->selection->thread;
+					source_ms.map = browser->selection->map;
 				}
 
-				if (!actions->ms.sym)
+				if (!source_ms.sym)
 					continue;
+
+				memset(&hotkey_act, 0, sizeof(hotkey_act));
+				map_symbol__copy(&hotkey_act.ms, &source_ms);
+				do_annotate(browser, &hotkey_act);
+				map_symbol__exit(&hotkey_act.ms);
 			} else {
 				if (symbol__annotation(browser->selection->sym)->src == NULL) {
 					ui_browser__warning(&browser->b, delay_secs * 2,
@@ -3173,18 +3201,20 @@ static int evsel__hists_browse(struct evsel *evsel, int nr_events, const char *h
 					continue;
 				}
 
-				actions->ms.map = browser->selection->map;
-				actions->ms.sym = browser->selection->sym;
+				memset(&hotkey_act, 0, sizeof(hotkey_act));
+				map_symbol__copy(&hotkey_act.ms, browser->selection);
+				do_annotate(browser, &hotkey_act);
+				map_symbol__exit(&hotkey_act.ms);
 			}
-
-			do_annotate(browser, actions);
 			continue;
 		case 'P':
 			hist_browser__dump(browser);
 			continue;
 		case 'd':
-			actions->ms.map = map;
-			do_zoom_dso(browser, actions);
+			memset(&hotkey_act, 0, sizeof(hotkey_act));
+			hotkey_act.ms.map = map__get(map);
+			do_zoom_dso(browser, &hotkey_act);
+			map_symbol__exit(&hotkey_act.ms);
 			continue;
 		case 'k':
 			if (browser->selection != NULL)
@@ -3199,12 +3229,16 @@ static int evsel__hists_browse(struct evsel *evsel, int nr_events, const char *h
 					   verbose);
 			continue;
 		case 't':
-			actions->thread = thread;
-			do_zoom_thread(browser, actions);
+			memset(&hotkey_act, 0, sizeof(hotkey_act));
+			hotkey_act.ms.thread = thread__get(thread);
+			do_zoom_thread(browser, &hotkey_act);
+			map_symbol__exit(&hotkey_act.ms);
 			continue;
 		case 'S':
-			actions->socket = socked_id;
-			do_zoom_socket(browser, actions);
+			memset(&hotkey_act, 0, sizeof(hotkey_act));
+			hotkey_act.socket = socked_id;
+			do_zoom_socket(browser, &hotkey_act);
+			map_symbol__exit(&hotkey_act.ms);
 			continue;
 		case '/':
 			if (ui_browser__input_window("Symbol to show",
@@ -3219,9 +3253,11 @@ static int evsel__hists_browse(struct evsel *evsel, int nr_events, const char *h
 			continue;
 		case 'r':
 			if (is_report_browser(hbt)) {
-				actions->thread = NULL;
-				actions->ms.sym = NULL;
-				do_run_script(browser, actions);
+				memset(&hotkey_act, 0, sizeof(hotkey_act));
+				hotkey_act.ms.thread = NULL;
+				hotkey_act.ms.sym = NULL;
+				do_run_script(browser, &hotkey_act);
+				map_symbol__exit(&hotkey_act.ms);
 			}
 			continue;
 		case 's':
@@ -3293,20 +3329,19 @@ static int evsel__hists_browse(struct evsel *evsel, int nr_events, const char *h
 
 				continue;
 			}
-			actions->ms.map = map;
+			memset(&hotkey_act, 0, sizeof(hotkey_act));
 			top = pstack__peek(browser->pstack);
 			if (top == &browser->hists->dso_filter) {
-				/*
-				 * No need to set actions->dso here since
-				 * it's just to remove the current filter.
-				 */
-				do_zoom_dso(browser, actions);
+				hotkey_act.ms.map = map__get(map);
+				do_zoom_dso(browser, &hotkey_act);
 			} else if (top == &browser->hists->thread_filter) {
-				actions->thread = thread;
-				do_zoom_thread(browser, actions);
+				hotkey_act.ms.thread = thread__get(thread);
+				do_zoom_thread(browser, &hotkey_act);
 			} else if (top == &browser->hists->socket_filter) {
-				do_zoom_socket(browser, actions);
+				hotkey_act.socket = socked_id;
+				do_zoom_socket(browser, &hotkey_act);
 			}
+			map_symbol__exit(&hotkey_act.ms);
 			continue;
 		}
 		case 'q':
@@ -3443,9 +3478,13 @@ static int evsel__hists_browse(struct evsel *evsel, int nr_events, const char *h
 
 		if (key == K_SWITCH_INPUT_DATA)
 			break;
+
+		free_popup_options(options, MAX_OPTIONS);
+		free_popup_actions(actions, MAX_OPTIONS);
 	}
 out_free_stack:
 	pstack__delete(browser->pstack);
+	free_popup_actions(actions, MAX_OPTIONS);
 out:
 	hist_browser__delete(browser);
 	free_popup_options(options, MAX_OPTIONS);
-- 
2.53.0



