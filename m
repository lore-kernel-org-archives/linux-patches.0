Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CD92676E0;
	Tue,  8 Apr 2025 11:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110106; cv=none; b=fGRfIWx60NLggVJLeIvcFlsgLj+de9Wi3rGzMDVz9y2YjbNASi/h/qcts/N7KxcExHJyXGYa3Ws641z60v4VVjmaH47kYuiR40JjhF6Qtz6bZ9zvrPy5WcduPC6wYGwTcT1hvmp2vi+SdzGGbuFq9LIWxaDpEPs0BkzbWs7Xk94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110106; c=relaxed/simple;
	bh=t4/6CRedqosg23lV4oMIBSO3LkGYiHZacNX8DPcGCJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIFZX2JMaSsa0NcQm20maYGkDzaFlgAYkoEwQLYtLOslrijFAaSHglVLIRTCeCZn4zbWmGGp8FfrcTrsc8FLREGAMs/+YjfhUoHH55pTbcCNI6z5NNHY3V9nuppsxlfcjOUfkePlRqmJ1m4fd9/ExXh2A9AKR1b2KDn5rifOeko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffAC0N8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffAC0N8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03216C4CEE5;
	Tue,  8 Apr 2025 11:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110106;
	bh=t4/6CRedqosg23lV4oMIBSO3LkGYiHZacNX8DPcGCJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffAC0N8hJFrB1zGK0IBKnakTYMW0I8CsDNeTWz+1bmdB/RIIxoo4aQHurz+JquQLV
	 Ay3Kr49eh3iPvaid9tn7cKKn9DVFSCdLsdNMLO6MXyJOojqBYTBHvEJuV1NzYkTRML
	 UsPn0SSSnTyO6kSFLLlDzR9H1crIfDrEIpFQJMi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/227] drm/mediatek: mtk_hdmi: Unregister audio platform device on failure
Date: Tue,  8 Apr 2025 12:48:28 +0200
Message-ID: <20250408104824.222844364@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 0be123cafc06eed0fd1227166a66e786434b0c50 ]

The probe function of this driver may fail after registering the
audio platform device: in that case, the state is not getting
cleaned up, leaving this device registered.

Adding up to the mix, should the probe function of this driver
return a probe deferral for N times, we're registering up to N
audio platform devices and, again, never freeing them up.

To fix this, add a pointer to the audio platform device in the
mtk_hdmi structure, and add a devm action to unregister it upon
driver removal or probe failure.

Fixes: 8f83f26891e1 ("drm/mediatek: Add HDMI support")
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20250217154836.108895-18-angelogioacchino.delregno@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi.c b/drivers/gpu/drm/mediatek/mtk_hdmi.c
index 97a1ff529a1dc..d6ca627cf00e9 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -172,6 +172,7 @@ struct mtk_hdmi {
 	unsigned int sys_offset;
 	void __iomem *regs;
 	enum hdmi_colorspace csp;
+	struct platform_device *audio_pdev;
 	struct hdmi_audio_param aud_param;
 	bool audio_enable;
 	bool powered;
@@ -1706,6 +1707,11 @@ static const struct hdmi_codec_ops mtk_hdmi_audio_codec_ops = {
 	.no_capture_mute = 1,
 };
 
+static void mtk_hdmi_unregister_audio_driver(void *data)
+{
+	platform_device_unregister(data);
+}
+
 static int mtk_hdmi_register_audio_driver(struct device *dev)
 {
 	struct mtk_hdmi *hdmi = dev_get_drvdata(dev);
@@ -1715,13 +1721,20 @@ static int mtk_hdmi_register_audio_driver(struct device *dev)
 		.i2s = 1,
 		.data = hdmi,
 	};
-	struct platform_device *pdev;
+	int ret;
 
-	pdev = platform_device_register_data(dev, HDMI_CODEC_DRV_NAME,
-					     PLATFORM_DEVID_AUTO, &codec_data,
-					     sizeof(codec_data));
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
+	hdmi->audio_pdev = platform_device_register_data(dev,
+							 HDMI_CODEC_DRV_NAME,
+							 PLATFORM_DEVID_AUTO,
+							 &codec_data,
+							 sizeof(codec_data));
+	if (IS_ERR(hdmi->audio_pdev))
+		return PTR_ERR(hdmi->audio_pdev);
+
+	ret = devm_add_action_or_reset(dev, mtk_hdmi_unregister_audio_driver,
+				       hdmi->audio_pdev);
+	if (ret)
+		return ret;
 
 	DRM_INFO("%s driver bound to HDMI\n", HDMI_CODEC_DRV_NAME);
 	return 0;
-- 
2.39.5



