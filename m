Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CA3FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAFFC433D2;
	Mon, 15 May 2023 16:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169630;
	bh=ypc6FpyCLBdab/YHAQMeI8P8UhUrjE11EkqkidVDsGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p34jS7aLw9JYMsRsVoOi6lHLILs5Of12kAZOTNwJo+Kty8VOIs8oGVyq5tFRl6Gsn
	 OVKNgepfzDRdei6WZxoIcAqalyNxZbD1obsJ8MLUKW/h5U3QOwqqqeApA+aEFEcsJn
	 B2slQpeCWU/0/64B0D2zI97eQYe1/A5Uz4pZcU2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 090/246] net: dsa: mt7530: split-off common parts from mt7531_setup
Date: Mon, 15 May 2023 18:25:02 +0200
Message-Id: <20230515161725.280638036@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 7f54cc9772ced2d76ac11832f0ada43798443ac9 ]

MT7988 shares a significant part of the setup function with MT7531.
Split-off those parts into a shared function which is going to be used
also by mt7988_setup.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 120a56b01bee ("net: dsa: mt7530: fix network connectivity with multiple CPU ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 99 ++++++++++++++++++++++------------------
 1 file changed, 55 insertions(+), 44 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 4d5c5820e4618..8cbde093fbd9e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2307,12 +2307,65 @@ mt7530_setup(struct dsa_switch *ds)
 	return 0;
 }
 
+static int
+mt7531_setup_common(struct dsa_switch *ds)
+{
+	struct mt7530_priv *priv = ds->priv;
+	struct dsa_port *cpu_dp;
+	int ret, i;
+
+	/* BPDU to CPU port */
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
+		mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
+			   BIT(cpu_dp->index));
+		break;
+	}
+	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
+		   MT753X_BPDU_CPU_ONLY);
+
+	/* Enable and reset MIB counters */
+	mt7530_mib_reset(ds);
+
+	for (i = 0; i < MT7530_NUM_PORTS; i++) {
+		/* Disable forwarding by default on all ports */
+		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
+			   PCR_MATRIX_CLR);
+
+		/* Disable learning by default on all ports */
+		mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
+
+		mt7530_set(priv, MT7531_DBG_CNT(i), MT7531_DIS_CLR);
+
+		if (dsa_is_cpu_port(ds, i)) {
+			ret = mt753x_cpu_port_enable(ds, i);
+			if (ret)
+				return ret;
+		} else {
+			mt7530_port_disable(ds, i);
+
+			/* Set default PVID to 0 on all user ports */
+			mt7530_rmw(priv, MT7530_PPBV1_P(i), G0_PORT_VID_MASK,
+				   G0_PORT_VID_DEF);
+		}
+
+		/* Enable consistent egress tag */
+		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
+			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
+	}
+
+	/* Flush the FDB table */
+	ret = mt7530_fdb_cmd(priv, MT7530_FDB_FLUSH, NULL);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static int
 mt7531_setup(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
 	struct mt7530_dummy_poll p;
-	struct dsa_port *cpu_dp;
 	u32 val, id;
 	int ret, i;
 
@@ -2390,44 +2443,7 @@ mt7531_setup(struct dsa_switch *ds)
 	mt7531_ind_c45_phy_write(priv, MT753X_CTRL_PHY_ADDR, MDIO_MMD_VEND2,
 				 CORE_PLL_GROUP4, val);
 
-	/* BPDU to CPU port */
-	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
-		mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
-			   BIT(cpu_dp->index));
-		break;
-	}
-	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
-		   MT753X_BPDU_CPU_ONLY);
-
-	/* Enable and reset MIB counters */
-	mt7530_mib_reset(ds);
-
-	for (i = 0; i < MT7530_NUM_PORTS; i++) {
-		/* Disable forwarding by default on all ports */
-		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
-			   PCR_MATRIX_CLR);
-
-		/* Disable learning by default on all ports */
-		mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
-
-		mt7530_set(priv, MT7531_DBG_CNT(i), MT7531_DIS_CLR);
-
-		if (dsa_is_cpu_port(ds, i)) {
-			ret = mt753x_cpu_port_enable(ds, i);
-			if (ret)
-				return ret;
-		} else {
-			mt7530_port_disable(ds, i);
-
-			/* Set default PVID to 0 on all user ports */
-			mt7530_rmw(priv, MT7530_PPBV1_P(i), G0_PORT_VID_MASK,
-				   G0_PORT_VID_DEF);
-		}
-
-		/* Enable consistent egress tag */
-		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
-			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
-	}
+	mt7531_setup_common(ds);
 
 	/* Setup VLAN ID 0 for VLAN-unaware bridges */
 	ret = mt7530_setup_vlan0(priv);
@@ -2437,11 +2453,6 @@ mt7531_setup(struct dsa_switch *ds)
 	ds->assisted_learning_on_cpu_port = true;
 	ds->mtu_enforcement_ingress = true;
 
-	/* Flush the FDB table */
-	ret = mt7530_fdb_cmd(priv, MT7530_FDB_FLUSH, NULL);
-	if (ret < 0)
-		return ret;
-
 	return 0;
 }
 
-- 
2.39.2



