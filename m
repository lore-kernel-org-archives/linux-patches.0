Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB5ADF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52ED2C433D2;
	Mon, 15 May 2023 16:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168769;
	bh=cr2EG/vIZ8hnNdAuvjvMvr5H3eALVt9l5CavgR+kWX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqvUyI5ppwxzFIcvnj3zwW2MBM//pboBklJ1wIgcVOAWI/OMi4lXNFRdywFr7ddq4
	 5QiU7kH8S56ABxUw9xzy1Vz2XCv6pdEpyiVnzYXSZVjPZ6oynttgArWNi7AAYp3Ezn
	 Rl063+GKKVTdOqbw2X3W+3R/0+qDakzXrRb3+hDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/191] drm/msm/adreno: drop bogus pm_runtime_set_active()
Date: Mon, 15 May 2023 18:24:33 +0200
Message-Id: <20230515161708.504426918@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
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
index 0275be7e13b19..7acb53a907e5c 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -196,9 +196,6 @@ struct msm_gpu *adreno_load_gpu(struct drm_device *dev)
 	 */
 	pm_runtime_enable(&pdev->dev);
 
-	/* Make sure pm runtime is active and reset any previous errors */
-	pm_runtime_set_active(&pdev->dev);
-
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0) {
 		dev_err(dev->dev, "Couldn't power up the GPU: %d\n", ret);
-- 
2.39.2



