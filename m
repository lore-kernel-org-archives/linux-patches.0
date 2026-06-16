Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706CA477986;
	Tue, 16 Jun 2026 16:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626856; cv=none; b=OhwvN+tlbwjfbYfo8ArumsiCZLbrPupXn1z2sQN7wNVBxI5qY+EkyVfTd5JCldYwHvd2v/o5+wH9KdKtA3dKyWJlBxnQIvddt5LoHMAMDLVgH3+t09DiiSIzm90yDS+Q/MZBpqN19v14GlJwb+XwAAo5cQ31HhGAkun/M22zH14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626856; c=relaxed/simple;
	bh=xZjWvgMF7iFlYED2vmlABbOHdJaWX0faiHbVqSclukw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPS4RnW0vBAmhfThSCWkoce4MGV8Ko3LzU3YxlV7bTG1TPeFhuWciNPE9Bkbwo8cBGX8WXaGyg4/WU5RKpANhbHZKwfpGePcL8vGijTU6W3wk10C6e+LE4So8UkY4ucfINxvh58i42nvdEvARahJI1QxYx/tqDuNEHmrR+6R/lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eMaGtst; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eMaGtst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0001F00A3A;
	Tue, 16 Jun 2026 16:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626855;
	bh=4K6+LbJge0zWh33jP1wRPbqcQEekzq7c7k5hovjSLxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1eMaGtstyddCaWAqzNOiE2O8+uDkUKpwv/f4uBirBFoSPvCdVMK2LuDxwo9vzf2BR
	 38f3ZgTXAHT9pye3LHNqMg2ZSBBNwwAJA4fHopUzoVoGjVRWKWjDLg+s8rc4DabHFs
	 pszWVhJjj0nsGTRVuWODG4I7/P4hH11r3ykLNXuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/261] net: phy: clean the sfp upstream if phy probing fails
Date: Tue, 16 Jun 2026 20:28:41 +0530
Message-ID: <20260616145048.907719266@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
index eb478e4961cb9b..f2d067b907bf99 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1508,6 +1508,9 @@ int phy_sfp_probe(struct phy_device *phydev,
 
 		ret = sfp_bus_add_upstream(bus, phydev, ops);
 		sfp_bus_put(bus);
+
+		if (ret)
+			phydev->sfp_bus = NULL;
 	}
 	return ret;
 }
@@ -3672,6 +3675,9 @@ static int phy_probe(struct device *dev)
 	return 0;
 
 out:
+	sfp_bus_del_upstream(phydev->sfp_bus);
+	phydev->sfp_bus = NULL;
+
 	if (!phydev->is_on_sfp_module)
 		phy_led_triggers_unregister(phydev);
 
-- 
2.53.0



