Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0550D7EEF8;
	Mon, 15 Apr 2024 14:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191265; cv=none; b=HjFpqJCQfNQC2TFLd2hnklq8A6bX6Rq2WB9VHSQnKnwIRVm/1Vw1tlkaU0vosd/WObrZ37+8t7lrsr0vei1fE31h8/1EwCDlkIbk2LIM2cO/bany4lJ79OEhyMbRX1mmtCyKnOHpRrbkUx8DHadhSAoRp7knf6KNycfcDLD8pi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191265; c=relaxed/simple;
	bh=parv5EKdcWQVNatQbrpuDvB7QGuA/zUjAllEzDzTCZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPf2P7s+Jin3cf6dE2FsJXEbagRMPFVcmCLTmrgAAjfQXkcCdbVOqGVc04LIynMi4paDBdg1U2zr12hmPdJKJWtQyOdv/xs0uLNV/VkWO9HGIoJ1jNECRn6+1O70pATF33imKMBNt32PpdZZstvW5xYnT+vxGcKVnkMkpA2+IGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlFclncN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlFclncN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6DBC113CC;
	Mon, 15 Apr 2024 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191264;
	bh=parv5EKdcWQVNatQbrpuDvB7QGuA/zUjAllEzDzTCZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlFclncN+oO6gv2YocN6MZdYxzVtggkV+VMLN9K92UDrOcyYgEb7b9fPaNOZbOFJZ
	 4I7kbS/n+ukzPMSnHuyu+1Z87dsWxcbsQ98RfI6/CXzSK22c63O/zSmAu8ouopAm9v
	 jkwXCmMHyO0qdR9zUtz61ZaeiPU70mq+krWJUDyQ=
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
Subject: [PATCH 6.8 085/172] net/mlx5: Properly link new fs rules into the tree
Date: Mon, 15 Apr 2024 16:19:44 +0200
Message-ID: <20240415142002.976884313@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index e6bfa7e4f146c..2a9421342a503 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1808,8 +1808,9 @@ static struct mlx5_flow_handle *add_rule_fg(struct mlx5_flow_group *fg,
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



