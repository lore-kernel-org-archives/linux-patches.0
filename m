Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4228C14A4D1;
	Fri,  6 Dec 2024 14:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496031; cv=none; b=S2EDme7f7KYE1tbjgerkphwP4MUPrPK2DwUUQHHLI43cmXPgSsWmny0er/3T7FnGZtFGCNk8qK48zxAL50+dn56tZd1Zx3/fsD/uq6o8mgUIoOui0Cq29arKAc8yp5UbRMFVF7jiLEC/H/gsv6/pEdeVQYOmX44a4wptXicaHkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496031; c=relaxed/simple;
	bh=znyrGRo4q9SpWKnjuSSTZLUxS17dgb2FmihrwVcwjvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEdGUUBXmdVYFLH5scd79qCidIqPwoo3vvflh8XS4hHF1lATxYOi3G0y7jWfA2EUl7CnfUvEPF9nsdc0W4tEaUY6iIOo9Miec6nwM6uB1tUSpLN1m4SH3EIx0y9H/k4yO5/iDAOMOm61H8U5Mp0azHVkLwirYb9BPJxd2VPlN8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlvLnu6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlvLnu6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A524BC4CEDE;
	Fri,  6 Dec 2024 14:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496031;
	bh=znyrGRo4q9SpWKnjuSSTZLUxS17dgb2FmihrwVcwjvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wlvLnu6xTvrIRGR/Q9nuBbQtkXprkNlyTV8/BNbmCeT9pOJJQhiut9U3Qjlf4J5yR
	 4hJz6FnwY7HgM4CpclpmlwIb0wC7AD7cXoJnpAxPoyK0WQQxmmvqJBqDalP5R+NdQA
	 rMdRCCKNnTWFQWWxploxtHHsVknLjbdk5RQKrVH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Romain Gantois <romain.gantois@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 032/146] net: phy: dp83869: fix status reporting for 1000base-x autonegotiation
Date: Fri,  6 Dec 2024 15:36:03 +0100
Message-ID: <20241206143528.901865789@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Romain Gantois <romain.gantois@bootlin.com>

commit 378e8feea9a70d37a5dc1678b7ec27df21099fa5 upstream.

The DP83869 PHY transceiver supports converting from RGMII to 1000base-x.
In this operation mode, autonegotiation can be performed, as described in
IEEE802.3.

The DP83869 has a set of fiber-specific registers located at offset 0xc00.
When the transceiver is configured in RGMII-to-1000base-x mode, these
registers are mapped onto offset 0, which should make reading the
autonegotiation status transparent.

However, the fiber registers at offset 0xc04 and 0xc05 follow the bit
layout specified in Clause 37, and genphy_read_status() assumes a Clause 22
layout. Thus, genphy_read_status() doesn't properly read the capabilities
advertised by the link partner, resulting in incorrect link parameters.

Similarly, genphy_config_aneg() doesn't properly write advertised
capabilities.

Fix the 1000base-x autonegotiation procedure by replacing
genphy_read_status() and genphy_config_aneg() with their Clause 37
equivalents.

Fixes: a29de52ba2a1 ("net: dp83869: Add ability to advertise Fiber connection")
Cc: stable@vger.kernel.org
Signed-off-by: Romain Gantois <romain.gantois@bootlin.com>
Link: https://patch.msgid.link/20241112-dp83869-1000base-x-v3-1-36005f4ab0d9@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83869.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -153,19 +153,32 @@ struct dp83869_private {
 	int mode;
 };
 
+static int dp83869_config_aneg(struct phy_device *phydev)
+{
+	struct dp83869_private *dp83869 = phydev->priv;
+
+	if (dp83869->mode != DP83869_RGMII_1000_BASE)
+		return genphy_config_aneg(phydev);
+
+	return genphy_c37_config_aneg(phydev);
+}
+
 static int dp83869_read_status(struct phy_device *phydev)
 {
 	struct dp83869_private *dp83869 = phydev->priv;
+	bool changed;
 	int ret;
 
+	if (dp83869->mode == DP83869_RGMII_1000_BASE)
+		return genphy_c37_read_status(phydev, &changed);
+
 	ret = genphy_read_status(phydev);
 	if (ret)
 		return ret;
 
-	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, phydev->supported)) {
+	if (dp83869->mode == DP83869_RGMII_100_BASE) {
 		if (phydev->link) {
-			if (dp83869->mode == DP83869_RGMII_100_BASE)
-				phydev->speed = SPEED_100;
+			phydev->speed = SPEED_100;
 		} else {
 			phydev->speed = SPEED_UNKNOWN;
 			phydev->duplex = DUPLEX_UNKNOWN;
@@ -898,6 +911,7 @@ static int dp83869_phy_reset(struct phy_
 	.soft_reset	= dp83869_phy_reset,			\
 	.config_intr	= dp83869_config_intr,			\
 	.handle_interrupt = dp83869_handle_interrupt,		\
+	.config_aneg    = dp83869_config_aneg,                  \
 	.read_status	= dp83869_read_status,			\
 	.get_tunable	= dp83869_get_tunable,			\
 	.set_tunable	= dp83869_set_tunable,			\


