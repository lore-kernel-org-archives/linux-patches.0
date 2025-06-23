Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CC7221FBE;
	Mon, 23 Jun 2025 21:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713959; cv=none; b=psT9LUF5EMFogUrfa+FsgloI56ZcWfeEeFLFIIinh/a2KtOh4v+LQqSgk4hmTS0qh2VpZSCw+wUZM/MgVJzTGDyjaxA0/dBnsj9rwgt3sCrYFWEMqTQJeCBkskOhvPOnngbxTKc6o3cSjlafFMTYGbt84z5caX+k6uabBnM6tOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713959; c=relaxed/simple;
	bh=+f9zpa2XhzY2B5kE8By4emJaCijBs88WspJUQlSQP4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oa8gdkpsTC0Bwk9NU6DeuOaLgenyA3fNANaGJMnhsAc2Fa+xd2z0k0TBrIDDUX4XdJBO9mmTWh2K6AqGb3wTFU1pLH1EakfUjOgg6n4Nyv6mExxJpp7JsAfGxPyj1/suO8KguMHxKXgC/QbKkzUp3rbSpHMFrFmmQbL6rF5sEnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1VXz2+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1VXz2+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBB1C4CEEA;
	Mon, 23 Jun 2025 21:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713959;
	bh=+f9zpa2XhzY2B5kE8By4emJaCijBs88WspJUQlSQP4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1VXz2+K14T7/+475xYQ5iXtL876nnLbALjaqXbbKiHOvVxVr/4lOMdFWvF2DiKAE
	 7t0iGAt0k+s1CoBj5Ma1DfqtEiW/dpYdf6/67OGv+Q1yLCzBzsVqoXtFZ1OWhi7nVV
	 yWA1gycJgLcvfmFA0R3U4Sp+bAsKun4eO7hUa2oA=
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
Subject: [PATCH 5.15 157/411] net/mlx5: Fix return value when searching for existing flow group
Date: Mon, 23 Jun 2025 15:05:01 +0200
Message-ID: <20250623130637.594864164@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8ff2b81960de7..ef56a71e43d70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1876,6 +1876,7 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 	struct mlx5_flow_handle *rule;
 	struct match_list *iter;
 	bool take_write = false;
+	bool try_again = false;
 	struct fs_fte *fte;
 	u64  version = 0;
 	int err;
@@ -1935,6 +1936,7 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 		nested_down_write_ref_node(&g->node, FS_LOCK_PARENT);
 
 		if (!g->node.active) {
+			try_again = true;
 			up_write_ref_node(&g->node, false);
 			continue;
 		}
@@ -1956,7 +1958,8 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
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



