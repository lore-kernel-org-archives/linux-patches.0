Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32CC54706B;
	Thu, 17 Sep 2026 18:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670741; cv=none; b=Y8hHUGdjKwJB+C5lAsavzXAJbBcA5HEFgLeyAnacpL232Qx6RZuew8Dxsz/701z/6vcIjT35c8dRdDPoIA2/mSKAaOJMDW48J+iaPWR3IqbcAPOjJlb9MyEFoKl2DdNrIeTA+3JmKFrUGkCvUcfyBdagLn+szYH91B+rSiOMzp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670741; c=relaxed/simple;
	bh=DCZfazi83GVQCkpYBgDZIj2cBDjcK2YCWklRib/dtGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaeu0QR8KwNLTMzNHimhMfsvISCvSJDoNid8V1vk00Cm8j1c1BEL6jhd9H1Z8kgRh+C2+T2k49++xqHMV/nUAY+IGoGbx7PK62YPr3i3Wo5EjVQGK708unXQ/8ZUaR0AfdqlO17fXBlO4NzhnA9RRcDMDeELIdXTpLZL6vmrh7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpy5R1ee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpy5R1ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284D41F000FF;
	Thu, 17 Sep 2026 18:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670739;
	bh=APwCFebqKlfa+kNWj+YtFucSfBjVZXb0/kfFkJY1HAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpy5R1eeLlUJUiOSh9hPKqDaxucql/XJ3HEA1om0UnxWVl7wWqyuXGZEAIHssQcs3
	 poLzwEaz2UMfI08qiEcJOkY3+FdmCPZ+hqYgIPC48QwrdD3cZVAcXg4P3Kc0ZpaKSI
	 oJdgirv6CSiRbJOzs0SR/BR1U/Ihid4BOc9S7p4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0754/1102] net: dsa: lantiq_gswip: deduplicate dsa_switch_ops
Date: Thu, 17 Sep 2026 16:11:37 +0100
Message-ID: <20260917151559.354447768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit fa1439a865830ec3b599114e7cc907f5ad126b07 ]

The two instances of struct dsa_switch_ops differ only by their
.phylink_get_caps op. Instead of having two instances of dsa_switch_ops,
rather just have a pointer to the phylink_get_caps function in
struct gswip_hw_info.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/03d72eceeb3faecdbe03ce58aab40861cf6b77c1.1755878232.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 59fb389ad6bf ("net: dsa: lantiq_gswip: fix GSWIP_MDIO_PHY_FCONTX_EN value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.c | 44 ++++++++++++----------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index b1f18a840da77..2c2b943ad13e1 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -254,7 +254,8 @@
 struct gswip_hw_info {
 	int max_ports;
 	int cpu_port;
-	const struct dsa_switch_ops *ops;
+	void (*phylink_get_caps)(struct dsa_switch *ds, int port,
+				 struct phylink_config *config);
 };
 
 struct xway_gphy_match_data {
@@ -1564,6 +1565,14 @@ static void gswip_xrx300_phylink_get_caps(struct dsa_switch *ds, int port,
 		MAC_10 | MAC_100 | MAC_1000;
 }
 
+static void gswip_phylink_get_caps(struct dsa_switch *ds, int port,
+				   struct phylink_config *config)
+{
+	struct gswip_priv *priv = ds->priv;
+
+	priv->hw_info->phylink_get_caps(ds, port, config);
+}
+
 static void gswip_port_set_link(struct gswip_priv *priv, int port, bool link)
 {
 	u32 mdio_phy;
@@ -1836,7 +1845,7 @@ static const struct phylink_mac_ops gswip_phylink_mac_ops = {
 	.mac_link_up	= gswip_phylink_mac_link_up,
 };
 
-static const struct dsa_switch_ops gswip_xrx200_switch_ops = {
+static const struct dsa_switch_ops gswip_switch_ops = {
 	.get_tag_protocol	= gswip_get_tag_protocol,
 	.setup			= gswip_setup,
 	.port_setup		= gswip_port_setup,
@@ -1854,30 +1863,7 @@ static const struct dsa_switch_ops gswip_xrx200_switch_ops = {
 	.port_fdb_dump		= gswip_port_fdb_dump,
 	.port_change_mtu	= gswip_port_change_mtu,
 	.port_max_mtu		= gswip_port_max_mtu,
-	.phylink_get_caps	= gswip_xrx200_phylink_get_caps,
-	.get_strings		= gswip_get_strings,
-	.get_ethtool_stats	= gswip_get_ethtool_stats,
-	.get_sset_count		= gswip_get_sset_count,
-};
-
-static const struct dsa_switch_ops gswip_xrx300_switch_ops = {
-	.get_tag_protocol	= gswip_get_tag_protocol,
-	.setup			= gswip_setup,
-	.port_enable		= gswip_port_enable,
-	.port_disable		= gswip_port_disable,
-	.port_bridge_join	= gswip_port_bridge_join,
-	.port_bridge_leave	= gswip_port_bridge_leave,
-	.port_fast_age		= gswip_port_fast_age,
-	.port_vlan_filtering	= gswip_port_vlan_filtering,
-	.port_vlan_add		= gswip_port_vlan_add,
-	.port_vlan_del		= gswip_port_vlan_del,
-	.port_stp_state_set	= gswip_port_stp_state_set,
-	.port_fdb_add		= gswip_port_fdb_add,
-	.port_fdb_del		= gswip_port_fdb_del,
-	.port_fdb_dump		= gswip_port_fdb_dump,
-	.port_change_mtu	= gswip_port_change_mtu,
-	.port_max_mtu		= gswip_port_max_mtu,
-	.phylink_get_caps	= gswip_xrx300_phylink_get_caps,
+	.phylink_get_caps	= gswip_phylink_get_caps,
 	.get_strings		= gswip_get_strings,
 	.get_ethtool_stats	= gswip_get_ethtool_stats,
 	.get_sset_count		= gswip_get_sset_count,
@@ -2140,7 +2126,7 @@ static int gswip_probe(struct platform_device *pdev)
 	priv->ds->dev = dev;
 	priv->ds->num_ports = priv->hw_info->max_ports;
 	priv->ds->priv = priv;
-	priv->ds->ops = priv->hw_info->ops;
+	priv->ds->ops = &gswip_switch_ops;
 	priv->ds->phylink_mac_ops = &gswip_phylink_mac_ops;
 	priv->dev = dev;
 	mutex_init(&priv->pce_table_lock);
@@ -2241,13 +2227,13 @@ static void gswip_shutdown(struct platform_device *pdev)
 static const struct gswip_hw_info gswip_xrx200 = {
 	.max_ports = 7,
 	.cpu_port = 6,
-	.ops = &gswip_xrx200_switch_ops,
+	.phylink_get_caps = gswip_xrx200_phylink_get_caps,
 };
 
 static const struct gswip_hw_info gswip_xrx300 = {
 	.max_ports = 7,
 	.cpu_port = 6,
-	.ops = &gswip_xrx300_switch_ops,
+	.phylink_get_caps = gswip_xrx300_phylink_get_caps,
 };
 
 static const struct of_device_id gswip_of_match[] = {
-- 
2.53.0



