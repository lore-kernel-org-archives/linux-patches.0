Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF961C57B3;
	Tue, 27 Aug 2024 15:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771466; cv=none; b=ABrK4ngBscOsm9nEQylz6g71YdcRF22odan9uQBCIKS+BdOogWEIJhqDB7kN2LIeTTo9Dr1SYKZvw+CWgrbD98In09XKtzMzrio+934urrCIZlrSBHe/Pn1R5PN5pnPgbrOTAbTB9SBU69t/XN3vk5F9f3RBCRte03Hbaud8E/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771466; c=relaxed/simple;
	bh=Psp6SKZsEm/fN3f0SnqgSFa4UsW4PmRXpG9LgiyWlLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMM5Cm8RQqOd4gk0oX8aOGTurQ88PhRV7QWhlaLS1RJnC/f/d4Jua2/pLcV/bY6cYYnGvp2ldojR7vypdzXHv32sqqVK/70EFb5IWNLxfr8gCenBnoJfRVL8hEFU+kpTK7QPaGoHUeP3oSMxWcDZ/AhnRGujo8lBbkZ6UsCiYUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Roe7wKor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Roe7wKor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46584C4DDED;
	Tue, 27 Aug 2024 15:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771466;
	bh=Psp6SKZsEm/fN3f0SnqgSFa4UsW4PmRXpG9LgiyWlLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Roe7wKormmaUhFUB79ivwF8cfckcd/n8iEVwFjj7bE2JVFm8D+8+DuYF8uxjZsDc8
	 vdgjM22lsFV3G0qDA2RhkXPi146x5CGOM+J2jTGuPk0/BzS+gwgQIhBAuq5Dz9jMRo
	 1lV6mgrjZpLB4p7IyRCwUAxotRJcy/Cq8miSOt0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 195/273] drm/msm/dp: reset the link phy params before link training
Date: Tue, 27 Aug 2024 16:38:39 +0200
Message-ID: <20240827143840.829297897@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7bc8a9f0657a9..f342fc5ae41ec 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1286,6 +1286,8 @@ static int dp_ctrl_link_train(struct dp_ctrl_private *ctrl,
 	link_info.rate = ctrl->link->link_params.rate;
 	link_info.capabilities = DP_LINK_CAP_ENHANCED_FRAMING;
 
+	dp_link_reset_phy_params_vx_px(ctrl->link);
+
 	dp_aux_link_configure(ctrl->aux, &link_info);
 
 	if (drm_dp_max_downspread(dpcd))
-- 
2.43.0



