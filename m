Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E154C10F3;
	Thu, 17 Sep 2026 15:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660533; cv=none; b=LjWrM/Sy/ldXEYuWHLlc8TwSQe85XE9BdW0tWrhIa20MedCooloMYsxrG8TmLcDTLyxFbzxh8kH13DBkJg2wHMQG7IHvxSUHU9uiSiJVRfHw5T8FVgvqR2IpZf7WFnUOWbaqzfPym6pbtU1SXWQmP8vbp+IAoN0wyMwaS7XhG3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660533; c=relaxed/simple;
	bh=vhDM+/wpn2TCiaDUniJnSZr+Wu9cWSwNWf3iLqiBlqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mA0Msidqbe9pOvVT2+1xxZLHq9vNNowra8AixhvbKXA/aaQxOdWyCmCV0xGptnn4eTtfYUeIYLddImU8F1eBn3pxh0qiwTaa6fzNJKGJCwp3ymKJpDd7UuJ35tE90lnvm+arGcnIvoj06l0mtnLTDYAb3Nl6gqKDEoLlGeyJVI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJ/8OPUp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJ/8OPUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F951F000FF;
	Thu, 17 Sep 2026 15:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660531;
	bh=eB0N4xJ+ElgdvbcIaYYkaJVTMa3iW/XI3CcgWx5aXLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJ/8OPUpQgeiz/7XXbkbWsUtvMtr8P1ME4sVDz/Dzcfjt86QrZisGesoHEX6EiDLy
	 2d8WISjgHJ5KO/eY1YGjJAKFu+rFFhjzXK3BO+0Jm8hu4JZdzRSfVkqUkKW8Ac8UYW
	 Xa75VmuDqnrKLM1OFrBdTQ6kgFJKQyNenoMmOQH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	stable@kernel.org,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.2 584/733] perf: RISC-V: store available counter mask as bitmap
Date: Thu, 17 Sep 2026 16:14:52 +0100
Message-ID: <20260917151406.966398816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -110,8 +110,9 @@ static void pmu_legacy_init(struct riscv
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
@@ -97,7 +97,7 @@ static unsigned int riscv_pmu_irq_mask;
 static unsigned int riscv_pmu_irq;
 
 /* Cache the available counters in a bitmask */
-static unsigned long cmask;
+static DECLARE_BITMAP(cmask, RISCV_MAX_COUNTERS);
 
 static int pmu_event_find_cache(u64 config);
 struct sbi_pmu_event_data {
@@ -359,16 +359,38 @@ free_mem:
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
@@ -488,10 +510,10 @@ int riscv_pmu_get_hpm_info(u32 *hw_ctr_w
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
@@ -540,8 +562,8 @@ static int pmu_sbi_ctr_get_idx(struct pe
 	struct riscv_pmu *rvpmu = to_riscv_pmu(event->pmu);
 	struct cpu_hw_events *cpuc = this_cpu_ptr(rvpmu->hw_events);
 	struct sbiret ret;
-	int idx;
-	uint64_t cbase = 0, cmask = rvpmu->cmask;
+	int idx, i;
+	u64 cbase = 0, cmask = 0;
 	unsigned long cflags = 0;
 
 	cflags = pmu_sbi_get_filter_flags(event);
@@ -562,14 +584,21 @@ static int pmu_sbi_ctr_get_idx(struct pe
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
@@ -577,7 +606,7 @@ static int pmu_sbi_ctr_get_idx(struct pe
 	}
 
 	idx = ret.value;
-	if (!test_bit(idx, &rvpmu->cmask) || !pmu_ctr_list[idx].value)
+	if (!test_bit(idx, rvpmu->cmask) || !pmu_ctr_list[idx].value)
 		return -ENOENT;
 
 	/* Additional sanity check for the counter id */
@@ -881,7 +910,7 @@ static int pmu_sbi_get_ctrinfo(int nctr,
 			/* The logical counter ids are not expected to be contiguous */
 			continue;
 
-		*mask |= BIT(i);
+		set_bit(i, mask);
 
 		cinfo.value = ret.value;
 		if (cinfo.type == SBI_PMU_CTR_TYPE_FW)
@@ -898,12 +927,19 @@ static int pmu_sbi_get_ctrinfo(int nctr,
 
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
@@ -1444,7 +1480,7 @@ static int pmu_sbi_device_probe(struct p
 	}
 
 	/* cache all the information about counters now */
-	if (pmu_sbi_get_ctrinfo(num_counters, &cmask))
+	if (pmu_sbi_get_ctrinfo(num_counters, cmask))
 		goto out_free;
 
 	ret = pmu_sbi_setup_irqs(pmu, pdev);
@@ -1456,7 +1492,7 @@ static int pmu_sbi_device_probe(struct p
 
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


