Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B67369224;
	Fri,  7 Aug 2026 15:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116324; cv=none; b=YM+K2o+ojjb+3p0a2FurKJpeO9yXh3kRZAO+pAxnjDCw+rncqomsLnwJ0yMjU5feAzG/tkK0nOYd3ENohUCmc1sk35Gy4vHajeEJ0Bl/hc1TAGghMCsZpvBbz9DBvqRekHzAY0S7WdHbc0G8Iy+5Ac4EHlWRNc8fQyEGpCM7Qok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116324; c=relaxed/simple;
	bh=aWaJzA2JiITHK8OubJ15/fvDnWogVBr2aXp2SFw4gMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CS2VsNDkNXgbETV5a5clk2UwCTGLdwr2/HdOU4sgmxBxsh/UCVD4Taiz6oxsqLx4XioaYQhbimLl793HDcy+km5eV6SVD4WUDrG59+scXdfjysvbNJhwLOStz95JLqWNezKOGWyNQtql0FwKEya7F4ATTohLHzVeJQWRHtI+ngI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdIQpUei; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdIQpUei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B23C1F000E9;
	Fri,  7 Aug 2026 15:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116322;
	bh=EWdTB84zGXn+x4P0+FpczEYricU5VfNLqrg5htOn2Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdIQpUeiUJh3L+JqXHJKDUc0c2qDhNnzISF4V63QJdroXAQZL6LAtCMpQpoA9WIko
	 oz3YOPdqRBS3Z8SrLNuw6bZZ67KI5KlpLapGAJZM5xgSgEayWdYNPBoWfdTwPiJEm2
	 dDzfcyMtUNutH1N264Yn0ayVaauodcDOSSHDmZi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.6 190/261] drm/mediatek: ovl_adaptor: balance component registrations
Date: Fri,  7 Aug 2026 16:39:07 +0200
Message-ID: <20260807143419.465484527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
@@ -494,6 +494,7 @@ static void mtk_disp_ovl_adaptor_master_
 	struct mtk_disp_ovl_adaptor *priv = dev_get_drvdata(dev);
 
 	priv->children_bound = false;
+	component_unbind_all(dev, priv->mmsys_dev);
 }
 
 static const struct component_master_ops mtk_disp_ovl_adaptor_master_ops = {
@@ -520,12 +521,15 @@ static int mtk_disp_ovl_adaptor_probe(st
 
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
 		dev_err(dev, "Failed to add component: %d\n", ret);
 	}
@@ -535,6 +539,7 @@ static int mtk_disp_ovl_adaptor_probe(st
 
 static int mtk_disp_ovl_adaptor_remove(struct platform_device *pdev)
 {
+	component_del(&pdev->dev, &mtk_disp_ovl_adaptor_comp_ops);
 	component_master_del(&pdev->dev, &mtk_disp_ovl_adaptor_master_ops);
 	pm_runtime_disable(&pdev->dev);
 	return 0;


