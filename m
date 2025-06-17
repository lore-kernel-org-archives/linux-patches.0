Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4464D1A5B9D;
	Tue, 17 Jun 2025 16:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178214; cv=none; b=HgxnrJRCEjJJfLA8mGc1PBSBsbrfKM0dqpGcyu1B+oB7Dm6Lmy1Yw0b32MS3ggn/eFvPShrdSmQd6OjDmS4Ko9AiyiZ8MsgPrYYSdtOW/t7p0Il4ymf5E0y7sZiVYIAbSoQaBZl7hJHhw+sa6T2Thyg/jsRKacn54UTiDk2DJZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178214; c=relaxed/simple;
	bh=zaL3bUrjIEvXgW6itcjJslKw/wTuc612UIu6HCe3rSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z95QlUFlpBxol1gpNH5ME5wl9t2jNfcfY06yTSW4P5yE3idJ68696vx6+/4ELIYGEnl/WiClFhIpNqkAJcEcuipYD4T7/EiNY7CpIsQtzlVOO/fICwZLnXZzPkzRbkxrKQeZaZGm7zyw2gEDpRUQhzDM3dxaAiBIURjPqE+bhRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfqpa5Pc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfqpa5Pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89189C4CEE3;
	Tue, 17 Jun 2025 16:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178214;
	bh=zaL3bUrjIEvXgW6itcjJslKw/wTuc612UIu6HCe3rSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfqpa5Pcfj2CfyGGd0iINAyJLWuw9x6Nn6sXeTcohgLmeZCAW2nEwxHSbVN3roDfK
	 OWJxeZqZCYX4zuTLMyXmXdtHnB+dpcc1Z5uH75vlYSlccXUVQIGEts7sVLIofVkLSA
	 tHcKBQy0YGuVgBo5ZmG1nyu3tEuUGOEJJjrWpxg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavi Teitz <gavi@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 462/512] net/mlx5: Fix return value when searching for existing flow group
Date: Tue, 17 Jun 2025 17:27:08 +0200
Message-ID: <20250617152438.288526188@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 8ec40e3f1f72bf8f8accf18020d487caa99f46a4 ]

When attempting to add a rule to an existing flow group, if a matching
flow group exists but is not active, the error code returned should be
EAGAIN, so that the rule can be added to the matching flow group once
it is active, rather than ENOENT, which indicates that no matching
flow group was found.

Fixes: bd71b08ec2ee ("net/mlx5: Support multiple updates of steering rules in parallel")
Signed-off-by: Gavi Teitz <gavi@nvidia.com>
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250610151514.1094735-4-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 0ce999706d412..1bc88743d2dfa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2200,6 +2200,7 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 	struct mlx5_flow_handle *rule;
 	struct match_list *iter;
 	bool take_write = false;
+	bool try_again = false;
 	struct fs_fte *fte;
 	u64  version = 0;
 	int err;
@@ -2264,6 +2265,7 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 		nested_down_write_ref_node(&g->node, FS_LOCK_PARENT);
 
 		if (!g->node.active) {
+			try_again = true;
 			up_write_ref_node(&g->node, false);
 			continue;
 		}
@@ -2285,7 +2287,8 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 			tree_put_node(&fte->node, false);
 		return rule;
 	}
-	rule = ERR_PTR(-ENOENT);
+	err = try_again ? -EAGAIN : -ENOENT;
+	rule = ERR_PTR(err);
 out:
 	kmem_cache_free(steering->ftes_cache, fte);
 	return rule;
-- 
2.39.5



