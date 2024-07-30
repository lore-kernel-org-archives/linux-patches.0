Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4408618452F;
	Tue, 30 Jul 2024 16:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357610; cv=none; b=RGFfDhgd+el9P0RO80nXYxWIi7606sjalI6uoD7L3Tkc+Xbw612mPlA4QEs77cIraX7TMoV/Ef0QWHEnnyP9fkLS3J76fuZG4yZ5zG3/efoC0ZJXfhfCSqPQ3lgz5uJ8rhD3S1yRGsv+Aqt/6YEb6ixGHlsxKOyREtksz8NP8y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357610; c=relaxed/simple;
	bh=EubrcINmNuoW5Oj37cfFbFxcDBFG/r/2Gym4xvwHBQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAMVnUSqToS0N0K1bDrvhcyUwLsomTB4BCZR5ays590DeH5dA3cT9lC6xoi5gZiZqiI/lpokK45Ky2Q0T49KXXStfvQsISZCOuWlaf6z7+HZo4QIFSu7yOI+mxskhf+CxWt4ECLijEwFAz+xUFq4tmQVWxNtyWc72nDS0rwyrAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNov5vp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNov5vp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61111C4AF0A;
	Tue, 30 Jul 2024 16:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357609;
	bh=EubrcINmNuoW5Oj37cfFbFxcDBFG/r/2Gym4xvwHBQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNov5vp6yqevNjmSfMKO4l/24Sk7tV5JgZZkpb+tQ42k+wFWkwMtgDVQiEXbu/OBj
	 EXld0qcd8+dbQfU5bh7mBtNteY1uZkFaKvswIN1e0nDtdK6LeqOwGxOImY/xBYBkSn
	 jhukf/b/xbuiZO8XuK3cO0YMHeJmQLmpaWdzfOdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 265/568] clk: qcom: gpucc-sm8350: Park RCGs clk source at XO during disable
Date: Tue, 30 Jul 2024 17:46:12 +0200
Message-ID: <20240730151650.232768122@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit 313e2909023bef36ef7b6d1d9ff2d98febcaa28d ]

The RCG's clk src has to be parked at XO while disabling as per the
HW recommendation, hence use clk_rcg2_shared_ops to achieve the same.

Fixes: 160758b05ab1 ("clk: qcom: add support for SM8350 GPUCC")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org> # SM8350-HDK
Link: https://lore.kernel.org/r/20240621-sm8350-gpucc-fixes-v1-1-22db60c7c5d3@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-sm8350.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gpucc-sm8350.c b/drivers/clk/qcom/gpucc-sm8350.c
index 8dc54dff983f3..33c4fb8891caa 100644
--- a/drivers/clk/qcom/gpucc-sm8350.c
+++ b/drivers/clk/qcom/gpucc-sm8350.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (c) 2019-2020, The Linux Foundation. All rights reserved.
  * Copyright (c) 2022, Linaro Limited
+ * Copyright (c) 2024, Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/clk.h>
@@ -147,7 +148,7 @@ static struct clk_rcg2 gpu_cc_gmu_clk_src = {
 		.parent_data = gpu_cc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gpu_cc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -169,7 +170,7 @@ static struct clk_rcg2 gpu_cc_hub_clk_src = {
 		.parent_data = gpu_cc_parent_data_1,
 		.num_parents = ARRAY_SIZE(gpu_cc_parent_data_1),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
-- 
2.43.0



