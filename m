Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FCC2E8DE7;
	Tue, 17 Jun 2025 16:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176946; cv=none; b=L9Ef1LrQmpD+5So66tdGXbI5zP+dbDrkiwPf/Q34jv4rHHZvzlKqgTR0fV6x0gJ2lBG5wulY/Leq81aGhFj9gXYEAC1dbWTr4CnG0MvxQHJ+Pgr68B1GC00ZyJcHsg+5xowz8K5fuyXbmArkqPMPu8IAYp68arA6WPHMf07uo20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176946; c=relaxed/simple;
	bh=m9ctFWBQnOFxMqDqvu08ic+3K/LqvU3+3Ksjo9IOnE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmL6VzP4v3twK4EP+fR3tf1qjWqv3Rz0LFJyYVD5aztcxiayJzVa7/TZqK8VNnJCkSqBMF35e2ZS/2Id/gwjcQSqHj/fSkiRoXyofQzI5FaScKh+0NFMx7Jminys/gvX6Ik4OoH6qGcFngV7xtjum/ouqUfSl3ncbrjqN0j671k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SveDZR/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SveDZR/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D5DC4CEE3;
	Tue, 17 Jun 2025 16:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176946;
	bh=m9ctFWBQnOFxMqDqvu08ic+3K/LqvU3+3Ksjo9IOnE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SveDZR/N5x8AaXcqJ7tGYdEI3FjY9fYrX16nbkOrirYwnJlthtBnppIpuMfVFZKB6
	 mPb1a22nfgzQWRiuRWvjl4MFQbuMu63cRIApMBtUOdHvdSHR1HWj7lC+1lnwjEsrT+
	 ZyOaN5tOL4zOym8Q4YD3t05Hz+vzbuMrgTSR9oRM=
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
Subject: [PATCH 6.6 325/356] net/mlx5: Fix return value when searching for existing flow group
Date: Tue, 17 Jun 2025 17:27:20 +0200
Message-ID: <20250617152351.229612755@linuxfoundation.org>
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
index d2dc375f5e49c..5f35a6fc03054 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1984,6 +1984,7 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 	struct mlx5_flow_handle *rule;
 	struct match_list *iter;
 	bool take_write = false;
+	bool try_again = false;
 	struct fs_fte *fte;
 	u64  version = 0;
 	int err;
@@ -2043,6 +2044,7 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 		nested_down_write_ref_node(&g->node, FS_LOCK_PARENT);
 
 		if (!g->node.active) {
+			try_again = true;
 			up_write_ref_node(&g->node, false);
 			continue;
 		}
@@ -2064,7 +2066,8 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
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



