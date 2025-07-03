Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4BF2EF285;
	Thu,  3 Jul 2025 15:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555765; cv=none; b=jsLsT/MthMigdsNrINcQH40rcJyTzAz07X/5kpjiLGGaDpLHeqARZPViDLv6Y+wWp/Vgkd9+PdOfrhg79aOmtazMJYmyZD0rslq8aGkYlAFVXS5oDI3MOceD3fS4NAsWalUI9vLUx4zdcVvGCsCUQYEihAFt0ged1JFRmYxT83E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555765; c=relaxed/simple;
	bh=ZoM3KBTDCAcpREGar3/QI4r7yQW5z4Zz3xouXbWcBs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oikfOlCFpEa0kb6dLaYqBnEpq/M6BjdzN4neHRh1uYsgNZnkMyGYQtloisigDX4uJXtYuGLZ7tVvq5f/BqUivM6zRhcFd00MqRW4hBFBSD9tBTcCFvOL/W45G2nyZVvA2mQgebpOy5WRSpRWjqYCRsAIiBRRPpcTMgON4lLiyJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9ceiYGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9ceiYGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0740DC4CEED;
	Thu,  3 Jul 2025 15:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555764;
	bh=ZoM3KBTDCAcpREGar3/QI4r7yQW5z4Zz3xouXbWcBs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9ceiYGYGgHncRpKyn6nh3POPlOkUNUGFxOh8nIm6l+5me0JwXX8hFWV3T6D2tjsH
	 kYquhgitcmHAwvoof1C0otKizEoGdqkWDcu+6UffOdruWBq/goBrf/pgMlcKtVSISd
	 +VYPbpWvcgkr1LLSUx5xQF4gH+mlshl2CUQz6LQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robdclark@chromium.org>
Subject: [PATCH 6.6 115/139] drm/msm/gpu: Fix crash when throttling GPU immediately during boot
Date: Thu,  3 Jul 2025 16:42:58 +0200
Message-ID: <20250703143945.685591243@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit b71717735be48d7743a34897e9e44a0b53e30c0e upstream.

There is a small chance that the GPU is already hot during boot. In that
case, the call to of_devfreq_cooling_register() will immediately try to
apply devfreq cooling, as seen in the following crash:

  Unable to handle kernel paging request at virtual address 0000000000014110
  pc : a6xx_gpu_busy+0x1c/0x58 [msm]
  lr : msm_devfreq_get_dev_status+0xbc/0x140 [msm]
  Call trace:
   a6xx_gpu_busy+0x1c/0x58 [msm] (P)
   devfreq_simple_ondemand_func+0x3c/0x150
   devfreq_update_target+0x44/0xd8
   qos_max_notifier_call+0x30/0x84
   blocking_notifier_call_chain+0x6c/0xa0
   pm_qos_update_target+0xd0/0x110
   freq_qos_apply+0x3c/0x74
   apply_constraint+0x88/0x148
   __dev_pm_qos_update_request+0x7c/0xcc
   dev_pm_qos_update_request+0x38/0x5c
   devfreq_cooling_set_cur_state+0x98/0xf0
   __thermal_cdev_update+0x64/0xb4
   thermal_cdev_update+0x4c/0x58
   step_wise_manage+0x1f0/0x318
   __thermal_zone_device_update+0x278/0x424
   __thermal_cooling_device_register+0x2bc/0x308
   thermal_of_cooling_device_register+0x10/0x1c
   of_devfreq_cooling_register_power+0x240/0x2bc
   of_devfreq_cooling_register+0x14/0x20
   msm_devfreq_init+0xc4/0x1a0 [msm]
   msm_gpu_init+0x304/0x574 [msm]
   adreno_gpu_init+0x1c4/0x2e0 [msm]
   a6xx_gpu_init+0x5c8/0x9c8 [msm]
   adreno_bind+0x2a8/0x33c [msm]
   ...

At this point we haven't initialized the GMU at all yet, so we cannot read
the GMU registers inside a6xx_gpu_busy(). A similar issue was fixed before
in commit 6694482a70e9 ("drm/msm: Avoid unclocked GMU register access in
6xx gpu_busy"): msm_devfreq_init() does call devfreq_suspend_device(), but
unlike msm_devfreq_suspend(), it doesn't set the df->suspended flag
accordingly. This means the df->suspended flag does not match the actual
devfreq state after initialization and msm_devfreq_get_dev_status() will
end up accessing GMU registers, causing the crash.

Fix this by setting df->suspended correctly during initialization.

Cc: stable@vger.kernel.org
Fixes: 6694482a70e9 ("drm/msm: Avoid unclocked GMU register access in 6xx gpu_busy")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/650772/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_gpu_devfreq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/msm/msm_gpu_devfreq.c
+++ b/drivers/gpu/drm/msm/msm_gpu_devfreq.c
@@ -156,6 +156,7 @@ void msm_devfreq_init(struct msm_gpu *gp
 	priv->gpu_devfreq_config.downdifferential = 10;
 
 	mutex_init(&df->lock);
+	df->suspended = true;
 
 	ret = dev_pm_qos_add_request(&gpu->pdev->dev, &df->boost_freq,
 				     DEV_PM_QOS_MIN_FREQUENCY, 0);


