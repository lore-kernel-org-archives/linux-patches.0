Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB8333EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA0EC433D2;
	Mon, 16 Jan 2023 16:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884950;
	bh=gGYMn6WzGqvBIQ7sOAitNF9QlPAGCIP0H2lLkfa/hcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jC7IQEZ7F+8moK+v77xYB4BRTjW0G+3FcABSsyyxyVVwnlGtcli+AoOelajbgrYhi
	 rIKycZoaBr9d6PzYPHxe/ud4hYEFq5Kv5nU2ly+gAdTu/CIxw1uB2ZS+gal1MIgOZ8
	 4K9aODTs49WcdBh4Opheegrj6pZON7hqldL9VOj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 5.15 18/86] net/mlx5e: Set action fwd flag when parsing tc action goto
Date: Mon, 16 Jan 2023 16:50:52 +0100
Message-Id: <20230116154747.848412058@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

commit 7f8770c71646cf93abdf3fea8b7733aaec4c82a3 upstream.

Do it when parsing like in other actions instead of when
checking if goto is supported in current scenario.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Cc: dann frazier <dann.frazier@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |   43 ++++++++++--------------
 1 file changed, 18 insertions(+), 25 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3597,7 +3597,8 @@ static int parse_tc_nic_actions(struct m
 			if (err)
 				return err;
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			attr->dest_chain = act->chain_index;
 			break;
 		case FLOW_ACTION_CT:
@@ -3632,12 +3633,9 @@ static int parse_tc_nic_actions(struct m
 
 	attr->action = action;
 
-	if (attr->dest_chain) {
-		if (attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
-			NL_SET_ERR_MSG(extack, "Mirroring goto chain rules isn't supported");
-			return -EOPNOTSUPP;
-		}
-		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	if (attr->dest_chain && parse_attr->mirred_ifindex[0]) {
+		NL_SET_ERR_MSG(extack, "Mirroring goto chain rules isn't supported");
+		return -EOPNOTSUPP;
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
@@ -4146,7 +4144,8 @@ static int parse_tc_fdb_actions(struct m
 			if (err)
 				return err;
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			attr->dest_chain = act->chain_index;
 			break;
 		case FLOW_ACTION_CT:
@@ -4218,24 +4217,18 @@ static int parse_tc_fdb_actions(struct m
 	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
-	if (attr->dest_chain) {
-		if (decap) {
-			/* It can be supported if we'll create a mapping for
-			 * the tunnel device only (without tunnel), and set
-			 * this tunnel id with this decap flow.
-			 *
-			 * On restore (miss), we'll just set this saved tunnel
-			 * device.
-			 */
-
-			NL_SET_ERR_MSG(extack,
-				       "Decap with goto isn't supported");
-			netdev_warn(priv->netdev,
-				    "Decap with goto isn't supported");
-			return -EOPNOTSUPP;
-		}
+	if (attr->dest_chain && decap) {
+		/* It can be supported if we'll create a mapping for
+		 * the tunnel device only (without tunnel), and set
+		 * this tunnel id with this decap flow.
+		 *
+		 * On restore (miss), we'll just set this saved tunnel
+		 * device.
+		 */
 
-		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+		NL_SET_ERR_MSG(extack, "Decap with goto isn't supported");
+		netdev_warn(priv->netdev, "Decap with goto isn't supported");
+		return -EOPNOTSUPP;
 	}
 
 	if (esw_attr->split_count > 0 && !mlx5_esw_has_fwd_fdb(priv->mdev)) {


