Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35651157053;
	Mon, 29 Jan 2024 17:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548150; cv=none; b=SL/A3yciLqtkddQ2dlqYaucYRip0fYANQIjbQ4dS4Er8JFb+K5WJICq6BxN46jtRHDOiMLtwyPOX84ocbh3FcYxpAjD+Y6/s6AQTfwGptHHIMdm5Awek05gr27HWdg63Lj/GYigshqiIrizaJc5O2WirkY6LBpgYof+NgVeLPk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548150; c=relaxed/simple;
	bh=4uaMkEWHMUUrSc5rZsdn5XaX3GFSFiXUdWYO4g7kijU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaCrVFmGsFWJ8GyFKwC9BnY616wuHk4BUM+lFLyBfnc4GFSADEgfwY97U6uWs1sBwI5yc2xpDrNpT4q7iib+9YiyD4BJG3Pdqti+uKq9aBjsGZTPLy2B9fQdDPTxPL0UmXcFJ6J2FqlCDPTwETPTLgtL9+QFQUt4F1SCA+Nbl/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lK6ODHcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lK6ODHcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35A8C433F1;
	Mon, 29 Jan 2024 17:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548150;
	bh=4uaMkEWHMUUrSc5rZsdn5XaX3GFSFiXUdWYO4g7kijU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lK6ODHcmLTiXD+ZJW2dodrCOM544325q+Jnw8zYpNYSYEUxWaeFBG7Dw43d0sAuTx
	 TZRPv5RtG6g7N0fydeDR0WpJcsynkmoHdKjHsIOsuVfnBQcSURo45F7N+OBBLBLu1z
	 telU9pFfxUYSxbK5tFaTE2pPMIeqXS1FfuWHvWqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 187/346] net/mlx5e: Fix inconsistent hairpin RQT sizes
Date: Mon, 29 Jan 2024 09:03:38 -0800
Message-ID: <20240129170021.896819207@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit c20767fd45e82d64352db82d4fc8d281a43e4783 ]

The processing of traffic in hairpin queues occurs in HW/FW and does not
involve the cpus, hence the upper bound on max num channels does not
apply to them.  Using this bound for the hairpin RQT max_table_size is
wrong.  It could be too small, and cause the error below [1].  As the
RQT size provided on init does not get modified later, use the same
value for both actual and max table sizes.

[1]
mlx5_core 0000:08:00.1: mlx5_cmd_out_err:805:(pid 1200): CREATE_RQT(0x916) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x538faf), err(-22)

Fixes: 74a8dadac17e ("net/mlx5e: Preparations for supporting larger number of channels")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 96af9e2ab1d8..b61d82f08e65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -761,7 +761,7 @@ static int mlx5e_hairpin_create_indirect_rqt(struct mlx5e_hairpin *hp)
 
 	err = mlx5e_rss_params_indir_init(&indir, mdev,
 					  mlx5e_rqt_size(mdev, hp->num_channels),
-					  mlx5e_rqt_size(mdev, priv->max_nch));
+					  mlx5e_rqt_size(mdev, hp->num_channels));
 	if (err)
 		return err;
 
-- 
2.43.0



