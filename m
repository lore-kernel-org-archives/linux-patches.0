Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7940390608;
	Fri,  7 Aug 2026 15:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117639; cv=none; b=FhEjqiT4tmhaV5afX/xUQ5xLw6eJUq7OE2FCqSV03bpzLPkYQlWi4J8mBdLylCDFq37jwcMVRSn8OCYQgodQKawvaRscaieeB6z+8O0uDaBRr3Io8+gzjNfUFfZG2LMOF6w+MeQb/I0gaLAN68NWGiBR9943MoRIuRyKaM4IkkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117639; c=relaxed/simple;
	bh=uIkxzoXgcQ6dq+Gceognn9JO3HHBXuxOtwJw0feQdBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJG9JSY1yUIZc4VTeuVxZo2QwQFBmGvqI12VUI02sKyotPAvFa2Y3inTRGls4/LWLMZdDDkWu4Q7VidzsKekamB30YWa93p7YkVv15uIvs2C81Ojtrr6ir9aFeggkCBDCUyDbyzpRovxcHwaXQIxEG3d5p3o0JowW/8lrzLrIYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myDu8HJq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myDu8HJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA501F000E9;
	Fri,  7 Aug 2026 15:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117637;
	bh=lBhcsOvfQWzq7bLZq+FkczxbYHyOZd8jgGl+2vKGN90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=myDu8HJq9AB+yCBeF8HhgDY6MUoii9GoEvdh/zVdPSDplk0ECu/jSCOYeqyUXhUM4
	 d1fEhqKHhAkTeJrD12ej9LWjFPJyfX4eSjHlrqufsNG/9ePNr4PQ6cP6a4d3+5PQRl
	 86DmRM/g+MiBtnYhZeo+bwZ7IHiM7F77TNI7QsrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 7.1 388/438] drm/mediatek: mtk_hdmi: Fix DDC adapter double put in v2
Date: Fri,  7 Aug 2026 16:39:44 +0200
Message-ID: <20260807143436.238359081@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit d19d8542808c3be5f4af849da6509e877b74d811 upstream.

mtk_hdmi_common_probe() gets the DDC adapter with
of_find_i2c_adapter_by_node() and registers a devm action to release the
adapter device reference with put_device().

The HDMI v2 remove callback also calls i2c_put_adapter() on the same DDC
adapter. This is not paired with of_find_i2c_adapter_by_node(): it drops
the adapter device reference before the devm action drops it again, and
it also puts a module reference that was never taken.

Remove the extra i2c_put_adapter() call and drop the now-empty HDMI v2
remove callback. The common devm action releases the adapter device
reference.

Fixes: 8d0f79886273 ("drm/mediatek: Introduce HDMI/DDC v2 for MT8195/MT8188")
Cc: stable@vger.kernel.org
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20260713112957.884640-1-lgs201920130244@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi_v2.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/gpu/drm/mediatek/mtk_hdmi_v2.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi_v2.c
@@ -1499,13 +1499,6 @@ static int mtk_hdmi_v2_probe(struct plat
 	return 0;
 }
 
-static void mtk_hdmi_v2_remove(struct platform_device *pdev)
-{
-	struct mtk_hdmi *hdmi = platform_get_drvdata(pdev);
-
-	i2c_put_adapter(hdmi->ddc_adpt);
-}
-
 static const struct of_device_id mtk_drm_hdmi_v2_of_ids[] = {
 	{ .compatible = "mediatek,mt8188-hdmi-tx", .data = &mtk_hdmi_conf_mt8188 },
 	{ .compatible = "mediatek,mt8195-hdmi-tx", .data = &mtk_hdmi_conf_mt8195 },
@@ -1515,7 +1508,6 @@ MODULE_DEVICE_TABLE(of, mtk_drm_hdmi_v2_
 
 static struct platform_driver mtk_hdmi_v2_driver = {
 	.probe = mtk_hdmi_v2_probe,
-	.remove = mtk_hdmi_v2_remove,
 	.driver = {
 		.name = "mediatek-drm-hdmi-v2",
 		.of_match_table = mtk_drm_hdmi_v2_of_ids,


