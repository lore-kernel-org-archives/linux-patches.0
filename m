Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143731E9B0D;
	Mon, 13 Oct 2025 14:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367327; cv=none; b=T2Ep96UPxX4c9iHsEYZPGlnPSA8jBkCDsp+rEnxQKfgg1h8aFrc0Sse9lT578yxeSYK5OQvZ4MoOo6OsaFoabS6ciIb+nTeuayPD5Ck+UOyeH6jDfvSgOHc0PbPv8B8BcUuyfuKr2PGdPz1u9yLoyoUAkG3LzMBomVdMWKHUU/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367327; c=relaxed/simple;
	bh=RufJthQFIXN2B7rizFFO5P7ZmtjwmbZ+KU78nrvP8ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBeGDItsmoqp0GxnNNViXXdeoUMXUVeaIzsgCminKPM85CtK5asiaEPV1gdQ2hb5TM4P4hBkoprlPYSNuUS8X3Wwt2nnSCFuyx7BLmW0nBdw2vKYJRBwAfe3J6TtZk5cSGxkZcuX3jvf2vuL/eLvpNoZ0GZuuMPKWtoFNv3v0Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofp0bRGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofp0bRGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD2AC4CEE7;
	Mon, 13 Oct 2025 14:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367326;
	bh=RufJthQFIXN2B7rizFFO5P7ZmtjwmbZ+KU78nrvP8ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofp0bRGLhkU8tn0gz6matAFUPHbx+Qc7aMG+GZ3y3MvuSYq2GYL+RewZcB2wsSNa7
	 swJQW8EQH73vCp2DuoA8f7gNB8+RKsjBZUQ0/22s8rGh0q2csLvcWc1g2O2Cfp5e+U
	 DIcR/K/ej58fxnav9/kn9Noi2G0/e5tmI5UeePJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/196] Revert "net/mlx5e: Update and set Xon/Xoff upon MTU set"
Date: Mon, 13 Oct 2025 16:45:44 +0200
Message-ID: <20251013144320.882761199@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 6f5dacf88a32b3fd8b52c8ea781bf188c42aaa95 ]

This reverts commit ceddedc969f0532b7c62ca971ee50d519d2bc0cb.

Commit in question breaks the mapping of PGs to pools for some SKUs.
Specifically multi-host NICs seem to be shipped with a custom buffer
configuration which maps the lossy PG to pool 4. But the bad commit
overrides this with pool 0 which does not have sufficient buffer space
reserved. Resulting in ~40% packet loss. The commit also breaks BMC /
OOB connection completely (100% packet loss).

Revert, similarly to commit 3fbfe251cc9f ("Revert "net/mlx5e: Update and
set Xon/Xoff upon port speed set""). The breakage is exactly the same,
the only difference is that quoted commit would break the NIC immediately
on boot, and the currently reverted commit only when MTU is changed.

Note: "good" kernels do not restore the configuration, so downgrade isn't
enough to recover machines. A NIC power cycle seems to be necessary to
return to a healthy state (or overriding the relevant registers using
a custom patch).

Fixes: ceddedc969f0 ("net/mlx5e: Update and set Xon/Xoff upon MTU set")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250929181529.1848157-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en/port_buffer.h         | 12 ------------
 .../net/ethernet/mellanox/mlx5/core/en_main.c   | 17 +----------------
 2 files changed, 1 insertion(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
index a23e3d810f3e4..80af7a5ac6046 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
@@ -63,23 +63,11 @@ struct mlx5e_port_buffer {
 	struct mlx5e_bufferx_reg  buffer[MLX5E_MAX_BUFFER];
 };
 
-#ifdef CONFIG_MLX5_CORE_EN_DCB
 int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 				    u32 change, unsigned int mtu,
 				    struct ieee_pfc *pfc,
 				    u32 *buffer_size,
 				    u8 *prio2buffer);
-#else
-static inline int
-mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
-				u32 change, unsigned int mtu,
-				void *pfc,
-				u32 *buffer_size,
-				u8 *prio2buffer)
-{
-	return 0;
-}
-#endif
 
 int mlx5e_port_query_buffer(struct mlx5e_priv *priv,
 			    struct mlx5e_port_buffer *port_buffer);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7612070b66160..887d446354006 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -42,7 +42,6 @@
 #include "eswitch.h"
 #include "en.h"
 #include "en/txrx.h"
-#include "en/port_buffer.h"
 #include "en_tc.h"
 #include "en_rep.h"
 #include "en_accel/ipsec.h"
@@ -2641,11 +2640,9 @@ int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv)
 	struct mlx5e_params *params = &priv->channels.params;
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
-	u16 mtu, prev_mtu;
+	u16 mtu;
 	int err;
 
-	mlx5e_query_mtu(mdev, params, &prev_mtu);
-
 	err = mlx5e_set_mtu(mdev, params, params->sw_mtu);
 	if (err)
 		return err;
@@ -2655,18 +2652,6 @@ int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv)
 		netdev_warn(netdev, "%s: VPort MTU %d is different than netdev mtu %d\n",
 			    __func__, mtu, params->sw_mtu);
 
-	if (mtu != prev_mtu && MLX5_BUFFER_SUPPORTED(mdev)) {
-		err = mlx5e_port_manual_buffer_config(priv, 0, mtu,
-						      NULL, NULL, NULL);
-		if (err) {
-			netdev_warn(netdev, "%s: Failed to set Xon/Xoff values with MTU %d (err %d), setting back to previous MTU %d\n",
-				    __func__, mtu, err, prev_mtu);
-
-			mlx5e_set_mtu(mdev, params, prev_mtu);
-			return err;
-		}
-	}
-
 	params->sw_mtu = mtu;
 	return 0;
 }
-- 
2.51.0



