Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2120A14AD19;
	Mon, 16 Sep 2024 12:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488339; cv=none; b=a/bY3Nm5DgdAbVKS70ibPEX/bKryeUROx+TcOp4tw8XaZJmJ5np4FrvkcxBAKFDW3DesuWfAITRneKiLvBz9T8pZiuFNAN78ZK73sZtBCe90AIpbcnM8pJ7XldMli+0lAmwTY+qjEDKheY/k69Fbo1rQqKTy7Xv228iqeS4E8/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488339; c=relaxed/simple;
	bh=dMqpoLtYXdPGBHUEbs7Y4t7aDrzsV8XPpiG47NNAGRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEgq1nnKrVgwmBsH3v0oC/Nl0aHviHn3D27IQ+7CCmu7DTerDm3b9bjt9TxW5zOOpLEij2bud+IVD3MQDCdBp7nOCEV/RKhsrl9VMniYWgrBh9XHWTZVCXknR+OSdPK/kf1l1m9PZC6m2P0R84U6JlqkmW4Lo7CK+PXTCIbdErA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upRiSsJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upRiSsJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BAAC4CEC4;
	Mon, 16 Sep 2024 12:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488338;
	bh=dMqpoLtYXdPGBHUEbs7Y4t7aDrzsV8XPpiG47NNAGRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upRiSsJlVQGWYQZCAFQr0slumQznQ+H+cw3s0UcUVLR7wHMnEr1dVtlVyhULGaHYF
	 c4wZ2m7a7puq9Pd7JSDpOqBXq4Tcr+Ed2s5VWcGAZeg/cJbi5pSRGuRuG9adl/gF3O
	 nWU+fDr58yyu6EPjLUmu5BHByDlBJA+Qh0oAMq7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 079/121] net/mlx5: Explicitly set scheduling element and TSAR type
Date: Mon, 16 Sep 2024 13:44:13 +0200
Message-ID: <20240916114231.768351714@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit c88146abe4d0f8cf659b2b8883fdc33936d2e3b8 ]

Ensure the scheduling element type and TSAR type are explicitly
initialized in the QoS rate group creation.

This prevents potential issues due to default values.

Fixes: 1ae258f8b343 ("net/mlx5: E-switch, Introduce rate limiting groups API")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index d2ebe56c3977..bcea5f06807a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -421,6 +421,7 @@ __esw_qos_create_rate_group(struct mlx5_eswitch *esw, struct netlink_ext_ack *ex
 {
 	u32 tsar_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
 	struct mlx5_esw_rate_group *group;
+	__be32 *attr;
 	u32 divider;
 	int err;
 
@@ -428,6 +429,12 @@ __esw_qos_create_rate_group(struct mlx5_eswitch *esw, struct netlink_ext_ack *ex
 	if (!group)
 		return ERR_PTR(-ENOMEM);
 
+	MLX5_SET(scheduling_context, tsar_ctx, element_type,
+		 SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR);
+
+	attr = MLX5_ADDR_OF(scheduling_context, tsar_ctx, element_attributes);
+	*attr = cpu_to_be32(TSAR_ELEMENT_TSAR_TYPE_DWRR << 16);
+
 	MLX5_SET(scheduling_context, tsar_ctx, parent_element_id,
 		 esw->qos.root_tsar_ix);
 	err = mlx5_create_scheduling_element_cmd(esw->dev,
-- 
2.43.0



