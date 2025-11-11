Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C869262FEC;
	Tue, 11 Nov 2025 01:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824802; cv=none; b=DPQOvL57nQKKtGuK4pNXRy9zTVg3WRVPGorclxcemWCuu11LqA4DJN5xDB2p0BHaXjAqiZQZ7soizwd64ATgsP0/sR0d1OIx4RK8KAWjHhVn2hKNbmCSM2SCOYEAOE76uxRcZKhQ+M7smHMOagyajvrmpZwcVjs9PaVWCdNQZhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824802; c=relaxed/simple;
	bh=zCvNQPROKUt2MAtghrQK9QKb7by1FShYDvI46P5wvyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StuwX1FnjzZmEMKNGZRFRgWSotgiYBGT6SIgJD6uHgN8VjhEOM5paQIq+4nanG60LQTXm9qfgjBnVDe+yVqmWlH6o39SFSQZs+otOx1kwcu6a/zJ+IQfyc2ZNrmbb0Dhd8RVZV1d/bios2PP75lhS1Tv4fOjzaHblNyl3bVesT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKMnIc9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKMnIc9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B03C4CEF5;
	Tue, 11 Nov 2025 01:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824802;
	bh=zCvNQPROKUt2MAtghrQK9QKb7by1FShYDvI46P5wvyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKMnIc9DHgz/Jl0fUNAZctaan6CCG/aaQA2XVzgYVvItf071ox0Tw0jPCFycFyA1x
	 UROuoCzmRC/JW54YeTBQQstU+K43ZOqE47LcFYcM+iMozFedVzTjIZD2YbfGs/ZI2E
	 w0G+46NtxNagWAeIa/wLLtpfGX0jKkj+g0Qsbzi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 520/565] net: dsa: b53: fix bcm63xx RGMII port link adjustment
Date: Tue, 11 Nov 2025 09:46:16 +0900
Message-ID: <20251111004538.661332820@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 318c5c2c8f74a..914dbb86e1b07 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1554,8 +1554,11 @@ static void b53_phylink_mac_link_down(struct phylink_config *config,
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
@@ -1583,6 +1586,13 @@ static void b53_phylink_mac_link_up(struct phylink_config *config,
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



