Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DA586334;
	Thu, 15 Jan 2026 17:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497478; cv=none; b=f5FkDbI6vmnfcrweqp9NPkwbb3cEG1w28ANBcUwPNClUMPDJOA3NfZGkAaEI5gIGfJUngHkzSjRbJut+Dmgir4IZIiaNo3lBF+RyqVFQciBNy7/vOkYfiUZv7SxiT/ecTtvC2F6IqLHJ8uHIvCBDqMJJQcr2LlToZTGLiHvq1sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497478; c=relaxed/simple;
	bh=KJFM3h58tMjINFfrKNqTY8F9KOPnu2d0C8XkUsqK3u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsesVc5YEBD6g+YW1dfH2RrAWH6kZT5svPqfDocHbjNHw9dFUMK8+uL4JTLstw/FZ5Vlf8VlqhvOqYQZw197SlkxjOLlnKswup0cjAoTK2rvKvCWNvU7O59C+BwVxJ7yRsG0wRyw72np4S59t71J7CodKEHE/u+3SPsdaqMJRW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tC6QAvSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tC6QAvSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABF9C116D0;
	Thu, 15 Jan 2026 17:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497478;
	bh=KJFM3h58tMjINFfrKNqTY8F9KOPnu2d0C8XkUsqK3u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tC6QAvSI/BYXMBl2fbZwQD1ElKG/RnemsvC/xYgjTJAoGfrZPst0lVZuz9Ho1FC8L
	 7DIZYX8RdGmXt0GucAN3NwQ69s3cXfnaOe0U12roF3h9v3iNZ86GIDZn4cmfW+BUgG
	 bjVTCNIvsxyxEj7vq6JsV61KBYBMW3FhuvO4auRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Al Grant <al.grant@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Leo Yan <leo.yan@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/554] coresight: etm4x: Use Trace Filtering controls dynamically
Date: Thu, 15 Jan 2026 17:42:40 +0100
Message-ID: <20260115164249.647725313@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 5f6fd1aa8cc147b111af1a833574487a87237dc0 ]

The Trace Filtering support (FEAT_TRF) ensures that the ETM
can be prohibited from generating any trace for a given EL.
This is much stricter knob, than the TRCVICTLR exception level
masks, which doesn't prevent the ETM from generating Context
packets for an "excluded" EL. At the moment, we do a onetime
enable trace at user and kernel and leave it untouched for the
kernel life time. This implies that the ETM could potentially
generate trace packets containing the kernel addresses, and
thus leaking the kernel virtual address in the trace.

This patch makes the switch dynamic, by honoring the filters
set by the user and enforcing them in the TRFCR controls.
We also rename the cpu_enable_tracing() appropriately to
cpu_detect_trace_filtering() and the drvdata member
trfc => trfcr to indicate the "value" of the TRFCR_EL1.

Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Al Grant <al.grant@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20210914102641.1852544-3-suzuki.poulose@arm.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 64eb04ae5452 ("coresight: etm4x: Add context synchronization before enabling trace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../coresight/coresight-etm4x-core.c          | 63 ++++++++++++++-----
 drivers/hwtracing/coresight/coresight-etm4x.h |  7 ++-
 .../coresight/coresight-self-hosted-trace.h   |  7 +++
 3 files changed, 59 insertions(+), 18 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index d124931ee2be5..54e5be46973a3 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -239,6 +239,45 @@ struct etm4_enable_arg {
 	int rc;
 };
 
+/*
+ * etm4x_prohibit_trace - Prohibit the CPU from tracing at all ELs.
+ * When the CPU supports FEAT_TRF, we could move the ETM to a trace
+ * prohibited state by filtering the Exception levels via TRFCR_EL1.
+ */
+static void etm4x_prohibit_trace(struct etmv4_drvdata *drvdata)
+{
+	/* If the CPU doesn't support FEAT_TRF, nothing to do */
+	if (!drvdata->trfcr)
+		return;
+	cpu_prohibit_trace();
+}
+
+/*
+ * etm4x_allow_trace - Allow CPU tracing in the respective ELs,
+ * as configured by the drvdata->config.mode for the current
+ * session. Even though we have TRCVICTLR bits to filter the
+ * trace in the ELs, it doesn't prevent the ETM from generating
+ * a packet (e.g, TraceInfo) that might contain the addresses from
+ * the excluded levels. Thus we use the additional controls provided
+ * via the Trace Filtering controls (FEAT_TRF) to make sure no trace
+ * is generated for the excluded ELs.
+ */
+static void etm4x_allow_trace(struct etmv4_drvdata *drvdata)
+{
+	u64 trfcr = drvdata->trfcr;
+
+	/* If the CPU doesn't support FEAT_TRF, nothing to do */
+	if (!trfcr)
+		return;
+
+	if (drvdata->config.mode & ETM_MODE_EXCL_KERN)
+		trfcr &= ~TRFCR_ELx_ExTRE;
+	if (drvdata->config.mode & ETM_MODE_EXCL_USER)
+		trfcr &= ~TRFCR_ELx_E0TRE;
+
+	write_trfcr(trfcr);
+}
+
 #ifdef CONFIG_ETM4X_IMPDEF_FEATURE
 
 #define HISI_HIP08_AMBA_ID		0x000b6d01
@@ -445,6 +484,7 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 	if (etm4x_is_ete(drvdata))
 		etm4x_relaxed_write32(csa, TRCRSR_TA, TRCRSR);
 
+	etm4x_allow_trace(drvdata);
 	/* Enable the trace unit */
 	etm4x_relaxed_write32(csa, 1, TRCPRGCTLR);
 
@@ -740,7 +780,6 @@ static int etm4_enable(struct coresight_device *csdev,
 static void etm4_disable_hw(void *info)
 {
 	u32 control;
-	u64 trfcr;
 	struct etmv4_drvdata *drvdata = info;
 	struct etmv4_config *config = &drvdata->config;
 	struct coresight_device *csdev = drvdata->csdev;
@@ -767,12 +806,7 @@ static void etm4_disable_hw(void *info)
 	 * If the CPU supports v8.4 Trace filter Control,
 	 * set the ETM to trace prohibited region.
 	 */
-	if (drvdata->trfc) {
-		trfcr = read_sysreg_s(SYS_TRFCR_EL1);
-		write_sysreg_s(trfcr & ~(TRFCR_ELx_ExTRE | TRFCR_ELx_E0TRE),
-			       SYS_TRFCR_EL1);
-		isb();
-	}
+	etm4x_prohibit_trace(drvdata);
 	/*
 	 * Make sure everything completes before disabling, as recommended
 	 * by section 7.3.77 ("TRCVICTLR, ViewInst Main Control Register,
@@ -788,9 +822,6 @@ static void etm4_disable_hw(void *info)
 	if (coresight_timeout(csa, TRCSTATR, TRCSTATR_PMSTABLE_BIT, 1))
 		dev_err(etm_dev,
 			"timeout while waiting for PM stable Trace Status\n");
-	if (drvdata->trfc)
-		write_sysreg_s(trfcr, SYS_TRFCR_EL1);
-
 	/* read the status of the single shot comparators */
 	for (i = 0; i < drvdata->nr_ss_cmp; i++) {
 		config->ss_status[i] =
@@ -988,15 +1019,15 @@ static bool etm4_init_csdev_access(struct etmv4_drvdata *drvdata,
 	return false;
 }
 
-static void cpu_enable_tracing(struct etmv4_drvdata *drvdata)
+static void cpu_detect_trace_filtering(struct etmv4_drvdata *drvdata)
 {
 	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
 	u64 trfcr;
 
+	drvdata->trfcr = 0;
 	if (!cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_TRACE_FILT_SHIFT))
 		return;
 
-	drvdata->trfc = true;
 	/*
 	 * If the CPU supports v8.4 SelfHosted Tracing, enable
 	 * tracing at the kernel EL and EL0, forcing to use the
@@ -1010,7 +1041,7 @@ static void cpu_enable_tracing(struct etmv4_drvdata *drvdata)
 	if (is_kernel_in_hyp_mode())
 		trfcr |= TRFCR_EL2_CX;
 
-	write_trfcr(trfcr);
+	drvdata->trfcr = trfcr;
 }
 
 static void etm4_init_arch_data(void *info)
@@ -1183,7 +1214,7 @@ static void etm4_init_arch_data(void *info)
 	/* NUMCNTR, bits[30:28] number of counters available for tracing */
 	drvdata->nr_cntr = BMVAL(etmidr5, 28, 30);
 	etm4_cs_lock(drvdata, csa);
-	cpu_enable_tracing(drvdata);
+	cpu_detect_trace_filtering(drvdata);
 }
 
 static inline u32 etm4_get_victlr_access_type(struct etmv4_config *config)
@@ -1680,7 +1711,7 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	int ret = 0;
 
 	/* Save the TRFCR irrespective of whether the ETM is ON */
-	if (drvdata->trfc)
+	if (drvdata->trfcr)
 		drvdata->save_trfcr = read_trfcr();
 	/*
 	 * Save and restore the ETM Trace registers only if
@@ -1792,7 +1823,7 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 
 static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 {
-	if (drvdata->trfc)
+	if (drvdata->trfcr)
 		write_trfcr(drvdata->save_trfcr);
 	if (drvdata->state_needs_restore)
 		__etm4_cpu_restore(drvdata);
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 74f1ba8ed148d..85bf733a21bab 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -899,7 +899,10 @@ struct etmv4_save_state {
  * @nooverflow:	Indicate if overflow prevention is supported.
  * @atbtrig:	If the implementation can support ATB triggers
  * @lpoverride:	If the implementation can support low-power state over.
- * @trfc:	If the implementation supports Arm v8.4 trace filter controls.
+ * @trfcr:	If the CPU supports FEAT_TRF, value of the TRFCR_ELx that
+ *		allows tracing at all ELs. We don't want to compute this
+ *		at runtime, due to the additional setting of TRFCR_CX when
+ *		in EL2. Otherwise, 0.
  * @config:	structure holding configuration parameters.
  * @save_trfcr:	Saved TRFCR_EL1 register during a CPU PM event.
  * @save_state:	State to be preserved across power loss
@@ -953,7 +956,7 @@ struct etmv4_drvdata {
 	bool				nooverflow;
 	bool				atbtrig;
 	bool				lpoverride;
-	bool				trfc;
+	u64				trfcr;
 	struct etmv4_config		config;
 	u64				save_trfcr;
 	struct etmv4_save_state		*save_state;
diff --git a/drivers/hwtracing/coresight/coresight-self-hosted-trace.h b/drivers/hwtracing/coresight/coresight-self-hosted-trace.h
index 303d71911870f..23f05df3f1730 100644
--- a/drivers/hwtracing/coresight/coresight-self-hosted-trace.h
+++ b/drivers/hwtracing/coresight/coresight-self-hosted-trace.h
@@ -21,4 +21,11 @@ static inline void write_trfcr(u64 val)
 	isb();
 }
 
+static inline void cpu_prohibit_trace(void)
+{
+	u64 trfcr = read_trfcr();
+
+	/* Prohibit tracing at EL0 & the kernel EL */
+	write_trfcr(trfcr & ~(TRFCR_ELx_ExTRE | TRFCR_ELx_E0TRE));
+}
 #endif /*  __CORESIGHT_SELF_HOSTED_TRACE_H */
-- 
2.51.0



