Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3D339FFD;
	Fri, 24 Nov 2023 18:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4Cbtkui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C01C433C8;
	Fri, 24 Nov 2023 18:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849598;
	bh=H4K0Q6sCfWvzaXmg+GxUm+tw+Ra8SCKKvUb0s6HncNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4CbtkuiMGwWNNfDK0r8XwSzF3UdEmu32amniJNbV3h3ZKYYGmewLEUMWiluiDUFG
	 /Ks3EPDzkfl5m4n8w+03EeIYlyI43w8Ono5WG0CGYhNpFOFA94oK1Ib62JM4rkkv0G
	 bNmDvk4M11qzRs5gmI5gjnmzSEFVs4XYQuAs6NAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/530] net/mlx5e: Dont modify the peer sent-to-vport rules for IPSec offload
Date: Fri, 24 Nov 2023 17:46:27 +0000
Message-ID: <20231124172034.784327152@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit bdf788cf224f61c20a01c58c00685d394d57887f ]

As IPSec packet offload in switchdev mode is not supported with LAG,
it's unnecessary to modify those sent-to-vport rules to the peer eswitch.

Fixes: c6c2bf5db4ea ("net/mlx5e: Support IPsec packet offload for TX in switchdev mode")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20231114215846.5902-9-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index b296ac52a4397..88236e75fd901 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -984,7 +984,8 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
 	dest.vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
-	if (rep->vport == MLX5_VPORT_UPLINK && on_esw->offloads.ft_ipsec_tx_pol) {
+	if (rep->vport == MLX5_VPORT_UPLINK &&
+	    on_esw == from_esw && on_esw->offloads.ft_ipsec_tx_pol) {
 		dest.ft = on_esw->offloads.ft_ipsec_tx_pol;
 		flow_act.flags = FLOW_ACT_IGNORE_FLOW_LEVEL;
 		dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-- 
2.42.0



