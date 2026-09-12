Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9762A3542F8;
	Sat, 12 Sep 2026 10:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207912; cv=none; b=aP9AhTyqUWifj5gkwd9+DSKyZ/RrO56j6geFEirqrlOjSRuIb83FRBiMis0eEdO6/4+RpWr73bc+J5jNnf1cIEWrCo2TgX1Xap6IOlQUmsUmq6KxH/utPMSdnY0rWTXJXxE9zzJj5LQ483M254xUTqpBu7TlkzwBAIAuWKLALm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207912; c=relaxed/simple;
	bh=UKVS9gWVrsM81s560QwNXkFVdMVGHZbf1zXwgHBU+Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEHGRkOIV3Gh7dUyFmNOHbcXAyydIIuuYxZNWDU3gf8GlO2TyQNgs/X1kY1mbFG9L57wc7XJlbafoz6wKfE8m3kL0JC6j2U+tISowxwsD7EJBFNLsNjleNLSIzFzmeQOIppRFRbNEmyDkqiUxLH0HvhYJyL1md7K9zDWOagU2v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTBSdi54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTBSdi54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509C91F000FF;
	Sat, 12 Sep 2026 10:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207911;
	bh=FUc+MZJ/627vcKgJFUdTS//qTRqfbFteI1iRMMiF2t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTBSdi544YYD2jfDTZiO1a3pSvjziiqMbg/yj8tlphRSGtfba7JjYKxQCH8aTiJms
	 XCfnQTiJ5mmbHn2Ax26esEfizcVScpmzULPuWlPiMVqQrMAtjOWVamGMunWRKRE+te
	 /OWaBHbykJ4VpUCEPy4YjzzBIRcYiKPZNZ/u08f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0467/1518] perf ui hists: Fix uninitialized stack memory free on pstack allocation failure
Date: Sat, 12 Sep 2026 08:43:56 +0200
Message-ID: <20260912065634.010884670@linuxfoundation.org>
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
index 487c0b08c0038..9c371b262b3b8 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -3064,15 +3064,15 @@ static int evsel__hists_browse(struct evsel *evsel, int nr_events, const char *h
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



