Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989C53659F4;
	Wed,  3 Dec 2025 16:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779431; cv=none; b=BCtdNe6NHs+4lC91JblFP3bSADuQuKMZYRdmcZ9k8zlmMiKpP4iDBhaxScEN6KfD1NvoJLdfczqSTOgIMnBHHBxJ6wEGs9vvcxEqH7CIGVTVrVegWSlZBjgG8tXzcIBEe83xwKUfM5U8IbaQJTKYe5KC/yCh4XsRXwOvy5anNz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779431; c=relaxed/simple;
	bh=Bg4ny6OxggzfDitpaRisZEQtrNqMwBeREqCwzzS5PVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcoXSfRAj0iQssWpyPSzcbAgleiglSzbXzHF/Qg/fxkfjvUCV0mEZAWgdIPQAcGqVhKQIZ0Kv2pbSvHzFUdHMfyDcJd5MfgavLLqNRIBiheOY0eruKQ30mgGv3PX37/JB4vLqqiyYBiv8BP11no2vyqUrfoqFX8nUv/TiBpteWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2CKN//v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2CKN//v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BB0C4CEF5;
	Wed,  3 Dec 2025 16:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779431;
	bh=Bg4ny6OxggzfDitpaRisZEQtrNqMwBeREqCwzzS5PVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2CKN//vlls4OAV9sHqUQd7bdcRUGPbb/Wa1puaUJSM2tyzYxjkGs8P9ExPSiy15h
	 EayYx8ejM0dtztAnGFWzMHwVJbHvyLtmg+4P86unE1TLd7br5mP0LPd7SD8yRv/Okg
	 RiykCakYOvMJiaLUIX3w4lJcQUbBvPWA7LZwF/H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 256/568] net: bridge: Install FDB for bridge MAC on VLAN 0
Date: Wed,  3 Dec 2025 16:24:18 +0100
Message-ID: <20251203152450.097151099@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 96e91d69a9a88..9341b5f51f0dd 100644
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



