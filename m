Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8752BD012;
	Wed,  4 Feb 2026 15:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218323; cv=none; b=J0A4o39rWkm4xtTlx0ZShZDMxAN4RSuunaWr7/WrpRahXr6cvtmgUiTpNrSiUIa6lSoGM47LWFDKBbs2zy3gxQEhI1ap5uZPuykXhg8lDHayqNtkZw/VLh6bZgVp3yviQS718Dk/Klwcq/T0YlDQPXcH2byLPnqa0vgbncir7Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218323; c=relaxed/simple;
	bh=m4rPtjOGspYILChpynzt/3roVAqSHeaKJ1EADyV/JZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bW4+0+EilUtrqn3Y5xVWgh3Hv2hBXsaZP0HO7mhcJqmbaAFqCIeALwLHl3VJPlV1bv+90oDt226nqKM8MgH3FuJ6vuJoXIChPREKK91LQeGnruQuygArmM47xC3vpL+6ta3jQRF7L2gAF1yiCB97hTUeBJXNAahflWixVvjIbSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRluMFPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRluMFPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92521C4CEF7;
	Wed,  4 Feb 2026 15:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218323;
	bh=m4rPtjOGspYILChpynzt/3roVAqSHeaKJ1EADyV/JZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRluMFPK9TABnl7PahwZPDjR2HC5XQet0jGi7dFLqN3QCFeDKrka5PqXn2BtjJeqh
	 Lf8KxtWECkIHJP92pFOVTXBqAF95g2HQQmfPLJNl1ZjeIgLN+J0AU+DjTnEOQv/4dW
	 2oJgAt9PwWYGWYJsjepvcpWqnfeDFYkaORnztITE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Frank Li <Frank.Li@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 278/280] drm/imx/tve: fix probe device leak
Date: Wed,  4 Feb 2026 15:40:52 +0100
Message-ID: <20260204143919.708360263@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit e535c23513c63f02f67e3e09e0787907029efeaf ]

Make sure to drop the reference taken to the DDC device during probe on
probe failure (e.g. probe deferral) and on driver unbind.

Fixes: fcbc51e54d2a ("staging: drm/imx: Add support for Television Encoder (TVEv2)")
Cc: stable@vger.kernel.org	# 3.10
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251030163456.15807-1-johan@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imx/imx-tve.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/gpu/drm/imx/imx-tve.c
+++ b/drivers/gpu/drm/imx/imx-tve.c
@@ -522,6 +522,13 @@ static const struct component_ops imx_tv
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
@@ -543,6 +550,12 @@ static int imx_tve_probe(struct platform
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


