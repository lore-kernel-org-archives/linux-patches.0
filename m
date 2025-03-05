Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F166E2505A7;
	Wed,  5 Mar 2025 17:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197280; cv=none; b=cBdPcPZslwQ1WdJJZYyKVZymQmA+B6uVQwnpnO91mby3SPvPLBwY1e7VQLIMrOyRFwBgcMgzl4UwT3eJnIo+erLgte/fsMLyymF3WFn/12zGFDUqWcRa+MsF0Q/dZBV2k5pAlcqfYYou+BK/CcArUkbAkfISeiLaBg/xrMFbwjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197280; c=relaxed/simple;
	bh=CiArs+uF6qFGVfHgMkP8VyXDf0sJzhv3X6Hr1EM99vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kwt/70FFxKBSXTksznxh5r+njig52fkKPYyqsOdZdOAZw6B6WVM7auhom1BwwfWZMdR3b24g+HpjiDoqGNZYmtR/+/ZuK3396LL01WUCWc5sJcZMjHTZIPWzOjoyqJ/mMdV6AdVWI1At9FQUNhdFTdJIzwCHcQhbst6IyB0f3Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sV3ZF1cf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sV3ZF1cf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEB0C4CEE2;
	Wed,  5 Mar 2025 17:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197279;
	bh=CiArs+uF6qFGVfHgMkP8VyXDf0sJzhv3X6Hr1EM99vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sV3ZF1cf4zQKMyzFroLATJaD27buLmo1nRu4r7+oblwqEEOmpZyCG1y0lmt9Hoy1u
	 1VJ8O1TSMRKjVf6EuQq1pka4OIumLBVipg3tNGE+OYA0atp/CKTcrisl4ZAKGKuCs2
	 53+AbHhZ1dxLS9DH5r9FOHDdSCc5SkPCNxG+Wggw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/176] drm/msm/dpu: Dont leak bits_per_component into random DSC_ENC fields
Date: Wed,  5 Mar 2025 18:47:18 +0100
Message-ID: <20250305174508.227785303@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 144429831f447223253a0e4376489f84ff37d1a7 ]

What used to be the input_10_bits boolean - feeding into the lowest
bit of DSC_ENC - on MSM downstream turned into an accidental OR with
the full bits_per_component number when it was ported to the upstream
kernel.

On typical bpc=8 setups we don't notice this because line_buf_depth is
always an odd value (it contains bpc+1) and will also set the 4th bit
after left-shifting by 3 (hence this |= bits_per_component is a no-op).

Now that guards are being removed to allow more bits_per_component
values besides 8 (possible since commit 49fd30a7153b ("drm/msm/dsi: use
DRM DSC helpers for DSC setup")), a bpc of 10 will instead clash with
the 5th bit which is convert_rgb.  This is "fortunately" also always set
to true by MSM's dsi_populate_dsc_params() already, but once a bpc of 12
starts being used it'll write into simple_422 which is normally false.

To solve all these overlaps, simply replicate downstream code and only
set this lowest bit if bits_per_component is equal to 10.  It is unclear
why DSC requires this only for bpc=10 but not bpc=12, and also notice
that this lowest bit wasn't set previously despite having a panel and
patch on the list using it without any mentioned issues.

Fixes: c110cfd1753e ("drm/msm/disp/dpu1: Add support for DSC")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/636311/
Link: https://lore.kernel.org/r/20250211-dsc-10-bit-v1-1-1c85a9430d9a@somainline.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c
index c8f14555834a8..70a6dfe94faa5 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c
@@ -46,6 +46,7 @@ static void dpu_hw_dsc_config(struct dpu_hw_dsc *hw_dsc,
 	u32 slice_last_group_size;
 	u32 det_thresh_flatness;
 	bool is_cmd_mode = !(mode & DSC_MODE_VIDEO);
+	bool input_10_bits = dsc->bits_per_component == 10;
 
 	DPU_REG_WRITE(c, DSC_COMMON_MODE, mode);
 
@@ -62,7 +63,7 @@ static void dpu_hw_dsc_config(struct dpu_hw_dsc *hw_dsc,
 	data |= (dsc->line_buf_depth << 3);
 	data |= (dsc->simple_422 << 2);
 	data |= (dsc->convert_rgb << 1);
-	data |= dsc->bits_per_component;
+	data |= input_10_bits;
 
 	DPU_REG_WRITE(c, DSC_ENC, data);
 
-- 
2.39.5



