Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230602DE707;
	Tue, 11 Nov 2025 01:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823738; cv=none; b=AvrFAHETBJsFg/a//sxx12g7lKFv7stz9csrkXG2zkKHWLGnXS53i1xxxftkd9lXBMs//hVZsL390ZzFrsMtMuXHW1uM3zsl6PU3Sa79hV0UHPVPkTYEylWLasiNG56VahNXVWe2wcXBkK1Vd6yo2RGw0UO4lhHs2tCr38QL+yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823738; c=relaxed/simple;
	bh=uX2VLKUki6ssgHJTc1gdkCy9h5zH8xiRWKFGS4n84gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFpQFzXHTvI9MgU6dDJtr3WEilaAVplaSZyMHeGXhIhNFVRs/6+6Vi9GjPQUi+Zlf6To1Qj4LRV1YF/ubhBac7l1i73kHwgCujHr+F1qZB49esglqleCJnPreWUeiyxN9Is7jCHeRvuthER3SU7hJppEio7mUWxs9zrpKWU+5cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKJI0cYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKJI0cYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71316C113D0;
	Tue, 11 Nov 2025 01:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823737;
	bh=uX2VLKUki6ssgHJTc1gdkCy9h5zH8xiRWKFGS4n84gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKJI0cYseWfaZTRGJrivS2jza9VOIWOK6F6cei83gKUyLIYj2mM5RWA2XkZ+G0nyR
	 vonuQBhPRpNbV+ed16z5DksgwNMMvI7Pk0rO1L4TalyP4WXkt9NPrCnZEcKElFRAxM
	 WORTu8KB/7ij8pQk3D/26z29kURP1mqrMEv/BOSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 310/565] net: dsa: felix: support phy-mode = "10g-qxgmii"
Date: Tue, 11 Nov 2025 09:42:46 +0900
Message-ID: <20251111004533.858873467@linuxfoundation.org>
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
index 3aa9c997018a5..72fb6594331e9 100644
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
@@ -1351,6 +1354,7 @@ static const u32 felix_phy_match_table[PHY_INTERFACE_MODE_MAX] = {
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



