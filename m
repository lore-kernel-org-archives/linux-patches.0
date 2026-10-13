Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7EA47604A;
	Tue, 13 Oct 2026 12:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894226; cv=none; b=f3gwwOlljeBEwHVvIKM9teZ6HC9FEPGtCIeb/u3aqSXFRyKswEz2hDg4kq+yNb3LS61w3K9p5mBEijSL4tsL2plF2mzuGRcNdSHlxhQofbOa6xWIko+hy2I70+PoDs2Sy99+xY2Dq20Wi63xFkYSxuOpvSuVNFApqLorf3gzc9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894226; c=relaxed/simple;
	bh=NddVZqHJ255AUOSdINf2KFn3nkAIJjjE6vxvCIlVXDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQ1TZyXLnqnmOFsEYfXXpls5jl8F7ucmZUC1gi9Au7yalGuGoLFxP0sgzoaAben4PKpu3zSTySrtVfKxYefYkdWe+SxntepBfihf2bN5jogkTkzNPUPPnkPRQawBd0BtoDmtIpngfqI5Oz4nOAnqvwvmhghnk0Nbge0YqgNgrYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IszcJ0LS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IszcJ0LS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477B01F000FF;
	Tue, 13 Oct 2026 12:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894224;
	bh=kgyOfTr14dQcCqQ4Bd3bWAIHOOf151GCbXekzDb+2SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IszcJ0LSadl4vRYrYGz9LBTVG2KJVjeC4652KHDdJT9qAfV9FeDzIeDy8h8SYm9MI
	 PqrPzRqYqBeFFDoUROZQp/C4+N1TRevlhFhqP/ySxnDFkprZxdhotJryiBQEHVJzCP
	 28nxen1BWKoa6isM4ZycM9jY6kabFup1uhaqI8PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 435/621] coresight: etm4x: missing cscfg_csdev_disable_active_config() in perf enable
Date: Tue, 13 Oct 2026 13:37:10 +0200
Message-ID: <20261013112931.156662859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 .../coresight/coresight-etm4x-core.c          | 51 +++++++++++--------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 522e128174467..be05ef41fd734 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -752,8 +752,7 @@ static int etm4_parse_event_config(struct coresight_device *csdev,
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
 	struct etmv4_config *config = &drvdata->config;
 	struct perf_event_attr *attr = &event->attr;
-	unsigned long cfg_hash;
-	int preset, cc_threshold;
+	int cc_threshold;
 
 	/* Clear configuration from previous run */
 	memset(config, 0, sizeof(struct etmv4_config));
@@ -834,20 +833,6 @@ static int etm4_parse_event_config(struct coresight_device *csdev,
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
@@ -871,7 +856,9 @@ static int etm4_enable_perf(struct coresight_device *csdev,
 			    struct coresight_path *path)
 {
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-	int ret;
+	struct perf_event_attr *attr = &event->attr;
+	unsigned long cfg_hash;
+	int ret, preset;
 
 	if (WARN_ON_ONCE(drvdata->cpu != smp_processor_id()))
 		return -EINVAL;
@@ -882,7 +869,23 @@ static int etm4_enable_perf(struct coresight_device *csdev,
 	/* Configure the tracer based on the session's specifics */
 	ret = etm4_parse_event_config(csdev, event);
 	if (ret)
-		goto out;
+		goto err;
+
+	/*
+	 * Set any selected configuration and preset.
+	 *
+	 * This extracts the values of PMU_FORMAT_ATTR(configid) and PMU_FORMAT_ATTR(preset)
+	 * in the perf attributes defined in coresight-etm-perf.c.
+	 * configid uses bits 63:32 of attr->config2, preset uses bits 3:0 of attr->config.
+	 * A zero configid means no configuration active, preset = 0 means no preset selected.
+	 */
+	cfg_hash = (u32)(attr->config2 >> 32);
+	if (cfg_hash) {
+		preset = attr->config & 0xF;
+		ret = cscfg_csdev_enable_active_config(csdev, cfg_hash, preset);
+		if (ret)
+			goto err;
+	}
 
 	drvdata->trcid = path->trace_id;
 
@@ -891,11 +894,17 @@ static int etm4_enable_perf(struct coresight_device *csdev,
 
 	/* And enable it */
 	ret = etm4_enable_hw(drvdata);
+	if (ret) {
+		if (cfg_hash)
+			cscfg_csdev_disable_active_config(csdev);
+		goto err;
+	}
 
-out:
+	return 0;
+
+err:
 	/* Failed to start tracer; roll back to DISABLED mode */
-	if (ret)
-		coresight_set_mode(csdev, CS_MODE_DISABLED);
+	coresight_set_mode(csdev, CS_MODE_DISABLED);
 	return ret;
 }
 
-- 
2.53.0



