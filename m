Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830391C02;
	Tue, 23 Jan 2024 00:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969484; cv=none; b=oPguMtPfWFenLwcZLfXqW8iudAHPAvPff13AYSKP3D8kEHPU0sywqGO4sKYPR5nN+KfJQapunnjg7Yg/ZmWaLCtBVcR6fn4fWPGvpA8JM6ZzFnv+R6pr6LFQow3Gky1NrAybdh4rSjO7H+GcQ7tnJaY8ldCN7r/QjHZxmyqaaV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969484; c=relaxed/simple;
	bh=vR9Ps+A2UXaeqNrbdwRuIW2M1xcK8td7RL0xDYb4cKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cCFMZqCicfT/W4j2c4xBOS11lDGiEyGhHb5sAtpUk0OtU4MwnkJasIZOwWzEiVLZTJZQTPT8wQWlrfkiS7cnGHJMSptcjbjTXId1wMqcenkkST9zLdEWlC0DvU90DvcXQVh5shu1XVqTceFnSn2S7CTZPzWag0G5Pq1bRLr/r6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oA8eXZxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oA8eXZxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD47C433F1;
	Tue, 23 Jan 2024 00:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969484;
	bh=vR9Ps+A2UXaeqNrbdwRuIW2M1xcK8td7RL0xDYb4cKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oA8eXZxPSpgHWtx1mEc8R45YUMQAfJHBefB+fo7cqx3nLYTtVfkCcpaSs7R2NMwI2
	 s875qIt751GdGe2BQYOCcmDEL8sRtxapoqtzO9LEguS9U3wJL5QXa6Gm1narcj1W8E
	 AzrFNv3jeCuyAQvv3OgbALx3fOI06ESvzgGOdITM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Philipp Zabel <philipp.zabel@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 275/641] drm/imx/lcdc: Fix double-free of driver data
Date: Mon, 22 Jan 2024 15:52:59 -0800
Message-ID: <20240122235826.522388184@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit ff3670877e7c73d06c2a835d9abb62efcae0145c ]

The struct imx_lcdc driver data is allocated using devm_drm_dev_alloc()
so it must not be explicitly kfree()d.

Also drm_kms_helper_poll_fini() should not be called as there is no
matching drm_kms_helper_poll_init(). So drop the release function
completely.

Fixes: c87e859cdeb5 ("drm/imx/lcdc: Implement DRM driver for imx25")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230706092731.2630232-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/lcdc/imx-lcdc.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/gpu/drm/imx/lcdc/imx-lcdc.c b/drivers/gpu/drm/imx/lcdc/imx-lcdc.c
index 22b65f4a0e30..4beb3b4bd694 100644
--- a/drivers/gpu/drm/imx/lcdc/imx-lcdc.c
+++ b/drivers/gpu/drm/imx/lcdc/imx-lcdc.c
@@ -342,21 +342,12 @@ static const struct drm_mode_config_helper_funcs imx_lcdc_mode_config_helpers =
 	.atomic_commit_tail = drm_atomic_helper_commit_tail_rpm,
 };
 
-static void imx_lcdc_release(struct drm_device *drm)
-{
-	struct imx_lcdc *lcdc = imx_lcdc_from_drmdev(drm);
-
-	drm_kms_helper_poll_fini(drm);
-	kfree(lcdc);
-}
-
 DEFINE_DRM_GEM_DMA_FOPS(imx_lcdc_drm_fops);
 
 static struct drm_driver imx_lcdc_drm_driver = {
 	.driver_features = DRIVER_GEM | DRIVER_MODESET | DRIVER_ATOMIC,
 	.fops = &imx_lcdc_drm_fops,
 	DRM_GEM_DMA_DRIVER_OPS_VMAP,
-	.release = imx_lcdc_release,
 	.name = "imx-lcdc",
 	.desc = "i.MX LCDC driver",
 	.date = "20200716",
-- 
2.43.0



