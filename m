Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9EF2E6CA0;
	Wed, 28 Jan 2026 15:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614773; cv=none; b=DjNiE+WS0UR/xRUY91XpdQIOzrFsf5NpBcypJPyrgmaoD+to4DtIR4udA9vgJayVv+xD2rWdg0GNmrQrNCNvHdBHdE3bTwu3bNFU5qFYpJfU1mj8T+obrm3jiK4xSGW/9XdVcvIDp9xYYcaq3fiQMgcuaYwyRKq907Ha6avtl4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614773; c=relaxed/simple;
	bh=X77IQdMylXlacE/QtrR3x7YXm+UXpagrlWqRA/KIYT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffiayxuDKQ3DovL09beg6lpyv6iafZjeJjZOliqBhSnG20JcSn8vaD0yxS9nQxmceZ7M49wHLL11rEGB7UYgrV2R8l6p0tFGZg89KnfZwVmonMQeyBHR3FOxVf320o30PKGjO/+Y15mWsqjlne8MLjBm4aB9sGtZXODIt/55oho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBrpXx1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBrpXx1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DDCC4CEF1;
	Wed, 28 Jan 2026 15:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614773;
	bh=X77IQdMylXlacE/QtrR3x7YXm+UXpagrlWqRA/KIYT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBrpXx1zQhbPw19t8zO7vpG8zE7sb802djGRRnt1VQ9sU/ZZwBZY+PPYam95dvchQ
	 QfTFxGu1f1kfpge1kg0wzST8G4ToXhNi5qlxn7dSA743c+T928/OJfB1rCFJ9G5tTb
	 DgGcN/eIiOegkggcxemjnASwsp05jOhcX5nk3LSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 237/254] phy: phy-rockchip-inno-usb2: Use dev_err_probe() in the probe path
Date: Wed, 28 Jan 2026 16:23:33 +0100
Message-ID: <20260128145353.322255341@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit 40452520850683f6771094ca218ff206d1fcb022 ]

Improve error handling in the probe path by using function dev_err_probe()
instead of function dev_err(), where appropriate.

Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/d4ccd9fc278fb46ea868406bf77811ee507f0e4e.1725524803.git.dsimic@manjaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: e07dea3de508 ("phy: rockchip: inno-usb2: Fix a double free bug in rockchip_usb2phy_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c |   27 +++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -420,11 +420,9 @@ static int rockchip_usb2phy_extcon_regis
 
 	if (of_property_read_bool(node, "extcon")) {
 		edev = extcon_get_edev_by_phandle(rphy->dev, 0);
-		if (IS_ERR(edev)) {
-			if (PTR_ERR(edev) != -EPROBE_DEFER)
-				dev_err(rphy->dev, "Invalid or missing extcon\n");
-			return PTR_ERR(edev);
-		}
+		if (IS_ERR(edev))
+			return dev_err_probe(rphy->dev, PTR_ERR(edev),
+					     "invalid or missing extcon\n");
 	} else {
 		/* Initialize extcon device */
 		edev = devm_extcon_dev_allocate(rphy->dev,
@@ -434,10 +432,9 @@ static int rockchip_usb2phy_extcon_regis
 			return -ENOMEM;
 
 		ret = devm_extcon_dev_register(rphy->dev, edev);
-		if (ret) {
-			dev_err(rphy->dev, "failed to register extcon device\n");
-			return ret;
-		}
+		if (ret)
+			return dev_err_probe(rphy->dev, ret,
+					     "failed to register extcon device\n");
 	}
 
 	rphy->edev = edev;
@@ -1396,10 +1393,8 @@ static int rockchip_usb2phy_probe(struct
 	}
 
 	ret = rockchip_usb2phy_clk480m_register(rphy);
-	if (ret) {
-		dev_err(dev, "failed to register 480m output clock\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to register 480m output clock\n");
 
 	if (rphy->phy_cfg->phy_tuning) {
 		ret = rphy->phy_cfg->phy_tuning(rphy);
@@ -1419,8 +1414,7 @@ static int rockchip_usb2phy_probe(struct
 
 		phy = devm_phy_create(dev, child_np, &rockchip_usb2phy_ops);
 		if (IS_ERR(phy)) {
-			dev_err_probe(dev, PTR_ERR(phy), "failed to create phy\n");
-			ret = PTR_ERR(phy);
+			ret = dev_err_probe(dev, PTR_ERR(phy), "failed to create phy\n");
 			goto put_child;
 		}
 
@@ -1457,8 +1451,7 @@ next_child:
 						"rockchip_usb2phy",
 						rphy);
 		if (ret) {
-			dev_err(rphy->dev,
-				"failed to request usb2phy irq handle\n");
+			dev_err_probe(rphy->dev, ret, "failed to request usb2phy irq handle\n");
 			goto put_child;
 		}
 	}


