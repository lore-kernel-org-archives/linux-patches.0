Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B2823D7FA;
	Tue, 26 Aug 2025 11:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207974; cv=none; b=aDGE8DBglR2WeOF9ZPHc6P6mVWj9pZ8yn8UFG40k6P2RRHGvJVjfH8h0rO7tOi6AEp2grer7y5OZSBorryqwA1wJi0yDBsKj3Rn74+YsmEQBDFhTeqlmiKIUotYb9jb/7I2MKUu1M2nO090y09ZD6i5rW98b9Ce50a+5GtjfJBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207974; c=relaxed/simple;
	bh=bL28PWZFzZyMsWC6zlEKyJR+ZfOcY1gl+XeA6DvlzNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1SAokntt36JWS4vtuknfA5qZrnOaCuTqoMzQTJIDnmppUMKPZ08pqXiKBg9CJupj4zzqSoz6oG/hEBtRWUCDSGLmT12Wl2kReqbC4KoU2w307jNiC5BT7E4/KyJ5inzCW6sGaAKLmFgv/706sGPQDTryasLreOprJQ0gTIf1QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Svo/kwp9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Svo/kwp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F65C4CEF1;
	Tue, 26 Aug 2025 11:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207974;
	bh=bL28PWZFzZyMsWC6zlEKyJR+ZfOcY1gl+XeA6DvlzNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Svo/kwp9o3M1SowLnzpZor66BiQvTVlWy+sEnz87oHIxtXYgkK122wgahCh4J7qKu
	 /dnKe1V5Tg+2Dh48Dmu/cLi0LwumfsAfQJ197IxpSsqtXErrPFzsDB/hf/QPynNRW9
	 PfnQJ2R4ElEYa1AwwO/kGj25fY/7GVtr4jYVZHgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baihan Li <libaihan@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 390/457] drm/hisilicon/hibmc: fix the hibmc loaded failed bug
Date: Tue, 26 Aug 2025 13:11:14 +0200
Message-ID: <20250826110946.935005642@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 4cdcc34070ee..ac552c339671 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
@@ -319,13 +319,13 @@ static int hibmc_load(struct drm_device *dev)
 
 	ret = hibmc_hw_init(priv);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = drmm_vram_helper_init(dev, pci_resource_start(pdev, 0),
 				    pci_resource_len(pdev, 0));
 	if (ret) {
 		drm_err(dev, "Error initializing VRAM MM; %d\n", ret);
-		goto err;
+		return ret;
 	}
 
 	ret = hibmc_kms_init(priv);
-- 
2.50.1



