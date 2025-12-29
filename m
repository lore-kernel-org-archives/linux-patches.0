Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23570330324;
	Mon, 29 Dec 2025 16:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024997; cv=none; b=OOB+lyG+9kcEr5eJfOiDkADIX6CkGwec+Hmt3Ri9cmhK14Zi1fd7oLzPUM3+/UIcmMdmahkix0awb9v67wqrZFVXaCnf2bbSp12GzVN4qrlfe2PSFMaO7Lyd45YmygLRB+7M1Qhbbjfh+gAdbMGdGXE14UFuWczXxf51qCeBGyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024997; c=relaxed/simple;
	bh=3jIeaNmYW2lPCSEwksX14/I7NWLijs0KJANhpZt7DvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXiKXyQ+ePunetBU2CF91t0619TkY31mfIr7/ptHW9bz7e6dizJve1i9mXHpBZvJwep6qbJoBfnKXy2TzWBKwWgx4jgZvIXECpMBM4dJCVHsQcAST9v4RGphlxEjBAAvZFBj2FsctD7Bv9ZesU7HgYH2HGuRCQenXYE2cK/rlgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuZQT9Mj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuZQT9Mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECA2C4CEF7;
	Mon, 29 Dec 2025 16:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024996;
	bh=3jIeaNmYW2lPCSEwksX14/I7NWLijs0KJANhpZt7DvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wuZQT9Mjj7EGz95scBlwmLYzonWDmfSEr6cJ1GIPYBwSaTs1HVLRy1Azi0kRU9ifX
	 Y7iqni6XJqCMwHo/mR1MNeKhwDxzYSnvF/3EsAGXRcb0WIQPzyasI9Un6kyvFDKN5v
	 czLL6fuJnba+vL/YPfo7yXbFVzcAnPMZ3RGIdCos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/430] net/mlx5: make enable_mpesw idempotent
Date: Mon, 29 Dec 2025 17:07:38 +0100
Message-ID: <20251229160726.429669155@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit cd7671ef4cf2edf73cd2a3dca3a2f522a4525bf5 ]

The enable_mpesw() function returns -EINVAL if ldev->mode is not
MLX5_LAG_MODE_NONE. This means attempting to enable MPESW mode when it's
already enabled will fail. In contrast, disable_mpesw() properly checks
if the mode is MLX5_LAG_MODE_MPESW before proceeding, making it
naturally idempotent and safe to call multiple times.

Fix enable_mpesw() to return success if mpesw is already enabled.

Fixes: a32327a3a02c ("net/mlx5: Lag, Control MultiPort E-Switch single FDB mode")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1764602008-1334866-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index aad52d3a90e68..2d86af8f0d9b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -67,12 +67,19 @@ static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
 
 static int enable_mpesw(struct mlx5_lag *ldev)
 {
-	int idx = mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P1);
 	struct mlx5_core_dev *dev0;
 	int err;
+	int idx;
 	int i;
 
-	if (idx < 0 || ldev->mode != MLX5_LAG_MODE_NONE)
+	if (ldev->mode == MLX5_LAG_MODE_MPESW)
+		return 0;
+
+	if (ldev->mode != MLX5_LAG_MODE_NONE)
+		return -EINVAL;
+
+	idx = mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P1);
+	if (idx < 0)
 		return -EINVAL;
 
 	dev0 = ldev->pf[idx].dev;
-- 
2.51.0



