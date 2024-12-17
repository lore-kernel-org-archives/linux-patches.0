Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DDD1F8AE4;
	Tue, 17 Dec 2024 17:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456705; cv=none; b=KU/4B7IZOTX2azDjNtdwR4otvBO1+ySvL2Dc6ygZSCCtNfcWr0kDx4ODnu6xSPVqyGchZA8nRLQX5uYaTj/o4XGfCIcmai6ZXCjBIjCuOMEfusN4SHMLIXuRV33BYfU0NLu1h/gbU0j/TCpSRncwmk1LCuhmNpXzSt/KcZmICDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456705; c=relaxed/simple;
	bh=LAy7dNM609o0hbROs+gQhf0tmAyZZpy/S/8fA9IhJbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sn5vHeWJuKXAI+hu+/mkUD9cx5fOwRSaQtmjXajycEvKIOosVt28NABT/6j0p4vpJSVqXpjNJFpV+S7Evrqe0CiHn7NYr9VgstL/Kj87FW9lL72sUpvOfSibTuqU7WxF3PUD3dcQOpV9VRtHnh0Og8qaP0WOdzA5REUHveWT0aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWyvfKyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWyvfKyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0713DC4CED3;
	Tue, 17 Dec 2024 17:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456704;
	bh=LAy7dNM609o0hbROs+gQhf0tmAyZZpy/S/8fA9IhJbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWyvfKyrJglPYnCqUyZoc1OyUTLzucZ4YHkU01OdDkg8hNdoTct0fyy7BMz0r0o7K
	 3/0IJ0e/FmDO1SRBwupaRFW0aTZaNDBa3pfozbntbq4MJp1tj7xJ7gbkss05DLKXzI
	 1j6CdrPcwu4QKonZ/baA01egj8nEroQzfF0Smagw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@idosch.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 140/172] net, team, bonding: Add netdev_base_features helper
Date: Tue, 17 Dec 2024 18:08:16 +0100
Message-ID: <20241217170552.145444595@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit d2516c3a53705f783bb6868df0f4a2b977898a71 ]

Both bonding and team driver have logic to derive the base feature
flags before iterating over their slave devices to refine the set
via netdev_increment_features().

Add a small helper netdev_base_features() so this can be reused
instead of having it open-coded multiple times.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Ido Schimmel <idosch@idosch.org>
Cc: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20241210141245.327886-1-daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: d064ea7fe2a2 ("bonding: Fix initial {vlan,mpls}_feature set in bond_compute_features")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 4 +---
 drivers/net/team/team_core.c    | 3 +--
 include/linux/netdev_features.h | 7 +++++++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 15e0f14d0d49..166910693fd7 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1520,9 +1520,7 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	struct slave *slave;
 
 	mask = features;
-
-	features &= ~NETIF_F_ONE_FOR_ALL;
-	features |= NETIF_F_ALL_FOR_ALL;
+	features = netdev_base_features(features);
 
 	bond_for_each_slave(bond, slave, iter) {
 		features = netdev_increment_features(features,
diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index 18191d5a8bd4..481c8df8842f 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -2012,8 +2012,7 @@ static netdev_features_t team_fix_features(struct net_device *dev,
 	netdev_features_t mask;
 
 	mask = features;
-	features &= ~NETIF_F_ONE_FOR_ALL;
-	features |= NETIF_F_ALL_FOR_ALL;
+	features = netdev_base_features(features);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 66e7d26b70a4..11be70a7929f 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -253,4 +253,11 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 				 NETIF_F_GSO_UDP_TUNNEL |		\
 				 NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
+static inline netdev_features_t netdev_base_features(netdev_features_t features)
+{
+	features &= ~NETIF_F_ONE_FOR_ALL;
+	features |= NETIF_F_ALL_FOR_ALL;
+	return features;
+}
+
 #endif	/* _LINUX_NETDEV_FEATURES_H */
-- 
2.39.5



