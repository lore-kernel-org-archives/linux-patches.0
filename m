Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D77394785;
	Sat, 17 Oct 2026 17:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256456; cv=none; b=FUuwa5uaBb6RmsfCJitaKIwCiF6/50JLcq84JbNT6RnlNz3GCYq/9pbH8c2bndIgl01Fb7rmkrGc4yI4fZ7fRTXz0ITqTrZS4h4oJQlCvmBDS2+ZFu2PzIfCBS4VJ/5e7N7lRkaZCEDpjfscYnL5PGjHrRdDwIELsLGIGZWtlPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256456; c=relaxed/simple;
	bh=msuTYIodkpRYfltpOsiiJMSsWLelM14AIucYhmALI50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3HN8HrT0YgZ4xTWxFom2MoNmD2GTNRBXZix5w/dPv5RCaub/XunVXZO+qJ9sDj+w03HzewSjq/SGOo2C7VkLbnT0HcvoJUFKCVkGeEJ6VziJjzHNFXQsy05NrvK9wL7OW4DKlZusihRtlNrXdiNYfxzdBdhGCIHXFfNq0thi98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qv9eGle8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qv9eGle8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B291F000C4;
	Sat, 17 Oct 2026 17:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256455;
	bh=X4RoIFcnLPq/pIqGnF4hQnWgey6CPxyYhlIg8HDiY9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qv9eGle8+7sJDFTuTrViSMIL8mbO7qhqSIaK9zaSKvZMMNOn6qF82n9xW2qHZbZOM
	 fw72OpGYrHqkVHFCLFjqUqq/DfzgpEpFnDdPDLRuTjSuVpsNSiHk0srAwnlMN//926
	 /KyyJOFTMFie3Xm1zSnYkRZO2aeFcGsaBtY1Y658=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.6 0241/1674] drm/mediatek: Fix ovl adaptor platform device leak
Date: Sat, 17 Oct 2026 17:41:53 +0200
Message-ID: <20261017160437.318211091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -808,7 +808,7 @@ static int mtk_drm_probe(struct platform
 	struct mtk_drm_private *private;
 	struct device_node *node;
 	struct component_match *match = NULL;
-	struct platform_device *ovl_adaptor;
+	struct platform_device *ovl_adaptor = NULL;
 	int ret;
 	int i;
 
@@ -939,6 +939,8 @@ static int mtk_drm_probe(struct platform
 err_pm:
 	pm_runtime_disable(dev);
 err_node:
+	if (ovl_adaptor)
+		platform_device_unregister(ovl_adaptor);
 	of_node_put(private->mutex_node);
 	for (i = 0; i < DDP_COMPONENT_DRM_ID_MAX; i++)
 		of_node_put(private->comp_node[i]);
@@ -948,9 +950,15 @@ err_node:
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


