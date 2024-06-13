Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7412CA6;
	Thu, 13 Jun 2024 12:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282466; cv=none; b=pqhD0g51/4HQJpwyHniO0kjXxTwCfFgTAhL4jKTILlQMdpF4OHzvuGMfNlQzqUvhtUhPz4pFaWFIRb0QFetldTvLV5H5vLRJ49hb+ymQfuZvy2LOD8/E9/U7UmQ0jWSGLKG0LMVZQeNWnm4mkJ8npmQUtff9+bSz4sIJZh6IfFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282466; c=relaxed/simple;
	bh=LOKNI6IPH2UzGoXDqOzsVOINB8OW9GljcS660ElhYbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hg+3irUCRPj1OOaEpQJEKlJHXFDfncOx9pHlwJ8y0LwnPOyXEqoRLTruhUPHDWNDmroWYWXOGpYHZ5rbLb9SrjN+9th5UkUrylWQJj3sr/1JWqO4V8tvim5XAjsUiOHk7AbvDUk2MGu+0Sihn9WWurCi9UCMoBuYHbQ/rQ6/xlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IK02f9mZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IK02f9mZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CDBC2BBFC;
	Thu, 13 Jun 2024 12:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282466;
	bh=LOKNI6IPH2UzGoXDqOzsVOINB8OW9GljcS660ElhYbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IK02f9mZEGEg7ddDTXQA1EjpyziI055+w/v2GFNvE87mOUTmonpQ7kvDHT/vd4fWj
	 E3wLP72DynYS47Robrw3rS2okmCN0aOMIL/Pcal81/YuH+N7QLIUv6oWl2oQF+YviB
	 o5W54TsiRR6gYJGHkZGfXj+rlEq960W7uDScVClA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 256/402] drm/msm/dsi: Print dual-DSI-adjusted pclk instead of original mode pclk
Date: Thu, 13 Jun 2024 13:33:33 +0200
Message-ID: <20240613113312.133091501@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit f12e0e12524a34bf145f7b80122e653ffe3d130a ]

When dual-DSI (bonded DSI) was added in commit ed9976a09b48
("drm/msm/dsi: adjust dsi timing for dual dsi mode") some DBG() prints
were not updated, leading to print the original mode->clock rather
than the adjusted (typically the mode clock divided by two, though more
recently also adjusted for DSC compression) msm_host->pixel_clk_rate
which is passed to clk_set_rate() just below.  Fix that by printing the
actual pixel_clk_rate that is being set.

Fixes: ed9976a09b48 ("drm/msm/dsi: adjust dsi timing for dual dsi mode")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/589896/
Link: https://lore.kernel.org/r/20240417-drm-msm-initial-dualpipe-dsc-fixes-v1-1-78ae3ee9a697@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 8d0612caf6c21..c563ecf6e7b94 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -501,8 +501,8 @@ int dsi_link_clk_set_rate_6g(struct msm_dsi_host *msm_host)
 	unsigned long byte_intf_rate;
 	int ret;
 
-	DBG("Set clk rates: pclk=%d, byteclk=%lu",
-		msm_host->mode->clock, msm_host->byte_clk_rate);
+	DBG("Set clk rates: pclk=%lu, byteclk=%lu",
+	    msm_host->pixel_clk_rate, msm_host->byte_clk_rate);
 
 	ret = dev_pm_opp_set_rate(&msm_host->pdev->dev,
 				  msm_host->byte_clk_rate);
@@ -583,9 +583,9 @@ int dsi_link_clk_set_rate_v2(struct msm_dsi_host *msm_host)
 {
 	int ret;
 
-	DBG("Set clk rates: pclk=%d, byteclk=%lu, esc_clk=%lu, dsi_src_clk=%lu",
-		msm_host->mode->clock, msm_host->byte_clk_rate,
-		msm_host->esc_clk_rate, msm_host->src_clk_rate);
+	DBG("Set clk rates: pclk=%lu, byteclk=%lu, esc_clk=%lu, dsi_src_clk=%lu",
+	    msm_host->pixel_clk_rate, msm_host->byte_clk_rate,
+	    msm_host->esc_clk_rate, msm_host->src_clk_rate);
 
 	ret = clk_set_rate(msm_host->byte_clk, msm_host->byte_clk_rate);
 	if (ret) {
-- 
2.43.0



