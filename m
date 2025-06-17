Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D802EA143;
	Tue, 17 Jun 2025 16:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176097; cv=none; b=Zr/4GYBBIx4Mra4pZAsRo5g067e3btTtqE8rPbi00vUn6JUWhW+Oj2tcljVTKmQfK/AXMypuqL2T3vZTEAdKuQ5xLVjh6aT9SHFWxsIPWcwRmzcSdIzkEQmbLEpC6OWt0F1H1gcEzrPQbepIDAWwFk+jyEWjLIAOhxskmmQ4Xl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176097; c=relaxed/simple;
	bh=wk/E3CumYGsHHNMj7/znCPaeXCYn6xW+FqwEOoeKNNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9DtgKUk0pwK1S7Vl3jJ0OxcwDcM49tnK1EwKDFPN0CjQJa8pZCcYR7jsAsrBW5mWvQoErElUDCNrKEN8ZvhlcpOLsKrs4/NCJ2EwPU1Z1STfHVarlkmGr+0BOQYw0JFOGjGOmSYmNrIfAvXBoa1BFMdwGiyIYmB7GcxOTfg3EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPz22C90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPz22C90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F31C4CEE3;
	Tue, 17 Jun 2025 16:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176096;
	bh=wk/E3CumYGsHHNMj7/znCPaeXCYn6xW+FqwEOoeKNNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPz22C901QQ31STPfDkITe2AsT2ewyTVWhneNz3KoKlJd6/rLXpCp+9bzwsB0BjpB
	 EHZvuMm+5lzOL9G7+pZGxz4C8AWFe/4bXgzUrv1UNdx+39YBQxwUd+0msd/noTYh1n
	 qPpZN1LyzRyJDsihQmSO+zAs0L0NRZTMU0C5Yo0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 151/780] drm/mediatek: Fix kobject put for component sub-drivers
Date: Tue, 17 Jun 2025 17:17:39 +0200
Message-ID: <20250617152457.652000822@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5994e2a97dc13..593193555c07e 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -682,6 +682,10 @@ static int mtk_drm_bind(struct device *dev)
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
@@ -689,6 +693,7 @@ static int mtk_drm_bind(struct device *dev)
 static void mtk_drm_unbind(struct device *dev)
 {
 	struct mtk_drm_private *private = dev_get_drvdata(dev);
+	int i;
 
 	/* for multi mmsys dev, unregister drm dev in mmsys master */
 	if (private->drm_master) {
@@ -696,6 +701,10 @@ static void mtk_drm_unbind(struct device *dev)
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



