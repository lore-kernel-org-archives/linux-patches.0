Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11EC1BFE04;
	Tue, 27 Aug 2024 14:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770657; cv=none; b=Z4HgsZaLZSSD4y3VWyQrcIX1mkjBzBEVjBW2iPEaya5URGk6JF8FGkvLjdhLKdRblaET7e3HlwvDKvLVwEByGOlNMPW7v1ppLPM+t108tsE/hetu5CNn1ijBNi/2gVaWSL8rL9QReIM5bmvJdvt8ojoqqZ8jTrNSxTmQhsfUS9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770657; c=relaxed/simple;
	bh=BgYpx2cW7GX2456a5F4kRiZ1NnHm1dGPB9CVj4sP5nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfHAdfjCrF20yOtaBbM9h1h+oV0iTecWL6SHcn5eJX/nD7DR6o2zP/OTkDlPXDEfMDIHlMjyF/lNUWE2Xrh8+4AyXNcW/bB5AgdxaUmSl3XgdGVZo4mCwJwNnI9xnaN7Y+16GjQZPkMrjole2uem7deVyvyHluBhwAhy3hXElME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srVFeCFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srVFeCFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F726C61040;
	Tue, 27 Aug 2024 14:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770656;
	bh=BgYpx2cW7GX2456a5F4kRiZ1NnHm1dGPB9CVj4sP5nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srVFeCFL+biVvSXoMUE/UAd2CMaLY9yXueUbJPEJLNFwMsclAQoWixTJnaBrRIEp/
	 OAr+rRNHJ20tik16LuyXKsn/VumfKzhvzYYQp+jZ1By29GV17tQ40EH+O8BXIkrIXb
	 5EWEYgVgsJucmmNMs1UU6Y9H6qCxkNAERyOOb0Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 287/341] drm/msm/dpu: take plane rotation into account for wide planes
Date: Tue, 27 Aug 2024 16:38:38 +0200
Message-ID: <20240827143854.318035639@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d3a785e4f983f523380e023d8a05fb6d04402957 ]

Take into account the plane rotation and flipping when calculating src
positions for the wide plane parts.

This is not an issue yet, because rotation is only supported for the
UBWC planes and wide UBWC planes are rejected anyway because in parallel
multirect case only the half of the usual width is supported for tiled
formats. However it's better to fix this now rather than stumbling upon
it later.

Fixes: 80e8ae3b38ab ("drm/msm/dpu: add support for wide planes")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/601059/
Link: https://lore.kernel.org/r/20240627-dpu-virtual-wide-v5-3-5efb90cbb8be@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
index 3c2a8c0ddaf76..637f50a8d42e6 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -865,6 +865,10 @@ static int dpu_plane_atomic_check(struct drm_plane *plane,
 
 	max_linewidth = pdpu->catalog->caps->max_linewidth;
 
+	drm_rect_rotate(&pipe_cfg->src_rect,
+			new_plane_state->fb->width, new_plane_state->fb->height,
+			new_plane_state->rotation);
+
 	if ((drm_rect_width(&pipe_cfg->src_rect) > max_linewidth) ||
 	     _dpu_plane_calc_clk(&crtc_state->adjusted_mode, pipe_cfg) > max_mdp_clk_rate) {
 		/*
@@ -914,6 +918,14 @@ static int dpu_plane_atomic_check(struct drm_plane *plane,
 		r_pipe_cfg->dst_rect.x1 = pipe_cfg->dst_rect.x2;
 	}
 
+	drm_rect_rotate_inv(&pipe_cfg->src_rect,
+			    new_plane_state->fb->width, new_plane_state->fb->height,
+			    new_plane_state->rotation);
+	if (r_pipe->sspp)
+		drm_rect_rotate_inv(&r_pipe_cfg->src_rect,
+				    new_plane_state->fb->width, new_plane_state->fb->height,
+				    new_plane_state->rotation);
+
 	ret = dpu_plane_atomic_check_pipe(pdpu, pipe, pipe_cfg, fmt, &crtc_state->adjusted_mode);
 	if (ret)
 		return ret;
-- 
2.43.0



