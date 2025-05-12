Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC8B296FC3;
	Mon, 12 May 2025 17:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071822; cv=none; b=dNpXoYv2sKTjtCvuR4nkXJ/PayWeDpRIWU7B6fO7gqHE6O4DF6qZOaw7V3di8XTjW4Mt2CwVCPN5zbXUIhJY8lgUxzDxLb0fEzTa1jYxfDW0bjz9jYEBybcSJEYwN9Sxl2QQtISqECEtU6rgNn5JoZErb+QjDo2wDObWWFZcEEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071822; c=relaxed/simple;
	bh=DZUwbT4xhKhJseJyeAi9KoysAj/D06wgKh6QTUhrzaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpuRl/e2jDkzVMKMbgwN1PI9ihSpQ2hzWpwEuMrbqyggdI90pMAioBmuXOJE3gKqAfLXDlec31fxgK/hEU/jO1aFmytA+vjs0uPCZ0BsQcv/EtdfyXFvmaBhucc5+l0iYDSA+wKPvx5KBfqoICbzLgDK+0f2DE8pr6Np/JFOBRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jq/5HCPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jq/5HCPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C20CC4CEE7;
	Mon, 12 May 2025 17:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071822;
	bh=DZUwbT4xhKhJseJyeAi9KoysAj/D06wgKh6QTUhrzaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jq/5HCPmLX8KCjeDMMtOTkimN08/DkQ1Akfz6pUIKckqRc/XIqO2Ld/RsVnLPY8XK
	 B8PpND90n8NVtr09N3v39j2j3wnbXikHhJAixIQjtTRswWQ0Gixbw+2e7O0z+V3xQt
	 qp1WVq9O0fse2jVj5MTHRGabHGyfh7BihC1H9rLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 041/197] net: dsa: b53: do not program vlans when vlan filtering is off
Date: Mon, 12 May 2025 19:38:11 +0200
Message-ID: <20250512172046.060741352@linuxfoundation.org>
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

[ Upstream commit f089652b6b16452535dcc5cbaa6e2bb05acd3f93 ]

Documentation/networking/switchdev.rst says:

- with VLAN filtering turned off: the bridge is strictly VLAN unaware and its
  data path will process all Ethernet frames as if they are VLAN-untagged.
  The bridge VLAN database can still be modified, but the modifications should
  have no effect while VLAN filtering is turned off.

This breaks if we immediately apply the VLAN configuration, so skip
writing it when vlan_filtering is off.

Fixes: 0ee2af4ebbe3 ("net: dsa: set configure_vlan_while_not_filtering to true by default")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-9-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 48 +++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 24d3d693086b2..bc51c9d807768 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1547,6 +1547,9 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 	if (vlan->vid == 0)
 		return 0;
 
+	if (!ds->vlan_filtering)
+		return 0;
+
 	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &old_pvid);
 	if (pvid)
 		new_pvid = vlan->vid;
@@ -1592,6 +1595,9 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
 	if (vlan->vid == 0)
 		return 0;
 
+	if (!ds->vlan_filtering)
+		return 0;
+
 	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
 
 	vl = &dev->vlans[vlan->vid];
@@ -1952,18 +1958,20 @@ int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
 	pvid = b53_default_pvid(dev);
 	vl = &dev->vlans[pvid];
 
-	/* Make this port leave the all VLANs join since we will have proper
-	 * VLAN entries from now on
-	 */
-	if (is58xx(dev)) {
-		b53_read16(dev, B53_VLAN_PAGE, B53_JOIN_ALL_VLAN_EN, &reg);
-		reg &= ~BIT(port);
-		if ((reg & BIT(cpu_port)) == BIT(cpu_port))
-			reg &= ~BIT(cpu_port);
-		b53_write16(dev, B53_VLAN_PAGE, B53_JOIN_ALL_VLAN_EN, reg);
-	}
-
 	if (ds->vlan_filtering) {
+		/* Make this port leave the all VLANs join since we will have
+		 * proper VLAN entries from now on
+		 */
+		if (is58xx(dev)) {
+			b53_read16(dev, B53_VLAN_PAGE, B53_JOIN_ALL_VLAN_EN,
+				   &reg);
+			reg &= ~BIT(port);
+			if ((reg & BIT(cpu_port)) == BIT(cpu_port))
+				reg &= ~BIT(cpu_port);
+			b53_write16(dev, B53_VLAN_PAGE, B53_JOIN_ALL_VLAN_EN,
+				    reg);
+		}
+
 		b53_get_vlan_entry(dev, pvid, vl);
 		vl->members &= ~BIT(port);
 		if (vl->members == BIT(cpu_port))
@@ -2030,16 +2038,16 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 	pvid = b53_default_pvid(dev);
 	vl = &dev->vlans[pvid];
 
-	/* Make this port join all VLANs without VLAN entries */
-	if (is58xx(dev)) {
-		b53_read16(dev, B53_VLAN_PAGE, B53_JOIN_ALL_VLAN_EN, &reg);
-		reg |= BIT(port);
-		if (!(reg & BIT(cpu_port)))
-			reg |= BIT(cpu_port);
-		b53_write16(dev, B53_VLAN_PAGE, B53_JOIN_ALL_VLAN_EN, reg);
-	}
-
 	if (ds->vlan_filtering) {
+		/* Make this port join all VLANs without VLAN entries */
+		if (is58xx(dev)) {
+			b53_read16(dev, B53_VLAN_PAGE, B53_JOIN_ALL_VLAN_EN, &reg);
+			reg |= BIT(port);
+			if (!(reg & BIT(cpu_port)))
+				reg |= BIT(cpu_port);
+			b53_write16(dev, B53_VLAN_PAGE, B53_JOIN_ALL_VLAN_EN, reg);
+		}
+
 		b53_get_vlan_entry(dev, pvid, vl);
 		vl->members |= BIT(port) | BIT(cpu_port);
 		vl->untag |= BIT(port) | BIT(cpu_port);
-- 
2.39.5



