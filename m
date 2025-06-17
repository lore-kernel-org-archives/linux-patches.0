Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B4E2FA64A;
	Tue, 17 Jun 2025 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179329; cv=none; b=qgcXSBKixcLWYCkdXY+4R4cFteXqSE9lS9s9s/2j5nsaCxnsZmzIjCl0ods7BpcyxCDLoGfXuJOqe7DhVufvYoK4ANWk1xzraslmVMuEJG8kFxnePpBf2a1JG3Tzd+FcIrRu+Ab1Nttf7i1ZlHCqe1f0aqNTuUabs2t9suRYmLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179329; c=relaxed/simple;
	bh=gCnqkY3eLdworZaES2VQC4JQQoFFRGWYnT/prS8dWZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1KcVT7zgCYpfaVJkGdIunnxzEn6CRiln8bfwzt4xiQ8SruYDJIjU43GG6Q/ybVm+BXLQwCtFr/hxUOwTEDFdHd5Hg/Qao59KRr3Jnw8gXpgY6t4XF5zoa3c5Bsh5r/1SWy8X0qWbRDHuGUzjgquD/4G5ROZwsRKskKGsABxUcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSBTB2NF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSBTB2NF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD996C4CEE3;
	Tue, 17 Jun 2025 16:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179329;
	bh=gCnqkY3eLdworZaES2VQC4JQQoFFRGWYnT/prS8dWZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSBTB2NFBB35JSt1hjwjF4JVBB7Xzqk/yLRBJn1c5K/6/+40C1U0qCoaJ0Roy4733
	 swh4oKg99WtUBt8+bfe5/wO7AVOicrLeDi1HfTjpksn62tnweegz8CaqJoka4+BC36
	 tvxE0qEHwwL6po/Msq4WccLJH98JUOwI+gwCWJek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 713/780] net/mlx5: HWS, make sure the uplink is the last destination
Date: Tue, 17 Jun 2025 17:27:01 +0200
Message-ID: <20250617152520.528149581@linuxfoundation.org>
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

From: Vlad Dogaru <vdogaru@nvidia.com>

[ Upstream commit b8335829518ec5988294280e37d735799209d70d ]

When there are more than one destinations, we create a FW flow
table and provide it with all the destinations. FW requires to
have wire as the last destination in the list (if it exists),
otherwise the operation fails with FW syndrome.

This patch fixes the destination array action creation: if it
contains a wire destination, it is moved to the end.

Fixes: 504e536d9010 ("net/mlx5: HWS, added actions handling")
Signed-off-by: Vlad Dogaru <vdogaru@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250610151514.1094735-7-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/hws/action.c       | 14 +++++++-------
 .../mellanox/mlx5/core/steering/hws/fs_hws.c       |  3 +++
 .../mellanox/mlx5/core/steering/hws/mlx5hws.h      |  1 +
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
index b5332c54d4fb0..17b8a3beb1173 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
@@ -1361,8 +1361,8 @@ mlx5hws_action_create_dest_array(struct mlx5hws_context *ctx,
 	struct mlx5hws_cmd_set_fte_attr fte_attr = {0};
 	struct mlx5hws_cmd_forward_tbl *fw_island;
 	struct mlx5hws_action *action;
-	u32 i /*, packet_reformat_id*/;
-	int ret;
+	int ret, last_dest_idx = -1;
+	u32 i;
 
 	if (num_dest <= 1) {
 		mlx5hws_err(ctx, "Action must have multiple dests\n");
@@ -1392,11 +1392,8 @@ mlx5hws_action_create_dest_array(struct mlx5hws_context *ctx,
 			dest_list[i].destination_id = dests[i].dest->dest_obj.obj_id;
 			fte_attr.action_flags |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 			fte_attr.ignore_flow_level = ignore_flow_level;
-			/* ToDo: In SW steering we have a handling of 'go to WIRE'
-			 * destination here by upper layer setting 'is_wire_ft' flag
-			 * if the destination is wire.
-			 * This is because uplink should be last dest in the list.
-			 */
+			if (dests[i].is_wire_ft)
+				last_dest_idx = i;
 			break;
 		case MLX5HWS_ACTION_TYP_VPORT:
 			dest_list[i].destination_type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
@@ -1420,6 +1417,9 @@ mlx5hws_action_create_dest_array(struct mlx5hws_context *ctx,
 		}
 	}
 
+	if (last_dest_idx != -1)
+		swap(dest_list[last_dest_idx], dest_list[num_dest - 1]);
+
 	fte_attr.dests_num = num_dest;
 	fte_attr.dests = dest_list;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 1b787cd66e6fd..29c5e00af1aa0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -966,6 +966,9 @@ static int mlx5_fs_fte_get_hws_actions(struct mlx5_flow_root_namespace *ns,
 			switch (attr->type) {
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE:
 				dest_action = mlx5_fs_get_dest_action_ft(fs_ctx, dst);
+				if (dst->dest_attr.ft->flags &
+				    MLX5_FLOW_TABLE_UPLINK_VPORT)
+					dest_actions[num_dest_actions].is_wire_ft = true;
 				break;
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM:
 				dest_action = mlx5_fs_get_dest_action_table_num(fs_ctx,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
index 8ed8a715a2eb2..173f7ed1c17c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
@@ -211,6 +211,7 @@ struct mlx5hws_action_dest_attr {
 	struct mlx5hws_action *dest;
 	/* Optional reformat action */
 	struct mlx5hws_action *reformat;
+	bool is_wire_ft;
 };
 
 /**
-- 
2.39.5



