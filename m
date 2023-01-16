Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B787F33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA49C433D2;
	Mon, 16 Jan 2023 15:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884777;
	bh=y7dXr5pG0p/Qty7nDP+Q2gmP8RhIcnT37aUyQ4YtKH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0bB9fUISI8+LcxEg2bjRtcoIUo661LxCy5cLGRSF4JbVDhSigF0j7fIzLWhpSSZ4
	 +iPpfLNGwUGfqab6E7V5XijVc3Q6d1NH2Yrlm2a00WNylbCXAJ+K7ZKmfyMc2h0w4V
	 V7TuFPoN2KTRP5dXzms7iobbV/AITk9MoqJiR3pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/183] drm/msm/dpu: Fix memory leak in msm_mdss_parse_data_bus_icc_path
Date: Mon, 16 Jan 2023 16:50:28 +0100
Message-Id: <20230116154807.812400820@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 45dac1352b55b1d8cb17f218936b2bc2bc1fb4ee ]

of_icc_get() alloc resources for path1, we should release it when not
need anymore. Early return when IS_ERR_OR_NULL(path0) may leak path1.
Defer getting path1 to fix this.

Fixes: b9364eed9232 ("drm/msm/dpu: Move min BW request and full BW disable back to mdss")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/514264/
Link: https://lore.kernel.org/r/20221207065922.2086368-1-linmq006@gmail.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_mdss.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_mdss.c b/drivers/gpu/drm/msm/msm_mdss.c
index e13c5c12b775..3b8d6991b04e 100644
--- a/drivers/gpu/drm/msm/msm_mdss.c
+++ b/drivers/gpu/drm/msm/msm_mdss.c
@@ -46,15 +46,17 @@ struct msm_mdss {
 static int msm_mdss_parse_data_bus_icc_path(struct device *dev,
 					    struct msm_mdss *msm_mdss)
 {
-	struct icc_path *path0 = of_icc_get(dev, "mdp0-mem");
-	struct icc_path *path1 = of_icc_get(dev, "mdp1-mem");
+	struct icc_path *path0;
+	struct icc_path *path1;
 
+	path0 = of_icc_get(dev, "mdp0-mem");
 	if (IS_ERR_OR_NULL(path0))
 		return PTR_ERR_OR_ZERO(path0);
 
 	msm_mdss->path[0] = path0;
 	msm_mdss->num_paths = 1;
 
+	path1 = of_icc_get(dev, "mdp1-mem");
 	if (!IS_ERR_OR_NULL(path1)) {
 		msm_mdss->path[1] = path1;
 		msm_mdss->num_paths++;
-- 
2.35.1



