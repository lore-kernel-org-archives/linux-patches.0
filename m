Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3741D34164F;
	Tue, 26 Aug 2025 11:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208155; cv=none; b=DRnAwewDH8Q4niCavRF4stac/e/aZa00QBBGztUo/OraV5cfE0J1GZEyH6tJSAfTOBZf8vvZIOuriiARpRTSyPh7y8qzbw/C0qkeCW4nk03k7NnwAjouZDmw45BK7hXxwvzFwMntnEiPFIfKwJs3J+oZlG/hLFqyUHt7LNIGTQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208155; c=relaxed/simple;
	bh=1UbWemT8sQUeMnNuGx7bCxMfwxM2xObP735a62p+kKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eu0Bjy9Ibm+jEMI3MgYWpv3RXOd4umwQFruDYylBD0xCY4HGwXIub9P21q1w6VzedzXh0gdSTGN23BTZ5mSIJ7a1+Q4hL9WjnYFR0G1R9xr+1a5y63aK6aB0/HujT7m1F5qVX16C+3+w62HFNpmt5UQ4U2MhqS9e6fFvnwp+ZAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufhA4fhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufhA4fhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFC8C4CEF4;
	Tue, 26 Aug 2025 11:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208155;
	bh=1UbWemT8sQUeMnNuGx7bCxMfwxM2xObP735a62p+kKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufhA4fhWcjQGzrKuuigExvfz4Y8mA/EM+aWagMNRUqoRUUPj70lcKBdaSOJ/B74uN
	 +M+JMJsLxQxzgbXnwCHklpRz9crZIS5s6Auwj1l7D1vw78XqBFRtV6ll5zl62zveVt
	 g62pIR8nm1/YTZbJRE6eE1ad+aRHTVFP8pWr3ADI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 450/457] net/mlx5e: Query FW for buffer ownership
Date: Tue, 26 Aug 2025 13:12:14 +0200
Message-ID: <20250826110948.407216667@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Lazar <alazar@nvidia.com>

[ Upstream commit 451d2849ea66659040b59ae3cb7e50cc97404733 ]

The SW currently saves local buffer ownership when setting
the buffer.
This means that the SW assumes it has ownership of the buffer
after the command is set.

If setting the buffer fails and we remain in FW ownership,
the local buffer ownership state incorrectly remains as SW-owned.
This leads to incorrect behavior in subsequent PFC commands,
causing failures.

Instead of saving local buffer ownership in SW,
query the FW for buffer ownership when setting the buffer.
This ensures that the buffer ownership state is accurately
reflected, avoiding the issues caused by incorrect ownership
states.

Fixes: ecdf2dadee8e ("net/mlx5e: Receive buffer support for DCBX")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250820133209.389065-8-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/dcbnl.h    |  1 -
 .../ethernet/mellanox/mlx5/core/en_dcbnl.c    | 12 ++++++++---
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  2 ++
 .../net/ethernet/mellanox/mlx5/core/port.c    | 20 +++++++++++++++++++
 4 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h b/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h
index b59aee75de94..2c98a5299df3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h
@@ -26,7 +26,6 @@ struct mlx5e_dcbx {
 	u8                         cap;
 
 	/* Buffer configuration */
-	bool                       manual_buffer;
 	u32                        cable_len;
 	u32                        xoff;
 	u16                        port_buff_cell_sz;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 5fe016e477b3..d166c0d5189e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -362,6 +362,7 @@ static int mlx5e_dcbnl_ieee_getpfc(struct net_device *dev,
 static int mlx5e_dcbnl_ieee_setpfc(struct net_device *dev,
 				   struct ieee_pfc *pfc)
 {
+	u8 buffer_ownership = MLX5_BUF_OWNERSHIP_UNKNOWN;
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u32 old_cable_len = priv->dcbx.cable_len;
@@ -389,7 +390,14 @@ static int mlx5e_dcbnl_ieee_setpfc(struct net_device *dev,
 
 	if (MLX5_BUFFER_SUPPORTED(mdev)) {
 		pfc_new.pfc_en = (changed & MLX5E_PORT_BUFFER_PFC) ? pfc->pfc_en : curr_pfc_en;
-		if (priv->dcbx.manual_buffer)
+		ret = mlx5_query_port_buffer_ownership(mdev,
+						       &buffer_ownership);
+		if (ret)
+			netdev_err(dev,
+				   "%s, Failed to get buffer ownership: %d\n",
+				   __func__, ret);
+
+		if (buffer_ownership == MLX5_BUF_OWNERSHIP_SW_OWNED)
 			ret = mlx5e_port_manual_buffer_config(priv, changed,
 							      dev->mtu, &pfc_new,
 							      NULL, NULL);
@@ -982,7 +990,6 @@ static int mlx5e_dcbnl_setbuffer(struct net_device *dev,
 	if (!changed)
 		return 0;
 
-	priv->dcbx.manual_buffer = true;
 	err = mlx5e_port_manual_buffer_config(priv, changed, dev->mtu, NULL,
 					      buffer_size, prio2buffer);
 	return err;
@@ -1252,7 +1259,6 @@ void mlx5e_dcbnl_initialize(struct mlx5e_priv *priv)
 		priv->dcbx.cap |= DCB_CAP_DCBX_HOST;
 
 	priv->dcbx.port_buff_cell_sz = mlx5e_query_port_buffers_cell_size(priv);
-	priv->dcbx.manual_buffer = false;
 	priv->dcbx.cable_len = MLX5E_DEFAULT_CABLE_LEN;
 
 	mlx5e_ets_init(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 2e02bdea8361..c2f6d205ddb1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -358,6 +358,8 @@ int mlx5_query_port_dcbx_param(struct mlx5_core_dev *mdev, u32 *out);
 int mlx5_set_port_dcbx_param(struct mlx5_core_dev *mdev, u32 *in);
 int mlx5_set_trust_state(struct mlx5_core_dev *mdev, u8 trust_state);
 int mlx5_query_trust_state(struct mlx5_core_dev *mdev, u8 *trust_state);
+int mlx5_query_port_buffer_ownership(struct mlx5_core_dev *mdev,
+				     u8 *buffer_ownership);
 int mlx5_set_dscp2prio(struct mlx5_core_dev *mdev, u8 dscp, u8 prio);
 int mlx5_query_dscp2prio(struct mlx5_core_dev *mdev, u8 *dscp2prio);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 549f1066d2a5..2d7adf7444ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -968,6 +968,26 @@ int mlx5_query_trust_state(struct mlx5_core_dev *mdev, u8 *trust_state)
 	return err;
 }
 
+int mlx5_query_port_buffer_ownership(struct mlx5_core_dev *mdev,
+				     u8 *buffer_ownership)
+{
+	u32 out[MLX5_ST_SZ_DW(pfcc_reg)] = {};
+	int err;
+
+	if (!MLX5_CAP_PCAM_FEATURE(mdev, buffer_ownership)) {
+		*buffer_ownership = MLX5_BUF_OWNERSHIP_UNKNOWN;
+		return 0;
+	}
+
+	err = mlx5_query_pfcc_reg(mdev, out, sizeof(out));
+	if (err)
+		return err;
+
+	*buffer_ownership = MLX5_GET(pfcc_reg, out, buf_ownership);
+
+	return 0;
+}
+
 int mlx5_set_dscp2prio(struct mlx5_core_dev *mdev, u8 dscp, u8 prio)
 {
 	int sz = MLX5_ST_SZ_BYTES(qpdpm_reg);
-- 
2.50.1



