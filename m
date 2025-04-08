Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77EB22257E;
	Tue,  8 Apr 2025 11:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113348; cv=none; b=fwr+eUMl19YGnIHfwu7TRjK1B76US0ufSRT0CvrMMr6mZ/cR8nHRfu+ESlV8QtBfMNnyrvTAWty7LNHnvv75KyJ2MalKXdekOtm07/y/2xHtkBUZZujLes7ATflAQJ320cCmKKArkxjHSM9bpTq8/ubFnmWsnGlifsG+rPhmMSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113348; c=relaxed/simple;
	bh=LPvGWfY93q9LbEgMKO5QXleBSmTgVcgk6pnGeFZun8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvL7gD1cvEMxBYkBwdF6SpvueSjHKfJ3XxPOHyzs0Dwuz4a1oBczCYD5BWRh9wW1aGBEy7WnmcPJ82jlAQn9SwJ9DapXtXfZUZoOXR+kkH0gmYkY6mNmBUa9MgABOMpAfqUc5EJbvVzTY34FI0/wlGZsbkJtOEGysFViNyNCVsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8Exj7hJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8Exj7hJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F554C4CEE5;
	Tue,  8 Apr 2025 11:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113348;
	bh=LPvGWfY93q9LbEgMKO5QXleBSmTgVcgk6pnGeFZun8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8Exj7hJfUOtgF5PLz7Lfn8074qntehQavCOCc5ADtJR1BVCwVag9v3MFBZbvGIzc
	 5LHeQMDYMO419NbXyVQbxyyHog+lFLfZtF2EFQIdOry8zzAsFZCZjF3lngWD/Hdoww
	 XRw48gRBTUwwibsFq0HYZs5TyO5MjtAlzr5e19qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/268] perf pmu: Dont double count common sysfs and json events
Date: Tue,  8 Apr 2025 12:48:40 +0200
Message-ID: <20250408104831.440296395@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit c9d699e10fa6c0cdabcddcf991e7ff42af6b2503 ]

After pmu_add_cpu_aliases() is called, perf_pmu__num_events() returns an
incorrect value that double counts common events and doesn't match the
actual count of events in the alias list. This is because after
'cpu_aliases_added == true', the number of events returned is
'sysfs_aliases + cpu_json_aliases'. But when adding 'case
EVENT_SRC_SYSFS' events, 'sysfs_aliases' and 'cpu_json_aliases' are both
incremented together, failing to account that these ones overlap and
only add a single item to the list. Fix it by adding another counter for
overlapping events which doesn't influence 'cpu_json_aliases'.

There doesn't seem to be a current issue because it's used in perf list
before pmu_add_cpu_aliases() so the correct value is returned. Other
uses in tests may also miss it for other reasons like only looking at
uncore events. However it's marked as a fixes commit in case any new fix
with new uses of perf_pmu__num_events() is backported.

Fixes: d9c5f5f94c2d ("perf pmu: Count sys and cpuid JSON events separately")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Link: https://lore.kernel.org/r/20250226104111.564443-3-james.clark@linaro.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmu.c | 7 ++++---
 tools/perf/util/pmu.h | 5 +++++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 27393e4327922..2587c4b463fa8 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -597,7 +597,7 @@ static int perf_pmu__new_alias(struct perf_pmu *pmu, const char *name,
 			};
 			if (pmu_events_table__find_event(pmu->events_table, pmu, name,
 							 update_alias, &data) == 0)
-				pmu->cpu_json_aliases++;
+				pmu->cpu_common_json_aliases++;
 		}
 		pmu->sysfs_aliases++;
 		break;
@@ -1680,9 +1680,10 @@ size_t perf_pmu__num_events(struct perf_pmu *pmu)
 	if (pmu->cpu_aliases_added)
 		 nr += pmu->cpu_json_aliases;
 	else if (pmu->events_table)
-		nr += pmu_events_table__num_events(pmu->events_table, pmu) - pmu->cpu_json_aliases;
+		nr += pmu_events_table__num_events(pmu->events_table, pmu) -
+			pmu->cpu_common_json_aliases;
 	else
-		assert(pmu->cpu_json_aliases == 0);
+		assert(pmu->cpu_json_aliases == 0 && pmu->cpu_common_json_aliases == 0);
 
 	return pmu->selectable ? nr + 1 : nr;
 }
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index aca4238f06a65..5a03c361cb04c 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -124,6 +124,11 @@ struct perf_pmu {
 	uint32_t cpu_json_aliases;
 	/** @sys_json_aliases: Number of json event aliases loaded matching the PMU's identifier. */
 	uint32_t sys_json_aliases;
+	/**
+	 * @cpu_common_json_aliases: Number of json events that overlapped with sysfs when
+	 * loading all sysfs events.
+	 */
+	uint32_t cpu_common_json_aliases;
 	/** @sysfs_aliases_loaded: Are sysfs aliases loaded from disk? */
 	bool sysfs_aliases_loaded;
 	/**
-- 
2.39.5



