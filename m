Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08272331EC0;
	Sat, 12 Sep 2026 14:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223081; cv=none; b=DmuRHjMQEPDjkzZhISpsqesCpyPUC+CQ1Ry+bgIzavxBQNolrgZCPzvY7scvCWM7WIxZyjjN1GgYcguC7Wib0c3G8twjOxxVYsyPMptRRYNoZfIk5mxfhql3QU+5x5KVT96/Q0lyRPKcFAZKClOkeevBWbtCWqhNRbGQCtm0zeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223081; c=relaxed/simple;
	bh=61v1Rzt+C77evHNxw17XdxktrQ70CYfxJ0upKYRr0Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmtN0z3Fm064t4GzRU06DZGhOcnWr647dqH/ZtUv1lrudB06XOAusUgHNK2oExW8iB8FVOeHl3XhJNz5f5YszSsARNm+3szegKGQNlF3kJv56eu1vmtPhywjRoACYM1wSH+eZG2DJDl/Y2C3Roqkoq+p3iqgw/DTa8KCfPcj5vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1x6z6sBX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1x6z6sBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D675B1F000FF;
	Sat, 12 Sep 2026 14:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223078;
	bh=CA6Cp3rSncEKsCQjuhuPudHs0ifSl3EocbQqnupXUQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1x6z6sBXk9mgDTYP7WKMAQg63GGs44AVOnSnAZ9p/E0FuMNc0ggoPt3anqqTe7pJ7
	 CWERUEuCIT6/W6NZp4M+oxjrJK95b5YR/WC/Upkul7Qx2D6nAv+7JdDAd6zA1WMIcW
	 UIYWwpHvsLIY+YPphvm1kBL65dRGo8Pk+i1103Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Peng <pengyu@kylinos.cn>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0714/1424] perf metricgroup: Fix metric expression copy leaks
Date: Sat, 12 Sep 2026 08:52:26 +0200
Message-ID: <20260912065623.285210774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bb5faaa25d510..3846a39decff9 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -1810,8 +1810,10 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
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
@@ -1823,6 +1825,7 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 				alloc_size = sizeof(*new_expr->metric_refs);
 				new_expr->metric_refs = calloc(nr + 1, alloc_size);
 				if (!new_expr->metric_refs) {
+					zfree(&new_expr->metric_name);
 					free(new_expr);
 					return -ENOMEM;
 				}
@@ -1839,6 +1842,7 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 			alloc_size = sizeof(*new_expr->metric_events);
 			new_expr->metric_events = calloc(nr + 1, alloc_size);
 			if (!new_expr->metric_events) {
+				zfree(&new_expr->metric_name);
 				zfree(&new_expr->metric_refs);
 				free(new_expr);
 				return -ENOMEM;
@@ -1849,6 +1853,7 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 				evsel = old_expr->metric_events[idx];
 				evsel = evlist__find_evsel(evlist, evsel->core.idx);
 				if (evsel == NULL) {
+					zfree(&new_expr->metric_name);
 					zfree(&new_expr->metric_events);
 					zfree(&new_expr->metric_refs);
 					free(new_expr);
-- 
2.53.0



