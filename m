Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22977224239;
	Tue,  8 Apr 2025 12:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114848; cv=none; b=cHezzbaG1sMHiVi77qGt2t9weRUtmNw8RscL6MZ/KMeeK1DTe9DGHBuuCNYBVLhEjvM9tK4nOL2K9O+apg1RzkEyZB81FdTb8+cH4pws1TTw4kgLmVQiFXWqhBHgMwHS2uNkBe+XVTZfXujcncOmDrC4AJ/0+z6n1gTMgXojj1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114848; c=relaxed/simple;
	bh=Y/XIYi8ELtLdE+r+cKAJW5Vd5ri1fTGAzXChv/c2e44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNHCm59LEV5vLeRuG2jCdv4YB3mhe7SrgIabpkJk+I37LHyT9b5IH12BJajXaWOnNxQWN8W50r76BFpWFOuHG/LxJPDDE/WaxJLB0qAOmYKh2nJ602nFJJJZJ157hx4DICzq+3p2tWSraaXo0wUJkfovoV+h0u/sefz8Kc6W99s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIfhsL7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIfhsL7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64BDC4CEE5;
	Tue,  8 Apr 2025 12:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114848;
	bh=Y/XIYi8ELtLdE+r+cKAJW5Vd5ri1fTGAzXChv/c2e44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIfhsL7aApz57dX9MU0qdkUxraxZWhtFdngnTD4cvSIsXyqt0kWGFv36cTKUimKOc
	 w7WMLfmu/+fub5u0r2DMzapwOSCPL0CU5qIrqJosVsIwvB+GJclz2bT2Y8D1a7fwjd
	 Srzw/d6wrsUmv/xsNWx4boTEKBGAobvR9HE0zv18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 217/499] perf pmu: Dont double count common sysfs and json events
Date: Tue,  8 Apr 2025 12:47:09 +0200
Message-ID: <20250408104856.620095242@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index d217678631ff5..d9a9fa7d49ec3 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -595,7 +595,7 @@ static int perf_pmu__new_alias(struct perf_pmu *pmu, const char *name,
 			};
 			if (pmu_events_table__find_event(pmu->events_table, pmu, name,
 							 update_alias, &data) == 0)
-				pmu->cpu_json_aliases++;
+				pmu->cpu_common_json_aliases++;
 		}
 		pmu->sysfs_aliases++;
 		break;
@@ -1840,9 +1840,10 @@ size_t perf_pmu__num_events(struct perf_pmu *pmu)
 	if (pmu->cpu_aliases_added)
 		 nr += pmu->cpu_json_aliases;
 	else if (pmu->events_table)
-		nr += pmu_events_table__num_events(pmu->events_table, pmu) - pmu->cpu_json_aliases;
+		nr += pmu_events_table__num_events(pmu->events_table, pmu) -
+			pmu->cpu_common_json_aliases;
 	else
-		assert(pmu->cpu_json_aliases == 0);
+		assert(pmu->cpu_json_aliases == 0 && pmu->cpu_common_json_aliases == 0);
 
 	if (perf_pmu__is_tool(pmu))
 		nr -= tool_pmu__num_skip_events();
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index dbed6c243a5ef..55005cc3caffc 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -134,6 +134,11 @@ struct perf_pmu {
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



