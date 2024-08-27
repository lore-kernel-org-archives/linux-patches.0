Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694D41E487;
	Tue, 27 Aug 2024 14:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770765; cv=none; b=Duh1ACM83eT7XKdIW7/Ybx+UPyVsJ41xEbZEdHuyR/Pq47zCGfF9J0xVSKbLt2R3XXt9eKzlRvtSC3VpNNV21lctTDQSOlFGKq2nl5xj0OzLdfKPPzidSeTRSXPAU7OSlYlsI8WuO2W8sZ+TA+pnAp6RGQ9aq+1M12Voe1qlt+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770765; c=relaxed/simple;
	bh=yWUPjenCvkp1PuSfJF9b7nzTwUsPjZ9ZMPjceNOMoH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kh55uVDECXBmraBYyMForMejd36TjZRoTxlr8YF828s+pLtkxwMVpAmX9yHn1DWaj0OL4vDTwTEJDXMywI2UtSV13svLylzBusNM95vG6bWslycgNntWpC9kKX/Po2eGZ+4CWYUJEzWtZe8T4fL8yxj24BmJELO2X7gxMPDVYfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEFsRhYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEFsRhYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0921C61044;
	Tue, 27 Aug 2024 14:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770765;
	bh=yWUPjenCvkp1PuSfJF9b7nzTwUsPjZ9ZMPjceNOMoH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEFsRhYyzfu8yA4eqTS40azyGOefJl53OKVRrTubmqlX9nhC+j3Wfp7wfaj2munGr
	 wcdaUeR0p8nnWpbZR8prFtaYUmp5LZ1w6C89/yHlGQuUG5R8oDc6x8BiZHYYEnetym
	 kZPvRQRLxNepyw8BD8zTRis0bi7g3ZjGBjiRgzRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 286/341] drm/msm/dpu: try multirect based on mdp clock limits
Date: Tue, 27 Aug 2024 16:38:37 +0200
Message-ID: <20240827143854.280881466@linuxfoundation.org>
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

[ Upstream commit e6c0de5f445091d250b75dabc4c60dd2643b8c98 ]

It's certainly possible that for large resolutions a single DPU SSPP
cannot process the image without exceeding the MDP clock limits but
it can still process it in multirect mode because the source rectangles
will get divided and can fall within the MDP clock limits.

If the SSPP cannot process the image even in multirect mode, then it
will be rejected in dpu_plane_atomic_check_pipe().

Hence try using multirect for resolutions which cannot be processed
by a single SSPP without exceeding the MDP clock limits.

changes in v2:
	- use crtc_state's adjusted_mode instead of mode
	- fix the UBWC condition to check maxlinewidth

Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/556817/
Link: https://lore.kernel.org/r/20230911221627.9569-2-quic_abhinavk@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: d3a785e4f983 ("drm/msm/dpu: take plane rotation into account for wide planes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
index 5ffbf131e1e80..3c2a8c0ddaf76 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -795,6 +795,8 @@ static int dpu_plane_atomic_check(struct drm_plane *plane,
 										 plane);
 	int ret = 0, min_scale;
 	struct dpu_plane *pdpu = to_dpu_plane(plane);
+	struct dpu_kms *kms = _dpu_plane_get_kms(&pdpu->base);
+	u64 max_mdp_clk_rate = kms->perf.max_core_clk_rate;
 	struct dpu_plane_state *pstate = to_dpu_plane_state(new_plane_state);
 	struct dpu_sw_pipe *pipe = &pstate->pipe;
 	struct dpu_sw_pipe *r_pipe = &pstate->r_pipe;
@@ -863,14 +865,16 @@ static int dpu_plane_atomic_check(struct drm_plane *plane,
 
 	max_linewidth = pdpu->catalog->caps->max_linewidth;
 
-	if (drm_rect_width(&pipe_cfg->src_rect) > max_linewidth) {
+	if ((drm_rect_width(&pipe_cfg->src_rect) > max_linewidth) ||
+	     _dpu_plane_calc_clk(&crtc_state->adjusted_mode, pipe_cfg) > max_mdp_clk_rate) {
 		/*
 		 * In parallel multirect case only the half of the usual width
 		 * is supported for tiled formats. If we are here, we know that
 		 * full width is more than max_linewidth, thus each rect is
 		 * wider than allowed.
 		 */
-		if (DPU_FORMAT_IS_UBWC(fmt)) {
+		if (DPU_FORMAT_IS_UBWC(fmt) &&
+		    drm_rect_width(&pipe_cfg->src_rect) > max_linewidth) {
 			DPU_DEBUG_PLANE(pdpu, "invalid src " DRM_RECT_FMT " line:%u, tiled format\n",
 					DRM_RECT_ARG(&pipe_cfg->src_rect), max_linewidth);
 			return -E2BIG;
-- 
2.43.0



