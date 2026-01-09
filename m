Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE742DEA6F;
	Fri,  9 Jan 2026 11:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959797; cv=none; b=Ok/sLOdY5PX0APdbQjZIxkCxQZMD6UW3pKuwBjC4++i0mQBSpggjhDbPSNL0+96+Ku/N8NcXlrF+po07vbTF6iOMVqC1KxdSDGCCFms6GblqgJHr65yAUnlGT/JDuuQz8JMyk1UXxNe/sqBaTWDWk0uPDlIEFGLsrI05a2TcdAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959797; c=relaxed/simple;
	bh=MyoGFJleQapWyIOZnosg//7BJowsW7dqptFVerAxs3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlM2x7QJSLfCbWgT8E1RIZK5wF8EJpnh3zFU191aI3cEY7wzMbJXi0gSXROHazVSmlG20kdTtTzyBnhJ3KD/gyAVYVgm5/qW3PkNueKKQyhUhmBm9xCte4Cckn1o6busTPyCOETIe6tHqfuyfH0VOolGu+3wN4zzqKQODOibkdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/Z3vo5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/Z3vo5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE962C4CEF1;
	Fri,  9 Jan 2026 11:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959797;
	bh=MyoGFJleQapWyIOZnosg//7BJowsW7dqptFVerAxs3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/Z3vo5uJv6ngd6rwfV90J3nH2xP/DJbgtLaeHHyhjYBLwlMIwo6QZHLY3/YGbYyE
	 Id6HV9UAeKJ3TvrxBAGe/PQFNDu0NRaoVxo0puHRDUp5lyZQbhsleD5iLY1Cct+sFz
	 uvh74ETLhjE7UCFBysMzmoXpth3f35QjTNO5jB4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/737] coresight: etm4x: Extract the trace unit controlling
Date: Fri,  9 Jan 2026 12:34:44 +0100
Message-ID: <20260109112139.452677867@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index cc35175abd504..a53816f24cd94 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -422,6 +422,44 @@ static int etm4x_wait_status(struct csdev_access *csa, int pos, int val)
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
@@ -531,33 +569,7 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
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
 
@@ -886,25 +898,12 @@ static int etm4_enable(struct coresight_device *csdev, struct perf_event *event,
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
 
@@ -945,6 +944,28 @@ static void etm4_disable_hw(void *info)
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



