Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179E7412269;
	Sat, 12 Sep 2026 09:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204731; cv=none; b=lTn8g+AAOBPt1NXY3L3a5ElvtJdWhHBhRA7eM1V637LtO3gHeYCOj2Crvuhiq8iSwqXoX/IqoHB9knVZk+YfaueCx7qotK7QM7xtpmaOKzVvIgTqBNJVRR+4rOA0lH71ZRGs0JQ1p4P80BqeM5KCtXZRwH/kqMFz6cl6un3ZzP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204731; c=relaxed/simple;
	bh=ezzO6cVJOabfkGMHqrgUT/0zcczAI3lRajgzrV5TlYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4+Jo10nkZHPB0113IsSSGopZZMedayJxm4qfp7AuV4SwSOn0tMxGm4g312XXrxUfrNGmQEtDCYb1RyjpdT7dOFxMFdN4ORHVs/wEt9FWDBT08p0944uUJNL1oYt4DTeXu8HcNPYRIpzsW2gQOXIjKq0LSvadMYFeDQwyQFmTMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=km/vu0qJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="km/vu0qJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E5C1F000FF;
	Sat, 12 Sep 2026 09:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204726;
	bh=MKMD/mTBFhjYoLj6kdBJC8lFTt4iiBOW2RW+sgArxwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=km/vu0qJKzkwKk6Zw2deU9HMZRLsCCAgLr3J2CHzl8lYiNl6HAt3xEE27ewozpLQp
	 0i4RfbGv+6meaBueGAlme9JBlpfVLEQEM47cSVoylw+ZR1/aALQovK7Epfw5Tctgz2
	 AWXS1+KsAZPek5Azyeh/tzUBF3pMEIjUYsM3VG7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1672/1815] net/mlx5: Move vport DOWN state check out of mlx5_query_vport_max_tx_speed()
Date: Sat, 12 Sep 2026 08:57:02 +0200
Message-ID: <20260912065728.240787768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 20f11b5cfa429ba3a2b8ef463d47e820687b4d2e ]

mlx5_query_vport_max_tx_speed() was introduced to serve the
query_port_speed path, which uses max_tx_speed == 0 when port is down.

This is incorrect for callers that need the actual configured speed
regardless of vport state, such as modify-vport-state helpers
that must preserve the speed across state transitions.

Move this logic to the caller function in the verb flow and let
mlx5_query_vport_max_tx_speed() return the raw firmware value
unconditionally.

Fixes: aaecff5e13cd ("RDMA/mlx5: Implement query_port_speed callback")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260816065015.3280733-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c               |  5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 12 ++++--------
 include/linux/mlx5/vport.h                      |  3 ++-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4ff6cca7e581a..c283a902ea7e4 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1631,14 +1631,15 @@ static int mlx5_ib_query_port_speed_from_vport(struct mlx5_core_dev *mdev,
 					       u32 port_num)
 {
 	u32 max_tx_speed;
+	u8 vport_state;
 	int err;
 
 	err = mlx5_query_vport_max_tx_speed(mdev, op_mod, vport, other_vport,
-					    &max_tx_speed);
+					    &max_tx_speed, &vport_state);
 	if (err)
 		return err;
 
-	if (max_tx_speed == 0)
+	if (vport_state == VPORT_STATE_DOWN || max_tx_speed == 0)
 		/* Value 0 indicates field not supported, fallback */
 		return mlx5_ib_query_port_speed_from_port(dev, port_num,
 							  speed);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 080f097b7bfa1..edac2d694e0f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -131,11 +131,11 @@ int mlx5_modify_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 opmod,
 }
 
 int mlx5_query_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 op_mod,
-				  u16 vport, u8 other_vport, u32 *max_tx_speed)
+				  u16 vport, u8 other_vport,
+				  u32 *max_tx_speed, u8 *state)
 {
 	u32 out[MLX5_ST_SZ_DW(query_vport_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_vport_state_in)] = {};
-	u32 state;
 	int err;
 
 	MLX5_SET(query_vport_state_in, in, opcode,
@@ -148,13 +148,9 @@ int mlx5_query_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 op_mod,
 	if (err)
 		return err;
 
-	state = MLX5_GET(query_vport_state_out, out, state);
-	if (state == VPORT_STATE_DOWN) {
-		*max_tx_speed = 0;
-		return 0;
-	}
-
 	*max_tx_speed = MLX5_GET(query_vport_state_out, out, max_tx_speed);
+	if (state)
+		*state = MLX5_GET(query_vport_state_out, out, state);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_vport_max_tx_speed);
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index ee34d3ed335f3..d5113ecb59588 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -61,7 +61,8 @@ u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport);
 int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 				  u16 vport, u8 other_vport, u8 state);
 int mlx5_query_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 op_mod,
-				  u16 vport, u8 other_vport, u32 *max_tx_speed);
+				  u16 vport, u8 other_vport,
+				  u32 *max_tx_speed, u8 *state);
 int mlx5_modify_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 opmod,
 				   u16 vport, u8 other_vport, u16 max_tx_speed);
 int mlx5_query_nic_vport_mac_address(struct mlx5_core_dev *mdev,
-- 
2.53.0



