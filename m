Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB456333447
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301266; cv=none; b=Du2n8BIeIYTBcAhWSGkwBmvFj+ToaLC88KOtK8752P3R0+Gpquo52PWuQ2V7r4jNk75JKRSlVHLvxybORwCNWttMgPR23R9soBb70Bbt/Ug+Ply5mRcBsB1UW8Hlwx5bCegUDapeaSrHDMOB0toNsmPVdIqnkvwCmGnUy2TZWvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301266; c=relaxed/simple;
	bh=dgFpN3XHNCBHH2zfZ7BwvQ0zx2JH/3/1eleSXZHaDG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDLtzimTzGeawRG92n3mmgFlc2zz/VUFNEiG9FXrOK7p/JFypy8i7fyxtF6Wd5kXr46S81//U8JhD1zzYEc8tqLRXqIdBgTFvQXVKRg92jmyKVU2QrAS4zatiNCNLIYCeqiJQ4sJ34LgFh00WXWyfoDkGwY/+myhEk3GyGY+oO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6rkrY5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6rkrY5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0678DC19423;
	Sat, 28 Feb 2026 17:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301266;
	bh=dgFpN3XHNCBHH2zfZ7BwvQ0zx2JH/3/1eleSXZHaDG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6rkrY5/uzqkoE88cXQAExScBn4k9VVJgJI2+Uo5kt0LOMuzt/kUuCn0LuJU30Goe
	 4J9d4kPBgPtpH9xS7uf56EXLuBxoR63+xnbHyw8HdPAiaiMqds/2yl/PJpTgfJXi43
	 mtugo+w2zJSCmkVfWWO0GKfwsxyKsjb/P52O2swR7kPacEcwNU/rTvnv5TACn58VC1
	 368kIq2WmrfpjfGVpZZgb8gIdn1KTNZEF7y8tpvXeqjnp3MOdh46+XALU4m03wV+yR
	 pjxOnjWXRVbnnkekbZ/DcmlWIkzaXWO33B0z9v7FyBymnhldbQ38NvYAInIc9S2qdV
	 2GQi/zLwmwXnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 450/752] net/mlx5: Fix missing devlink lock in SRIOV enable error path
Date: Sat, 28 Feb 2026 12:42:41 -0500
Message-ID: <20260228174750.1542406-450-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 60253042c0b87b61596368489c44d12ba720d11c ]

The cited commit miss to add locking in the error path of
mlx5_sriov_enable(). When pci_enable_sriov() fails,
mlx5_device_disable_sriov() is called to clean up. This cleanup function
now expects to be called with the devlink instance lock held.

Add the missing devl_lock(devlink) and devl_unlock(devlink)

Fixes: 84a433a40d0e ("net/mlx5: Lock mlx5 devlink reload callbacks")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260224114652.1787431-5-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index a2fc937d54617..172862a70c70d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -193,7 +193,9 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 	err = pci_enable_sriov(pdev, num_vfs);
 	if (err) {
 		mlx5_core_warn(dev, "pci_enable_sriov failed : %d\n", err);
+		devl_lock(devlink);
 		mlx5_device_disable_sriov(dev, num_vfs, true, true);
+		devl_unlock(devlink);
 	}
 	return err;
 }
-- 
2.51.0

