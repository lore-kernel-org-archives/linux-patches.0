Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90652FA62E;
	Tue, 17 Jun 2025 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179333; cv=none; b=YsZortWQL6z/WWtEl9RY+DTOd/8+KFqlMOphPqOd1e3hZ6MMqFPEXDyhVDcvAjB6ds1dDgQqiswW313p7tN7uyvcpfapcU2beCqnyCDj0s0SQXIBHcxwTdXTZHwXL25LQJs9qVft3fcogQli2j15pfn3XQio+Nk4O8bnf1OC/aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179333; c=relaxed/simple;
	bh=1AQht9g3DwYsJKSRQpBEzbgiOQPxGBLH3hPOkQV/MLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVfQfqt0w8AutbKx+zvAvbsPY242umoekdWAhB06rm4XcoyCPqwI9im9UjkmD/O9BnkBsk0cxgRSDcihYZAN45lvN+bvVvOWMvM2iMa0oKf2tryODiULG4+Me3pbZOYysjgab/q0USZ/x8LXoaq6uYNbHGGoJ9ZGiycz4roNBFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmaWHvGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmaWHvGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EAEC4CEE3;
	Tue, 17 Jun 2025 16:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179332;
	bh=1AQht9g3DwYsJKSRQpBEzbgiOQPxGBLH3hPOkQV/MLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmaWHvGt2PvKhExfSqOuqSEO2fJ0NwfWap0dJkZG1aqnsuzu8pys4U1JuMhQ2m2VC
	 rFhhIjr+qfH26YhrJZwq9ssu49r9lV7FZDy+2H7Alsp6d8zZhP0gZatiTceLTTAMFA
	 htP4Tfao/6euID87DNFwQhrNFXPhNYiTT3BA8G3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Alex Lazar <alazar@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 714/780] net/mlx5e: Fix leak of Geneve TLV option object
Date: Tue, 17 Jun 2025 17:27:02 +0200
Message-ID: <20250617152520.567468345@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit aa9c44b842096c553871bc68a8cebc7861fa192b ]

Previously, a unique tunnel id was added for the matching on TC
non-zero chains, to support inner header rewrite with goto action.
Later, it was used to support VF tunnel offload for vxlan, then for
Geneve and GRE. To support VF tunnel, a temporary mlx5_flow_spec is
used to parse tunnel options. For Geneve, if there is TLV option, a
object is created, or refcnt is added if already exists. But the
temporary mlx5_flow_spec is directly freed after parsing, which causes
the leak because no information regarding the object is saved in
flow's mlx5_flow_spec, which is used to free the object when deleting
the flow.

To fix the leak, call mlx5_geneve_tlv_option_del() before free the
temporary spec if it has TLV object.

Fixes: 521933cdc4aa ("net/mlx5e: Support Geneve and GRE with VF tunnel offload")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Alex Lazar <alazar@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250610151514.1094735-9-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f1d908f611349..fef418e1ed1a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2028,9 +2028,8 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	return err;
 }
 
-static bool mlx5_flow_has_geneve_opt(struct mlx5e_tc_flow *flow)
+static bool mlx5_flow_has_geneve_opt(struct mlx5_flow_spec *spec)
 {
-	struct mlx5_flow_spec *spec = &flow->attr->parse_attr->spec;
 	void *headers_v = MLX5_ADDR_OF(fte_match_param,
 				       spec->match_value,
 				       misc_parameters_3);
@@ -2069,7 +2068,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	}
 	complete_all(&flow->del_hw_done);
 
-	if (mlx5_flow_has_geneve_opt(flow))
+	if (mlx5_flow_has_geneve_opt(&attr->parse_attr->spec))
 		mlx5_geneve_tlv_option_del(priv->mdev->geneve);
 
 	if (flow->decap_route)
@@ -2574,12 +2573,13 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 
 		err = mlx5e_tc_tun_parse(filter_dev, priv, tmp_spec, f, match_level);
 		if (err) {
-			kvfree(tmp_spec);
 			NL_SET_ERR_MSG_MOD(extack, "Failed to parse tunnel attributes");
 			netdev_warn(priv->netdev, "Failed to parse tunnel attributes");
-			return err;
+		} else {
+			err = mlx5e_tc_set_attr_rx_tun(flow, tmp_spec);
 		}
-		err = mlx5e_tc_set_attr_rx_tun(flow, tmp_spec);
+		if (mlx5_flow_has_geneve_opt(tmp_spec))
+			mlx5_geneve_tlv_option_del(priv->mdev->geneve);
 		kvfree(tmp_spec);
 		if (err)
 			return err;
-- 
2.39.5



