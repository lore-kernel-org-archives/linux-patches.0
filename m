Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC0429A2
	for <patches@lists.linux.dev>; Wed, 30 Mar 2022 18:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2037CC340EE;
	Wed, 30 Mar 2022 18:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1648663598;
	bh=c40oLSuQ05wWwsFeXD0porA4/1RgYoRPdHiOlqdCHXE=;
	h=From:To:Cc:Subject:Date:From;
	b=kQKiSz1we2LYxuvicJhG6Ebsg1zV7ks2eShcPlJO1sWfP3CbtT1qa9KV5oJs12Dlr
	 Hu0tz7xgQWo2EdZ4f8115s3FccUEPu63qvJxB9Cq2S5QQu52/wIUVNBS+nx2n+BlQp
	 11rvaoZKFK8/TjvZKOW+UB6S2RcS7abmU3ghFZ8wpjm1nWGxobpeV7yZEwFLP80xMQ
	 WIQTyjmXVAYb8WoforyrsHywOyYZEHGMaVu8heEKKpNB3WhDOZxkgRugSt4JbHZBr2
	 rc6+7CVYm73Req1UNo6e/S8+ZFgCgQrVqIfHiTxhJqx5E32wwz5j+Suxmwoh8p26US
	 YMPSajaOPl7hQ==
From: Nathan Chancellor <nathan@kernel.org>
To: Rob Clark <robdclark@gmail.com>,
	Sean Paul <sean@poorly.run>
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>,
	linux-arm-msm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] drm/msm/gpu: Avoid -Wunused-function with !CONFIG_PM_SLEEP
Date: Wed, 30 Mar 2022 11:05:41 -0700
Message-Id: <20220330180541.62250-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building with CONFIG_PM=y and CONFIG_PM_SLEEP=n (such as ARCH=riscv
allmodconfig), the following warnings/errors occur:

  drivers/gpu/drm/msm/adreno/adreno_device.c:679:12: error: 'adreno_system_resume' defined but not used [-Werror=unused-function]
    679 | static int adreno_system_resume(struct device *dev)
        |            ^~~~~~~~~~~~~~~~~~~~
  drivers/gpu/drm/msm/adreno/adreno_device.c:655:12: error: 'adreno_system_suspend' defined but not used [-Werror=unused-function]
    655 | static int adreno_system_suspend(struct device *dev)
        |            ^~~~~~~~~~~~~~~~~~~~~
  cc1: all warnings being treated as errors

These functions are only used in SET_SYSTEM_SLEEP_PM_OPS(), which
evaluates to empty when CONFIG_PM_SLEEP is not set, making these
functions unused.

Traditionally, these functions are marked as __maybe_unused but in this
case, there is already an '#ifdef CONFIG_PM' in the code, so just do the
same thing with CONFIG_PM_SLEEP to resolve the warning.

Fixes: 7e4167c9e021 ("drm/msm/gpu: Park scheduler threads for system suspend")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index 661dfa7681fb..b25915230bab 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -621,6 +621,7 @@ static int adreno_runtime_suspend(struct device *dev)
 	return gpu->funcs->pm_suspend(gpu);
 }
 
+#ifdef CONFIG_PM_SLEEP
 static void suspend_scheduler(struct msm_gpu *gpu)
 {
 	int i;
@@ -681,8 +682,8 @@ static int adreno_system_resume(struct device *dev)
 	resume_scheduler(dev_to_gpu(dev));
 	return pm_runtime_force_resume(dev);
 }
-
-#endif
+#endif /* CONFIG_PM_SLEEP */
+#endif /* CONFIG_PM */
 
 static const struct dev_pm_ops adreno_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(adreno_system_suspend, adreno_system_resume)

base-commit: 05241de1f69eb7f56b0a5e0bec96a7752fad1b2f
-- 
2.35.1

