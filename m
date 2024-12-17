Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F112E1F76C3;
	Tue, 17 Dec 2024 17:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456773; cv=none; b=nSqHvKjgpItol334VRj5sQkF2KL76Ce5LO4H15hjc/e7DDpAuLxU6DhdLpmD0fifcGdKSDO25WGCEBo7677N2uHuQVokAe2FtFlWF3mBHlBxFGrIzVhlr0ga5wGLy2fqicg+7KIWShGuPXgNa0Bbpg909OwnwPu3Pef+Zqe3c/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456773; c=relaxed/simple;
	bh=W4Ku+uVlX5wBD4eEsE7PqvyV/Mk42O8RNSr5UgXAYzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8+kbBRPUDKM3QWuC5qCu5Q7J+EDwiMaD5xpbbXDgBxZLn+K0jTSyCL9n7lVqblhq4o5QdWrknXo5bz592yLKYuTzx7o9cSox9Dh7GNj0PltloS1EZDgQ/EAi6MJfmwx4yWXHjh+8SscDHG6Fop6CUbc6tElg6FPif1p/KnJwP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyNr0Xy9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyNr0Xy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74443C4CED7;
	Tue, 17 Dec 2024 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456772;
	bh=W4Ku+uVlX5wBD4eEsE7PqvyV/Mk42O8RNSr5UgXAYzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyNr0Xy9tlcM2TI6wmVsaLqRMH/kB+g/scwMgqhZ7kCyj08VSU0K9oj/iWAeq/5d1
	 I1q156GRk8tFrVWrPmBj0AVfGYG8J/rvAWgOvmEweHYKBu6BwIWZtomTuWh1fpgmkq
	 lsEhu4VrLDjmcPWQzVRiZdj8fNJ4NgP5Q+96XlaQ=
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
Subject: [PATCH 6.12 143/172] team: Fix initial vlan_feature set in __team_compute_features
Date: Tue, 17 Dec 2024 18:08:19 +0100
Message-ID: <20241217170552.265073152@linuxfoundation.org>
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

[ Upstream commit 396699ac2cb1bc4e3485abb48a1e3e41956de0cd ]

Similarly as with bonding, fix the calculation of vlan_features to reuse
netdev_base_features() in order derive the set in the same way as
ndo_fix_features before iterating through the slave devices to refine the
feature set.

Fixes: 3625920b62c3 ("teaming: fix vlan_features computing")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Ido Schimmel <idosch@idosch.org>
Cc: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20241210141245.327886-4-daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index 481c8df8842f..ddd9ae7085c7 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -991,13 +991,14 @@ static void team_port_disable(struct team *team,
 static void __team_compute_features(struct team *team)
 {
 	struct team_port *port;
-	netdev_features_t vlan_features = TEAM_VLAN_FEATURES &
-					  NETIF_F_ALL_FOR_ALL;
+	netdev_features_t vlan_features = TEAM_VLAN_FEATURES;
 	netdev_features_t enc_features  = TEAM_ENC_FEATURES;
 	unsigned short max_hard_header_len = ETH_HLEN;
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
 
+	vlan_features = netdev_base_features(vlan_features);
+
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
 		vlan_features = netdev_increment_features(vlan_features,
-- 
2.39.5



