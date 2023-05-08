Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7917B168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AEDC433EF;
	Mon,  8 May 2023 11:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543974;
	bh=xgFAfjcZyeVlfpxoVw0HA594Fixeh7xBnMIzRAK34VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMj5r9zmqiV9UTEWeQ8bSwKYThK+zqBdEWcXIowULzOuy6QW0hQfikjY+TwbhBdMC
	 1uEI1dh7xALRwdClDDp0b4WhfN6wGvDltq9XD9SbRbiCyERXnrchFtb1LL7qUrhuIW
	 TQjqZXJlCPC1Y3HFMnPbAY9Bp/WOfqkHA1XkZGvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 262/694] Revert "drm/msm: Add missing check and destroy for alloc_ordered_workqueue"
Date: Mon,  8 May 2023 11:41:37 +0200
Message-Id: <20230508094440.783508639@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit dfa70344d1b5f5ff08525a8c872c8dd5e82fc5d9 ]

This reverts commit 643b7d0869cc7f1f7a5ac7ca6bd25d88f54e31d0.

A recent patch that tried to fix up the msm_drm_init() paths with
respect to the workqueue but only ended up making things worse:

First, the newly added calls to msm_drm_uninit() on early errors would
trigger NULL-pointer dereferences, for example, as the kms pointer would
not have been initialised. (Note that these paths were also modified by
a second broken error handling patch which in effect cancelled out this
part when merged.)

Second, the newly added allocation sanity check would still leak the
previously allocated drm device.

Instead of trying to salvage what was badly broken (and clearly not
tested), let's revert the bad commit so that clean and backportable
fixes can be added in its place.

Fixes: 643b7d0869cc ("drm/msm: Add missing check and destroy for alloc_ordered_workqueue")
Cc: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/525107/
Link: https://lore.kernel.org/r/20230306100722.28485-2-johan+linaro@kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index aca48c868c14d..b7f5a78eadd4a 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -420,8 +420,6 @@ static int msm_drm_init(struct device *dev, const struct drm_driver *drv)
 	priv->dev = ddev;
 
 	priv->wq = alloc_ordered_workqueue("msm", 0);
-	if (!priv->wq)
-		return -ENOMEM;
 
 	INIT_LIST_HEAD(&priv->objects);
 	mutex_init(&priv->obj_lock);
-- 
2.39.2



