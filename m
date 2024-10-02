Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E23376;
	Wed,  2 Oct 2024 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876124; cv=none; b=lONAMC+5OwApzL+fX5CSKnUjsZ1hhtOw9bsw8ZO1o2ZrdHl3j/WuIRO28CxU60TuyH7PcPQebLNsaWDlC7fZ/+h1W9y0+LJzJ540O99Wtl3gNf4Ilqy2Pb4UhEk6n0wQRShvID5wWGjf/kVmErF02KE6j+4APAMo33e3fghCzTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876124; c=relaxed/simple;
	bh=BabhBXqFRfK+pwvWcvTMVkl3/xroeUrfuDvtfvYjtF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IF0TpLbqJGy47uM0DdsT1lSv0w/nBh7UUlJ2eyIYAHCdEBotAHixsuHRMcOXv7QnTLdxJjfqC3wVFoHmG9qLuNd14SgEEFUhZ2tNfdqMMmFvalo//vIQnwN6JED2LfraSmEx8yRFEkzw3NGS2OOuH1UT3/7Gw+3dl8UtvGRTElk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Voq06CbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Voq06CbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175C7C4CEC5;
	Wed,  2 Oct 2024 13:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876124;
	bh=BabhBXqFRfK+pwvWcvTMVkl3/xroeUrfuDvtfvYjtF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Voq06CbBt4IT9kO8/vTis5+1czgLfDy4Iv/DkOAKHiglC/uUJ6+BGDnkC8QWmcO83
	 hdBiSkA1UWglctaIiwRcP+fUGnzEiOs4SFoPbp42rh6AoSCX6grnHWBoTT4ciaW9Xr
	 tgwWl4V4fL4FVbyHruQ2X5uyblgNizGQRnlaLzRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 337/695] perf hist: Dont set hpp_fmt_value for members in --no-group
Date: Wed,  2 Oct 2024 14:55:35 +0200
Message-ID: <20241002125835.902694973@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 4f3affe0abf5d5910dc469a1f63257629605d3c3 ]

Perf crashes as below when applying --no-group

  # perf record -e "{cache-misses,branches"} -b sleep 1
  # perf report --stdio --no-group
  free(): invalid next size (fast)
  Aborted (core dumped)
  #

In the __hpp__fmt(), only 1 hpp_fmt_value is allocated for the current
event when --no-group is applied.

However, the current implementation tries to assign the hists from all
members to the hpp_fmt_value, which exceeds the allocated memory.

Fixes: 8f6071a3dce40e69 ("perf hist: Simplify __hpp_fmt() using hpp_fmt_data")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240820183202.3174323-1-kan.liang@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/hist.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 5d1f04f66a5a1..e5491995adf08 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -62,7 +62,7 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	struct evsel *pos;
 	char *buf = hpp->buf;
 	size_t size = hpp->size;
-	int i, nr_members = 1;
+	int i = 0, nr_members = 1;
 	struct hpp_fmt_value *values;
 
 	if (evsel__is_group_event(evsel))
@@ -72,16 +72,16 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	if (values == NULL)
 		return 0;
 
-	i = 0;
-	for_each_group_evsel(pos, evsel)
-		values[i++].hists = evsel__hists(pos);
-
+	values[0].hists = evsel__hists(evsel);
 	values[0].val = get_field(he);
 	values[0].samples = he->stat.nr_events;
 
 	if (evsel__is_group_event(evsel)) {
 		struct hist_entry *pair;
 
+		for_each_group_member(pos, evsel)
+			values[++i].hists = evsel__hists(pos);
+
 		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
 			for (i = 0; i < nr_members; i++) {
 				if (values[i].hists != pair->hists)
-- 
2.43.0



