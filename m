Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D9A251793;
	Tue, 29 Apr 2025 17:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949345; cv=none; b=TNWZAXVPND6rAUo1PpuWPE355Dnu/MeZ71yNsg7j40h7lCAyNlKsWuqjjC1WWYKESaKgyu/QbOkVgG1X85F0qNXUFoaa4fKUjMgMEz3gPphPI+hMKVfQ6Wg8LNGVzy8LDTQBtKGdFOGL0TYEabgt4U1PC4DTGLJkx62Bj0Mc+UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949345; c=relaxed/simple;
	bh=9deHqYkF0n48rBV/YXCR3tvhXRgO0i6L5F24Jzew7D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLB0+BxFFydzBhSrWNSf0JMpo/iohZP15UKY0xQOjY/WCIBH+vQFjIvcCA/yO1l1Bc8dfSCbOOpbOXDtPCypgaF49iMx8ughRQha6EERTH9qK6lK5yG0/FwKVgJCqNqDx2XxuXRHBsGEbAcHAqRmGKX7fCy/DBod19FE0YAvpHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iB5gY3ht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iB5gY3ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA59DC4CEE3;
	Tue, 29 Apr 2025 17:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949345;
	bh=9deHqYkF0n48rBV/YXCR3tvhXRgO0i6L5F24Jzew7D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iB5gY3htCsCNpj8Vq4+94v5UyNwIg93fNGOFjHeIqI3rUdBFVbZr33ZO7cJL/ZPRY
	 c582XZGFpboK7snLCWFdNxwXbusTLlbHRWQzOVAMx2/Ot3yW1U8NrJo7p6bmmTI750
	 owQZwYa6IY+9OCz9kanvd08rDjtUjKJ6vNojDQyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Guan <hao.guan@siflower.com.cn>,
	Qingfang Deng <qingfang.deng@siflower.com.cn>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 290/373] net: phy: leds: fix memory leak
Date: Tue, 29 Apr 2025 18:42:47 +0200
Message-ID: <20250429161135.043728627@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <qingfang.deng@siflower.com.cn>

[ Upstream commit b7f0ee992adf601aa00c252418266177eb7ac2bc ]

A network restart test on a router led to an out-of-memory condition,
which was traced to a memory leak in the PHY LED trigger code.

The root cause is misuse of the devm API. The registration function
(phy_led_triggers_register) is called from phy_attach_direct, not
phy_probe, and the unregister function (phy_led_triggers_unregister)
is called from phy_detach, not phy_remove. This means the register and
unregister functions can be called multiple times for the same PHY
device, but devm-allocated memory is not freed until the driver is
unbound.

This also prevents kmemleak from detecting the leak, as the devm API
internally stores the allocated pointer.

Fix this by replacing devm_kzalloc/devm_kcalloc with standard
kzalloc/kcalloc, and add the corresponding kfree calls in the unregister
path.

Fixes: 3928ee6485a3 ("net: phy: leds: Add support for "link" trigger")
Fixes: 2e0bc452f472 ("net: phy: leds: add support for led triggers on phy link state change")
Signed-off-by: Hao Guan <hao.guan@siflower.com.cn>
Signed-off-by: Qingfang Deng <qingfang.deng@siflower.com.cn>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250417032557.2929427-1-dqfext@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_led_triggers.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/phy_led_triggers.c b/drivers/net/phy/phy_led_triggers.c
index f550576eb9dae..6f9d8da76c4df 100644
--- a/drivers/net/phy/phy_led_triggers.c
+++ b/drivers/net/phy/phy_led_triggers.c
@@ -91,9 +91,8 @@ int phy_led_triggers_register(struct phy_device *phy)
 	if (!phy->phy_num_led_triggers)
 		return 0;
 
-	phy->led_link_trigger = devm_kzalloc(&phy->mdio.dev,
-					     sizeof(*phy->led_link_trigger),
-					     GFP_KERNEL);
+	phy->led_link_trigger = kzalloc(sizeof(*phy->led_link_trigger),
+					GFP_KERNEL);
 	if (!phy->led_link_trigger) {
 		err = -ENOMEM;
 		goto out_clear;
@@ -103,10 +102,9 @@ int phy_led_triggers_register(struct phy_device *phy)
 	if (err)
 		goto out_free_link;
 
-	phy->phy_led_triggers = devm_kcalloc(&phy->mdio.dev,
-					    phy->phy_num_led_triggers,
-					    sizeof(struct phy_led_trigger),
-					    GFP_KERNEL);
+	phy->phy_led_triggers = kcalloc(phy->phy_num_led_triggers,
+					sizeof(struct phy_led_trigger),
+					GFP_KERNEL);
 	if (!phy->phy_led_triggers) {
 		err = -ENOMEM;
 		goto out_unreg_link;
@@ -127,11 +125,11 @@ int phy_led_triggers_register(struct phy_device *phy)
 out_unreg:
 	while (i--)
 		phy_led_trigger_unregister(&phy->phy_led_triggers[i]);
-	devm_kfree(&phy->mdio.dev, phy->phy_led_triggers);
+	kfree(phy->phy_led_triggers);
 out_unreg_link:
 	phy_led_trigger_unregister(phy->led_link_trigger);
 out_free_link:
-	devm_kfree(&phy->mdio.dev, phy->led_link_trigger);
+	kfree(phy->led_link_trigger);
 	phy->led_link_trigger = NULL;
 out_clear:
 	phy->phy_num_led_triggers = 0;
@@ -145,8 +143,13 @@ void phy_led_triggers_unregister(struct phy_device *phy)
 
 	for (i = 0; i < phy->phy_num_led_triggers; i++)
 		phy_led_trigger_unregister(&phy->phy_led_triggers[i]);
+	kfree(phy->phy_led_triggers);
+	phy->phy_led_triggers = NULL;
 
-	if (phy->led_link_trigger)
+	if (phy->led_link_trigger) {
 		phy_led_trigger_unregister(phy->led_link_trigger);
+		kfree(phy->led_link_trigger);
+		phy->led_link_trigger = NULL;
+	}
 }
 EXPORT_SYMBOL_GPL(phy_led_triggers_unregister);
-- 
2.39.5



