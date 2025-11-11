Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99EF285CA2;
	Tue, 11 Nov 2025 01:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825359; cv=none; b=mjJRKaNQFRqAflLHjpFOiJWz6r4+5xMLeJCsaTlpF6aW3vbdOhQY/B1q7ZIdYy+5bgQS+ZVn3suvG97ith1IyEiA9xhM/CqSCZyC48cBPGgglly5ka79oht8+uSD/3vRBIalW3d07HiDEVirJ6q1d6RlTM0KuxtBB1BuHWqAC3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825359; c=relaxed/simple;
	bh=uaw0mgOKE75sE1xnlavJ4nMoAbrxmEGGlW9QjxQaliU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppLJhONac8WtfHd5mGbj/0dQoZJjR/NhnS1cePsdzJvvwU+LfF9iEGVU9uUctwAgnGG5KJKEHMOFVE/3mE8q1q48x0i6gzcKAJPbxIy6dRoXuJbHmqAKJ6wvplVfmhxMoCM1ILGux3BQDJjsxML0iQhTzWir5bGjgetHsi0It6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1v5zXGiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1v5zXGiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8F3C116B1;
	Tue, 11 Nov 2025 01:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825359;
	bh=uaw0mgOKE75sE1xnlavJ4nMoAbrxmEGGlW9QjxQaliU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1v5zXGiV6yQyH83O7xChw+gGgc1Is2a+DmRMlx1MmocxXOc8j2JJiLQOVvVG5Ayt3
	 o7y2UHX2WdEBRTJtAkBW8D7wrlTSXn8ULC0/pn0nAe7NHR57DG8Hy/Ofqge2l6KzL9
	 4/HOwT6qucnRw4T92N3Yfx8/t8U+DNUIsLEjXnmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 770/849] net: dsa: b53: fix bcm63xx RGMII port link adjustment
Date: Tue, 11 Nov 2025 09:45:40 +0900
Message-ID: <20251111004555.045514856@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 3e4ebdc1606adf77744cf8ed7a433d279fdc57ba ]

BCM63XX's switch does not support MDIO scanning of external phys, so its
MACs needs to be manually configured for autonegotiated link speeds.

So b53_force_port_config() and b53_force_link() accordingly also when
mode is MLO_AN_PHY for those ports.

Fixes lower speeds than 1000/full on rgmii ports 4 - 7.

This aligns the behaviour with the old bcm63xx_enetsw driver for those
ports.

Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251101132807.50419-3-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index cb28256ef3cc3..bb2c6dfa7835d 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1602,8 +1602,11 @@ static void b53_phylink_mac_link_down(struct phylink_config *config,
 	struct b53_device *dev = dp->ds->priv;
 	int port = dp->index;
 
-	if (mode == MLO_AN_PHY)
+	if (mode == MLO_AN_PHY) {
+		if (is63xx(dev) && in_range(port, B53_63XX_RGMII0, 4))
+			b53_force_link(dev, port, false);
 		return;
+	}
 
 	if (mode == MLO_AN_FIXED) {
 		b53_force_link(dev, port, false);
@@ -1631,6 +1634,13 @@ static void b53_phylink_mac_link_up(struct phylink_config *config,
 	if (mode == MLO_AN_PHY) {
 		/* Re-negotiate EEE if it was enabled already */
 		p->eee_enabled = b53_eee_init(ds, port, phydev);
+
+		if (is63xx(dev) && in_range(port, B53_63XX_RGMII0, 4)) {
+			b53_force_port_config(dev, port, speed, duplex,
+					      tx_pause, rx_pause);
+			b53_force_link(dev, port, true);
+		}
+
 		return;
 	}
 
-- 
2.51.0



