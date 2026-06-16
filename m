Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52EE42847F;
	Tue, 16 Jun 2026 15:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625232; cv=none; b=IunJmjW/CCF9DjN7f1eFvQQYqOqPKSuMvKzeWBJ36IFhy4oCnG1S9QmpKMxVkLeTV1kdd3mQ2O3UPfQ4IBFCNVjN4SP8AVFCWArHguWLsu3w2qZkH3d5qS6kktLU2pAnZE3eG7Hhfn06kg/pK/RDAceuctZXqDxhzCEPTne1/T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625232; c=relaxed/simple;
	bh=8lveH1nvM8T+iLDw+YnQD0wmTwVanbwaUsxAp38tsYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9AyqMOrOKIL+w5huj/BFtJHZyl41LZFXp2NUKC0eHdox/nfqEbiVR/0aDwQRwIws/ln04MfSHryG5uluAnOcUptlY56ydWrad/Vs/Y4tnRSd2Vl45VMCmBE1hLydiKo8y16mzPvtOi2SHjh0S2uvZ+xYJD3AmxWQIB1VkIzpBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AaSg01fS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AaSg01fS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC7E1F00A3D;
	Tue, 16 Jun 2026 15:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625231;
	bh=ZXfeJfA/RO1Bq8xJyYSMWtkmJdMnIMtquzgrNXXbVCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AaSg01fSzgmJFv7y8rwUcqbOzRul4H+YEgrARilnVy+ae6QccWBcijJs2+oNyvb1j
	 uspQN5m9191mTqA6dv2LKDYP8pdx+8PsmoYO4y/vTmmsQWF4SU6DhTE9I9w3LVBA0e
	 oRkKpIPTpJPKJHZsDEuvHaIT+VUuzcAF3Xrm3CM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/325] net: phy: clean the sfp upstream if phy probing fails
Date: Tue, 16 Jun 2026 20:28:18 +0530
Message-ID: <20260616145102.766302897@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
index 78cf05a17f8ff2..26b08e3dbd1dee 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1598,6 +1598,9 @@ int phy_sfp_probe(struct phy_device *phydev,
 
 		ret = sfp_bus_add_upstream(bus, phydev, ops);
 		sfp_bus_put(bus);
+
+		if (ret)
+			phydev->sfp_bus = NULL;
 	}
 	return ret;
 }
@@ -3513,6 +3516,9 @@ static int phy_probe(struct device *dev)
 	return 0;
 
 out:
+	sfp_bus_del_upstream(phydev->sfp_bus);
+	phydev->sfp_bus = NULL;
+
 	if (!phydev->is_on_sfp_module)
 		phy_led_triggers_unregister(phydev);
 
-- 
2.53.0



