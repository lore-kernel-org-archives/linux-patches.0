Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF48400DF6;
	Sat, 12 Sep 2026 11:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212653; cv=none; b=ZOmb+zrkeQCExXbzGW/CH7ya/FUZXfAKSLD0qrh++hhLXepa1Nx1ZO36+1Xv2lWe4RVNiE+Q0jMZvCG+ODsJ1/sbkuru42GBoIQU8CwzWojVitUHjke/oaH236gsDmeLeza6qMZK9hfh3Zg7MJXW/kMLvcEwakWpVgGm8xyJr/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212653; c=relaxed/simple;
	bh=mpFFTyMWHn4Ddi7SeFMSte9LPayZwVZe/1ll8RX0jg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CA1aliSCGwkE+fjVebHf7R1N7PopHG3bgyKmc4iqG+Bn4RX6Eyzo8dRNEt+NsgDPwBYGMw7f8YLRnrVLXFCbrE2FaFY7Mx/TeZKUwn0r8YXaYwcBxfd4uCeO4qIFRwfGmPKFTPmt83TLSMuXvrxbjQsHeN72mmmvfXsilVc0ltk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1mj1yP91; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1mj1yP91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F99A1F000FF;
	Sat, 12 Sep 2026 11:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212652;
	bh=3evPJN6u+zCd7JvJycUpRs7fH9Pf3urN1IVWL4rQ/O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1mj1yP91gaX2QeTeveIjj6dl1VqriHDpN3o8sf9uLxyBhOO1A1QDb24SEy41sRD32
	 7/n7yPJOEvaVC+tAd9GikgUlSAi5qEgyzbgddBQYdh+ETNhylHIAEhdCguwDpK6C8d
	 Pmkc8S3aYl3vP4JqoYGqbIDaEQiFnKROybknDzG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyou Li <tianyou.li@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1481/1518] perf annotate: Fix build with NO_SLANG=1
Date: Sat, 12 Sep 2026 09:00:50 +0200
Message-ID: <20260912065657.062881527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 0e6c07a3c30cdc4509fc5e7dc490d4cc6e5c241a ]

The recent change for perf c2c annotate broke build without slang
support like below.

  builtin-annotate.c: In function 'hists__find_annotations':
  builtin-annotate.c:522:73: error: 'NO_ADDR' undeclared (first use in this function); did you mean 'NR_ADDR'?
    522 |                         key = hist_entry__tui_annotate(he, evsel, NULL, NO_ADDR);
        |                                                                         ^~~~~~~
        |                                                                         NR_ADDR
  builtin-annotate.c:522:73: note: each undeclared identifier is reported only once for each function it appears in

  builtin-annotate.c:522:31: error: too many arguments to function 'hist_entry__tui_annotate'
    522 |                         key = hist_entry__tui_annotate(he, evsel, NULL, NO_ADDR);
        |                               ^~~~~~~~~~~~~~~~~~~~~~~~
  In file included from util/sort.h:6,
                   from builtin-annotate.c:28:
  util/hist.h:756:19: note: declared here
    756 | static inline int hist_entry__tui_annotate(struct hist_entry *he __maybe_unused,
        |                   ^~~~~~~~~~~~~~~~~~~~~~~~

And I noticed that it missed to update the other side of #ifdef
HAVE_SLANG_SUPPORT.  Let's fix it.

Cc: Tianyou Li <tianyou.li@intel.com>
Fixes: cd3466cd2639783d ("perf c2c: Add annotation support to perf c2c report")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hist.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index c64005278687c..a4f244a046866 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -709,6 +709,8 @@ struct block_hist {
 	struct hist_entry	he;
 };
 
+#define NO_ADDR 0
+
 #ifdef HAVE_SLANG_SUPPORT
 #include "../ui/keysyms.h"
 void attr_to_script(char *buf, struct perf_event_attr *attr);
@@ -746,14 +748,16 @@ int evlist__tui_browse_hists(struct evlist *evlist __maybe_unused,
 static inline int __hist_entry__tui_annotate(struct hist_entry *he __maybe_unused,
 					     struct map_symbol *ms __maybe_unused,
 					     struct evsel *evsel __maybe_unused,
-					     struct hist_browser_timer *hbt __maybe_unused)
+					     struct hist_browser_timer *hbt __maybe_unused,
+					     u64 al_addr __maybe_unused)
 {
 	return 0;
 }
 
 static inline int hist_entry__tui_annotate(struct hist_entry *he __maybe_unused,
 					   struct evsel *evsel __maybe_unused,
-					   struct hist_browser_timer *hbt __maybe_unused)
+					   struct hist_browser_timer *hbt __maybe_unused,
+					   u64 al_addr __maybe_unused)
 {
 	return 0;
 }
-- 
2.53.0



