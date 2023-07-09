Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8BA5232
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A706CC433C7;
	Sun,  9 Jul 2023 11:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902328;
	bh=NeJ1uJ6XJj3ghLU8NUv+MQX4/pHzVtnlPNdhSweo6k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJWBxXJICB/JlSBN6GIw+T8SKmHGKo4ijJeYg16+MBRe1nwEkhQ4OB2AyOEmpx4Rr
	 8j/fRgypSyMQmeZxPiwLiKWv2yNjW1a9bUC/N1/W6NJv7w/EZS+5hwcU9Uih255wMc
	 SH+fUkgEdZ93uzZ/uD6YKWxRLotZr81aZnRJ3yt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 309/431] drm/msm/dpu: Fix slice_last_group_size calculation
Date: Sun,  9 Jul 2023 13:14:17 +0200
Message-ID: <20230709111458.407715959@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jessica Zhang <quic_jesszhan@quicinc.com>

[ Upstream commit c223059e6f8340f7eac2319470984cbfc39c433b ]

Correct the math for slice_last_group_size so that it matches the
calculations downstream.

Fixes: c110cfd1753e ("drm/msm/disp/dpu1: Add support for DSC")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/539269/
Link: https://lore.kernel.org/r/20230329-rfc-msm-dsc-helper-v14-7-bafc7be95691@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c
index 619926da1441e..68035745b7069 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c
@@ -54,9 +54,10 @@ static void dpu_hw_dsc_config(struct dpu_hw_dsc *hw_dsc,
 	if (is_cmd_mode)
 		initial_lines += 1;
 
-	slice_last_group_size = 3 - (dsc->slice_width % 3);
+	slice_last_group_size = (dsc->slice_width + 2) % 3;
+
 	data = (initial_lines << 20);
-	data |= ((slice_last_group_size - 1) << 18);
+	data |= (slice_last_group_size << 18);
 	/* bpp is 6.4 format, 4 LSBs bits are for fractional part */
 	data |= (dsc->bits_per_pixel << 8);
 	data |= (dsc->block_pred_enable << 7);
-- 
2.39.2



