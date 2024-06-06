Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BA019750E;
	Thu,  6 Jun 2024 14:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682959; cv=none; b=Mrz3ia2eSEy7rk6OBq3rFGrXLe2/GcROBMbF3Id4vLKRkGhuBqgOECFR1BuXN8NJs7L7Qwb7czQl5MWmZYfQoJYgaliXzNVTwX0gcwsehYOGMMHoOQuY9GBA14PFenjyObnue1q+ZRUBPVM+WJnO5ukIZUxdg3nY4JCzT531JFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682959; c=relaxed/simple;
	bh=5jzwJWSuD/wW9d4vwfLf6UxASSnASZa8aL1uk1QtRLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkOMy8xqhe7fW0omDJHiSFBZrfSoPhh9gyEjno+lM2LWZylArPnOSxaUzFZ3AOnGp+FNx7WrWo6ZlYissbJFP4kk9IuAGYYd5aUjVFVZW6WrSLr/HzXsc1kqKz/b9qHFpiTvQvFy1Jt/E0fmrAqE60u6lXghq0liYeCdVNp138Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPnJE651; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPnJE651"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BA5C32781;
	Thu,  6 Jun 2024 14:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682959;
	bh=5jzwJWSuD/wW9d4vwfLf6UxASSnASZa8aL1uk1QtRLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPnJE651SGwZlP2Ga4uNKMd5rfjZwvTlD/LH0Kpb8UI0nkcxZoONjDwV0jxTxI8MA
	 aNi54mk1SNOAMBUqT3PO1JwRvExab7UiIRWsFKyAEfsLADaNw/eY3WwYL+ctsPr8DS
	 8+25StkvwQluq3tQTBCrZqlK7OWkCgHRaD1oGdp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia He <justin.he@arm.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 125/374] perf pmu: Count sys and cpuid JSON events separately
Date: Thu,  6 Jun 2024 16:01:44 +0200
Message-ID: <20240606131656.090251402@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit d9c5f5f94c2d356fdf3503f7fcaf254512bc032d ]

Sys events are eagerly loaded as each event has a compat option that may
mean the event is or isn't associated with the PMU.

These shouldn't be counted as loaded_json_events as that is used for
JSON events matching the CPUID that may or may not have been loaded. The
mismatch causes issues on ARM64 that uses sys events.

Fixes: e6ff1eed3584362d ("perf pmu: Lazily add JSON events")
Closes: https://lore.kernel.org/lkml/20240510024729.1075732-1-justin.he@arm.com/
Reported-by: Jia He <justin.he@arm.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240511003601.2666907-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmu.c | 70 ++++++++++++++++++++++++++++++-------------
 tools/perf/util/pmu.h |  6 ++--
 2 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index feab54606a995..cc349d9cb0f9f 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -36,6 +36,18 @@ struct perf_pmu perf_pmu__fake = {
 
 #define UNIT_MAX_LEN	31 /* max length for event unit name */
 
+enum event_source {
+	/* An event loaded from /sys/devices/<pmu>/events. */
+	EVENT_SRC_SYSFS,
+	/* An event loaded from a CPUID matched json file. */
+	EVENT_SRC_CPU_JSON,
+	/*
+	 * An event loaded from a /sys/devices/<pmu>/identifier matched json
+	 * file.
+	 */
+	EVENT_SRC_SYS_JSON,
+};
+
 /**
  * struct perf_pmu_alias - An event either read from sysfs or builtin in
  * pmu-events.c, created by parsing the pmu-events json files.
@@ -521,7 +533,7 @@ static int update_alias(const struct pmu_event *pe,
 
 static int perf_pmu__new_alias(struct perf_pmu *pmu, const char *name,
 				const char *desc, const char *val, FILE *val_fd,
-				const struct pmu_event *pe)
+			        const struct pmu_event *pe, enum event_source src)
 {
 	struct perf_pmu_alias *alias;
 	int ret;
@@ -573,25 +585,30 @@ static int perf_pmu__new_alias(struct perf_pmu *pmu, const char *name,
 		}
 		snprintf(alias->unit, sizeof(alias->unit), "%s", unit);
 	}
-	if (!pe) {
-		/* Update an event from sysfs with json data. */
-		struct update_alias_data data = {
-			.pmu = pmu,
-			.alias = alias,
-		};
-
+	switch (src) {
+	default:
+	case EVENT_SRC_SYSFS:
 		alias->from_sysfs = true;
 		if (pmu->events_table) {
+			/* Update an event from sysfs with json data. */
+			struct update_alias_data data = {
+				.pmu = pmu,
+				.alias = alias,
+			};
 			if (pmu_events_table__find_event(pmu->events_table, pmu, name,
 							 update_alias, &data) == 0)
-				pmu->loaded_json_aliases++;
+				pmu->cpu_json_aliases++;
 		}
-	}
-
-	if (!pe)
 		pmu->sysfs_aliases++;
-	else
-		pmu->loaded_json_aliases++;
+		break;
+	case  EVENT_SRC_CPU_JSON:
+		pmu->cpu_json_aliases++;
+		break;
+	case  EVENT_SRC_SYS_JSON:
+		pmu->sys_json_aliases++;
+		break;
+
+	}
 	list_add_tail(&alias->list, &pmu->aliases);
 	return 0;
 }
@@ -667,7 +684,8 @@ static int pmu_aliases_parse(struct perf_pmu *pmu)
 		}
 
 		if (perf_pmu__new_alias(pmu, name, /*desc=*/ NULL,
-					/*val=*/ NULL, file, /*pe=*/ NULL) < 0)
+					/*val=*/ NULL, file, /*pe=*/ NULL,
+					EVENT_SRC_SYSFS) < 0)
 			pr_debug("Cannot set up %s\n", name);
 		fclose(file);
 	}
@@ -921,7 +939,8 @@ static int pmu_add_cpu_aliases_map_callback(const struct pmu_event *pe,
 {
 	struct perf_pmu *pmu = vdata;
 
-	perf_pmu__new_alias(pmu, pe->name, pe->desc, pe->event, /*val_fd=*/ NULL, pe);
+	perf_pmu__new_alias(pmu, pe->name, pe->desc, pe->event, /*val_fd=*/ NULL,
+			    pe, EVENT_SRC_CPU_JSON);
 	return 0;
 }
 
@@ -956,13 +975,14 @@ static int pmu_add_sys_aliases_iter_fn(const struct pmu_event *pe,
 		return 0;
 
 	if (pmu_uncore_alias_match(pe->pmu, pmu->name) &&
-			pmu_uncore_identifier_match(pe->compat, pmu->id)) {
+	    pmu_uncore_identifier_match(pe->compat, pmu->id)) {
 		perf_pmu__new_alias(pmu,
 				pe->name,
 				pe->desc,
 				pe->event,
 				/*val_fd=*/ NULL,
-				pe);
+				pe,
+				EVENT_SRC_SYS_JSON);
 	}
 
 	return 0;
@@ -1056,6 +1076,12 @@ struct perf_pmu *perf_pmu__lookup(struct list_head *pmus, int dirfd, const char
 	pmu->max_precise = pmu_max_precise(dirfd, pmu);
 	pmu->alias_name = pmu_find_alias_name(pmu, dirfd);
 	pmu->events_table = perf_pmu__find_events_table(pmu);
+	/*
+	 * Load the sys json events/aliases when loading the PMU as each event
+	 * may have a different compat regular expression. We therefore can't
+	 * know the number of sys json events/aliases without computing the
+	 * regular expressions for them all.
+	 */
 	pmu_add_sys_aliases(pmu);
 	list_add_tail(&pmu->list, pmus);
 
@@ -1654,12 +1680,14 @@ size_t perf_pmu__num_events(struct perf_pmu *pmu)
 	size_t nr;
 
 	pmu_aliases_parse(pmu);
-	nr = pmu->sysfs_aliases;
+	nr = pmu->sysfs_aliases + pmu->sys_json_aliases;;
 
 	if (pmu->cpu_aliases_added)
-		 nr += pmu->loaded_json_aliases;
+		 nr += pmu->cpu_json_aliases;
 	else if (pmu->events_table)
-		nr += pmu_events_table__num_events(pmu->events_table, pmu) - pmu->loaded_json_aliases;
+		nr += pmu_events_table__num_events(pmu->events_table, pmu) - pmu->cpu_json_aliases;
+	else
+		assert(pmu->cpu_json_aliases == 0);
 
 	return pmu->selectable ? nr + 1 : nr;
 }
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 2430083b151d0..77c59ebc05261 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -123,8 +123,10 @@ struct perf_pmu {
 	const struct pmu_events_table *events_table;
 	/** @sysfs_aliases: Number of sysfs aliases loaded. */
 	uint32_t sysfs_aliases;
-	/** @sysfs_aliases: Number of json event aliases loaded. */
-	uint32_t loaded_json_aliases;
+	/** @cpu_json_aliases: Number of json event aliases loaded specific to the CPUID. */
+	uint32_t cpu_json_aliases;
+	/** @sys_json_aliases: Number of json event aliases loaded matching the PMU's identifier. */
+	uint32_t sys_json_aliases;
 	/** @sysfs_aliases_loaded: Are sysfs aliases loaded from disk? */
 	bool sysfs_aliases_loaded;
 	/**
-- 
2.43.0



