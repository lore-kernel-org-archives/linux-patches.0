Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF1C1A01BF;
	Tue, 12 Aug 2025 18:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024353; cv=none; b=Z86m9NcIQJIXFpenFFovlMmiyvZq9fahVy05Cw+0BsMxhn1sFHmrsaCeuxVYDJt4+lxvsUEtJarGIb1bTyj1I4Q6MYZnOTECP3buSk5Na3Tyhzd8Bd8jGOG3mjVH2yxXK++JI4MEfl3T9x39ch6/UcEvwB2mmO1LJriYK8A6/6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024353; c=relaxed/simple;
	bh=vo/SYwCgb/NgOECivxDE+Ljn6saUh05ICFlQWThhyns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFg4ZjJ8qou/e/BQsRoO2ImmX43ZfbhO9UD36f2hiD+B0O7/UHaWsRT22cX6WRczFcp9KZmUXOann1f/IdTyGsOCpc7qs+rzQlV6POTH7ZNtYwRV4gYU3FOewWHkTW8OGHGYLiZUntFgOGEh1LyLCf5xjQPjOMzdWfTu1buYMls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+xiiXnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+xiiXnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABD6C4CEF0;
	Tue, 12 Aug 2025 18:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024352;
	bh=vo/SYwCgb/NgOECivxDE+Ljn6saUh05ICFlQWThhyns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+xiiXnC9N/wiQq/iFBhXNgqX8V2uUJMoz2RAkwc2PtWxm4c2JLPfTW83tv38PT2x
	 pFRi0Nq0d3ZRE+aGDG5fCluyaniTChSU500F29S3kXYvxAxV6qZEZqyhm3jitNUsYw
	 pwUvHslUGnH1yA1h5aKbrJv6wOY4l42ZNZYA1+6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 315/627] perf parse-events: Set default GH modifier properly
Date: Tue, 12 Aug 2025 19:30:10 +0200
Message-ID: <20250812173431.282170364@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit dcbe6e51a0bb80a40f9a8c87750c291c2364573d ]

Commit 7b100989b4f6bce7 ("perf evlist: Remove __evlist__add_default")
changed to use "cycles:P" as a default event.  But the problem is it
cannot set other default modifiers correctly.

perf kvm needs to set attr.exclude_host by default but it didn't work
because of the logic in the parse_events__modifier_list().  Also the
exclude_GH_default was applied only if ":u" modifier was specified -
which is strange.  Move it out after handling the ":GH" and check
perf_host and perf_guest properly.

Before:
  $ ./perf kvm record -vv true |& grep exclude
  (nothing)

But specifying an event (without a modifier) works:

  $ ./perf kvm record -vv -e cycles true |& grep exclude
    exclude_host                     1

After:
It now works for the both cases:

  $ ./perf kvm record -vv true |& grep exclude
    exclude_host                     1

  $ ./perf kvm record -vv -e cycles true |& grep exclude
    exclude_host                     1

Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250606225431.2109754-1-namhyung@kernel.org
Fixes: 35c8d21371e9b342 ("perf tools: Don't set attr.exclude_guest by default")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 2380de56a207..d07c83ba6f1a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1829,13 +1829,11 @@ static int parse_events__modifier_list(struct parse_events_state *parse_state,
 		int eH = group ? evsel->core.attr.exclude_host : 0;
 		int eG = group ? evsel->core.attr.exclude_guest : 0;
 		int exclude = eu | ek | eh;
-		int exclude_GH = group ? evsel->exclude_GH : 0;
+		int exclude_GH = eG | eH;
 
 		if (mod.user) {
 			if (!exclude)
 				exclude = eu = ek = eh = 1;
-			if (!exclude_GH && !perf_guest && exclude_GH_default)
-				eG = 1;
 			eu = 0;
 		}
 		if (mod.kernel) {
@@ -1858,6 +1856,13 @@ static int parse_events__modifier_list(struct parse_events_state *parse_state,
 				exclude_GH = eG = eH = 1;
 			eH = 0;
 		}
+		if (!exclude_GH && exclude_GH_default) {
+			if (perf_host)
+				eG = 1;
+			else if (perf_guest)
+				eH = 1;
+		}
+
 		evsel->core.attr.exclude_user   = eu;
 		evsel->core.attr.exclude_kernel = ek;
 		evsel->core.attr.exclude_hv     = eh;
-- 
2.39.5



