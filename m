Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A81281530;
	Wed,  4 Feb 2026 14:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216681; cv=none; b=kDapMjuHa9fx2gMabJt6YNSde4L1cIMtCVx9+GKcRxsuz1eWFc/71fhpsDxBOcQ1IM0Js16afWoQjXNU85SArBT89LPFWnyEJiSidVYs5ytFnrtruh7etwCFP8aoN6QPRjws5yTvCRbjFwOLde4wEI+1otfXsmCbH+vf4Ddc9I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216681; c=relaxed/simple;
	bh=+x73yPqfFOnVE0MiZ7qqtXbBWlWJ4Byc1iWviJCb05o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEgp1vCqxOqJaYAK5Ft5sfYyKkm9ytjkaPBYIlIegiz2wJ9BJgXK8jTpx+ZgPww0uMfOnuLgzsfrZX+VZXhAzUatNdogA9DMaJJjLQKg/ThdaW3Afh21buqG0m7Cy8f+JWZpzSv6XS2M/6WpZnbhtDa+RwLkAzuha6eoA5D/D+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3DzkqdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3DzkqdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A45C4CEF7;
	Wed,  4 Feb 2026 14:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216681;
	bh=+x73yPqfFOnVE0MiZ7qqtXbBWlWJ4Byc1iWviJCb05o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3DzkqdTVk88UI7GlfzWHdVN4s7LFbpGFYYaFIgwcE1ft7liLRA32YXFSYzOX7j/Q
	 dtKqoItjFYmDcIaJuA7XNVqUstrUoAfX8rT7luj/Wj322ZCyF2+sJm6mPR712HXBLp
	 XqDlsc9u6DwGQYnk6Cy7vDQrRkYQ/o46aikxhhW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Frank Li <Frank.Li@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/161] drm/imx/tve: fix probe device leak
Date: Wed,  4 Feb 2026 15:40:24 +0100
Message-ID: <20260204143857.542369387@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -517,6 +517,13 @@ static const struct component_ops imx_tv
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
@@ -539,6 +546,12 @@ static int imx_tve_probe(struct platform
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


