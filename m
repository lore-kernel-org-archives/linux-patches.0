Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDA2231829;
	Tue, 21 Jul 2026 18:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660086; cv=none; b=RwVmHgkoGUmHNaFN3xw5AQzp/fWg8a+s4gwDYauBbzt2oC5AVxkj+wzhS0tQeEaroW1BYzDtRu1i36W9CkN9Po1pS3PiqOjN4ZFqSoEEhmpGot619/01uK3DtodoNKCs2sHjD711CzeN/1ITxcPYV3W/WkUkCKbejgd3VMuDYdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660086; c=relaxed/simple;
	bh=O7SsSBdUw5UllqX4qwdudQZ+izWJKbzHdmOKK808ODY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5kN1O8G27jtuy+6Jd/xAe+mSM69MEsH5tKlvfpVkR9+CYiMuhhhdwpSEYNOWM6vkXy9KAENORubC9H9ggXZua6sC0dfFhA4HrgYyJvOVVXFpw33wcO32IjvClV9EuPZGPjYpx2HZDi4cP5trRpbpw69coYzGoDeFWbdqdy74NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GAYrfGp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GAYrfGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CC41F000E9;
	Tue, 21 Jul 2026 18:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660084;
	bh=T0EMmlxmjEOn2EReUSjDxP6BSUPCRNCn4zlifhXknXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1GAYrfGpPASP8eC40+e4WwbzVTQ9zmeRRoL7vbgJzMzqh+6LGh3pmeQJTUW8LcLhx
	 iV6P2lEg9hPNNFljfZVhJzHxMq1JbuDgNp+pYfQ7eFijIhGeeYxr2DhEPYWhVyYLqa
	 0EXdDAQwMqZvFt//X+SF4E96Zko/PMy3jaPclZvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0846/2077] coresight: ete: Always save state on power down
Date: Tue, 21 Jul 2026 17:08:39 +0200
Message-ID: <20260721152612.746582737@linuxfoundation.org>
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

From: James Clark <james.clark@linaro.org>

[ Upstream commit 2ab4645fe4206c142a5f1491e191c906279686cf ]

System register ETMs and ETE are unlikely to be preserved on CPU power
down. The ETE DT binding also never documented
"arm,coresight-loses-context-with-cpu" so nobody would have legitimately
been able to use that binding to fix it and ACPI has no such binding at
all.

Fix it by hard coding the setting for sysreg ETMs (ETE is always sysreg)
or ACPI boots. Use a local variable when setting up save_state so that
it's immune to concurrent probing when devices have different
configurations which is an issue with modifying the global.

This fixes the following error when using Coresight with ACPI on the FVP
which supports CPU PM:

  coresight ete0: External agent took claim tag
  WARNING: drivers/hwtracing/coresight/coresight-core.c:248 at coresight_disclaim_device_unlocked+0xe0/0xe8, CPU#0: perf/117

Fixes: 35e1c9163e02 ("coresight: ete: Add support for ETE tracing")
Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260505-james-cs-ete-pm_save_enable-v3-1-485d21dd79b8@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../coresight/coresight-etm4x-core.c          | 48 +++++++++++++------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index d565a73f0042e3..591dfe0bc63505 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -56,10 +56,14 @@ MODULE_PARM_DESC(boot_enable, "Enable tracing on boot");
 #define PARAM_PM_SAVE_NEVER	  1 /* never save any state */
 #define PARAM_PM_SAVE_SELF_HOSTED 2 /* save self-hosted state only */
 
+/*
+ * Save option for ETM4. ETE, sysreg ETM4s and ACPI boots ignore this option and
+ * will always save.
+ */
 static int pm_save_enable = PARAM_PM_SAVE_FIRMWARE;
 module_param(pm_save_enable, int, 0444);
 MODULE_PARM_DESC(pm_save_enable,
-	"Save/restore state on power down: 1 = never, 2 = self-hosted");
+	"Save/restore state on power down: 1 = never, 2 = self-hosted. MMIO and DT only.");
 
 static struct etmv4_drvdata *etmdrvdata[NR_CPUS];
 static void etm4_set_default_config(struct etmv4_config *config);
@@ -2012,7 +2016,7 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 {
 	int ret = 0;
 
-	if (pm_save_enable != PARAM_PM_SAVE_SELF_HOSTED)
+	if (!drvdata->save_state)
 		return 0;
 
 	/*
@@ -2127,7 +2131,7 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 
 static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 {
-	if (pm_save_enable != PARAM_PM_SAVE_SELF_HOSTED)
+	if (!drvdata->save_state)
 		return;
 
 	if (coresight_get_mode(drvdata->csdev))
@@ -2212,6 +2216,17 @@ static void etm4_pm_clear(void)
 	}
 }
 
+static bool etm4x_always_pm_save(struct device *dev, struct csdev_access *csa)
+{
+	/*
+	 * Only IO mem ETM devices will benefit from skipping PM save and only
+	 * DT has the option to control it, not ACPI. Otherwise system register
+	 * based ETMs and ETEs will always lose context on CPU power down, so
+	 * always save.
+	 */
+	return !csa->io_mem || is_acpi_device_node(dev_fwnode(dev));
+}
+
 static int etm4_add_coresight_dev(struct etm4_init_arg *init_arg)
 {
 	int ret;
@@ -2221,6 +2236,7 @@ static int etm4_add_coresight_dev(struct etm4_init_arg *init_arg)
 	struct coresight_desc desc = { 0 };
 	u8 major, minor;
 	char *type_name;
+	bool pm_save;
 
 	if (!drvdata)
 		return -EINVAL;
@@ -2248,6 +2264,21 @@ static int etm4_add_coresight_dev(struct etm4_init_arg *init_arg)
 
 	etm4_set_default(&drvdata->config);
 
+	if (etm4x_always_pm_save(dev, init_arg->csa))
+		pm_save = true;
+	else if (pm_save_enable == PARAM_PM_SAVE_FIRMWARE)
+		pm_save = coresight_loses_context_with_cpu(dev);
+	else
+		pm_save = pm_save_enable != PARAM_PM_SAVE_NEVER;
+
+	if (pm_save) {
+		drvdata->save_state = devm_kmalloc(dev,
+						   sizeof(struct etmv4_save_state),
+						   GFP_KERNEL);
+		if (!drvdata->save_state)
+			return -ENOMEM;
+	}
+
 	pdata = coresight_get_platform_data(dev);
 	if (IS_ERR(pdata))
 		return PTR_ERR(pdata);
@@ -2305,17 +2336,6 @@ static int etm4_probe(struct device *dev)
 	if (ret)
 		return ret;
 
-	if (pm_save_enable == PARAM_PM_SAVE_FIRMWARE)
-		pm_save_enable = coresight_loses_context_with_cpu(dev) ?
-			       PARAM_PM_SAVE_SELF_HOSTED : PARAM_PM_SAVE_NEVER;
-
-	if (pm_save_enable != PARAM_PM_SAVE_NEVER) {
-		drvdata->save_state = devm_kmalloc(dev,
-				sizeof(struct etmv4_save_state), GFP_KERNEL);
-		if (!drvdata->save_state)
-			return -ENOMEM;
-	}
-
 	raw_spin_lock_init(&drvdata->spinlock);
 
 	drvdata->cpu = coresight_get_cpu(dev);
-- 
2.53.0



