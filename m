Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A11354ADA;
	Tue, 16 Dec 2025 11:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885797; cv=none; b=Dtn524Wjbx/HRcrTZczVfZac69H10WFt7GxNqdzoS9NcgzcQl/1VfWA8UMH62lSPhB0C95206kMAacZjzX2hLMtmfm2ILCdpVuI4lkIMbMmaK5WPPy07x0F6j4LlDGRIAbGn9MuD0QWkBAgzoIOxLb/b40KCHECyIz4c874NkkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885797; c=relaxed/simple;
	bh=7LX2lUUXELWLiI28dMylPPuNIQ1/sa5JIDTwg6yZVBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLNxMAgVAa7pEvayTkrivObtOuP1Nn2Zhx8HIJ+hVsFnsIfTMB2pecIPIbO4QdWOk5Mbq9hN6s1QnReWkZxsJcdcK435YR3YlwXhFf6sBan99zKNew4eAQAcdZI+MB5+MWZ59M5/4cgBBiLG4pKsbJo2PRJZDU1GDM7gu/DFI4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vt2JDpNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vt2JDpNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E12C4CEF1;
	Tue, 16 Dec 2025 11:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885797;
	bh=7LX2lUUXELWLiI28dMylPPuNIQ1/sa5JIDTwg6yZVBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vt2JDpNekqO6yppXvqrsHk+CU4mocVkRR5UTiQZkinHTLLP/xs4lUeO5usBQbtYdn
	 MYgD/u02SdxOc+mvH5h1VvgaOkMqM0k3kVal9856XItcSTfPjhyCGQ6jgSzA0I7fp8
	 BashfwaeCd/lsn4ZRpVSYtj2s5xQArtvhtVzdvv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 214/507] coresight: etm3x: Always set tracers device mode on target CPU
Date: Tue, 16 Dec 2025 12:10:55 +0100
Message-ID: <20251216111353.260677489@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit ab3fde32afe6a77e5cc60f868e44e6e09424752b ]

The ETMv3 driver shares the same issue as ETMv4 regarding race
conditions when accessing the device mode.

This commit applies the same fix: ensuring that the device mode is
modified only by the target CPU to eliminate race conditions across
CPUs.

Fixes: 22fd532eaa0c ("coresight: etm3x: adding operation mode for etm_enable()")
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20251111-arm_coresight_power_management_fix-v6-3-f55553b6c8b3@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../coresight/coresight-etm3x-core.c          | 59 +++++++++++++------
 1 file changed, 40 insertions(+), 19 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm3x-core.c b/drivers/hwtracing/coresight/coresight-etm3x-core.c
index baba2245b1dfb..602648eb33ec5 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-core.c
@@ -439,13 +439,26 @@ struct etm_enable_arg {
 	int rc;
 };
 
-static void etm_enable_hw_smp_call(void *info)
+static void etm_enable_sysfs_smp_call(void *info)
 {
 	struct etm_enable_arg *arg = info;
+	struct coresight_device *csdev;
 
 	if (WARN_ON(!arg))
 		return;
+
+	csdev = arg->drvdata->csdev;
+	if (!coresight_take_mode(csdev, CS_MODE_SYSFS)) {
+		/* Someone is already using the tracer */
+		arg->rc = -EBUSY;
+		return;
+	}
+
 	arg->rc = etm_enable_hw(arg->drvdata);
+
+	/* The tracer didn't start */
+	if (arg->rc)
+		coresight_set_mode(csdev, CS_MODE_DISABLED);
 }
 
 static int etm_cpu_id(struct coresight_device *csdev)
@@ -465,16 +478,26 @@ static int etm_enable_perf(struct coresight_device *csdev,
 			   struct coresight_path *path)
 {
 	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	int ret;
 
 	if (WARN_ON_ONCE(drvdata->cpu != smp_processor_id()))
 		return -EINVAL;
 
+	if (!coresight_take_mode(csdev, CS_MODE_PERF))
+		return -EBUSY;
+
 	/* Configure the tracer based on the session's specifics */
 	etm_parse_event_config(drvdata, event);
 	drvdata->traceid = path->trace_id;
 
 	/* And enable it */
-	return etm_enable_hw(drvdata);
+	ret = etm_enable_hw(drvdata);
+
+	/* Failed to start tracer; roll back to DISABLED mode */
+	if (ret)
+		coresight_set_mode(csdev, CS_MODE_DISABLED);
+
+	return ret;
 }
 
 static int etm_enable_sysfs(struct coresight_device *csdev, struct coresight_path *path)
@@ -494,7 +517,7 @@ static int etm_enable_sysfs(struct coresight_device *csdev, struct coresight_pat
 	if (cpu_online(drvdata->cpu)) {
 		arg.drvdata = drvdata;
 		ret = smp_call_function_single(drvdata->cpu,
-					       etm_enable_hw_smp_call, &arg, 1);
+					       etm_enable_sysfs_smp_call, &arg, 1);
 		if (!ret)
 			ret = arg.rc;
 		if (!ret)
@@ -517,12 +540,6 @@ static int etm_enable(struct coresight_device *csdev, struct perf_event *event,
 		      enum cs_mode mode, struct coresight_path *path)
 {
 	int ret;
-	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-
-	if (!coresight_take_mode(csdev, mode)) {
-		/* Someone is already using the tracer */
-		return -EBUSY;
-	}
 
 	switch (mode) {
 	case CS_MODE_SYSFS:
@@ -535,17 +552,12 @@ static int etm_enable(struct coresight_device *csdev, struct perf_event *event,
 		ret = -EINVAL;
 	}
 
-	/* The tracer didn't start */
-	if (ret)
-		coresight_set_mode(drvdata->csdev, CS_MODE_DISABLED);
-
 	return ret;
 }
 
-static void etm_disable_hw(void *info)
+static void etm_disable_hw(struct etm_drvdata *drvdata)
 {
 	int i;
-	struct etm_drvdata *drvdata = info;
 	struct etm_config *config = &drvdata->config;
 	struct coresight_device *csdev = drvdata->csdev;
 
@@ -567,6 +579,15 @@ static void etm_disable_hw(void *info)
 		"cpu: %d disable smp call done\n", drvdata->cpu);
 }
 
+static void etm_disable_sysfs_smp_call(void *info)
+{
+	struct etm_drvdata *drvdata = info;
+
+	etm_disable_hw(drvdata);
+
+	coresight_set_mode(drvdata->csdev, CS_MODE_DISABLED);
+}
+
 static void etm_disable_perf(struct coresight_device *csdev)
 {
 	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
@@ -588,6 +609,8 @@ static void etm_disable_perf(struct coresight_device *csdev)
 
 	CS_LOCK(drvdata->csa.base);
 
+	coresight_set_mode(drvdata->csdev, CS_MODE_DISABLED);
+
 	/*
 	 * perf will release trace ids when _free_aux()
 	 * is called at the end of the session
@@ -612,7 +635,8 @@ static void etm_disable_sysfs(struct coresight_device *csdev)
 	 * Executing etm_disable_hw on the cpu whose ETM is being disabled
 	 * ensures that register writes occur when cpu is powered.
 	 */
-	smp_call_function_single(drvdata->cpu, etm_disable_hw, drvdata, 1);
+	smp_call_function_single(drvdata->cpu, etm_disable_sysfs_smp_call,
+				 drvdata, 1);
 
 	spin_unlock(&drvdata->spinlock);
 	cpus_read_unlock();
@@ -652,9 +676,6 @@ static void etm_disable(struct coresight_device *csdev,
 		WARN_ON_ONCE(mode);
 		return;
 	}
-
-	if (mode)
-		coresight_set_mode(csdev, CS_MODE_DISABLED);
 }
 
 static const struct coresight_ops_source etm_source_ops = {
-- 
2.51.0



