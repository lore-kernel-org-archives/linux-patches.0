Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6978F1C6161;
	Thu,  6 Jun 2024 14:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683683; cv=none; b=k6rQGem9U+bgi+wZUVkwjL+cnEfQ/luTRGGCPWlrE+UtMovUzeqaf3dUBqG9j2gxcB2Jf7NwKlt4Bfb7J3GluKGTU/eiyiq+zuXlzS/jJ2VZlpQ/aDKLZz2gWB/CkUA69FUSXruNAoK0JWGWndQ8WvefLwl+b+Xz1Sri3p2jcUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683683; c=relaxed/simple;
	bh=j617FGwIdVfWRJnWUJYrEVgBov1b1on/V0NeRoXeL9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxgiKI8MA5dfCpoPJXjPkL80JrLflL70frlPHR2m/AL2Gl2c37M+qkdzoYKuyyZtmyjzzeWsaDyBlvh2v9PmtIOaLjDgMAJIYK4Y3k7hTygn5oDJcw3804JvaRxhPdzGK3xCxMHXIwWtJ58uaVEJE2IU1T3sUVjBo0kxFjGlblQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+GkUU0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+GkUU0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA70C32781;
	Thu,  6 Jun 2024 14:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683683;
	bh=j617FGwIdVfWRJnWUJYrEVgBov1b1on/V0NeRoXeL9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+GkUU0pIvhwEaofsqus5COAoOUjkPZ+xwUZgXYOo+fQqzDCEs6Ioqxk+hb+gw4Sj
	 EMKbydhpOuYcYMdfvcIbjrsIeB2X9g2GPMX7HQrMtxQwB3bcQIZMPXfjQXigjGOqXL
	 82Jdr0+VtkFE9Ym9c6eQiDPc3IANHJP2DBZCOmcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 586/744] drm/msm/dpu: stop using raw IRQ indices in the kernel output
Date: Thu,  6 Jun 2024 16:04:18 +0200
Message-ID: <20240606131751.260005471@linuxfoundation.org>
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

[ Upstream commit 6893199183f836e1ff452082f0f9d068364b2f17 ]

In preparation to reworking IRQ indcies, stop using raw IRQ indices in
kernel output (both printk and debugfs). Instead use a pair of register
index and bit. This corresponds closer to the values in HW catalog.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/550933/
Link: https://lore.kernel.org/r/20230802100426.4184892-7-dmitry.baryshkov@linaro.org
Stable-dep-of: 530f272053a5 ("drm/msm/dpu: Add callback function pointer check before its call")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c   | 26 +++++-----
 .../gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c | 51 +++++++++++--------
 .../gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.h |  2 +
 3 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 3961b514a9a18..5fb7e2e10801d 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -357,7 +357,7 @@ static int dpu_encoder_helper_wait_event_timeout(int32_t drm_id,
 		u32 irq_idx, struct dpu_encoder_wait_info *info);
 
 int dpu_encoder_helper_wait_for_irq(struct dpu_encoder_phys *phys_enc,
-		int irq,
+		int irq_idx,
 		void (*func)(void *arg),
 		struct dpu_encoder_wait_info *wait_info)
 {
@@ -372,36 +372,36 @@ int dpu_encoder_helper_wait_for_irq(struct dpu_encoder_phys *phys_enc,
 
 	/* return EWOULDBLOCK since we know the wait isn't necessary */
 	if (phys_enc->enable_state == DPU_ENC_DISABLED) {
-		DRM_ERROR("encoder is disabled id=%u, callback=%ps, irq=%d\n",
+		DRM_ERROR("encoder is disabled id=%u, callback=%ps, IRQ=[%d, %d]\n",
 			  DRMID(phys_enc->parent), func,
-			  irq);
+			  DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
 		return -EWOULDBLOCK;
 	}
 
-	if (irq < 0) {
+	if (irq_idx < 0) {
 		DRM_DEBUG_KMS("skip irq wait id=%u, callback=%ps\n",
 			      DRMID(phys_enc->parent), func);
 		return 0;
 	}
 
-	DRM_DEBUG_KMS("id=%u, callback=%ps, irq=%d, pp=%d, pending_cnt=%d\n",
+	DRM_DEBUG_KMS("id=%u, callback=%ps, IRQ=[%d, %d], pp=%d, pending_cnt=%d\n",
 		      DRMID(phys_enc->parent), func,
-		      irq, phys_enc->hw_pp->idx - PINGPONG_0,
+		      DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx), phys_enc->hw_pp->idx - PINGPONG_0,
 		      atomic_read(wait_info->atomic_cnt));
 
 	ret = dpu_encoder_helper_wait_event_timeout(
 			DRMID(phys_enc->parent),
-			irq,
+			irq_idx,
 			wait_info);
 
 	if (ret <= 0) {
-		irq_status = dpu_core_irq_read(phys_enc->dpu_kms, irq);
+		irq_status = dpu_core_irq_read(phys_enc->dpu_kms, irq_idx);
 		if (irq_status) {
 			unsigned long flags;
 
-			DRM_DEBUG_KMS("irq not triggered id=%u, callback=%ps, irq=%d, pp=%d, atomic_cnt=%d\n",
+			DRM_DEBUG_KMS("IRQ=[%d, %d] not triggered id=%u, callback=%ps, pp=%d, atomic_cnt=%d\n",
+				      DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx),
 				      DRMID(phys_enc->parent), func,
-				      irq,
 				      phys_enc->hw_pp->idx - PINGPONG_0,
 				      atomic_read(wait_info->atomic_cnt));
 			local_irq_save(flags);
@@ -410,16 +410,16 @@ int dpu_encoder_helper_wait_for_irq(struct dpu_encoder_phys *phys_enc,
 			ret = 0;
 		} else {
 			ret = -ETIMEDOUT;
-			DRM_DEBUG_KMS("irq timeout id=%u, callback=%ps, irq=%d, pp=%d, atomic_cnt=%d\n",
+			DRM_DEBUG_KMS("IRQ=[%d, %d] timeout id=%u, callback=%ps, pp=%d, atomic_cnt=%d\n",
+				      DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx),
 				      DRMID(phys_enc->parent), func,
-				      irq,
 				      phys_enc->hw_pp->idx - PINGPONG_0,
 				      atomic_read(wait_info->atomic_cnt));
 		}
 	} else {
 		ret = 0;
 		trace_dpu_enc_irq_wait_success(DRMID(phys_enc->parent),
-			func, irq,
+			func, irq_idx,
 			phys_enc->hw_pp->idx - PINGPONG_0,
 			atomic_read(wait_info->atomic_cnt));
 	}
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
index 3d6d13407dded..c413e9917d7eb 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
@@ -197,8 +197,7 @@ static const struct dpu_intr_reg dpu_intr_set_7xxx[] = {
 	},
 };
 
-#define DPU_IRQ_REG(irq_idx)	(irq_idx / 32)
-#define DPU_IRQ_MASK(irq_idx)	(BIT(irq_idx % 32))
+#define DPU_IRQ_MASK(irq_idx)	(BIT(DPU_IRQ_BIT(irq_idx)))
 
 static inline bool dpu_core_irq_is_valid(int irq_idx)
 {
@@ -220,10 +219,11 @@ static void dpu_core_irq_callback_handler(struct dpu_kms *dpu_kms, int irq_idx)
 {
 	struct dpu_hw_intr_entry *irq_entry = dpu_core_irq_get_entry(dpu_kms->hw_intr, irq_idx);
 
-	VERB("irq_idx=%d\n", irq_idx);
+	VERB("IRQ=[%d, %d]\n", DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
 
 	if (!irq_entry->cb)
-		DRM_ERROR("no registered cb, idx:%d\n", irq_idx);
+		DRM_ERROR("no registered cb, IRQ=[%d, %d]\n",
+			  DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
 
 	atomic_inc(&irq_entry->count);
 
@@ -305,7 +305,8 @@ static int dpu_hw_intr_enable_irq_locked(struct dpu_hw_intr *intr, int irq_idx)
 		return -EINVAL;
 
 	if (!dpu_core_irq_is_valid(irq_idx)) {
-		pr_err("invalid IRQ index: [%d]\n", irq_idx);
+		pr_err("invalid IRQ=[%d, %d]\n",
+		       DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
 		return -EINVAL;
 	}
 
@@ -341,7 +342,8 @@ static int dpu_hw_intr_enable_irq_locked(struct dpu_hw_intr *intr, int irq_idx)
 		intr->cache_irq_mask[reg_idx] = cache_irq_mask;
 	}
 
-	pr_debug("DPU IRQ %d %senabled: MASK:0x%.8lx, CACHE-MASK:0x%.8x\n", irq_idx, dbgstr,
+	pr_debug("DPU IRQ=[%d, %d] %senabled: MASK:0x%.8lx, CACHE-MASK:0x%.8x\n",
+		 DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx), dbgstr,
 			DPU_IRQ_MASK(irq_idx), cache_irq_mask);
 
 	return 0;
@@ -358,7 +360,8 @@ static int dpu_hw_intr_disable_irq_locked(struct dpu_hw_intr *intr, int irq_idx)
 		return -EINVAL;
 
 	if (!dpu_core_irq_is_valid(irq_idx)) {
-		pr_err("invalid IRQ index: [%d]\n", irq_idx);
+		pr_err("invalid IRQ=[%d, %d]\n",
+		       DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
 		return -EINVAL;
 	}
 
@@ -390,7 +393,8 @@ static int dpu_hw_intr_disable_irq_locked(struct dpu_hw_intr *intr, int irq_idx)
 		intr->cache_irq_mask[reg_idx] = cache_irq_mask;
 	}
 
-	pr_debug("DPU IRQ %d %sdisabled: MASK:0x%.8lx, CACHE-MASK:0x%.8x\n", irq_idx, dbgstr,
+	pr_debug("DPU IRQ=[%d, %d] %sdisabled: MASK:0x%.8lx, CACHE-MASK:0x%.8x\n",
+		 DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx), dbgstr,
 			DPU_IRQ_MASK(irq_idx), cache_irq_mask);
 
 	return 0;
@@ -443,7 +447,7 @@ u32 dpu_core_irq_read(struct dpu_kms *dpu_kms, int irq_idx)
 		return 0;
 
 	if (!dpu_core_irq_is_valid(irq_idx)) {
-		pr_err("invalid IRQ index: [%d]\n", irq_idx);
+		pr_err("invalid IRQ=[%d, %d]\n", DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
 		return 0;
 	}
 
@@ -519,16 +523,19 @@ int dpu_core_irq_register_callback(struct dpu_kms *dpu_kms, int irq_idx,
 	int ret;
 
 	if (!irq_cb) {
-		DPU_ERROR("invalid ird_idx:%d irq_cb:%ps\n", irq_idx, irq_cb);
+		DPU_ERROR("invalid IRQ=[%d, %d] irq_cb:%ps\n",
+			  DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx), irq_cb);
 		return -EINVAL;
 	}
 
 	if (!dpu_core_irq_is_valid(irq_idx)) {
-		DPU_ERROR("invalid IRQ index: [%d]\n", irq_idx);
+		DPU_ERROR("invalid IRQ=[%d, %d]\n",
+			  DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
 		return -EINVAL;
 	}
 
-	VERB("[%pS] irq_idx=%d\n", __builtin_return_address(0), irq_idx);
+	VERB("[%pS] IRQ=[%d, %d]\n", __builtin_return_address(0),
+	     DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
 
 	spin_lock_irqsave(&dpu_kms->hw_intr->irq_lock, irq_flags);
 
@@ -547,8 +554,8 @@ int dpu_core_irq_register_callback(struct dpu_kms *dpu_kms, int irq_idx,
 				dpu_kms->hw_intr,
 				irq_idx);
 	if (ret)
-		DPU_ERROR("Fail to enable IRQ for irq_idx:%d\n",
-					irq_idx);
+		DPU_ERROR("Failed/ to enable IRQ=[%d, %d]\n",
+			  DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
 	spin_unlock_irqrestore(&dpu_kms->hw_intr->irq_lock, irq_flags);
 
 	trace_dpu_irq_register_success(irq_idx);
@@ -563,19 +570,21 @@ int dpu_core_irq_unregister_callback(struct dpu_kms *dpu_kms, int irq_idx)
 	int ret;
 
 	if (!dpu_core_irq_is_valid(irq_idx)) {
-		DPU_ERROR("invalid IRQ index: [%d]\n", irq_idx);
+		DPU_ERROR("invalid IRQ=[%d, %d]\n",
+			  DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
 		return -EINVAL;
 	}
 
-	VERB("[%pS] irq_idx=%d\n", __builtin_return_address(0), irq_idx);
+	VERB("[%pS] IRQ=[%d, %d]\n", __builtin_return_address(0),
+	     DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
 
 	spin_lock_irqsave(&dpu_kms->hw_intr->irq_lock, irq_flags);
 	trace_dpu_core_irq_unregister_callback(irq_idx);
 
 	ret = dpu_hw_intr_disable_irq_locked(dpu_kms->hw_intr, irq_idx);
 	if (ret)
-		DPU_ERROR("Fail to disable IRQ for irq_idx:%d: %d\n",
-					irq_idx, ret);
+		DPU_ERROR("Failed to disable IRQ=[%d, %d]: %d\n",
+			  DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx), ret);
 
 	irq_entry = dpu_core_irq_get_entry(dpu_kms->hw_intr, irq_idx);
 	irq_entry->cb = NULL;
@@ -605,7 +614,8 @@ static int dpu_debugfs_core_irq_show(struct seq_file *s, void *v)
 		spin_unlock_irqrestore(&dpu_kms->hw_intr->irq_lock, irq_flags);
 
 		if (irq_count || cb)
-			seq_printf(s, "idx:%d irq:%d cb:%ps\n", i, irq_count, cb);
+			seq_printf(s, "IRQ=[%d, %d] count:%d cb:%ps\n",
+				   DPU_IRQ_REG(i), DPU_IRQ_BIT(i), irq_count, cb);
 	}
 
 	return 0;
@@ -651,7 +661,8 @@ void dpu_core_irq_uninstall(struct msm_kms *kms)
 	for (i = 0; i < DPU_NUM_IRQS; i++) {
 		irq_entry = dpu_core_irq_get_entry(dpu_kms->hw_intr, i);
 		if (irq_entry->cb)
-			DPU_ERROR("irq_idx=%d still enabled/registered\n", i);
+			DPU_ERROR("IRQ=[%d, %d] still enabled/registered\n",
+				  DPU_IRQ_REG(i), DPU_IRQ_BIT(i));
 	}
 
 	dpu_clear_irqs(dpu_kms);
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.h
index bb775b6a24327..9df5d6e737a11 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.h
@@ -37,6 +37,8 @@ enum dpu_hw_intr_reg {
 #define MDP_INTFn_INTR(intf)	(MDP_INTF0_INTR + (intf - INTF_0))
 
 #define DPU_IRQ_IDX(reg_idx, offset)	(reg_idx * 32 + offset)
+#define DPU_IRQ_REG(irq_idx)	(irq_idx / 32)
+#define DPU_IRQ_BIT(irq_idx)	(irq_idx % 32)
 
 #define DPU_NUM_IRQS		(MDP_INTR_MAX * 32)
 
-- 
2.43.0



