Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15531D079F;
	Wed,  2 Oct 2024 13:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876556; cv=none; b=DPgJmpOszPl2gsr0Z0iQljveIgizkd041Gh35dmbL8XROVQBRgwF9n6hn2qJBeWOhy+DoWAX/X0tp0o8Bn1QMTQHy06FaiOQwRCXR2j7L3DOPGZHsgbU3nFqsooANrbY65hpMNOxqFOqeSMwyuD433OsDFr6gO2BbpbrVmnRI0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876556; c=relaxed/simple;
	bh=MxeOZjjDIunHkLZ3OLM/wn9WItA/C/4Wq8b68/CC+xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CykvSdikiHuPBb+2DBo66V5NXrJU8pE5anyl+PFjP1vkRaeERrvHWjT3bU+ywTWnul49T9RkD6zRNl22ez6qcTdU+bTwL9pwPg07PGHVGOurJapLJID7ZiD4na1iuRsOzXegRBT/c/BcbkEOfOin7J6wR94nF6diH+hv0Or9XTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evCINygi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evCINygi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39252C4CECE;
	Wed,  2 Oct 2024 13:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876556;
	bh=MxeOZjjDIunHkLZ3OLM/wn9WItA/C/4Wq8b68/CC+xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evCINygiifPNGxXTH7wcRmZhhKwgfvgaRTjo4jvcqQ45sJmd0W3zv6UATxkwS96vL
	 VyVtlAXfZSNv0EFI4MUGSZIg/jkWuwfunucp0SbZhY6bhVPaS0tQpk147CcN2MKv01
	 oVB1KX7EijTl09bFYxSa3qkec/aYY0gWdBmi8Pdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 484/695] net: phy: aquantia: fix applying active_low bit after reset
Date: Wed,  2 Oct 2024 14:58:02 +0200
Message-ID: <20241002125841.789831281@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 6f9defaf99122d1af9c2562181c77bc99be0672d ]

for_each_set_bit was used wrongly in aqr107_config_init() when iterating
over LEDs. Drop misleading 'index' variable and call
aqr_phy_led_active_low_set() for each set bit representing an LED which
is driven by VDD instead of GND pin.

Fixes: 61578f679378 ("net: phy: aquantia: add support for PHY LEDs")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/9b1f0cd91f4cda54c8be56b4fe780480baf4aa0f.1726580902.git.daniel@makrotopia.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/aquantia/aquantia_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/aquantia/aquantia_main.c b/drivers/net/phy/aquantia/aquantia_main.c
index 57b8b8f400fd4..4d156d406bab9 100644
--- a/drivers/net/phy/aquantia/aquantia_main.c
+++ b/drivers/net/phy/aquantia/aquantia_main.c
@@ -489,7 +489,7 @@ static int aqr107_config_init(struct phy_device *phydev)
 {
 	struct aqr107_priv *priv = phydev->priv;
 	u32 led_active_low;
-	int ret, index = 0;
+	int ret;
 
 	/* Check that the PHY interface type is compatible */
 	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
@@ -516,10 +516,9 @@ static int aqr107_config_init(struct phy_device *phydev)
 
 	/* Restore LED polarity state after reset */
 	for_each_set_bit(led_active_low, &priv->leds_active_low, AQR_MAX_LEDS) {
-		ret = aqr_phy_led_active_low_set(phydev, index, led_active_low);
+		ret = aqr_phy_led_active_low_set(phydev, led_active_low, true);
 		if (ret)
 			return ret;
-		index++;
 	}
 
 	return 0;
-- 
2.43.0



