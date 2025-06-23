Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A091E22E6;
	Mon, 23 Jun 2025 21:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715695; cv=none; b=nZIjwlSf39J2pYKs/Bil3t5rD/pM7cVO52XSBV92vsxV7oZ4VpqojIAFbVWL+981BXYbXNboFDMYFlnEEGD8vP/Ova1oCZ74RRXaGJN7X6bVk/TsQSCiY95ku3J9yz43VJ7HZD9ukEDonYbykAxlXImxYhKVck4Lul3XEiQ3sww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715695; c=relaxed/simple;
	bh=7D8sygOiYLG/JKLaIwF4IgNyZkz7lZqO2LPcf9G/+mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sT+wBIVgbFGdAdOGR6j2NBFMraS45qj1W4RVQM9iQTQKEF7lGlRf3r1pAsCx7zzJRBpKPVqCwhR4prWAFTUJLjeWJ3OyqMJrO2boN83oHYmbbAnQa6aK5mORs5m6XOr4kZTfOBI5bhg2h/KetObEPzrkNZ4rE7wducbFHT/bYvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PItb/Db1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PItb/Db1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CD3C4CEEA;
	Mon, 23 Jun 2025 21:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715695;
	bh=7D8sygOiYLG/JKLaIwF4IgNyZkz7lZqO2LPcf9G/+mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PItb/Db1X2u0sYckk5NOk00y/rG2pI7+44LRfI+85PKewjbM7itUT5tzxd8aG4xKE
	 5jElWRWFa/p/J/9Tx7iSNxMi/JAFKpymuhKhIAM6Qs36f+CLWpm2FnnuRLxm9q6/tR
	 /N73JEYGUWsjMYjFQBlFyAiG/DlnLcxFdAwReZ6I=
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
Subject: [PATCH 6.1 256/508] net/mlx5: Fix return value when searching for existing flow group
Date: Mon, 23 Jun 2025 15:05:01 +0200
Message-ID: <20250623130651.551789964@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2717450e96661..b4c0a6dd171fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1918,6 +1918,7 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 	struct mlx5_flow_handle *rule;
 	struct match_list *iter;
 	bool take_write = false;
+	bool try_again = false;
 	struct fs_fte *fte;
 	u64  version = 0;
 	int err;
@@ -1977,6 +1978,7 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 		nested_down_write_ref_node(&g->node, FS_LOCK_PARENT);
 
 		if (!g->node.active) {
+			try_again = true;
 			up_write_ref_node(&g->node, false);
 			continue;
 		}
@@ -1998,7 +2000,8 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
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



