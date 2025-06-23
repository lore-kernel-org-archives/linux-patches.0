Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526E570838;
	Mon, 23 Jun 2025 21:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712849; cv=none; b=Ue+4FpH8//O+FGK5UCg49Xc0lHc83cmhNmJdAiJwc6UTDxIw2dzSPKBIAT7Ju+Tl3soGV7+Ks//DVTxR/qxYyKF9LEPV1jNAXSQx3YwAABPHDOhp8ZzyS+CZJxhe6jjeUUrNbUoZedn8bSzKrZTSjSGCOyA3tUA838zK/T+EfP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712849; c=relaxed/simple;
	bh=uyRm8PxxDvoXiAvogeoptTj8iRqR0JooAANxPvL7jcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6mhrB8DphblNyjY/quR961etA3AvG/apcLWAA7XGWWCu67oewIBouT8e+p2zp8hS3UAfubQBKfJ/UWEGFj94Cpi72NZYamQHXfWchx6fjbMmTRJm9zD4czqNAJxHOWG3WNkPcuSnFGjN0XNpz4fra4Dlel9fNQGBJKBmyre+Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+oEW8mt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+oEW8mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1A4C4CEEA;
	Mon, 23 Jun 2025 21:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712849;
	bh=uyRm8PxxDvoXiAvogeoptTj8iRqR0JooAANxPvL7jcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+oEW8mt0B88JFfb0XUC9rlhjET0bzdlVoU/gFusNOiw0f86dNM1TaYwIRSpcaRF6
	 QFiKR7sSNG6GadIZlvLDDrIlPanuOapQEt/tdyALKNgCVA+m1ORZR/xz2ewc8rxjjr
	 NBaKX9t6yNy8eaucGveH6Bt0vIdzdON1XZL3piNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/411] perf ui browser hists: Set actions->thread before calling do_zoom_thread()
Date: Mon, 23 Jun 2025 15:03:56 +0200
Message-ID: <20250623130635.773350173@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 1741189d843a1d5ef38538bc52a3760e2e46cb2e ]

In 7cecb7fe8388d5c3 ("perf hists: Move sort__has_comm into struct
perf_hpp_list") it assumes that act->thread is set prior to calling
do_zoom_thread().

This doesn't happen when we use ESC or the Left arrow key to Zoom out of
a specific thread, making this operation not to work and we get stuck
into the thread zoom.

In 6422184b087ff435 ("perf hists browser: Simplify zooming code using
pstack_peek()") it says no need to set actions->thread, and at that
point that was true, but in 7cecb7fe8388d5c3 a actions->thread == NULL
check was added before the zoom out of thread could kick in.

We can zoom out using the alternative 't' thread zoom toggle hotkey to
finally set actions->thread before calling do_zoom_thread() and zoom
out, but lets also fix the ESC/Zoom out of thread case.

Fixes: 7cecb7fe8388d5c3 ("perf hists: Move sort__has_comm into struct perf_hpp_list")
Reported-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/Z_TYux5fUg2pW-pF@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index fd3e67d2c6bdd..a68d3ee1769d6 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -3238,10 +3238,10 @@ static int evsel__hists_browse(struct evsel *evsel, int nr_events, const char *h
 				/*
 				 * No need to set actions->dso here since
 				 * it's just to remove the current filter.
-				 * Ditto for thread below.
 				 */
 				do_zoom_dso(browser, actions);
 			} else if (top == &browser->hists->thread_filter) {
+				actions->thread = thread;
 				do_zoom_thread(browser, actions);
 			} else if (top == &browser->hists->socket_filter) {
 				do_zoom_socket(browser, actions);
-- 
2.39.5



