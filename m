Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B0D1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C5DC433D2;
	Wed, 28 Dec 2022 15:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241695;
	bh=v8jM3pE8cByIJhJ+yVAtqvDzNsxxf9RrJNrs533gVag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gozojpfgjW8nrogeRny+TeWUL/qngS0VD4hU4AzD8U45crOLjeP5sshvTQW1bOsjN
	 yzBM9pKY1UPeQ/n38vTGVY88kxOFyJcalKQWeGheeN8WqCX6MoSZUzX/wdqLxXHawc
	 uAd/9iKY3yYJePs16s2sqeNlEVnYyhhvvupPWgU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0278/1146] drm/msm/dsi: Remove useless math in DSC calculations
Date: Wed, 28 Dec 2022 15:30:17 +0100
Message-Id: <20221228144337.687897066@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 01a907980e0be3310f18c7d4955968f3b28e7147 ]

Multiplying a value by 2 and adding 1 to it always results in a value
that is uneven, and that 1 gets truncated immediately when performing
integer division by 2 again.  There is no "rounding" possible here.

After that target_bpp_x16 is used to store a multiplication of
bits_per_pixel by 16 which is only ever read to immediately be divided
by 16 again, and is elided in much the same way.

Fixes: b9080324d6ca ("drm/msm/dsi: add support for dsc data")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/508932/
Link: https://lore.kernel.org/r/20221026182824.876933-2-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 7fbf391c024f..8026fe65bff6 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1762,7 +1762,6 @@ static int dsi_populate_dsc_params(struct drm_dsc_config *dsc)
 	int hrd_delay;
 	int pre_num_extra_mux_bits, num_extra_mux_bits;
 	int slice_bits;
-	int target_bpp_x16;
 	int data;
 	int final_value, final_scale;
 	int i;
@@ -1842,14 +1841,7 @@ static int dsi_populate_dsc_params(struct drm_dsc_config *dsc)
 	data = 2048 * (dsc->rc_model_size - dsc->initial_offset + num_extra_mux_bits);
 	dsc->slice_bpg_offset = DIV_ROUND_UP(data, groups_total);
 
-	/* bpp * 16 + 0.5 */
-	data = dsc->bits_per_pixel * 16;
-	data *= 2;
-	data++;
-	data /= 2;
-	target_bpp_x16 = data;
-
-	data = (dsc->initial_xmit_delay * target_bpp_x16) / 16;
+	data = dsc->initial_xmit_delay * dsc->bits_per_pixel;
 	final_value =  dsc->rc_model_size - data + num_extra_mux_bits;
 	dsc->final_offset = final_value;
 
-- 
2.35.1



