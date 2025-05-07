Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E63329A0;
	Wed,  7 May 2025 18:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643575; cv=none; b=EY+j21iMiCZpHuGVmpDt1bjEUr5juuLuDOH+NYzEKCrE8UvOuxMxy0WdpYtkdFxxOUvH/BbOgDaC29RjZ0jgZMEGxHrzn1iw0yd4uCPWTKZFKLu5Qjbhvg5/QyPVkCAoYdONGSMZUicfQeOaJx/Y3BDxStzYRaxdcXC/Zds8CBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643575; c=relaxed/simple;
	bh=Xi7xs9+ztyhDmp9UMfZwejkDO9T2yvmQ72tJxyRTi1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uc/Tqc1l4fyPtwyQgSHCcMiV+L+HjXKRTJg8mbSHdagMghvNeEZ4lW9Il9tbbMwCf4SZyfzU8WgpA7WRBo5qQrrAoslFtMKSsYZQXsl9HomY2mKDiYGDCGaIgoQj107jKHb1MQn36WZNnlaSmtwgi7RZ89RNQ3PMQFEVz8bq0ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLBI6hiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLBI6hiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7CFC4CEE2;
	Wed,  7 May 2025 18:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643575;
	bh=Xi7xs9+ztyhDmp9UMfZwejkDO9T2yvmQ72tJxyRTi1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLBI6hiKHqfygPhTtuRIwWth/w4U6GxsOMOg/VsuK4Evd/v04MP1gIYkQOW4GjssE
	 ZdKhjOlFv+QI24LZWNx/6ZMAhK/Wwzqan6pfkEMR/84smzUt09oLrbYu8H8cqZ/Ze/
	 rzny/+GJEcmUrer2ti26mHVJvlTicDZzLZQRUS90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 47/97] net: mscc: ocelot: delete PVID VLAN when readding it as non-PVID
Date: Wed,  7 May 2025 20:39:22 +0200
Message-ID: <20250507183808.893840801@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 5ec6d7d737a491256cd37e33910f7ac1978db591 ]

The following set of commands:

ip link add br0 type bridge vlan_filtering 1 # vlan_default_pvid 1 is implicit
ip link set swp0 master br0
bridge vlan add dev swp0 vid 1

should result in the dropping of untagged and 802.1p-tagged traffic, but
we see that it continues to be accepted. Whereas, had we deleted VID 1
instead, the aforementioned dropping would have worked

This is because the ANA_PORT_DROP_CFG update logic doesn't run, because
ocelot_vlan_add() only calls ocelot_port_set_pvid() if the new VLAN has
the BRIDGE_VLAN_INFO_PVID flag.

Similar to other drivers like mt7530_port_vlan_add() which handle this
case correctly, we need to test whether the VLAN we're changing used to
have the BRIDGE_VLAN_INFO_PVID flag, but lost it now. That amounts to a
PVID deletion and should be treated as such.

Regarding blame attribution: this never worked properly since the
introduction of bridge VLAN filtering in commit 7142529f1688 ("net:
mscc: ocelot: add VLAN filtering"). However, there was a significant
paradigm shift which aligned the ANA_PORT_DROP_CFG register with the
PVID concept rather than with the native VLAN concept, and that change
wasn't targeted for 'stable'. Realistically, that is as far as this fix
needs to be propagated to.

Fixes: be0576fed6d3 ("net: mscc: ocelot: move the logic to drop 802.1p traffic to the pvid deletion")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250424223734.3096202-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ec644a201b8e5..203cb4978544a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -793,6 +793,7 @@ EXPORT_SYMBOL(ocelot_vlan_prepare);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		    bool untagged)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int err;
 
 	/* Ignore VID 0 added to our RX filter by the 8021q module, since
@@ -812,6 +813,11 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 					   ocelot_bridge_vlan_find(ocelot, vid));
 		if (err)
 			return err;
+	} else if (ocelot_port->pvid_vlan &&
+		   ocelot_bridge_vlan_find(ocelot, vid) == ocelot_port->pvid_vlan) {
+		err = ocelot_port_set_pvid(ocelot, port, NULL);
+		if (err)
+			return err;
 	}
 
 	/* Untagged egress vlan clasification */
-- 
2.39.5



