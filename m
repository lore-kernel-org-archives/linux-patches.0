Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AEA24A047;
	Thu, 28 May 2026 20:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999423; cv=none; b=uP5PH909tDr1TbZ9f7/OxAjhwbVq1SXXy1msLmX5LjLzrGrKR9i4KvifZJJkaWiMmP8PFwdHwf4scIti7mh2Exa7/GYgXed34Y9jD5S4HslG/M3gNalqFGRQEc51PPx8e6Vnaf5oqVUnNh0a4k8zVp7I/tA77bcH5h8XjHGltDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999423; c=relaxed/simple;
	bh=Z/UyXgz5SSWC2JYzzvKXMdIdvk3Lk6Q2ZPziCzRMDF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U9RpDMGNRaPcQYH6aGXG8DEHV+7jjwZayt7vuUS8spHyl9oQ5rnLraEoOKY8dCPkR3YsHHPbARcOGr/gzevXif7Avo83UEuGUyZja8HaGq24O5ENnE86Oe2/6AOtKlP74/AW22PnHCwU8CuV48utIeax2qIBD/PMuxg2nhcOvsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gq5aLI8C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gq5aLI8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C511F000E9;
	Thu, 28 May 2026 20:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999422;
	bh=aQp7SWF83+zbHCvRlyWctsIDrRLi54LvGTX5hEdo8Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gq5aLI8Ct/7RNEq/hrQUXlKkWarDz7973TDzCcc5ttqgicQyTyefS9ghzl/OR/F2z
	 F/TtrEP8W5BvkZyQhDyc0K8zhpuyvthwUri+XCcEV4XlkYZy9vCFlRZQgW8dqFDiNN
	 laG7/53L2grxe7YxHSLnJJhTNMB2QM6iIzvVYjsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 061/377] net: phy: skip EEE advertisement write when autoneg is disabled
Date: Thu, 28 May 2026 21:44:59 +0200
Message-ID: <20260528194640.135265933@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>

commit 960e77ce14a83ef7f226e8e4b4d75765633ba48b upstream.

genphy_c45_an_config_eee_aneg() writes the EEE advertisement to the
auto-negotiation device's MMD register space (MDIO_MMD_AN, register
MDIO_AN_EEE_ADV).  These registers are read by the link partner only
during auto-negotiation, so writing them while autoneg is disabled
cannot influence the link.  On some PHYs (e.g. Broadcom BCM54213PE)
the write nevertheless reaches the chip and disturbs the receive
datapath.

Concretely, running

    ethtool -s eth0 speed 100 duplex full autoneg off
    ethtool --set-eee eth0 eee off

leaves eth0 with TX working and RX completely silent on a
Raspberry Pi 4 / CM4 board (bcmgenet + BCM54213PE in rgmii-rxid).
Switching back to autoneg recovers the link.

Prior to commit f26a29a038ee ("net: phy: ensure that genphy_c45_an_config_eee_aneg() sees new value of phydev->eee_cfg.eee_enabled"),
the disable path was effectively a no-op because the helper read
the stale eee_cfg.eee_enabled, so the underlying PHY behavior never
surfaced.

Bisected on rpi-6.12.y between commits 83943264 (good) and
effcbc88 (bad) to f26a29a038ee.

Fixes: f26a29a038ee ("net: phy: ensure that genphy_c45_an_config_eee_aneg() sees new value of phydev->eee_cfg.eee_enabled")
Cc: stable@vger.kernel.org
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Tested-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260516150251.879680-1-nerijus.bendziunas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy-c45.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -939,6 +939,14 @@ EXPORT_SYMBOL_GPL(genphy_c45_read_eee_ab
  */
 int genphy_c45_an_config_eee_aneg(struct phy_device *phydev)
 {
+	/* Writing MMD AN advertisements while autoneg is disabled has no
+	 * effect on link-partner negotiation, but on some PHYs (e.g. the
+	 * Broadcom BCM54213PE) the write itself disturbs the receive
+	 * datapath. Skip it.
+	 */
+	if (phydev->autoneg == AUTONEG_DISABLE)
+		return 0;
+
 	if (!phydev->eee_cfg.eee_enabled) {
 		__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
 


