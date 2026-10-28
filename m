Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215797;
	b=Ia9zqZ4WKwMuZJORN4Q/Vec6aldxuyElQbGF/w1WmUYem/eLCHOJ8GKJSzcz6aMEMWt7
	 wecHTldi6LnllE+3mq+csUsyj5w+/Sw+gU2LC0VQooHDr0ygudPy/z548B28TvipFVV38
	 lLmsB+WpAtfXZovw5AnejeJ/3ijCDq6XC7LKPQLJcbokzNL9hvwulzXUiZyfdo8t05qX9
	 BPBZAjTuYEyJDjZGQvk1z+GykelBqN8Mwfj9tDVmjt4pwnCARzXiNToleKQ3G30D8byTK
	 y6JpYX83hqhReh/47rWKgnIPfdl5hfpK/jxUpVi3R7bO5LPXnbzitKy3RqgpIS2Ioow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XWuOmFaFU0Ve9ztrPeUa+ujY58s5HKjJ4o5E6Okg8Us=;
	b=v504Tv0KOPQITsLph5i8eVxhrYbICeyNdf5yCecK4lzKQastAa59+VDZ6ZQLUUQDAvIa
	 Zbtv/LDtkT0sOpOz6TrwSveOg8uWCiBSJB8Hsvsx5eVh961d23jbHCsvnwCZ5zjof9myl
	 4DUcNJIj61wFC1Y8Dq6J7UyipGA1NC4rw4Bv4icir6tKFap92f5+D5OR26gj+5R1Lvo5U
	 uBNw4uNATLOy7aOQ5S9idM8SAxAPy1jaTH/vYNolllSFyhI++E2krTUYcpGu3y2lIBvVa
	 rSAs217bZ6rEFeNvGJF+R+Lex7tE2+5W7i8nawxVbSwQ9fSEXtUdNXY8FyUrBGDXN+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yFIPfViw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B71606A31A;
	Wed, 28 Oct 2026 19:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yFIPfViw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C8E1F01825;
	Wed, 28 Oct 2026 19:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215797;
	bh=XWuOmFaFU0Ve9ztrPeUa+ujY58s5HKjJ4o5E6Okg8Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yFIPfViw6RhAKyVR6j2TE6Ay01vgX7x2MTy5qlBgVHb58Gm0A1Vxt3u/sx5eCCsyj
	 w9ujvC6wP0uBjNbARgKue33mVVOwfwEAtAWO12LyLwFjm2foNtrY0QPRL3Qv1zPT9V
	 ehvayun82yp63NtMelxHTWfNK7nyrRgFsxat9MfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1319/1887] coresight: ete: Always save state on power down
Date: Wed, 28 Oct 2026 17:56:55 +0100
Message-ID: <20261028170529.445904950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 .../coresight/coresight-etm4x-core.c          | 45 ++++++++++++++-----
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 45f2f6db15886..32be2cd1b3b7d 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2014, The Linux Foundation. All rights reserved.
  */
 
+#include <linux/acpi.h>
 #include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/moduleparam.h>
@@ -51,10 +52,14 @@ MODULE_PARM_DESC(boot_enable, "Enable tracing on boot");
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
@@ -1994,6 +1999,17 @@ static void etm4_pm_clear(void)
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
 static int etm4_probe(struct device *dev, void __iomem *base, u32 etm_pid)
 {
 	int ret;
@@ -2003,6 +2019,7 @@ static int etm4_probe(struct device *dev, void __iomem *base, u32 etm_pid)
 	struct etm4_init_arg init_arg = { 0 };
 	u8 major, minor;
 	char *type_name;
+	bool pm_save;
 
 	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
 	if (!drvdata)
@@ -2010,17 +2027,6 @@ static int etm4_probe(struct device *dev, void __iomem *base, u32 etm_pid)
 
 	dev_set_drvdata(dev, drvdata);
 
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
 	drvdata->base = base;
 
 	spin_lock_init(&drvdata->spinlock);
@@ -2064,6 +2070,21 @@ static int etm4_probe(struct device *dev, void __iomem *base, u32 etm_pid)
 	etm4_init_trace_id(drvdata);
 	etm4_set_default(&drvdata->config);
 
+	if (etm4x_always_pm_save(dev, &desc.access))
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
-- 
2.53.0



