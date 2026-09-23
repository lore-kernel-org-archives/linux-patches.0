Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B46535FA3;
	Wed, 23 Sep 2026 14:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174968; cv=none; b=dumHgei/3ad897rPTQypNUgD1Lf8JwbmhsRV4e2c/02/jJAFWxxg9G/5W+RZrSTnRVOXYi3JwsAFRhkcVdl0pWOeROTBgGGYikJvS4cYW2CYyN3zuQ7I4JgEtXfVfQUN34QfMnGecsvySfSYLrW/VfJDenBByz3usereYTnDEOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174968; c=relaxed/simple;
	bh=M0Zl5DcaTP1Lrr1nkJoNiSW2Se0nGcTUC8mHEdPw3Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgTadaaBGePSkuEaxY2uS1eCzgA0+a3apy2g9zo13ckPndhlIsruJaByiE7x1vMNISxr1CkT5STXRwA4DMwc/MrDQMGFFl3NGs7b7FiXgYJt+tidgQXwcyUDn5w5yk7SxMMB04Dt48bTk+bFJPYFNMIZc3+NtSevJ3c9znc+hpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KADBqdi2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KADBqdi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A5A1F000FF;
	Wed, 23 Sep 2026 14:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174967;
	bh=4Si1nCoK06SM9C1DCeRwCjxKbna+7Fsubzj+6UUvwZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KADBqdi2TOBGIdW6MNo9S24KjTeTlz+/VZMXnQA2B8Xkb86u7I82g2EobkUdiw8Ev
	 wv2yll5WXAzS31oVFNt/GTiYHwhIqvu7Sg4vlReWiFhpoNwtP55pLMDhxoKJFVVfdX
	 OSayKLlaM/qVAyJ5n98WDagU9S0gVQ/7bY93qnYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 245/398] net: phy: mediatek: do not report link and per-speed LED rules together
Date: Wed, 23 Sep 2026 16:05:19 +0200
Message-ID: <20260923140649.761456593@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Ahmed Naseef <naseefkm@gmail.com>

commit bde5212360bd44506edec073ebbd6d0c72f75820 upstream.

mtk_phy_led_hw_ctrl_get() reports TRIGGER_NETDEV_LINK whenever any of the
speed bits in on_set is on, and in addition reports every individual
TRIGGER_NETDEV_LINK_* bit that is set. The netdev trigger refuses that
combination: netdev_led_attr_store() rejects TRIGGER_NETDEV_LINK together
with any per-speed rule, and it validates the whole resulting mode rather
than just the bit being written. Once the hardware has any link bit
programmed, every write to the trigger attributes of that LED therefore
fails with -EINVAL and the LED can no longer be configured.

The rules are also fed back into the hardware: the trigger stores what is
read back, and a later write of device_name programs it again, expanding
TRIGGER_NETDEV_LINK to every speed in on_set. An LED configured for a
single speed is thereby silently widened to "on at any link speed".

Both are easy to see on the EcoNet EN7528, whose four PHYs share one LED
block. The first LED programs the block correctly, the second reads those
rules back and rewrites them widened, and the remaining two then read the
widened value, so an LED configured for "link_10 link_100" ends up lit on a
1000 Mbps link.

on_set holds every speed the LED can indicate and is exactly what
mtk_phy_led_hw_ctrl_set() programs for TRIGGER_NETDEV_LINK, so report the
speed independent rule only when all of them are on, and the individual
speeds otherwise. The mapping is then the inverse of the one used when
programming the LED and round trips without changing the register.

Fixes: c66937b0f8db ("net: phy: mediatek-ge-soc: support PHY LEDs")
Cc: stable@vger.kernel.org
Signed-off-by: Ahmed Naseef <naseefkm@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260912134306.3544329-1-naseefkm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mediatek/mtk-phy-lib.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

--- a/drivers/net/phy/mediatek/mtk-phy-lib.c
+++ b/drivers/net/phy/mediatek/mtk-phy-lib.c
@@ -156,20 +156,27 @@ int mtk_phy_led_hw_ctrl_get(struct phy_d
 	if (!rules)
 		return 0;
 
-	if (on & on_set)
+	/* TRIGGER_NETDEV_LINK must not be reported together with any of the
+	 * per-speed rules, the netdev trigger rejects that combination.
+	 * on_set holds every speed this LED can indicate and is what
+	 * mtk_phy_led_hw_ctrl_set() programs for TRIGGER_NETDEV_LINK, so
+	 * report the speed independent rule only when they are all on.
+	 */
+	if ((on & on_set) == on_set) {
 		*rules |= BIT(TRIGGER_NETDEV_LINK);
-
-	if (on & MTK_PHY_LED_ON_LINK10)
-		*rules |= BIT(TRIGGER_NETDEV_LINK_10);
-
-	if (on & MTK_PHY_LED_ON_LINK100)
-		*rules |= BIT(TRIGGER_NETDEV_LINK_100);
-
-	if (on & MTK_PHY_LED_ON_LINK1000)
-		*rules |= BIT(TRIGGER_NETDEV_LINK_1000);
-
-	if (on & MTK_PHY_LED_ON_LINK2500)
-		*rules |= BIT(TRIGGER_NETDEV_LINK_2500);
+	} else {
+		if (on & MTK_PHY_LED_ON_LINK10)
+			*rules |= BIT(TRIGGER_NETDEV_LINK_10);
+
+		if (on & MTK_PHY_LED_ON_LINK100)
+			*rules |= BIT(TRIGGER_NETDEV_LINK_100);
+
+		if (on & MTK_PHY_LED_ON_LINK1000)
+			*rules |= BIT(TRIGGER_NETDEV_LINK_1000);
+
+		if (on & MTK_PHY_LED_ON_LINK2500)
+			*rules |= BIT(TRIGGER_NETDEV_LINK_2500);
+	}
 
 	if (on & MTK_PHY_LED_ON_FDX)
 		*rules |= BIT(TRIGGER_NETDEV_FULL_DUPLEX);


