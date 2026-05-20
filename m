Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6702701C4;
	Wed, 20 May 2026 16:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296024; cv=none; b=F8eUIn9HuT75nLyE8b4jP9C3LYg1v44jJizyR3BkULddcYgxAnXOGqI8FWW2YhmYPhWMF/695J7ZLzx3bq5x091i2MOYlKbNg+5/feZlZawW41JnmYt2rjtHQK683ijqnKof9gPTp4Gl4p2X+OAx1sf99rQUj5wH/iDZg/ezz0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296024; c=relaxed/simple;
	bh=4MccKmamZYvlABKVFj6YCe5MAn6H45bQzxi1IhUHbUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/h2mX148Qxrpmc27Y6m6f7P5nIAjiu9auDQ4p+xtWwy903xXwNoOsAe0mOaU0VEHBPvs5Z1Lv4WkgkZk07EeILK/alPsO5Ld7FiKiM4wlJiMsSsnJo7Cdx8BvKGO6bmq95o69khgN7hEw20cCRJ2XHkXMM+xYiUKew2deZpe7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNESgLlE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNESgLlE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155EB1F000E9;
	Wed, 20 May 2026 16:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296023;
	bh=VJfXwYoPU1S6nwYcQLauak7mJaCrC7EYG5rR51ePVto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNESgLlELh8h7R1KNi/K1dtHzofV6DfxhU16PdaOInJ+TLagJnX11PQwHStmqZfuQ
	 MgVNbf/2bny7/CrjkK4WXTEbMHa9QYzRwUMA6MR/CoiR/x0mVv9Ry/Z8n/YTMdTyIt
	 7S+JtVhx6EXjPm5OL8xaPkVHWLqKEdEYScWDQurk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Yaroshevskiy <dyaroshev@meta.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Ian Rogers <irogers@google.com>,
	Breno Leitao <leitao@debian.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0641/1146] perf stat: Fix crash on arm64
Date: Wed, 20 May 2026 18:14:51 +0200
Message-ID: <20260520162202.686130484@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit b5708a308a5602d4a3caf0720dce452082d443ec ]

Perf stat is crashing on arm64 hosts with the following issue:

  # make -C tools/perf DEBUG=1
  # perf stat sleep 1
  perf: util/evsel.c:2034: get_group_fd: Assertion `!(!leader->core.fd)' failed.
  [1]    1220794 IOT instruction (core dumped)  ./perf stat

The sorting function introduced by commit a745c0831c15c ("perf stat:
Sort default events/metrics") compares events based on their individual
properties. This can cause events from different groups to be
interleaved, resulting in group members appearing before their leaders
in the sorted evlist.

When the iterator opens events in list order, a group member may be
processed before its leader has been opened.

For example, CPU_CYCLES (idx=32) with leader STALL_SLOT_BACKEND (idx=37)
could be sorted before its leader, causing the crash when CPU_CYCLES
tries to get its group fd from the not-yet-opened leader.

Fix this by comparing events based on their leader's attributes instead
of their own attributes when the events are in different groups. This
ensures all members of a group share the same sort key as their leader,
keeping groups together and guaranteeing leaders are opened before their
members.

Fixes: a745c0831c15c ("perf stat: Sort default events/metrics")
Reported-by: Denis Yaroshevskiy <dyaroshev@meta.com>
Tested-by: Dmitry Ilvokhin <d@ilvokhin.com>
Tested-by: Ian Rogers <irogers@google.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2eb76d7476b7f..6a12c1068d8a0 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1917,25 +1917,33 @@ static int default_evlist_evsel_cmp(void *priv __maybe_unused,
 	const struct evsel *lhs = container_of(lhs_core, struct evsel, core);
 	const struct perf_evsel *rhs_core = container_of(r, struct perf_evsel, node);
 	const struct evsel *rhs = container_of(rhs_core, struct evsel, core);
+	const struct evsel *lhs_leader = evsel__leader(lhs);
+	const struct evsel *rhs_leader = evsel__leader(rhs);
 
-	if (evsel__leader(lhs) == evsel__leader(rhs)) {
+	if (lhs_leader == rhs_leader) {
 		/* Within the same group, respect the original order. */
 		return lhs_core->idx - rhs_core->idx;
 	}
 
+	/*
+	 * Compare using leader's attributes so that all members of a group
+	 * stay together. This ensures leaders are opened before their members.
+	 */
+
 	/* Sort default metrics evsels first, and default show events before those. */
-	if (lhs->default_metricgroup != rhs->default_metricgroup)
-		return lhs->default_metricgroup ? -1 : 1;
+	if (lhs_leader->default_metricgroup != rhs_leader->default_metricgroup)
+		return lhs_leader->default_metricgroup ? -1 : 1;
 
-	if (lhs->default_show_events != rhs->default_show_events)
-		return lhs->default_show_events ? -1 : 1;
+	if (lhs_leader->default_show_events != rhs_leader->default_show_events)
+		return lhs_leader->default_show_events ? -1 : 1;
 
 	/* Sort by PMU type (prefers legacy types first). */
-	if (lhs->pmu != rhs->pmu)
-		return lhs->pmu->type - rhs->pmu->type;
+	if (lhs_leader->pmu != rhs_leader->pmu)
+		return lhs_leader->pmu->type - rhs_leader->pmu->type;
 
-	/* Sort by name. */
-	return strcmp(evsel__name((struct evsel *)lhs), evsel__name((struct evsel *)rhs));
+	/* Sort by leader's name. */
+	return strcmp(evsel__name((struct evsel *)lhs_leader),
+		      evsel__name((struct evsel *)rhs_leader));
 }
 
 /*
-- 
2.53.0



