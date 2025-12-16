Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E97C32BF22;
	Tue, 16 Dec 2025 11:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884283; cv=none; b=pKLbH+6TzGSKCdJ91/LpR3y4gcBaOxa/tWajsM+I8x0HLNAYALayK6pxquPr5UAapyYEg+KHUXjbqv3jwSnPwhTgV7tuvY/B/tzc5nUDo9olcALFgtcTm/6VZKqaGZ7pdN+zYVGZPfslC5mM811B1/Sqx2eP/1uQnAhLss6XPR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884283; c=relaxed/simple;
	bh=dGIdtyvNWK8nXJKHlj4EqnLCJGPc2JJzxJfWUt7u2vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwOhYwqYyUbhiwb+ZYsP8RBZK3Jljqg8Cvl5DOllYkhjKzgaGVX5NSl03SvI8QeJ3N49VWAxpW93i/51MyJv8XbFz6NjDtvGH0ekrrX2iBJ1Smw5DCGTo7fFWYRFAjC6Ri1pC2kOBPLj1G1JkmfyLfXI1WIi8OJO0NW87hKyE6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/B11Dzg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/B11Dzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911A4C4CEF1;
	Tue, 16 Dec 2025 11:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884283;
	bh=dGIdtyvNWK8nXJKHlj4EqnLCJGPc2JJzxJfWUt7u2vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/B11DzgflQ54LZ6EvvZJ4bogiXOJ6p1XwnA8I4wL5vnN6m5Ca0SjET6ocAexKpFL
	 W84Un/XRDNnPoYtBccYVlozc88it2v/Pc0D6zis5WADCpo8VJisXhNCnx+ujnXe6Rj
	 gPPdnYx3i96+yjZJf5FOoMpXHT2GwwRjCr4kS6A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/354] coresight: etm4x: Extract the trace unit controlling
Date: Tue, 16 Dec 2025 12:11:54 +0100
Message-ID: <20251216111326.241525116@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 9164e134814ae..853a170439608 100644
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
 
@@ -889,25 +901,12 @@ static int etm4_enable(struct coresight_device *csdev, struct perf_event *event,
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
 
@@ -948,6 +947,28 @@ static void etm4_disable_hw(void *info)
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



