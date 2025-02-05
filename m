Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA5515198D;
	Wed,  5 Feb 2025 14:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764162; cv=none; b=PmfvefV9di5o2dZSaRsYQ9cHvm/ji4h6vgM0lvq/smP+4eHGjTA/w7KJ7C9uDvYRWJKNYx9DQZWndG+EBC0HdZ4nrSKg5h+yjPw5x+kJ9dopeD7m2YzCwl0bgmdp0yvEmJojENYhB4Odc4JbMakM/2awA1BCT5kLBrRjuWG2h9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764162; c=relaxed/simple;
	bh=2isLC3BhsbvnWbvxwcFsXDG4ruIk79yHdXwB6t+HypU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVYa1yV4ENdw/ppMmWpiXjQl1NO2PTOtKgxh6fVN7hr+NX8ATw8+2QRskkwjnPVcSJw8PgrGOsAg5uKJpac+ueI5dGpOeTPKB6vj8OJdkwEyKbCeTcvuM3+tfoIXOiOBWuKHr5OTkzvNz2f4v/iswSlPkxZiODANSh1Ocn3dAtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cqdboz+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cqdboz+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA3DC4CED6;
	Wed,  5 Feb 2025 14:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764162;
	bh=2isLC3BhsbvnWbvxwcFsXDG4ruIk79yHdXwB6t+HypU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cqdboz+co99tFptQxczU664krRWEBdPdLzv0+0+I5/IIlDYulz1PC0X/8A61QvY35
	 NXNpx8utB1ti9VC/ZPNdY03ezi2AqdDbqtdyumQoZvWafINtYyPB4uU1fBAEsfA6a2
	 jOyVecDy9QjJuIaKKutIUxnc0ZpbEebMxJvOMbMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 053/623] drm/msm/dp: disable the opp table request even for dp_ctrl_off_link()
Date: Wed,  5 Feb 2025 14:36:35 +0100
Message-ID: <20250205134458.258527450@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit a3dd01375a6a21ed3e5dbc58f7004d48561f0977 ]

dp_ctrl_off_link() was created to handle a case where we received
a cable connect and then get a cable disconnect without the corresponding
dp_display_enable(). For such cases the pixel clock will be off but the
link clock will still be on. dp_ctrl_off_link() handles this case by
turning off the link clock only.

However, the vote removal to the opp table for this case was missed.
Remove the opp table vote in dp_ctrl_off_link().

Fixes: 375a126090b9 ("drm/msm/dp: tear down main link at unplug handle immediately")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/627487/
Link: https://lore.kernel.org/r/20241205-dp_mst-v1-2-f8618d42a99a@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index a8069f7c4773f..9c463ae2f8fae 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -2070,6 +2070,7 @@ void msm_dp_ctrl_off_link(struct msm_dp_ctrl *msm_dp_ctrl)
 
 	msm_dp_catalog_ctrl_mainlink_ctrl(ctrl->catalog, false);
 
+	dev_pm_opp_set_rate(ctrl->dev, 0);
 	msm_dp_ctrl_link_clk_disable(&ctrl->msm_dp_ctrl);
 
 	DRM_DEBUG_DP("Before, phy=%p init_count=%d power_on=%d\n",
-- 
2.39.5



