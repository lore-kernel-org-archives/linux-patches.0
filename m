Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7B523506A;
	Tue, 30 Sep 2025 15:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244680; cv=none; b=jNJg5EMHfELL3zuVHwoKLbJZ7uHYiz6jQXVIxe1RL9fKL3lDyJuxZiNpYAM+cgasanaogpAg623xzEKRah1KDcfkGjUqKfizSiDVU6wki1lhp7bHnw1Tf5Siqq8nJc2sOqBnr1bcrDjXl3epu1GTBi0U38BVUDRL8Fc5Sod9GbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244680; c=relaxed/simple;
	bh=IG8zWT/ViJKRPhdJiYPscDAqok0jM+Ua77q3Pr9cB80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0HSbndphkn/fZKYKQyVsqBNjzXvGBcjO1lW1dXBxOmJbOrU5twMwkQoldxlGgveuCXGSj1rXvUHrUZRXaQp+A/LlyYeZA2DT0Emu61S4R6HJNzeHt19vdi3IiZB83Oj8G+24dykOmSnyDDh3kMh9Q3qXq3qhOQZ2tPFyilEmM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcY5H/JI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcY5H/JI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D6AC113D0;
	Tue, 30 Sep 2025 15:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244680;
	bh=IG8zWT/ViJKRPhdJiYPscDAqok0jM+Ua77q3Pr9cB80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcY5H/JIZXRqAh5bwpkOimgKJVCBIueC/iI8gMEAFIfcxLvEsgJZKafGyKi7vAPHQ
	 Jxb8Q3KmYV0sc9McENt3B2keXNZXs7vtikj/l3hXi6iffAye1+ZNbV96zu60LzO+0f
	 l9NWJHLeOy61lJKSMPdgYk0f5oHfOZWhtixLVi6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 081/143] net/mlx5: HWS, ignore flow level for multi-dest table
Date: Tue, 30 Sep 2025 16:46:45 +0200
Message-ID: <20250930143834.466994492@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit efb877cf27e300e47e1c051f4e8fd80fc42325d5 ]

When HWS creates multi-dest FW table and adds rules to
forward to other tables, ignore the flow level enforcement
in FW, because HWS is responsible for table levels.

This fixes the following error:

  mlx5_core 0000:08:00.0: mlx5_cmd_out_err:818:(pid 192306):
     SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed,
     status bad parameter(0x3), syndrome (0x6ae84c), err(-22)

Fixes: 504e536d9010 ("net/mlx5: HWS, added actions handling")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1758525094-816583-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/steering/hws/action.c |  4 ++--
 .../ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c | 11 +++--------
 .../mellanox/mlx5/core/steering/hws/mlx5hws.h         |  3 +--
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
index 6b36a4a7d895f..fe56b59e24c59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
@@ -1360,7 +1360,7 @@ mlx5hws_action_create_modify_header(struct mlx5hws_context *ctx,
 struct mlx5hws_action *
 mlx5hws_action_create_dest_array(struct mlx5hws_context *ctx, size_t num_dest,
 				 struct mlx5hws_action_dest_attr *dests,
-				 bool ignore_flow_level, u32 flags)
+				 u32 flags)
 {
 	struct mlx5hws_cmd_set_fte_dest *dest_list = NULL;
 	struct mlx5hws_cmd_ft_create_attr ft_attr = {0};
@@ -1397,7 +1397,7 @@ mlx5hws_action_create_dest_array(struct mlx5hws_context *ctx, size_t num_dest,
 				MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 			dest_list[i].destination_id = dests[i].dest->dest_obj.obj_id;
 			fte_attr.action_flags |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-			fte_attr.ignore_flow_level = ignore_flow_level;
+			fte_attr.ignore_flow_level = 1;
 			if (dests[i].is_wire_ft)
 				last_dest_idx = i;
 			break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 131e74b2b7743..6a4c4cccd6434 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -572,12 +572,12 @@ static void mlx5_fs_put_dest_action_sampler(struct mlx5_fs_hws_context *fs_ctx,
 static struct mlx5hws_action *
 mlx5_fs_create_action_dest_array(struct mlx5hws_context *ctx,
 				 struct mlx5hws_action_dest_attr *dests,
-				 u32 num_of_dests, bool ignore_flow_level)
+				 u32 num_of_dests)
 {
 	u32 flags = MLX5HWS_ACTION_FLAG_HWS_FDB | MLX5HWS_ACTION_FLAG_SHARED;
 
 	return mlx5hws_action_create_dest_array(ctx, num_of_dests, dests,
-						ignore_flow_level, flags);
+						flags);
 }
 
 static struct mlx5hws_action *
@@ -1014,19 +1014,14 @@ static int mlx5_fs_fte_get_hws_actions(struct mlx5_flow_root_namespace *ns,
 		}
 		(*ractions)[num_actions++].action = dest_actions->dest;
 	} else if (num_dest_actions > 1) {
-		bool ignore_flow_level;
-
 		if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX ||
 		    num_fs_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
 			err = -EOPNOTSUPP;
 			goto free_actions;
 		}
-		ignore_flow_level =
-			!!(fte_action->flags & FLOW_ACT_IGNORE_FLOW_LEVEL);
 		tmp_action =
 			mlx5_fs_create_action_dest_array(ctx, dest_actions,
-							 num_dest_actions,
-							 ignore_flow_level);
+							 num_dest_actions);
 		if (!tmp_action) {
 			err = -EOPNOTSUPP;
 			goto free_actions;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
index 32d7d75bc6daf..e6ba5a2129075 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
@@ -727,7 +727,6 @@ mlx5hws_action_create_push_vlan(struct mlx5hws_context *ctx, u32 flags);
  * @num_dest: The number of dests attributes.
  * @dests: The destination array. Each contains a destination action and can
  *	   have additional actions.
- * @ignore_flow_level: Whether to turn on 'ignore_flow_level' for this dest.
  * @flags: Action creation flags (enum mlx5hws_action_flags).
  *
  * Return: pointer to mlx5hws_action on success NULL otherwise.
@@ -735,7 +734,7 @@ mlx5hws_action_create_push_vlan(struct mlx5hws_context *ctx, u32 flags);
 struct mlx5hws_action *
 mlx5hws_action_create_dest_array(struct mlx5hws_context *ctx, size_t num_dest,
 				 struct mlx5hws_action_dest_attr *dests,
-				 bool ignore_flow_level, u32 flags);
+				 u32 flags);
 
 /**
  * mlx5hws_action_create_insert_header - Create insert header action.
-- 
2.51.0



