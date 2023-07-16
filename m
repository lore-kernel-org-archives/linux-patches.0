Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547148F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0CDC433C7;
	Sun, 16 Jul 2023 20:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539939;
	bh=+0vuHoE+7FFMfKChqxW+IDHW3lZxmwJbVksuzVFzt0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXNY+3F/4XN3WeDmVKxcg13HeQzz5RDo9bu07YMt0DVPreCF7snPnTbn9Ug/jkZf/
	 4QX8v9+vG//3sTrCgCTyBx/ILbbzPZbdZoEuHUIMDau/IpyMhsve5lyYHWuWBkoqQv
	 OUVu5ABq5dj2O8QSJRBDsO/Q/fhPK230ZKM/uY7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Polimera <quic_vpolimer@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 185/591] drm/msm/disp/dpu: get timing engine status from intf status register
Date: Sun, 16 Jul 2023 21:45:24 +0200
Message-ID: <20230716194928.656467480@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vinod Polimera <quic_vpolimer@quicinc.com>

[ Upstream commit e3969eadc8ee78a5bdca65b8ed0a421a359e4090 ]

Recommended way of reading the interface timing gen status is via
status register. Timing gen status register will give a reliable status
of the interface especially during ON/OFF transitions. This support was
added from DPU version 5.0.0.

Signed-off-by: Vinod Polimera <quic_vpolimer@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/524724/
Link: https://lore.kernel.org/r/1677774797-31063-6-git-send-email-quic_vpolimer@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: a7129231edf3 ("drm/msm/dpu: Set DPU_DATA_HCTL_EN for in INTF_SC7180_MASK")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c |  3 ++-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h | 12 +++++++-----
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c    |  8 +++++++-
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index 32a3c42ec45b1..715c7a254632b 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -79,7 +79,8 @@
 
 #define INTF_SDM845_MASK (0)
 
-#define INTF_SC7180_MASK BIT(DPU_INTF_INPUT_CTRL) | BIT(DPU_INTF_TE)
+#define INTF_SC7180_MASK \
+	(BIT(DPU_INTF_INPUT_CTRL) | BIT(DPU_INTF_TE) | BIT(DPU_INTF_STATUS_SUPPORTED))
 
 #define INTF_SC7280_MASK INTF_SC7180_MASK | BIT(DPU_DATA_HCTL_EN)
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h
index 38aa38ab15685..77c46ce5a22f9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h
@@ -203,17 +203,19 @@ enum {
 
 /**
  * INTF sub-blocks
- * @DPU_INTF_INPUT_CTRL         Supports the setting of pp block from which
- *                              pixel data arrives to this INTF
- * @DPU_INTF_TE                 INTF block has TE configuration support
- * @DPU_DATA_HCTL_EN            Allows data to be transferred at different rate
-                                than video timing
+ * @DPU_INTF_INPUT_CTRL             Supports the setting of pp block from which
+ *                                  pixel data arrives to this INTF
+ * @DPU_INTF_TE                     INTF block has TE configuration support
+ * @DPU_DATA_HCTL_EN                Allows data to be transferred at different rate
+ *                                  than video timing
+ * @DPU_INTF_STATUS_SUPPORTED       INTF block has INTF_STATUS register
  * @DPU_INTF_MAX
  */
 enum {
 	DPU_INTF_INPUT_CTRL = 0x1,
 	DPU_INTF_TE,
 	DPU_DATA_HCTL_EN,
+	DPU_INTF_STATUS_SUPPORTED,
 	DPU_INTF_MAX
 };
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
index b2a94b9a3e987..b9dddf576c029 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
@@ -57,6 +57,7 @@
 #define   INTF_PROG_FETCH_START         0x170
 #define   INTF_PROG_ROT_START           0x174
 #define   INTF_MUX                      0x25C
+#define   INTF_STATUS                   0x26C
 
 #define INTF_CFG_ACTIVE_H_EN	BIT(29)
 #define INTF_CFG_ACTIVE_V_EN	BIT(30)
@@ -292,8 +293,13 @@ static void dpu_hw_intf_get_status(
 		struct intf_status *s)
 {
 	struct dpu_hw_blk_reg_map *c = &intf->hw;
+	unsigned long cap = intf->cap->features;
+
+	if (cap & BIT(DPU_INTF_STATUS_SUPPORTED))
+		s->is_en = DPU_REG_READ(c, INTF_STATUS) & BIT(0);
+	else
+		s->is_en = DPU_REG_READ(c, INTF_TIMING_ENGINE_EN);
 
-	s->is_en = DPU_REG_READ(c, INTF_TIMING_ENGINE_EN);
 	s->is_prog_fetch_en = !!(DPU_REG_READ(c, INTF_CONFIG) & BIT(31));
 	if (s->is_en) {
 		s->frame_count = DPU_REG_READ(c, INTF_FRAME_COUNT);
-- 
2.39.2



