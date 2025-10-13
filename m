Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045A327A477;
	Mon, 13 Oct 2025 15:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368610; cv=none; b=HGjwMU0M2hit91cCjBpUGxrGfiP2c8xXtY30BK50wNt49nRSUeT4MHl36WCL08Iz3RBw0hFavE4d2jUS158fwQ3tyi7pjIsaqYeKaPF/8WONSRVajMKrGuX/PHzqo45yVC+qCcf5/mgbvavYxEYlrfUcQifj+JWlikRDDI9ppXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368610; c=relaxed/simple;
	bh=A5PEwCawLeYuPx+mRnoWJYYF+YizQ+uEQXz3hunMdew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0VVHjo4szfTull3+LdFyQb+bYtOsHlv7+noGnJhn4C0p1hknr9IUfe0fA8FyZGNnZgvc/CCXiQEJLIoSAeIbSlqxtA1SOFCh44tGLFsRWhbpD74m8gS2Q6Y1fKYs/NM7dSxd9ggcJvIISqH4YgjvKD8gyqd1xTR+JQKrrySH+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKQe5KGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKQe5KGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C77C4CEE7;
	Mon, 13 Oct 2025 15:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368609;
	bh=A5PEwCawLeYuPx+mRnoWJYYF+YizQ+uEQXz3hunMdew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKQe5KGRGTgK44BIviCFUQau/LGPjlzWNDyase++t1Gfq5jU6Xo4XQx3RQ24Vpbv6
	 WT4VYneRsSdvffvwQ9f0AuICjT5l8Q84Km1//rLAyuVIXAIiqCxbviaVTN0VoMhG5h
	 p5wHFjiQXHQazY90H0po+cvJ+Kw/tZQVooXcmxAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/262] Revert "net/mlx5e: Update and set Xon/Xoff upon MTU set"
Date: Mon, 13 Oct 2025 16:46:03 +0200
Message-ID: <20251013144334.202712539@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 66d276a1be836..f4a19ffbb641c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
@@ -66,23 +66,11 @@ struct mlx5e_port_buffer {
 	struct mlx5e_bufferx_reg  buffer[MLX5E_MAX_NETWORK_BUFFER];
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
index de2327ffb0f78..4a2f58a9d7066 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -47,7 +47,6 @@
 #include "en.h"
 #include "en/dim.h"
 #include "en/txrx.h"
-#include "en/port_buffer.h"
 #include "en_tc.h"
 #include "en_rep.h"
 #include "en_accel/ipsec.h"
@@ -2918,11 +2917,9 @@ int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv)
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
@@ -2932,18 +2929,6 @@ int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv)
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



