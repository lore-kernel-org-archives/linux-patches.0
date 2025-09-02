Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACB82F1FC1;
	Tue,  2 Sep 2025 13:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820634; cv=none; b=pSDQa636czDElaHFCBqfEneKFhchdzgH1NLZ50Hj7TpjPzEcxwpN6xOly2pWMFFLQr2c5TA4PusYcjAUXRIL/hMwQvLIlLtCt4dCTwtkLbqdv/j6B7y6krv5EFeUO8X3Jy72q58SjHyagT69huawi8ys0aJvf2BXDTNeS8rzCyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820634; c=relaxed/simple;
	bh=VRIr4BCIEKc7EWmgpBfAk1TJvHO6b+zd7YTi+Z9C2pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+lzPCSE4QdXAGZBaDJ6tD3DJbHHu39Mli3hHLfbWKpBqnV3XvbrP/DD2kehzayTkg+2pT70hFYqGLxcpjOScUyywjhKNPpKApa8H2YW5MjocUp3biuJaYw/O3Q9Em8JXMuf27iNURVaBjw95U3zkimuLQvbb/8pI0Lvv0kPY+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1tcUKu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1tcUKu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D6EC4CEF4;
	Tue,  2 Sep 2025 13:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820633;
	bh=VRIr4BCIEKc7EWmgpBfAk1TJvHO6b+zd7YTi+Z9C2pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1tcUKu1JDUQ16sBaP0d4L+yq6Jx7OwXPBBpo/bvgvEeT3tvgWDWh4J9PkzddTFl7
	 yzKaxiKuBp7edchZvCAUCA1mngQzftdkRhnbSAIa0hy9P3njlofqFSg+kNJ+DmFwcQ
	 1iP8SzqmVgNnEAGv2u/hU6yFEoccYoM1NRBLs114=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/33] net/mlx5e: Update and set Xon/Xoff upon MTU set
Date: Tue,  2 Sep 2025 15:21:33 +0200
Message-ID: <20250902131927.651999782@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Lazar <alazar@nvidia.com>

[ Upstream commit ceddedc969f0532b7c62ca971ee50d519d2bc0cb ]

Xon/Xoff sizes are derived from calculation that include the MTU size.
Set Xon/Xoff when MTU is set.
If Xon/Xoff fails, set the previous MTU.

Fixes: 0696d60853d5 ("net/mlx5e: Receive buffer configuration")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250825143435.598584-10-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en/port_buffer.h         | 12 ++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c   | 17 ++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
index 80af7a5ac6046..a23e3d810f3e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
@@ -63,11 +63,23 @@ struct mlx5e_port_buffer {
 	struct mlx5e_bufferx_reg  buffer[MLX5E_MAX_BUFFER];
 };
 
+#ifdef CONFIG_MLX5_CORE_EN_DCB
 int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 				    u32 change, unsigned int mtu,
 				    struct ieee_pfc *pfc,
 				    u32 *buffer_size,
 				    u8 *prio2buffer);
+#else
+static inline int
+mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
+				u32 change, unsigned int mtu,
+				void *pfc,
+				u32 *buffer_size,
+				u8 *prio2buffer)
+{
+	return 0;
+}
+#endif
 
 int mlx5e_port_query_buffer(struct mlx5e_priv *priv,
 			    struct mlx5e_port_buffer *port_buffer);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 321441e6ad328..bb7e3c80ad74e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -42,6 +42,7 @@
 #include "eswitch.h"
 #include "en.h"
 #include "en/txrx.h"
+#include "en/port_buffer.h"
 #include "en_tc.h"
 #include "en_rep.h"
 #include "en_accel/ipsec.h"
@@ -2242,9 +2243,11 @@ int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv)
 	struct mlx5e_params *params = &priv->channels.params;
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
-	u16 mtu;
+	u16 mtu, prev_mtu;
 	int err;
 
+	mlx5e_query_mtu(mdev, params, &prev_mtu);
+
 	err = mlx5e_set_mtu(mdev, params, params->sw_mtu);
 	if (err)
 		return err;
@@ -2254,6 +2257,18 @@ int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv)
 		netdev_warn(netdev, "%s: VPort MTU %d is different than netdev mtu %d\n",
 			    __func__, mtu, params->sw_mtu);
 
+	if (mtu != prev_mtu && MLX5_BUFFER_SUPPORTED(mdev)) {
+		err = mlx5e_port_manual_buffer_config(priv, 0, mtu,
+						      NULL, NULL, NULL);
+		if (err) {
+			netdev_warn(netdev, "%s: Failed to set Xon/Xoff values with MTU %d (err %d), setting back to previous MTU %d\n",
+				    __func__, mtu, err, prev_mtu);
+
+			mlx5e_set_mtu(mdev, params, prev_mtu);
+			return err;
+		}
+	}
+
 	params->sw_mtu = mtu;
 	return 0;
 }
-- 
2.50.1



