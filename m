Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680C5296FC6;
	Mon, 12 May 2025 17:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071825; cv=none; b=s8gPodbSNEXH0qhJj29dt/DoK/TCqw7r35EbrixXupNiKnwrerbka7YC26WT48lMNYkVMwHxTeDHgdwXyX4E+6G32JxEHGZWuHA+YzKcVyj1Z7mejprr9UfR1vtZ93EFFKW/iXj5gZe8jFKyowbpiSPh71BET9Xu8FACb71RHWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071825; c=relaxed/simple;
	bh=ojJDpGgxuMZptBt4ljGM/zVdvKn6r2vLb8SM4kd1oKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VblaZDYwqSAwswc3CSWz3zXH4kUq/awXCEA+g+HygEX/qYyZ41XKzfDSNLXXo7eggxPCQi7OA91iCynDTuuRTSOStBKT8Ybvu8Miq02R/WbbXxvM6kYdmEsc2A1v84NGSfdef47arrxoPq7GwEjaZL+DSt7kakiYvuoAzNx5nBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTXPOnlM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTXPOnlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6BAC4CEE7;
	Mon, 12 May 2025 17:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071825;
	bh=ojJDpGgxuMZptBt4ljGM/zVdvKn6r2vLb8SM4kd1oKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTXPOnlM5HSTOxF0H2YZJutOkExWlQJV4w94JlRJ2g+Y1KwrWTTatO/P4AJKjxUrl
	 9BBe4TXbXOdG+RxcNBPYzcRxf2O7QU1v2sQvI5Lesa2jdSOUGfXLHgHnrK5I0mFvsg
	 tzpDHrWTYIILR3WGuRlPzREKrE7oFyyZynnMQBd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 042/197] net: dsa: b53: fix toggling vlan_filtering
Date: Mon, 12 May 2025 19:38:12 +0200
Message-ID: <20250512172046.101571986@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 2dc2bd57111582895e10f54ea380329c89873f1c ]

To allow runtime switching between vlan aware and vlan non-aware mode,
we need to properly keep track of any bridge VLAN configuration.
Likewise, we need to know when we actually switch between both modes, to
not have to rewrite the full VLAN table every time we update the VLANs.

So keep track of the current vlan_filtering mode, and on changes, apply
the appropriate VLAN configuration.

Fixes: 0ee2af4ebbe3 ("net: dsa: set configure_vlan_while_not_filtering to true by default")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-10-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 104 ++++++++++++++++++++++---------
 drivers/net/dsa/b53/b53_priv.h   |   2 +
 2 files changed, 75 insertions(+), 31 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index bc51c9d807768..118457e28e717 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -763,6 +763,22 @@ static bool b53_vlan_port_needs_forced_tagged(struct dsa_switch *ds, int port)
 	return dev->tag_protocol == DSA_TAG_PROTO_NONE && dsa_is_cpu_port(ds, port);
 }
 
+static bool b53_vlan_port_may_join_untagged(struct dsa_switch *ds, int port)
+{
+	struct b53_device *dev = ds->priv;
+	struct dsa_port *dp;
+
+	if (!dev->vlan_filtering)
+		return true;
+
+	dp = dsa_to_port(ds, port);
+
+	if (dsa_port_is_cpu(dp))
+		return true;
+
+	return dp->bridge == NULL;
+}
+
 int b53_configure_vlan(struct dsa_switch *ds)
 {
 	struct b53_device *dev = ds->priv;
@@ -781,7 +797,7 @@ int b53_configure_vlan(struct dsa_switch *ds)
 		b53_do_vlan_op(dev, VTA_CMD_CLEAR);
 	}
 
-	b53_enable_vlan(dev, -1, dev->vlan_enabled, ds->vlan_filtering);
+	b53_enable_vlan(dev, -1, dev->vlan_enabled, dev->vlan_filtering);
 
 	/* Create an untagged VLAN entry for the default PVID in case
 	 * CONFIG_VLAN_8021Q is disabled and there are no calls to
@@ -789,26 +805,39 @@ int b53_configure_vlan(struct dsa_switch *ds)
 	 * entry. Do this only when the tagging protocol is not
 	 * DSA_TAG_PROTO_NONE
 	 */
+	v = &dev->vlans[def_vid];
 	b53_for_each_port(dev, i) {
-		v = &dev->vlans[def_vid];
-		v->members |= BIT(i);
+		if (!b53_vlan_port_may_join_untagged(ds, i))
+			continue;
+
+		vl.members |= BIT(i);
 		if (!b53_vlan_port_needs_forced_tagged(ds, i))
-			v->untag = v->members;
-		b53_write16(dev, B53_VLAN_PAGE,
-			    B53_VLAN_PORT_DEF_TAG(i), def_vid);
+			vl.untag = vl.members;
+		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(i),
+			    def_vid);
 	}
+	b53_set_vlan_entry(dev, def_vid, &vl);
 
-	/* Upon initial call we have not set-up any VLANs, but upon
-	 * system resume, we need to restore all VLAN entries.
-	 */
-	for (vid = def_vid; vid < dev->num_vlans; vid++) {
-		v = &dev->vlans[vid];
+	if (dev->vlan_filtering) {
+		/* Upon initial call we have not set-up any VLANs, but upon
+		 * system resume, we need to restore all VLAN entries.
+		 */
+		for (vid = def_vid + 1; vid < dev->num_vlans; vid++) {
+			v = &dev->vlans[vid];
 
-		if (!v->members)
-			continue;
+			if (!v->members)
+				continue;
+
+			b53_set_vlan_entry(dev, vid, v);
+			b53_fast_age_vlan(dev, vid);
+		}
 
-		b53_set_vlan_entry(dev, vid, v);
-		b53_fast_age_vlan(dev, vid);
+		b53_for_each_port(dev, i) {
+			if (!dsa_is_cpu_port(ds, i))
+				b53_write16(dev, B53_VLAN_PAGE,
+					    B53_VLAN_PORT_DEF_TAG(i),
+					    dev->ports[i].pvid);
+		}
 	}
 
 	return 0;
@@ -1127,7 +1156,9 @@ EXPORT_SYMBOL(b53_setup_devlink_resources);
 static int b53_setup(struct dsa_switch *ds)
 {
 	struct b53_device *dev = ds->priv;
+	struct b53_vlan *vl;
 	unsigned int port;
+	u16 pvid;
 	int ret;
 
 	/* Request bridge PVID untagged when DSA_TAG_PROTO_NONE is set
@@ -1146,6 +1177,15 @@ static int b53_setup(struct dsa_switch *ds)
 		return ret;
 	}
 
+	/* setup default vlan for filtering mode */
+	pvid = b53_default_pvid(dev);
+	vl = &dev->vlans[pvid];
+	b53_for_each_port(dev, port) {
+		vl->members |= BIT(port);
+		if (!b53_vlan_port_needs_forced_tagged(ds, port))
+			vl->untag |= BIT(port);
+	}
+
 	b53_reset_mib(dev);
 
 	ret = b53_apply_config(dev);
@@ -1499,7 +1539,10 @@ int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 {
 	struct b53_device *dev = ds->priv;
 
-	b53_enable_vlan(dev, port, dev->vlan_enabled, vlan_filtering);
+	if (dev->vlan_filtering != vlan_filtering) {
+		dev->vlan_filtering = vlan_filtering;
+		b53_apply_config(dev);
+	}
 
 	return 0;
 }
@@ -1524,7 +1567,7 @@ static int b53_vlan_prepare(struct dsa_switch *ds, int port,
 	if (vlan->vid >= dev->num_vlans)
 		return -ERANGE;
 
-	b53_enable_vlan(dev, port, true, ds->vlan_filtering);
+	b53_enable_vlan(dev, port, true, dev->vlan_filtering);
 
 	return 0;
 }
@@ -1547,21 +1590,17 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 	if (vlan->vid == 0)
 		return 0;
 
-	if (!ds->vlan_filtering)
-		return 0;
-
-	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &old_pvid);
+	old_pvid = dev->ports[port].pvid;
 	if (pvid)
 		new_pvid = vlan->vid;
 	else if (!pvid && vlan->vid == old_pvid)
 		new_pvid = b53_default_pvid(dev);
 	else
 		new_pvid = old_pvid;
+	dev->ports[port].pvid = new_pvid;
 
 	vl = &dev->vlans[vlan->vid];
 
-	b53_get_vlan_entry(dev, vlan->vid, vl);
-
 	if (dsa_is_cpu_port(ds, port))
 		untagged = false;
 
@@ -1571,6 +1610,9 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 	else
 		vl->untag &= ~BIT(port);
 
+	if (!dev->vlan_filtering)
+		return 0;
+
 	b53_set_vlan_entry(dev, vlan->vid, vl);
 	b53_fast_age_vlan(dev, vlan->vid);
 
@@ -1595,23 +1637,22 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
 	if (vlan->vid == 0)
 		return 0;
 
-	if (!ds->vlan_filtering)
-		return 0;
-
-	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
+	pvid = dev->ports[port].pvid;
 
 	vl = &dev->vlans[vlan->vid];
 
-	b53_get_vlan_entry(dev, vlan->vid, vl);
-
 	vl->members &= ~BIT(port);
 
 	if (pvid == vlan->vid)
 		pvid = b53_default_pvid(dev);
+	dev->ports[port].pvid = pvid;
 
 	if (untagged && !b53_vlan_port_needs_forced_tagged(ds, port))
 		vl->untag &= ~(BIT(port));
 
+	if (!dev->vlan_filtering)
+		return 0;
+
 	b53_set_vlan_entry(dev, vlan->vid, vl);
 	b53_fast_age_vlan(dev, vlan->vid);
 
@@ -1958,7 +1999,7 @@ int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
 	pvid = b53_default_pvid(dev);
 	vl = &dev->vlans[pvid];
 
-	if (ds->vlan_filtering) {
+	if (dev->vlan_filtering) {
 		/* Make this port leave the all VLANs join since we will have
 		 * proper VLAN entries from now on
 		 */
@@ -2038,7 +2079,7 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 	pvid = b53_default_pvid(dev);
 	vl = &dev->vlans[pvid];
 
-	if (ds->vlan_filtering) {
+	if (dev->vlan_filtering) {
 		/* Make this port join all VLANs without VLAN entries */
 		if (is58xx(dev)) {
 			b53_read16(dev, B53_VLAN_PAGE, B53_JOIN_ALL_VLAN_EN, &reg);
@@ -2790,6 +2831,7 @@ struct b53_device *b53_switch_alloc(struct device *base,
 	ds->ops = &b53_switch_ops;
 	ds->phylink_mac_ops = &b53_phylink_mac_ops;
 	dev->vlan_enabled = true;
+	dev->vlan_filtering = false;
 	/* Let DSA handle the case were multiple bridges span the same switch
 	 * device and different VLAN awareness settings are requested, which
 	 * would be breaking filtering semantics for any of the other bridge
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 9e9b5bc0c5d6a..982d1867f76b5 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -95,6 +95,7 @@ struct b53_pcs {
 
 struct b53_port {
 	u16		vlan_ctl_mask;
+	u16		pvid;
 	struct ethtool_keee eee;
 };
 
@@ -146,6 +147,7 @@ struct b53_device {
 	unsigned int num_vlans;
 	struct b53_vlan *vlans;
 	bool vlan_enabled;
+	bool vlan_filtering;
 	unsigned int num_ports;
 	struct b53_port *ports;
 
-- 
2.39.5



