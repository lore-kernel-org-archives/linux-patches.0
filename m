Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA171A0DD5;
	Thu,  6 Jun 2024 14:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683681; cv=none; b=Tkj+R3mYZ67P35kVqEahTDStjX531B8a0iBuBsYEFp+ZpCiSNWf7bYGCZfL1ZaFJIXDYzdMsyYUGdJevEV3ESq69JLbMUzvpoA+G+twqs1gTeeB7h1N6GEQBrB4Qx7gTXfHIqos2qlh+lVVPWfU4fe9XeR9UglfVx33k56SUgeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683681; c=relaxed/simple;
	bh=8zzOKdlD46darN+d15jyang52TPJ22ZAmOfRohPRyVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvQelUJxye9CyF5UAKofmSHc0X3nkVo6uC/vmR1PaAlwqxjxIfonjY88d449NCwovXhnFtkwhEFIgBSzFqAh0rnY/FUhqrq5d0fbGBEmPq9yAbytKnUpxxNC6eNabP5PBPwZ4CUuDLt5A/CpB8uy/ZCck06eKLdA63+Sn+QUdOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQDsaD4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQDsaD4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9577EC32786;
	Thu,  6 Jun 2024 14:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683681;
	bh=8zzOKdlD46darN+d15jyang52TPJ22ZAmOfRohPRyVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQDsaD4+Z9oTlEDeHqIRayjaHQZaauYIW1oydi7ebguar+JpPWKVid/aPiL3qYHNO
	 PC0zehK2yw5DHKBYTUPAPmxGEoGHEx33+cxtT5UrIXsR+lCwoNf3QPvO9/rApo8zTO
	 Rp7dtItuqeYBy0XLBmAa36oVZTmeWFdqrqQaWkiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 583/744] drm/msm/dpu: extract dpu_core_irq_is_valid() helper
Date: Thu,  6 Jun 2024 16:04:15 +0200
Message-ID: <20240606131751.155760314@linuxfoundation.org>
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

[ Upstream commit a65264833690d1280b901e3fe8e2825a44b3502c ]

In preparation to reworking IRQ indices, move irq_idx validation to
a separate helper.

Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/550929/
Link: https://lore.kernel.org/r/20230802100426.4184892-4-dmitry.baryshkov@linaro.org
Stable-dep-of: 530f272053a5 ("drm/msm/dpu: Add callback function pointer check before its call")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
index 01a9ccfcd54bf..81d03b6c67d12 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
@@ -200,6 +200,12 @@ static const struct dpu_intr_reg dpu_intr_set_7xxx[] = {
 #define DPU_IRQ_REG(irq_idx)	(irq_idx / 32)
 #define DPU_IRQ_MASK(irq_idx)	(BIT(irq_idx % 32))
 
+static inline bool dpu_core_irq_is_valid(struct dpu_hw_intr *intr,
+					 int irq_idx)
+{
+	return irq_idx >= 0 && irq_idx < intr->total_irqs;
+}
+
 /**
  * dpu_core_irq_callback_handler - dispatch core interrupts
  * @dpu_kms:		Pointer to DPU's KMS structure
@@ -291,7 +297,7 @@ static int dpu_hw_intr_enable_irq_locked(struct dpu_hw_intr *intr, int irq_idx)
 	if (!intr)
 		return -EINVAL;
 
-	if (irq_idx < 0 || irq_idx >= intr->total_irqs) {
+	if (!dpu_core_irq_is_valid(intr, irq_idx)) {
 		pr_err("invalid IRQ index: [%d]\n", irq_idx);
 		return -EINVAL;
 	}
@@ -344,7 +350,7 @@ static int dpu_hw_intr_disable_irq_locked(struct dpu_hw_intr *intr, int irq_idx)
 	if (!intr)
 		return -EINVAL;
 
-	if (irq_idx < 0 || irq_idx >= intr->total_irqs) {
+	if (!dpu_core_irq_is_valid(intr, irq_idx)) {
 		pr_err("invalid IRQ index: [%d]\n", irq_idx);
 		return -EINVAL;
 	}
@@ -429,13 +435,7 @@ u32 dpu_core_irq_read(struct dpu_kms *dpu_kms, int irq_idx)
 	if (!intr)
 		return 0;
 
-	if (irq_idx < 0) {
-		DPU_ERROR("[%pS] invalid irq_idx=%d\n",
-				__builtin_return_address(0), irq_idx);
-		return 0;
-	}
-
-	if (irq_idx < 0 || irq_idx >= intr->total_irqs) {
+	if (!dpu_core_irq_is_valid(intr, irq_idx)) {
 		pr_err("invalid IRQ index: [%d]\n", irq_idx);
 		return 0;
 	}
@@ -518,7 +518,7 @@ int dpu_core_irq_register_callback(struct dpu_kms *dpu_kms, int irq_idx,
 		return -EINVAL;
 	}
 
-	if (irq_idx < 0 || irq_idx >= dpu_kms->hw_intr->total_irqs) {
+	if (!dpu_core_irq_is_valid(dpu_kms->hw_intr, irq_idx)) {
 		DPU_ERROR("invalid IRQ index: [%d]\n", irq_idx);
 		return -EINVAL;
 	}
@@ -555,7 +555,7 @@ int dpu_core_irq_unregister_callback(struct dpu_kms *dpu_kms, int irq_idx)
 	unsigned long irq_flags;
 	int ret;
 
-	if (irq_idx < 0 || irq_idx >= dpu_kms->hw_intr->total_irqs) {
+	if (!dpu_core_irq_is_valid(dpu_kms->hw_intr, irq_idx)) {
 		DPU_ERROR("invalid IRQ index: [%d]\n", irq_idx);
 		return -EINVAL;
 	}
-- 
2.43.0



