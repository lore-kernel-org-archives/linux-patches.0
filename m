Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760C32594BD;
	Sat, 12 Sep 2026 16:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229452; cv=none; b=lWmPq2fTYNOelIhtvYib3V09+siNcRFG7zU7/aQvTF8sY0lUV2ZM1+EnlysGbU/RatYbWiXWRYHCuPi6b18Ew06HcrfksWqQGCLvHRTlQjvk+G3FSivi7ORMbdJt84Puws0J20eNOfFBpOigMWfsaYI/4iphZXKUTrO6Vo+2/S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229452; c=relaxed/simple;
	bh=Cbgzf09JhdO1KKHLlNLEI4hfGdkY1LLWGvZIZ69ZW9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVCdP612WWKIevhmRfOS/H6zyhJLNuFJhiiTb+3lnSi8qiqc0xstORflcSGVFnxjXy+SJGfuPaS91Bf6Ju1Tzpt/OFBddlaVJO7KFCYBdK7u0ODJqzz2vCgn85ur8t/UCn9m+qnaDncBAvlOJ1JJWnNN+yUKaHDV942TRzeq2IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFQRO4V9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFQRO4V9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0464B1F00893;
	Sat, 12 Sep 2026 16:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229444;
	bh=Kxv5yBk5Uk84ZAYuk6CEJGi+nHHtn3BYYAT5Pj/yY7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFQRO4V9MfGKwgfH75655ROtDXFAHU68GxBsQocDKwsY0G3zoRMoHsASl9Xu/586r
	 EHGtLe0zn2kX8D0zaVFD5g0Xj8+w25OxmY2U7ujv0en7EK6tK5amTYsT7QDoAXzzCQ
	 NZBurSqLMNM0uOV9jDf2WNFXNKf7L8rLSs5aFw8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Peng <pengyu@kylinos.cn>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0590/1191] perf metricgroup: Fix metric expression copy leaks
Date: Sat, 12 Sep 2026 08:55:18 +0200
Message-ID: <20260912065601.498629358@linuxfoundation.org>
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
index c05463a91719f..96c965162c78c 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -1776,8 +1776,10 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 
 			new_expr->metric_expr = old_expr->metric_expr;
 			new_expr->metric_name = strdup(old_expr->metric_name);
-			if (!new_expr->metric_name)
+			if (!new_expr->metric_name) {
+				free(new_expr);
 				return -ENOMEM;
+			}
 
 			new_expr->metric_unit = old_expr->metric_unit;
 			new_expr->runtime = old_expr->runtime;
@@ -1789,6 +1791,7 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 				alloc_size = sizeof(*new_expr->metric_refs);
 				new_expr->metric_refs = calloc(nr + 1, alloc_size);
 				if (!new_expr->metric_refs) {
+					zfree(&new_expr->metric_name);
 					free(new_expr);
 					return -ENOMEM;
 				}
@@ -1805,6 +1808,7 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 			alloc_size = sizeof(*new_expr->metric_events);
 			new_expr->metric_events = calloc(nr + 1, alloc_size);
 			if (!new_expr->metric_events) {
+				zfree(&new_expr->metric_name);
 				zfree(&new_expr->metric_refs);
 				free(new_expr);
 				return -ENOMEM;
@@ -1815,6 +1819,7 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 				evsel = old_expr->metric_events[idx];
 				evsel = evlist__find_evsel(evlist, evsel->core.idx);
 				if (evsel == NULL) {
+					zfree(&new_expr->metric_name);
 					zfree(&new_expr->metric_events);
 					zfree(&new_expr->metric_refs);
 					free(new_expr);
-- 
2.53.0



