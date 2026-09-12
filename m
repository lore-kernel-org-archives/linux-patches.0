Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA4B384232;
	Sat, 12 Sep 2026 10:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210376; cv=none; b=TsiAb/pbmSv16pDDYAezIIRTl7P9cKD0roI1wt2dmI7Qfh2+mgx1vr5J9hZVL/Ej49tfIII6MwgLJpSL5MkR1hGlUo26kQCYb2b3oUGsb4p1Xr5cD+VeU6dtaP9FlSOjLFsw/pNsQ3ZuEAI9vbEkShql6Gx6/S4vopRA5f2p5nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210376; c=relaxed/simple;
	bh=CHNL0UGgbj1tfD05Wx5vgjzpV6ufbS+OGZtyHvGg6Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPt60W0qqZWGbgtCsPwr6OCIa/KWAMKM13SI68wa3IPhaBGt35JPxq2IxwXoZAKZDI0WoNWM6eU9oOdl07rwML7G8Pnp+vMPxOZs2dE1/mCjM61LhPt6YZTErZXgHUlCiC3TXAmFuPbgY63Z29GbC9xZC2sddj6XrwM0aqJ9pLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsp43dxT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsp43dxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9361F000FF;
	Sat, 12 Sep 2026 10:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210375;
	bh=BdelAoT92gNaBvydpKQi80sxGX1JfvdaktMO/Da3Ue4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zsp43dxTHYTKpkxbySssa1j1zZgm1p9JFwbeeeNZcKT/CCgnCGE/RW6FNX/pRQF3o
	 hGUISxxc0CjF6VDxIkhtqtTBCKndm2P/y4Oi2nv9DtNgqZiEaJGINUS2fAu8hYVA8X
	 CS6K5gbtC/5BiVGUhq+sNBWIkJrev9FyQEprLxzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0970/1518] coresight: etm4x: fix underflow for usage of (nrseqstate - 1)
Date: Sat, 12 Sep 2026 08:52:19 +0200
Message-ID: <20260912065645.402200902@linuxfoundation.org>
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 1674d9bff8073bdee5dbc200f56fc3caa28d0566 ]

According to IHI006H Embedded Trace Macrocell Architecture
Specification[0], TRCSEQEVR<n> is implemented only when
TRCIDR5.NUMSEQSTATE is 0b100, in which case n ranges from 0 to 2;
otherwise, TRCIDR5.NUMSEQSTATE is 0b000.

IOW, the number of usage in the initialisation or setting
TRCSEQEVR<n> with drvdata->nrseqstate - 1 in the loop could make
underflow issue when TRCIDR5.NUMSEQSTATE is 0b000.

Therefore, introduce nr_seq_ctrls field and untie it from nrseqstate.
As part of this introduce ETM_MAX_SEQ_TRANSITIONS macro and
apply nr_seq_ctrls and above macro to TRCSEQEVR<n> relevant fields setup.

Link: https://developer.arm.com/documentation/ihi0064/latest/ [0]
Fixes: 2e1cdfe184b5 ("coresight-etm4x: Adding CoreSight ETM4x driver")
Suggested-by: Leo Yan <leo.yan@arm.com>
Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260725113645.57519-3-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-cfg.c   | 2 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c  | 9 ++++++---
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 6 ++++--
 drivers/hwtracing/coresight/coresight-etm4x.h       | 7 +++++--
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-cfg.c b/drivers/hwtracing/coresight/coresight-etm4x-cfg.c
index c302072b293a3..e1a59b4345052 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-cfg.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-cfg.c
@@ -76,7 +76,7 @@ static int etm4_cfg_map_reg_offset(struct etmv4_drvdata *drvdata,
 	} else if ((offset & GENMASK(11, 4)) == TRCSEQEVRn(0)) {
 		/* sequencer state control registers */
 		idx = (offset & GENMASK(3, 0)) / 4;
-		if (idx < ETM_MAX_SEQ_STATES) {
+		if (idx < ETM_MAX_SEQ_TRANSITIONS) {
 			reg_csdev->driver_regval = &drvcfg->seq_ctrl[idx];
 			err = 0;
 		}
diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 318846e4dda3a..a265586020ac8 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -541,7 +541,8 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 	etm4x_relaxed_write32(csa, config->vissctlr, TRCVISSCTLR);
 	if (drvdata->nr_pe_cmp)
 		etm4x_relaxed_write32(csa, config->vipcssctlr, TRCVIPCSSCTLR);
-	for (i = 0; i < drvdata->nrseqstate - 1; i++)
+
+	for (i = 0; i < drvdata->nr_seq_ctrls; i++)
 		etm4x_relaxed_write32(csa, config->seq_ctrl[i], TRCSEQEVRn(i));
 	if (drvdata->nrseqstate) {
 		etm4x_relaxed_write32(csa, config->seq_rst, TRCSEQRSTEVR);
@@ -1476,6 +1477,8 @@ static void etm4_init_arch_data(void *info)
 	drvdata->lpoverride = (etmidr5 & TRCIDR5_LPOVERRIDE) && (!drvdata->skip_power_up);
 	/* NUMSEQSTATE, bits[27:25] number of sequencer states implemented */
 	drvdata->nrseqstate = FIELD_GET(TRCIDR5_NUMSEQSTATE_MASK, etmidr5);
+	if (drvdata->nrseqstate)
+		drvdata->nr_seq_ctrls = ETM_MAX_SEQ_TRANSITIONS;
 	/* NUMCNTR, bits[30:28] number of counters available for tracing */
 	drvdata->nr_cntr = FIELD_GET(TRCIDR5_NUMCNTR_MASK, etmidr5);
 
@@ -1889,7 +1892,7 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	if (drvdata->nr_pe_cmp)
 		state->trcvipcssctlr = etm4x_read32(csa, TRCVIPCSSCTLR);
 
-	for (i = 0; i < drvdata->nrseqstate - 1; i++)
+	for (i = 0; i < drvdata->nr_seq_ctrls; i++)
 		state->trcseqevr[i] = etm4x_read32(csa, TRCSEQEVRn(i));
 
 	if (drvdata->nrseqstate) {
@@ -2020,7 +2023,7 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	if (drvdata->nr_pe_cmp)
 		etm4x_relaxed_write32(csa, state->trcvipcssctlr, TRCVIPCSSCTLR);
 
-	for (i = 0; i < drvdata->nrseqstate - 1; i++)
+	for (i = 0; i < drvdata->nr_seq_ctrls; i++)
 		etm4x_relaxed_write32(csa, state->trcseqevr[i], TRCSEQEVRn(i));
 
 	if (drvdata->nrseqstate) {
diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
index e9eeea6240d55..cc6cdd3ae29d5 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
@@ -223,7 +223,7 @@ static ssize_t reset_store(struct device *dev,
 	config->vipcssctlr = 0x0;
 
 	/* Disable seq events */
-	for (i = 0; i < drvdata->nrseqstate-1; i++)
+	for (i = 0; i < drvdata->nr_seq_ctrls; i++)
 		config->seq_ctrl[i] = 0x0;
 	config->seq_rst = 0x0;
 	config->seq_state = 0x0;
@@ -1395,9 +1395,11 @@ static ssize_t seq_idx_store(struct device *dev,
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
 	struct etmv4_config *config = &drvdata->config;
 
+	if (!drvdata->nr_seq_ctrls)
+		return -ENOTSUPP;
 	if (kstrtoul(buf, 16, &val))
 		return -EINVAL;
-	if (val >= drvdata->nrseqstate - 1)
+	if (val >= drvdata->nr_seq_ctrls)
 		return -EINVAL;
 
 	/*
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 0287d19ce12ed..d2ece9691d3a2 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -570,6 +570,7 @@
 #define ETM_MAX_NR_PE			8
 #define ETMv4_MAX_CNTR			4
 #define ETM_MAX_SEQ_STATES		4
+#define ETM_MAX_SEQ_TRANSITIONS		3
 #define ETM_MAX_EXT_INP_SEL		4
 #define ETM_MAX_EXT_INP			256
 #define ETM_MAX_EXT_OUT			4
@@ -833,7 +834,7 @@ struct etmv4_config {
 	u32				vipcssctlr;
 	u8				seq_idx;
 	u8				syncfreq;
-	u32				seq_ctrl[ETM_MAX_SEQ_STATES];
+	u32				seq_ctrl[ETM_MAX_SEQ_TRANSITIONS];
 	u32				seq_rst;
 	u32				seq_state;
 	u8				cntr_idx;
@@ -884,7 +885,7 @@ struct etmv4_save_state {
 	u32	trcvissctlr;
 	u32	trcvipcssctlr;
 
-	u32	trcseqevr[ETM_MAX_SEQ_STATES];
+	u32	trcseqevr[ETM_MAX_SEQ_TRANSITIONS];
 	u32	trcseqrstevr;
 	u32	trcseqstr;
 	u32	trcextinselr;
@@ -937,6 +938,7 @@ struct etmv4_save_state {
  * @numcidc:	Number of contextID comparators.
  * @numvmidc:	Number of VMID comparators.
  * @nrseqstate: The number of sequencer states that are implemented.
+ * @nr_seq_ctrls: The number of sequence state transition control registers.
  * @nr_event:	Indicates how many events the trace unit support.
  * @nr_resource:The number of resource selection pairs available for tracing.
  * @nr_ss_cmp:	Number of single-shot comparator controls that are available.
@@ -1002,6 +1004,7 @@ struct etmv4_drvdata {
 	u8				numextinsel;
 	u8				numvmidc;
 	u8				nrseqstate;
+	u8				nr_seq_ctrls;
 	u8				nr_event;
 	u8				nr_resource;
 	u8				nr_ss_cmp;
-- 
2.53.0



