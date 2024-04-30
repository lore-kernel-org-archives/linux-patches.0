Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88535127B70;
	Tue, 30 Apr 2024 10:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473731; cv=none; b=dtszliZZVf9oPjL9qeXpGB8UDFd6R9PzV9Bktp4tiAUmOclFKCWSXEl3U8M1A1DBrJqE4uderk5xqyO09mVSftJCuzW+hHL1DJnvOJOQaIT2p6/ERc2O/74v9z9RXLTOIwbAdxCpwVP9aUVMzT4Tx84jh3OG/0BPTmWC+GxHQf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473731; c=relaxed/simple;
	bh=MXtu1OhLTto9ZJynNeX5d31OwnMTQBN4FcWGT2KvWY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDYI8gRj4r2I7GKsstJ+oE6PC4lg9g1ZN1+nKeX3fVa84M76egcxv6CEmaddKa4o+qK3eNv/y4KUbcjn8OxwiGi09+dNyOV9UpvYW0zntlZdsVdkn2y/2nhGGphffQm229k22U5J3c49UPsUs0Yy53MmN4lX9LQj2veZSDUufU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTt+IQH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTt+IQH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104D8C2BBFC;
	Tue, 30 Apr 2024 10:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473731;
	bh=MXtu1OhLTto9ZJynNeX5d31OwnMTQBN4FcWGT2KvWY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTt+IQH6hv2Cm8b9T7MhpLanDcObTiHh+dpNlZndz2xQvggvYN26geobv4YRnWkzw
	 GMWnkil9krml6KiN1mr0KJTV4oti8pyfvPTvNMIjXfsDrDCpB6Gbxl7452DmpEdstl
	 vZm6dmi+HKLTph6L6hmsWc/rrID1+7FUNk2MZrnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/77] net/mlx5: Properly link new fs rules into the tree
Date: Tue, 30 Apr 2024 12:38:47 +0200
Message-ID: <20240430103041.366183008@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 7c6782ad4911cbee874e85630226ed389ff2e453 ]

Previously, add_rule_fg would only add newly created rules from the
handle into the tree when they had a refcount of 1. On the other hand,
create_flow_handle tries hard to find and reference already existing
identical rules instead of creating new ones.

These two behaviors can result in a situation where create_flow_handle
1) creates a new rule and references it, then
2) in a subsequent step during the same handle creation references it
   again,
resulting in a rule with a refcount of 2 that is not linked into the
tree, will have a NULL parent and root and will result in a crash when
the flow group is deleted because del_sw_hw_rule, invoked on rule
deletion, assumes node->parent is != NULL.

This happened in the wild, due to another bug related to incorrect
handling of duplicate pkt_reformat ids, which lead to the code in
create_flow_handle incorrectly referencing a just-added rule in the same
flow handle, resulting in the problem described above. Full details are
at [1].

This patch changes add_rule_fg to add new rules without parents into
the tree, properly initializing them and avoiding the crash. This makes
it more consistent with how rules are added to an FTE in
create_flow_handle.

Fixes: 74491de93712 ("net/mlx5: Add multi dest support")
Link: https://lore.kernel.org/netdev/ea5264d6-6b55-4449-a602-214c6f509c1e@163.com/T/#u [1]
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240409190820.227554-5-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index f0aa7f0e54803..d2b8d284b1995 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1452,8 +1452,9 @@ static struct mlx5_flow_handle *add_rule_fg(struct mlx5_flow_group *fg,
 	}
 	trace_mlx5_fs_set_fte(fte, false);
 
+	/* Link newly added rules into the tree. */
 	for (i = 0; i < handle->num_rules; i++) {
-		if (refcount_read(&handle->rule[i]->node.refcount) == 1) {
+		if (!handle->rule[i]->node.parent) {
 			tree_add_node(&handle->rule[i]->node, &fte->node);
 			trace_mlx5_fs_add_rule(handle->rule[i]);
 		}
-- 
2.43.0



