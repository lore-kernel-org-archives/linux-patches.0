Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359A71519B8;
	Mon, 12 May 2025 18:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072819; cv=none; b=hv7gwh2+KItNvXuIe6PoQSF77UzGXoXeCR+b0Qq+hNnzirXVt7bZtRglJVAmiyTCq3oC282ylT23c0Vj+FzBAlDIbqyo4yOvd/iSOt5yd45UuPC+WznwVHQxCSZV4kvyvku+Pd5lMuBLT/LklGFUJ5qR6CL8um70JsZBKHBQxe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072819; c=relaxed/simple;
	bh=D4ccS4uop2AiCP4OYY82ZeqW0geui9Jb+D+6hSTKaMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTPfPez0wVTg7xOyGrduihx43A5/AjtnwSWicNlfNj0xbvjJMkD9DpUPdAyLJKrKiDZB0kYufn7+mT9408U5l2C4c/Dlv6ALzrmkz9lVyOA5GGfz/+gB6u4n2xQFjbsgL2F/oXogtCyDWHdbMki9oHO8+76NU7VW2jrrWkD6Zzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAkPr0BU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAkPr0BU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B84C4CEE7;
	Mon, 12 May 2025 18:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072819;
	bh=D4ccS4uop2AiCP4OYY82ZeqW0geui9Jb+D+6hSTKaMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAkPr0BU43gkjPWRJllN709UhslbYkf34VQ9GDuFbmKe36dWNXKVk48L0DdJKMS/h
	 6Qnjhiseayg8H5QJAljnDbcHJANG78imsCDU1zBFUO7aLWHyOcFWyJZu6+aSmhe7CC
	 pnw6nbkRcMzb9G4E1QRUi2OKoZFxwUit7tiBj9Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/184] net: dsa: b53: fix clearing PVID of a port
Date: Mon, 12 May 2025 19:43:58 +0200
Message-ID: <20250512172043.234430306@linuxfoundation.org>
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

[ Upstream commit f480851981043d9bb6447ca9883ade9247b9a0ad ]

Currently the PVID of ports are only set when adding/updating VLANs with
PVID set or removing VLANs, but not when clearing the PVID flag of a
VLAN.

E.g. the following flow

$ ip link add br0 type bridge vlan_filtering 1
$ ip link set sw1p1 master bridge
$ bridge vlan add dev sw1p1 vid 10 pvid untagged
$ bridge vlan add dev sw1p1 vid 10 untagged

Would keep the PVID set as 10, despite the flag being cleared. Fix this
by checking if we need to unset the PVID on vlan updates.

Fixes: a2482d2ce349 ("net: dsa: b53: Plug in VLAN support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-4-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index d66ef7ad7a604..31d20552cdb08 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1538,12 +1538,21 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct b53_vlan *vl;
+	u16 old_pvid, new_pvid;
 	int err;
 
 	err = b53_vlan_prepare(ds, port, vlan);
 	if (err)
 		return err;
 
+	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &old_pvid);
+	if (pvid)
+		new_pvid = vlan->vid;
+	else if (!pvid && vlan->vid == old_pvid)
+		new_pvid = b53_default_pvid(dev);
+	else
+		new_pvid = old_pvid;
+
 	vl = &dev->vlans[vlan->vid];
 
 	b53_get_vlan_entry(dev, vlan->vid, vl);
@@ -1563,9 +1572,9 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 	b53_set_vlan_entry(dev, vlan->vid, vl);
 	b53_fast_age_vlan(dev, vlan->vid);
 
-	if (pvid && !dsa_is_cpu_port(ds, port)) {
+	if (!dsa_is_cpu_port(ds, port) && new_pvid != old_pvid) {
 		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
-			    vlan->vid);
+			    new_pvid);
 		b53_fast_age_vlan(dev, vlan->vid);
 	}
 
-- 
2.39.5



