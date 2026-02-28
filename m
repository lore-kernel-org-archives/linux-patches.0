Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D752E3314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301265; cv=none; b=fs9cgdjfnJlOYYzKF3GkpNI2QOAs4k/AlrbYkCb6jsxlcMgCy8LAyCCKCzaDyYNXN8dk2tN3H9NaGe2DHW8u5OMDT/OeYuW+G0DotGC2BaSKP3o+F0HX40XxCLYsSrdyCKaiAw/YiFhwCVSrRhlMUhHwJLs49kA0Zos/RmFxZfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301265; c=relaxed/simple;
	bh=P6R3klmL04przCxYleECliiwRazrgQ+kDzGO8A8Qk1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYUuWFueKvn2NUXV9m0KYSp/3mqpX7b8SqM9NKeRcn4zpUNXhHhSCLc4fgpk9K5U8G1l7cUxkahaIX7DOvom/iDtVDPD1T47669PFD8eG5CsXYoS2oT/lj0uUbfomnBDUtk0cvazWAuxlNUvoC1lqbrh6G+sqPe89IPtyR/YrXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IeIblglP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IeIblglP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C44C19424;
	Sat, 28 Feb 2026 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301265;
	bh=P6R3klmL04przCxYleECliiwRazrgQ+kDzGO8A8Qk1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeIblglP/TcOde7/8Uzi3Cq6jpFSqEMOw9qp+t6WeCmuzhrSnLekn/1O/HunmV9td
	 CwHX3cgSzqnskbMMJUSfYt4IBI3do6PV/Tp1SvuD+qbPxlyHKwi3S5ONDkf9NwB1dB
	 YurF7mbWoTxHNpYGVk1i7k4RVwBz9xzaaBo1xJsiDJCHpT/lEUscU9r4d/3Aj27hpL
	 +IxnAIhv2IE8srsEKe7WzwVKaPyejPka+bQ4UWOD4BDNatWDPS+RZzd1EwIYAVpqc+
	 2hhiqBJFkCizv/IVM21nfxeL+7AQFYSxfMBk+zs9CyoPm+8eTORoFQl7qYFw/s4Fke
	 grP+gE8lq61ag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 449/752] net/mlx5: E-switch, Clear legacy flag when moving to switchdev
Date: Sat, 28 Feb 2026 12:42:40 -0500
Message-ID: <20260228174750.1542406-449-sashal@kernel.org>
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

[ Upstream commit d7073e8b978ae925f1f0f08754f33f84d8547ea7 ]

The cited commit introduced MLX5_PRIV_FLAGS_SWITCH_LEGACY to identify
when a transition to legacy mode is requested via devlink.  However, the
logic failed to clear this flag if the mode was subsequently changed
back to MLX5_ESWITCH_OFFLOADS (switchdev).  Consequently, if a user
toggled from legacy to switchdev, the flag remained set, leaving the
driver with wrong state indicating

Fix this by explicitly clearing the MLX5_PRIV_FLAGS_SWITCH_LEGACY bit
when the requested mode is MLX5_ESWITCH_OFFLOADS.

Fixes: 2a4f56fbcc47 ("net/mlx5e: Keep netdev when leave switchdev for devlink set legacy only")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260224114652.1787431-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 784130cdf6c07..8c0e812f13c3f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3854,6 +3854,8 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 
 	if (mode == DEVLINK_ESWITCH_MODE_LEGACY)
 		esw->dev->priv.flags |= MLX5_PRIV_FLAGS_SWITCH_LEGACY;
+	if (mlx5_mode == MLX5_ESWITCH_OFFLOADS)
+		esw->dev->priv.flags &= ~MLX5_PRIV_FLAGS_SWITCH_LEGACY;
 	mlx5_eswitch_disable_locked(esw);
 	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV) {
 		if (mlx5_devlink_trap_get_num_active(esw->dev)) {
-- 
2.51.0

