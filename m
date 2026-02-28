Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04AF333447
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301268; cv=none; b=B7go0IGsDIGvXrQQ1eGNaSf4Tjs7423RhNfGn2xAZdeqWQW7yecISRGqf3sS0sQ8ERMQBwCGgIwJgNnGo3HbJiQfRDcmRuFlVjOtJfoAi0ATIhaV6Wh9cq59Us1gRza6aCYJvlyGe1kpLrAWyZ9Mi5mOUb67tTAgH8wypTIi8PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301268; c=relaxed/simple;
	bh=m8rcSrTq8JiI7juCypbu6cgYnNFLbEXxQCOdNeq9dtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1yQVi3uTH9yaMERUrdXNI/R/JNlpXkHjAQAunjKaMHg42bvZRWyZUQ909DKNY+vbZKRK1us5r7W0+4qws5DXamVthDn74Dmw74DS4eRqqDPm6+wq6BJIjdjSOYa4NPlR34T38RkoWkJHl3kTt+no2D7RoeAeYHjF+qJcQywAuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lg8RK+R9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lg8RK+R9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4E9C116D0;
	Sat, 28 Feb 2026 17:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301267;
	bh=m8rcSrTq8JiI7juCypbu6cgYnNFLbEXxQCOdNeq9dtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lg8RK+R9xHu3izbFcHLZUPHJq91Q2nM7IqgBmWquGDMw+OLap1nXOtpUhVj3vfutA
	 VvBRq4BIdXOOJjdPF3puNwUC72J9Y7YDKnuc5EhsqfH3aTtG2PrDmSDEWZdT6GCpH4
	 7Ra0vWEDZVSRCdwLJqMI/DrxOcTwr7H5D+ZmjUmYxfk2b4qz+Ns7B1SU3kitpg3xc2
	 tlV86LBPmfm2dNJK0czrfMm7EQHkmDMyhLSZL3/X+ij+nQBdELqxPIyAyyA7/BiSv2
	 4A6XUBqT7hTWq6QZf21Xzxqhgo93DF6Liaa0AWDCGNegt1Rtp3f63ywhE2d0S4MDfG
	 rdYRNajVacwjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 451/752] net/mlx5e: Fix "scheduling while atomic" in IPsec MAC address query
Date: Sat, 28 Feb 2026 12:42:42 -0500
Message-ID: <20260228174750.1542406-451-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 859380694f434597407632c29f30fdb5e763e6cc ]

Fix a "scheduling while atomic" bug in mlx5e_ipsec_init_macs() by
replacing mlx5_query_mac_address() with ether_addr_copy() to get the
local MAC address directly from netdev->dev_addr.

The issue occurs because mlx5_query_mac_address() queries the hardware
which involves mlx5_cmd_exec() that can sleep, but it is called from
the mlx5e_ipsec_handle_event workqueue which runs in atomic context.

The MAC address is already available in netdev->dev_addr, so no need
to query hardware. This avoids the sleeping call and resolves the bug.

Call trace:
  BUG: scheduling while atomic: kworker/u112:2/69344/0x00000200
  __schedule+0x7ab/0xa20
  schedule+0x1c/0xb0
  schedule_timeout+0x6e/0xf0
  __wait_for_common+0x91/0x1b0
  cmd_exec+0xa85/0xff0 [mlx5_core]
  mlx5_cmd_exec+0x1f/0x50 [mlx5_core]
  mlx5_query_nic_vport_mac_address+0x7b/0xd0 [mlx5_core]
  mlx5_query_mac_address+0x19/0x30 [mlx5_core]
  mlx5e_ipsec_init_macs+0xc1/0x720 [mlx5_core]
  mlx5e_ipsec_build_accel_xfrm_attrs+0x422/0x670 [mlx5_core]
  mlx5e_ipsec_handle_event+0x2b9/0x460 [mlx5_core]
  process_one_work+0x178/0x2e0
  worker_thread+0x2ea/0x430

Fixes: cee137a63431 ("net/mlx5e: Handle ESN update events")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260224114652.1787431-6-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 9c7064187ed0f..f03507a522b4f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -259,7 +259,6 @@ static void mlx5e_ipsec_init_limits(struct mlx5e_ipsec_sa_entry *sa_entry,
 static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 				  struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
-	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	struct mlx5e_ipsec_addr *addrs = &attrs->addrs;
 	struct net_device *netdev = sa_entry->dev;
 	struct xfrm_state *x = sa_entry->x;
@@ -276,7 +275,7 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	    attrs->type != XFRM_DEV_OFFLOAD_PACKET)
 		return;
 
-	mlx5_query_mac_address(mdev, addr);
+	ether_addr_copy(addr, netdev->dev_addr);
 	switch (attrs->dir) {
 	case XFRM_DEV_OFFLOAD_IN:
 		src = attrs->dmac;
-- 
2.51.0

