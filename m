Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26A66FAF;
	Tue,  5 Dec 2023 03:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RafQw1KR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E1EC433C8;
	Tue,  5 Dec 2023 03:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746662;
	bh=AnIDFACfSZ52881f4LcLv0oUGb2W3JJyZAt1EYFgBog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RafQw1KRXPB+CWaey4WKBiuG3kTdVAqMHt9dQ99681c1uLEy7EFa5CeZrY47RtAA+
	 VrXerZVc4gCj44I5yJRcj4m2FqmWsmYSBvnnJm1zPluxIkBZ5Bv/ng+Wol7vJLA7wW
	 DLmQLzMWl4yFSWhzJYCELEAh5oBW116F0dXM/Plc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Ungerer <gerg@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/134] net: dsa: mv88e6xxx: fix marvell 6350 switch probing
Date: Tue,  5 Dec 2023 12:15:57 +0900
Message-ID: <20231205031540.864496338@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Ungerer <gerg@kernel.org>

[ Upstream commit b3f1a164c7f742503dc7159011f7ad6b092b660e ]

As of commit de5c9bf40c45 ("net: phylink: require supported_interfaces to
be filled") Marvell 88e6350 switches fail to be probed:

    ...
    mv88e6085 d0072004.mdio-mii:11: switch 0x3710 detected: Marvell 88E6350, revision 2
    mv88e6085 d0072004.mdio-mii:11: phylink: error: empty supported_interfaces
    error creating PHYLINK: -22
    mv88e6085: probe of d0072004.mdio-mii:11 failed with error -22
    ...

The problem stems from the use of mv88e6185_phylink_get_caps() to get
the device capabilities. Create a new dedicated phylink_get_caps for the
6351 family (which the 6350 is one of) to properly support their set of
capabilities.

According to chip.h the 6351 switch family includes the 6171, 6175, 6350
and 6351 switches, so update each of these to use the correct
phylink_get_caps.

Fixes: de5c9bf40c45 ("net: phylink: require supported_interfaces to be filled")
Signed-off-by: Greg Ungerer <gerg@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ab434a77b059a..6d7256ea477a1 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -577,6 +577,18 @@ static void mv88e6250_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100;
 }
 
+static void mv88e6351_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
+				       struct phylink_config *config)
+{
+	unsigned long *supported = config->supported_interfaces;
+
+	/* Translate the default cmode */
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
+				   MAC_1000FD;
+}
+
 static int mv88e6352_get_port4_serdes_cmode(struct mv88e6xxx_chip *chip)
 {
 	u16 reg, val;
@@ -4340,7 +4352,7 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
 	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
-	.phylink_get_caps = mv88e6185_phylink_get_caps,
+	.phylink_get_caps = mv88e6351_phylink_get_caps,
 };
 
 static const struct mv88e6xxx_ops mv88e6172_ops = {
@@ -4440,7 +4452,7 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
 	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
-	.phylink_get_caps = mv88e6185_phylink_get_caps,
+	.phylink_get_caps = mv88e6351_phylink_get_caps,
 };
 
 static const struct mv88e6xxx_ops mv88e6176_ops = {
@@ -5069,7 +5081,7 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
 	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
-	.phylink_get_caps = mv88e6185_phylink_get_caps,
+	.phylink_get_caps = mv88e6351_phylink_get_caps,
 };
 
 static const struct mv88e6xxx_ops mv88e6351_ops = {
@@ -5117,7 +5129,7 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
-	.phylink_get_caps = mv88e6185_phylink_get_caps,
+	.phylink_get_caps = mv88e6351_phylink_get_caps,
 };
 
 static const struct mv88e6xxx_ops mv88e6352_ops = {
-- 
2.42.0



