Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BEB4F3EB0;
	Tue, 13 Oct 2026 12:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894978; cv=none; b=U7n3EfReuocwwxKCebur4KAYkTRbLZsDZgK1ksCRmgHPMi/ndMDHPFo5RzJls1BbY2PQEHqSR7orfIB8/QvRXdKE9Dh/sUIraO7Qmz3Q8ZY7HYEbmn6Wq1/ujZFyjn2slBIcIOAf8VdvYC2Vu4h11/hbAAYxFxTDSl7K4qWLgZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894978; c=relaxed/simple;
	bh=CzkAm8c7DAxhSM/vWtvShYvBWByRMn9n7g0dcpI++IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGsuJ0kzr14X2tqMEiP2747nqrnE8F8d8RRXr/+qTplHtAI+QyalNF6l4FHnRPT5r9namvWr/3ZPVX7M6/DCuqPOvoQVyfpfCxVB5WuoNNqyZhLyUtVsBY6n7nCy0vYV+pTd8U21McXTLmaXXactO6egl6/SogO+n8aimpVxJYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xefVJkJX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xefVJkJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF8D1F000FF;
	Tue, 13 Oct 2026 12:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894977;
	bh=IDKBN2sqBfHDRRjcaE5gjphHkYzLYHT0+jZOMcev9zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xefVJkJXu47NHqKZCwpe6fKvkgomJDxucqoRgZbMT4HQc6NU0cTgUprwNy23sGMmE
	 FqolrWAq5Zo6d66HxEt3OYUz/XxJgsFiAWqKq8+g2oIm80zP74nmIAW68W46wnzOlo
	 Vs9pe6uwaZiay8Czsj0qr7sA5bihs9lJvAfIsmgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.12 119/497] drm/mediatek: Fix ovl adaptor platform device leak
Date: Tue, 13 Oct 2026 13:34:46 +0200
Message-ID: <20261013112910.715885809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 048739be3e9cacae5301b68245668002fe6f0ce5 upstream.

mtk_drm_probe() creates an OVL adaptor platform device with
platform_device_register_data() when the display pipeline requires the
OVL adaptor.

If a later initialization step fails, the probe error path releases
the DRM resources without unregistering the already registered OVL
adaptor device. The normal remove path likewise leaves the device
registered after the DRM driver is unbound.

Keep track of whether the OVL adaptor was successfully registered and
unregister it on probe failure. Also recover the platform device from
the stored DDP component device and unregister it during normal
removal.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: 0d9eee9118b7 ("drm/mediatek: Add drm ovl_adaptor sub driver for MT8195")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20260921131156.403652-1-lgs201920130244@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -841,7 +841,7 @@ static int mtk_drm_probe(struct platform
 	struct mtk_drm_private *private;
 	struct device_node *node;
 	struct component_match *match = NULL;
-	struct platform_device *ovl_adaptor;
+	struct platform_device *ovl_adaptor = NULL;
 	int ret;
 	int i;
 
@@ -972,6 +972,8 @@ static int mtk_drm_probe(struct platform
 err_pm:
 	pm_runtime_disable(dev);
 err_node:
+	if (ovl_adaptor)
+		platform_device_unregister(ovl_adaptor);
 	of_node_put(private->mutex_node);
 	for (i = 0; i < DDP_COMPONENT_DRM_ID_MAX; i++)
 		of_node_put(private->comp_node[i]);
@@ -981,9 +983,15 @@ err_node:
 static void mtk_drm_remove(struct platform_device *pdev)
 {
 	struct mtk_drm_private *private = platform_get_drvdata(pdev);
+	struct device *ovl_adaptor_dev;
 	int i;
 
+	ovl_adaptor_dev =
+		private->ddp_comp[DDP_COMPONENT_DRM_OVL_ADAPTOR].dev;
+
 	component_master_del(&pdev->dev, &mtk_drm_ops);
+	if (ovl_adaptor_dev)
+		platform_device_unregister(to_platform_device(ovl_adaptor_dev));
 	pm_runtime_disable(&pdev->dev);
 	of_node_put(private->mutex_node);
 	for (i = 0; i < DDP_COMPONENT_DRM_ID_MAX; i++)


