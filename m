Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A99255E47;
	Mon, 12 May 2025 17:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072365; cv=none; b=XtOjDIaVBFUUA/SfXF4cCISmpib0V1FOc7Gmvjip9K9k1LLunYCYbFLt89F7EV8jLtgF7HRC00fe/x6ZWigB6vFwkjfKVKmuBueg0aIZmDWB2I9nqgroMppFEUgLNAzGTHba2RrFUah8nUFTHfEAvPiRS90nVb9TtWFdhErjRL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072365; c=relaxed/simple;
	bh=IKJ8n7tuxeW14b3QT/mXoy0PvIA7af267nYrA+59AkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3nm2GZl6Wy7pprDgUrf4iJsrMMA+bwk+AD4RlU9FTnOJep1OHIiZEHiWAGd5YPfJNpGVR+V6nShaxCKY1A8WDqP74GflY95cpA6hQqUPCMcwjfTnU1T5jFhV+JLittFBynkKOLVroTrRwR0WfJmF7zzgYU4+Gq7gGtX8YA93w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vew/2297; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vew/2297"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959A1C4CEE7;
	Mon, 12 May 2025 17:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072365;
	bh=IKJ8n7tuxeW14b3QT/mXoy0PvIA7af267nYrA+59AkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vew/2297jv6UAbxGTXoWqBTl/cv1xgAFE/+xzRoYyxTHGRnvm299sK9odXk/+0CFq
	 V+G0FnPQHEQccX1tu3qBV+PAM4CBxFZG1Po/OnLz2lT9JWs1/relvvP2GqFljGypqc
	 I8EEosqOUYdb5gtAJSRu6Vk+8sg2NfKmDJK9Na4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/92] net: dsa: b53: fix clearing PVID of a port
Date: Mon, 12 May 2025 19:44:53 +0200
Message-ID: <20250512172023.863246894@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index afaecc92f8a84..9e33e713b9c83 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1477,12 +1477,21 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
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
@@ -1499,9 +1508,9 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
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



