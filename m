Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D4646EF78;
	Tue, 21 Jul 2026 18:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656956; cv=none; b=Uzc4IQ+WJIsr084tsOR2IpuUSIMqCeJ3OGdGlxIF72J3tfHb6w+QOBxN7Vph5QOORyrJnE4lCeUz2Bl3kDwISwytdL+A8GymbYAmEUFSLrPd+s9GXvbIyMLoSJR42S1KgzUBj+XO/UwwHI2Gzn5KRD6So7G1gWC+fa/qMldbS2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656956; c=relaxed/simple;
	bh=sQ3mmZmqvs+4hBy6sNzqLppLu7KtvaANpUAGU+jvXyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdVUXX0gE7wRhwIDM2mkYR1JoMWNYY0c9w3VzZF4AHpJ2Yy4gqz7Xqt3PsOfXzTwf4s78ed/Lc8uy9NZz9Mc8IxfenPFh1TSb0GsQfBpFyHmgrKbQqsGz9WozQiHEncFQThlNGiDLrNRDid3AecfhY4a5YNdFQP6orLklHff+DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bwAR8Pcp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bwAR8Pcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938491F000E9;
	Tue, 21 Jul 2026 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656955;
	bh=M4Kar2pqzk3T+8IB/TI+wV7hbIrfZSojbvId9zJWEEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bwAR8PcpMh9zFPQ+GogJelH2CxWmkie1aJXrJEI+iDE+haehH+D1c13tT7vml/nhJ
	 rMIg6qoJAOFsWh2IixsW4c7izF61SpqCfkRHadNbnRh63EZrrdoO1j0sTAjCIY5qOz
	 zdX+yw4ESql2fmI0yN2BVxWyLVT1alsPgj/hlszU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0582/1611] coresight: etm4x: Remove the state_needs_restore flag
Date: Tue, 21 Jul 2026 17:11:38 +0200
Message-ID: <20260721152528.469496468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 9e9182cab5ebc3ee7544e60ef08ba19fdf216920 ]

When the restore flow is invoked, it means no error occurred during the
save phase. Otherwise, if any errors happened while saving the context,
the function would return an error and abort the suspend sequence.

Therefore, the state_needs_restore flag is unnecessary. The save and
restore functions are changed to check two conditions:

1) The global flag pm_save_enable is SELF_HOSTED mode;
2) The device is in active mode (non DISABLED).

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20251111-arm_coresight_power_management_fix-v6-8-f55553b6c8b3@arm.com
Stable-dep-of: 2ab4645fe420 ("coresight: ete: Always save state on power down")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 14 ++++++++------
 drivers/hwtracing/coresight/coresight-etm4x.h      |  2 --
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index fdda924a2c7117..36bf1eecb2a4bb 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1953,8 +1953,6 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 		goto out;
 	}
 
-	drvdata->state_needs_restore = true;
-
 	/*
 	 * Power can be removed from the trace unit now. We do this to
 	 * potentially save power on systems that respect the TRCPDCR_PU
@@ -1972,11 +1970,14 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 {
 	int ret = 0;
 
+	if (pm_save_enable != PARAM_PM_SAVE_SELF_HOSTED)
+		return 0;
+
 	/*
 	 * Save and restore the ETM Trace registers only if
 	 * the ETM is active.
 	 */
-	if (coresight_get_mode(drvdata->csdev) && drvdata->save_state)
+	if (coresight_get_mode(drvdata->csdev))
 		ret = __etm4_cpu_save(drvdata);
 	return ret;
 }
@@ -2066,8 +2067,6 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	if (!drvdata->skip_power_up)
 		etm4x_relaxed_write32(csa, state->trcpdcr, TRCPDCR);
 
-	drvdata->state_needs_restore = false;
-
 	/*
 	 * As recommended by section 4.3.7 ("Synchronization when using the
 	 * memory-mapped interface") of ARM IHI 0064D
@@ -2086,7 +2085,10 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 
 static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 {
-	if (drvdata->state_needs_restore)
+	if (pm_save_enable != PARAM_PM_SAVE_SELF_HOSTED)
+		return;
+
+	if (coresight_get_mode(drvdata->csdev))
 		__etm4_cpu_restore(drvdata);
 }
 
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index b8796b4271025f..012c52fd193381 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -980,7 +980,6 @@ struct etmv4_save_state {
  *		in EL2. Otherwise, 0.
  * @config:	structure holding configuration parameters.
  * @save_state:	State to be preserved across power loss
- * @state_needs_restore: True when there is context to restore after PM exit
  * @skip_power_up: Indicates if an implementation can skip powering up
  *		   the trace unit.
  * @paused:	Indicates if the trace unit is paused.
@@ -1036,7 +1035,6 @@ struct etmv4_drvdata {
 	u64				trfcr;
 	struct etmv4_config		config;
 	struct etmv4_save_state		*save_state;
-	bool				state_needs_restore;
 	bool				skip_power_up;
 	bool				paused;
 	DECLARE_BITMAP(arch_features, ETM4_IMPDEF_FEATURE_MAX);
-- 
2.53.0



