Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCC121B91D;
	Thu, 12 Dec 2024 16:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019290; cv=none; b=EGrDyxKN000uRUwVETIbEuCLI2zU9JUsKuZPqC5cUsntEwKANQHvMa9GlZYl6Gj0HnRMNn+fI8gdeINIKbBRvttU9CacIYWg484gxQvvRlzu7aRlVOVFvo+K11BgRwcbEUjtZtnByVFGx/KKxlDvv74kb/k3MVd8OhCrFMQfgRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019290; c=relaxed/simple;
	bh=7D2TYAzmrRRwzdwRcI0A2UsubEXRsBzLXsO2KtiXSTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qi+SgjBQyIEgiFyfgnDa1gy179OkIrbZI5X3o4iA22hDHtse4hHJHvwT+tc0p6bWEuyok9SJ9QZRoI2JmgB2nhhLQJ2gNfaFucIaW+eeSFVJV6FV05GnHUJnxTU2yqiE8GuaBNBnRoEfOPcxPYdm1DiZTkaxKRaZwHegSHCkblg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onMUic89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onMUic89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B875C4CED0;
	Thu, 12 Dec 2024 16:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019290;
	bh=7D2TYAzmrRRwzdwRcI0A2UsubEXRsBzLXsO2KtiXSTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onMUic89aEBKpR2SGEl+qXf3Uw0D9kJid+73Vt0zDEnWPvuVIJr0DAcu18kh+cGSp
	 rtgUjLf6GMaNbjIGPSUUWz0b4wdoavJUcUmnbLPI146mT+0Lx3Uq/yVgQVnWDmOAYj
	 zz4KPpjR1ozqnT1tLEiiTV82x+fKLzziisTEd4sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Luba <lukasz.luba@arm.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/772] drm/msm/gpu: Check the status of registration to PM QoS
Date: Thu, 12 Dec 2024 15:51:54 +0100
Message-ID: <20241212144356.929077585@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ae5380e2abf76..4e73b915fe1a2 100644
--- a/drivers/gpu/drm/msm/msm_gpu_devfreq.c
+++ b/drivers/gpu/drm/msm/msm_gpu_devfreq.c
@@ -140,6 +140,7 @@ void msm_devfreq_init(struct msm_gpu *gpu)
 {
 	struct msm_gpu_devfreq *df = &gpu->devfreq;
 	struct msm_drm_private *priv = gpu->dev->dev_private;
+	int ret;
 
 	/* We need target support to do devfreq */
 	if (!gpu->funcs->gpu_busy)
@@ -147,8 +148,12 @@ void msm_devfreq_init(struct msm_gpu *gpu)
 
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



