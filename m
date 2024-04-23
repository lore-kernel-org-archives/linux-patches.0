Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBF8144D25;
	Tue, 23 Apr 2024 21:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908504; cv=none; b=jHB3uy+bhCWykH4DXlcSBmnCgIo/ucmS390BtoMAoAV5DGhh2PqMZOR8SB4RfYRKVSJMR6gNirkONDBIZ4G1A9gGCetslAeQ009E8Zrq/smoMTm4qdlDGvWMQ6lYUO21MZBfZ8t+pbiEt+KqDlQRBymVQM70RpiDkICoPMsREQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908504; c=relaxed/simple;
	bh=yzF7yfYzBSicIOgqhTZXWTI8TljctUb258gWiWtG5WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6Gu1GCD9T6iSSRebTSs6UVoj1CdlreK26m9sga1upLtCikcwxCgO7V53Hm6gHPUGLpAdqYM7KgbUrV4PyjMFSyPTyBSHoPKGMiIXI5J6eoJJDOdfQV7OsKfDkWRPQ2B2+530xDJUw/hyyGFw5v1nd/mdjYTw6hOEZHSNdcQE5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWmfEBw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWmfEBw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB7EC116B1;
	Tue, 23 Apr 2024 21:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908504;
	bh=yzF7yfYzBSicIOgqhTZXWTI8TljctUb258gWiWtG5WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWmfEBw6eXHEaaGIO6sfxvfjRFTpqyDDM3lPO1kOXx5cnEEMXkdWrWJegdtp1ncga
	 sufpeL3bdqApdhqG8dftJ2gyZmkQhglSjJFQmS+wKM1j5kSOAn4ig82SpGdkehEPXv
	 52y6KQLNhErlZffLI+y6jNbvOROi+21zxmPq0nQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 058/158] perf annotate: Make sure to call symbol__annotate2() in TUI
Date: Tue, 23 Apr 2024 14:38:00 -0700
Message-ID: <20240423213857.833351553@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 2b8dbf69ec60faf6c7db49e57d7f316409ccec92 ]

The symbol__annotate2() initializes some data structures needed by TUI.
It has a logic to prevent calling it multiple times by checking if it
has the annotated source.  But data type profiling uses a different
code (symbol__annotate) to allocate the annotated lines in advance.
So TUI missed to call symbol__annotate2() when it shows the annotation
browser.

Make symbol__annotate() reentrant and handle that situation properly.
This fixes a crash in the annotation browser started by perf report in
TUI like below.

  $ perf report -s type,sym --tui
  # and press 'a' key and then move down

Fixes: 81e57deec325 ("perf report: Support data type profiling")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240405211800.1412920-2-namhyung@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/browsers/annotate.c | 2 +-
 tools/perf/util/annotate.c        | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index ec5e219328760..4790c735599bd 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -970,7 +970,7 @@ int symbol__tui_annotate(struct map_symbol *ms, struct evsel *evsel,
 	if (dso->annotate_warned)
 		return -1;
 
-	if (not_annotated) {
+	if (not_annotated || !sym->annotate2) {
 		err = symbol__annotate2(ms, evsel, &browser.arch);
 		if (err) {
 			char msg[BUFSIZ];
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 9b70ab110ce79..86a996290e9ab 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -2435,6 +2435,9 @@ int symbol__annotate(struct map_symbol *ms, struct evsel *evsel,
 	if (parch)
 		*parch = arch;
 
+	if (!list_empty(&notes->src->source))
+		return 0;
+
 	args.arch = arch;
 	args.ms = *ms;
 	if (annotate_opts.full_addr)
-- 
2.43.0



