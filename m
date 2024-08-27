Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6B01C689C;
	Tue, 27 Aug 2024 14:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770627; cv=none; b=ErK6F/uv+kHdYrWhcChDiD3ENokXSlFCMe9J5ZBu32nuSI0AKPi2vBDAeXZLoAd47RmOIQQhP6EiYVZSaFd1zHWbbAUWzXh+/K7DsHIq+StmSIYvW+hLiykWDS2q1qRCLSWDPMBOUV8HcSvTAS+0WtR/7nMJPXWrN7RC9mU+bsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770627; c=relaxed/simple;
	bh=Byk20AK8n+fPv/VvyjQHRW8Gs+80y0h5MTTiDs+SGaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ll/C0OogKw3sYTwYlmHGrV52FzoyVEtJn4ea0swI7dsdW3j6Gm/UJ/JqdBm3aSge4cVcxkCmNHMbxNRp0RB+4ObafHDQ2jfn5pjOeQbyfBxWEeIIKFC//IIY19GvVz8GWbpihO+kLVp6xoEyg8rMjYvNBY/A3OwiJU73RXwy/qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t00KPO9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t00KPO9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B0AC4FE01;
	Tue, 27 Aug 2024 14:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770627;
	bh=Byk20AK8n+fPv/VvyjQHRW8Gs+80y0h5MTTiDs+SGaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t00KPO9sn9GflNzU7La5RpOk09CKMJItpQP+57ON4aSm2n/TdLbOwY4PyUZDa/bZW
	 wRLbnmM3HyGKNdlHixdZEMnEOMJMszc+x9V53UXfSCCLHGT+cIbQ5STGZgnB7suh4r
	 n/ZkpO8tbPYUB4azKsksHb2phPPUp5ur3pc1f1Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 284/341] drm/msm/dp: reset the link phy params before link training
Date: Tue, 27 Aug 2024 16:38:35 +0200
Message-ID: <20240827143854.204751641@linuxfoundation.org>
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
index 780e9747be1fb..7472dfd631b83 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1253,6 +1253,8 @@ static int dp_ctrl_link_train(struct dp_ctrl_private *ctrl,
 	link_info.rate = ctrl->link->link_params.rate;
 	link_info.capabilities = DP_LINK_CAP_ENHANCED_FRAMING;
 
+	dp_link_reset_phy_params_vx_px(ctrl->link);
+
 	dp_aux_link_configure(ctrl->aux, &link_info);
 
 	if (drm_dp_max_downspread(dpcd))
-- 
2.43.0



