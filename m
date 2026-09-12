Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BE61DE4EF;
	Sat, 12 Sep 2026 14:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222204; cv=none; b=OJOE4POf9wmqriX5CW7UjFq/BnBtHhonH5Ln2j9GI4AmOGSNb3y19yp7dKws+HnvK7O6VAo30Lxaa5Rpi/pwuN7l0qkCCDQDm2WnjcEGE9MIYkr2nZNEaLqMVs1C7opeOWzfTyyzquL5nOD7ZtJotFcYlq4hwz7l8JfyAFdO6vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222204; c=relaxed/simple;
	bh=GOEqtF9FYa7q09gnOmGWsu4rhyEWmAqYRPsft3A7NVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWJMBwnVOnuByoIUy+p9qhz2KeKCYv+EjkJE/dVK1MXLkDBwrbNP4jcEOJKes/WMmjh0wHuxbAD9TAaNG1Buz6RFAYolcUw6P1UFQzegi31ugfHKWLfAN9D67KdcFgxdypdovmujsiv9H4T0Pte2qlojm6h6UcduAO6RlUyNoV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSqsUaIb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSqsUaIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CC51F000FF;
	Sat, 12 Sep 2026 14:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222203;
	bh=5xWi41HQU3LOJuKuM8U0u1QjSPQtIB1BzhLcLZWQFN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSqsUaIbsujennLjBcuR6wSyXg7BZZa67Mtcx0NVtEUZeVOtFjYXq/R4yHjUljLud
	 Ah4K6IXzcW33eSS429tgosd0phcETuu+CAB5nO2M2MwCt3mMTaScMLroEv/pW4E+bb
	 VWBeyRK7Raih2/ojcAy2y61VG+Fgg6pieT00o9zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 6.6 0508/1424] drm/bridge: dw-hdmi: fix i2c adapter leak on probe failure
Date: Sat, 12 Sep 2026 08:49:00 +0200
Message-ID: <20260912065618.664728662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 09b195a7bb23df56269cd2a95d01ba3a5533af13 upstream.

Make sure to drop the i2c adapter device and module references before
returning when detecting a malformed devicetree during probe.

Fixes: 80e2f97968b5 ("drm: bridge: dw-hdmi: Switch to regmap for register access")
Cc: stable@vger.kernel.org	# 4.12
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Link: https://patch.msgid.link/20260717090819.1630965-1-johan@kernel.org
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -3401,7 +3401,8 @@ struct dw_hdmi *dw_hdmi_probe(struct pla
 			break;
 		default:
 			dev_err(dev, "reg-io-width must be 1 or 4\n");
-			return ERR_PTR(-EINVAL);
+			ret = -EINVAL;
+			goto err_res;
 		}
 
 		iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);


