Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC57D50277E;
	Thu, 17 Sep 2026 17:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666481; cv=none; b=cAhCVHYrEvO2uQYf4imwE8Mg15QrXHAR93t+Y7a0GlCERYC9mLRlKF14jCZzfbDEAccujTwqtdux2NbbuHw4kWkB57n2WGvRtonbMSfsV9chaizNtBu+1bM9NLNd8DMnTzUqe4lU7zGDozoD5nN86FccGSd0VAZKILHqSGbNQDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666481; c=relaxed/simple;
	bh=IwOrZqwfuh/y3bapNGQVfcuAcSQyFYt5PCdm8a0eNwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXCLGX1TPzDkdYvwRy6cNFsG9QGd+CUwDi+jOlBfwl25Ve9/pe0L+K+oDMbjc+7ETVczOrrYM3wYVaj7RLdL56y3UwL+Dg/cvJd5xYbKuTPRhQi6Vre0pxpgShxCYF1Z/fSUaj9v3MkOH8EvuZ0+QJJc1IrsHTCe5rdRxlDrrL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRigsyES; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRigsyES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F20E1F000FF;
	Thu, 17 Sep 2026 17:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666479;
	bh=oZv05HcbRA0ka+/rSw9YLco+1u6WwESxswAskL2TzsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRigsyES8hVVGSny5fPjZwyIIXVSae8SqU/UDYD000R9OjV/+PEM9Zz+TKhMlAOOl
	 Dv7Z3Hn8IfBvhLfh3Yqy5a0PwdwzwgCR6p0ydZiZ/At/zSmM1wAtjnVKmlZulZWfBT
	 aY/cnWinnuGLEsmOee9+YXII2ei1GPOmmKfWz8eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	stable@kernel.org,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 1050/1250] perf: RISC-V: store available counter mask as bitmap
Date: Thu, 17 Sep 2026 16:14:05 +0100
Message-ID: <20260917151620.578893218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Xixin Liu <liuxixin@kylinos.cn>

commit 6809da6e9c08ccc9a09cb0a48c61471679274aaa upstream.

The available-counter mask was a single unsigned long, but iteration
uses RISCV_MAX_COUNTERS, which is 64. On RV32 that reads past the object.
Filling with an unsigned-long bit at index 32 and above is also wrong.

Use DECLARE_BITMAP and set_bit/bitmap helpers. Walk each bitmap word
into CFG_MATCH when checking events, when allocating an index, and when
stopping all counters. Set the counter base to i times BITS_PER_LONG.
Share the CFG_MATCH ecall through a small helper so the 32-bit argument
split is not duplicated. On qemu-system-riscv32 the probe bitmap has bits
above XLEN set, so the first word alone is not enough.

Fixes: e9991434596f ("RISC-V: Add perf platform driver based on SBI PMU extension")
Assisted-by: DeepSeek:deepseek-v3
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Link: https://patch.msgid.link/prpmask02cmap.v2.1786434000.git.liuxixin@kylinos.cn
Cc: stable@kernel.org
[pjw@kernel.org: updated to apply; fixed checkpatch.pl issues]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/riscv_pmu_legacy.c |    5 +-
 drivers/perf/riscv_pmu_sbi.c    |   88 ++++++++++++++++++++++++++++------------
 include/linux/perf/riscv_pmu.h  |    2 
 3 files changed, 66 insertions(+), 29 deletions(-)

--- a/drivers/perf/riscv_pmu_legacy.c
+++ b/drivers/perf/riscv_pmu_legacy.c
@@ -111,8 +111,9 @@ static void pmu_legacy_init(struct riscv
 {
 	pr_info("Legacy PMU implementation is available\n");
 
-	pmu->cmask = BIT(RISCV_PMU_LEGACY_CYCLE) |
-		BIT(RISCV_PMU_LEGACY_INSTRET);
+	bitmap_zero(pmu->cmask, RISCV_MAX_COUNTERS);
+	set_bit(RISCV_PMU_LEGACY_CYCLE, pmu->cmask);
+	set_bit(RISCV_PMU_LEGACY_INSTRET, pmu->cmask);
 	pmu->ctr_start = pmu_legacy_ctr_start;
 	pmu->ctr_stop = NULL;
 	pmu->event_map = pmu_legacy_event_map;
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -98,7 +98,7 @@ static unsigned int riscv_pmu_irq_mask;
 static unsigned int riscv_pmu_irq;
 
 /* Cache the available counters in a bitmask */
-static unsigned long cmask;
+static DECLARE_BITMAP(cmask, RISCV_MAX_COUNTERS);
 
 static int pmu_event_find_cache(u64 config);
 struct sbi_pmu_event_data {
@@ -360,16 +360,38 @@ free_mem:
 	return result;
 }
 
+static struct sbiret pmu_sbi_ctr_cfg_match(unsigned long cbase,
+					   unsigned long ctr_mask,
+					   unsigned long cflags,
+					   unsigned long event_idx,
+					   u64 config)
+{
+#if defined(CONFIG_32BIT)
+	return sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cbase,
+			 ctr_mask, cflags, event_idx, config, config >> 32);
+#else
+	return sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cbase,
+			 ctr_mask, cflags, event_idx, config, 0);
+#endif
+}
+
 static void pmu_sbi_check_event(struct sbi_pmu_event_data *edata)
 {
-	struct sbiret ret;
+	struct sbiret ret = { .error = SBI_ERR_NOT_SUPPORTED };
+	int i;
 
-	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH,
-			0, cmask, 0, edata->event_idx, 0, 0);
-	if (!ret.error) {
-		sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP,
-			  ret.value, 0x1, SBI_PMU_STOP_FLAG_RESET, 0, 0, 0);
-	} else if (ret.error == SBI_ERR_NOT_SUPPORTED) {
+	for (i = 0; i < BITS_TO_LONGS(RISCV_MAX_COUNTERS); i++) {
+		if (!cmask[i])
+			continue;
+		ret = pmu_sbi_ctr_cfg_match(i * BITS_PER_LONG, cmask[i], 0,
+					    edata->event_idx, 0);
+		if (!ret.error) {
+			sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP,
+				  ret.value, 0x1, SBI_PMU_STOP_FLAG_RESET, 0, 0, 0);
+			return;
+		}
+	}
+	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
 		/* This event cannot be monitored by any counter */
 		edata->event_idx = -ENOENT;
 	}
@@ -489,10 +511,10 @@ int riscv_pmu_get_hpm_info(u32 *hw_ctr_w
 	union sbi_pmu_ctr_info *info;
 	u32 hpm_width = 0, hpm_count = 0;
 
-	if (!cmask)
+	if (bitmap_empty(cmask, RISCV_MAX_COUNTERS))
 		return -EINVAL;
 
-	for_each_set_bit(i, &cmask, RISCV_MAX_COUNTERS) {
+	for_each_set_bit(i, cmask, RISCV_MAX_COUNTERS) {
 		info = &pmu_ctr_list[i];
 		if (!info)
 			continue;
@@ -541,8 +563,8 @@ static int pmu_sbi_ctr_get_idx(struct pe
 	struct riscv_pmu *rvpmu = to_riscv_pmu(event->pmu);
 	struct cpu_hw_events *cpuc = this_cpu_ptr(rvpmu->hw_events);
 	struct sbiret ret;
-	int idx;
-	uint64_t cbase = 0, cmask = rvpmu->cmask;
+	int idx, i;
+	u64 cbase = 0, cmask = 0;
 	unsigned long cflags = 0;
 
 	cflags = pmu_sbi_get_filter_flags(event);
@@ -563,14 +585,21 @@ static int pmu_sbi_ctr_get_idx(struct pe
 	}
 
 	/* retrieve the available counter index */
-#if defined(CONFIG_32BIT)
-	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cbase,
-			cmask, cflags, hwc->event_base, hwc->config,
-			hwc->config >> 32);
-#else
-	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cbase,
-			cmask, cflags, hwc->event_base, hwc->config, 0);
-#endif
+	if (cmask) {
+		ret = pmu_sbi_ctr_cfg_match(cbase, cmask, cflags, hwc->event_base,
+					    hwc->config);
+	} else {
+		ret.error = SBI_ERR_NOT_SUPPORTED;
+		for (i = 0; i < BITS_TO_LONGS(RISCV_MAX_COUNTERS); i++) {
+			if (!rvpmu->cmask[i])
+				continue;
+			cbase = i * BITS_PER_LONG;
+			ret = pmu_sbi_ctr_cfg_match(cbase, rvpmu->cmask[i], cflags,
+						    hwc->event_base, hwc->config);
+			if (!ret.error)
+				break;
+		}
+	}
 	if (ret.error) {
 		pr_debug("Not able to find a counter for event %lx config %llx\n",
 			hwc->event_base, hwc->config);
@@ -578,7 +607,7 @@ static int pmu_sbi_ctr_get_idx(struct pe
 	}
 
 	idx = ret.value;
-	if (!test_bit(idx, &rvpmu->cmask) || !pmu_ctr_list[idx].value)
+	if (!test_bit(idx, rvpmu->cmask) || !pmu_ctr_list[idx].value)
 		return -ENOENT;
 
 	/* Additional sanity check for the counter id */
@@ -882,7 +911,7 @@ static int pmu_sbi_get_ctrinfo(int nctr,
 			/* The logical counter ids are not expected to be contiguous */
 			continue;
 
-		*mask |= BIT(i);
+		set_bit(i, mask);
 
 		cinfo.value = ret.value;
 		if (cinfo.type == SBI_PMU_CTR_TYPE_FW)
@@ -899,12 +928,19 @@ static int pmu_sbi_get_ctrinfo(int nctr,
 
 static inline void pmu_sbi_stop_all(struct riscv_pmu *pmu)
 {
+	int i;
+
 	/*
 	 * No need to check the error because we are disabling all the counters
 	 * which may include counters that are not enabled yet.
 	 */
-	sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP,
-		  0, pmu->cmask, SBI_PMU_STOP_FLAG_RESET, 0, 0, 0);
+	for (i = 0; i < BITS_TO_LONGS(RISCV_MAX_COUNTERS); i++) {
+		if (!pmu->cmask[i])
+			continue;
+		sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP,
+			  i * BITS_PER_LONG, pmu->cmask[i],
+			  SBI_PMU_STOP_FLAG_RESET, 0, 0, 0);
+	}
 }
 
 static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
@@ -1445,7 +1481,7 @@ static int pmu_sbi_device_probe(struct p
 	}
 
 	/* cache all the information about counters now */
-	if (pmu_sbi_get_ctrinfo(num_counters, &cmask))
+	if (pmu_sbi_get_ctrinfo(num_counters, cmask))
 		goto out_free;
 
 	ret = pmu_sbi_setup_irqs(pmu, pdev);
@@ -1457,7 +1493,7 @@ static int pmu_sbi_device_probe(struct p
 
 	pmu->pmu.attr_groups = riscv_pmu_attr_groups;
 	pmu->pmu.parent = &pdev->dev;
-	pmu->cmask = cmask;
+	bitmap_copy(pmu->cmask, cmask, RISCV_MAX_COUNTERS);
 	pmu->ctr_start = pmu_sbi_ctr_start;
 	pmu->ctr_stop = pmu_sbi_ctr_stop;
 	pmu->event_map = pmu_sbi_event_map;
--- a/include/linux/perf/riscv_pmu.h
+++ b/include/linux/perf/riscv_pmu.h
@@ -55,7 +55,7 @@ struct riscv_pmu {
 
 	irqreturn_t	(*handle_irq)(int irq_num, void *dev);
 
-	unsigned long	cmask;
+	DECLARE_BITMAP(cmask, RISCV_MAX_COUNTERS);
 	u64		(*ctr_read)(struct perf_event *event);
 	int		(*ctr_get_idx)(struct perf_event *event);
 	int		(*ctr_get_width)(int idx);


