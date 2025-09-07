Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34038D528;
	Sun,  7 Sep 2025 20:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276744; cv=none; b=bv7oVeN1DSI9/5gtg37MD6/GWRxBggYQ6KKalYsP6QBhPg0EhMzC8+iXb1y0sUiMMroky0aSyohAtLrVYbtSCqa+xe7yYVUHS1WQ7LWitTblZCps7dDU0gS8B7knLS2p59rM1ZYU96NBhNZlhaSXwRAZgXiEHDhBAuLqjiWOuPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276744; c=relaxed/simple;
	bh=gDssaU6KHpVkQqFgJTQEH9It95lbAMYmnj0nEF4oLzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZn8FuJAeqPJAbycad1Cme2y1ym/GR6w2RitEcA/TAr0ml5+S5TfK2TO3pOJfxRMep63570HbrmdOruSvR+s6i13wu5tp9Jy8mszYvXlgjtqesp9Tkejhmkl6IvnU8dqZgMcv4fsAJ3W5VC3D4Qkjdtl2c8hY0R1wF86HVHgOdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBoL2Ppj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBoL2Ppj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A3BC4CEF0;
	Sun,  7 Sep 2025 20:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276744;
	bh=gDssaU6KHpVkQqFgJTQEH9It95lbAMYmnj0nEF4oLzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBoL2PpjJNfsLYHF9oKXukMa5HH+5wiHlFWBzC/ui7vqUGqWavqYtenwyHrODXjF7
	 sl+3Qojc2tWmiRo0eMLi61ADsmui1+B/o2874IFhE7ATcee6hpiuyw3zAoDxQWTAlQ
	 pg8DbO8Gl4Z7o0bI02uW4GP/oEReSZJ39LmixgmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Fei Shao <fshao@chromium.org>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/121] drm/mediatek: Fix using wrong drm private data to bind mediatek-drm
Date: Sun,  7 Sep 2025 21:58:50 +0200
Message-ID: <20250907195612.264219352@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

From: "Jason-JH.Lin" <jason-jh.lin@mediatek.com>

[ Upstream commit ebba0960993045787ca00bb0932d83dad98c2e26 ]

According to mtk_drm_kms_init(), the all_drm_private array in each
drm private data stores all drm private data in display path order.

In mtk_drm_get_all_drm_priv(), each element in all_drm_priv should have one
display path private data, such as:
all_drm_priv[CRTC_MAIN] should only have main_path data
all_drm_priv[CRTC_EXT] should only have ext_path data
all_drm_priv[CRTC_THIRD] should only have third_path data

So we need to add the length checking for each display path before
assigning their drm private data into all_drm_priv array.

Then the all_drm_private array in each drm private data needs to be
assigned in their display path order.

Fixes: 1ef7ed48356c ("drm/mediatek: Modify mediatek-drm for mt8195 multi mmsys support")
Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Tested-by: Fei Shao <fshao@chromium.org>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20231004024013.18956-4-jason-jh.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Stable-dep-of: 1f403699c40f ("drm/mediatek: Fix device/node reference count leaks in mtk_drm_get_all_drm_priv")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -352,6 +352,7 @@ static bool mtk_drm_get_all_drm_priv(str
 {
 	struct mtk_drm_private *drm_priv = dev_get_drvdata(dev);
 	struct mtk_drm_private *all_drm_priv[MAX_CRTC];
+	struct mtk_drm_private *temp_drm_priv;
 	struct device_node *phandle = dev->parent->of_node;
 	const struct of_device_id *of_id;
 	struct device_node *node;
@@ -371,11 +372,21 @@ static bool mtk_drm_get_all_drm_priv(str
 			continue;
 
 		drm_dev = device_find_child(&pdev->dev, NULL, mtk_drm_match);
-		if (!drm_dev || !dev_get_drvdata(drm_dev))
+		if (!drm_dev)
 			continue;
 
-		all_drm_priv[cnt] = dev_get_drvdata(drm_dev);
-		if (all_drm_priv[cnt] && all_drm_priv[cnt]->mtk_drm_bound)
+		temp_drm_priv = dev_get_drvdata(drm_dev);
+		if (!temp_drm_priv)
+			continue;
+
+		if (temp_drm_priv->data->main_len)
+			all_drm_priv[CRTC_MAIN] = temp_drm_priv;
+		else if (temp_drm_priv->data->ext_len)
+			all_drm_priv[CRTC_EXT] = temp_drm_priv;
+		else if (temp_drm_priv->data->third_len)
+			all_drm_priv[CRTC_THIRD] = temp_drm_priv;
+
+		if (temp_drm_priv->mtk_drm_bound)
 			cnt++;
 
 		if (cnt == MAX_CRTC) {


