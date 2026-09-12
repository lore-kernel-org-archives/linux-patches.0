Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7E1346AE3;
	Sat, 12 Sep 2026 07:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199077; cv=none; b=LLGpOwi6+qJnhIcC60pisfzYvOeLzRpGKre7+bc/+4Vzf1xbB2J9mno8m30+ONGHFcARSE1gM9ad5v9vpfuJWzZPOrHwq0zjarkBLkPHcFVg+LjMUfF80rDKj/BMiMJcyzEps/UcWmQIL+w6aBX8txNFBgJ7bDEqmfw6eFr3lJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199077; c=relaxed/simple;
	bh=eBjdqXxj49zxFO3KEylSTMJ05XkLR8HHJR/vHMJjA2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQAQ8XM8OEUcRFrWKd7PfXmUKOlgVkPmU3yfrg4hIoeC2qE0aO9wTTSjpqDerOikYkOZuJbaCY31Ls4Txq3c5Ee1oMNajzsVeJtLZgDgWCe3rgWsxv3YOoEYpklPblAp39oZaYieQs+W5qF28LQZXHdRB8W0GSJKyMeI4lkpM5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOAeVRdu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOAeVRdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5C11F000FF;
	Sat, 12 Sep 2026 07:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199076;
	bh=8KiRpU8PCT4M26QQvwxq8x6sP16ysZB/0EJUBh1jn64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOAeVRdufNgELT61RORK4Qvj0MWsqST1bDGcDFhjVsJWmxcOZZq/tc4WUvvprce3r
	 HEGRIJxs0cN+ZgqRd5UfjOzL6WZPmhv9Kop9Xl2smE8spZqVLOChF4LXoyHlqwxbol
	 pmfuwZ4DOP/jSWTLUirHbd/q+sFl8oYKN+wG9qFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0512/1815] perf ui hists: Fix uninitialized stack memory free on pstack allocation failure
Date: Sat, 12 Sep 2026 08:37:42 +0200
Message-ID: <20260912065700.910160412@linuxfoundation.org>
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
index da7cc195b9f41..bae7e4943abff 100644
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



