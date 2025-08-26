Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BDA2FC008;
	Tue, 26 Aug 2025 13:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214004; cv=none; b=mMC7NHz3efLYIik7PHVFuRB4zyYakHRsDWQjn8IWzBGi4aE3ZSo/1RNi9j1gJHn+J6RGVTgKZScSNh0XnnMu/tktjZCg4b6swwD7cG3a17utRgh9nSTyUjwvE0UiFuYgdGU6Jggp+k0Pu+sTnO2yXHMsNqwtfpzpS6fHNzRHck4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214004; c=relaxed/simple;
	bh=iip5ejvZlMtelrI5HRzL5HRa/fKA96/jtN+tpP36Td4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWvNSLxgeEwWhs+s4eKZ1jg9ODOjM9f2YIhyRsF9V6jRb1ap23C9ADBocQ/Y1rombY6ZZI8mRmWb6eyOE9vda2av5XehGnzsVthF236zvZcDcMRVudkUBmbvT8tqNDaPi0vbT/IWD/LOhk9V7J0NKPngezbTFFJK2oK0C6MnCKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrNSSQ7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrNSSQ7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BA2C4CEF4;
	Tue, 26 Aug 2025 13:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214004;
	bh=iip5ejvZlMtelrI5HRzL5HRa/fKA96/jtN+tpP36Td4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrNSSQ7swF6drlzxj3fDzbtbapFHS8DmH1xvmXbXLZ0ffGNwXbnuceT/eydWILQUo
	 /88vTKgYWnPPU00c2KL8BocxG+cGVCFz4QnYSEFHXQ0rc2jJbCS7kX6kWkX4uARChU
	 qFXwXIumd9zmD4MM10ONAgjVniPSbC3bEIIIVzjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baihan Li <libaihan@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 562/587] drm/hisilicon/hibmc: fix the hibmc loaded failed bug
Date: Tue, 26 Aug 2025 13:11:51 +0200
Message-ID: <20250826111007.322449002@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
index 8a98fa276e8a..96f960bcfd82 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
@@ -258,13 +258,13 @@ static int hibmc_load(struct drm_device *dev)
 
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



