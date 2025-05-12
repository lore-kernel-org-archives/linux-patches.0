Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9B7255E52;
	Mon, 12 May 2025 17:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072736; cv=none; b=DeWLmsBBH0CpLNeGCrW8Xgv64PfcntdeWXlNy10LvB0ZMII7sBTJEJcy9BHHzCo43O7GkG7UQdO6NMWZwJMAp+WQUzXZJVB8mEk+F3020XYeBccO/9+LqUw9Yh0UdE6/oXO2Pgbo3IFwycEko0amdut9Ajuyczr3OiwaSjHEcaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072736; c=relaxed/simple;
	bh=Mx9YprUzbPnYDqmK2Iw/CNagHSKpdniBkKxlr8cuZXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NposWURFYMuGyy1gWAag2dj86+Kdl7YyE3KyQ3vi1hx6NyepXyz6C5cCajn0p9jX8LMOaGfYuv0gt13oMUfKP4T4c68wCoFuSQOnBPjn5QOHEhiP7rBbDSdQbKRtl8LGo90Wo+kc1IGROKJczUYkh75b1ThsuaHRvfcE2icG25k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3GuLhXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3GuLhXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5BDC4CEE7;
	Mon, 12 May 2025 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072736;
	bh=Mx9YprUzbPnYDqmK2Iw/CNagHSKpdniBkKxlr8cuZXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3GuLhXZPWGD+tKTLd9Wyfmrz8JWZFmQv7pcsLzKj4x3yoWPno1/K1yv2pVfPvuv8
	 bG8kVvTaCo4FDzQhibnCmJR7GtUAKvuVQAFswID2JQWvpWPBgbidU1S5LQMxVmqjCg
	 ZlA2OyPB5RTYo81oB8sLvMs4VMpv803oLE6dNdmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/184] net: dsa: b53: do not allow to configure VLAN 0
Date: Mon, 12 May 2025 19:44:02 +0200
Message-ID: <20250512172043.401560254@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 45e9d59d39503bb3e6ab4d258caea4ba6496e2dc ]

Since we cannot set forwarding destinations per VLAN, we should not have
a VLAN 0 configured, as it would allow untagged traffic to work across
ports on VLAN aware bridges regardless if a PVID untagged VLAN exists.

So remove the VLAN 0 on join, an re-add it on leave. But only do so if
we have a VLAN aware bridge, as without it, untagged traffic would
become tagged with VID 0 on a VLAN unaware bridge.

Fixes: a2482d2ce349 ("net: dsa: b53: Plug in VLAN support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-8-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 36 ++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 70a8f70d2c6d5..16d6582c931f9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1545,6 +1545,9 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 	if (err)
 		return err;
 
+	if (vlan->vid == 0)
+		return 0;
+
 	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &old_pvid);
 	if (pvid)
 		new_pvid = vlan->vid;
@@ -1557,10 +1560,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 
 	b53_get_vlan_entry(dev, vlan->vid, vl);
 
-	if (vlan->vid == 0 && vlan->vid == b53_default_pvid(dev))
-		untagged = true;
-
-	if (vlan->vid > 0 && dsa_is_cpu_port(ds, port))
+	if (dsa_is_cpu_port(ds, port))
 		untagged = false;
 
 	vl->members |= BIT(port);
@@ -1590,6 +1590,9 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
 	struct b53_vlan *vl;
 	u16 pvid;
 
+	if (vlan->vid == 0)
+		return 0;
+
 	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
 
 	vl = &dev->vlans[vlan->vid];
@@ -1936,8 +1939,9 @@ int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
 		bool *tx_fwd_offload, struct netlink_ext_ack *extack)
 {
 	struct b53_device *dev = ds->priv;
+	struct b53_vlan *vl;
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
-	u16 pvlan, reg;
+	u16 pvlan, reg, pvid;
 	unsigned int i;
 
 	/* On 7278, port 7 which connects to the ASP should only receive
@@ -1946,6 +1950,9 @@ int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
 	if (dev->chip_id == BCM7278_DEVICE_ID && port == 7)
 		return -EINVAL;
 
+	pvid = b53_default_pvid(dev);
+	vl = &dev->vlans[pvid];
+
 	/* Make this port leave the all VLANs join since we will have proper
 	 * VLAN entries from now on
 	 */
@@ -1957,6 +1964,15 @@ int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
 		b53_write16(dev, B53_VLAN_PAGE, B53_JOIN_ALL_VLAN_EN, reg);
 	}
 
+	if (ds->vlan_filtering) {
+		b53_get_vlan_entry(dev, pvid, vl);
+		vl->members &= ~BIT(port);
+		if (vl->members == BIT(cpu_port))
+			vl->members &= ~BIT(cpu_port);
+		vl->untag = vl->members;
+		b53_set_vlan_entry(dev, pvid, vl);
+	}
+
 	b53_read16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), &pvlan);
 
 	b53_for_each_port(dev, i) {
@@ -2024,10 +2040,12 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 		b53_write16(dev, B53_VLAN_PAGE, B53_JOIN_ALL_VLAN_EN, reg);
 	}
 
-	b53_get_vlan_entry(dev, pvid, vl);
-	vl->members |= BIT(port) | BIT(cpu_port);
-	vl->untag |= BIT(port) | BIT(cpu_port);
-	b53_set_vlan_entry(dev, pvid, vl);
+	if (ds->vlan_filtering) {
+		b53_get_vlan_entry(dev, pvid, vl);
+		vl->members |= BIT(port) | BIT(cpu_port);
+		vl->untag |= BIT(port) | BIT(cpu_port);
+		b53_set_vlan_entry(dev, pvid, vl);
+	}
 }
 EXPORT_SYMBOL(b53_br_leave);
 
-- 
2.39.5



