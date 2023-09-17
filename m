Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7265B746E
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C213C433C8;
	Sun, 17 Sep 2023 19:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980687;
	bh=YZSisbruAH/vvDY24lyHyKFC7mSWT4fNCzPqqkeivoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLRvK0H2WayXZTUerTk95oapsvUWw8pZsoGdWMU0fwWiioNJXexbLOi901ff25GBb
	 WsrQXcHlme4e9RYeL0ZaPoFkpTa32OEmy1QVeSVMpbR7PHDkMGv+Olu4HPsER46oJa
	 FAxbvsxpRQNb1b4b6xSBxBOJ5Xju73C6OVY8CH/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.5 237/285] perf hists browser: Fix the number of entries for e key
Date: Sun, 17 Sep 2023 21:13:57 +0200
Message-ID: <20230917191059.601057358@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

commit f6b8436bede3e80226e8b2100279c4450c73806a upstream.

The 'e' key is to toggle expand/collapse the selected entry only.  But
the current code has a bug that it only increases the number of entries
by 1 in the hierarchy mode so users cannot move under the current entry
after the key stroke.  This is due to a wrong assumption in the
hist_entry__set_folding().

The commit b33f922651011eff ("perf hists browser: Put hist_entry folding
logic into single function") factored out the code, but actually it
should be handled separately.  The hist_browser__set_folding() is to
update fold state for each entry so it needs to traverse all (child)
entries regardless of the current fold state.  So it increases the
number of entries by 1.

But the hist_entry__set_folding() only cares the currently selected
entry and its all children.  So it should count all unfolded child
entries.  This code is implemented in hist_browser__toggle_fold()
already so we can just call it.

Fixes: b33f922651011eff ("perf hists browser: Put hist_entry folding logic into single function")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230731094934.1616495-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/ui/browsers/hists.c |   58 ++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 34 deletions(-)

--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -407,11 +407,6 @@ static bool hist_browser__selection_has_
 	return container_of(ms, struct callchain_list, ms)->has_children;
 }
 
-static bool hist_browser__he_selection_unfolded(struct hist_browser *browser)
-{
-	return browser->he_selection ? browser->he_selection->unfolded : false;
-}
-
 static bool hist_browser__selection_unfolded(struct hist_browser *browser)
 {
 	struct hist_entry *he = browser->he_selection;
@@ -584,8 +579,8 @@ static int hierarchy_set_folding(struct
 	return n;
 }
 
-static void __hist_entry__set_folding(struct hist_entry *he,
-				      struct hist_browser *hb, bool unfold)
+static void hist_entry__set_folding(struct hist_entry *he,
+				    struct hist_browser *hb, bool unfold)
 {
 	hist_entry__init_have_children(he);
 	he->unfolded = unfold ? he->has_children : false;
@@ -603,34 +598,12 @@ static void __hist_entry__set_folding(st
 		he->nr_rows = 0;
 }
 
-static void hist_entry__set_folding(struct hist_entry *he,
-				    struct hist_browser *browser, bool unfold)
-{
-	double percent;
-
-	percent = hist_entry__get_percent_limit(he);
-	if (he->filtered || percent < browser->min_pcnt)
-		return;
-
-	__hist_entry__set_folding(he, browser, unfold);
-
-	if (!he->depth || unfold)
-		browser->nr_hierarchy_entries++;
-	if (he->leaf)
-		browser->nr_callchain_rows += he->nr_rows;
-	else if (unfold && !hist_entry__has_hierarchy_children(he, browser->min_pcnt)) {
-		browser->nr_hierarchy_entries++;
-		he->has_no_entry = true;
-		he->nr_rows = 1;
-	} else
-		he->has_no_entry = false;
-}
-
 static void
 __hist_browser__set_folding(struct hist_browser *browser, bool unfold)
 {
 	struct rb_node *nd;
 	struct hist_entry *he;
+	double percent;
 
 	nd = rb_first_cached(&browser->hists->entries);
 	while (nd) {
@@ -640,6 +613,21 @@ __hist_browser__set_folding(struct hist_
 		nd = __rb_hierarchy_next(nd, HMD_FORCE_CHILD);
 
 		hist_entry__set_folding(he, browser, unfold);
+
+		percent = hist_entry__get_percent_limit(he);
+		if (he->filtered || percent < browser->min_pcnt)
+			continue;
+
+		if (!he->depth || unfold)
+			browser->nr_hierarchy_entries++;
+		if (he->leaf)
+			browser->nr_callchain_rows += he->nr_rows;
+		else if (unfold && !hist_entry__has_hierarchy_children(he, browser->min_pcnt)) {
+			browser->nr_hierarchy_entries++;
+			he->has_no_entry = true;
+			he->nr_rows = 1;
+		} else
+			he->has_no_entry = false;
 	}
 }
 
@@ -659,8 +647,10 @@ static void hist_browser__set_folding_se
 	if (!browser->he_selection)
 		return;
 
-	hist_entry__set_folding(browser->he_selection, browser, unfold);
-	browser->b.nr_entries = hist_browser__nr_entries(browser);
+	if (unfold == browser->he_selection->unfolded)
+		return;
+
+	hist_browser__toggle_fold(browser);
 }
 
 static void ui_browser__warn_lost_events(struct ui_browser *browser)
@@ -732,8 +722,8 @@ static int hist_browser__handle_hotkey(s
 		hist_browser__set_folding(browser, true);
 		break;
 	case 'e':
-		/* Expand the selected entry. */
-		hist_browser__set_folding_selected(browser, !hist_browser__he_selection_unfolded(browser));
+		/* Toggle expand/collapse the selected entry. */
+		hist_browser__toggle_fold(browser);
 		break;
 	case 'H':
 		browser->show_headers = !browser->show_headers;


