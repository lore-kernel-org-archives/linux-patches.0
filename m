Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02428324B2B;
	Fri,  9 Jan 2026 12:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961794; cv=none; b=Tkc6NYmV1MOKH5kRUkpYCxk7qZw0qd9T4bOrdkXqfjAxuc5R0cGTxupCYjmWoxFlCudmbNMDRnUjJqdyFRjT0iWNnWOgirfjPwRQnTO4hkFrs4nkJMZA9EwNiOuEW57SMyYIBTKfXCyFadCONmxStHZPC0nCZZ042cOxYupV50o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961794; c=relaxed/simple;
	bh=NcffoXtT9ycta9CD+ty99TJCLbPOe7s0lxpbRfiKcmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfJuI/B5wfRUr+Gi9gso70gIOzZPPqtrTnn0KeQk5yjGmZ1rtPKqSMT+eeiHHH76eY/IqTqOAgjzz3LuRBk8kCvXu2ioOJHpBXvl5WKAV7b2aX7AEwQBx6jLYJxqdt10UTLJ1cA5eTPGT/7DMyIIg8Ru2k0Sv1gjGksRO9k02a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pa6h1zXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pa6h1zXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E5FC4CEF1;
	Fri,  9 Jan 2026 12:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961793;
	bh=NcffoXtT9ycta9CD+ty99TJCLbPOe7s0lxpbRfiKcmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pa6h1zXEsYA0qF42ZYz2HIeOwunsgsUtRuEVWYbOmBP1Bhyw1J192ocK64n/MqPcC
	 Onk7ag3nUZHjEzX5nlLd+qOAhImXlc2QVJ4HNTWy6wxxiqsnnt/Ts+OU/odrx25T2U
	 hPGVOqJZEfELBQ1SHbEUsNN3AVWrEKUGIl/hAQAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/634] coresight: etm4x: Extract the trace unit controlling
Date: Fri,  9 Jan 2026 12:36:23 +0100
Message-ID: <20260109112121.384748255@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 40f682ae5086366d51e29e66eb8a344501245d0d ]

The trace unit is controlled in the ETM hardware enabling and disabling.
The sequential changes for support AUX pause and resume will reuse the
same operations.

Extract the operations in the etm4_{enable|disable}_trace_unit()
functions.  A minor improvement in etm4_enable_trace_unit() is for
returning the timeout error to callers.

Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250401180708.385396-2-leo.yan@arm.com
Stable-dep-of: 64eb04ae5452 ("coresight: etm4x: Add context synchronization before enabling trace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../coresight/coresight-etm4x-core.c          | 103 +++++++++++-------
 1 file changed, 62 insertions(+), 41 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index a3553f9ca0786..b0185b4331523 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -392,6 +392,44 @@ static int etm4x_wait_status(struct csdev_access *csa, int pos, int val)
 	return coresight_timeout(csa, TRCSTATR, pos, val);
 }
 
+static int etm4_enable_trace_unit(struct etmv4_drvdata *drvdata)
+{
+	struct coresight_device *csdev = drvdata->csdev;
+	struct device *etm_dev = &csdev->dev;
+	struct csdev_access *csa = &csdev->access;
+
+	/*
+	 * ETE mandates that the TRCRSR is written to before
+	 * enabling it.
+	 */
+	if (etm4x_is_ete(drvdata))
+		etm4x_relaxed_write32(csa, TRCRSR_TA, TRCRSR);
+
+	etm4x_allow_trace(drvdata);
+	/* Enable the trace unit */
+	etm4x_relaxed_write32(csa, 1, TRCPRGCTLR);
+
+	/* Synchronize the register updates for sysreg access */
+	if (!csa->io_mem)
+		isb();
+
+	/* wait for TRCSTATR.IDLE to go back down to '0' */
+	if (etm4x_wait_status(csa, TRCSTATR_IDLE_BIT, 0)) {
+		dev_err(etm_dev,
+			"timeout while waiting for Idle Trace Status\n");
+		return -ETIME;
+	}
+
+	/*
+	 * As recommended by section 4.3.7 ("Synchronization when using the
+	 * memory-mapped interface") of ARM IHI 0064D
+	 */
+	dsb(sy);
+	isb();
+
+	return 0;
+}
+
 static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 {
 	int i, rc;
@@ -501,33 +539,7 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 		etm4x_relaxed_write32(csa, trcpdcr | TRCPDCR_PU, TRCPDCR);
 	}
 
-	/*
-	 * ETE mandates that the TRCRSR is written to before
-	 * enabling it.
-	 */
-	if (etm4x_is_ete(drvdata))
-		etm4x_relaxed_write32(csa, TRCRSR_TA, TRCRSR);
-
-	etm4x_allow_trace(drvdata);
-	/* Enable the trace unit */
-	etm4x_relaxed_write32(csa, 1, TRCPRGCTLR);
-
-	/* Synchronize the register updates for sysreg access */
-	if (!csa->io_mem)
-		isb();
-
-	/* wait for TRCSTATR.IDLE to go back down to '0' */
-	if (etm4x_wait_status(csa, TRCSTATR_IDLE_BIT, 0))
-		dev_err(etm_dev,
-			"timeout while waiting for Idle Trace Status\n");
-
-	/*
-	 * As recommended by section 4.3.7 ("Synchronization when using the
-	 * memory-mapped interface") of ARM IHI 0064D
-	 */
-	dsb(sy);
-	isb();
-
+	rc = etm4_enable_trace_unit(drvdata);
 done:
 	etm4_cs_lock(drvdata, csa);
 
@@ -828,25 +840,12 @@ static int etm4_enable(struct coresight_device *csdev,
 	return ret;
 }
 
-static void etm4_disable_hw(void *info)
+static void etm4_disable_trace_unit(struct etmv4_drvdata *drvdata)
 {
 	u32 control;
-	struct etmv4_drvdata *drvdata = info;
-	struct etmv4_config *config = &drvdata->config;
 	struct coresight_device *csdev = drvdata->csdev;
 	struct device *etm_dev = &csdev->dev;
 	struct csdev_access *csa = &csdev->access;
-	int i;
-
-	etm4_cs_unlock(drvdata, csa);
-	etm4_disable_arch_specific(drvdata);
-
-	if (!drvdata->skip_power_up) {
-		/* power can be removed from the trace unit now */
-		control = etm4x_relaxed_read32(csa, TRCPDCR);
-		control &= ~TRCPDCR_PU;
-		etm4x_relaxed_write32(csa, control, TRCPDCR);
-	}
 
 	control = etm4x_relaxed_read32(csa, TRCPRGCTLR);
 
@@ -887,6 +886,28 @@ static void etm4_disable_hw(void *info)
 	 * of ARM IHI 0064H.b.
 	 */
 	isb();
+}
+
+static void etm4_disable_hw(void *info)
+{
+	u32 control;
+	struct etmv4_drvdata *drvdata = info;
+	struct etmv4_config *config = &drvdata->config;
+	struct coresight_device *csdev = drvdata->csdev;
+	struct csdev_access *csa = &csdev->access;
+	int i;
+
+	etm4_cs_unlock(drvdata, csa);
+	etm4_disable_arch_specific(drvdata);
+
+	if (!drvdata->skip_power_up) {
+		/* power can be removed from the trace unit now */
+		control = etm4x_relaxed_read32(csa, TRCPDCR);
+		control &= ~TRCPDCR_PU;
+		etm4x_relaxed_write32(csa, control, TRCPDCR);
+	}
+
+	etm4_disable_trace_unit(drvdata);
 
 	/* read the status of the single shot comparators */
 	for (i = 0; i < drvdata->nr_ss_cmp; i++) {
-- 
2.51.0



