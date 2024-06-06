Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CFE1C53B7;
	Thu,  6 Jun 2024 14:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683682; cv=none; b=SO0AMuzpCx2sLB2q735QKhm9F/WzsuyPJ9Rn2S+nK4rayRsbCRsMbUZperO+G8h9Oc+Oowt4PS5GczMq1o4+SxQ2WrkGwTA1VIFN2FzGhnch6F0we+4XZYwPCyipx1r3m1irR4qIA4bStYfjNvdGJB+iWBGBwwHoOM4OYXooPWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683682; c=relaxed/simple;
	bh=U3K7XE/lF6wqcEzJgUlHb2G9SprdHt2yMVFiHUHJe7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QefcBFCO9X8TKfTWwbL8gE3q7vEKMpx8IBJ9fztfRZGvxYDTbKUEQ1XRFddrj4JyzjFh1QUWV1A+Mo5nYp1CwYp0ujbRX1mkO8b2Gx0Gule/NzCsBu9z3omMm40Mco/axpiPgc1H6o469PUQDJrhJdvMRTmtc5Ma+lAh9Yp4nBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQSwlQFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQSwlQFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11566C32786;
	Thu,  6 Jun 2024 14:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683682;
	bh=U3K7XE/lF6wqcEzJgUlHb2G9SprdHt2yMVFiHUHJe7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQSwlQFuCVmnOn63R6kj6Pcoqyctjs6sF3zYfFdWSOeHAj6zfUh/AECluuemgNbif
	 xJ4sI8LHcHYAr4/LiA/NmDhN4YppN3dKcggxJNNvd8amUuqnNNSgnEhu2jZx6WrlOk
	 Zzo1AS0O+f2OZzpWFWP+S5N9HLX86kHj5iWWBh0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 584/744] drm/msm/dpu: add helper to get IRQ-related data
Date: Thu,  6 Jun 2024 16:04:16 +0200
Message-ID: <20240606131751.195890288@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit ea4842ed62f3556cf0a90f19d911ee03a4d0c844 ]

In preparation to reworking IRQ indices, move irq_tbl access to
a separate helper.

Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/550931/
Link: https://lore.kernel.org/r/20230802100426.4184892-5-dmitry.baryshkov@linaro.org
Stable-dep-of: 530f272053a5 ("drm/msm/dpu: Add callback function pointer check before its call")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c | 48 +++++++++++++------
 .../gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.h | 12 +++--
 2 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
index 81d03b6c67d12..14d374de30c52 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
@@ -206,6 +206,12 @@ static inline bool dpu_core_irq_is_valid(struct dpu_hw_intr *intr,
 	return irq_idx >= 0 && irq_idx < intr->total_irqs;
 }
 
+static inline struct dpu_hw_intr_entry *dpu_core_irq_get_entry(struct dpu_hw_intr *intr,
+							       int irq_idx)
+{
+	return &intr->irq_tbl[irq_idx];
+}
+
 /**
  * dpu_core_irq_callback_handler - dispatch core interrupts
  * @dpu_kms:		Pointer to DPU's KMS structure
@@ -213,17 +219,19 @@ static inline bool dpu_core_irq_is_valid(struct dpu_hw_intr *intr,
  */
 static void dpu_core_irq_callback_handler(struct dpu_kms *dpu_kms, int irq_idx)
 {
+	struct dpu_hw_intr_entry *irq_entry = dpu_core_irq_get_entry(dpu_kms->hw_intr, irq_idx);
+
 	VERB("irq_idx=%d\n", irq_idx);
 
-	if (!dpu_kms->hw_intr->irq_tbl[irq_idx].cb)
+	if (!irq_entry->cb)
 		DRM_ERROR("no registered cb, idx:%d\n", irq_idx);
 
-	atomic_inc(&dpu_kms->hw_intr->irq_tbl[irq_idx].count);
+	atomic_inc(&irq_entry->count);
 
 	/*
 	 * Perform registered function callback
 	 */
-	dpu_kms->hw_intr->irq_tbl[irq_idx].cb(dpu_kms->hw_intr->irq_tbl[irq_idx].arg);
+	irq_entry->cb(irq_entry->arg);
 }
 
 irqreturn_t dpu_core_irq(struct msm_kms *kms)
@@ -510,6 +518,7 @@ int dpu_core_irq_register_callback(struct dpu_kms *dpu_kms, int irq_idx,
 		void (*irq_cb)(void *arg),
 		void *irq_arg)
 {
+	struct dpu_hw_intr_entry *irq_entry;
 	unsigned long irq_flags;
 	int ret;
 
@@ -527,15 +536,16 @@ int dpu_core_irq_register_callback(struct dpu_kms *dpu_kms, int irq_idx,
 
 	spin_lock_irqsave(&dpu_kms->hw_intr->irq_lock, irq_flags);
 
-	if (unlikely(WARN_ON(dpu_kms->hw_intr->irq_tbl[irq_idx].cb))) {
+	irq_entry = dpu_core_irq_get_entry(dpu_kms->hw_intr, irq_idx);
+	if (unlikely(WARN_ON(irq_entry->cb))) {
 		spin_unlock_irqrestore(&dpu_kms->hw_intr->irq_lock, irq_flags);
 
 		return -EBUSY;
 	}
 
 	trace_dpu_core_irq_register_callback(irq_idx, irq_cb);
-	dpu_kms->hw_intr->irq_tbl[irq_idx].arg = irq_arg;
-	dpu_kms->hw_intr->irq_tbl[irq_idx].cb = irq_cb;
+	irq_entry->arg = irq_arg;
+	irq_entry->cb = irq_cb;
 
 	ret = dpu_hw_intr_enable_irq_locked(
 				dpu_kms->hw_intr,
@@ -552,6 +562,7 @@ int dpu_core_irq_register_callback(struct dpu_kms *dpu_kms, int irq_idx,
 
 int dpu_core_irq_unregister_callback(struct dpu_kms *dpu_kms, int irq_idx)
 {
+	struct dpu_hw_intr_entry *irq_entry;
 	unsigned long irq_flags;
 	int ret;
 
@@ -570,8 +581,9 @@ int dpu_core_irq_unregister_callback(struct dpu_kms *dpu_kms, int irq_idx)
 		DPU_ERROR("Fail to disable IRQ for irq_idx:%d: %d\n",
 					irq_idx, ret);
 
-	dpu_kms->hw_intr->irq_tbl[irq_idx].cb = NULL;
-	dpu_kms->hw_intr->irq_tbl[irq_idx].arg = NULL;
+	irq_entry = dpu_core_irq_get_entry(dpu_kms->hw_intr, irq_idx);
+	irq_entry->cb = NULL;
+	irq_entry->arg = NULL;
 
 	spin_unlock_irqrestore(&dpu_kms->hw_intr->irq_lock, irq_flags);
 
@@ -584,14 +596,16 @@ int dpu_core_irq_unregister_callback(struct dpu_kms *dpu_kms, int irq_idx)
 static int dpu_debugfs_core_irq_show(struct seq_file *s, void *v)
 {
 	struct dpu_kms *dpu_kms = s->private;
+	struct dpu_hw_intr_entry *irq_entry;
 	unsigned long irq_flags;
 	int i, irq_count;
 	void *cb;
 
 	for (i = 0; i < dpu_kms->hw_intr->total_irqs; i++) {
 		spin_lock_irqsave(&dpu_kms->hw_intr->irq_lock, irq_flags);
-		irq_count = atomic_read(&dpu_kms->hw_intr->irq_tbl[i].count);
-		cb = dpu_kms->hw_intr->irq_tbl[i].cb;
+		irq_entry = dpu_core_irq_get_entry(dpu_kms->hw_intr, i);
+		irq_count = atomic_read(&irq_entry->count);
+		cb = irq_entry->cb;
 		spin_unlock_irqrestore(&dpu_kms->hw_intr->irq_lock, irq_flags);
 
 		if (irq_count || cb)
@@ -614,6 +628,7 @@ void dpu_debugfs_core_irq_init(struct dpu_kms *dpu_kms,
 void dpu_core_irq_preinstall(struct msm_kms *kms)
 {
 	struct dpu_kms *dpu_kms = to_dpu_kms(kms);
+	struct dpu_hw_intr_entry *irq_entry;
 	int i;
 
 	pm_runtime_get_sync(&dpu_kms->pdev->dev);
@@ -621,22 +636,27 @@ void dpu_core_irq_preinstall(struct msm_kms *kms)
 	dpu_disable_all_irqs(dpu_kms);
 	pm_runtime_put_sync(&dpu_kms->pdev->dev);
 
-	for (i = 0; i < dpu_kms->hw_intr->total_irqs; i++)
-		atomic_set(&dpu_kms->hw_intr->irq_tbl[i].count, 0);
+	for (i = 0; i < dpu_kms->hw_intr->total_irqs; i++) {
+		irq_entry = dpu_core_irq_get_entry(dpu_kms->hw_intr, i);
+		atomic_set(&irq_entry->count, 0);
+	}
 }
 
 void dpu_core_irq_uninstall(struct msm_kms *kms)
 {
 	struct dpu_kms *dpu_kms = to_dpu_kms(kms);
+	struct dpu_hw_intr_entry *irq_entry;
 	int i;
 
 	if (!dpu_kms->hw_intr)
 		return;
 
 	pm_runtime_get_sync(&dpu_kms->pdev->dev);
-	for (i = 0; i < dpu_kms->hw_intr->total_irqs; i++)
-		if (dpu_kms->hw_intr->irq_tbl[i].cb)
+	for (i = 0; i < dpu_kms->hw_intr->total_irqs; i++) {
+		irq_entry = dpu_core_irq_get_entry(dpu_kms->hw_intr, i);
+		if (irq_entry->cb)
 			DPU_ERROR("irq_idx=%d still enabled/registered\n", i);
+	}
 
 	dpu_clear_irqs(dpu_kms);
 	dpu_disable_all_irqs(dpu_kms);
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.h
index e2b00dd326193..391fb268ad903 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.h
@@ -38,6 +38,12 @@ enum dpu_hw_intr_reg {
 
 #define DPU_IRQ_IDX(reg_idx, offset)	(reg_idx * 32 + offset)
 
+struct dpu_hw_intr_entry {
+	void (*cb)(void *arg);
+	void *arg;
+	atomic_t count;
+};
+
 /**
  * struct dpu_hw_intr: hw interrupts handling data structure
  * @hw:               virtual address mapping
@@ -57,11 +63,7 @@ struct dpu_hw_intr {
 	unsigned long irq_mask;
 	const struct dpu_intr_reg *intr_set;
 
-	struct {
-		void (*cb)(void *arg);
-		void *arg;
-		atomic_t count;
-	} irq_tbl[];
+	struct dpu_hw_intr_entry irq_tbl[];
 };
 
 /**
-- 
2.43.0



