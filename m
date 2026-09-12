Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB4623BD03;
	Sat, 12 Sep 2026 12:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215273; cv=none; b=tPGvskfSubJi/wsBaw1MhBQ/hEhcWhL6Pv8PvMOXmX8m3APcuYDxxFnNP1SridNVnS7dMQxjekKZk44Nwtd2xUfsocw/7rGC4aeS7+Zbl8BJPvoYJswrzfsdSiKaYAlgkhgIwZzm3K6JYkzNr2B4gxMPSsDyE1as8GqHmNdbA+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215273; c=relaxed/simple;
	bh=5n0+l5WDqMGizGgWAAyBaITF58TcQryKCNgT4kBV6So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bo3/BFln86cHd5355HsdAPjdDSVIwS269kpN7u5Dox4/14N6eTy+wXgoPlHGt7s/jQdbBB487u//KwFhM4Fn385b96OZKeO+FnmCo6Or7/CZ3kWQe2grpOLXEKATczQMRsu4f3TakWiw81y49PnaBZtjhUzd4b1rPLcNhFxrkRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYHS+9CD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYHS+9CD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13AE1F000FF;
	Sat, 12 Sep 2026 12:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215269;
	bh=iEQlOQDZjVWBRk+jcHrXDEnnSCkTNKIzt38AYZueG1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IYHS+9CDig5btbuGq/8OqGNjeVu6Ug649PEHlSq9vV23KoKu3k5V6I5jMGAubvHjE
	 NC0kJFQBQzQwuwU8aDu3hB6Ij+B9Dy2ZmjoJho+jGTOSQglZ8miJsNI91iI4eAS9T4
	 heYP78LDGJm7hnRhEbFJp8o61DJ8Xa7AEPBs9Vtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Peng <pengyu@kylinos.cn>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0496/1376] perf metricgroup: Fix metric expression copy leaks
Date: Sat, 12 Sep 2026 08:48:42 +0200
Message-ID: <20260912065618.593536365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4dff3e925a47b..6d6bfcebb97a8 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -1814,8 +1814,10 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
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
@@ -1827,6 +1829,7 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 				alloc_size = sizeof(*new_expr->metric_refs);
 				new_expr->metric_refs = calloc(nr + 1, alloc_size);
 				if (!new_expr->metric_refs) {
+					zfree(&new_expr->metric_name);
 					free(new_expr);
 					return -ENOMEM;
 				}
@@ -1843,6 +1846,7 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 			alloc_size = sizeof(*new_expr->metric_events);
 			new_expr->metric_events = calloc(nr + 1, alloc_size);
 			if (!new_expr->metric_events) {
+				zfree(&new_expr->metric_name);
 				zfree(&new_expr->metric_refs);
 				free(new_expr);
 				return -ENOMEM;
@@ -1853,6 +1857,7 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 				evsel = old_expr->metric_events[idx];
 				evsel = evlist__find_evsel(evlist, evsel->core.idx);
 				if (evsel == NULL) {
+					zfree(&new_expr->metric_name);
 					zfree(&new_expr->metric_events);
 					zfree(&new_expr->metric_refs);
 					free(new_expr);
-- 
2.53.0



