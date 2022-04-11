Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2E41865
	for <patches@lists.linux.dev>; Mon, 11 Apr 2022 18:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BB7C385A4;
	Mon, 11 Apr 2022 18:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1649700870;
	bh=tlaHWLebE/3fsbDzy1BqRre1Irq1Ran1Bo9T0hGhvGY=;
	h=From:To:Cc:Subject:Date:From;
	b=T9/mL/lo9AfzCcQZyV5d4/4yQD9AJkqaGdOY7ydKCtbFM4+z4bwIW1pnqtSJTYeqR
	 ZN+ufL7BMWqyV4PXIBxosC03wnUvfOvArTrsLteuhtGKIcUSSGqlIVDGDboMmzxYL6
	 PeiB9VMOrghGCFwBGqo2+gEcjBlvgDYKu2j4pF8LlRzWGcdYvJU5vE6W3w551LVFeK
	 RMQGNmr7YjLuKJfHg+a8AJQZm2NNVV2uZz/oPr8rZr1HJMBzY5dgO/sCFUfUAzwAvI
	 1vslHFnt8ooVpwPSBzfi+zKaOYfzK4zNfCpwWHlNnX2GwQ5Hd+oBfWfil9CouMqi2g
	 otMkvwrjvUz1A==
From: Nathan Chancellor <nathan@kernel.org>
To: Rob Clark <robdclark@gmail.com>,
	Sean Paul <sean@poorly.run>
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	linux-arm-msm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v2] drm/msm/gpu: Avoid -Wunused-function with !CONFIG_PM_SLEEP
Date: Mon, 11 Apr 2022 11:12:50 -0700
Message-Id: <20220411181249.2758344-1-nathan@kernel.org>
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

To resolve this, use the SYSTEM_SLEEP_PM_OPS() and RUNTIME_PM_OPS()
macros, which were introduced in commit 1a3c7bb08826 ("PM: core: Add new
*_PM_OPS macros, deprecate old ones"). They are designed to avoid these
compiler warnings while still guarding their use on
CONFIG_PM{,_SLEEP}=y.

Fixes: 7e4167c9e021 ("drm/msm/gpu: Park scheduler threads for system suspend")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

v1 -> v2: https://lore.kernel.org/20220330180541.62250-1-nathan@kernel.org/

* Avoid using #ifdef altogether by using new PM macros.

 drivers/gpu/drm/msm/adreno/adreno_device.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index 661dfa7681fb..8706bcdd1472 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -599,7 +599,6 @@ static const struct of_device_id dt_match[] = {
 	{}
 };
 
-#ifdef CONFIG_PM
 static int adreno_runtime_resume(struct device *dev)
 {
 	struct msm_gpu *gpu = dev_to_gpu(dev);
@@ -682,11 +681,9 @@ static int adreno_system_resume(struct device *dev)
 	return pm_runtime_force_resume(dev);
 }
 
-#endif
-
 static const struct dev_pm_ops adreno_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(adreno_system_suspend, adreno_system_resume)
-	SET_RUNTIME_PM_OPS(adreno_runtime_suspend, adreno_runtime_resume, NULL)
+	SYSTEM_SLEEP_PM_OPS(adreno_system_suspend, adreno_system_resume)
+	RUNTIME_PM_OPS(adreno_runtime_suspend, adreno_runtime_resume, NULL)
 };
 
 static struct platform_driver adreno_driver = {

base-commit: 0fe35b8dcb8b3c4b751a1a44f1e128b690af71e4
-- 
2.35.1

