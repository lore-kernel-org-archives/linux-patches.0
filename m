Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1CC2144C1;
	Wed,  7 May 2025 19:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644993; cv=none; b=m6kzfICdb4y88AD6nocbCaVUS9nPsFna48wWBpubN5TMytFT1u9NlzvqHtZ56BzslMsgxRmArQ0Ko2Pniacla0YkjVg0hdHL99/pNVq9iHHRN+zORoINkezuXnUHdPyxR2cAklpK/KSsQBqHdHTMfNNpAuNd3+6Z/hRXRLfqmAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644993; c=relaxed/simple;
	bh=gB39WgfEQd9hORj6usEgQ/penBaC+ShCdTaq0P5RfGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUnhMx/0ZpsCFANlHhPKksikWBc5C1hqY1+ARqt5TIAvMWB/yehRHC/gCOwaSBiqDuC7Ae/gjUhVPZ3E+7NJGOqCwOVgUbIvRP1BZW4VblNAv2WJG89H/KYQ13t1pJ3eMnQXk0NFPk2TeTLzbW6ZOzVY+QIoNtIr18/+qK5z0K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=am8QpmW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="am8QpmW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3060AC4CEE2;
	Wed,  7 May 2025 19:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644993;
	bh=gB39WgfEQd9hORj6usEgQ/penBaC+ShCdTaq0P5RfGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=am8QpmW6xz95+vYDSGQylbTLaDbugCaLSiadxW1HQGikTIOBmp2/Byqv0DCw8LFkg
	 V5C77bGvBq/blD0fs19fiV6uLZwuEhCgs4BtEuZ6F27ZhULSbXGg3rLLN3By1nK0Lr
	 8AWUs5Lzqlti9+JuK6TNwQ8Jh4QBUZzL37/8eYgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/129] net: mscc: ocelot: delete PVID VLAN when readding it as non-PVID
Date: Wed,  7 May 2025 20:39:56 +0200
Message-ID: <20250507183815.960325790@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d3e7aff5a794a..252d8e6f18c3c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -830,6 +830,7 @@ EXPORT_SYMBOL(ocelot_vlan_prepare);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		    bool untagged)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int err;
 
 	/* Ignore VID 0 added to our RX filter by the 8021q module, since
@@ -849,6 +850,11 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
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



