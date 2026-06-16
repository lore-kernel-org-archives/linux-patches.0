Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B097F449EA8;
	Tue, 16 Jun 2026 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623434; cv=none; b=VLuqkgcETbnliUeC1koEIiI3t629qLxJO70iUKiWYrIVvUUndVdBvL2PkkN/CScqZQB9FwDqJBGf0XTEmo0frWp1WLejeTL35k4u1VBuz0BrB4xM6rpJZQ44zv6AQMCPSXNrm4fADR8+D4Jcbn2CbIoyBJLGySIJl4wHQybnunM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623434; c=relaxed/simple;
	bh=qQCakSUeZ1KB204THeQ9g07i8C9aFxnI7gW0b57AJ/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Od9LUdBoISim4GmLq309B+0yaf0jVJT5MsfX2m7UA9bicccpUeKfnGfz4svY9Yq1GhxDxRmz6TIZOhatwkBhJEScnn8REey1q0XBqzcW5CabqtJowVV4s6G8ANuAo7n7sG8FBBbmrnMQgucLZMplmlw2wA6UUV1zKJKhlgNcrqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcI4MIML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcI4MIML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AD41F000E9;
	Tue, 16 Jun 2026 15:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623433;
	bh=PIUs6rIecLyX4V25qmFlZ9UlUGfi3lcClx4AWWr1rCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OcI4MIML196PYXZrI+Y4XGbUd2awWnITlTeU05Djj+N7RfOMdUtjwxECVOvX12Gng
	 P3Pv7uZLwtEfooGfjn7s6PXdjyWaKYRw2m1n6zVR2Ep+7YopouMb9Ay2hrDf37jeDe
	 X2Fm/t5+up+V20eM5d2b4tLhR4EREu6Qn4HnjPcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 114/378] net: phy: clean the sfp upstream if phy probing fails
Date: Tue, 16 Jun 2026 20:25:45 +0530
Message-ID: <20260616145116.366429937@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 48774e87bbaa0056819d4b52301e4692e50e3252 ]

Sashiko reported that we don't call sfp_bus_del_upstream() in the probe
failure path, so let's add it, otherwise the sfp-bus is left with a
dangling 'upstream' field, that may be used later on during SFP events.

This issue existed before the generic phylib sfp support, back when
drivers were calling phy_sfp_probe themselves.

Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Fixes: 298e54fa810e ("net: phy: add core phylib sfp support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260604092819.723505-2-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index cfb505ed9a3a09..c6722592f8672a 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1710,6 +1710,9 @@ static int phy_sfp_probe(struct phy_device *phydev)
 
 		ret = sfp_bus_add_upstream(bus, phydev, &sfp_phydev_ops);
 		sfp_bus_put(bus);
+
+		if (ret)
+			phydev->sfp_bus = NULL;
 	}
 
 	if (!ret && phydev->sfp_bus)
@@ -3791,6 +3794,9 @@ static int phy_probe(struct device *dev)
 	return 0;
 
 out:
+	sfp_bus_del_upstream(phydev->sfp_bus);
+	phydev->sfp_bus = NULL;
+
 	if (!phydev->is_on_sfp_module)
 		phy_led_triggers_unregister(phydev);
 
-- 
2.53.0



