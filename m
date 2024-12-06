Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2AA53A7;
	Fri,  6 Dec 2024 15:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497284; cv=none; b=DiKGejPUe6zCaEh1Qp3hdfvmBLMx2CUxCE/9mYxxRXdgLvcaTwh4Ba4JOKASZqbSVyyhX1bueXDoQk0pl/dchEUo3UcGn4hWXjbcFLpVC70PU7AzUQ/ziIVzdocXy9GDqiHu97KamDXkcpLCjFiqtATRUkcrOvo+dqygShZzPCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497284; c=relaxed/simple;
	bh=LW9SrVAkT12Q1ocynj3A6PKVjc1ly0NigOT/QAa8j7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7xqlxTYbbxVVU2G6qTLb1IiZGKE5VEy/fJQ51322VuxC/+KFfgj+7DYUwm0C3AIHjN9lVKg3HyEhl0GTRhZk3dj2tTrDUdnECuhooulOIcsUn0QsCozwzgpGFLC5HIz7Z6Cars1FORQOm6SwtxRTUHlX+3+ktswrYauwPxj+oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdPFT1xk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdPFT1xk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E656C4CED1;
	Fri,  6 Dec 2024 15:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497283;
	bh=LW9SrVAkT12Q1ocynj3A6PKVjc1ly0NigOT/QAa8j7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdPFT1xkR8e8TShK0vGgt4ZzQkfRU4YMZwQ5vFa9wjOPPOyWeLcXjq53wuhUgDMqW
	 kszNx1ftZhzdxiYkFGrvN0LtxlKnmo7yEZ+v2JAnsmFM130DeHrvozIiIW2MBP3B8P
	 O/+h41JQHJfCf6JiBs9F50M7Vm7LsU8cG72Qm0AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Luba <lukasz.luba@arm.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 216/676] drm/msm/gpu: Check the status of registration to PM QoS
Date: Fri,  6 Dec 2024 15:30:35 +0100
Message-ID: <20241206143701.777653050@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Lukasz Luba <lukasz.luba@arm.com>

[ Upstream commit 8f32ddd87e499ba6d2dc74ce30b6932baf1e1fc3 ]

There is a need to check the returned value of the registration function.
In case of returned error, print that and stop the init process.

Fixes: 7c0ffcd40b16 ("drm/msm/gpu: Respect PM QoS constraints")
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
Patchwork: https://patchwork.freedesktop.org/patch/620336/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gpu_devfreq.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gpu_devfreq.c b/drivers/gpu/drm/msm/msm_gpu_devfreq.c
index ea70c1c32d940..6970b0f7f457c 100644
--- a/drivers/gpu/drm/msm/msm_gpu_devfreq.c
+++ b/drivers/gpu/drm/msm/msm_gpu_devfreq.c
@@ -140,6 +140,7 @@ void msm_devfreq_init(struct msm_gpu *gpu)
 {
 	struct msm_gpu_devfreq *df = &gpu->devfreq;
 	struct msm_drm_private *priv = gpu->dev->dev_private;
+	int ret;
 
 	/* We need target support to do devfreq */
 	if (!gpu->funcs->gpu_busy)
@@ -156,8 +157,12 @@ void msm_devfreq_init(struct msm_gpu *gpu)
 
 	mutex_init(&df->lock);
 
-	dev_pm_qos_add_request(&gpu->pdev->dev, &df->boost_freq,
-			       DEV_PM_QOS_MIN_FREQUENCY, 0);
+	ret = dev_pm_qos_add_request(&gpu->pdev->dev, &df->boost_freq,
+				     DEV_PM_QOS_MIN_FREQUENCY, 0);
+	if (ret < 0) {
+		DRM_DEV_ERROR(&gpu->pdev->dev, "Couldn't initialize QoS\n");
+		return;
+	}
 
 	msm_devfreq_profile.initial_freq = gpu->fast_rate;
 
-- 
2.43.0



