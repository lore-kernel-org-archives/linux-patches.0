Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A7026D4C1;
	Tue, 11 Nov 2025 01:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824208; cv=none; b=JpKQcw/tRme/bJ2Hti4betTiRyTEX+RynrAD6Luq9n1zYZ4CnZ8lO9FDTZDncpm+TYaQjIO62fqnH6wIjh4qVd0CfwGSg/me7JVuuwmQg54zcfTfhQzGyFmP8JaOadubKxCToz1W2SHOLhZeSnjcKru16gztIZmaG5UwsSqtmTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824208; c=relaxed/simple;
	bh=elFJri/nCeLqO0D8bV9P/sdDKlpVzMMaKgyCyoSUwjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxIGiTlyLJwr+a+1SCHQbNMZaw1mkhjFxoSnh9vODH6tyD2xqz2BLCE7ZKSfKBPwVnQV/4GfM4g4cyESjonnvLzM7Hg5jiwhZX28wvwGdpAy6h3yFP8ITHIdxh/LSpBirkEIKSK4PwXfoaQ3RG5CVUcDTS6d/a/sgHi2J0sYphc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlzvkRXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlzvkRXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC88C4CEF5;
	Tue, 11 Nov 2025 01:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824207;
	bh=elFJri/nCeLqO0D8bV9P/sdDKlpVzMMaKgyCyoSUwjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlzvkRXVkf30nF6L7nDIEN4xLQnRwEQcujUsFLv9YS1g20vqj4uAVB0OJ7hfC+c3R
	 fTO5dTUU0i4fG+/7C3OdB21kNiOjKB6PoCKJNyOJRsTYe+4Rm5LyB4MfsyrjNyZpLI
	 76zVQwo4ZMZ3B2v574dsttQhbTYnwWDXPJ9Tg0yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 462/849] net: dsa: felix: support phy-mode = "10g-qxgmii"
Date: Tue, 11 Nov 2025 09:40:32 +0900
Message-ID: <20251111004547.596854857@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 6f616757dd306fce4b55131df23737732e347d8f ]

The "usxgmii" phy-mode that the Felix switch ports support on LS1028A is
not quite USXGMII, it is defined by the USXGMII multiport specification
document as 10G-QXGMII. It uses the same signaling as USXGMII, but it
multiplexes 4 ports over the link, resulting in a maximum speed of 2.5G
per port.

This change is needed in preparation for the lynx-10g SerDes driver on
LS1028A, which will make a more clear distinction between usxgmii
(supported on lane 0) and 10g-qxgmii (supported on lane 1). These
protocols have their configuration in different PCCR registers (PCCRB vs
PCCR9).

Continue parsing and supporting single-port-per-lane USXGMII when found
in the device tree as usual (because it works), but add support for
10G-QXGMII too. Using phy-mode = "10g-qxgmii" will be required when
modifying the device trees to specify a "phys" phandle to the SerDes
lane. The result when the "phys" phandle is present but the phy-mode is
wrong is undefined.

The only PHY driver in known use with this phy-mode, AQR412C, will gain
logic to transition from "usxgmii" to "10g-qxgmii" in a future change.
Prepare the driver by also setting PHY_INTERFACE_MODE_10G_QXGMII in
supported_interfaces when PHY_INTERFACE_MODE_USXGMII is there, to
prevent breakage with existing device trees.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250903130730.2836022-3-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix.c         | 4 ++++
 drivers/net/dsa/ocelot/felix.h         | 3 ++-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 3 ++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 2dd4e56e1cf11..20ab558fde247 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1153,6 +1153,9 @@ static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
 
 	__set_bit(ocelot->ports[port]->phy_mode,
 		  config->supported_interfaces);
+	if (ocelot->ports[port]->phy_mode == PHY_INTERFACE_MODE_USXGMII)
+		__set_bit(PHY_INTERFACE_MODE_10G_QXGMII,
+			  config->supported_interfaces);
 }
 
 static void felix_phylink_mac_config(struct phylink_config *config,
@@ -1359,6 +1362,7 @@ static const u32 felix_phy_match_table[PHY_INTERFACE_MODE_MAX] = {
 	[PHY_INTERFACE_MODE_SGMII] = OCELOT_PORT_MODE_SGMII,
 	[PHY_INTERFACE_MODE_QSGMII] = OCELOT_PORT_MODE_QSGMII,
 	[PHY_INTERFACE_MODE_USXGMII] = OCELOT_PORT_MODE_USXGMII,
+	[PHY_INTERFACE_MODE_10G_QXGMII] = OCELOT_PORT_MODE_10G_QXGMII,
 	[PHY_INTERFACE_MODE_1000BASEX] = OCELOT_PORT_MODE_1000BASEX,
 	[PHY_INTERFACE_MODE_2500BASEX] = OCELOT_PORT_MODE_2500BASEX,
 };
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 211991f494e35..a657b190c5d7b 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -12,8 +12,9 @@
 #define OCELOT_PORT_MODE_SGMII		BIT(1)
 #define OCELOT_PORT_MODE_QSGMII		BIT(2)
 #define OCELOT_PORT_MODE_2500BASEX	BIT(3)
-#define OCELOT_PORT_MODE_USXGMII	BIT(4)
+#define OCELOT_PORT_MODE_USXGMII	BIT(4) /* compatibility */
 #define OCELOT_PORT_MODE_1000BASEX	BIT(5)
+#define OCELOT_PORT_MODE_10G_QXGMII	BIT(6)
 
 struct device_node;
 
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 7b35d24c38d76..8cf4c89865876 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -34,7 +34,8 @@
 					 OCELOT_PORT_MODE_QSGMII | \
 					 OCELOT_PORT_MODE_1000BASEX | \
 					 OCELOT_PORT_MODE_2500BASEX | \
-					 OCELOT_PORT_MODE_USXGMII)
+					 OCELOT_PORT_MODE_USXGMII | \
+					 OCELOT_PORT_MODE_10G_QXGMII)
 
 static const u32 vsc9959_port_modes[VSC9959_NUM_PORTS] = {
 	VSC9959_PORT_MODE_SERDES,
-- 
2.51.0



