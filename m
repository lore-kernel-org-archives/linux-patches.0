Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA301FBEA6;
	Sat, 12 Sep 2026 19:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242738; cv=none; b=HZrSQf8vDXviU/KPEGmcYNwiuO3RxMRi11RXNUr/1Z0Dvy+zOLRYN6vdN8789C7zdY4M02QzK4xKuk9sbQhcEZxpf9OPARJxIEjc4yN5IgOBCKzoU6NL/8iDWR4uU9TAA33uswtRqFv9YYnqqei06wCb0m3bdBbsheCyLJ7JFsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242738; c=relaxed/simple;
	bh=hWiV66RocaRfw/YBPmKNRo+05iSpXdIW+A+7rX0dEas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vq5DNYSGalexp3j7PGzZTcHv9zTCUbwKY2X1WMh5r0KoXh0i9AwcwnX3WAdIqmDOehz/zSlcgPgoesSWVokFv/9QvOYeuohBMyqmBh1PYQN73lwU6curFMqym+38ZINfeZjB9ACwSi7Z9/qRtl8vblJb5buCzdwhUQJpLVRDAcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zK1fDz3g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zK1fDz3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856F71F000FF;
	Sat, 12 Sep 2026 19:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242737;
	bh=HM8NS2oIZPVNUffTEacvXhjCTnuiufIfLnHtV9o//f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zK1fDz3g25K2JwbFODYbxOnE9GQoYLknutk5A+26Q2K0wQyVCODUk+bG2h31xSGrD
	 +pWyyhnf2nIQwZsu+aMBMd2ekgy+dJedBYOpzBuuHZZReNlE+SGgYwvo+TvegG09pp
	 C/nvHdxlzDgjNncJQgXWvE4UazxlGfEdl84o//I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 472/798] perf ui hists: Fix uninitialized stack memory free on pstack allocation failure
Date: Sat, 12 Sep 2026 09:01:40 +0200
Message-ID: <20260912065527.963816594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 19e79e159996a..ce95b4a46a8fa 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -3008,15 +3008,15 @@ static int perf_evsel__hists_browse(struct evsel *evsel, int nr_events,
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



