Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE9142189E;
	Wed,  4 Feb 2026 15:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218761; cv=none; b=PmHZZbpliiLNMUR+PNlC8vtNjP2NGdbPA3RArNco5aOduLUDsflDlxC8xB7jlU1mlcnIt/XJjrhDaP1ciDyAtF0WeYCKKq0eTbVvi1csuWBNVG7Hn1cbmzE8BTrj51DIRvHisDECKAq6fOBXu/ig5scwG9kJOSwwkl2zcqjub50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218761; c=relaxed/simple;
	bh=lHqhZmwSVZKPGx4SBO/B/atqvROyN+oNhy6Xgx34eKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cu6J5ll9MUR392eYKwyCDIFzKwnOu05XHG2vIPpS/fWohN2kBHupyJ5Mg9I+056D0b/KUlNI+LzvMHtiI7acloW82tHaXzr6qyvLRnnOQd1CI4ullZ8l6OpxnDdvnL0CVchrDLVTjik6mTbrtqUmIg/M+a8BYAsZWRfxDEoehes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDCsRHYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDCsRHYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D229CC4CEF7;
	Wed,  4 Feb 2026 15:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218761;
	bh=lHqhZmwSVZKPGx4SBO/B/atqvROyN+oNhy6Xgx34eKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDCsRHYla2JqGqo7/zLtEbIcKQx5qvc5wNNCI9ySOWpgnAKL5Q8Wu4MKjFAwKh+Vu
	 HJAHuO+rOTl6eh8pg4ILsrMaTzv0f7UOddow+RcuMoi0bhNq6E4YuNGbj7EXF+TM9M
	 +tO7yo8sfwEeZ2S7fVLC6voHM8bBrMhZCXqobpvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 20/87] net/mlx5: fs, Fix inverted cap check in tx flow table root disconnect
Date: Wed,  4 Feb 2026 15:40:18 +0100
Message-ID: <20260204143847.638675157@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 2610a3d65691a1301ab10c92ff6ebab0bedf9199 ]

The capability check for reset_root_to_default was inverted, causing
the function to return -EOPNOTSUPP when the capability IS supported,
rather than when it is NOT supported.

Fix the capability check condition.

Fixes: 3c9c34c32bc6 ("net/mlx5: fs, Command to control TX flow table root")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1769503961-124173-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 676005854dad4..c115270936774 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -1166,7 +1166,8 @@ int mlx5_fs_cmd_set_tx_flow_table_root(struct mlx5_core_dev *dev, u32 ft_id, boo
 	u32 out[MLX5_ST_SZ_DW(set_flow_table_root_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(set_flow_table_root_in)] = {};
 
-	if (disconnect && MLX5_CAP_FLOWTABLE_NIC_TX(dev, reset_root_to_default))
+	if (disconnect &&
+	    !MLX5_CAP_FLOWTABLE_NIC_TX(dev, reset_root_to_default))
 		return -EOPNOTSUPP;
 
 	MLX5_SET(set_flow_table_root_in, in, opcode,
-- 
2.51.0



