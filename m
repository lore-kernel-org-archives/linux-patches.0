Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA48420468;
	Sat, 12 Sep 2026 08:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202406; cv=none; b=MRmAWhcr9K0WSpZkW4lNDvEJbweFDcvLMJ7fi52C+C9XobyedNQ30a/+wBxqoUuNa0ezWJIoBNsjMn9lM5GamhGAJe32Aop1uvsbQf6W5+1G5Z5DkqHrOL46rtOYfhsuw8RQ/RJ6CpJs9lCbFucyKPZr+UsmjECrEJCxREZJCNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202406; c=relaxed/simple;
	bh=snw4HPvMC9Qakb9RV6WeEdjAruxqWfWm5xw+YsXXrWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvy+ORwR2VOX5WhLyqmeEnVKztUia0F/SJfb/ud2JsBuaTdCIOL9oq+yYHIatCzqCZiXechR0zanJy8VCbVb8Q6YEOGkXwkoXWeWsEFqyY6Lc4UgUqnBqw113LU1Twpndtn74LOhGuq3W8/mUbrpxui4j2gfy88tb1g4J5UZ9nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oM1+tgRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oM1+tgRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566EC1F000FF;
	Sat, 12 Sep 2026 08:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202405;
	bh=A3Z4yATLwGeYZvBIB/XtbRrrhpwdkz6oY0Mv2MZ1mbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oM1+tgRzlFgTxR9WXQvO+aqt8SBkzlc7oSfN4lG0wEzvF4si3HHMcj9PqWsaCdBpH
	 VXm1UUOZn445CJeL/nOiNcdcOT4eiWXgCO5cBgNWszITLiXC/9kVNjY877AgdhLoJA
	 rMI2nwdhCnMqLIz9OHO5cAiLcKBNuT45N+CRStl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1197/1815] coresight: etm4x: missing cscfg_csdev_disable_active_config() in perf enable
Date: Sat, 12 Sep 2026 08:49:07 +0200
Message-ID: <20260912065717.114709878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 0a47f0be6557b4a851addd430383a4dc7ee08752 ]

In the perf enable path, there are missing cases where
cscfg_csdev_disable_active_config() is not called:

  - Branch broadcast is selected but not supported by the hardware
  - etm4_enable_hw() fails

This can lead to a leak of config_desc->active_cnt.
Fix this by properly calling cscfg_csdev_disable_active_config()
in these error paths.

Fixes: 810ac401db1f ("coresight: etm4x: Add complex configuration handlers to etmv4")
Suggested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260725113645.57519-6-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../coresight/coresight-etm4x-core.c          | 44 +++++++++++--------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 8363c55b3952a..2247ad55d4442 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -757,8 +757,7 @@ static int etm4_parse_event_config(struct coresight_device *csdev,
 		.ATTR_CFG_FLD_timestamp_CFG = U64_MAX,
 	};
 	struct perf_event_attr *attr = &event->attr;
-	unsigned long cfg_hash;
-	int preset, cc_threshold;
+	int cc_threshold;
 	u8 ts_level;
 
 	/* Clear configuration from previous run */
@@ -844,16 +843,6 @@ static int etm4_parse_event_config(struct coresight_device *csdev,
 		/* bit[12], Return stack enable bit */
 		config->cfg |= TRCCONFIGR_RS;
 
-	/*
-	 * Set any selected configuration and preset. A zero configid means no
-	 * configuration active, preset = 0 means no preset selected.
-	 */
-	cfg_hash = ATTR_CFG_GET_FLD(attr, configid);
-	if (cfg_hash) {
-		preset = ATTR_CFG_GET_FLD(attr, preset);
-		ret = cscfg_csdev_enable_active_config(csdev, cfg_hash, preset);
-	}
-
 	/* branch broadcast - enable if selected and supported */
 	if (ATTR_CFG_GET_FLD(attr, branch_broadcast)) {
 		if (!drvdata->trcbb) {
@@ -877,7 +866,9 @@ static int etm4_enable_perf(struct coresight_device *csdev,
 			    struct coresight_path *path)
 {
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-	int ret;
+	struct perf_event_attr *attr = &event->attr;
+	unsigned long cfg_hash;
+	int ret, preset;
 
 	if (WARN_ON_ONCE(drvdata->cpu != smp_processor_id()))
 		return -EINVAL;
@@ -888,7 +879,19 @@ static int etm4_enable_perf(struct coresight_device *csdev,
 	/* Configure the tracer based on the session's specifics */
 	ret = etm4_parse_event_config(csdev, event);
 	if (ret)
-		goto out;
+		goto err;
+
+	/*
+	 * Set any selected configuration and preset. A zero configid means no
+	 * configuration active, preset = 0 means no preset selected.
+	 */
+	cfg_hash = ATTR_CFG_GET_FLD(attr, configid);
+	if (cfg_hash) {
+		preset = ATTR_CFG_GET_FLD(attr, preset);
+		ret = cscfg_csdev_enable_active_config(csdev, cfg_hash, preset);
+		if (ret)
+			goto err;
+	}
 
 	drvdata->trcid = path->trace_id;
 
@@ -897,16 +900,19 @@ static int etm4_enable_perf(struct coresight_device *csdev,
 
 	/* And enable it */
 	ret = etm4_enable_hw(drvdata);
-
-out:
-	/* Failed to start tracer; roll back to DISABLED mode */
 	if (ret) {
-		coresight_set_mode(csdev, CS_MODE_DISABLED);
-		return ret;
+		if (cfg_hash)
+			cscfg_csdev_disable_active_config(csdev);
+		goto err;
 	}
 
 	csdev->path = path;
 	return 0;
+
+err:
+	/* Failed to start tracer; roll back to DISABLED mode */
+	coresight_set_mode(csdev, CS_MODE_DISABLED);
+	return ret;
 }
 
 static int etm4_enable_sysfs(struct coresight_device *csdev, struct coresight_path *path)
-- 
2.53.0



