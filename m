Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3697356A0D;
	Sat, 12 Sep 2026 11:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211993; cv=none; b=qdt9jimSLZNvDnUDCv1yy/yRTO+gEcpPU5+kGfmGWERqJqNgIJFh+voKWKbg/rPNm64p5FMz9MFJdN/3NDG4ehgH5Nv9PaY2k0pt9KB7yDnC6xJjSpsDx188ijVcXnonZgvIPgk59bzND96pnwxLfajo4ZrPqLkd3hJwUBL2gwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211993; c=relaxed/simple;
	bh=D7ubwAMStSth9Z+ZOLZpZ4NVFtijYYtMexG51kw/DA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eo+YiqdDYe6QfKTD2LgwqLv82leEvHg0k6bVV515kNRFEqBxscTFSXIJp1UEPimUXAqYVRZiPEaggKu5n4BW1+JRjsa2DCqymHrNSVTxDJTk+2xq1oyhHPa/C/m6rI5lhEAHTdNnTWR//I1ME9ME+7VjXt3iNZ9GyfTmdEjIP4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzvHB0J4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzvHB0J4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D511F000FF;
	Sat, 12 Sep 2026 11:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211991;
	bh=rsLCYIfVnZvZZAgluzEh/yKe+TiATNwPs0aemlaWS4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kzvHB0J4msehts9oIfQOfvl//jU4yxBpD7qNPmihHk4vgboyX99EpOpJmsnR4Xocz
	 VywfcewF0mxQ8+c4sVjUv03lScm9wv2Sl/F7CPqm6GFQMmjB2SiX9YoESszY8BaEAx
	 eTxts7Vj7O4/CTgOrXX1ExUxUXy868fSvcbGjbh8=
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
Subject: [PATCH 6.18 1346/1518] net/mlx5: Move vport DOWN state check out of mlx5_query_vport_max_tx_speed()
Date: Sat, 12 Sep 2026 08:58:35 +0200
Message-ID: <20260912065653.978066744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx speed on vport state modification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c               |  5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 12 ++++--------
 include/linux/mlx5/vport.h                      |  3 ++-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a67a2aa2e101c..7c82518e9f046 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1616,14 +1616,15 @@ static int mlx5_ib_query_port_speed_from_vport(struct mlx5_core_dev *mdev,
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
index 93bd19b9c6f9a..2ee914f9ce933 100644
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
index 69c5f22c2d621..e53a5d033d72d 100644
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



