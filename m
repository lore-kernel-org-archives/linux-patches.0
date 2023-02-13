Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C898F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77560C433D2;
	Mon, 13 Feb 2023 14:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300059;
	bh=FaOdq5LEdadE73UAy6b3zzHqbY1BPTBPI+nVo7azeiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgMdLPMviIy2muZyiC8ml5CuwywY3ofX/Dg3xHKkDFEQbFDN7SprDRZ0NyA77F3xn
	 vtxbpw2vS81cmxCfzzQlG1uoSI8BEseEpNViBmODHhARK4fgvLG2EoBl2Vr2YQrNCU
	 AFHezX5dHXpO1m7iHwUNeoxEUm0SrA+PUVqZR5Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/114] net/mlx5e: IPoIB, Show unknown speed instead of error
Date: Mon, 13 Feb 2023 15:48:03 +0100
Message-Id: <20230213144744.664380248@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

[ Upstream commit 8aa5f171d51c1cb69e5e3106df4dd1a446102823 ]

ethtool is returning an error for unknown speeds for the IPoIB interface:

$ ethtool ib0
netlink error: failed to retrieve link settings
netlink error: Invalid argument
netlink error: failed to retrieve link settings
netlink error: Invalid argument
Settings for ib0:
Link detected: no

After this change, ethtool will return success and show "unknown speed":

$ ethtool ib0
Settings for ib0:
Supported ports: [  ]
Supported link modes:   Not reported
Supported pause frame use: No
Supports auto-negotiation: No
Supported FEC modes: Not reported
Advertised link modes:  Not reported
Advertised pause frame use: No
Advertised auto-negotiation: No
Advertised FEC modes: Not reported
Speed: Unknown!
Duplex: Full
Auto-negotiation: off
Port: Other
PHYAD: 0
Transceiver: internal
Link detected: no

Fixes: eb234ee9d541 ("net/mlx5e: IPoIB, Add support for get_link_ksettings in ethtool")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index eff92dc0927c1..e09518f887a04 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -189,16 +189,16 @@ static inline int mlx5_ptys_rate_enum_to_int(enum mlx5_ptys_rate rate)
 	}
 }
 
-static int mlx5i_get_speed_settings(u16 ib_link_width_oper, u16 ib_proto_oper)
+static u32 mlx5i_get_speed_settings(u16 ib_link_width_oper, u16 ib_proto_oper)
 {
 	int rate, width;
 
 	rate = mlx5_ptys_rate_enum_to_int(ib_proto_oper);
 	if (rate < 0)
-		return -EINVAL;
+		return SPEED_UNKNOWN;
 	width = mlx5_ptys_width_enum_to_int(ib_link_width_oper);
 	if (width < 0)
-		return -EINVAL;
+		return SPEED_UNKNOWN;
 
 	return rate * width;
 }
@@ -221,16 +221,13 @@ static int mlx5i_get_link_ksettings(struct net_device *netdev,
 	ethtool_link_ksettings_zero_link_mode(link_ksettings, advertising);
 
 	speed = mlx5i_get_speed_settings(ib_link_width_oper, ib_proto_oper);
-	if (speed < 0)
-		return -EINVAL;
+	link_ksettings->base.speed = speed;
+	link_ksettings->base.duplex = speed == SPEED_UNKNOWN ? DUPLEX_UNKNOWN : DUPLEX_FULL;
 
-	link_ksettings->base.duplex = DUPLEX_FULL;
 	link_ksettings->base.port = PORT_OTHER;
 
 	link_ksettings->base.autoneg = AUTONEG_DISABLE;
 
-	link_ksettings->base.speed = speed;
-
 	return 0;
 }
 
-- 
2.39.0



