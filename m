Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B081D619D;
	Mon,  6 Jan 2025 15:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177154; cv=none; b=lLZnIaT1W8L3lkrsFIKkHyDLPGNChPiMRV97AGspqAFLw83TZX8JOPKCCg4ZCSnobsdUjyn2imVbGTJozwBlh3HIzYakPs199zDlHj2gjRntZAa31S2Y9vVTgLcGiCs7HPxRAVUZMvWHXcc/P4KuX10DvIARkxmPAc/K/PC7mAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177154; c=relaxed/simple;
	bh=YC6pNagC8I+XWT9Sk3qosxs8I3lDZobI/yVdrtTeruQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGaiPCVjysoi44IeF/Ys/PM6LlDQC9yfi5eJUwym1sVmCiVVRMBEI8GDOd6NssP5en6Nxk9z+rAywQ053vopyhFLY06hffhx+aE7I31+gJEtdi03cCdBcIF2V/LTI/dXIXNT8z0ZMOpRqdNanIDZdZlxl4EA3Om9pXp3YZ5XS2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Brvx6cvh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Brvx6cvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D82C4CED6;
	Mon,  6 Jan 2025 15:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177154;
	bh=YC6pNagC8I+XWT9Sk3qosxs8I3lDZobI/yVdrtTeruQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Brvx6cvhrTA6MgjQyy1cZxy74hO8AsRguR67yd23ejucvHwHD0M/lNwEePcl6ACj1
	 OH8z6qcQ3SK21pMI1HMGyWAVmaEB4VJpWV5iMTSF1HXpu6iPy2SrzNKazil2f0dDjE
	 8BwLjGYKc6hTawV/xUm5D/uXowHJdqFDm/aZhI0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>,
	Breno Leitao <leitao@debian.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/222] net/mlx5: unique names for per device caches
Date: Mon,  6 Jan 2025 16:14:34 +0100
Message-ID: <20250106151153.253399543@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

From: Sebastian Ott <sebott@redhat.com>

[ Upstream commit 25872a079bbbe952eb660249cc9f40fa75623e68 ]

Add the device name to the per device kmem_cache names to
ensure their uniqueness. This fixes warnings like this:
"kmem_cache of name 'mlx5_fs_fgs' already exists".

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241023134146.28448-1-sebott@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 991250f44c2e..474e63d02ba4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -3478,6 +3478,7 @@ void mlx5_fs_core_free(struct mlx5_core_dev *dev)
 int mlx5_fs_core_alloc(struct mlx5_core_dev *dev)
 {
 	struct mlx5_flow_steering *steering;
+	char name[80];
 	int err = 0;
 
 	err = mlx5_init_fc_stats(dev);
@@ -3502,10 +3503,12 @@ int mlx5_fs_core_alloc(struct mlx5_core_dev *dev)
 	else
 		steering->mode = MLX5_FLOW_STEERING_MODE_DMFS;
 
-	steering->fgs_cache = kmem_cache_create("mlx5_fs_fgs",
+	snprintf(name, sizeof(name), "%s-mlx5_fs_fgs", dev_name(dev->device));
+	steering->fgs_cache = kmem_cache_create(name,
 						sizeof(struct mlx5_flow_group), 0,
 						0, NULL);
-	steering->ftes_cache = kmem_cache_create("mlx5_fs_ftes", sizeof(struct fs_fte), 0,
+	snprintf(name, sizeof(name), "%s-mlx5_fs_ftes", dev_name(dev->device));
+	steering->ftes_cache = kmem_cache_create(name, sizeof(struct fs_fte), 0,
 						 0, NULL);
 	if (!steering->ftes_cache || !steering->fgs_cache) {
 		err = -ENOMEM;
-- 
2.39.5



