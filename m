Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC3B1F943D;
	Tue,  3 Dec 2024 15:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238618; cv=none; b=j8qwxKbQRZ9fcK9Ilq0UWyUQs7yZcrNLgTW8nI9RQXQBOdTLrv/EYiXdasWcZyvJwJaftO2HP50No1UEoGgmiWjpDJjaMOIj3B7zlDDDAhE/TN8sCRaAddYr3aJWJNMIHXGhrDiO7qG6bNYoXl0Q01LLEe1HPtPoPkwT6fUOmOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238618; c=relaxed/simple;
	bh=c/OpJUyZnScWW9eaDNXC9aeKsKSKiO3q8FWAmPMRQfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YeDZY06Q4yt0hqq/7r4DxHCLGB2iSPm9ARcDLGVlR4Y3r3Q10l/sGiR5OuY5SPx9IAv/vS2diIXs6yI1oY1ECxmtRjwgfWdRSX4PgWZxPGelVqjXUpwolUh8OFbNKtOLXtRziXt65yaRfifp4ZRDgtRdfWv2lkkXd9fAWEoMr0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsb6OVz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsb6OVz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73767C4CED6;
	Tue,  3 Dec 2024 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238617;
	bh=c/OpJUyZnScWW9eaDNXC9aeKsKSKiO3q8FWAmPMRQfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsb6OVz8mEXyuwf3nQc7d1UbVpKVYz7Dg0EhtofE5iCtwe3I58z0G4ec0UTuEuZsP
	 b/bRdO2JewZquWKF/N8hCoVckjhhiRYk5iGHF4VPywTGrr4DBuGlHFS9QxYQyfVg+u
	 zhsaVVqmbOar/lNReokn0PBVJvaIcdi8lbK8lvOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 308/817] drm/msm/dpu: cast crtc_clk calculation to u64 in _dpu_core_perf_calc_clk()
Date: Tue,  3 Dec 2024 15:38:00 +0100
Message-ID: <20241203144007.839159904@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



