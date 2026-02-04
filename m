Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594AD27702D;
	Wed,  4 Feb 2026 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218781; cv=none; b=GdHuKic8h+NWzQjJGoY2iZ/9OQMf9Xee2Rlu3jDayhIg79wijSOMEdE1dbJnRmUclrbmNUXYYld88zNPebCafyRrDTqZtvMJBNSkoCk8VT5J/rfRFe6mm54Ug3KqyGSWgBs+ZR+nWf3/yt+4USsPos1kw2o8wCU4mwZS8X1nnDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218781; c=relaxed/simple;
	bh=5bVxUs5Z+KGlbrbRHTvJSsWL6YUQownL0bYp70P4zKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puFtlQd9QPUt8fCBWecAnOJZIWEx6Pvcei+e0rGVbVMDfqvwS8spCT8J62BI2iHIiV2lNyDpHmAMavCw1fWotgYVrYi2jxTGf5pjfQLRPEtg4eAYsJKyRQj8a1bU5CD0XwNcBQu84LjXLDEB6WMnGbBb/AQuUSy18wA34/FjSAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQAvuUwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQAvuUwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21CFC4CEF7;
	Wed,  4 Feb 2026 15:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218781;
	bh=5bVxUs5Z+KGlbrbRHTvJSsWL6YUQownL0bYp70P4zKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQAvuUwiboZtDhMgTb+L0p3dmdtV0nY2W9JzLP7CL5sKzwIA6K/bjYikRTu8Fo8sS
	 MxjKYz9PvUlTUF/8x0cHtbJlx3bNto47uMd3Zfg+lEi1N10DxIUJq2trqgpt4qPA9C
	 q5fRk8qmDZAB2m1EfeF6cgyT0NLxgGo2Ll9oOmfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Frank Li <Frank.Li@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Maxime Ripard <mripard@kernel.org>
Subject: [PATCH 6.12 60/87] drm/imx/tve: fix probe device leak
Date: Wed,  4 Feb 2026 15:40:58 +0100
Message-ID: <20260204143849.079061090@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit e535c23513c63f02f67e3e09e0787907029efeaf upstream.

Make sure to drop the reference taken to the DDC device during probe on
probe failure (e.g. probe deferral) and on driver unbind.

Fixes: fcbc51e54d2a ("staging: drm/imx: Add support for Television Encoder (TVEv2)")
Cc: stable@vger.kernel.org	# 3.10
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251030163456.15807-1-johan@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imx/ipuv3/imx-tve.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/gpu/drm/imx/ipuv3/imx-tve.c
+++ b/drivers/gpu/drm/imx/ipuv3/imx-tve.c
@@ -519,6 +519,13 @@ static const struct component_ops imx_tv
 	.bind	= imx_tve_bind,
 };
 
+static void imx_tve_put_device(void *_dev)
+{
+	struct device *dev = _dev;
+
+	put_device(dev);
+}
+
 static int imx_tve_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -540,6 +547,12 @@ static int imx_tve_probe(struct platform
 	if (ddc_node) {
 		tve->ddc = of_find_i2c_adapter_by_node(ddc_node);
 		of_node_put(ddc_node);
+		if (tve->ddc) {
+			ret = devm_add_action_or_reset(dev, imx_tve_put_device,
+						       &tve->ddc->dev);
+			if (ret)
+				return ret;
+		}
 	}
 
 	tve->mode = of_get_tve_mode(np);


