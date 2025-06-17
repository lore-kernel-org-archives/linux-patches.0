Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B121A2632;
	Tue, 17 Jun 2025 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176985; cv=none; b=OAowvr/gid0awPniCpL9wCOur+BcYtJ/c8dYLmw6nEr2hO2hfDgofdcHfL400y5SQiNf1Jhi/DkUXOB74LquqKsVte3iFPktCiFXF8hpnng26tqpLj0R7kCLtXIRjjtC/JHGdT7Vxi0txfP2l9Pc2NWHzyFfzY7BPcZ276u2eDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176985; c=relaxed/simple;
	bh=8+GVrzE0UzNKF4NIKaoGCkkgQRlsL1FzKu6j/Abhj/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8kvI9Qz2gjnTDkFGwNdlZDM7bnBimLZVDSBwwzeI+D7Jsnb8gF6CS2k7TwWTF/orEv9tyuZCTTn+0OtewyLRfj9SOiylp70MlPLUhM+ZhhshCkpfsMWUjNhBJ52Yny6WFdSc7qnB9DVy54fBKU6vvmYVH5UQuNlVGQTCxUR2b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHndvuvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHndvuvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B09C4CEE3;
	Tue, 17 Jun 2025 16:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176984;
	bh=8+GVrzE0UzNKF4NIKaoGCkkgQRlsL1FzKu6j/Abhj/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHndvuvUInN6rzPw/O/iUWzzv1W+0RGnNTProHqrWiTGpvTZWw5zJJMFvpdC+N4TD
	 mT/df2lgSadwemKZETVgIQFASUglmdVgh1AtNI4TCso23KSwVmMRHyG+RPgL0Ptqy8
	 W1ldbSBoOlz+2EQS4q0xrdSZo2TYfne7q+EXzpDQ=
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
Subject: [PATCH 6.6 326/356] net/mlx5e: Fix leak of Geneve TLV option object
Date: Tue, 17 Jun 2025 17:27:21 +0200
Message-ID: <20250617152351.271505451@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dc9b157a44993..2be9c69daad5f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1915,9 +1915,8 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	return err;
 }
 
-static bool mlx5_flow_has_geneve_opt(struct mlx5e_tc_flow *flow)
+static bool mlx5_flow_has_geneve_opt(struct mlx5_flow_spec *spec)
 {
-	struct mlx5_flow_spec *spec = &flow->attr->parse_attr->spec;
 	void *headers_v = MLX5_ADDR_OF(fte_match_param,
 				       spec->match_value,
 				       misc_parameters_3);
@@ -1956,7 +1955,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	}
 	complete_all(&flow->del_hw_done);
 
-	if (mlx5_flow_has_geneve_opt(flow))
+	if (mlx5_flow_has_geneve_opt(&attr->parse_attr->spec))
 		mlx5_geneve_tlv_option_del(priv->mdev->geneve);
 
 	if (flow->decap_route)
@@ -2456,12 +2455,13 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 
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



