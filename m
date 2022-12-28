Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FF21863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6220C433EF;
	Wed, 28 Dec 2022 15:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242395;
	bh=i4kn/bkOE2FWuqdT+xmrCUi/bo4Ef6WDtqiFk35+D7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDcBJdinGDiHBRA08CG2vd6FKC7Z+mxapcxX5bX16QgtVEx/hixmFmPZkaPZs7iBs
	 aytcLKxEdel/WUl0QEwEwHHzb9C8+fF1AilHrrUtbmihF5Z4SkXUIcqdMxt1zgQwL3
	 58z3+HF7VPHF028U1xRAzBfz43O1//Id7YM/jdjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0405/1073] drm/msm/mdp5: fix reading hw revision on db410c platform
Date: Wed, 28 Dec 2022 15:33:13 +0100
Message-Id: <20221228144339.019136994@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 5d8c0417ea62fed3cec7f5daed06a20477efeb39 ]

Since the commit commit c6122688f265 ("drm/msm/mdp5: stop overriding
drvdata") reading the MDP5 hw revision on db410c will crash the board
as the MDSS_GDSC is not enabled. Revert a part of the offending commit
(moving rpm enablement) and set priv->kms earlier. This make it possible
to use pm_runtime_get_sync() during read_mdp_hw_revision(), which will
power up both the MDP5 and MDSS devices.

Fixes: c6122688f265 ("drm/msm/mdp5: stop overriding drvdata")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/512985/
Link: https://lore.kernel.org/r/20221125000213.252115-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
index b46f983f2b46..29ae5c9613f3 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
@@ -519,10 +519,9 @@ static void read_mdp_hw_revision(struct mdp5_kms *mdp5_kms,
 	struct device *dev = &mdp5_kms->pdev->dev;
 	u32 version;
 
-	/* Manually enable the MDP5, as pm runtime isn't usable yet. */
-	mdp5_enable(mdp5_kms);
+	pm_runtime_get_sync(dev);
 	version = mdp5_read(mdp5_kms, REG_MDP5_HW_VERSION);
-	mdp5_disable(mdp5_kms);
+	pm_runtime_put_sync(dev);
 
 	*major = FIELD(version, MDP5_HW_VERSION_MAJOR);
 	*minor = FIELD(version, MDP5_HW_VERSION_MINOR);
@@ -839,6 +838,12 @@ static int mdp5_init(struct platform_device *pdev, struct drm_device *dev)
 	 */
 	clk_set_rate(mdp5_kms->core_clk, 200000000);
 
+	/* set uninit-ed kms */
+	priv->kms = &mdp5_kms->base.base;
+
+	pm_runtime_enable(&pdev->dev);
+	mdp5_kms->rpm_enabled = true;
+
 	read_mdp_hw_revision(mdp5_kms, &major, &minor);
 
 	mdp5_kms->cfg = mdp5_cfg_init(mdp5_kms, major, minor);
@@ -887,12 +892,6 @@ static int mdp5_init(struct platform_device *pdev, struct drm_device *dev)
 	if (ret)
 		goto fail;
 
-	/* set uninit-ed kms */
-	priv->kms = &mdp5_kms->base.base;
-
-	pm_runtime_enable(&pdev->dev);
-	mdp5_kms->rpm_enabled = true;
-
 	return 0;
 fail:
 	if (mdp5_kms)
-- 
2.35.1



