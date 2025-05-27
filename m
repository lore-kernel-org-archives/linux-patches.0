Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8046725A627;
	Tue, 27 May 2025 17:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367816; cv=none; b=Cf0DHszo7W9W88OmS0v4UAdbioKnGYyGpWIKyPNXXtC0O3DA29FgGZPcPeC5LXYDF7vUrWSuNaIJmrU5Xy4ObryqTHXs4aofF6fm9jA+mR2o6qS9KiJ3FI0+hgPttwLZ3pK0GlKC3XSIotgQyy4x6XO/vKUr5ny/+krdgOyBhpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367816; c=relaxed/simple;
	bh=jsqMzIMX2rZ2D1xgXnuWiRXFm8CJBqXX8azx66SgDxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W58iHFtamhVnymeO1aFh9A5FTZZ83UzVer6RtkjkIAOMIugAEuKux6NxwZuZ/l1fvgW3UabVAhtueHeA2PvyoHFxnfuapfvvG97oi2T89fJ0BN7d/c6qcuV2KCQKqotm5DmR+dfYQRg6FLozaP6SAYHgCnbrrtaUZx/ZPgZJi3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBzIdOtT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBzIdOtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F67C4CEE9;
	Tue, 27 May 2025 17:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367816;
	bh=jsqMzIMX2rZ2D1xgXnuWiRXFm8CJBqXX8azx66SgDxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBzIdOtTiPWhJc8Pql3mQ0PKmcAqgk8vzUA815384eV7i7r1cwBzyuPQ/QXkQqZWq
	 czyOzE2faG18YqwnT7w66RM7NzYjyRayzlBvUiROMxv+llsg4iRzBp86OmBQ+rnFZQ
	 98gAq+SMKiYsLmxK8r8IjwJaG4CFA06dlR6CknKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Tu <witu@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 507/783] net/mlx5e: set the tx_queue_len for pfifo_fast
Date: Tue, 27 May 2025 18:25:04 +0200
Message-ID: <20250527162533.785396571@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Tu <witu@nvidia.com>

[ Upstream commit a38cc5706fb9f7dc4ee3a443f61de13ce1e410ed ]

By default, the mq netdev creates a pfifo_fast qdisc. On a
system with 16 core, the pfifo_fast with 3 bands consumes
16 * 3 * 8 (size of pointer) * 1024 (default tx queue len)
= 393KB. The patch sets the tx qlen to representor default
value, 128 (1<<MLX5E_REP_PARAMS_DEF_LOG_SQ_SIZE), which
consumes 16 * 3 * 8 * 128 = 49KB, saving 344KB for each
representor at ECPF.

Signed-off-by: William Tu <witu@nvidia.com>
Reviewed-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250209101716.112774-9-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index fdff9fd8a89ec..6667ec26e079b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -886,6 +886,8 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev,
 	netdev->ethtool_ops = &mlx5e_rep_ethtool_ops;
 
 	netdev->watchdog_timeo    = 15 * HZ;
+	if (mlx5_core_is_ecpf(mdev))
+		netdev->tx_queue_len = 1 << MLX5E_REP_PARAMS_DEF_LOG_SQ_SIZE;
 
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 	netdev->hw_features    |= NETIF_F_HW_TC;
-- 
2.39.5



