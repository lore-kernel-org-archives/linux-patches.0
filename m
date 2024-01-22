Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BD55C5FB;
	Tue, 23 Jan 2024 01:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974365; cv=none; b=fjVPJWO27FqzV8DfAF9kEhwU6BF2J45qyEKNRsx2HHkZNCd/NEQIxNcdm6oO0cEClOmtzLByAfvv/QCS4OqzUdDB6mRdTN2huDpQnVL6LSN/2kcXizT7lmFBGHs2/iyfsaRC/yil8k8z03z9XTqjWGx/x9A7t6BJJIOiVkXdKmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974365; c=relaxed/simple;
	bh=Ns19Snfd63YksiOtcr+W9l1iw2RCXe8iGYm0bY7+zqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+2060B4wkWzy3cqLHSNxbFBw2ZNJTlroO2zOnynvusOEjyi1W6KlSSvIXJCifXrcThwBqk+7cBh5OJes578+EPWXMzcOuBTkB1zfgIXTS1kMznhg8lxGcqR1l4IN0IkDFry3X77laAUWVmAyOXTvDLt4YaQ7d8gk6v6vGyqH3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jh2trWfx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jh2trWfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E0AC43394;
	Tue, 23 Jan 2024 01:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974364;
	bh=Ns19Snfd63YksiOtcr+W9l1iw2RCXe8iGYm0bY7+zqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jh2trWfx99zuzG1rx8Wwb+OZesAtO19IT+Dt6sV7E58leG2zemAJYEI0ji1Jo3LHK
	 JhUVKsoMD01gxrZisq24K6nYAel1ni2ttpkw3nIlB/U1/Tz8N3pMtt2pqAFPvoKICw
	 YvhrZHlSH2WhwzBfyWGWqDeZxSZHzzV3CgGNAJC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 193/374] drm/msm/dsi: Use pm_runtime_resume_and_get to prevent refcnt leaks
Date: Mon, 22 Jan 2024 15:57:29 -0800
Message-ID: <20240122235751.331172300@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 3d07a411b4faaf2b498760ccf12888f8de529de0 ]

This helper has been introduced to avoid programmer errors (missing
_put calls leading to dangling refcnt) when using pm_runtime_get, use it.

While at it, start checking the return value.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 5c8290284402 ("drm/msm/dsi: Split PHY drivers to separate files")
Patchwork: https://patchwork.freedesktop.org/patch/543350/
Link: https://lore.kernel.org/r/20230620-topic-dsiphy_rpm-v2-1-a11a751f34f0@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
index 6a917fe69a83..4b5b0a4b051b 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -588,7 +588,9 @@ static int dsi_phy_enable_resource(struct msm_dsi_phy *phy)
 	struct device *dev = &phy->pdev->dev;
 	int ret;
 
-	pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(phy->ahb_clk);
 	if (ret) {
-- 
2.43.0



