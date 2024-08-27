Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAEF1C6894;
	Tue, 27 Aug 2024 14:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770624; cv=none; b=WQXHThJJ578UiMXUSSQV8MdQrhnHtIUC2WRjYv10nOR2MZzJ75bo3l6z3QtwsAg/ZuwdDX0NkNCD7cuKIlPz7GTpcaZw1dnUIqUDVLnwhAdVO28D3cV9jlGrsTmpbtzR2lbp9EmugA4MBlTfQtjYNvOZbeFuDgUbkvqVfKB1PS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770624; c=relaxed/simple;
	bh=dwtmbiVs8alIj2VSiFEUTBay4A1++JcghqvqbixUhwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rILw80i5hvVCp3q/OyzdU+OsFLI6D/TgpcSNh6RtXHSscPSevm2lwkSFcsceSE/UGi8VXCVPKV5VmLQ7LXU33JJlBm7XYS/pzc5NmspNnvgpyKC9mD/cPbO1KG/gmmYeypvcIxE8aUpOgDtjrymUi/t0/348I2KHLzk5OxaDxfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inxA8+Zs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inxA8+Zs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3FDC4FE01;
	Tue, 27 Aug 2024 14:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770624;
	bh=dwtmbiVs8alIj2VSiFEUTBay4A1++JcghqvqbixUhwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inxA8+ZsLul53S3KXEn2vRWT+lMRbFST7Z67YOG3EFsiWtl9xxKyAh99DNm0zULPY
	 i2Zl4sSrEK1qMk96eqmYVTkpHgeM3gwfuhVhddykFmJAGzrfAoxapQEb79JGfys95T
	 HfXXds3tQu0k+eVYkl3ncupK+FR/nsWG1ccqnRUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 283/341] drm/msm/dpu: move dpu_encoders connector assignment to atomic_enable()
Date: Tue, 27 Aug 2024 16:38:34 +0200
Message-ID: <20240827143854.166883602@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit aedf02e46eb549dac8db4821a6b9f0c6bf6e3990 ]

For cases where the crtc's connectors_changed was set without enable/active
getting toggled , there is an atomic_enable() call followed by an
atomic_disable() but without an atomic_mode_set().

This results in a NULL ptr access for the dpu_encoder_get_drm_fmt() call in
the atomic_enable() as the dpu_encoder's connector was cleared in the
atomic_disable() but not re-assigned as there was no atomic_mode_set() call.

Fix the NULL ptr access by moving the assignment for atomic_enable() and also
use drm_atomic_get_new_connector_for_encoder() to get the connector from
the atomic_state.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Closes: https://gitlab.freedesktop.org/drm/msm/-/issues/59
Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org> # SM8350-HDK
Patchwork: https://patchwork.freedesktop.org/patch/606729/
Link: https://lore.kernel.org/r/20240731191723.3050932-1-quic_abhinavk@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 0c57588044641..6262ec5e40204 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1119,8 +1119,6 @@ static void dpu_encoder_virt_atomic_mode_set(struct drm_encoder *drm_enc,
 
 	cstate->num_mixers = num_lm;
 
-	dpu_enc->connector = conn_state->connector;
-
 	for (i = 0; i < dpu_enc->num_phys_encs; i++) {
 		struct dpu_encoder_phys *phys = dpu_enc->phys_encs[i];
 
@@ -1216,6 +1214,8 @@ static void dpu_encoder_virt_atomic_enable(struct drm_encoder *drm_enc,
 
 	dpu_enc->commit_done_timedout = false;
 
+	dpu_enc->connector = drm_atomic_get_new_connector_for_encoder(state, drm_enc);
+
 	cur_mode = &dpu_enc->base.crtc->state->adjusted_mode;
 
 	trace_dpu_enc_enable(DRMID(drm_enc), cur_mode->hdisplay,
-- 
2.43.0



