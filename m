Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74A327726;
	Wed,  4 Jun 2025 01:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998914; cv=none; b=TXK0MIjgWwvXmuc6fK7opnBDEo8egoWv4t5ZZ7qYUAUyQdGVqotNQ33H0WURgg54n26QpnRJKBihbx1UsW+DdZhLQF+bNwekLy3QxfDboVwmJxHvW1JdCL0/lkG7AScVzRwBMj9I3d3lzhD3TyjitR8J4fOmaeQoaRHrpKd/Ao0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998914; c=relaxed/simple;
	bh=KVolGAcX7oueIE0Sbb+ta5lMCGBforILEJpbrcfIY7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HxyN4kX6u5FKoUuOPMaEJkXHm9LS9trhQ6xxh2IvwDb9oNjdeCDkdtOOQ8x9BwUcFWwUQ8k/h4CKgtz+Pb3S4qiMY8n4bRDaTq40kVoW5+CQz9fmJF2ZE00Zl2ryK2oyQWDUalbokqVVF8fq0K8H5DY3g4gTJzowyxtZ2xCqAXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NmzWxTbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NmzWxTbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9947EC4CEED;
	Wed,  4 Jun 2025 01:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998913;
	bh=KVolGAcX7oueIE0Sbb+ta5lMCGBforILEJpbrcfIY7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmzWxTbJRZAyjByuygPzZrwiBcIbc+JbLrYbKYTEK8z/SjduKPpkCBW8LnegUhEWA
	 mPKuli+wIxv8xesbJr38F70RFjaM0s/K3FasvW+8H6jfu0JwzgPVtp23f+NV4XrSWW
	 y/smCdW7ETMTlRXIwyx1XVlP3cTlCpn20MWABUnNSJWzCpKzo0Pm0YU7BPDlNJoUDo
	 PGJL49k0mQNNrHAl49Q2iBPrGzg3E2uvhiE3ZHkraPEyVk9VI3LPyMJJbQdEy8XYMG
	 nU/ICxko6h27FoKpUWiE6TnOO9MVUUuSIchqgNyrCp+C7yF9H6lRzdNxQ/w6dJAS6X
	 pK1w/KuOm5EMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux@armlinux.org.uk,
	max.schulze@online.de,
	linux-usb@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 84/93] usbnet: asix AX88772: leave the carrier control to phylink
Date: Tue,  3 Jun 2025 20:59:10 -0400
Message-Id: <20250604005919.4191884-84-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005919.4191884-1-sashal@kernel.org>
References: <20250604005919.4191884-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Transfer-Encoding: 8bit

From: Krzysztof Hałasa <khalasa@piap.pl>

[ Upstream commit 4145f00227ee80f21ab274e9cd9c09758e9bcf3d ]

ASIX AX88772B based USB 10/100 Ethernet adapter doesn't come
up ("carrier off"), despite the built-in 100BASE-FX PHY positive link
indication. The internal PHY is configured (using EEPROM) in fixed
100 Mbps full duplex mode.

The primary problem appears to be using carrier_netif_{on,off}() while,
at the same time, delegating carrier management to phylink. Use only the
latter and remove "manual control" in the asix driver.

I don't have any other AX88772 board here, but the problem doesn't seem
specific to a particular board or settings - it's probably
timing-dependent.

Remove unused asix_adjust_link() as well.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/m3plhmdfte.fsf_-_@t19.piap.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my detailed analysis: ## Why This Should Be Backported ### 1. **Clear
Bug Fix Nature** This commit fixes a functional bug where ASIX AX88772B
USB Ethernet adapters fail to establish carrier state ("carrier off")
despite the PHY indicating a positive link. This is a real-world
connectivity issue that affects users' ability to use their network
hardware. ### 2. **Code Analysis - Specific Changes** Looking at the
diff, the changes are: - **Removed `asix_adjust_link()` function** from
`asix_common.c` - This function was manually calling
`usbnet_link_change()` which conflicts with phylink - **Removed
`usbnet_link_change()` calls** from `ax88772_mac_link_up()` and
`ax88772_mac_link_down()` in `asix_devices.c` - **Removed `.status =
asix_status`** from driver info structures for AX88772 devices -
**Removed `FLAG_LINK_INTR`** from AX88772 device driver flags These
changes eliminate the dual carrier control conflict by removing manual
carrier management and letting phylink handle it exclusively. ### 3.
**Low Risk Profile** - **Removes conflicting code** rather than adding
new functionality - **Small, focused changes** that address a specific
technical conflict - **Phylink is well-established** and already
properly handles carrier management for these devices - **Changes are
targeted** to specific hardware (AX88772) rather than broad
architectural changes ### 4. **Comparison to Similar "NO" Commits** The
provided similar commits were marked "NO" because they were: - **Feature
additions** (phylink migration, selftest support) - **Architectural
changes** (migrating from MII to phylink) - **Enhancements** rather than
bug fixes This commit is fundamentally different - it's a **bug fix**
that resolves a conflict introduced by previous phylink migration work.
### 5. **User Impact** This affects users who have ASIX AX88772B
adapters that don't work properly due to carrier detection issues. This
is likely a regression from earlier phylink migration commits, making it
a critical fix for hardware compatibility. ### 6. **Stable Tree Criteria
Compliance** - ✅ **Important bug fix** - Fixes network connectivity
issues - ✅ **Minimal risk** - Removes conflicting code, doesn't
introduce new features - ✅ **Small and contained** - Changes are focused
on carrier control conflict - ✅ **No architectural changes** -
Simplifies by removing duplicate functionality - ✅ **Clear side
effects** - Only affects AX88772 devices, improves their functionality
The commit message explicitly states this fixes a timing-dependent issue
where devices "don't come up" despite proper PHY indication, which is
exactly the type of hardware compatibility bug that stable trees aim to
address.

 drivers/net/usb/asix.h         |  1 -
 drivers/net/usb/asix_common.c  | 22 ----------------------
 drivers/net/usb/asix_devices.c | 17 ++++-------------
 3 files changed, 4 insertions(+), 36 deletions(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index 74162190bccc1..8531b804021aa 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -224,7 +224,6 @@ int asix_write_rx_ctl(struct usbnet *dev, u16 mode, int in_pm);
 
 u16 asix_read_medium_status(struct usbnet *dev, int in_pm);
 int asix_write_medium_mode(struct usbnet *dev, u16 mode, int in_pm);
-void asix_adjust_link(struct net_device *netdev);
 
 int asix_write_gpio(struct usbnet *dev, u16 value, int sleep, int in_pm);
 
diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 72ffc89b477ad..7fd763917ae2c 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -414,28 +414,6 @@ int asix_write_medium_mode(struct usbnet *dev, u16 mode, int in_pm)
 	return ret;
 }
 
-/* set MAC link settings according to information from phylib */
-void asix_adjust_link(struct net_device *netdev)
-{
-	struct phy_device *phydev = netdev->phydev;
-	struct usbnet *dev = netdev_priv(netdev);
-	u16 mode = 0;
-
-	if (phydev->link) {
-		mode = AX88772_MEDIUM_DEFAULT;
-
-		if (phydev->duplex == DUPLEX_HALF)
-			mode &= ~AX_MEDIUM_FD;
-
-		if (phydev->speed != SPEED_100)
-			mode &= ~AX_MEDIUM_PS;
-	}
-
-	asix_write_medium_mode(dev, mode, 0);
-	phy_print_status(phydev);
-	usbnet_link_change(dev, phydev->link, 0);
-}
-
 int asix_write_gpio(struct usbnet *dev, u16 value, int sleep, int in_pm)
 {
 	int ret;
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index da24941a6e444..9b0318fb50b55 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -752,7 +752,6 @@ static void ax88772_mac_link_down(struct phylink_config *config,
 	struct usbnet *dev = netdev_priv(to_net_dev(config->dev));
 
 	asix_write_medium_mode(dev, 0, 0);
-	usbnet_link_change(dev, false, false);
 }
 
 static void ax88772_mac_link_up(struct phylink_config *config,
@@ -783,7 +782,6 @@ static void ax88772_mac_link_up(struct phylink_config *config,
 		m |= AX_MEDIUM_RFC;
 
 	asix_write_medium_mode(dev, m, 0);
-	usbnet_link_change(dev, true, false);
 }
 
 static const struct phylink_mac_ops ax88772_phylink_mac_ops = {
@@ -1350,10 +1348,9 @@ static const struct driver_info ax88772_info = {
 	.description = "ASIX AX88772 USB 2.0 Ethernet",
 	.bind = ax88772_bind,
 	.unbind = ax88772_unbind,
-	.status = asix_status,
 	.reset = ax88772_reset,
 	.stop = ax88772_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR | FLAG_MULTI_PACKET,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_MULTI_PACKET,
 	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 };
@@ -1362,11 +1359,9 @@ static const struct driver_info ax88772b_info = {
 	.description = "ASIX AX88772B USB 2.0 Ethernet",
 	.bind = ax88772_bind,
 	.unbind = ax88772_unbind,
-	.status = asix_status,
 	.reset = ax88772_reset,
 	.stop = ax88772_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
-	         FLAG_MULTI_PACKET,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_MULTI_PACKET,
 	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 	.data = FLAG_EEPROM_MAC,
@@ -1376,11 +1371,9 @@ static const struct driver_info lxausb_t1l_info = {
 	.description = "Linux Automation GmbH USB 10Base-T1L",
 	.bind = ax88772_bind,
 	.unbind = ax88772_unbind,
-	.status = asix_status,
 	.reset = ax88772_reset,
 	.stop = ax88772_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
-		 FLAG_MULTI_PACKET,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_MULTI_PACKET,
 	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 	.data = FLAG_EEPROM_MAC,
@@ -1412,10 +1405,8 @@ static const struct driver_info hg20f9_info = {
 	.description = "HG20F9 USB 2.0 Ethernet",
 	.bind = ax88772_bind,
 	.unbind = ax88772_unbind,
-	.status = asix_status,
 	.reset = ax88772_reset,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
-	         FLAG_MULTI_PACKET,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_MULTI_PACKET,
 	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 	.data = FLAG_EEPROM_MAC,
-- 
2.39.5

