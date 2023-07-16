Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C485D8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4390EC433C8;
	Sun, 16 Jul 2023 20:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538375;
	bh=JQDjPzQ4RJC3qzeajvpuaPUuIoPTZuasYtiBO+egjok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yRr69TyW8u8njuQ6ftMMQeGliM5MHZdhK52CPe+vTXa8lqnw8TaZlZkFnGL7le3sL
	 gsP/eP3/TCYAAtfVVQ9/KwLWYSQfQS0KXV+X63StSDnp8NQ7J2JbpL3IgsM+rmqKTu
	 s0HrwUPUZnVay9paEmz5j6123Byk0GK9kT6egg6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 399/800] drm/msm/dpu: Fix slice_last_group_size calculation
Date: Sun, 16 Jul 2023 21:44:12 +0200
Message-ID: <20230716194958.339455263@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index 4e1396575e6aa..c3c70ba61c1c4 100644
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



