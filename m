Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4687719309C;
	Tue,  6 Jan 2026 18:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722482; cv=none; b=ma8l/hqGeVTswrOw7K9umnekv7cVHCFih/vB2WdDwaZD/iOL4YYIzOFjSK+7hQaYUsLh13YPopMPw+yYZv6ek8Nedeo5RQcAs/UiQPaHzOebNflOAWNWrhzkLSjC565YaW/MdvwbwyF7QEdP1CJVBPGDhId6lT33R60LjEeAA5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722482; c=relaxed/simple;
	bh=wpxUZDEupvhEYR3iS430ScSiNOwLGNntw2XjzV1Qv4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJDoWSleezw60e+a+q8Cn1ftzK4/6F2jhlZfbG7MCT2SrCEcBULAdel3DJiKpNm9kLoPqOLoNLDY0lNPDHO3HwAbWsUgcrcsYEInphzqu1Kl/bj2KLa+XljqwxCbj2ObTBTC0WjNPULRYtrw616qG6Jh1SmjO2bHLGug+8ebWk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2/id5of; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2/id5of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D50BC116C6;
	Tue,  6 Jan 2026 18:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722482;
	bh=wpxUZDEupvhEYR3iS430ScSiNOwLGNntw2XjzV1Qv4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2/id5ofZrlOwR9paxJLgncrk4vccymqzduse9C2U0RZGBFHyPc2FYCUm6WCjVFeu
	 FBgRfi5rQL0tFy8gsGBnkiVPt98Rf9WMu3jPTOMc4W9fwrz2hDKxHrRt0KYlvtGVQ0
	 ayJz8+HrpE3Jp3rQ/J/DYjd7wH0r8D+Lbv1Z/BBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Qiu <jie.qiu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.18 278/312] drm/mediatek: mtk_hdmi: Fix probe device leaks
Date: Tue,  6 Jan 2026 18:05:52 +0100
Message-ID: <20260106170557.908158150@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 9545bae5c8acd5a47af7add606718d94578bd838 upstream.

Make sure to drop the references to the DDC adapter and CEC device
taken during probe on probe failure (e.g. probe deferral) and on driver
unbind.

Fixes: 8f83f26891e1 ("drm/mediatek: Add HDMI support")
Cc: stable@vger.kernel.org	# 4.8
Cc: Jie Qiu <jie.qiu@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250923152340.18234-5-johan@kernel.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -1345,6 +1345,13 @@ static const struct drm_bridge_funcs mtk
 	.edid_read = mtk_hdmi_bridge_edid_read,
 };
 
+static void mtk_hdmi_put_device(void *_dev)
+{
+	struct device *dev = _dev;
+
+	put_device(dev);
+}
+
 static int mtk_hdmi_get_cec_dev(struct mtk_hdmi *hdmi, struct device *dev, struct device_node *np)
 {
 	struct platform_device *cec_pdev;
@@ -1369,6 +1376,10 @@ static int mtk_hdmi_get_cec_dev(struct m
 	}
 	of_node_put(cec_np);
 
+	ret = devm_add_action_or_reset(dev, mtk_hdmi_put_device, &cec_pdev->dev);
+	if (ret)
+		return ret;
+
 	/*
 	 * The mediatek,syscon-hdmi property contains a phandle link to the
 	 * MMSYS_CONFIG device and the register offset of the HDMI_SYS_CFG
@@ -1423,6 +1434,10 @@ static int mtk_hdmi_dt_parse_pdata(struc
 	if (!hdmi->ddc_adpt)
 		return dev_err_probe(dev, -EINVAL, "Failed to get ddc i2c adapter by node\n");
 
+	ret = devm_add_action_or_reset(dev, mtk_hdmi_put_device, &hdmi->ddc_adpt->dev);
+	if (ret)
+		return ret;
+
 	ret = mtk_hdmi_get_cec_dev(hdmi, dev, np);
 	if (ret)
 		return ret;


