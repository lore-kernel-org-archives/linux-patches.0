Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83210267B10;
	Tue,  8 Apr 2025 11:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111714; cv=none; b=KROHX26nNirlk0viJs1CFXVbeV4hXwXyPIwwTpwwtKb5CKPhR+XxuTLUOLh6PQ3/Wz9XOor+gu4/URxVoYJq8vpJ7Ts/N9xWRoWCnksaYYEpBuTv3SDKYageMhtO7/N03frnPkQoFNJn0+gTJ1yLu7P/88VS/gZ2EjUx0UQcdis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111714; c=relaxed/simple;
	bh=pqkPk6WPkV5CdDFgT/Z/dwAIFBXb+qq0Ub/X3W7Sch8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTyU29t54bMjPPeMqTo2GXVKSNyyB3NkxLGNyyaJ7NctmYdYmnMJli/axZ+46NHD7JA6La9TlB7motM/ERsQNukbCwdG2Hi83PLAUj6X+wJBmjn3NQeifH3ABmD1S8LE1c/ql8jpRcAJJQfEnxn0zgMbNV3PbH3LowZya7EQj50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLH8l9r5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLH8l9r5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D8EC4CEE5;
	Tue,  8 Apr 2025 11:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111714;
	bh=pqkPk6WPkV5CdDFgT/Z/dwAIFBXb+qq0Ub/X3W7Sch8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLH8l9r5zj6U1ktE1qWdE+TMmeJvhmVtpv/+arzMc09PtTTBfD8W61gvP+FWbSvOf
	 W7oB0m6Ssf3ReyIBeNQwHaZHyAMcn/8fLwRmHNlYyAwey4e8cv4t/s9jzRf9g/RQfY
	 BTZJ3m0yyHaypjmMmQc1Y5TJ/sYkf60TS7+wbRdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 532/731] perf pmu: Handle memory failure in tool_pmu__new()
Date: Tue,  8 Apr 2025 12:47:09 +0200
Message-ID: <20250408104926.649538270@linuxfoundation.org>
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

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 431db90a7303cb394c5a881b4479946f64052727 ]

On linux-next
commit 72c6f57a4193 ("perf pmu: Dynamically allocate tool PMU")
allocated PMU named "tool" dynamicly. However that allocation
can fail and a NULL pointer is returned. That case is currently
not handled and would result in an invalid address reference.
Add a check for NULL pointer.

Fixes: 72c6f57a4193 ("perf pmu: Dynamically allocate tool PMU")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Link: https://lore.kernel.org/r/20250319122820.2898333-1-tmricht@linux.ibm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmus.c     | 3 ++-
 tools/perf/util/tool_pmu.c | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/pmus.c b/tools/perf/util/pmus.c
index 6498021acef01..7959af59908c2 100644
--- a/tools/perf/util/pmus.c
+++ b/tools/perf/util/pmus.c
@@ -269,7 +269,8 @@ static void pmu_read_sysfs(unsigned int to_read_types)
 	if ((to_read_types & PERF_TOOL_PMU_TYPE_TOOL_MASK) != 0 &&
 	    (read_pmu_types & PERF_TOOL_PMU_TYPE_TOOL_MASK) == 0) {
 		tool_pmu = tool_pmu__new();
-		list_add_tail(&tool_pmu->list, &other_pmus);
+		if (tool_pmu)
+			list_add_tail(&tool_pmu->list, &other_pmus);
 	}
 	if ((to_read_types & PERF_TOOL_PMU_TYPE_HWMON_MASK) != 0 &&
 	    (read_pmu_types & PERF_TOOL_PMU_TYPE_HWMON_MASK) == 0)
diff --git a/tools/perf/util/tool_pmu.c b/tools/perf/util/tool_pmu.c
index 9156745ea180d..d43d6cf6e4a20 100644
--- a/tools/perf/util/tool_pmu.c
+++ b/tools/perf/util/tool_pmu.c
@@ -494,12 +494,20 @@ struct perf_pmu *tool_pmu__new(void)
 {
 	struct perf_pmu *tool = zalloc(sizeof(struct perf_pmu));
 
+	if (!tool)
+		goto out;
 	tool->name = strdup("tool");
+	if (!tool->name) {
+		zfree(&tool);
+		goto out;
+	}
+
 	tool->type = PERF_PMU_TYPE_TOOL;
 	INIT_LIST_HEAD(&tool->aliases);
 	INIT_LIST_HEAD(&tool->caps);
 	INIT_LIST_HEAD(&tool->format);
 	tool->events_table = find_core_events_table("common", "common");
 
+out:
 	return tool;
 }
-- 
2.39.5



