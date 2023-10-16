Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98551A29F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaPB7eJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BF9C433C9;
	Mon, 16 Oct 2023 08:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446587;
	bh=DS2p/sC1CiCfUBsqjuxNX8wbKIvyk/Ac0kb6NFbuvAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaPB7eJcfNkKkWg8MusavxLr8iJTNbv0WitqS0XCoTEy4OUKL4d7AbikEqucahBiU
	 tXs0kUXvIQy6Ups2HejTn3MGp+TiwyrTHp22R7U3vdGWaJxNN18us30k8gJInwbplW
	 4QOvsR8GA5CZopcXF7+iGa0cxlJl48MQF6FSrEVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Nia Espera <nespera@igalia.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/131] drm/msm/dpu: change _dpu_plane_calc_bw() to use u64 to avoid overflow
Date: Mon, 16 Oct 2023 10:40:20 +0200
Message-ID: <20231016084000.989943447@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit 95e681ca3b65e4ce3d2537b47672d787b7d30375 ]

_dpu_plane_calc_bw() uses integer variables to calculate the bandwidth
used during plane bandwidth calculations. However for high resolution
displays this overflows easily and leads to below errors

[dpu error]crtc83 failed performance check -7

Promote the intermediate variables to u64 to avoid overflow.

changes in v2:
	- change to u64 where actually needed in the math

Fixes: c33b7c0389e1 ("drm/msm/dpu: add support for clk and bw scaling for display")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reported-by: Nia Espera <nespera@igalia.com>
Closes: https://gitlab.freedesktop.org/drm/msm/-/issues/32
Tested-by: Nia Espera <nespera@igalia.com>
Patchwork: https://patchwork.freedesktop.org/patch/556288/
Link: https://lore.kernel.org/r/20230908012616.20654-1-quic_abhinavk@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
index 3fbda2a1f77fc..62d48c0f905e4 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -142,6 +142,7 @@ static void _dpu_plane_calc_bw(struct drm_plane *plane,
 	const struct dpu_format *fmt = NULL;
 	struct dpu_kms *dpu_kms = _dpu_plane_get_kms(plane);
 	int src_width, src_height, dst_height, fps;
+	u64 plane_pixel_rate, plane_bit_rate;
 	u64 plane_prefill_bw;
 	u64 plane_bw;
 	u32 hw_latency_lines;
@@ -164,13 +165,12 @@ static void _dpu_plane_calc_bw(struct drm_plane *plane,
 	scale_factor = src_height > dst_height ?
 		mult_frac(src_height, 1, dst_height) : 1;
 
-	plane_bw =
-		src_width * mode->vtotal * fps * fmt->bpp *
-		scale_factor;
+	plane_pixel_rate = src_width * mode->vtotal * fps;
+	plane_bit_rate = plane_pixel_rate * fmt->bpp;
 
-	plane_prefill_bw =
-		src_width * hw_latency_lines * fps * fmt->bpp *
-		scale_factor * mode->vtotal;
+	plane_bw = plane_bit_rate * scale_factor;
+
+	plane_prefill_bw = plane_bw * hw_latency_lines;
 
 	if ((vbp+vpw) > hw_latency_lines)
 		do_div(plane_prefill_bw, (vbp+vpw));
-- 
2.40.1



