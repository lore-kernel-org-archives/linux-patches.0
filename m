Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4407F4CF461;
	Sat, 17 Oct 2026 18:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260070; cv=none; b=EuM2Qw4sgcVl8Q6uhB2ByQedGkdDAVj/IDVxx0/2ofZpfeyn2WkegnDdpHnRi7B1gvYxhrEMhG2pOSiiRMI42Sl1YJwn2ifmtkgE2O1wv1naO2nmCFwzztBGS99vf48pELZ/gfezPozvW6jSH6XBqd4TwsiQJfbdO0pWs1VwVnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260070; c=relaxed/simple;
	bh=ptZFWos7OXYSQgcSao4dIPVH8oxJRoYUSRlYQqaiad0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sx5XSuIzD5CZBGqW6iNkJYWykYFT0zY6wnVwIIU1UFuU66OlyGn5lA6tp8mr56r30acGEgNlQuyQpRJZWy01K0GZq4NkCkvRUNQFwRM8uUfzz4eWTfa6YBOSgTKcJUa97KPTAZliCl7jJa4keC8K+pD3Tf7eItr9crGeHSUlLw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2ihPQiE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2ihPQiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0D31F000C5;
	Sat, 17 Oct 2026 18:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260066;
	bh=xjm6rxYlE8/PsCyNECWlGEpjh6vqpezlumFzxTGOI5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2ihPQiEGlR4voUT4a6MZvq6rk7lAf+J7kVKiOne6Vb7E5aO8vamOa1nXk6cb3oVY
	 xzXIIOmCxITDbnPxa8OLFDdHAmiawmX7tIVA/++atBw3msVb2wzjOLc94acBHK+mBS
	 l84qws30YfkihdLBS8J0ReOXy6NIt8B0lePfR29k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1423/1674] coresight: etm4x: missing cscfg_csdev_disable_active_config() in perf enable
Date: Sat, 17 Oct 2026 18:01:35 +0200
Message-ID: <20261017160507.703036694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 .../coresight/coresight-etm4x-core.c          | 45 +++++++++++--------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index c740b3356422f..593dcfe4c9457 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -698,8 +698,6 @@ static int etm4_parse_event_config(struct coresight_device *csdev,
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
 	struct etmv4_config *config = &drvdata->config;
 	struct perf_event_attr *attr = &event->attr;
-	unsigned long cfg_hash;
-	int preset;
 
 	/* Clear configuration from previous run */
 	memset(config, 0, sizeof(struct etmv4_config));
@@ -769,20 +767,6 @@ static int etm4_parse_event_config(struct coresight_device *csdev,
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
@@ -804,8 +788,10 @@ static int etm4_parse_event_config(struct coresight_device *csdev,
 static int etm4_enable_perf(struct coresight_device *csdev,
 			    struct perf_event *event)
 {
-	int ret = 0, trace_id;
+	int ret = 0, trace_id, preset;
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	struct perf_event_attr *attr = &event->attr;
+	unsigned long cfg_hash = 0;
 
 	if (WARN_ON_ONCE(drvdata->cpu != smp_processor_id())) {
 		ret = -EINVAL;
@@ -817,6 +803,22 @@ static int etm4_enable_perf(struct coresight_device *csdev,
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
@@ -830,13 +832,20 @@ static int etm4_enable_perf(struct coresight_device *csdev,
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



