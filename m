Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2B9267F4F;
	Tue,  8 Apr 2025 11:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111612; cv=none; b=WXYWwyAcJUNSh0eaK2lueY41MP9kV9yuVPuRKzHBJLZ7GndYRZatcKqONjf9WalKskEQjS4FI/+rxZvsK5xrV7KdctNFJfwR1IP2M4Pnt/SriDs7LM3/XQB5zdKF8TH8IQCcNTr0Fa17oqyaWbykXEEnnAfXSnI3G1NYDQbjNq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111612; c=relaxed/simple;
	bh=BGOah1WY0M+CYz61+AbaLKSlDMnJSN8dZCDQEZPdtDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRPspz7+NEIaRWJcVqb/ULU1cLZ+aMFWWx2b1P2HVse+wn/LL5CSafWmuJfpcK5xnIsUhyFKApOga/gMkUORYGK4c92B2c5g3XsTHOnnNAKHaUWT0nyPXHGDsUrrsWx6pvYAuAILLmuz5C/J23pvvmEjRGjaez38gLLLWM82FYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2Fg8+8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2Fg8+8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABA6C4CEE5;
	Tue,  8 Apr 2025 11:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111612;
	bh=BGOah1WY0M+CYz61+AbaLKSlDMnJSN8dZCDQEZPdtDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2Fg8+8DvaBpN1nYd5Hvo7ZzB/2A2SxjzIU8Dju1muR5932ROshNXIWYT90iyF8e6
	 f/Py6XH8t3hn0tqJ5xAvDk1IS1cdlNuAGCzZ2sfzZ3+hFZuIG1+QRGWlvSpwTVf3gY
	 9MO/IWzRJI/2e6JbFrtqmy4jGd/qXjtGEr9WZBNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 467/731] perf pmu: Dont double count common sysfs and json events
Date: Tue,  8 Apr 2025 12:46:04 +0200
Message-ID: <20250408104925.139946853@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index a8193ac8f2e7d..98cc525dc9ded 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -596,7 +596,7 @@ static int perf_pmu__new_alias(struct perf_pmu *pmu, const char *name,
 			};
 			if (pmu_events_table__find_event(pmu->events_table, pmu, name,
 							 update_alias, &data) == 0)
-				pmu->cpu_json_aliases++;
+				pmu->cpu_common_json_aliases++;
 		}
 		pmu->sysfs_aliases++;
 		break;
@@ -1851,9 +1851,10 @@ size_t perf_pmu__num_events(struct perf_pmu *pmu)
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
index edd36c20aedc2..deaf9c268ed13 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -136,6 +136,11 @@ struct perf_pmu {
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



