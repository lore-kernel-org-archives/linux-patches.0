Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEE47406A;
	Mon, 29 Jan 2024 17:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548570; cv=none; b=psomskR2yhcjBzEf1oET+xvp06s5FODyTbpOyJmXX0P3NjEt4DLlJd//fJmfm1DRLY1Qj3pbYBwTBMTgZ+YW+13jLekp/PVoPK9Ymh8ZWLEuBDYvWj7jUb33RXFQI5AyHus/RZPEwclvfGLPxEkaneO1Kzt5AU65qDB72hd9PyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548570; c=relaxed/simple;
	bh=vUkwaF7q+WoAZQIdHS13NLr3/LHQYjUCHDTCjYiBliY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i81vpDvui6YghS5thRJfPNxoCINe11x9B+kRB0+JiAfXxFy44MR5fGxYLOZfNEZvVq7AblpzosMSHNdCHBOV4Ui4Kl8BNq1zwvIR6krgEaDef5Y/m9j+63+/qqPI8Av29ERSN0u9IC7kh0t1vwgDpGXySKtrzXppR13DVfeLIgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myAdPijO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myAdPijO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13391C43399;
	Mon, 29 Jan 2024 17:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548570;
	bh=vUkwaF7q+WoAZQIdHS13NLr3/LHQYjUCHDTCjYiBliY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=myAdPijOZV8ETM/JEPePSNzhaLXqUgfWY3S607BlwusY3lJBjzZhYWTdK3RwO9YVb
	 nbQKRvtrSLglRlpWsmSj1sxju/u5byotZ0Xu8QeEC9nfwyrLJ/JNlCzNiAaYFK5dP0
	 Ae7tqIZUuJ3IF/WYuUqiSnA/J9XjEG1CvskS1Tuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erez Shitrit <erezsh@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 195/331] net/mlx5: Bridge, Enable mcast in smfs steering mode
Date: Mon, 29 Jan 2024 09:04:19 -0800
Message-ID: <20240129170020.583247131@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erez Shitrit <erezsh@nvidia.com>

[ Upstream commit 653b7eb9d74426397c95061fd57da3063625af65 ]

In order to have mcast offloads the driver needs the following:
It should know if that mcast comes from wire port, in addition the flow
should not be marked as any specific source, that way it will give the
flexibility for the driver not to be depended on the way iterator
implemented in the FW.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: ec7cc38ef9f8 ("net/mlx5: Bridge, fix multicast packets sent to uplink")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge_mcast.c    | 11 ++---------
 include/linux/mlx5/fs.h                               |  1 +
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
index 7a01714b3780..a7ed87e9d842 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
@@ -78,6 +78,8 @@ mlx5_esw_bridge_mdb_flow_create(u16 esw_owner_vhca_id, struct mlx5_esw_bridge_md
 	xa_for_each(&entry->ports, idx, port) {
 		dests[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 		dests[i].ft = port->mcast.ft;
+		if (port->vport_num == MLX5_VPORT_UPLINK)
+			dests[i].ft->flags |= MLX5_FLOW_TABLE_UPLINK_VPORT;
 		i++;
 	}
 
@@ -585,10 +587,6 @@ mlx5_esw_bridge_mcast_vlan_flow_create(u16 vlan_proto, struct mlx5_esw_bridge_po
 	if (!rule_spec)
 		return ERR_PTR(-ENOMEM);
 
-	if (MLX5_CAP_ESW_FLOWTABLE(bridge->br_offloads->esw->dev, flow_source) &&
-	    port->vport_num == MLX5_VPORT_UPLINK)
-		rule_spec->flow_context.flow_source =
-			MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT;
 	rule_spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
 
 	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
@@ -660,11 +658,6 @@ mlx5_esw_bridge_mcast_fwd_flow_create(struct mlx5_esw_bridge_port *port)
 	if (!rule_spec)
 		return ERR_PTR(-ENOMEM);
 
-	if (MLX5_CAP_ESW_FLOWTABLE(bridge->br_offloads->esw->dev, flow_source) &&
-	    port->vport_num == MLX5_VPORT_UPLINK)
-		rule_spec->flow_context.flow_source =
-			MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT;
-
 	if (MLX5_CAP_ESW(bridge->br_offloads->esw->dev, merged_eswitch)) {
 		dest.vport.flags = MLX5_FLOW_DEST_VPORT_VHCA_ID;
 		dest.vport.vhca_id = port->esw_owner_vhca_id;
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 1e00c2436377..6f7725238abc 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -67,6 +67,7 @@ enum {
 	MLX5_FLOW_TABLE_TERMINATION = BIT(2),
 	MLX5_FLOW_TABLE_UNMANAGED = BIT(3),
 	MLX5_FLOW_TABLE_OTHER_VPORT = BIT(4),
+	MLX5_FLOW_TABLE_UPLINK_VPORT = BIT(5),
 };
 
 #define LEFTOVERS_RULE_NUM	 2
-- 
2.43.0



