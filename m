Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3CB2C6AF;
	Sun,  1 Sep 2024 17:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210327; cv=none; b=skQc67TnA/8ZMEPoHeG+xdV/rXSG8S9MV7glPm8317WZyV2RoQdn8X8QDlpAlKf0xfroXss8TtezMwpCEwg2rMjx6Mj5yR5KCcEWBhmxfdy5LLnRSRUfAIBuEyIX9fx/DBPaewI1nlh8GjG+nuzyNmsLNkCfLK9unsv3B8rI+FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210327; c=relaxed/simple;
	bh=C/GNcxO4xot7T88AAqUfrgGLwXa//qu20vICvPaZmJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFrBQ7IjB5mZFBKuf8BH8j2TV3tn5S2GbocALB6NCVMczdcCVtMwWbJbhvXhcroalSn0IWNA54p3E1Ibem0VFR8jbMQAZjkPz9j3fW7wEfAhbof+QNP39ox4JkvOFu6AIy+l7R7JxSsP5hJXJQzc5ErFg80Pwj2/eJmhjA2VY5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddXRzVyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddXRzVyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558EFC4CEC3;
	Sun,  1 Sep 2024 17:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210327;
	bh=C/GNcxO4xot7T88AAqUfrgGLwXa//qu20vICvPaZmJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddXRzVyw29giTgQx0LvuX2lOoXcO7xLXj8YsXZQNj2EaoC8IBvgOWnYRCrMtNh35b
	 uTmjsKxE3tHyTqEJeAQ2k1IT5Kk3NVE5Gz0T3kjZ4knLedbzyPN84X4oOAqWOUe4bq
	 iUc96KYiyuTwWAk2rts+EVdXm0qNzSvunugO74C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/215] drm/msm/dp: reset the link phy params before link training
Date: Sun,  1 Sep 2024 18:17:48 +0200
Message-ID: <20240901160829.259072092@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
index 854173df67018..85f86afc55052 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1237,6 +1237,8 @@ static int dp_ctrl_link_train(struct dp_ctrl_private *ctrl,
 	link_info.rate = ctrl->link->link_params.rate;
 	link_info.capabilities = DP_LINK_CAP_ENHANCED_FRAMING;
 
+	dp_link_reset_phy_params_vx_px(ctrl->link);
+
 	dp_aux_link_configure(ctrl->aux, &link_info);
 	drm_dp_dpcd_write(ctrl->aux, DP_MAIN_LINK_CHANNEL_CODING_SET,
 				&encoding, 1);
-- 
2.43.0



