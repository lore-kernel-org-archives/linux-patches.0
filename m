Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E28224F6;
	Tue,  8 Apr 2025 11:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111184; cv=none; b=ZdcnqMBFxFotsG8icCIXo7uHnsRkYBZyESKhFoomyXu8SWLbgyUSE9F7ZI3pca70Pl1xwQew2eb9k2SvgeQXE5O5Fcv805tqFchjULTM/2wXMPnG/Jz7JuJeyeagpV4mWCCzZbHhvYdLArKT9Aotv5SmG3Z5gCH8p6z1X1NC4Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111184; c=relaxed/simple;
	bh=GaC5juWZeektVlPMuHSj7c5S7IrPd8klZALSTR54yjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkbYz/cwL8rlSAi6ylYOioXwI2rk4SUxazspYDeS6XbHYu9yN5YNXq8A4iS9EbmWqfmfhqSKqqBNOJYJDb4gY3jkZAEzCWC6BxnXGjaUgwsqgmuoFEsrNq1lVKZE/YLYZIvel+PxPVno40tFS25r1QOHikaQ+XWkte/VdvYW25w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li3joRmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li3joRmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F40C4CEE5;
	Tue,  8 Apr 2025 11:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111183;
	bh=GaC5juWZeektVlPMuHSj7c5S7IrPd8klZALSTR54yjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=li3joRmtOm0+dt6qGiPlV2iTAzbjmQ9KxHnp5R2ZNVAev3NdVxINM6q9u9O1iRJcR
	 LeyW+ehm4WvhveOPt1P91BWOYFAkbOPWymwrJV/qMop/uI6fftAUeF3rAuXDqXTJZ2
	 XYsuvMGttv733cje+dbF9YGfcqeY1CCjf+pqJRBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Danila Tikhonov <danila@jiaxyga.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 300/731] drm/msm/dpu: Fall back to a single DSC encoder (1:1:1) on small SoCs
Date: Tue,  8 Apr 2025 12:43:17 +0200
Message-ID: <20250408104921.256612555@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit b6090ffb30f3301d3831774f9c3e2f1b1141a399 ]

Some SoCs such as SC7280 (used in the Fairphone 5) have only a single
DSC "hard slice" encoder.  The current hardcoded use of 2:2:1 topology
(2 LM and 2 DSC for a single interface) make it impossible to use
Display Stream Compression panels with mainline, which is exactly what's
installed on the Fairphone 5.

By loosening the hardcoded `num_dsc = 2` to fall back to `num_dsc =
1` when the catalog only contains one entry, we can trivially support
this phone and unblock further panel enablement on mainline.  A few
more supporting changes in this patch ensure hardcoded constants of 2
DSC encoders are replaced to count or read back the actual number of
DSC hardware blocks that are enabled for the given virtual encoder.
Likewise DSC_MODE_SPLIT_PANEL can no longer be unconditionally enabled.

Cc: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Tested-by: Danila Tikhonov <danila@jiaxyga.com>
Patchwork: https://patchwork.freedesktop.org/patch/633318/
Link: https://lore.kernel.org/r/20250122-dpu-111-topology-v2-1-505e95964af9@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: d245ce568929 ("drm/msm/dpu: Remove arbitrary limit of 1 interface in DSC topology")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 47 +++++++++++----------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index ee7dacf8a1cb6..88591b6f9e350 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -622,9 +622,9 @@ bool dpu_encoder_use_dsc_merge(struct drm_encoder *drm_enc)
 		if (dpu_enc->phys_encs[i])
 			intf_count++;
 
-	/* See dpu_encoder_get_topology, we only support 2:2:1 topology */
-	if (dpu_enc->dsc)
-		num_dsc = 2;
+	for (i = 0; i < MAX_CHANNELS_PER_ENC; i++)
+		if (dpu_enc->hw_dsc[i])
+			num_dsc++;
 
 	return (num_dsc > 0) && (num_dsc > intf_count);
 }
@@ -686,13 +686,19 @@ static struct msm_display_topology dpu_encoder_get_topology(
 
 	if (dsc) {
 		/*
-		 * In case of Display Stream Compression (DSC), we would use
-		 * 2 DSC encoders, 2 layer mixers and 1 interface
-		 * this is power optimal and can drive up to (including) 4k
-		 * screens
+		 * Use 2 DSC encoders and 2 layer mixers per single interface
+		 * when Display Stream Compression (DSC) is enabled,
+		 * and when enough DSC blocks are available.
+		 * This is power-optimal and can drive up to (including) 4k
+		 * screens.
 		 */
-		topology.num_dsc = 2;
-		topology.num_lm = 2;
+		if (dpu_kms->catalog->dsc_count >= 2) {
+			topology.num_dsc = 2;
+			topology.num_lm = 2;
+		} else {
+			topology.num_dsc = 1;
+			topology.num_lm = 1;
+		}
 		topology.num_intf = 1;
 	}
 
@@ -2019,7 +2025,6 @@ static void dpu_encoder_dsc_pipe_cfg(struct dpu_hw_ctl *ctl,
 static void dpu_encoder_prep_dsc(struct dpu_encoder_virt *dpu_enc,
 				 struct drm_dsc_config *dsc)
 {
-	/* coding only for 2LM, 2enc, 1 dsc config */
 	struct dpu_encoder_phys *enc_master = dpu_enc->cur_master;
 	struct dpu_hw_ctl *ctl = enc_master->hw_ctl;
 	struct dpu_hw_dsc *hw_dsc[MAX_CHANNELS_PER_ENC];
@@ -2029,22 +2034,24 @@ static void dpu_encoder_prep_dsc(struct dpu_encoder_virt *dpu_enc,
 	int dsc_common_mode;
 	int pic_width;
 	u32 initial_lines;
+	int num_dsc = 0;
 	int i;
 
 	for (i = 0; i < MAX_CHANNELS_PER_ENC; i++) {
 		hw_pp[i] = dpu_enc->hw_pp[i];
 		hw_dsc[i] = dpu_enc->hw_dsc[i];
 
-		if (!hw_pp[i] || !hw_dsc[i]) {
-			DPU_ERROR_ENC(dpu_enc, "invalid params for DSC\n");
-			return;
-		}
+		if (!hw_pp[i] || !hw_dsc[i])
+			break;
+
+		num_dsc++;
 	}
 
-	dsc_common_mode = 0;
 	pic_width = dsc->pic_width;
 
-	dsc_common_mode = DSC_MODE_SPLIT_PANEL;
+	dsc_common_mode = 0;
+	if (num_dsc > 1)
+		dsc_common_mode |= DSC_MODE_SPLIT_PANEL;
 	if (dpu_encoder_use_dsc_merge(enc_master->parent))
 		dsc_common_mode |= DSC_MODE_MULTIPLEX;
 	if (enc_master->intf_mode == INTF_MODE_VIDEO)
@@ -2053,14 +2060,10 @@ static void dpu_encoder_prep_dsc(struct dpu_encoder_virt *dpu_enc,
 	this_frame_slices = pic_width / dsc->slice_width;
 	intf_ip_w = this_frame_slices * dsc->slice_width;
 
-	/*
-	 * dsc merge case: when using 2 encoders for the same stream,
-	 * no. of slices need to be same on both the encoders.
-	 */
-	enc_ip_w = intf_ip_w / 2;
+	enc_ip_w = intf_ip_w / num_dsc;
 	initial_lines = dpu_encoder_dsc_initial_line_calc(dsc, enc_ip_w);
 
-	for (i = 0; i < MAX_CHANNELS_PER_ENC; i++)
+	for (i = 0; i < num_dsc; i++)
 		dpu_encoder_dsc_pipe_cfg(ctl, hw_dsc[i], hw_pp[i],
 					 dsc, dsc_common_mode, initial_lines);
 }
-- 
2.39.5



