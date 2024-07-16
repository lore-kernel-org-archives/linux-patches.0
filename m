Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B87527733;
	Tue, 16 Jul 2024 15:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144839; cv=none; b=g4cO1tt/Ts47sBkAihUaTQcxQi/hsnmVEeCqlbdSpmFASVEgzTsCtFyfnjXDhEQipTzYV3HtaEqKB8M+fkGgn6AQp4KaBa9w4VyLfkY0xW36VqDnNrxmJ993oFWeFx3s3hOtHYCj69GcYpMV+GtnLQ4Y3ZwstCQD+7OvfpbOagM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144839; c=relaxed/simple;
	bh=kbT08IuO/VIfNwTYUhu57c5yHdH4EMHrfL9UdYCK2sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brjTaAAOwg0vojG9O96HGQi86vmdBIAdHOQA/MHlTcbZr4wiS6TJR39pU6lWG8w/zhx6t3qg0+ucuGMk6mt94IN/O3I3oZtnzpdc5q51BDUN6ELyprJ2RUdpXX9BArOBjfOIIyX+PbyiQROUI8Px7SK1OZkEbLpmynGIqzWoJ+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyrsRPVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyrsRPVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F139DC116B1;
	Tue, 16 Jul 2024 15:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144839;
	bh=kbT08IuO/VIfNwTYUhu57c5yHdH4EMHrfL9UdYCK2sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyrsRPVX7ZlO/ZHj6kYhnh4aKMfr/XqF7i5vuMflLvdNdyIe3ZIkNf1qMJQ/NjZCk
	 E/mEvelk3k89FOQY6oIhbXv1Jp8Nl5+0ayttxE3nNtXv4ZR3RdCpXwmxPK75wKbChn
	 BzMi9J8wzccikXkE8Tb5A4bIHv9x1GHIMqb4S3cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Vladimir Oltean <olteanv@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 013/143] net: dsa: allow DSA switch drivers to provide their own phylink mac ops
Date: Tue, 16 Jul 2024 17:30:09 +0200
Message-ID: <20240716152756.498971328@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit cae425cb43feddd9fd62fc1b25567f9463da4915 ]

Rather than having a shim for each and every phylink MAC operation,
allow DSA switch drivers to provide their own ops structure. When a
DSA driver provides the phylink MAC operations, the shimmed ops must
not be provided, so fail an attempt to register a switch with both
the phylink_mac_ops in struct dsa_switch and the phylink_mac_*
operations populated in dsa_switch_ops populated.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/E1rudqF-006K9H-Cc@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0005b2dc43f9 ("dsa: lan9303: Fix mapping between DSA port number and PHY address")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dsa.h |  5 +++++
 net/dsa/dsa.c     | 11 +++++++++++
 net/dsa/port.c    | 26 ++++++++++++++++++++------
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f228b479a5fd2..7edfd8de8882f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -457,6 +457,11 @@ struct dsa_switch {
 	 */
 	const struct dsa_switch_ops	*ops;
 
+	/*
+	 * Allow a DSA switch driver to override the phylink MAC ops
+	 */
+	const struct phylink_mac_ops	*phylink_mac_ops;
+
 	/*
 	 * User mii_bus and devices for the individual ports.
 	 */
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 09d2f5d4b3dd4..2f347cd373162 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -1505,6 +1505,17 @@ static int dsa_switch_probe(struct dsa_switch *ds)
 	if (!ds->num_ports)
 		return -EINVAL;
 
+	if (ds->phylink_mac_ops) {
+		if (ds->ops->phylink_mac_select_pcs ||
+		    ds->ops->phylink_mac_prepare ||
+		    ds->ops->phylink_mac_config ||
+		    ds->ops->phylink_mac_finish ||
+		    ds->ops->phylink_mac_link_down ||
+		    ds->ops->phylink_mac_link_up ||
+		    ds->ops->adjust_link)
+			return -EINVAL;
+	}
+
 	if (np) {
 		err = dsa_switch_parse_of(ds, np);
 		if (err)
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 02bf1c306bdca..c6febc3d96d9b 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1662,6 +1662,7 @@ static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 
 int dsa_port_phylink_create(struct dsa_port *dp)
 {
+	const struct phylink_mac_ops *mac_ops;
 	struct dsa_switch *ds = dp->ds;
 	phy_interface_t mode;
 	struct phylink *pl;
@@ -1685,8 +1686,12 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 		}
 	}
 
-	pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
-			    mode, &dsa_port_phylink_mac_ops);
+	mac_ops = &dsa_port_phylink_mac_ops;
+	if (ds->phylink_mac_ops)
+		mac_ops = ds->phylink_mac_ops;
+
+	pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn), mode,
+			    mac_ops);
 	if (IS_ERR(pl)) {
 		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(pl));
 		return PTR_ERR(pl);
@@ -1952,12 +1957,23 @@ static void dsa_shared_port_validate_of(struct dsa_port *dp,
 		dn, dsa_port_is_cpu(dp) ? "CPU" : "DSA", dp->index);
 }
 
+static void dsa_shared_port_link_down(struct dsa_port *dp)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->phylink_mac_ops && ds->phylink_mac_ops->mac_link_down)
+		ds->phylink_mac_ops->mac_link_down(&dp->pl_config, MLO_AN_FIXED,
+						   PHY_INTERFACE_MODE_NA);
+	else if (ds->ops->phylink_mac_link_down)
+		ds->ops->phylink_mac_link_down(ds, dp->index, MLO_AN_FIXED,
+					       PHY_INTERFACE_MODE_NA);
+}
+
 int dsa_shared_port_link_register_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	bool missing_link_description;
 	bool missing_phy_mode;
-	int port = dp->index;
 
 	dsa_shared_port_validate_of(dp, &missing_phy_mode,
 				    &missing_link_description);
@@ -1973,9 +1989,7 @@ int dsa_shared_port_link_register_of(struct dsa_port *dp)
 				 "Skipping phylink registration for %s port %d\n",
 				 dsa_port_is_cpu(dp) ? "CPU" : "DSA", dp->index);
 		} else {
-			if (ds->ops->phylink_mac_link_down)
-				ds->ops->phylink_mac_link_down(ds, port,
-					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
+			dsa_shared_port_link_down(dp);
 
 			return dsa_shared_port_phylink_register(dp);
 		}
-- 
2.43.0



