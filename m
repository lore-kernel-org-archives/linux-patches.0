Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CCB39BFFE;
	Tue, 21 Jul 2026 18:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660131; cv=none; b=lmIdCPW6yiqCu3J8XqUcZFKlTiNfm3p1Q/0G/OV14ArKmPbwycOUhkcMXmEMcd6ftjMeT2i1aavyKTk0NknlUM+PGdVLo1qvqfNvmlJ64/swk60ky4g0iM1VkOYqSyPqPcuAFF5Fii7E32OprSBzyk3T5nrsV+6feef5iNCoA7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660131; c=relaxed/simple;
	bh=wCdHnr2gAWJA+KSZUYjz9+UluXRXJGAgQh6tugOxfeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9LAaZlUCnmbhOh/Pjhj7EUJ8Eo6lOGZdiD2NTSaWkdBft/4jc+6WgnZUWLKlhukq/GmQ/gZLpshjAMHUoSxxH9qhxdfj717b5Qf+LbsGV0vy0N39W+tEzsT26F0bSun4bNxfTW667gjZ2PgUc8TDeMAheAZtrNYGudvEdIpb3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1c9yb/J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1c9yb/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4361F000E9;
	Tue, 21 Jul 2026 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660129;
	bh=dshvf6jGDVsSI3V90bHa/nHe3aapRpoaHzk+CHNovLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P1c9yb/J9dThRGQExGb4htLLZyEK3aahkJZyBACkDbdIntrwUMKCr4EtBchPvG6D1
	 Zhoaaudl3jm01c3A9uwWXLQkcMNUTAqTS8tKAOrW98/mIBWOaYuJQNZtOAiNPQXj6a
	 AeK6bZz7gGUHSabBFlv2GrqCmllnrgpRfUWEfmxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Richard Cheng <icheng@nvidia.com>,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0862/2077] coresight: fix missing error code when trace ID is invalid
Date: Tue, 21 Jul 2026 17:08:55 +0200
Message-ID: <20260721152613.124638741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Gan <jie.gan@oss.qualcomm.com>

[ Upstream commit f4526ffee6ff9f5845b430957417149eded74bf3 ]

When coresight_path_assign_trace_id() cannot assign a valid trace ID,
coresight_enable_sysfs() takes the err_path goto with ret still 0,
returning success to the caller despite no trace session being started.

Change coresight_path_assign_trace_id() to return int, moving the
IS_VALID_CS_TRACE_ID() check inside it so it returns -EINVAL on failure
and 0 on success. Update both callers to propagate this return value
directly instead of inspecting path->trace_id after the call.

Fixes: d87d76d823d1 ("Coresight: Allocate trace ID after building the path")
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Signed-off-by: Jie Gan <jie.gan@oss.qualcomm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260512-fix-trace-id-error-v4-1-eb3de789767a@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-core.c  | 23 +++++++++++--------
 .../hwtracing/coresight/coresight-etm-perf.c  |  5 ++--
 drivers/hwtracing/coresight/coresight-priv.h  |  2 +-
 drivers/hwtracing/coresight/coresight-sysfs.c |  4 ++--
 4 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-core.c b/drivers/hwtracing/coresight/coresight-core.c
index 46f247f73cf64a..2105bb8139407b 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -739,8 +739,8 @@ static int coresight_get_trace_id(struct coresight_device *csdev,
  * Call this after creating the path and before enabling it. This leaves
  * the trace ID set on the path, or it remains 0 if it couldn't be assigned.
  */
-void coresight_path_assign_trace_id(struct coresight_path *path,
-				    enum cs_mode mode)
+int coresight_path_assign_trace_id(struct coresight_path *path,
+				   enum cs_mode mode)
 {
 	struct coresight_device *sink = coresight_get_sink(path);
 	struct coresight_node *nd;
@@ -750,15 +750,18 @@ void coresight_path_assign_trace_id(struct coresight_path *path,
 		/* Assign a trace ID to the path for the first device that wants to do it */
 		trace_id = coresight_get_trace_id(nd->csdev, mode, sink);
 
-		/*
-		 * 0 in this context is that it didn't want to assign so keep searching.
-		 * Non 0 is either success or fail.
-		 */
-		if (trace_id != 0) {
-			path->trace_id = trace_id;
-			return;
-		}
+		/* 0 means the device has no ID assignment, so keep searching */
+		if (trace_id == 0)
+			continue;
+
+		if (!IS_VALID_CS_TRACE_ID(trace_id))
+			return -EINVAL;
+
+		path->trace_id = trace_id;
+		return 0;
 	}
+
+	return -EINVAL;
 }
 
 /**
diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index f85dedf89a3f9e..89ba7c9a661370 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -324,6 +324,7 @@ static void *etm_setup_aux(struct perf_event *event, void **pages,
 	struct coresight_device *sink = NULL;
 	struct coresight_device *user_sink = NULL, *last_sink = NULL;
 	struct etm_event_data *event_data = NULL;
+	int ret;
 
 	event_data = alloc_event_data(cpu);
 	if (!event_data)
@@ -420,8 +421,8 @@ static void *etm_setup_aux(struct perf_event *event, void **pages,
 		}
 
 		/* ensure we can allocate a trace ID for this CPU */
-		coresight_path_assign_trace_id(path, CS_MODE_PERF);
-		if (!IS_VALID_CS_TRACE_ID(path->trace_id)) {
+		ret = coresight_path_assign_trace_id(path, CS_MODE_PERF);
+		if (ret) {
 			cpumask_clear_cpu(cpu, mask);
 			coresight_release_path(path);
 			continue;
diff --git a/drivers/hwtracing/coresight/coresight-priv.h b/drivers/hwtracing/coresight/coresight-priv.h
index 1ea882dffd703b..34c7e792adbd99 100644
--- a/drivers/hwtracing/coresight/coresight-priv.h
+++ b/drivers/hwtracing/coresight/coresight-priv.h
@@ -153,7 +153,7 @@ int coresight_make_links(struct coresight_device *orig,
 void coresight_remove_links(struct coresight_device *orig,
 			    struct coresight_connection *conn);
 u32 coresight_get_sink_id(struct coresight_device *csdev);
-void coresight_path_assign_trace_id(struct coresight_path *path,
+int coresight_path_assign_trace_id(struct coresight_path *path,
 				   enum cs_mode mode);
 
 #if IS_ENABLED(CONFIG_CORESIGHT_SOURCE_ETM3X)
diff --git a/drivers/hwtracing/coresight/coresight-sysfs.c b/drivers/hwtracing/coresight/coresight-sysfs.c
index d2a6ed8bcc74d6..b6a870399e8341 100644
--- a/drivers/hwtracing/coresight/coresight-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-sysfs.c
@@ -211,8 +211,8 @@ int coresight_enable_sysfs(struct coresight_device *csdev)
 		goto out;
 	}
 
-	coresight_path_assign_trace_id(path, CS_MODE_SYSFS);
-	if (!IS_VALID_CS_TRACE_ID(path->trace_id))
+	ret = coresight_path_assign_trace_id(path, CS_MODE_SYSFS);
+	if (ret)
 		goto err_path;
 
 	ret = coresight_enable_path(path, CS_MODE_SYSFS);
-- 
2.53.0



