Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FD63D0907;
	Tue, 21 Jul 2026 18:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657098; cv=none; b=dGTr7xUpaCUUdtHB2fa20HdETlYjTMPHaZYWSFDuelHZt1cj4tLRrP6xnZGzTtdU4XIQf94Ws2Ca3+qrzg2ondF14Ch8DmC6+Oan1D566UGDdwF23aUyNpQuGIXB/IVgKENxxus5iriTDQptw3AfiT15xbxUMjOEMcNi4SFXHVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657098; c=relaxed/simple;
	bh=Dw/dnlPf2iAuyp0GHmawhgrpCS3/gQzPPljARPLeZBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKB0VwnifFZxafzGtLNR3N/INWm4ojUj+0i5ztbQ3+//61g6b/hq+VUrKAr+urlPAh2/FAPKFZP77OQDjaG4EKSqihCmryY/fIDIdw0x1ZKRCoY8dxq2xVSm0pO6t/inyPjBUdlTnUFpOrswhDAqHITjgz0+FUJH4aGoS7GXAS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5c4Uwja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5c4Uwja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC041F000E9;
	Tue, 21 Jul 2026 18:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657097;
	bh=xgkzS2H+LFQRfAjO48nha6iVtBZloUc4cI1DT1V22MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5c4UwjaCkY9Us+3i2llKzhz4o+iszRVO+GjlMMk8/oMnF2jdxZUAKKd8425QZvjt
	 2XKPPV32JE/gFr0Uwf/CmmIOyigZ3rlY2IqweSg7GfAgLi8Av+mMRKtTMliSu8Qnye
	 OJF64ZQrcOYjUzVTKcHM50ZOi1iNozDk83WcmL7I=
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
Subject: [PATCH 6.18 0635/1611] perf annotate: Fix crashes on empty annotate windows
Date: Tue, 21 Jul 2026 17:12:31 +0200
Message-ID: <20260721152529.671411570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8fe699f985423e..97f92512f136d1 100644
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



