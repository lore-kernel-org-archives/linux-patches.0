Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2859020CCCA;
	Tue, 26 Aug 2025 13:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215299; cv=none; b=Jjmy0Rs0Tg90NBgGBeBbbC9GFyH/qAc/gyzKNJS1MV8PlRkK3BpgE7E2snnxnVRLvVGx8+E2AAMJ/76l2empfXo1e9myIBbWw4j87y1naOFLbXznTF5QwXUgfBv3kwD+r8Mthy+JxzfjvChDfkNjcPKKDQQMGP8jm4Q6+TO3FiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215299; c=relaxed/simple;
	bh=An4KRtQPmC11i/WX+bEjtWE8+JOCiMuUoxlvJX7dFcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qW9cVIkrPELImZcu2CdQHLDF+4Hux0iRlUoQu/3wYnBbm1c+7gcNy9ZUJn7nUqQ16BmmgBHTGB5VfuCuyZiOZL89a3XoDyoE6Xh6IfMgChBVsev9hSynUn+zujVNuKn3svLkvWujCkcEEvPpzwhr+sfT1dqAtLicmnbwpMPxKh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fz+yZ5q9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fz+yZ5q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB05C4CEF1;
	Tue, 26 Aug 2025 13:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215299;
	bh=An4KRtQPmC11i/WX+bEjtWE8+JOCiMuUoxlvJX7dFcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fz+yZ5q9r11bE3jTNBmu8vPB3mzlVxHofaBZmNmvGI5adinUiN0r13hke4Ib3ullK
	 yT2JPRvgyZUdEGTt/wkXZUnAfKoG63JRaTmylJoJ11piGjaA2kSj//eGvmeFwF71V0
	 zs+UMDoF8MwO9ZNm20iPLVwpy8JS3zlbOn8ij0Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baihan Li <libaihan@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 462/482] drm/hisilicon/hibmc: fix the hibmc loaded failed bug
Date: Tue, 26 Aug 2025 13:11:55 +0200
Message-ID: <20250826110942.236891657@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baihan Li <libaihan@huawei.com>

[ Upstream commit 93a08f856fcc5aaeeecad01f71bef3088588216a ]

When hibmc loaded failed, the driver use hibmc_unload to free the
resource, but the mutexes in mode.config are not init, which will
access an NULL pointer. Just change goto statement to return, because
hibnc_hw_init() doesn't need to free anything.

Fixes: b3df5e65cc03 ("drm/hibmc: Drop drm_vblank_cleanup")
Signed-off-by: Baihan Li <libaihan@huawei.com>
Signed-off-by: Yongbang Shi <shiyongbang@huawei.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250813094238.3722345-5-shiyongbang@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
index fe4269c5aa0a..20c2af66ee53 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
@@ -269,12 +269,12 @@ static int hibmc_load(struct drm_device *dev)
 
 	ret = hibmc_hw_init(priv);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = drmm_vram_helper_init(dev, pci_resource_start(pdev, 0), priv->fb_size);
 	if (ret) {
 		drm_err(dev, "Error initializing VRAM MM; %d\n", ret);
-		goto err;
+		return ret;
 	}
 
 	ret = hibmc_kms_init(priv);
-- 
2.50.1



