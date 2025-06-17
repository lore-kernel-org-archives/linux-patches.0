Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB5A2ECE98;
	Tue, 17 Jun 2025 15:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175156; cv=none; b=IX7JB5BBjVG5Eags0kqz65s+xj1bRWjB3wl0pSeLzdwetPMIdL+2VxyOww/dxOnPQNFjVnXqTJbVr3PBANvandxkvx7rzhuxwbQux3iwJxgcztTV1sVeL4eYzfI9Fff0wTcc+bxPc4BBOnQ5O45PjrfHQQ98Cv8cbM1NrtSfof0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175156; c=relaxed/simple;
	bh=lq3mDSHSS+wIMC0fRRbkM4gXo66nX2HQRlYTtjG9NhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+rbNvUKYIEwiFxL7wa0NGYA/r7+pMxA40J20un+Ex8TNR8sIOoVmTQwEm4HD8SOgpfqs2X3ZfxFLiRD7hAD8QExYeI+JAOEo4fJDhjUhES+CXELx4L+VLC1Dz6mi8xwGnxmiDM6oQPj2aO8oCNoL6S95eRVoipXqRHT6D/5jpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZP6rNAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZP6rNAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E124C4CEE3;
	Tue, 17 Jun 2025 15:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175156;
	bh=lq3mDSHSS+wIMC0fRRbkM4gXo66nX2HQRlYTtjG9NhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZP6rNAq1qV/0nY4IoX4ZLQM6RjcOUC3GYBbMFnyyI5OadlD4KUdvUzIPn6bnHfPO
	 MirqEPAx/+MqRqo8bfrbw3NXccVZWgfb9cW1Ga1C4H5e3UQfg06BcjPhzJ8AvHxvaH
	 IX5bQCI1eUMr7e8SqPA6+9H8+q/FEmev2KoludU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/512] drm/mediatek: mtk_drm_drv: Fix kobject put for mtk_mutex device ptr
Date: Tue, 17 Jun 2025 17:21:05 +0200
Message-ID: <20250617152423.608704182@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 22918591fb747a6d16801e74a170cf98e886f83b ]

This driver is taking a kobject for mtk_mutex only once per mmsys
device for each drm-mediatek driver instance, differently from the
behavior with other components, but it is decrementing the kobj's
refcount in a loop and once per mmsys: this is not right and will
result in a refcount_t underflow warning when mediatek-drm returns
multiple probe deferrals in one boot (or when manually bound and
unbound).

Besides that, the refcount for mutex_dev was not decremented for
error cases in mtk_drm_bind(), causing another refcount_t warning
but this time for overflow, when the failure happens not during
driver bind but during component bind.

In order to fix one of the reasons why this is happening, remove
the put_device(xx->mutex_dev) loop from the mtk_drm_kms_init()'s
put_mutex_dev label (and drop the label) and add a single call to
correctly free the single incremented refcount of mutex_dev to
the mtk_drm_unbind() function to fix the refcount_t underflow.

Moreover, add the same call to the error cases in mtk_drm_bind()
to fix the refcount_t overflow.

Fixes: 1ef7ed48356c ("drm/mediatek: Modify mediatek-drm for mt8195 multi mmsys support")
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250403104741.71045-2-angelogioacchino.delregno@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 4e93fd075e03c..86541b0d5c496 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -463,7 +463,7 @@ static int mtk_drm_kms_init(struct drm_device *drm)
 
 	ret = drmm_mode_config_init(drm);
 	if (ret)
-		goto put_mutex_dev;
+		return ret;
 
 	drm->mode_config.min_width = 64;
 	drm->mode_config.min_height = 64;
@@ -482,7 +482,7 @@ static int mtk_drm_kms_init(struct drm_device *drm)
 		drm->dev_private = private->all_drm_private[i];
 		ret = component_bind_all(private->all_drm_private[i]->dev, drm);
 		if (ret)
-			goto put_mutex_dev;
+			return ret;
 	}
 
 	/*
@@ -575,9 +575,6 @@ static int mtk_drm_kms_init(struct drm_device *drm)
 err_component_unbind:
 	for (i = 0; i < private->data->mmsys_dev_num; i++)
 		component_unbind_all(private->all_drm_private[i]->dev, drm);
-put_mutex_dev:
-	for (i = 0; i < private->data->mmsys_dev_num; i++)
-		put_device(private->all_drm_private[i]->mutex_dev);
 
 	return ret;
 }
@@ -648,8 +645,10 @@ static int mtk_drm_bind(struct device *dev)
 		return 0;
 
 	drm = drm_dev_alloc(&mtk_drm_driver, dev);
-	if (IS_ERR(drm))
-		return PTR_ERR(drm);
+	if (IS_ERR(drm)) {
+		ret = PTR_ERR(drm);
+		goto err_put_dev;
+	}
 
 	private->drm_master = true;
 	drm->dev_private = private;
@@ -675,6 +674,8 @@ static int mtk_drm_bind(struct device *dev)
 	drm_dev_put(drm);
 	for (i = 0; i < private->data->mmsys_dev_num; i++)
 		private->all_drm_private[i]->drm = NULL;
+err_put_dev:
+	put_device(private->mutex_dev);
 	return ret;
 }
 
@@ -687,6 +688,8 @@ static void mtk_drm_unbind(struct device *dev)
 		drm_dev_unregister(private->drm);
 		mtk_drm_kms_deinit(private->drm);
 		drm_dev_put(private->drm);
+
+		put_device(private->mutex_dev);
 	}
 	private->mtk_drm_bound = false;
 	private->drm_master = false;
-- 
2.39.5



