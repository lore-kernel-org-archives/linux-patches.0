Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A48381B1;
	Tue,  3 Dec 2024 15:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241372; cv=none; b=FWlKNl6V3F4Msx/fvm6lahlKL/DRP2t44/1bkkcmwQGGXbhrgiZS5lqx+f2mT3kpGz0q2TvxE3vrfLs1hjcU2UMAFszTS2/5gGr/mIFH5ZIwbEgSNAk6mK/8XGnPNxn7pZFuBt71EXWrrZqIcMTwSP6I9qdfevyepEcH8tQL7ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241372; c=relaxed/simple;
	bh=gBQDiQVHs0w7N4iCuPeWs5knZG7qUTQ4VycGtLXoBKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1T/Rt5tDGHuKdfN9KCTFukHQjxNVRs10A1ebFwl65yyKse74hLS9HRvSMyphgN9fPlGI6eygHOqzb/0GUAp5QJnqn+c3zoTB1bZB88D3LONTV08zmNC5vu5Ln5QUQnaQVOJ4fUDEQaimqWyicLncVkJOYo5NKrtigrefix9omM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcP/mjoC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcP/mjoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E243DC4CECF;
	Tue,  3 Dec 2024 15:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241372;
	bh=gBQDiQVHs0w7N4iCuPeWs5knZG7qUTQ4VycGtLXoBKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcP/mjoCFWe8/nowtnXDNDkbFRWHbl9EbvZR/1q133zPOCgyQXnao1h51FRiguiof
	 Qv8AwSFD46RUaZKLmXEpRDngsVGDytfKFixWOrtxGK6EUHAo+pRIV+9UM/RM1z7eXX
	 9YwuhYuuBlpq3bP/uTjQHQ2s6bo/XoU+LTYeJd9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 400/826] RDMA/mlx5: Call dev_put() after the blocking notifier
Date: Tue,  3 Dec 2024 15:42:07 +0100
Message-ID: <20241203144759.365282965@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chiara Meiohas <cmeiohas@nvidia.com>

[ Upstream commit 6d9c7b272966f13ebbf39687620f395d97f4d15d ]

Move dev_put() call to occur directly after the blocking
notifier, instead of within the event handler.

Fixes: 8d159eb2117b ("RDMA/mlx5: Use IB set_netdev and get_netdev functions")
Signed-off-by: Chiara Meiohas <cmeiohas@nvidia.com>
Link: https://patch.msgid.link/342ff94b3dcbb07da1c7dab862a73933d604b717.1730381292.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c                 | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4999239c8f413..32e57cc343361 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3234,7 +3234,6 @@ static int lag_event(struct notifier_block *nb, unsigned long event, void *data)
 			}
 			err = ib_device_set_netdev(&dev->ib_dev, ndev,
 						   portnum + 1);
-			dev_put(ndev);
 			if (err)
 				return err;
 			/* Rescan gids after new netdev assignment */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 8577db3308cc5..d661267d98ffc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -516,6 +516,7 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 		blocking_notifier_call_chain(&dev0->priv.lag_nh,
 					     MLX5_DRIVER_EVENT_ACTIVE_BACKUP_LAG_CHANGE_LOWERSTATE,
 					     ndev);
+		dev_put(ndev);
 	}
 }
 
-- 
2.43.0



