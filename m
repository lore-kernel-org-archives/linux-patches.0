Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB93221F1F;
	Tue, 17 Jun 2025 15:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174508; cv=none; b=CZFHELLo8yuk5sL2GOQM9kSBtRh4aSCbtjW+yLUf4N+2fHFdeFe+7ocNWzWlKF6B1cvMSpIhIdeuocUKebKJ0WLIIGgci2BU32MF6S8vVQ/KAwjlA/QLl2uusIv9iheMwpu374gJPzpbvN+QYghXnk/FSeDbpKW1C3HTtsWkt6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174508; c=relaxed/simple;
	bh=RV5LbI/PmiMyzVkcx2eXk+Xhg0LthIEZqB4HIBgf10I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUjbTFj1343KJEOQ/QzRLZZtRvAFD8B77ukvuEhf0Dq+fAmjiLOEve/TQJmoerxSwCmG01sIPRsrJiFcH5jmMSIEgISMOUymb/ViEc5pTmJqHHDRcAcZkxBQSy1p674d6GX2/tByomCJpV3xZp4goukxlLdXxlSaOX0EOcKaAMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffgCKTVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffgCKTVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C935C4CEF2;
	Tue, 17 Jun 2025 15:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174508;
	bh=RV5LbI/PmiMyzVkcx2eXk+Xhg0LthIEZqB4HIBgf10I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffgCKTVZWykYJ/GNgKyOUEl6cu+8T2GLY+QslSO6LHpBPOekSTrUNmRAwHCNtfeyn
	 mpZE61BD483li/suPBDlRQO6f1FruQYRWEGe/P8q93ILUSMKEgx2r6olQK8xrJZsSh
	 FrJEalcIYfSTy7S8dqELPUeMYck09TiEV23JpTRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/356] drm/mediatek: Fix kobject put for component sub-drivers
Date: Tue, 17 Jun 2025 17:23:12 +0200
Message-ID: <20250617152341.322876326@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 80805b62ea5b95eda54c225b989f929ca0691ab0 ]

In function mtk_drm_get_all_drm_priv(), this driver is incrementing
the refcount for the sub-drivers of mediatek-drm with a call to
device_find_child() when taking a reference to all of those child
devices.

When the component bind fails multiple times this results in a
refcount_t overflow, as the reference count is never decremented:
fix that by adding a call to put_device() for all of the mmsys
devices in a loop, in error cases of mtk_drm_bind() and in the
mtk_drm_unbind() callback.

Fixes: 1ef7ed48356c ("drm/mediatek: Modify mediatek-drm for mt8195 multi mmsys support")
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250403104741.71045-3-angelogioacchino.delregno@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 108cab35ce485..32d66fa75b7c4 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -635,6 +635,10 @@ static int mtk_drm_bind(struct device *dev)
 	for (i = 0; i < private->data->mmsys_dev_num; i++)
 		private->all_drm_private[i]->drm = NULL;
 err_put_dev:
+	for (i = 0; i < private->data->mmsys_dev_num; i++) {
+		/* For device_find_child in mtk_drm_get_all_priv() */
+		put_device(private->all_drm_private[i]->dev);
+	}
 	put_device(private->mutex_dev);
 	return ret;
 }
@@ -642,6 +646,7 @@ static int mtk_drm_bind(struct device *dev)
 static void mtk_drm_unbind(struct device *dev)
 {
 	struct mtk_drm_private *private = dev_get_drvdata(dev);
+	int i;
 
 	/* for multi mmsys dev, unregister drm dev in mmsys master */
 	if (private->drm_master) {
@@ -649,6 +654,10 @@ static void mtk_drm_unbind(struct device *dev)
 		mtk_drm_kms_deinit(private->drm);
 		drm_dev_put(private->drm);
 
+		for (i = 0; i < private->data->mmsys_dev_num; i++) {
+			/* For device_find_child in mtk_drm_get_all_priv() */
+			put_device(private->all_drm_private[i]->dev);
+		}
 		put_device(private->mutex_dev);
 	}
 	private->mtk_drm_bound = false;
-- 
2.39.5



