Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD6C3126CA;
	Tue,  2 Sep 2025 13:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819969; cv=none; b=GkZHVa9jBMtm0y49sTpZ1E9PYJxWF8MZDcSzKEcfH6IvhUW05dYAwURhjYAVjumCYC/TfgnQ4OvCI8THT0tyo/Fl6aG3F6wgIJNCVaozmAgesjrajdOKiokSdce/CCsp91h0x30HHmT91FD6Tmwi9GkI4tLLX8mwBkYO64bwmbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819969; c=relaxed/simple;
	bh=tXJup5migEiY0HBtdY5TNNicGKrzTzvrzK2/BvJd8yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eo6bLnjTpoD9pX6O8sW6YfgsFoKG6jYxmn+iDtglDgMniaoIj7S0Tvytrf5VBOYm7jq40Yj9yypaIOhDmI+2S26EeMceiiBbgI2xanewL0UQ4dJNTJNBiH6AEfEjrkZTS+2tRsiwxQNBn24+vB3wCcEReQd5HRaKkY4JhlOoDw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrWGjray; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrWGjray"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3797C4CEED;
	Tue,  2 Sep 2025 13:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819969;
	bh=tXJup5migEiY0HBtdY5TNNicGKrzTzvrzK2/BvJd8yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrWGjrayhXpr+tN+rHlTCwN5+MI+2T67PB3T6330oiatP31b9MVbZtk/u4iJKr72+
	 vc13sg+oJgyXRbiWLu5GcALk6eU6BATU4n2d6eKBh9PmVs7Cm72SSql5dtbTOGtB/1
	 WxEGvBtooax/NjuFIEn4qqATwBrkvqXWKcxKeO3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 51/95] net/mlx5e: Update and set Xon/Xoff upon MTU set
Date: Tue,  2 Sep 2025 15:20:27 +0200
Message-ID: <20250902131941.564713114@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f4a19ffbb641c..66d276a1be836 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
@@ -66,11 +66,23 @@ struct mlx5e_port_buffer {
 	struct mlx5e_bufferx_reg  buffer[MLX5E_MAX_NETWORK_BUFFER];
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
index 4a2f58a9d7066..de2327ffb0f78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -47,6 +47,7 @@
 #include "en.h"
 #include "en/dim.h"
 #include "en/txrx.h"
+#include "en/port_buffer.h"
 #include "en_tc.h"
 #include "en_rep.h"
 #include "en_accel/ipsec.h"
@@ -2917,9 +2918,11 @@ int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv)
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
@@ -2929,6 +2932,18 @@ int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv)
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



