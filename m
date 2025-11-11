Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F32226AC3;
	Tue, 11 Nov 2025 01:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825031; cv=none; b=UjJ/xWEyKnnlhrMsQGdXgu4HD+kHGWIvOzne3uIeP6qbks4UyI2wanlG9InOR0YexFBS6QbAzxsOZjfl8NqwViTCo8pmBSQxItwzuhjk8l2dQGsgE/gKwroKEKxiUY1coIKwvt3oeCjmCohzBzqAL24VoULrvFuPcjYuCLedQrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825031; c=relaxed/simple;
	bh=jT4mmOZpE3eXMaK3N2lynFyg1xOIDSD0A9Ll20m6/EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3/Pl4K+mHIBy9i8mrtkoISWJ+dWfqRGNAZttqu7UbdjagxsPe5zj1rUucM1ew5s+THeVbZKXVJhutu72LNvmceMonFQWHnOuQMZVw36Sh5pSV8DamjrUAPxsrFnIH18Mxr5EPypS17czejO4T/l+rxQUTPbHA2Mcp5qgczPse4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCUZHBO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCUZHBO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E1AC113D0;
	Tue, 11 Nov 2025 01:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825031;
	bh=jT4mmOZpE3eXMaK3N2lynFyg1xOIDSD0A9Ll20m6/EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCUZHBO9qWcACmiQTJHbIeuX1oEmpsvSd0E0Bht5iWK/RKhd5P0a9bUnAVzhZNHeV
	 3LA+FxqUTbnrofJifUQlXpm3h4EdUtESzUFB//1D4AiVpNRc1ZnIG9XSZnyHT8ImHM
	 wm30+D1hGCKvqku2N7x6jsE8XU3Jf838CCOwgEmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 632/849] net: phy: dp83640: improve phydev and driver removal handling
Date: Tue, 11 Nov 2025 09:43:22 +0900
Message-ID: <20251111004551.712351633@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 42e2a9e11a1dcb81c83d50d18c547dc9a1c6d6ed ]

Once the last user of a clock has been removed, the clock should be
removed. So far orphaned clocks are cleaned up in dp83640_free_clocks()
only. Add the logic to remove orphaned clocks in dp83640_remove().
This allows to simplify the code, and use standard macro
module_phy_driver(). dp83640 was the last external user of
phy_driver_register(), so we can stop exporting this function afterwards.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/6d4e80e7-c684-4d95-abbd-ea62b79a9a8a@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83640.c | 58 ++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 38 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index daab555721df8..74396453f5bb2 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -953,30 +953,6 @@ static void decode_status_frame(struct dp83640_private *dp83640,
 	}
 }
 
-static void dp83640_free_clocks(void)
-{
-	struct dp83640_clock *clock;
-	struct list_head *this, *next;
-
-	mutex_lock(&phyter_clocks_lock);
-
-	list_for_each_safe(this, next, &phyter_clocks) {
-		clock = list_entry(this, struct dp83640_clock, list);
-		if (!list_empty(&clock->phylist)) {
-			pr_warn("phy list non-empty while unloading\n");
-			BUG();
-		}
-		list_del(&clock->list);
-		mutex_destroy(&clock->extreg_lock);
-		mutex_destroy(&clock->clock_lock);
-		put_device(&clock->bus->dev);
-		kfree(clock->caps.pin_config);
-		kfree(clock);
-	}
-
-	mutex_unlock(&phyter_clocks_lock);
-}
-
 static void dp83640_clock_init(struct dp83640_clock *clock, struct mii_bus *bus)
 {
 	INIT_LIST_HEAD(&clock->list);
@@ -1479,6 +1455,7 @@ static void dp83640_remove(struct phy_device *phydev)
 	struct dp83640_clock *clock;
 	struct list_head *this, *next;
 	struct dp83640_private *tmp, *dp83640 = phydev->priv;
+	bool remove_clock = false;
 
 	if (phydev->mdio.addr == BROADCAST_ADDR)
 		return;
@@ -1506,11 +1483,27 @@ static void dp83640_remove(struct phy_device *phydev)
 		}
 	}
 
+	if (!clock->chosen && list_empty(&clock->phylist))
+		remove_clock = true;
+
 	dp83640_clock_put(clock);
 	kfree(dp83640);
+
+	if (remove_clock) {
+		mutex_lock(&phyter_clocks_lock);
+		list_del(&clock->list);
+		mutex_unlock(&phyter_clocks_lock);
+
+		mutex_destroy(&clock->extreg_lock);
+		mutex_destroy(&clock->clock_lock);
+		put_device(&clock->bus->dev);
+		kfree(clock->caps.pin_config);
+		kfree(clock);
+	}
 }
 
-static struct phy_driver dp83640_driver = {
+static struct phy_driver dp83640_driver[] = {
+{
 	.phy_id		= DP83640_PHY_ID,
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "NatSemi DP83640",
@@ -1521,26 +1514,15 @@ static struct phy_driver dp83640_driver = {
 	.config_init	= dp83640_config_init,
 	.config_intr    = dp83640_config_intr,
 	.handle_interrupt = dp83640_handle_interrupt,
+},
 };
 
-static int __init dp83640_init(void)
-{
-	return phy_driver_register(&dp83640_driver, THIS_MODULE);
-}
-
-static void __exit dp83640_exit(void)
-{
-	dp83640_free_clocks();
-	phy_driver_unregister(&dp83640_driver);
-}
+module_phy_driver(dp83640_driver);
 
 MODULE_DESCRIPTION("National Semiconductor DP83640 PHY driver");
 MODULE_AUTHOR("Richard Cochran <richardcochran@gmail.com>");
 MODULE_LICENSE("GPL");
 
-module_init(dp83640_init);
-module_exit(dp83640_exit);
-
 static const struct mdio_device_id __maybe_unused dp83640_tbl[] = {
 	{ DP83640_PHY_ID, 0xfffffff0 },
 	{ }
-- 
2.51.0



