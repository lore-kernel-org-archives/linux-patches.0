Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41723AAF67;
	Sat, 17 Oct 2026 16:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255061; cv=none; b=VistD3WRv39bKFPyXlR8blG0SZKNGzVxjFlKbupcFrMQLx0JJfv4eTiE12Gf8j2h5Eeb9XM1uLT4p63W5fSNuj7hq6O+fXkB0SBecOz+Rpv6ASQE3IV9Rj4R+bh0dck+JvC4XogVx1KIujft+KhKGpLogwGfxZhKGRnC4g1fcpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255061; c=relaxed/simple;
	bh=t5LpzYpIp0VE7fcXFE2VIjGeu/m7/0/WdUEhwlhux4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cM+QPlje1jb+UIHsq9wLKtLjzGApTgGyrVqNIxU+SkO8FgzQ9n3IYOIvjUvfPLfs3UgOKNE6RGJPBP+ZDQwcEdZcHYKL1ZM2WysOxWAdaegmcEd07E1mYxbuJ7TTBhDIxRCzL7N7xjQdG8WkVYoBE1TjgdOe2Y+rI4JIKI/Nch4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Di/1iEiX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Di/1iEiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDCF1F000C4;
	Sat, 17 Oct 2026 16:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255060;
	bh=cmVN+lFtU4Yi94o/d9LoJd+sd2yibUt70U/lNVgYXG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Di/1iEiXWq7t26T40RIDg3wdaoKYhYnqMfe3pWfrGpcXOPnO2dtVJZao38eAl5tQT
	 FPeeoeM5kHmbzrYiuynUaAEa8skehhc7Fm7YHMzMQcnkGIEad2QGx4OLFvu3qC1xSY
	 0bcFAY1pEYlIgcXn7Z42pg6VSRqY4ivBVbK6jTC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 650/869] coresight: etm4x: missing cscfg_csdev_disable_active_config() in perf enable
Date: Sat, 17 Oct 2026 17:58:11 +0200
Message-ID: <20261017160053.672693810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 .../coresight/coresight-etm4x-core.c          | 46 +++++++++++--------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index e69ee4ccc2658..9127bc0255528 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -698,8 +698,7 @@ static int etm4_parse_event_config(struct coresight_device *csdev,
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
 	struct etmv4_config *config = &drvdata->config;
 	struct perf_event_attr *attr = &event->attr;
-	unsigned long cfg_hash;
-	int preset, cc_threshold;
+	int cc_threshold;
 
 	/* Clear configuration from previous run */
 	memset(config, 0, sizeof(struct etmv4_config));
@@ -774,20 +773,6 @@ static int etm4_parse_event_config(struct coresight_device *csdev,
 		/* bit[12], Return stack enable bit */
 		config->cfg |= TRCCONFIGR_RS;
 
-	/*
-	 * Set any selected configuration and preset.
-	 *
-	 * This extracts the values of PMU_FORMAT_ATTR(configid) and PMU_FORMAT_ATTR(preset)
-	 * in the perf attributes defined in coresight-etm-perf.c.
-	 * configid uses bits 63:32 of attr->config2, preset uses bits 3:0 of attr->config.
-	 * A zero configid means no configuration active, preset = 0 means no preset selected.
-	 */
-	if (attr->config2 & GENMASK_ULL(63, 32)) {
-		cfg_hash = (u32)(attr->config2 >> 32);
-		preset = attr->config & 0xF;
-		ret = cscfg_csdev_enable_active_config(csdev, cfg_hash, preset);
-	}
-
 	/* branch broadcast - enable if selected and supported */
 	if (attr->config & BIT(ETM_OPT_BRANCH_BROADCAST)) {
 		if (!drvdata->trcbb) {
@@ -810,8 +795,10 @@ static int etm4_enable_perf(struct coresight_device *csdev,
 			    struct perf_event *event,
 			    struct coresight_trace_id_map *id_map)
 {
-	int ret = 0, trace_id;
+	int ret = 0, trace_id, preset;
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	struct perf_event_attr *attr = &event->attr;
+	unsigned long cfg_hash = 0;
 
 	if (WARN_ON_ONCE(drvdata->cpu != smp_processor_id())) {
 		ret = -EINVAL;
@@ -823,6 +810,22 @@ static int etm4_enable_perf(struct coresight_device *csdev,
 	if (ret)
 		goto out;
 
+	/*
+	 * Set any selected configuration and preset.
+	 *
+	 * This extracts the values of PMU_FORMAT_ATTR(configid) and PMU_FORMAT_ATTR(preset)
+	 * in the perf attributes defined in coresight-etm-perf.c.
+	 * configid uses bits 63:32 of attr->config2, preset uses bits 3:0 of attr->config.
+	 * A zero configid means no configuration active, preset = 0 means no preset selected.
+	 */
+	if (attr->config2 & GENMASK_ULL(63, 32)) {
+		cfg_hash = (u32)(attr->config2 >> 32);
+		preset = attr->config & 0xF;
+		ret = cscfg_csdev_enable_active_config(csdev, cfg_hash, preset);
+		if (ret)
+			goto out;
+	}
+
 	/*
 	 * perf allocates cpu ids as part of _setup_aux() - device needs to use
 	 * the allocated ID. This reads the current version without allocation.
@@ -836,13 +839,20 @@ static int etm4_enable_perf(struct coresight_device *csdev,
 		dev_err(&drvdata->csdev->dev, "Failed to set trace ID for %s on CPU%d\n",
 			dev_name(&drvdata->csdev->dev), drvdata->cpu);
 		ret = -EINVAL;
-		goto out;
+		goto err_cfg;
 	}
 	drvdata->trcid = (u8)trace_id;
 
 	/* And enable it */
 	ret = etm4_enable_hw(drvdata);
+	if (ret)
+		goto err_cfg;
+
+	return 0;
 
+err_cfg:
+	if (cfg_hash)
+		cscfg_csdev_disable_active_config(csdev);
 out:
 	return ret;
 }
-- 
2.53.0



