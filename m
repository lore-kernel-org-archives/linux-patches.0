Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9B82D7D3A;
	Fri, 17 Oct 2025 15:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715119; cv=none; b=H3qzIvmof9ArJUE+3KNs3xKazeMCGbYP4Yd3RlhIhHXdUnZ/qjhdQqeFtBfYNIwIZbUk8327Xu73bQhnynZSMBAeTgkx69bxv4NEOZqoaWvwKill1kA0GLAdMEybIz6a2XlPKlKWsb3O0mH7vD8UFZhG16QWzyeiNkYCLflw2dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715119; c=relaxed/simple;
	bh=YEW0mpSaqr/w9p0oo7d8cd9XuXxALoc93qWCUv/eYio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QpBGX+sXM6RQdvedUrVDfkE+A0GeoD3z2fUEcmQEq09pM0zuuICcoDjPqhp1xl7ppniCqwFLBsNUDIxvDlZbd/g6RG6cABkn9/eNayyzrAy1V/dsJCaeGWaETIfDqeUjrUwQcmBq6LAM4+GahFEa76ds53Lbz7139eqj4YWJ5ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQegvwY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQegvwY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B4EC4CEE7;
	Fri, 17 Oct 2025 15:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715118;
	bh=YEW0mpSaqr/w9p0oo7d8cd9XuXxALoc93qWCUv/eYio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQegvwY5aomFSv0tSZCCVozmNd9gq/iXtC3hMKAVe9NXCYDHTp68OxS8SutFJeurx
	 fyzHXZ+fiS7cGniPVBFFGcLsCqMb1y5u5rOfYNH9ZYnJ9o9pBx9rHSGf54qgl2efTK
	 x00kUDpzU+UmdXdRFPVOgNGSAN3tDOvu8+1o9Dvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 105/371] net/mlx5: Prevent tunnel mode conflicts between FDB and NIC IPsec tables
Date: Fri, 17 Oct 2025 16:51:20 +0200
Message-ID: <20251017145205.737923710@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 7593439c13933164f701eed9c83d89358f203469 ]

When creating IPsec flow tables with tunnel mode enabled, the driver
uses mlx5_eswitch_block_encap() to prevent tunnel encapsulation
conflicts across different domains (NIC_RX/NIC_TX and FDB), since the
firmware doesn’t allow both at the same time.

Currently, the driver attempts to reserve tunnel mode unconditionally
for both NIC and FDB IPsec tables. This can lead to conflicting tunnel
mode setups, for example, if a flow table was created in the FDB
domain with tunnel offload enabled, and we later try to create another
one in the NIC, or vice versa.

To resolve this, adjust the blocking logic so that tunnel mode is only
reserved by NIC flows. This ensures that tunnel offload is exclusively
used in either the NIC or the FDB, and avoids unintended offload
conflicts.

Fixes: 1762f132d542 ("net/mlx5e: Support IPsec packet offload for RX in switchdev mode")
Fixes: c6c2bf5db4ea ("net/mlx5e: Support IPsec packet offload for TX in switchdev mode")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1759652999-858513-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c     |  8 ++++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h  |  5 +++--
 .../mellanox/mlx5/core/eswitch_offloads.c      | 18 ++++++++++--------
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 65dc3529283b6..b525f3f21c51f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -1045,7 +1045,9 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 
 	/* Create FT */
 	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_TUNNEL)
-		rx->allow_tunnel_mode = mlx5_eswitch_block_encap(mdev);
+		rx->allow_tunnel_mode =
+			mlx5_eswitch_block_encap(mdev, rx == ipsec->rx_esw);
+
 	if (rx->allow_tunnel_mode)
 		flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 	ft = ipsec_ft_create(attr.ns, attr.sa_level, attr.prio, 1, 2, flags);
@@ -1286,7 +1288,9 @@ static int tx_create(struct mlx5e_ipsec *ipsec, struct mlx5e_ipsec_tx *tx,
 		goto err_status_rule;
 
 	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_TUNNEL)
-		tx->allow_tunnel_mode = mlx5_eswitch_block_encap(mdev);
+		tx->allow_tunnel_mode =
+			mlx5_eswitch_block_encap(mdev, tx == ipsec->tx_esw);
+
 	if (tx->allow_tunnel_mode)
 		flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 	ft = ipsec_ft_create(tx->ns, attr.sa_level, attr.prio, 1, 4, flags);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 45506ad568470..53d7e33d6c0b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -851,7 +851,7 @@ void mlx5_eswitch_offloads_single_fdb_del_one(struct mlx5_eswitch *master_esw,
 					      struct mlx5_eswitch *slave_esw);
 int mlx5_eswitch_reload_ib_reps(struct mlx5_eswitch *esw);
 
-bool mlx5_eswitch_block_encap(struct mlx5_core_dev *dev);
+bool mlx5_eswitch_block_encap(struct mlx5_core_dev *dev, bool from_fdb);
 void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev);
 
 int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev);
@@ -943,7 +943,8 @@ mlx5_eswitch_reload_ib_reps(struct mlx5_eswitch *esw)
 	return 0;
 }
 
-static inline bool mlx5_eswitch_block_encap(struct mlx5_core_dev *dev)
+static inline bool
+mlx5_eswitch_block_encap(struct mlx5_core_dev *dev, bool from_fdb)
 {
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index bee906661282a..f358e8fe432cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3938,23 +3938,25 @@ int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 	return esw_inline_mode_to_devlink(esw->offloads.inline_mode, mode);
 }
 
-bool mlx5_eswitch_block_encap(struct mlx5_core_dev *dev)
+bool mlx5_eswitch_block_encap(struct mlx5_core_dev *dev, bool from_fdb)
 {
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
+	enum devlink_eswitch_encap_mode encap;
+	bool allow_tunnel = false;
 
 	if (!mlx5_esw_allowed(esw))
 		return true;
 
 	down_write(&esw->mode_lock);
-	if (esw->mode != MLX5_ESWITCH_LEGACY &&
-	    esw->offloads.encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE) {
-		up_write(&esw->mode_lock);
-		return false;
+	encap = esw->offloads.encap;
+	if (esw->mode == MLX5_ESWITCH_LEGACY ||
+	    (encap == DEVLINK_ESWITCH_ENCAP_MODE_NONE && !from_fdb)) {
+		allow_tunnel = true;
+		esw->offloads.num_block_encap++;
 	}
-
-	esw->offloads.num_block_encap++;
 	up_write(&esw->mode_lock);
-	return true;
+
+	return allow_tunnel;
 }
 
 void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev)
-- 
2.51.0



