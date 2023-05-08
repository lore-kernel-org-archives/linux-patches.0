Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952E1171A1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1CEC433EF;
	Mon,  8 May 2023 11:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545659;
	bh=o2sP2FvTlBNfPBIjt96CcSxigoA8+0TGU+aq5Py8swY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAfR/mgzo1+sGmNK71o1EwlsaVsR3U6odipDGJrouM0iWqIkHnukwSzdPwe+BN2IL
	 S0Ohp0McwS6NAwuM0I6XG3OR4BoGOO5N+CtnsyqAfFin/qWCa/Ub7MxNYxQoOCV/R6
	 AqfX2JpXanls3W03uqAcLt6LNME77uRDLPnZqiq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/371] drm/msm/adreno: drop bogus pm_runtime_set_active()
Date: Mon,  8 May 2023 11:45:13 +0200
Message-Id: <20230508094816.467519454@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit db7662d076c973072d788bd0e8130e04430307a1 ]

The runtime PM status can only be updated while runtime PM is disabled.

Drop the bogus pm_runtime_set_active() call that was made after enabling
runtime PM and which (incidentally but correctly) left the runtime PM
status set to 'suspended'.

Fixes: 2c087a336676 ("drm/msm/adreno: Load the firmware before bringing up the hardware")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Patchwork: https://patchwork.freedesktop.org/patch/524972/
Link: https://lore.kernel.org/r/20230303164807.13124-4-johan+linaro@kernel.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index 32207bc42b281..3eb9146653444 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -404,9 +404,6 @@ struct msm_gpu *adreno_load_gpu(struct drm_device *dev)
 	 */
 	pm_runtime_enable(&pdev->dev);
 
-	/* Make sure pm runtime is active and reset any previous errors */
-	pm_runtime_set_active(&pdev->dev);
-
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0) {
 		pm_runtime_put_sync(&pdev->dev);
-- 
2.39.2



