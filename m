Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8D9384232;
	Sat, 12 Sep 2026 10:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210386; cv=none; b=D8TzlsEGuWg+R9oKgil4sili0k63EziqJV67C3QW06l8f6UGsb7tikej9aRXwy0DWQvRgPM/joIRwNqJldxjRlQRyrJHC5hpr8AJTFn/UmYHnzqY2+qMr8tSWjf6hyoJcsRN06CcOsRh4YJl4G9ruE1iCrhqqrUuGvAjczXYAqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210386; c=relaxed/simple;
	bh=BCsPiYOmiwJcYrdRVcg832FmljU3rocedWceQm7jkw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJSYJOLLBsELT+gVAA33k1R1FbixeqKj+c51Wp2H6IcvVpZoCYXjphII6wkauM3k5szV29LDniZ9beM1qFo55qfQ8kN+b5qvmPW4MZ8vLJuLvfv/uswPYs5NSwwZto8bOB8j3NfQ/lf6UmX7GJJLTSM4xa2MiZZ3/0I5dHNbG58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NR6LdrOC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NR6LdrOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1D41F000FF;
	Sat, 12 Sep 2026 10:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210384;
	bh=3aasi0ZAbWqNpwu0P2hI6pv5GqRiYaISaSI731IIsKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NR6LdrOCTHapzf+oAHeqJxCCU8tDgeUCxKv6jPkOQRBMzFQSTBCO+lNQJBoR36UOM
	 GFm/y4DmX7WMVZQ4qSIfnah8XK9SHEROTMJved3HGOucl9dU6bQaafR78owxZ2Iipd
	 RVpa+KVdl1AOlecsM4hq9oSKeuphD2OaB7/Zigdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0972/1518] coresight: Refactor etm4_config_timestamp_event()
Date: Sat, 12 Sep 2026 08:52:21 +0200
Message-ID: <20260912065645.447237321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: James Clark <james.clark@linaro.org>

[ Upstream commit b02450de6ba6309c66e2e056ccfbfce4bd3b0352 ]

Remove some of the magic numbers and try to clarify some of the
documentation so it's clearer how this sets up the timestamp interval.

Return errors directly instead of jumping to out and returning ret,
nothing needs to be cleaned up at the end and it only obscures the flow
and return value.

Add utilities for programming resource selectors that do compile time
checks for constants or WARN_ONs for non-constant values. FIELD_PREP
includes compile time checks so we only need to add an additional
BUILD_BUG_ON for resource == 0 in pair mode.

Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20251128-james-cs-syncfreq-v8-3-4d319764cc58@linaro.org
Stable-dep-of: 0a47f0be6557 ("coresight: etm4x: missing cscfg_csdev_disable_active_config() in perf enable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../coresight/coresight-etm4x-core.c          | 96 ++++++++++++-------
 drivers/hwtracing/coresight/coresight-etm4x.h | 54 ++++++++++-
 2 files changed, 112 insertions(+), 38 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index ac0908a347132..522e128174467 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -641,18 +641,33 @@ static void etm4_enable_sysfs_smp_call(void *info)
  * TRCRSCTLR1 (always true) used to get the counter to decrement.  From
  * there a resource selector is configured with the counter and the
  * timestamp control register to use the resource selector to trigger the
- * event that will insert a timestamp packet in the stream.
+ * event that will insert a timestamp packet in the stream:
+ *
+ *  +--------------+
+ *  | Resource 1   |   fixed "always-true" resource
+ *  +--------------+
+ *         |
+ *  +------v-------+
+ *  | Counter x    |   (reload to 1 on underflow)
+ *  +--------------+
+ *         |
+ *  +------v--------------+
+ *  | Resource Selector y |   (trigger on counter x == 0)
+ *  +---------------------+
+ *         |
+ *  +------v---------------+
+ *  | Timestamp Generator  |  (timestamp on resource y)
+ *  +----------------------+
  */
 static int etm4_config_timestamp_event(struct etmv4_drvdata *drvdata)
 {
-	int ctridx, ret = -EINVAL;
-	int counter, rselector;
-	u32 val = 0;
+	int ctridx;
+	int rselector;
 	struct etmv4_config *config = &drvdata->config;
 
 	/* No point in trying if we don't have at least one counter */
 	if (!drvdata->nr_cntr)
-		goto out;
+		return -EINVAL;
 
 	/* Find a counter that hasn't been initialised */
 	for (ctridx = 0; ctridx < drvdata->nr_cntr; ctridx++)
@@ -662,15 +677,19 @@ static int etm4_config_timestamp_event(struct etmv4_drvdata *drvdata)
 	/* All the counters have been configured already, bail out */
 	if (ctridx == drvdata->nr_cntr) {
 		pr_debug("%s: no available counter found\n", __func__);
-		ret = -ENOSPC;
-		goto out;
+		return -ENOSPC;
 	}
 
 	/*
-	 * Searching for an available resource selector to use, starting at
-	 * '2' since every implementation has at least 2 resource selector.
-	 * ETMIDR4 gives the number of resource selector _pairs_,
-	 * hence multiply by 2.
+	 * Searching for an available resource selector to use, starting at '2'
+	 * since resource 0 is the fixed 'always returns false' resource and 1
+	 * is the fixed 'always returns true' resource. See IHI0064H_b '7.3.64
+	 * TRCRSCTLRn, Resource Selection Control Registers, n=2-31'. If there
+	 * are no resources, there would also be no counters so wouldn't get
+	 * here.
+	 *
+	 * ETMIDR4 gives the number of resource selector _pairs_, hence multiply
+	 * by 2.
 	 */
 	for (rselector = 2; rselector < drvdata->nr_resource * 2; rselector++)
 		if (!config->res_ctrl[rselector])
@@ -679,13 +698,9 @@ static int etm4_config_timestamp_event(struct etmv4_drvdata *drvdata)
 	if (rselector == drvdata->nr_resource * 2) {
 		pr_debug("%s: no available resource selector found\n",
 			 __func__);
-		ret = -ENOSPC;
-		goto out;
+		return -ENOSPC;
 	}
 
-	/* Remember what counter we used */
-	counter = 1 << ctridx;
-
 	/*
 	 * Initialise original and reload counter value to the smallest
 	 * possible value in order to get as much precision as we can.
@@ -693,26 +708,41 @@ static int etm4_config_timestamp_event(struct etmv4_drvdata *drvdata)
 	config->cntr_val[ctridx] = 1;
 	config->cntrldvr[ctridx] = 1;
 
-	/* Set the trace counter control register */
-	val =  0x1 << 16	|  /* Bit 16, reload counter automatically */
-	       0x0 << 7		|  /* Select single resource selector */
-	       0x1;		   /* Resource selector 1, i.e always true */
-
-	config->cntr_ctrl[ctridx] = val;
-
-	val = 0x2 << 16		| /* Group 0b0010 - Counter and sequencers */
-	      counter << 0;	  /* Counter to use */
-
-	config->res_ctrl[rselector] = val;
+	/*
+	 * Trace Counter Control Register TRCCNTCTLRn
+	 *
+	 * CNTCHAIN = 0, don't reload on the previous counter
+	 * RLDSELF = true, reload counter automatically on underflow
+	 * RLDEVENT = RES_SEL_FALSE (0), reload on single false resource (never reload)
+	 * CNTEVENT = RES_SEL_TRUE (1), count single fixed 'always true' resource (always decrement)
+	 */
+	config->cntr_ctrl[ctridx] = TRCCNTCTLRn_RLDSELF |
+				    FIELD_PREP(TRCCNTCTLRn_RLDEVENT_MASK,
+					       etm4_res_sel_single(ETM4_RES_SEL_FALSE)) |
+				    FIELD_PREP(TRCCNTCTLRn_CNTEVENT_MASK,
+					       etm4_res_sel_single(ETM4_RES_SEL_TRUE));
 
-	val = 0x0 << 7		| /* Select single resource selector */
-	      rselector;	  /* Resource selector */
+	/*
+	 * Resource Selection Control Register TRCRSCTLRn
+	 *
+	 * PAIRINV = 0, INV = 0, don't invert
+	 * GROUP = 2, SELECT = ctridx, trigger when counter 'ctridx' reaches 0
+	 *
+	 * Multiple counters can be selected, and each bit signifies a counter,
+	 * so set bit 'ctridx' to select our counter.
+	 */
+	config->res_ctrl[rselector] = FIELD_PREP(TRCRSCTLRn_GROUP_MASK, 2) |
+				      FIELD_PREP(TRCRSCTLRn_SELECT_MASK, 1 << ctridx);
 
-	config->ts_ctrl = val;
+	/*
+	 * Global Timestamp Control Register TRCTSCTLR
+	 *
+	 * EVENT = generate timestamp on single resource 'rselector'
+	 */
+	config->ts_ctrl = FIELD_PREP(TRCTSCTLR_EVENT_MASK,
+				     etm4_res_sel_single(rselector));
 
-	ret = 0;
-out:
-	return ret;
+	return 0;
 }
 
 static int etm4_parse_event_config(struct coresight_device *csdev,
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index d2ece9691d3a2..0489496babb33 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -225,6 +225,50 @@
 #define TRCRSCTLRn_GROUP_MASK			GENMASK(19, 16)
 #define TRCRSCTLRn_SELECT_MASK			GENMASK(15, 0)
 
+#define TRCCNTCTLRn_CNTCHAIN			BIT(17)
+#define TRCCNTCTLRn_RLDSELF			BIT(16)
+#define TRCCNTCTLRn_RLDEVENT_MASK		GENMASK(15, 8)
+#define TRCCNTCTLRn_CNTEVENT_MASK		GENMASK(7, 0)
+
+#define TRCTSCTLR_EVENT_MASK			GENMASK(7, 0)
+
+#define ETM4_RES_SEL_FALSE 0 /* Fixed function 'always false' resource selector */
+#define ETM4_RES_SEL_TRUE  1 /* Fixed function 'always true' resource selector */
+
+#define ETM4_RES_SEL_SINGLE_MASK		GENMASK(4, 0)
+#define ETM4_RES_SEL_PAIR_MASK			GENMASK(3, 0)
+#define ETM4_RES_SEL_TYPE_PAIR			BIT(7)
+
+/*
+ * Utilities for programming EVENT resource selectors, e.g. TRCCNTCTLRn_RLDEVENT.
+ *
+ * Resource selectors have a common format across registers:
+ *
+ *    7     6  5  4     0
+ * +------+------+-------+
+ * | TYPE | RES0 |  SEL  |
+ * +------+------+-------+
+ *
+ * Where TYPE indicates whether the selector is for a single event or a pair.
+ * When TYPE is pair, SEL is 4 bits wide and using pair 0 is UNPREDICTABLE.
+ * Otherwise for single it's 5 bits wide.
+ */
+static inline u32 etm4_res_sel_single(u8 res_sel_idx)
+{
+	WARN_ON_ONCE(!FIELD_FIT(ETM4_RES_SEL_SINGLE_MASK, res_sel_idx));
+	return FIELD_PREP(ETM4_RES_SEL_SINGLE_MASK, res_sel_idx);
+}
+
+static inline u32 etm4_res_sel_pair(u8 res_sel_idx)
+{
+	if (__builtin_constant_p(res_sel_idx))
+		BUILD_BUG_ON(res_sel_idx == 0);
+	WARN_ON_ONCE(!FIELD_FIT(ETM4_RES_SEL_PAIR_MASK, res_sel_idx) ||
+		     (res_sel_idx == 0));
+	return FIELD_PREP(ETM4_RES_SEL_PAIR_MASK, res_sel_idx) |
+	       ETM4_RES_SEL_TYPE_PAIR;
+}
+
 /*
  * System instructions to access ETM registers.
  * See ETMv4.4 spec ARM IHI0064F section 4.3.6 System instructions
@@ -825,7 +869,7 @@ struct etmv4_config {
 	u32				eventctrl0;
 	u32				eventctrl1;
 	u32				stall_ctrl;
-	u32				ts_ctrl;
+	u32				ts_ctrl; /* TRCTSCTLR */
 	u32				ccctlr;
 	u32				bb_ctrl;
 	u32				vinst_ctrl;
@@ -838,11 +882,11 @@ struct etmv4_config {
 	u32				seq_rst;
 	u32				seq_state;
 	u8				cntr_idx;
-	u32				cntrldvr[ETMv4_MAX_CNTR];
-	u32				cntr_ctrl[ETMv4_MAX_CNTR];
-	u32				cntr_val[ETMv4_MAX_CNTR];
+	u32				cntrldvr[ETMv4_MAX_CNTR]; /* TRCCNTRLDVRn */
+	u32				cntr_ctrl[ETMv4_MAX_CNTR];  /* TRCCNTCTLRn */
+	u32				cntr_val[ETMv4_MAX_CNTR]; /* TRCCNTVRn */
 	u8				res_idx;
-	u32				res_ctrl[ETM_MAX_RES_SEL];
+	u32				res_ctrl[ETM_MAX_RES_SEL]; /* TRCRSCTLRn */
 	u8				ss_idx;
 	u32				ss_ctrl[ETM_MAX_SS_CMP];
 	u32				ss_status[ETM_MAX_SS_CMP];
-- 
2.53.0



