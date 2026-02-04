Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5171D21FF4C;
	Wed,  4 Feb 2026 15:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218977; cv=none; b=gSNKhxFi2TcbBYlZ66wDY06kgzufY7aQ/2pqKhJGywHLw02Htk6xI9ouLzpYblbz1B4Jm8xgR6phsXocW8c+8QLtwdtHNpVps00syAnXH7qxhy1xheKP7PDWz1wLRxabXcZsTb2vdkEOdlr1aBCunyBo3Z0MQWpm5M3GIEcCw+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218977; c=relaxed/simple;
	bh=gbTgvC2hGwFHkztrYQQaw1jqGzun+kDVol23iNcsYtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqnsTf8bsIm4ujkkhN95WNpx1EBXdEbkEpzTIAiizTnUrUh6r3R8HNeDLDvKVCkHDV2nZG5BoNWXi3sXVqDCBBdDtpZJYhGEMTm3W7qBuGaPiKwJh/d9XTF1/5uvTHSQgw8i32f4mBQLR7JD43bCgD1groN1c4ginIKeJDVZpnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzoTzzPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzoTzzPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50BBC116C6;
	Wed,  4 Feb 2026 15:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218977;
	bh=gbTgvC2hGwFHkztrYQQaw1jqGzun+kDVol23iNcsYtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzoTzzPAFglF/cJmFGG25LVGo9pUFCeWPjubVYCoKTGImwG0ynDMLwclGMXytPbWp
	 vc1UFbTlsj6o1tExv8OHwWJcjo97yok33r+IlUXY6qwr2exyvZ0w+qallMIp/ymRJ+
	 2RLlXUDMXYpWdWqCVIMd3vqoPQAnuOYc888UuDcA=
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
Subject: [PATCH 6.18 031/122] net/mlx5: fs, Fix inverted cap check in tx flow table root disconnect
Date: Wed,  4 Feb 2026 15:40:13 +0100
Message-ID: <20260204143852.982469683@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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
index 1af76da8b1320..b79544134e2a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -1167,7 +1167,8 @@ int mlx5_fs_cmd_set_tx_flow_table_root(struct mlx5_core_dev *dev, u32 ft_id, boo
 	u32 out[MLX5_ST_SZ_DW(set_flow_table_root_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(set_flow_table_root_in)] = {};
 
-	if (disconnect && MLX5_CAP_FLOWTABLE_NIC_TX(dev, reset_root_to_default))
+	if (disconnect &&
+	    !MLX5_CAP_FLOWTABLE_NIC_TX(dev, reset_root_to_default))
 		return -EOPNOTSUPP;
 
 	MLX5_SET(set_flow_table_root_in, in, opcode,
-- 
2.51.0



