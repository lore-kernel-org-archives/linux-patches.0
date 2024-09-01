Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE271DFD1;
	Sun,  1 Sep 2024 16:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209657; cv=none; b=YgpDUxDAFnwJvDSKLsrPmn1oeyBnBSYfQq93VWReDg9hLUfYm8nreoGais6VTD8G6JQ90KJ4xuaStGW88v63noyOPEZkUdtvIzQkLn4rZMCrLEku+5MAFyJPrS+uLP9/wfqNKSAceED8/hXuzybZFN2mPl20tlTwb2FysVG/5o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209657; c=relaxed/simple;
	bh=zqltx1sHdx6Zf3JYvoQ41z691/8pRP5WGEjgJdF6GYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPO8h+uMvkTzuAUkA3Wb22A4zRQJyNsD5UVr96DZea9li6p3gvi306Ay/rfEj+pAfhr+UeRpnVm2KKUzD+HSxoV1/KfJIgWZptava+fOJ5BhGmLttpmSRGBU1KHEwWdQMTm303ShhTDQUHPLJW6vN2WmioJ6hqUw46YXfbfjHr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLPeRwDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLPeRwDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB871C4CEC3;
	Sun,  1 Sep 2024 16:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209657;
	bh=zqltx1sHdx6Zf3JYvoQ41z691/8pRP5WGEjgJdF6GYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLPeRwDufhFK0ibemMImYB6mEVzDUGX9KRgc3In4uIur7Gxmbey8BK4YxQfP++vGt
	 5nSZDdnNo4XGRWng6oFSaLgI71UjOo0coJ7jduAr8tvUxfJrK/Hs9vbyD/D8YaviQc
	 eMaPrx1lLqjkbVOojRtl+LaOXbfKpRDr076pqKjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/151] drm/msm/dp: reset the link phy params before link training
Date: Sun,  1 Sep 2024 18:17:45 +0200
Message-ID: <20240901160818.059704313@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit 319aca883bfa1b85ee08411541b51b9a934ac858 ]

Before re-starting link training reset the link phy params namely
the pre-emphasis and voltage swing levels otherwise the next
link training begins at the previously cached levels which can result
in link training failures.

Fixes: 8ede2ecc3e5e ("drm/msm/dp: Add DP compliance tests on Snapdragon Chipsets")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org> # SM8350-HDK
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/605946/
Link: https://lore.kernel.org/r/20240725220450.131245-1-quic_abhinavk@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 07becbf3c64fc..0b0d86d2121b9 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1246,6 +1246,8 @@ static int dp_ctrl_link_train(struct dp_ctrl_private *ctrl,
 	link_info.rate = ctrl->link->link_params.rate;
 	link_info.capabilities = DP_LINK_CAP_ENHANCED_FRAMING;
 
+	dp_link_reset_phy_params_vx_px(ctrl->link);
+
 	dp_aux_link_configure(ctrl->aux, &link_info);
 	drm_dp_dpcd_write(ctrl->aux, DP_MAIN_LINK_CHANNEL_CODING_SET,
 				&encoding, 1);
-- 
2.43.0



