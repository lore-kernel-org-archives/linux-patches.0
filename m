Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D863074B2;
	Sat, 25 Oct 2025 16:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408972; cv=none; b=H8YRkyvXTSR0xR3lAmyIbucAOs33plkdaZDAJdulG1gKgrvGEJEOkXoJec3kCvjK2laVqbEdu/Gs6qJahNYDry01y9X5dlEWd7F7KBkXUxcm6DwR+qNYqVuSbHsDNLUbLtYJY0PRcMQTSN5ddiA1sytRA5A1ux5t7zBxvg8nb7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408972; c=relaxed/simple;
	bh=3d+JS98l1QcouAqEyCnc0lMFvnZjQzclVdjFf/OvsIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uNqinuYbQ7VQZ1wQJMu8kw3fggF+ps9lKdinQPyIKTd+IgfSYapVJKC3bPsTV+ltg1cYV6vxFTTcIlb3A/8y5a1I+htF8miQ7Q0VbHXphf5aoOCKL8pFNJTKNnWGZDqfqZOeR2K2qyGmNSOxLRToboRxtDijrFmHalI4pUKQ09E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NRmzNg9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NRmzNg9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AE1C4CEFF;
	Sat, 25 Oct 2025 16:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408972;
	bh=3d+JS98l1QcouAqEyCnc0lMFvnZjQzclVdjFf/OvsIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRmzNg9xyfYGyYgmmgcLPfblSy0KD3ja79ooXmRhwDmwejwDYYP8yFb+c16TcBMR6
	 rj1UCUsL7pVl+gyPpPlgf14jFLoPseSxaRa7PjGdx3dDaEQuHPgNPyO7HqnajZwWBo
	 hwrOii8Tfw2tks53abAervpyP7d1wWhIrWSIxaJLRY9KfhT8oa7wGLOFJfTUFAoJ0O
	 6xU9DBNJ83of0+2ZBzWoKeXTiktg0oUEvKZyQdmEdyQNtdbtjAI/H9c4RxUd9Ly0g8
	 F6YPMyT2eHcA0ZcVJMQC0fQyadAV/SVydrR/wzmlD97GwJRDKFsqjj2VPFVEvtFr9b
	 Lr1RaaMOd301Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.1] net: bridge: Install FDB for bridge MAC on VLAN 0
Date: Sat, 25 Oct 2025 11:56:30 -0400
Message-ID: <20251025160905.3857885-159-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES
- `net/bridge/br.c:39-55` now invokes `br_fdb_change_mac_address(br,
  dev->dev_addr)` during the bridge master’s `NETDEV_REGISTER` notifier,
  immediately installing the bridge’s own MAC into the FDB for VLAN 0.
  Without this early call, a user who sets the bridge MAC to its current
  value before enslaving any port leaves `addr_assign_type` at
  `NET_ADDR_SET`, so later events never repopulate the missing VLAN‑0
  entry.
- When that entry is absent, `br_handle_frame_finish()`
  (`net/bridge/br_input.c:204-235`) fails to resolve a local destination
  for frames addressed to the bridge on VLAN 0, falls into the
  `br_flood()` path, and never calls `br_pass_frame_up()`, so traffic to
  the bridge itself is effectively dropped in exactly the scenario
  described.
- The added call simply reuses the existing, well-tested helper in
  `net/bridge/br_fdb.c:501-536`, making bridge setup match the behavior
  already applied whenever the MAC really changes; it keeps bridge and
  port FDB handling consistent and generates the same notifications user
  space would see after a later MAC change.
- Risk is minimal: the new work executes under RTNL alongside existing
  registration bookkeeping, adds no new data structures or semantics,
  and on allocation failure merely falls back to the prior state. In
  contrast, the bug is user-visible and causes incorrect flooding
  instead of local delivery, so this qualifies as a focused, important
  fix suitable for stable backporting.

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

