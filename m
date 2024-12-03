Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042561F892C;
	Tue,  3 Dec 2024 15:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241051; cv=none; b=mU08Fy5F/Xb8WqBPaoGwKzob+W0WhKfBoGHHNey0yhuMjjq2UweGCmO/cRM6Nvh+DiayJTaUSWWKfJJS5bg6zY0386+fU4JL2nwA1zOkn5io1vb1m1NuizdZLaSi8XUM5NUPccYOhAURLoQUbBFlHmez4Gp7sg0r9ixZaHOClEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241051; c=relaxed/simple;
	bh=W2nX2w9c05IoDRLyPNbu2QXhXlZPg7h0+glWOxbFrkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQa4XAF/K4I3OuqjySVmwEaYXYIMMAeJotmn7ul4hO5pD1F6Ar0mOYV6nt6DwuSSrVaFqCjJDxl3/sLoiCY3oYZZSXiWbQ61/89RaZijYrepKYWp8nFkVlBD7yiMhMeLVMoJ34LsqfL84VSYtVUwB2uIIsonykuEfGgQijj3UdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQt43J5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQt43J5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7DFC4CECF;
	Tue,  3 Dec 2024 15:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241050;
	bh=W2nX2w9c05IoDRLyPNbu2QXhXlZPg7h0+glWOxbFrkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQt43J5pxYxMO2Wdz9cnayEpPdKyKY19T+X37kNXtdo/KyuiyYeV5NXcXhwaZ/toi
	 khSkQFXNExc/l4V5sP3BRh0p3u7OILl8xaxx/URCp1GfpAznHu2KxPKK9NL1Vuwmxf
	 wA23okpZQUh06X+PchxIli9jLiT0tijMbG5emoyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Luba <lukasz.luba@arm.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 279/826] drm/msm/gpu: Check the status of registration to PM QoS
Date: Tue,  3 Dec 2024 15:40:06 +0100
Message-ID: <20241203144754.657608223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



