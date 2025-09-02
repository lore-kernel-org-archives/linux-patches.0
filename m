Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620D2313E23;
	Tue,  2 Sep 2025 13:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820430; cv=none; b=CboJ1+aKDXHba1TRh5KiAMD/kwTvdoM16Ycm8Ts5jl12SYnNxS6oXsNxSU+KxWKQ6nHo2ddr6eC1PbI/WjqAXxzJ24powvid8K5TJe4tnYGqesx7pzojybtaCHzR/Hd8DbKzoyqyA5FgbXLU9y7aM5ftRyzk5dk2CCN4B9afa1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820430; c=relaxed/simple;
	bh=463nhyPkks4LpuWUNxggHKG9NP9tR4+eDrqHib8UuWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOvWkdmmh8FVJTi24W7curDcfTkcaQe3ocsNnXEXTwFNlv2CqOhIuGu/49iGSUT9ielh+czk+An2pnbZayhWibMWNjdtPMPKVgr/rBJaQR5VogXrv+UQ/n2fWBXJhUEX/wzdQbPfcr58LhFXXCwoOGN9TZsx1AfV4o2pDJFjQrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdMWYlbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdMWYlbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76777C4CEF9;
	Tue,  2 Sep 2025 13:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820429;
	bh=463nhyPkks4LpuWUNxggHKG9NP9tR4+eDrqHib8UuWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdMWYlbtTA1HejJfHM8bFaJUDi5jm2sJ6pXEINgU7CDAXPHyVrD96LzVfz1GaFI9V
	 CiCCz+t6H4V51pa198ZjxlUeaFPYidZ1iEf9jA7b6+ylwTnS5gVffgBzOOEoIF5GOl
	 d6Zor6WolMR5EwDBIMrg9YJkkCq0yVxjSeG7Dlok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 26/50] net/mlx5e: Update and set Xon/Xoff upon MTU set
Date: Tue,  2 Sep 2025 15:21:17 +0200
Message-ID: <20250902131931.563208795@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 887d446354006..7612070b66160 100644
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
@@ -2640,9 +2641,11 @@ int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv)
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
@@ -2652,6 +2655,18 @@ int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv)
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



