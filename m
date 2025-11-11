Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA09726AC3;
	Tue, 11 Nov 2025 01:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825028; cv=none; b=BhmyJfXxDFFWmETqYThpECa+HvG3i9ZtJ76g6CglwFTykD1hEoT/oconmUWFpvLWSm1s7wCnw4/XAmMuJWDT1NXIbyr01MrTYEyyNDQ9sWR1K895QdN70L13KUycmi3iQRPdAB8SqtFT8x/uGAuqAp7NmM82QIjd3HCF5xkX79w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825028; c=relaxed/simple;
	bh=C982Rv8AskD1dCNEiE7b8TQbW0DFprbvUoupwBsPAKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUUTQ9J94HXKq1pyTNGfU5J52U+sOvAJupRB1G+fBUWBV8srIIc1I9NIltDJtXI0FzFTgBz01HRauUB8T7XD/BN9YQLi+Nrld3WXHoauK7EmxKIc7o2/Cuw6zaVO+I7gfKpo0PeI38btZDZghqo161dC+PqRvOl0SAqU2zqCFog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZgTcQGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZgTcQGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FC4C4CEFB;
	Tue, 11 Nov 2025 01:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825028;
	bh=C982Rv8AskD1dCNEiE7b8TQbW0DFprbvUoupwBsPAKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZgTcQGmIEtnfjSCPtGnF89ASoJC781uqVbS3HIPAZzfQI/IUH9+utkM9gwPDvpZr
	 o9T3csLG52ayiIqTOzoj+C03LjVD3Ycr6PEp+jTHL7AahgL3rWDxb9V53+cC0d5Lkl
	 kYl+H14kCRf8WLwJviCn6zRhtCSSuz81I4hE1hsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 631/849] net: bridge: Install FDB for bridge MAC on VLAN 0
Date: Tue, 11 Nov 2025 09:43:21 +0900
Message-ID: <20251111004551.689274842@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit cd9a9562b2559973aa1b68c3af63021a2c5fd022 ]

Currently, after the bridge is created, the FDB does not hold an FDB entry
for the bridge MAC on VLAN 0:

 # ip link add name br up type bridge
 # ip -br link show dev br
 br               UNKNOWN        92:19:8c:4e:01:ed <BROADCAST,MULTICAST,UP,LOWER_UP>
 # bridge fdb show | grep 92:19:8c:4e:01:ed
 92:19:8c:4e:01:ed dev br vlan 1 master br permanent

Later when the bridge MAC is changed, or in fact when the address is given
during netdevice creation, the entry appears:

 # ip link add name br up address 00:11:22:33:44:55 type bridge
 # bridge fdb show | grep 00:11:22:33:44:55
 00:11:22:33:44:55 dev br vlan 1 master br permanent
 00:11:22:33:44:55 dev br master br permanent

However when the bridge address is set by the user to the current bridge
address before the first port is enslaved, none of the address handlers
gets invoked, because the address is not actually changed. The address is
however marked as NET_ADDR_SET. Then when a port is enslaved, the address
is not changed, because it is NET_ADDR_SET. Thus the VLAN 0 entry is not
added, and it has not been added previously either:

 # ip link add name br up type bridge
 # ip -br link show dev br
 br               UNKNOWN        7e:f0:a8:1a:be:c2 <BROADCAST,MULTICAST,UP,LOWER_UP>
 # ip link set dev br addr 7e:f0:a8:1a:be:c2
 # ip link add name v up type veth
 # ip link set dev v master br
 # ip -br link show dev br
 br               UNKNOWN        7e:f0:a8:1a:be:c2 <BROADCAST,MULTICAST,UP,LOWER_UP>
 # bridge fdb | grep 7e:f0:a8:1a:be:c2
 7e:f0:a8:1a:be:c2 dev br vlan 1 master br permanent

Then when the bridge MAC is used as DMAC, and br_handle_frame_finish()
looks up an FDB entry with VLAN=0, it doesn't find any, and floods the
traffic instead of passing it up.

Fix this by simply adding the VLAN 0 FDB entry for the bridge itself always
on netdevice creation. This also makes the behavior consistent with how
ports are treated: ports always have an FDB entry for each member VLAN as
well as VLAN 0.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/415202b2d1b9b0899479a502bbe2ba188678f192.1758550408.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index c683baa3847f1..74706cb9283a2 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -37,6 +37,11 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
 	int err;
 
 	if (netif_is_bridge_master(dev)) {
+		struct net_bridge *br = netdev_priv(dev);
+
+		if (event == NETDEV_REGISTER)
+			br_fdb_change_mac_address(br, dev->dev_addr);
+
 		err = br_vlan_bridge_event(dev, event, ptr);
 		if (err)
 			return notifier_from_errno(err);
-- 
2.51.0



