Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0643B8BB9;
	Tue, 21 Jul 2026 18:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660299; cv=none; b=MVhcMvZATQnlYLW9Hr+9zAM+KSNxuzjPI3iNEvWmFdGp4pOCXe1Bb3zW0aOEIeB9lGcepKu721NY2NhLTIflxUGUSD6evY/hbBwxFCRAgbaJV0HCnvLEnqzUSB/UM5/u7ufNQdj631VXWTlwvmtLj47xb0oU42dmngmo9WC44lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660299; c=relaxed/simple;
	bh=zL52wynhINJl9YDal8zK0WpUqaVS0/uXkxpTbocQMaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3QvWHko4/480ARfaAMEl6gzF5rSJPjzF7dOlI2Zs7s1u5fdHNfsqXIrT7Wqh0eNz95fiIS4xayG0hv32JHDgBso1clhINPUEaB8yBomWwH5da9ar+pySYm5/REx9xgkU/ncWhv/gDrzaWsE7wP0w95UkLzmOJdnfDc86lHhBfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojwJ7oWe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojwJ7oWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547761F000E9;
	Tue, 21 Jul 2026 18:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660297;
	bh=utGsQH+gxqPoMPasgo/R08m2fwoH+jcLsHblJHYPAcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojwJ7oWe6O9xuknKZvWflc/yi1U/+SNVBN6nxLRy3bDyxr3EVI9x77wTT7Cy9jNM2
	 UsP1M/abUrr8LSKxMDYD39Eo2Oi/iYSxzud1bTl0uGQKkut37oS0hVqkbAZZoiCUK8
	 +3u75FxNdWFMJLh6KPYmv4tiUIYzIPlXca+5CvEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0928/2077] perf annotate: Fix crashes on empty annotate windows
Date: Tue, 21 Jul 2026 17:10:01 +0200
Message-ID: <20260721152614.703754645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit 74802634e4a7e556429417963a8cbda27dd8b4b3 ]

Annotate can open with an empty window if the disassembly tool fails.
After the linked change, the TUI started assuming there was a current
annotation line and could assert or segfault in the seek, refresh, and
source-toggle paths.

Handle empty annotate windows explicitly: set the asm entry count before
resetting the browser, return early when refreshing an empty list, and
ignore source line toggle when there is no current annotation line.

Fixes the following when opening an annotation:

  perf: ui/browser.c:125: ui_browser__list_head_seek: Assertion `pos != NULL' failed.
  Aborted

Fixes: e201757f7a0a901e ("perf annotate: Fix source code annotate with objdump")
Assisted-by: GitHub Copilot:GPT-5.4
Signed-off-by: James Clark <james.clark@linaro.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/browser.c           | 3 +++
 tools/perf/ui/browsers/annotate.c | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index dc88427b4ae5af..321187b204d38d 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -513,6 +513,9 @@ unsigned int ui_browser__list_head_refresh(struct ui_browser *browser)
 	struct list_head *head = browser->entries;
 	int row = 0;
 
+	if (browser->nr_entries == 0)
+		return 0;
+
 	if (browser->top == NULL || browser->top == browser->entries)
                 browser->top = ui_browser__list_head_filter_entries(browser, head->next);
 
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index ea17e6d29a7e49..0261cd92218344 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -449,6 +449,9 @@ static bool annotate_browser__toggle_source(struct annotate_browser *browser,
 	struct annotation_line *al;
 	off_t offset = browser->b.index - browser->b.top_idx;
 
+	if (browser->b.nr_entries == 0)
+		return false;
+
 	browser->b.seek(&browser->b, offset, SEEK_CUR);
 	al = list_entry(browser->b.top, struct annotation_line, node);
 
@@ -542,8 +545,8 @@ static void annotate_browser__show_full_location(struct ui_browser *browser)
 static void ui_browser__init_asm_mode(struct ui_browser *browser)
 {
 	struct annotation *notes = browser__annotation(browser);
-	ui_browser__reset_index(browser);
 	browser->nr_entries = notes->src->nr_asm_entries;
+	ui_browser__reset_index(browser);
 }
 
 static int sym_title(struct symbol *sym, struct map *map, char *title,
-- 
2.53.0



