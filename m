Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E7B47CC81;
	Sat, 12 Sep 2026 16:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229447; cv=none; b=IM+JVajuKZuPWNBQyaND2MFbniXL5L97uJVEtEo8OdF82NEXA06LuuCfxaGJ+W+Gwl2trP/Mu2RzM38J1jcuv5BGG77VkoJt0ioKdrQhq7L3XWW0JlTQ+beqoQAaEIwty1h8bSLl2cVirXtOZh0WaEaIYEH1EWI1uWGocG6XRrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229447; c=relaxed/simple;
	bh=gV6xjRQbROvEr2SUQtPnhpCP3P80iNDhiMyGkk8V9lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqOQDb22VGz4LzJ8GaShP1LxGkSbqtDLBkQOzDr1XLmhok9cPG+6vSqa9dHTXeh1de94PsGTSH4bSDY0OApIhEEAR8HLVmSCNX9/UYgxy75nfE1uNdGzv9kUPucgFBOlipELXv4lfr3IAZHFtgI9g0sKH7MTycxGwHs2RPw01BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVdSNoDM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVdSNoDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B2C1F000FF;
	Sat, 12 Sep 2026 16:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229438;
	bh=lANnLpcOsAuiuvca+muDna7OIYQ1x/rsAoAGF0iAIVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVdSNoDM1wV1fNebF39j+xX9PrqLD7ef9BcpqeZAZDhHHL/J/aNx1Hq0l182tZTXw
	 aEtfLz/ry7nbAMTDif6HDXsf8Qc4a3krhsltY+EVEBktgpT8QkEirHt4nlG/EX9vnH
	 XDCU8pZtUuAXHS0svKcpW2XcYJ/bL0YXZ7oYelow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0589/1191] perf metricgroups: Use zfree() to reduce chances of use after free
Date: Sat, 12 Sep 2026 08:55:17 +0200
Message-ID: <20260912065601.477034985@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 11ff9bcd7dfeefa6a9a9fcd4c7775b8066c46a31 ]

Do defensive programming by using zfree() to initialize freed pointers
to NULL, so that eventual use after free result in a NULL pointer deref
instead of more subtle behaviour.

This file already used zfree() in other places, so this just plugs some
leftovers.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: ef3af1df4f33 ("perf metricgroup: Fix metric expression copy leaks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/metricgroup.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 4c98ac29ee13f..c05463a91719f 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -87,9 +87,9 @@ static void metric_event_delete(struct rblist *rblist __maybe_unused,
 	struct metric_expr *expr, *tmp;
 
 	list_for_each_entry_safe(expr, tmp, &me->head, nd) {
-		free((char *)expr->metric_name);
-		free(expr->metric_refs);
-		free(expr->metric_events);
+		zfree(&expr->metric_name);
+		zfree(&expr->metric_refs);
+		zfree(&expr->metric_events);
 		free(expr);
 	}
 
@@ -184,9 +184,9 @@ static void metric__free(struct metric *m)
 	if (!m)
 		return;
 
-	free(m->metric_refs);
+	zfree(&m->metric_refs);
 	expr__ctx_free(m->pctx);
-	free((char *)m->modifier);
+	zfree(&m->modifier);
 	evlist__delete(m->evlist);
 	free(m);
 }
@@ -723,7 +723,7 @@ static int decode_all_metric_ids(struct evlist *perf_evlist, const char *modifie
 		if (strstr(ev->name, "metric-id=")) {
 			bool has_slash = false;
 
-			free(ev->name);
+			zfree(&ev->name);
 			for (cur = strchr(sb.buf, '@') ; cur; cur = strchr(++cur, '@')) {
 				*cur = '/';
 				has_slash = true;
@@ -1805,7 +1805,7 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 			alloc_size = sizeof(*new_expr->metric_events);
 			new_expr->metric_events = calloc(nr + 1, alloc_size);
 			if (!new_expr->metric_events) {
-				free(new_expr->metric_refs);
+				zfree(&new_expr->metric_refs);
 				free(new_expr);
 				return -ENOMEM;
 			}
@@ -1815,8 +1815,8 @@ int metricgroup__copy_metric_events(struct evlist *evlist, struct cgroup *cgrp,
 				evsel = old_expr->metric_events[idx];
 				evsel = evlist__find_evsel(evlist, evsel->core.idx);
 				if (evsel == NULL) {
-					free(new_expr->metric_events);
-					free(new_expr->metric_refs);
+					zfree(&new_expr->metric_events);
+					zfree(&new_expr->metric_refs);
 					free(new_expr);
 					return -EINVAL;
 				}
-- 
2.53.0



