Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57AB211493;
	Thu, 12 Dec 2024 17:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023960; cv=none; b=AwRiiJHsm5J0a8dq5A8Fzm2k1z6LlQQapz0WOA7bUXaxSWuq810Ddi6+x7XWXkRtzLojSS2K0ycFnMK/4iU22dDoOCE6GIcifYLyPj2Ycie0ErG0EWoPIx4yHtB/h3AxgRqzbwIr/1kzCxGKwb83w1LEQPUigMPlQ3qCEZzaw98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023960; c=relaxed/simple;
	bh=1cZzB847di2YD2vjDk6Zj6HHxyjU/gcrMV2i8NNhHy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5mEuSx4VnvPkVCASmX9D5ixQB3sJj860oVO7gLLzzpVLhnSFnPnd5oUZs/KmicW+L6mqlpIvqu9NEtwOKJ+Bno4eddLCSZk3oTAHfsphCkeWzeFNXazDmIjGCZe2aJIa0jxKmfx2WhVtl+RCd1utCHNSiTxIiQw62e3buqA/6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SaksUt9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaksUt9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68358C4CED0;
	Thu, 12 Dec 2024 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023959;
	bh=1cZzB847di2YD2vjDk6Zj6HHxyjU/gcrMV2i8NNhHy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaksUt9CCxjVuv8TyxhbEamkaIDEp1Eq5fumNqklTm2dBWL1fCQ03lQV1a9Hii/US
	 2ZQyl9wb3VwSXcswLaMOhLtoAOaE3Vik0D55OjTHv3e3ymnSuR4bAsgdgBN+d9cHLp
	 N1GInZ9i193TkBKZT35nieQMEWdqwSMLrRKdeVCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/459] drm/msm/dpu: cast crtc_clk calculation to u64 in _dpu_core_perf_calc_clk()
Date: Thu, 12 Dec 2024 15:57:57 +0100
Message-ID: <20241212144259.001370384@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zichen Xie <zichenxie0106@gmail.com>

[ Upstream commit 20c7b42d9dbd048019bfe0af39229e3014007a98 ]

There may be a potential integer overflow issue in
_dpu_core_perf_calc_clk(). crtc_clk is defined as u64, while
mode->vtotal, mode->hdisplay, and drm_mode_vrefresh(mode) are defined as
a smaller data type. The result of the calculation will be limited to
"int" in this case without correct casting. In screen with high
resolution and high refresh rate, integer overflow may happen.
So, we recommend adding an extra cast to prevent potential
integer overflow.

Fixes: c33b7c0389e1 ("drm/msm/dpu: add support for clk and bw scaling for display")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/622206/
Link: https://lore.kernel.org/r/20241029194209.23684-1-zichenxie0106@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
index 37c8270681c23..733941fb4078d 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -79,7 +79,7 @@ static u64 _dpu_core_perf_calc_clk(struct dpu_kms *kms,
 
 	mode = &state->adjusted_mode;
 
-	crtc_clk = mode->vtotal * mode->hdisplay * drm_mode_vrefresh(mode);
+	crtc_clk = (u64)mode->vtotal * mode->hdisplay * drm_mode_vrefresh(mode);
 
 	drm_atomic_crtc_for_each_plane(plane, crtc) {
 		pstate = to_dpu_plane_state(plane->state);
-- 
2.43.0



