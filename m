Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADF0296FB6;
	Mon, 12 May 2025 17:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071820; cv=none; b=Cq7AdtSEkgCgW7HoV0DPLwxhmnU9BkC/8ADiKJDT+/pOR2W4QVKkrv8FHBYDf3tnNDT70/364ohioNkn4L1985EQIPNMP23OebVRv3U8HrFLdzsX1gTu/kQdz8id9WwjWz6U5HQ5Sq1Xz3n1hEffFHFiL3C62+S8OKK1wN67WEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071820; c=relaxed/simple;
	bh=l6+SoEALowo/hpDpY/58+sYVgm/7E5/CwW6idZ4Ew4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XA1aSiS3p90G5Saqist0AswM3OGDsB0Cr4uyoFncWRGuHnuyA1BXKto0q0LKP5VVscQcYPQmIy4h9jCEVXqbmis7JwIRMKkCrTk7wzbGspVRAzlstASRE+OnHXeSAUlJ6QKt8oOLoVI5e1loii9qMtmRKF2FiZkTb10tYFTLiPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gu5C6IiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gu5C6IiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC301C4CEE7;
	Mon, 12 May 2025 17:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071820;
	bh=l6+SoEALowo/hpDpY/58+sYVgm/7E5/CwW6idZ4Ew4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gu5C6IiLaMMzvk0ZbtdlYhC1jkrglu+ZA36lpsiqCynlAN1xvuKjBcWy+CKvXDXaz
	 IbheVQKWQkbU21OD82e4BYWyqRWuhq+wx9DLxSAcTqaAen4b461r0cAYj8eH/lLgpo
	 /Umwenjqx04ZYdwuk0+Zo0Ritfhm+K4ho8zQ82sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 040/197] net: dsa: b53: do not allow to configure VLAN 0
Date: Mon, 12 May 2025 19:38:10 +0200
Message-ID: <20250512172046.007858643@linuxfoundation.org>
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
index 305e3b5c804a2..24d3d693086b2 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1544,6 +1544,9 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 	if (err)
 		return err;
 
+	if (vlan->vid == 0)
+		return 0;
+
 	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &old_pvid);
 	if (pvid)
 		new_pvid = vlan->vid;
@@ -1556,10 +1559,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 
 	b53_get_vlan_entry(dev, vlan->vid, vl);
 
-	if (vlan->vid == 0 && vlan->vid == b53_default_pvid(dev))
-		untagged = true;
-
-	if (vlan->vid > 0 && dsa_is_cpu_port(ds, port))
+	if (dsa_is_cpu_port(ds, port))
 		untagged = false;
 
 	vl->members |= BIT(port);
@@ -1589,6 +1589,9 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
 	struct b53_vlan *vl;
 	u16 pvid;
 
+	if (vlan->vid == 0)
+		return 0;
+
 	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
 
 	vl = &dev->vlans[vlan->vid];
@@ -1935,8 +1938,9 @@ int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
 		bool *tx_fwd_offload, struct netlink_ext_ack *extack)
 {
 	struct b53_device *dev = ds->priv;
+	struct b53_vlan *vl;
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
-	u16 pvlan, reg;
+	u16 pvlan, reg, pvid;
 	unsigned int i;
 
 	/* On 7278, port 7 which connects to the ASP should only receive
@@ -1945,6 +1949,9 @@ int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
 	if (dev->chip_id == BCM7278_DEVICE_ID && port == 7)
 		return -EINVAL;
 
+	pvid = b53_default_pvid(dev);
+	vl = &dev->vlans[pvid];
+
 	/* Make this port leave the all VLANs join since we will have proper
 	 * VLAN entries from now on
 	 */
@@ -1956,6 +1963,15 @@ int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
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
@@ -2023,10 +2039,12 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
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



