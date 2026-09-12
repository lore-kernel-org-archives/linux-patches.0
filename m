Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB93425CF0;
	Sat, 12 Sep 2026 10:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207231; cv=none; b=IVpwjTte+W8XjY6ej8cOgLOuJeM7S971R4Q4ndxTl9L9Tt56m2ebzfYyoKKsoNFHSfFX0hqdrGRqjZ8yAEVSzkNo1TXUWs9Z3wR+9V7RHhaKem0PV6C1awk+Pw4vDzHkQ1kKjaejn9myS/HzAZDrO+6I3Bi7NfIu5tg5EBzc8Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207231; c=relaxed/simple;
	bh=QW9Wjg2+BaD27xQsbloWGpp7riZqoYMoiJjzvAt5yEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrr1VsjRBBvahipynVNsUAsT/Q/ZF/17Z/36nF2hZSa5uH4R4VCeuyfKaeoMvCfxKcH059eJ8fedgasbIHf7ImTHqjJihfOtA7Bh0QdYkIl1Z/biwoseCcQE4vOYeouQNUlJq0lHnxln5e3XfyBuIAmRt4L9Q9RSI/J5ceqfzQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vq6NGxUt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vq6NGxUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88441F000FF;
	Sat, 12 Sep 2026 10:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207230;
	bh=u7a6L73A9al6LVxZW4JIjiLHYqxNPwC3JLepN/PkTEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vq6NGxUtVArm6v7dYBpGuo+m4G3cK11r6OL8b+bV7tG0EnpoXwWAC+nzN6Ajh04aL
	 fJ683/A+/U2rVVD3yeDEHb0xew9DC0MvsSBIkqnkPDHwuXpSS2T9p9aMuJOJpwS6HQ
	 uda6YEwrESse2FO+e/Z4q39079J1mw+YF7b2bVWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Peng <pengyu@kylinos.cn>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0327/1518] perf metricgroup: Fix metric expression copy leaks
Date: Sat, 12 Sep 2026 08:41:36 +0200
Message-ID: <20260912065630.869511818@linuxfoundation.org>
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

From: Yu Peng <pengyu@kylinos.cn>

[ Upstream commit ef3af1df4f3372bd8ad47619452a283048b3bc8d ]

metricgroup__copy_metric_events() allocates a new metric expression and
duplicates metric_name before linking the expression into the destination
metric event.

Free new_expr when strdup() fails, and free the duplicated metric_name on
the later error paths.

Fixes: b85a4d61d302 ("perf metric: Allow modifiers on metrics")
Signed-off-by: Yu Peng <pengyu@kylinos.cn>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/metricgroup.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 238c3e605bfe1..bf98a01c4222d 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -1614,8 +1614,10 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 			new_expr->metric_expr = old_expr->metric_expr;
 			new_expr->metric_threshold = old_expr->metric_threshold;
 			new_expr->metric_name = strdup(old_expr->metric_name);
-			if (!new_expr->metric_name)
+			if (!new_expr->metric_name) {
+				free(new_expr);
 				return -ENOMEM;
+			}
 
 			new_expr->metric_unit = old_expr->metric_unit;
 			new_expr->runtime = old_expr->runtime;
@@ -1627,6 +1629,7 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 				alloc_size = sizeof(*new_expr->metric_refs);
 				new_expr->metric_refs = calloc(nr + 1, alloc_size);
 				if (!new_expr->metric_refs) {
+					zfree(&new_expr->metric_name);
 					free(new_expr);
 					return -ENOMEM;
 				}
@@ -1643,6 +1646,7 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 			alloc_size = sizeof(*new_expr->metric_events);
 			new_expr->metric_events = calloc(nr + 1, alloc_size);
 			if (!new_expr->metric_events) {
+				zfree(&new_expr->metric_name);
 				zfree(&new_expr->metric_refs);
 				free(new_expr);
 				return -ENOMEM;
@@ -1653,6 +1657,7 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 				evsel = old_expr->metric_events[idx];
 				evsel = evlist__find_evsel(evlist, evsel->core.idx);
 				if (evsel == NULL) {
+					zfree(&new_expr->metric_name);
 					zfree(&new_expr->metric_events);
 					zfree(&new_expr->metric_refs);
 					free(new_expr);
-- 
2.53.0



