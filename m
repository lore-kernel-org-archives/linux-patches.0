Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D0A280331;
	Fri,  7 Aug 2026 15:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117642; cv=none; b=QWexly7B1pZooBy9xXCTKDzyLHwDf8scqlF8eBIckfRMSnRx1cOVIXaZUmIw7ZyOVAdMiVHiH/PPpXgJfZRn6yevoNP2NDHjsGWnT+g59WPLLMHUSdaEEgZFhbr3gNcx85QUwg+9N6RsP3GF89RKFeLd6uASBFWCDVBv9+NV1qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117642; c=relaxed/simple;
	bh=CzajpESK1cWqbEAvKx8E5fS2o/zbWtPWYaHs27FE1O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSvACImnUhTPvah37cRugmOjiBJ1xNgP+PcBn2LCQPqYfvhbMOqvAo88qyEI8b8beVRBUIPhYrpn/YX4Bq7UaQeTr4DE8y6O6N/WZ3y0+a0TThfeHycpWj3TLpU6DqWkt58x+m4AG+M8+DT1Z0rHvauJ0EggBfdWLBY+xjWx1kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8Tp3V9F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8Tp3V9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC761F000E9;
	Fri,  7 Aug 2026 15:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117640;
	bh=+JX8h2WXZL7HZrOtQ37fpS6XEmHtuRl8JySpVmcgyZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8Tp3V9FAh91PNg9XKXMe2IYxyqGBKTKR8QWvWqkIgBqL4ivdJuRMo73DVonXJUx/
	 B3vMqAY3xRZaNgXhnNgQJo3rPLlSyQuXUM3uPK5C0VS2UK+ezb5duWeVp4XB/P4hew
	 1hP51gPMR3y/LV3RNu/UpAXNZmXEt0WPKofKjLY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 7.1 389/438] drm/mediatek: ovl_adaptor: balance component registrations
Date: Fri,  7 Aug 2026 16:39:45 +0200
Message-ID: <20260807143436.258682105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 533e3469a57996905cdb95f178e7efe38c21aeb2 upstream.

The OVL adaptor registers both an aggregate driver for its child devices
and a component for the main DRM aggregate. Probe currently ignores an
error from registering the child aggregate and leaves that aggregate
registered if registering the DRM component fails. The remove callback
also leaves the DRM component registered.

These imbalances can leave component framework entries referring to a
device whose probe failed or whose driver has been detached. The aggregate
unbind callback also fails to undo component_bind_all(), leaving its child
components marked as bound when the aggregate is removed.

Check the aggregate registration result, unwind it when the component
registration fails, and unregister the component before the aggregate on
remove. Keep runtime PM enabled until both framework registrations have
been removed, and unbind all child components from the aggregate unbind
callback.

Fixes: 453c3364632a ("drm/mediatek: Add ovl_adaptor support for MT8195")
Cc: stable@vger.kernel.org # 6.4+
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20260721152242.47138-1-mhun512@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c
@@ -625,6 +625,7 @@ static void mtk_disp_ovl_adaptor_master_
 	struct mtk_disp_ovl_adaptor *priv = dev_get_drvdata(dev);
 
 	priv->children_bound = false;
+	component_unbind_all(dev, priv->mmsys_dev);
 }
 
 static const struct component_master_ops mtk_disp_ovl_adaptor_master_ops = {
@@ -651,12 +652,15 @@ static int mtk_disp_ovl_adaptor_probe(st
 
 	priv->mmsys_dev = pdev->dev.platform_data;
 
-	component_master_add_with_match(dev, &mtk_disp_ovl_adaptor_master_ops, match);
+	ret = component_master_add_with_match(dev, &mtk_disp_ovl_adaptor_master_ops, match);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to add component master\n");
 
 	pm_runtime_enable(dev);
 
 	ret = component_add(dev, &mtk_disp_ovl_adaptor_comp_ops);
 	if (ret != 0) {
+		component_master_del(dev, &mtk_disp_ovl_adaptor_master_ops);
 		pm_runtime_disable(dev);
 		return dev_err_probe(dev, ret, "Failed to add component\n");
 	}
@@ -666,6 +670,7 @@ static int mtk_disp_ovl_adaptor_probe(st
 
 static void mtk_disp_ovl_adaptor_remove(struct platform_device *pdev)
 {
+	component_del(&pdev->dev, &mtk_disp_ovl_adaptor_comp_ops);
 	component_master_del(&pdev->dev, &mtk_disp_ovl_adaptor_master_ops);
 	pm_runtime_disable(&pdev->dev);
 }


