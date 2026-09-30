Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C915563FD9;
	Wed, 30 Sep 2026 17:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790450; cv=none; b=JyeTh3hLtZwyE93WZSnJEoyYwAUaAKsJ8AvqzGrK8cAwdiYqKpbv/60roqAVRUxqwZyHej3SzJNiaoihrNcX/oIm/7DE5B9wo5JxTYu9q68JqSc6zEq5/JSyriEhXST11N76xzR9aQzpYPDoBQos5WW0zKFki+gAwqCnviJMCDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790450; c=relaxed/simple;
	bh=V6VGJl2TSVkRkKuwczIRLadwLebajzdojII3dAv81hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbgAa7Bl1wrMpoiV8oX9GTWpeqPiIyEZXsCl2t1pyo/nVs6W7HKnRbh2vCtieLOkzrj9/4ZLAk4Pg2cnCIeTg2M8X2hWwxGBGPKKuSGoE3eBVsXTYvlLUUSq8eL76qVEhTBlXK+5JgvnCqam25fB+VEGugvhgm3wOgT9CxVFWZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chWaPyjq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chWaPyjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60721F000FF;
	Wed, 30 Sep 2026 17:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790449;
	bh=0KDpQoa+kr8rGqidrqavcct4qNXS8TjDMR/xeRpuQ7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chWaPyjqwPqIWAeW7aJ4xEy5Mg5ZjWhrgnPxRx2mhpPo0YLMNAuvWI6ppXWUsz+A4
	 zJUMDlJt6aCBOY6hi+b5nLYZUU9qg8mf7EoPpw9SKRN9BeMbEiLDn104CML6EVqQ3/
	 SGgeeSMRbSQZIn+oSVlTSBrldBucHt4GLyKRNk1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 789/877] net: phy: mediatek: do not report link and per-speed LED rules together
Date: Wed, 30 Sep 2026 17:28:20 +0200
Message-ID: <20260930152431.740478064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Ahmed Naseef <naseefkm@gmail.com>

[ Upstream commit bde5212360bd44506edec073ebbd6d0c72f75820 ]

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
[ adapted the LED helper changes to the existing gigabit-only implementation in mtk-ge-soc.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mediatek/mtk-ge-soc.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/net/phy/mediatek/mtk-ge-soc.c
+++ b/drivers/net/phy/mediatek/mtk-ge-soc.c
@@ -1276,17 +1276,24 @@ static int mt798x_phy_led_hw_control_get
 	if (!rules)
 		return 0;
 
-	if (on & MTK_PHY_LED_ON_LINK)
+	/* TRIGGER_NETDEV_LINK must not be reported together with any of the
+	 * per-speed rules, the netdev trigger rejects that combination.
+	 * MTK_PHY_LED_ON_LINK holds every speed this LED can indicate and is what
+	 * mt798x_phy_led_hw_control_set() programs for TRIGGER_NETDEV_LINK, so
+	 * report the speed independent rule only when they are all on.
+	 */
+	if ((on & MTK_PHY_LED_ON_LINK) == MTK_PHY_LED_ON_LINK) {
 		*rules |= BIT(TRIGGER_NETDEV_LINK);
+	} else {
+		if (on & MTK_PHY_LED_ON_LINK10)
+			*rules |= BIT(TRIGGER_NETDEV_LINK_10);
 
-	if (on & MTK_PHY_LED_ON_LINK10)
-		*rules |= BIT(TRIGGER_NETDEV_LINK_10);
+		if (on & MTK_PHY_LED_ON_LINK100)
+			*rules |= BIT(TRIGGER_NETDEV_LINK_100);
 
-	if (on & MTK_PHY_LED_ON_LINK100)
-		*rules |= BIT(TRIGGER_NETDEV_LINK_100);
-
-	if (on & MTK_PHY_LED_ON_LINK1000)
-		*rules |= BIT(TRIGGER_NETDEV_LINK_1000);
+		if (on & MTK_PHY_LED_ON_LINK1000)
+			*rules |= BIT(TRIGGER_NETDEV_LINK_1000);
+	}
 
 	if (on & MTK_PHY_LED_ON_FDX)
 		*rules |= BIT(TRIGGER_NETDEV_FULL_DUPLEX);


