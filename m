Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5321A34A3AC;
	Tue, 16 Dec 2025 11:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885185; cv=none; b=ALBaim0yMmlIpa+k5WrhaSr1gVKspPhN1SpGYNZ1tqX0jFKzbcI3MaBs3PJZtzqKH6fEg0zSJZFl+GIVqPYJVXl7J4j9ANv8qtBJXWVUv37EAmShUonHH5g5JZeRoek5r7aYhLhZWjwy/jATgqcLU+HUACjDANLYwPH49WyxLq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885185; c=relaxed/simple;
	bh=aM6bFBwQIiF1LCEnxaaPiKib8E61dE41XWuJdLu44WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clby6ymheNP6jFRi6GK/9+v/7TIb/GWQZ2blI7XguQET3jzP/nP20BWdUaLtkElfAs6hbaAuSC8ze+FptG+Rk7J/p0uJTrz25Xtbb21AszxmUIxio75rRnVJ1/Dpuo0WNjZgq+LCIGUwczWeuVNUfMK99EZBp/9SLkwhSVRFCc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFnO3Crk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFnO3Crk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEB7C4CEF1;
	Tue, 16 Dec 2025 11:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885184;
	bh=aM6bFBwQIiF1LCEnxaaPiKib8E61dE41XWuJdLu44WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFnO3Crkc0ytEJraabZYzIi2xSa+Z7CVyCznVQMI/AURxaGvzx5exrmbn/xBRjmmk
	 k5FBT+7VAp+kXA65/Y0ahM7w6Ukny/WSJMFqHO+6QaFvj94NXWI/a+Ph7nf+jC1T+8
	 han8CM2Th+cLVta+zsy1IqHFUFmX3ag1nt/9CHVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 031/507] perf parse-events: Fix legacy cache events if event is duplicated in a PMU
Date: Tue, 16 Dec 2025 12:07:52 +0100
Message-ID: <20251216111346.665069555@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit b7b76f607a15f16031001687e733046b5f6f5d86 ]

The term list when adding an event to a PMU is expected to have the
event name for the alias lookup. Also, set found_supported so that
-EINVAL isn't returned.

Fixes: 62593394f66a ("perf parse-events: Legacy cache names on all
PMUs and lower priority")

Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 28 +++++++++++++++++++++++++++-
 tools/perf/util/parse-events.h |  3 ++-
 tools/perf/util/parse-events.y |  2 +-
 3 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 0026cff4d69e4..fbf287363d9e6 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -475,8 +475,10 @@ static int parse_events_add_pmu(struct parse_events_state *parse_state,
 
 int parse_events_add_cache(struct list_head *list, int *idx, const char *name,
 			   struct parse_events_state *parse_state,
-			   struct parse_events_terms *parsed_terms)
+			   struct parse_events_terms *parsed_terms,
+			   void *loc_)
 {
+	YYLTYPE *loc = loc_;
 	struct perf_pmu *pmu = NULL;
 	bool found_supported = false;
 	const char *config_name = get_config_name(parsed_terms);
@@ -497,12 +499,36 @@ int parse_events_add_cache(struct list_head *list, int *idx, const char *name,
 			 * The PMU has the event so add as not a legacy cache
 			 * event.
 			 */
+			struct parse_events_terms temp_terms;
+			struct parse_events_term *term;
+			char *config = strdup(name);
+
+			if (!config)
+				goto out_err;
+
+			parse_events_terms__init(&temp_terms);
+			if (!parsed_terms)
+				parsed_terms = &temp_terms;
+
+			if (parse_events_term__num(&term,
+						    PARSE_EVENTS__TERM_TYPE_USER,
+						    config, /*num=*/1, /*novalue=*/true,
+						    loc, /*loc_val=*/NULL) < 0) {
+				zfree(&config);
+				goto out_err;
+			}
+			list_add(&term->list, &parsed_terms->terms);
+
 			ret = parse_events_add_pmu(parse_state, list, pmu,
 						   parsed_terms,
 						   first_wildcard_match,
 						   /*alternate_hw_config=*/PERF_COUNT_HW_MAX);
+			list_del_init(&term->list);
+			parse_events_term__delete(term);
+			parse_events_terms__exit(&temp_terms);
 			if (ret)
 				goto out_err;
+			found_supported = true;
 			if (first_wildcard_match == NULL)
 				first_wildcard_match =
 					container_of(list->prev, struct evsel, core.node);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 62dc7202e3bad..c498d896badfd 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -235,7 +235,8 @@ int parse_events_add_numeric(struct parse_events_state *parse_state,
 			     bool wildcard);
 int parse_events_add_cache(struct list_head *list, int *idx, const char *name,
 			   struct parse_events_state *parse_state,
-			   struct parse_events_terms *parsed_terms);
+			   struct parse_events_terms *parsed_terms,
+			   void *loc);
 int parse_events__decode_legacy_cache(const char *name, int pmu_type, __u64 *config);
 int parse_events_add_breakpoint(struct parse_events_state *parse_state,
 				struct list_head *list,
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index a2361c0040d75..ced26c549c33a 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -353,7 +353,7 @@ PE_LEGACY_CACHE opt_event_config
 	if (!list)
 		YYNOMEM;
 
-	err = parse_events_add_cache(list, &parse_state->idx, $1, parse_state, $2);
+	err = parse_events_add_cache(list, &parse_state->idx, $1, parse_state, $2, &@1);
 
 	parse_events_terms__delete($2);
 	free($1);
-- 
2.51.0



