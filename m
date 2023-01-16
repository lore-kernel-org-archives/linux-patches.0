Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291D933EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A5FC433EF;
	Mon, 16 Jan 2023 16:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884830;
	bh=4vM6BypZ49ftx98geRyPD1Xs680hffCNQX8OSli5Ba4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsqXFWoDdvWe8Qm6c+CguX+yFowzSHKMq6sigCzwHbWVRYDpy+clTEvy3eYgqIqxx
	 c4VvNPuPkKMENaoC1jeCbo69/Cw7uxwcejeC2sB5Nf97GbZHfD8EvngplXJim97i5M
	 fhtfd+9TC/RbCttLTEQnqezCQUAzfWm1XDpCVXFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/183] net/mlx5e: IPoIB, Block PKEY interfaces with less rx queues than parent
Date: Mon, 16 Jan 2023 16:51:18 +0100
Message-Id: <20230116154809.866244978@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 31c70bfe58ef09fe36327ddcced9143a16e9e83d ]

A user is able to configure an arbitrary number of rx queues when
creating an interface via netlink. This doesn't work for child PKEY
interfaces because the child interface uses the parent receive channels.

Although the child shares the parent's receive channels, the number of
rx queues is important for the channel_stats array: the parent's rx
channel index is used to access the child's channel_stats. So the array
has to be at least as large as the parent's rx queue size for the
counting to work correctly and to prevent out of bound accesses.

This patch checks for the mentioned scenario and returns an error when
trying to create the interface. The error is propagated to the user.

Fixes: be98737a4faa ("net/mlx5e: Use dynamic per-channel allocations in stats")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c   | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 3d31c59e69d4..0cf4eaf852d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -168,6 +168,15 @@ static int mlx5i_pkey_dev_init(struct net_device *dev)
 		return -EINVAL;
 	}
 
+	if (dev->num_rx_queues < parent_dev->real_num_rx_queues) {
+		mlx5_core_warn(priv->mdev,
+			       "failed to create child device with rx queues [%d] less than parent's [%d]\n",
+			       dev->num_rx_queues,
+			       parent_dev->real_num_rx_queues);
+		mlx5i_parent_put(dev);
+		return -EINVAL;
+	}
+
 	/* Get QPN to netdevice hash table from parent */
 	parent_ipriv = netdev_priv(parent_dev);
 	ipriv->qpn_htbl = parent_ipriv->qpn_htbl;
-- 
2.35.1



