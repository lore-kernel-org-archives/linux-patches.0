Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484032E92BC;
	Tue, 17 Jun 2025 15:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175166; cv=none; b=l/wOqHcYKLgX1gTBB4s7sAcfhooMb57ZgQCwfE6S3E0Kv8UMJyCwGvNjgUDOGh2U3G2F64pk5pz5xLZYYOzCnmK3/8Otrq/SFpzXQm+Jl70VEvQK/pZbGzY1/loZ/NF2D8/ODE3NPYudvgbzG29dSdbRy0BV3Y3teJ1EhlXoJCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175166; c=relaxed/simple;
	bh=nPaQSG3SKtLGZIzTDRPDDdv5v+gd0kfofZ00Rj+ts2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzlCnyrRDQ34IZwY6uWVFJZaMPDrSqdKETykG6kq8qZqzwGYfeaulaCAzpYm0N8msoj/BQs+C4YIw+HltqmZwU79RngcphYZU2wSMqV/VJH09SOJJ86NParj8v/3RY7IkJ88AqXyJqktpsJ+aUBmx0fFrLlEJZ+otgJ9623rbEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0W0AS/or; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0W0AS/or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C0CC4CEE3;
	Tue, 17 Jun 2025 15:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175166;
	bh=nPaQSG3SKtLGZIzTDRPDDdv5v+gd0kfofZ00Rj+ts2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0W0AS/orpXOnM4ohdcVuIAoBvRPu/w7eD3cUmL2kOLYyaU1KtXbK4M6jG6NMnBH4R
	 3c6Hbbf6ARRCYGMyMAP9A0xjKXO97GiS92gHkup0hewwAHRy9EKnGhzgH5Lc3EVNR6
	 1zpaWODMP2B/8UJG6fb9WDI4HZN7WV2rmdB9s+Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/512] drm/mediatek: Fix kobject put for component sub-drivers
Date: Tue, 17 Jun 2025 17:21:06 +0200
Message-ID: <20250617152423.649490916@linuxfoundation.org>
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
index 86541b0d5c496..3cdda6694f7f5 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -675,6 +675,10 @@ static int mtk_drm_bind(struct device *dev)
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
@@ -682,6 +686,7 @@ static int mtk_drm_bind(struct device *dev)
 static void mtk_drm_unbind(struct device *dev)
 {
 	struct mtk_drm_private *private = dev_get_drvdata(dev);
+	int i;
 
 	/* for multi mmsys dev, unregister drm dev in mmsys master */
 	if (private->drm_master) {
@@ -689,6 +694,10 @@ static void mtk_drm_unbind(struct device *dev)
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



