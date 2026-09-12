Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5FE4BEE38;
	Sat, 12 Sep 2026 16:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229774; cv=none; b=Ipi5GUwl6i/wZQfoveP4BLSIbns0GIIumJVhlJj5yHWQLRtXCzTIFr6cxH0/kakYuVbgDJJdkv6j7gLCru876K0MZJSzX7/09u5NeaJBviStyJOHVzB1cdfmToqxqEMAbCyDyXPYWzwdXr140YVHsDQzWV8LkGHEHUzbQqvBxhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229774; c=relaxed/simple;
	bh=7BxO0IGWWxi3dyk4cUIlyCtnnx14/j7j5xbizOqIG+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X848/9foVoFYA4rWf3mFvmVTjPR1A/qu83SCpp+Neq/UwL8XS6TZUekRXECgBXg8QkOs6FxT1QUMr4TnzE6zqOz4HC4z9AZzKNU29VNFbxNyAuUBa8qHUknPBxHem080y0omtH951IUTt70x2t1iTw0NGDF9XofvP7w7FpP2qBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ce4IpoA9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ce4IpoA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537721F000FF;
	Sat, 12 Sep 2026 16:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229773;
	bh=mOjh0LMv+ZgvO0LTi7Ra34XJO18E8srtHVT0ocZIU24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ce4IpoA9OsRbuUY1IJmwZiYeP7ORqgwNg9msAh3zl5twslz5YZVq5XhojuCOFMSIP
	 HapGvtcpk4A1E8PqjjvGADOs2bv7/G+DP2/8QD2Y3rKYIdaC+C6vznGSN+nsyj6Nq7
	 LZarACQfJDoxBdHq46+oZf1e7HhG8Cl5IiRze0LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0659/1191] perf ui hists: Fix uninitialized stack memory free on pstack allocation failure
Date: Sat, 12 Sep 2026 08:56:27 +0200
Message-ID: <20260912065603.058820355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit d5fdde1c426922efabe86a515f0782b3eba40577 ]

Fixes heap corruption by initializing the options and actions arrays before
the pstack allocation check, preventing an uninitialized stack pointer from
being passed to free_popup_options() if the allocation fails.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-perf-users/20260709035230.6DBEE1F000E9@smtp.kernel.org/
Fixes: f2b487db45f2 ("perf hists browser: Fix possible memory leak")
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/linux-perf-users/20260709035230.6DBEE1F000E9@smtp.kernel.org/
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index a68d3ee1769d6..d3c75eed41c80 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -3005,15 +3005,15 @@ static int evsel__hists_browse(struct evsel *evsel, int nr_events, const char *h
 		browser->min_pcnt = min_pcnt;
 	hist_browser__update_nr_entries(browser);
 
+	memset(options, 0, sizeof(options));
+	memset(actions, 0, sizeof(actions));
+
 	browser->pstack = pstack__new(3);
 	if (browser->pstack == NULL)
 		goto out;
 
 	ui_helpline__push(helpline);
 
-	memset(options, 0, sizeof(options));
-	memset(actions, 0, sizeof(actions));
-
 	if (symbol_conf.col_width_list_str)
 		perf_hpp__set_user_width(symbol_conf.col_width_list_str);
 
-- 
2.53.0



