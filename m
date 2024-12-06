Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5562010E0;
	Fri,  6 Dec 2024 14:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497196; cv=none; b=JTRpgie9zyGP4xPm5NHygkPFfVegSDccQ0KnSSkJANzAs9FUBflmLYiKzCUhTmoI428H33vn5+Q3QayrtEJLaM8QdoD70OoUZ987dai9wh5pXaUGKUtJmN4EvR51d7PYY2J+J4EeO9a8Hshv0mjpOJnwYw8phRicSziK92pWHJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497196; c=relaxed/simple;
	bh=5StewqAYkr7X/z9pZ91n6xCGM7985hWtutvHFK62FF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFKFJA6Bji5DQcVai0YWS28dx2cUKxq0QCEld5ymMo1pWJuIVSvu726CJycfLQRhxW5kVewnOHWpIkdMzW2PEqGaTxdikYeZqIzbLLDps+E/4G8a9iUyCpKJdN/I0ek7AsCqvfRAal8v+aFPFKIpXWud2poFliSeGuZHdkuyTfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxC0+EbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxC0+EbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B45C4CED1;
	Fri,  6 Dec 2024 14:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497194;
	bh=5StewqAYkr7X/z9pZ91n6xCGM7985hWtutvHFK62FF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxC0+EbFKNETJmoDveGoAfMGEgnSDMan9lcL3shAsqaOT/kTKgy3enTiItUknfo0z
	 /1TX8INx6laL36TxqzINrZBhLmmRTCk/dMnroVqwPj2PQs7rXY01DANwu9v7KcfHU9
	 Ub2aqg/9u+4Gol3BQ2fpb1BO2EkfvWtx2Jk5Gp40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 222/676] drm/msm/dpu: cast crtc_clk calculation to u64 in _dpu_core_perf_calc_clk()
Date: Fri,  6 Dec 2024 15:30:41 +0100
Message-ID: <20241206143702.010054687@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 68fae048a9a83..260accc151d4b 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -80,7 +80,7 @@ static u64 _dpu_core_perf_calc_clk(const struct dpu_perf_cfg *perf_cfg,
 
 	mode = &state->adjusted_mode;
 
-	crtc_clk = mode->vtotal * mode->hdisplay * drm_mode_vrefresh(mode);
+	crtc_clk = (u64)mode->vtotal * mode->hdisplay * drm_mode_vrefresh(mode);
 
 	drm_atomic_crtc_for_each_plane(plane, crtc) {
 		pstate = to_dpu_plane_state(plane->state);
-- 
2.43.0



