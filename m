Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D342EDD6B;
	Tue,  2 Sep 2025 13:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820656; cv=none; b=gzfOzYJ8HGXqS2zYmeonFAaC4LEA5D/B9tuq0RY9iImLqdOMJypdJ27LeRhiiWm7DtSlaJx69y9nRgaHr5VmycXD/b5djbQ3z2mRSwYeNitXdwHS1DJD0X1yXFVF7bYMacYve47wG42L4a0RNPT2Hl/Wp8SLRLTbSpP+C+U2zvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820656; c=relaxed/simple;
	bh=m5hCIGruwc8KJEcGz+hE7ZbVwybC/30JmVVE12AyGXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRroh4ObGGUE5xbJSeeZ78kV/trMlRjTyU5ZGFbqBMhGc4bVl2rkfcO5jnqbTeO8RzliVNhlNWTYEQIZvj3OJl+AGO0CepEjoWNBCLa0167bqS2ujvyFWp5Up0W9lm+f0rVxC2KyU76bEzPrHjK+YvThYaZBit+W/uw6hWcB7/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWS77Sz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWS77Sz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41347C4CEED;
	Tue,  2 Sep 2025 13:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820656;
	bh=m5hCIGruwc8KJEcGz+hE7ZbVwybC/30JmVVE12AyGXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWS77Sz+Oix7l4dFWD9CHixyx4f5nRpj9dJazVrfux9vp8JxKqSrTHodJHqQ48MJb
	 Fy0ZdD8bVB8xPvqpUux2E10KC9kCZPkThk3b5vDKsZ2ycAyjdJVDL5SoNXWtgoUqSG
	 GDCarkkzXZ3adxCGoQXHGlgS3silb1ENvwSsH2Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/34] net/mlx5e: Update and set Xon/Xoff upon MTU set
Date: Tue,  2 Sep 2025 15:21:39 +0200
Message-ID: <20250902131927.145967293@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c3ff1fc577a7c..cef60bc2589cc 100644
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
@@ -2874,9 +2875,11 @@ int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv)
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
@@ -2886,6 +2889,18 @@ int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv)
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



