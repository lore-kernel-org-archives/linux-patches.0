Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674C615A4B0;
	Mon, 29 Jan 2024 17:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548152; cv=none; b=dklWZlUupnw7eRnJODvYGOT4hAAgfy3KptdrTT68YP2AGIFHzb99+Yfq1raZqy4GhPr/Ap2rVveug8Gf2Hx2y4Rc07+bFDVHkjFxZyKXHjfXiX3e9OqOSgDyGrKUc8WMMsHCVKv0M6bfaSfi1p6rmomLzMESigA5/jpWIQe1Jqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548152; c=relaxed/simple;
	bh=2idfw3NMgyLL/YM/r36x8K44+a+RXyk1Ep2culI+/GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Om7TsBrzLIDL/QvVND8kiR8+TO/4o7cP1N8EG3dsWDoKJWbNLKi/n4PDbujZR9Q6jJDMhE49f8FwQErWuY0IPVu8LB0O1jVt/jq0FErf1pv+M3WMLmLcjF8mMExe6Is3X6/6P2s5OnnjQMEq9x++gmeLE4dadl58aNfl1W8kiPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=va0kQ6ZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="va0kQ6ZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFFBC433F1;
	Mon, 29 Jan 2024 17:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548152;
	bh=2idfw3NMgyLL/YM/r36x8K44+a+RXyk1Ep2culI+/GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=va0kQ6ZGoHw9FhHmSktSu7eomn1EXRSem2TrIbeJN/eQD46FfOjzrVLSW2fWCxtqA
	 xC4fHl3Wv5vJvCM62fRNwgdk1Zkf7vIyoFlQFFDYgbzoFBKtUWyI5VhFd3L93Am2Cf
	 jU0kLIQqNhtO7HVY7zegR0r3iYj8bPluxilF7GOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 190/346] net/mlx5: Bridge, fix multicast packets sent to uplink
Date: Mon, 29 Jan 2024 09:03:41 -0800
Message-ID: <20240129170021.989595126@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit ec7cc38ef9f83553102e84c82536971a81630739 ]

To enable multicast packets which are offloaded in bridge multicast
offload mode to be sent also to uplink, FTE bit uplink_hairpin_en should
be set. Add this bit to FTE for the bridge multicast offload rules.

Fixes: 18c2916cee12 ("net/mlx5: Bridge, snoop igmp/mld packets")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c           | 2 ++
 include/linux/mlx5/fs.h                                    | 1 +
 include/linux/mlx5/mlx5_ifc.h                              | 2 +-
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
index a7ed87e9d842..22dd30cf8033 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
@@ -83,6 +83,7 @@ mlx5_esw_bridge_mdb_flow_create(u16 esw_owner_vhca_id, struct mlx5_esw_bridge_md
 		i++;
 	}
 
+	rule_spec->flow_context.flags |= FLOW_CONTEXT_UPLINK_HAIRPIN_EN;
 	rule_spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
 	dmac_v = MLX5_ADDR_OF(fte_match_param, rule_spec->match_value, outer_headers.dmac_47_16);
 	ether_addr_copy(dmac_v, entry->key.addr);
@@ -587,6 +588,7 @@ mlx5_esw_bridge_mcast_vlan_flow_create(u16 vlan_proto, struct mlx5_esw_bridge_po
 	if (!rule_spec)
 		return ERR_PTR(-ENOMEM);
 
+	rule_spec->flow_context.flags |= FLOW_CONTEXT_UPLINK_HAIRPIN_EN;
 	rule_spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
 
 	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
@@ -662,6 +664,7 @@ mlx5_esw_bridge_mcast_fwd_flow_create(struct mlx5_esw_bridge_port *port)
 		dest.vport.flags = MLX5_FLOW_DEST_VPORT_VHCA_ID;
 		dest.vport.vhca_id = port->esw_owner_vhca_id;
 	}
+	rule_spec->flow_context.flags |= FLOW_CONTEXT_UPLINK_HAIRPIN_EN;
 	handle = mlx5_add_flow_rules(port->mcast.ft, rule_spec, &flow_act, &dest, 1);
 
 	kvfree(rule_spec);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index a4b925331661..b29299c49ab3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -566,6 +566,8 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 		 fte->flow_context.flow_tag);
 	MLX5_SET(flow_context, in_flow_context, flow_source,
 		 fte->flow_context.flow_source);
+	MLX5_SET(flow_context, in_flow_context, uplink_hairpin_en,
+		 !!(fte->flow_context.flags & FLOW_CONTEXT_UPLINK_HAIRPIN_EN));
 
 	MLX5_SET(flow_context, in_flow_context, extended_destination,
 		 extended_dest);
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 6f7725238abc..3fb428ce7d1c 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -132,6 +132,7 @@ struct mlx5_flow_handle;
 
 enum {
 	FLOW_CONTEXT_HAS_TAG = BIT(0),
+	FLOW_CONTEXT_UPLINK_HAIRPIN_EN = BIT(1),
 };
 
 struct mlx5_flow_context {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 3f7b664d625b..fb8d26a15df4 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3557,7 +3557,7 @@ struct mlx5_ifc_flow_context_bits {
 	u8         action[0x10];
 
 	u8         extended_destination[0x1];
-	u8         reserved_at_81[0x1];
+	u8         uplink_hairpin_en[0x1];
 	u8         flow_source[0x2];
 	u8         encrypt_decrypt_type[0x4];
 	u8         destination_list_size[0x18];
-- 
2.43.0



