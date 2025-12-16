Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A38033B6D5;
	Tue, 16 Dec 2025 12:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887510; cv=none; b=cOoF4UbpU7zkDI/oRYYBgU0KmLEA76s/SjDeeuTEEJ4N+rMsituM2XA2MswTextSNl7Isc7B8WQ2XlzohJjifJbwtKcdkwiYUER0NusKf/ZWLjI13fyPcOMAnrwwA3XAiE0bBmvNM6StbUAvIdDcgCqQPwou1vAflvx3hqM07ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887510; c=relaxed/simple;
	bh=f0SwDv64OGObWpgCBXiKvIo9dVAImzQnPF6dj/QeDqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkuRRTfSC9eVe7IL/0VdzImF3Z2VDOHkCUZ11bVv9FSOJrZn+M7zKlmhDSseqGYzotRv6dPWt9YGO9JLIWFZLAg477wxcu+6UtD9nae4C6kcdDba6lAlytRvDySXWO+eI3vDJHX39uSMzryvUURHFjOr6amKbsjIwE5vLQlLDu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hprEid67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hprEid67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3DCC4CEF5;
	Tue, 16 Dec 2025 12:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887510;
	bh=f0SwDv64OGObWpgCBXiKvIo9dVAImzQnPF6dj/QeDqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hprEid67AG1+lfetER5V1Fnzh/vROEqiAz4VjYuuOjqpG1WwhDgA+dIR73ymHA6Ff
	 wrD8L43Gouv6ZtNleL9sDBYRsxrqrFnR/fd+RMFtYFRwzXya+YOhPk/KI2mZxqYYj1
	 KFT1B3FUaVir9PcdJ2hUug2PX8PhR+rrfkph98M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 253/614] coresight: etm4x: Always set tracers device mode on target CPU
Date: Tue, 16 Dec 2025 12:10:20 +0100
Message-ID: <20251216111410.540896560@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 28eee2158575aea8fee7807adb9248ceaf9196f1 ]

When enabling a tracer via SysFS interface, the device mode may be set
by any CPU - not necessarily the target CPU. This can lead to race
condition in SMP, and may result in incorrect mode values being read.

Consider the following example, where CPU0 attempts to enable the tracer
on CPU1 (the target CPU):

 CPU0                                    CPU1
 etm4_enable()
  ` coresight_take_mode(SYSFS)
  ` etm4_enable_sysfs()
     ` smp_call_function_single() ---->  etm4_enable_hw_smp_call()
     			                /
                                       /  CPU idle:
                                      /   etm4_cpu_save()
                                     /     ` coresight_get_mode()
	       Failed to enable h/w /         ^^^
  ` coresight_set_mode(DISABLED) <-'          Read the intermediate SYSFS mode

In this case, CPU0 initiates the operation by taking the SYSFS mode to
avoid conflicts with the Perf mode. It then sends an IPI to CPU1 to
configure the tracer registers. If any error occurs during this process,
CPU0 rolls back by setting the mode to DISABLED.

However, if CPU1 enters an idle state during this time, it might read
the intermediate SYSFS mode. As a result, the CPU PM flow could wrongly
save and restore tracer context that is actually disabled.

To resolve the issue, this commit moves the device mode setting logic on
the target CPU. This ensures that the device mode is only modified by
the target CPU, eliminating race condition between mode writes and reads
across CPUs.

An additional change introduces the etm4_disable_sysfs_smp_call()
function for SMP calls, which disables the tracer and explicitly set the
mode to DISABLED during SysFS operations. Rename
etm4_disable_hw_smp_call() to etm4_disable_sysfs_smp_call() for naming
consistency.

The flow is updated with this change:

 CPU0                                    CPU1
 etm4_enable()
  ` etm4_enable_sysfs()
     ` smp_call_function_single() ---->  etm4_enable_hw_smp_call()
                                          ` coresight_take_mode(SYSFS)
	                                    Failed, set back to DISABLED
                                          ` coresight_set_mode(DISABLED)

                                          CPU idle:
                                          etm4_cpu_save()
                                           ` coresight_get_mode()
                                              ^^^
                                              Read out the DISABLED mode

Fixes: c38a9ec2b2c1 ("coresight: etm4x: moving etm_drvdata::enable to atomic field")
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: mike Leach <mike.leach@linaro.org>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20251111-arm_coresight_power_management_fix-v6-2-f55553b6c8b3@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../coresight/coresight-etm4x-core.c          | 60 ++++++++++++-------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 020f070bf17dc..1324b40d54210 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -589,13 +589,26 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 	return rc;
 }
 
-static void etm4_enable_hw_smp_call(void *info)
+static void etm4_enable_sysfs_smp_call(void *info)
 {
 	struct etm4_enable_arg *arg = info;
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
 	arg->rc = etm4_enable_hw(arg->drvdata);
+
+	/* The tracer didn't start */
+	if (arg->rc)
+		coresight_set_mode(csdev, CS_MODE_DISABLED);
 }
 
 /*
@@ -808,13 +821,14 @@ static int etm4_enable_perf(struct coresight_device *csdev,
 			    struct perf_event *event,
 			    struct coresight_path *path)
 {
-	int ret = 0;
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	int ret;
 
-	if (WARN_ON_ONCE(drvdata->cpu != smp_processor_id())) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (WARN_ON_ONCE(drvdata->cpu != smp_processor_id()))
+		return -EINVAL;
+
+	if (!coresight_take_mode(csdev, CS_MODE_PERF))
+		return -EBUSY;
 
 	/* Configure the tracer based on the session's specifics */
 	ret = etm4_parse_event_config(csdev, event);
@@ -830,6 +844,9 @@ static int etm4_enable_perf(struct coresight_device *csdev,
 	ret = etm4_enable_hw(drvdata);
 
 out:
+	/* Failed to start tracer; roll back to DISABLED mode */
+	if (ret)
+		coresight_set_mode(csdev, CS_MODE_DISABLED);
 	return ret;
 }
 
@@ -861,7 +878,7 @@ static int etm4_enable_sysfs(struct coresight_device *csdev, struct coresight_pa
 	 */
 	arg.drvdata = drvdata;
 	ret = smp_call_function_single(drvdata->cpu,
-				       etm4_enable_hw_smp_call, &arg, 1);
+				       etm4_enable_sysfs_smp_call, &arg, 1);
 	if (!ret)
 		ret = arg.rc;
 	if (!ret)
@@ -882,11 +899,6 @@ static int etm4_enable(struct coresight_device *csdev, struct perf_event *event,
 {
 	int ret;
 
-	if (!coresight_take_mode(csdev, mode)) {
-		/* Someone is already using the tracer */
-		return -EBUSY;
-	}
-
 	switch (mode) {
 	case CS_MODE_SYSFS:
 		ret = etm4_enable_sysfs(csdev, path);
@@ -898,10 +910,6 @@ static int etm4_enable(struct coresight_device *csdev, struct perf_event *event,
 		ret = -EINVAL;
 	}
 
-	/* The tracer didn't start */
-	if (ret)
-		coresight_set_mode(csdev, CS_MODE_DISABLED);
-
 	return ret;
 }
 
@@ -953,10 +961,9 @@ static void etm4_disable_trace_unit(struct etmv4_drvdata *drvdata)
 	isb();
 }
 
-static void etm4_disable_hw(void *info)
+static void etm4_disable_hw(struct etmv4_drvdata *drvdata)
 {
 	u32 control;
-	struct etmv4_drvdata *drvdata = info;
 	struct etmv4_config *config = &drvdata->config;
 	struct coresight_device *csdev = drvdata->csdev;
 	struct csdev_access *csa = &csdev->access;
@@ -993,6 +1000,15 @@ static void etm4_disable_hw(void *info)
 		"cpu: %d disable smp call done\n", drvdata->cpu);
 }
 
+static void etm4_disable_sysfs_smp_call(void *info)
+{
+	struct etmv4_drvdata *drvdata = info;
+
+	etm4_disable_hw(drvdata);
+
+	coresight_set_mode(drvdata->csdev, CS_MODE_DISABLED);
+}
+
 static int etm4_disable_perf(struct coresight_device *csdev,
 			     struct perf_event *event)
 {
@@ -1022,6 +1038,8 @@ static int etm4_disable_perf(struct coresight_device *csdev,
 	/* TRCVICTLR::SSSTATUS, bit[9] */
 	filters->ssstatus = (control & BIT(9));
 
+	coresight_set_mode(drvdata->csdev, CS_MODE_DISABLED);
+
 	/*
 	 * perf will release trace ids when _free_aux() is
 	 * called at the end of the session.
@@ -1047,7 +1065,8 @@ static void etm4_disable_sysfs(struct coresight_device *csdev)
 	 * Executing etm4_disable_hw on the cpu whose ETM is being disabled
 	 * ensures that register writes occur when cpu is powered.
 	 */
-	smp_call_function_single(drvdata->cpu, etm4_disable_hw, drvdata, 1);
+	smp_call_function_single(drvdata->cpu, etm4_disable_sysfs_smp_call,
+				 drvdata, 1);
 
 	raw_spin_unlock(&drvdata->spinlock);
 
@@ -1087,9 +1106,6 @@ static void etm4_disable(struct coresight_device *csdev,
 		etm4_disable_perf(csdev, event);
 		break;
 	}
-
-	if (mode)
-		coresight_set_mode(csdev, CS_MODE_DISABLED);
 }
 
 static int etm4_resume_perf(struct coresight_device *csdev)
-- 
2.51.0



