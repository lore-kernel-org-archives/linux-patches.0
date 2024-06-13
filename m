Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B611459FA;
	Thu, 13 Jun 2024 12:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281422; cv=none; b=VA8J1Hp0+kAGgNoDNrUQ72agUjpGmHhL2aOttCFoJQZquzDpfC8kv8N3lgz267C86CLJWwFzruCYhCCV5B0MQm8Hor7Lxpxg5wKrpViY5Gf+/dV4vQ3zQ80uyMYU68SSOXwvLNjM8SmVAXdJ4E36huFL7fsfBojEhAB5yOXcoAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281422; c=relaxed/simple;
	bh=RIQmxofCHUiP47wzciRNmIsignoC6r77WO1nniHEGaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/qsFhkEn+ormkyl0EYEAQLyz10zsFTDzNygLJ4K0CXCS1srBVfPSHm6uhKF8KA5T8c/0SE6g9Dj6PHVJo00bEt2xlPFJuX7jXy3JXLYz+dDtt7omkqOagdP37nGtbY/JBdSE27BYY7XvkOwMWUO0UHP0MlEJb5zdZeHNLe3nYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mB1fSAKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mB1fSAKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95378C2BBFC;
	Thu, 13 Jun 2024 12:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281422;
	bh=RIQmxofCHUiP47wzciRNmIsignoC6r77WO1nniHEGaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mB1fSAKmOE7KuQY4zB9rX/cZbskWxDlfv3iytvPw4iKNJs0HmyTJzC/PnQQJMAjSI
	 dvvlIVGeyz/qW0IDFTJvjvMylTGHpf9tRZrgpnXNyQgNqqXQcGItGryfGAtfD6BRMu
	 q19PWUGoTNIb6UQ2oVquezr7WTqAg7qOKlJxdaHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/317] net/mlx5e: Use rx_missed_errors instead of rx_dropped for reporting buffer exhaustion
Date: Thu, 13 Jun 2024 13:34:27 +0200
Message-ID: <20240613113257.183536370@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 5c74195d5dd977e97556e6fa76909b831c241230 ]

Previously, the driver incorrectly used rx_dropped to report device
buffer exhaustion.

According to the documentation, rx_dropped should not be used to count
packets dropped due to buffer exhaustion, which is the purpose of
rx_missed_errors.

Use rx_missed_errors as intended for counting packets dropped due to
buffer exhaustion.

Fixes: 269e6b3af3bf ("net/mlx5e: Report additional error statistics in get stats ndo")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5673a4113253b..f1834853872da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3695,7 +3695,7 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		mlx5e_fold_sw_stats64(priv, stats);
 	}
 
-	stats->rx_dropped = priv->stats.qcnt.rx_out_of_buffer;
+	stats->rx_missed_errors = priv->stats.qcnt.rx_out_of_buffer;
 
 	stats->rx_length_errors =
 		PPORT_802_3_GET(pstats, a_in_range_length_errors) +
-- 
2.43.0



